defmodule SmartlockWeb.LockLive.Show do
  use SmartlockWeb, :live_view

  alias Smartlock.Locks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Lock {@lock.id}
        <:subtitle>This is a lock record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/locks"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/locks/#{@lock}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit lock
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@lock.name}</:item>
        <:item title="Status">{@lock.status}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Lock")
     |> assign(:lock, Locks.get_lock!(id))}
  end
end
