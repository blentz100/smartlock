defmodule Smartlock.IoT.LockSimulator do
  use GenServer

  alias Smartlock.Locks
  alias SmartlockWeb.Endpoint

  @interval 10_000 # 10 seconds for demo

  # Public API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Init timer loop
  def init(state) do
    schedule_tick()
    {:ok, state}
  end

  def handle_info(:tick, state) do
    simulate_event()

    schedule_tick()
    {:noreply, state}
  end

  defp schedule_tick do
    jitter = Enum.random(-2000..2000)
    delay = max(5000, @interval + jitter)

    Process.send_after(self(), :tick, delay)
  end

  defp simulate_event do
    locks = Locks.list_locks()

    Enum.each(locks, fn lock ->
      maybe_toggle(lock)
      # 80% chance to send heartbeat
      if :rand.uniform() < 0.8 do
        update_heartbeat(lock)
      else
        # simulate missed heartbeat
        IO.puts("Skipping heartbeat for #{lock.id}")
      end
    end)
  end

  defp update_heartbeat(lock) do
    # Simulate natural device reporting drift
    offset_seconds = Enum.random(0..30)

    timestamp =
      DateTime.utc_now()
      |> DateTime.add(-offset_seconds, :second)

    {:ok, updated} =
      Locks.update_lock(lock, %{
        last_seen_at: timestamp
      })

    Endpoint.broadcast("locks", "updated", updated)
  end

  defp maybe_toggle(lock) do
    recently_commanded? =
      case lock.last_command_at do
        nil -> false
        ts -> DateTime.diff(DateTime.utc_now(), ts) < 15
      end
    # 10% chance of lock state change
    if !recently_commanded? and :rand.uniform() < 0.1 do
      new_status =
        case lock.status do
          "locked" -> "unlocked"
          _ -> "locked"
        end

      {:ok, updated} =
        Locks.update_lock(lock, %{status: new_status})

      Endpoint.broadcast("locks", "updated", updated)
    end
  end
end