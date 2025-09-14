defmodule RodeoWeb.MeetLive.Index do
  use RodeoWeb, :live_view

  alias Rodeo.Meets

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Meets
        <:actions>
          <.button variant="primary" navigate={~p"/meets/new"}>
            <.icon name="hero-plus" /> New Meet
          </.button>
        </:actions>
      </.header>

      <.table
        id="meets"
        rows={@streams.meets}
        row_click={fn {_id, meet} -> JS.navigate(~p"/meets/#{meet}") end}
      >
        <:col :let={{_id, meet}} label="Name">{meet.name}</:col>
        <:col :let={{_id, meet}} label="Date">{meet.date}</:col>
        <:col :let={{_id, meet}} label="Location">{meet.location}</:col>
        <:action :let={{_id, meet}}>
          <div class="sr-only">
            <.link navigate={~p"/meets/#{meet}"}>Show</.link>
          </div>
          <.link navigate={~p"/meets/#{meet}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, meet}}>
          <.link
            phx-click={JS.push("delete", value: %{id: meet.id}) |> hide("##{id}")}
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
    if connected?(socket) do
      Meets.subscribe_meets(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Meets")
     |> stream(:meets, list_meets(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    meet = Meets.get_meet!(socket.assigns.current_scope, id)
    {:ok, _} = Meets.delete_meet(socket.assigns.current_scope, meet)

    {:noreply, stream_delete(socket, :meets, meet)}
  end

  @impl true
  def handle_info({type, %Rodeo.Meets.Meet{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :meets, list_meets(socket.assigns.current_scope), reset: true)}
  end

  defp list_meets(current_scope) do
    Meets.list_meets(current_scope)
  end
end
