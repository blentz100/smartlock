defmodule SmartlockWeb.LockLive.Index do
  use SmartlockWeb, :live_view

   alias Smartlock.Locks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Locks
        <:actions>
          <.button variant="primary" navigate={~p"/locks/new"}>
            <.icon name="hero-plus" /> New Lock
          </.button>
        </:actions>
      </.header>

      <.table
        id="locks"
        rows={@streams.locks}
        row_click={fn {_id, lock} -> JS.navigate(~p"/locks/#{lock}") end}
      >
        <:col :let={{_id, lock}} label="Name">{lock.name}</:col>
        <:col :let={{_id, lock}} label="Status">
          <span class={[
          "px-2 py-1 rounded text-white text-sm",
          lock.status == "locked" && "bg-red-500",
          lock.status == "unlocked" && "bg-green-500"
          ]}>
          <%= lock.status %>
          </span>
        </:col>
        <:action :let={{_id, lock}}>
    <.link navigate={~p"/locks/#{lock}/edit"}>Edit</.link>
    </:action>

    <:action :let={{_id, lock}}>
    <.link phx-click="toggle" phx-value-id={lock.id}>
      <%= if lock.status == "locked", do: "Unlock", else: "Lock" %>
    </.link>
    </:action>
        <:action :let={{id, lock}}>
          <.link
            phx-click={JS.push("delete", value: %{id: lock.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Locks")
     |> stream(:locks, list_locks())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    lock = Locks.get_lock!(id)
    {:ok, _} = Locks.delete_lock(lock)

    {:noreply, stream_delete(socket, :locks, lock)}
  end
  def handle_event("toggle", %{"id" => id}, socket) do
    lock = Smartlock.Locks.get_lock!(id)

    {:ok, updated_lock} =
      case lock.status do
        "locked" -> Smartlock.Locks.unlock_lock(lock)
        "unlocked" -> Smartlock.Locks.lock_lock(lock)
      end

    {:noreply, stream_insert(socket, :locks, updated_lock)}
  end

  defp list_locks() do
    Locks.list_locks()
  end
end
