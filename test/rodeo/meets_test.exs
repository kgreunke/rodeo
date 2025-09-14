defmodule Rodeo.MeetsTest do
  use Rodeo.DataCase

  alias Rodeo.Meets

  describe "meets" do
    alias Rodeo.Meets.Meet

    import Rodeo.AccountsFixtures, only: [user_scope_fixture: 0]
    import Rodeo.MeetsFixtures

    @invalid_attrs %{name: nil, date: nil, location: nil}

    test "list_meets/1 returns all scoped meets" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      meet = meet_fixture(scope)
      other_meet = meet_fixture(other_scope)
      assert Meets.list_meets(scope) == [meet]
      assert Meets.list_meets(other_scope) == [other_meet]
    end

    test "get_meet!/2 returns the meet with given id" do
      scope = user_scope_fixture()
      meet = meet_fixture(scope)
      other_scope = user_scope_fixture()
      assert Meets.get_meet!(scope, meet.id) == meet
      assert_raise Ecto.NoResultsError, fn -> Meets.get_meet!(other_scope, meet.id) end
    end

    test "create_meet/2 with valid data creates a meet" do
      valid_attrs = %{name: "some name", date: ~N[2025-09-13 03:41:00], location: "some location"}
      scope = user_scope_fixture()

      assert {:ok, %Meet{} = meet} = Meets.create_meet(scope, valid_attrs)
      assert meet.name == "some name"
      assert meet.date == ~N[2025-09-13 03:41:00]
      assert meet.location == "some location"
      assert meet.user_id == scope.user.id
    end

    test "create_meet/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Meets.create_meet(scope, @invalid_attrs)
    end

    test "update_meet/3 with valid data updates the meet" do
      scope = user_scope_fixture()
      meet = meet_fixture(scope)
      update_attrs = %{name: "some updated name", date: ~N[2025-09-14 03:41:00], location: "some updated location"}

      assert {:ok, %Meet{} = meet} = Meets.update_meet(scope, meet, update_attrs)
      assert meet.name == "some updated name"
      assert meet.date == ~N[2025-09-14 03:41:00]
      assert meet.location == "some updated location"
    end

    test "update_meet/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      meet = meet_fixture(scope)

      assert_raise MatchError, fn ->
        Meets.update_meet(other_scope, meet, %{})
      end
    end

    test "update_meet/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      meet = meet_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Meets.update_meet(scope, meet, @invalid_attrs)
      assert meet == Meets.get_meet!(scope, meet.id)
    end

    test "delete_meet/2 deletes the meet" do
      scope = user_scope_fixture()
      meet = meet_fixture(scope)
      assert {:ok, %Meet{}} = Meets.delete_meet(scope, meet)
      assert_raise Ecto.NoResultsError, fn -> Meets.get_meet!(scope, meet.id) end
    end

    test "delete_meet/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      meet = meet_fixture(scope)
      assert_raise MatchError, fn -> Meets.delete_meet(other_scope, meet) end
    end

    test "change_meet/2 returns a meet changeset" do
      scope = user_scope_fixture()
      meet = meet_fixture(scope)
      assert %Ecto.Changeset{} = Meets.change_meet(scope, meet)
    end
  end
end
