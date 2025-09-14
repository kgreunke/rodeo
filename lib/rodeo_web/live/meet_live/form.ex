defmodule RodeoWeb.MeetLive.Form do
  use RodeoWeb, :live_view

  alias Rodeo.Meets
  alias Rodeo.Meets.Meet

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage meet records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="meet-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:date]} type="datetime-local" label="Date" />
        <.input field={@form[:location]} type="text" label="Location" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Meet</.button>
          <.button navigate={return_path(@current_scope, @return_to, @meet)}>Cancel</.button>
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
    meet = Meets.get_meet!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Meet")
    |> assign(:meet, meet)
    |> assign(:form, to_form(Meets.change_meet(socket.assigns.current_scope, meet)))
  end

  defp apply_action(socket, :new, _params) do
    meet = %Meet{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Meet")
    |> assign(:meet, meet)
    |> assign(:form, to_form(Meets.change_meet(socket.assigns.current_scope, meet)))
  end

  @impl true
  def handle_event("validate", %{"meet" => meet_params}, socket) do
    changeset = Meets.change_meet(socket.assigns.current_scope, socket.assigns.meet, meet_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"meet" => meet_params}, socket) do
    save_meet(socket, socket.assigns.live_action, meet_params)
  end

  defp save_meet(socket, :edit, meet_params) do
    case Meets.update_meet(socket.assigns.current_scope, socket.assigns.meet, meet_params) do
      {:ok, meet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Meet updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, meet)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_meet(socket, :new, meet_params) do
    case Meets.create_meet(socket.assigns.current_scope, meet_params) do
      {:ok, meet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Meet created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, meet)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _meet), do: ~p"/meets"
  defp return_path(_scope, "show", meet), do: ~p"/meets/#{meet}"
end
