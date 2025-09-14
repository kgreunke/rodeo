defmodule Rodeo.TenantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rodeo.Tenants` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name"
      })

    {:ok, organization} = Rodeo.Tenants.create_organization(scope, attrs)
    organization
  end
end
