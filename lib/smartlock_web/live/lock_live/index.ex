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
          <div class="flex justify-start">
          <span class={[
            "inline-flex w-28 justify-center px-2 py-1 rounded-full text-xs font-semibold",
            lock.status == "locked" && "bg-red-100 text-red-700",
            lock.status == "unlocked" && "bg-green-100 text-green-700",
            lock.status == "processing" && "bg-yellow-100 text-yellow-700"
          ]}>
            <%= String.capitalize(lock.status) %>
          </span>
          </div>
        </:col>

      <:col :let={{_id, lock}} label="Action">
         <div class="flex gap-2 justify-start whitespace-nowrap">

          <.link
            phx-click="toggle"
            phx-value-id={lock.id}
            title={if lock.status == "locked", do: "Unlock", else: "Lock"}
            class="text-gray-600 hover:text-blue-600"
          >
            <.icon name={
              if lock.status == "locked",
              do: "hero-lock-closed",
              else: "hero-lock-open"
            } />
          </.link>

          <.link
            navigate={~p"/locks/#{lock}/edit"}
            title="Edit"
            class="text-gray-600 hover:text-blue-600"
          >
            <.icon name="hero-pencil-square" />
          </.link>

          <.link
            phx-click={JS.push("delete", value: %{id: lock.id}) |> hide("##{lock.id}")}
            data-confirm="Are you sure?"
            title="Delete"
            class="text-gray-600 hover:text-red-600"
          >
            <.icon name="hero-trash" />
          </.link>

        </div>
      </:col>
      </.table>
      <div class="flex justify-between mt-4">
        <.button
        phx-click="prev_page"
        disabled={@page <= 1}
        >
        Previous
        </.button>

        <div class="text-sm text-gray-500">
        Page <%= @page %> of <%= @total_pages %>
        </div>

        <.button
        phx-click="next_page"
        disabled={@page >= @total_pages}
        >
        Next
        </.button>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    page = 1
    page_size = 10

    socket =
      socket
      |> assign(:page, page)
      |> assign(:page_size, page_size)
      |> load_locks()
    {:ok,socket}
  end

  defp load_locks(socket) do
    page = socket.assigns.page
    page_size = socket.assigns.page_size

    locks =
      Smartlock.Locks.list_locks_paginated(page, page_size)

    total = Smartlock.Locks.count_locks()

    total_pages =
      if total == 0 do
        1
      else
        div(total + page_size - 1, page_size)
      end

    socket
    |> assign(:total_pages, total_pages)
    |> stream(:locks, locks, reset: true)
  end

  def handle_event("next_page", _, socket) do
    if socket.assigns.page < socket.assigns.total_pages do
      socket =
        update(socket, :page, &(&1 + 1))
        |> load_locks()

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("prev_page", _, socket) do
    socket =
      update(socket, :page, fn page ->
        if page > 1, do: page - 1, else: page
      end)
      |> load_locks()

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    lock = Locks.get_lock!(id)
    {:ok, _} = Locks.delete_lock(lock)

    {:noreply, stream_delete(socket, :locks, lock)}
  end
  def handle_event("toggle", %{"id" => id}, socket) do
    lock = Smartlock.Locks.get_lock!(id)

    # Immediately mark as processing
    {:ok, updated_lock} =
      Locks.update_lock(lock, %{status: "processing"})
    # Simulate device delay
    delay = Enum.random(300..1500)
    Process.send_after(self(), {:complete_toggle, lock.id}, delay)

    {:noreply, stream_insert(socket, :locks, updated_lock)}
  end

  def handle_info({:complete_toggle, id}, socket) do
    lock = Locks.get_lock!(id)

    new_status =
      case lock.status do
          "processing" ->
            if :rand.uniform() > 0.5, do: "locked", else: "unlocked"
          other ->
            other
      end
    {:ok, updated_lock} =
      Locks.update_lock(lock, %{status: new_status})
    {:noreply, stream_insert(socket, :locks, updated_lock)}
  end

  @impl true
  def handle_info(%{event: "updated", payload: lock}, socket) do
    {:noreply, stream_insert(socket, :locks, lock)}
  end
end
