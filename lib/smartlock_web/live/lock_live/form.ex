defmodule SmartlockWeb.LockLive.Form do
  use SmartlockWeb, :live_view

  alias Smartlock.Locks
  alias Smartlock.Locks.Lock

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage lock records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="lock-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:status]} type="text" label="Status" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Lock</.button>
          <.button navigate={return_path(@return_to, @lock)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    lock = Locks.get_lock!(id)

    socket
    |> assign(:page_title, "Edit Lock")
    |> assign(:lock, lock)
    |> assign(:form, to_form(Locks.change_lock(lock)))
  end

  defp apply_action(socket, :new, _params) do
    lock = %Lock{}

    socket
    |> assign(:page_title, "New Lock")
    |> assign(:lock, lock)
    |> assign(:form, to_form(Locks.change_lock(lock)))
  end

  @impl true
  def handle_event("validate", %{"lock" => lock_params}, socket) do
    changeset = Locks.change_lock(socket.assigns.lock, lock_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"lock" => lock_params}, socket) do
    save_lock(socket, socket.assigns.live_action, lock_params)
  end

  defp save_lock(socket, :edit, lock_params) do
    case Locks.update_lock(socket.assigns.lock, lock_params) do
      {:ok, lock} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lock updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, lock))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_lock(socket, :new, lock_params) do
    case Locks.create_lock(lock_params) do
      {:ok, lock} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lock created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, lock))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _lock), do: ~p"/locks"
  defp return_path("show", lock), do: ~p"/locks/#{lock}"
end
