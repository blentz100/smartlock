defmodule SmartlockWeb.LockLiveTest do
  use SmartlockWeb.ConnCase

  import Phoenix.LiveViewTest
  import Smartlock.LocksFixtures

  @create_attrs %{name: "some name", status: "some status"}
  @update_attrs %{name: "some updated name", status: "some updated status"}
  @invalid_attrs %{name: nil, status: nil}
  defp create_lock(_) do
    lock = lock_fixture()

    %{lock: lock}
  end

  describe "Index" do
    setup [:create_lock]

    test "lists all locks", %{conn: conn, lock: lock} do
      {:ok, _index_live, html} = live(conn, ~p"/locks")

      assert html =~ "Listing Locks"
      assert html =~ lock.name
    end

    test "saves new lock", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/locks")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Lock")
               |> render_click()
               |> follow_redirect(conn, ~p"/locks/new")

      assert render(form_live) =~ "New Lock"

      assert form_live
             |> form("#lock-form", lock: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#lock-form", lock: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/locks")

      html = render(index_live)
      assert html =~ "Lock created successfully"
      assert html =~ "some name"
    end

    test "updates lock in listing", %{conn: conn, lock: lock} do
      {:ok, index_live, _html} = live(conn, ~p"/locks")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#locks-#{lock.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/locks/#{lock}/edit")

      assert render(form_live) =~ "Edit Lock"

      assert form_live
             |> form("#lock-form", lock: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#lock-form", lock: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/locks")

      html = render(index_live)
      assert html =~ "Lock updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes lock in listing", %{conn: conn, lock: lock} do
      {:ok, index_live, _html} = live(conn, ~p"/locks")

      assert index_live |> element("#locks-#{lock.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#locks-#{lock.id}")
    end
  end

  describe "Show" do
    setup [:create_lock]

    test "displays lock", %{conn: conn, lock: lock} do
      {:ok, _show_live, html} = live(conn, ~p"/locks/#{lock}")

      assert html =~ "Show Lock"
      assert html =~ lock.name
    end

    test "updates lock and returns to show", %{conn: conn, lock: lock} do
      {:ok, show_live, _html} = live(conn, ~p"/locks/#{lock}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/locks/#{lock}/edit?return_to=show")

      assert render(form_live) =~ "Edit Lock"

      assert form_live
             |> form("#lock-form", lock: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#lock-form", lock: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/locks/#{lock}")

      html = render(show_live)
      assert html =~ "Lock updated successfully"
      assert html =~ "some updated name"
    end
  end
end
