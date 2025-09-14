defmodule RodeoWeb.MeetLiveTest do
  use RodeoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rodeo.MeetsFixtures

  @create_attrs %{name: "some name", date: "2025-09-13T03:41:00", location: "some location"}
  @update_attrs %{name: "some updated name", date: "2025-09-14T03:41:00", location: "some updated location"}
  @invalid_attrs %{name: nil, date: nil, location: nil}

  setup :register_and_log_in_user

  defp create_meet(%{scope: scope}) do
    meet = meet_fixture(scope)

    %{meet: meet}
  end

  describe "Index" do
    setup [:create_meet]

    test "lists all meets", %{conn: conn, meet: meet} do
      {:ok, _index_live, html} = live(conn, ~p"/meets")

      assert html =~ "Listing Meets"
      assert html =~ meet.name
    end

    test "saves new meet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/meets")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Meet")
               |> render_click()
               |> follow_redirect(conn, ~p"/meets/new")

      assert render(form_live) =~ "New Meet"

      assert form_live
             |> form("#meet-form", meet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#meet-form", meet: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/meets")

      html = render(index_live)
      assert html =~ "Meet created successfully"
      assert html =~ "some name"
    end

    test "updates meet in listing", %{conn: conn, meet: meet} do
      {:ok, index_live, _html} = live(conn, ~p"/meets")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#meets-#{meet.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/meets/#{meet}/edit")

      assert render(form_live) =~ "Edit Meet"

      assert form_live
             |> form("#meet-form", meet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#meet-form", meet: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/meets")

      html = render(index_live)
      assert html =~ "Meet updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes meet in listing", %{conn: conn, meet: meet} do
      {:ok, index_live, _html} = live(conn, ~p"/meets")

      assert index_live |> element("#meets-#{meet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#meets-#{meet.id}")
    end
  end

  describe "Show" do
    setup [:create_meet]

    test "displays meet", %{conn: conn, meet: meet} do
      {:ok, _show_live, html} = live(conn, ~p"/meets/#{meet}")

      assert html =~ "Show Meet"
      assert html =~ meet.name
    end

    test "updates meet and returns to show", %{conn: conn, meet: meet} do
      {:ok, show_live, _html} = live(conn, ~p"/meets/#{meet}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/meets/#{meet}/edit?return_to=show")

      assert render(form_live) =~ "Edit Meet"

      assert form_live
             |> form("#meet-form", meet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#meet-form", meet: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/meets/#{meet}")

      html = render(show_live)
      assert html =~ "Meet updated successfully"
      assert html =~ "some updated name"
    end
  end
end
