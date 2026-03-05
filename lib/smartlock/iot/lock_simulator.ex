defmodule Smartlock.IoT.LockSimulator do
  use GenServer

  alias Smartlock.Locks
  alias SmartlockWeb.Endpoint

  @interval 3_000 # 3 seconds for demo

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
    Process.send_after(self(), :tick, @interval)
  end

  defp simulate_event do
    locks = Locks.list_locks()

    Enum.each(locks, fn lock ->
      maybe_toggle(lock)
    end)
  end

  defp maybe_toggle(lock) do
    # 30% chance of state change
    if :rand.uniform() < 0.3 do
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