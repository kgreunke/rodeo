defmodule RodeoWeb.MeetLive.Show do
  use RodeoWeb, :live_view

  alias Rodeo.Meets

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Meet {@meet.id}
        <:subtitle>This is a meet record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/meets"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/meets/#{@meet}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit meet
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@meet.name}</:item>
        <:item title="Date">{@meet.date}</:item>
        <:item title="Location">{@meet.location}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Meets.subscribe_meets(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Meet")
     |> assign(:meet, Meets.get_meet!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Rodeo.Meets.Meet{id: id} = meet},
        %{assigns: %{meet: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :meet, meet)}
  end

  def handle_info(
        {:deleted, %Rodeo.Meets.Meet{id: id}},
        %{assigns: %{meet: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current meet was deleted.")
     |> push_navigate(to: ~p"/meets")}
  end

  def handle_info({type, %Rodeo.Meets.Meet{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
