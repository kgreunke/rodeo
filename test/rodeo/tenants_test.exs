defmodule Rodeo.TenantsTest do
  use Rodeo.DataCase

  alias Rodeo.Tenants

  describe "organizations" do
    alias Rodeo.Tenants.Organization

    import Rodeo.AccountsFixtures, only: [user_scope_fixture: 0]
    import Rodeo.TenantsFixtures

    @invalid_attrs %{name: nil}

    test "list_organizations/1 returns all scoped organizations" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)
      other_organization = organization_fixture(other_scope)
      assert Tenants.list_organizations(scope) == [organization]
      assert Tenants.list_organizations(other_scope) == [other_organization]
    end

    test "get_organization!/2 returns the organization with given id" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      other_scope = user_scope_fixture()
      assert Tenants.get_organization!(scope, organization.id) == organization
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_organization!(other_scope, organization.id) end
    end

    test "create_organization/2 with valid data creates a organization" do
      valid_attrs = %{name: "some name"}
      scope = user_scope_fixture()

      assert {:ok, %Organization{} = organization} = Tenants.create_organization(scope, valid_attrs)
      assert organization.name == "some name"
      assert organization.user_id == scope.user.id
    end

    test "create_organization/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.create_organization(scope, @invalid_attrs)
    end

    test "update_organization/3 with valid data updates the organization" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Organization{} = organization} = Tenants.update_organization(scope, organization, update_attrs)
      assert organization.name == "some updated name"
    end

    test "update_organization/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)

      assert_raise MatchError, fn ->
        Tenants.update_organization(other_scope, organization, %{})
      end
    end

    test "update_organization/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Tenants.update_organization(scope, organization, @invalid_attrs)
      assert organization == Tenants.get_organization!(scope, organization.id)
    end

    test "delete_organization/2 deletes the organization" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert {:ok, %Organization{}} = Tenants.delete_organization(scope, organization)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_organization!(scope, organization.id) end
    end

    test "delete_organization/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert_raise MatchError, fn -> Tenants.delete_organization(other_scope, organization) end
    end

    test "change_organization/2 returns a organization changeset" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert %Ecto.Changeset{} = Tenants.change_organization(scope, organization)
    end
  end
end
