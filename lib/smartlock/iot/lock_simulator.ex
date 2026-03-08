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
      update_heartbeat(lock)
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
    # 30% chance of state change
    if !recently_commanded? and :rand.uniform() < 0.3 do
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