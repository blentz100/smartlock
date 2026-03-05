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
        <:col :let={{_id, lock}} label="Status">{lock.status}</:col>
        <:action :let={{_id, lock}}>
    <.link navigate={~p"/locks/#{lock}/edit"}>Edit</.link>
    </:action>

    <:action :let={{_id, lock}}>
    <.link phx-click="lock" phx-value-id={lock.id}>
    Lock
    </.link>
    </:action>

    <:action :let={{_id, lock}}>
    <.link phx-click="unlock" phx-value-id={lock.id}>
    Unlock
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
  def handle_event("lock", %{"id" => id}, socket) do
    lock = Smartlock.Locks.get_lock!(id)
    {:ok, updated_lock} = Smartlock.Locks.lock_lock(lock)

    {:noreply, stream_insert(socket, :locks, updated_lock)}
  end

  def handle_event("unlock", %{"id" => id}, socket) do
    lock = Smartlock.Locks.get_lock!(id)
    {:ok, updated_lock} = Smartlock.Locks.unlock_lock(lock)

    {:noreply, stream_insert(socket, :locks, updated_lock)}
  end

  defp list_locks() do
    Locks.list_locks()
  end
end
