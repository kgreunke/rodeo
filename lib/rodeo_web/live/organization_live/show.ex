defmodule RodeoWeb.OrganizationLive.Show do
  use RodeoWeb, :live_view

  alias Rodeo.Tenants

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Organization {@organization.id}
        <:subtitle>This is a organization record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/organizations"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/organizations/#{@organization}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit organization
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@organization.name}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Tenants.subscribe_organizations(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Organization")
     |> assign(:organization, Tenants.get_organization!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Rodeo.Tenants.Organization{id: id} = organization},
        %{assigns: %{organization: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :organization, organization)}
  end

  def handle_info(
        {:deleted, %Rodeo.Tenants.Organization{id: id}},
        %{assigns: %{organization: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current organization was deleted.")
     |> push_navigate(to: ~p"/organizations")}
  end

  def handle_info({type, %Rodeo.Tenants.Organization{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
