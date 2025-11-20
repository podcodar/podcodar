defmodule PodcodarWeb.UserProfileLiveTest do
  use PodcodarWeb.ConnCase
  import Phoenix.LiveViewTest
  import Podcodar.AccountsFixtures

  describe "User Profile Page" do
    test "renders user profile page", %{conn: conn} do
      user = user_fixture(%{name: "John Doe", username: "johndoe"})

      {:ok, _lv, html} = live(conn, ~p"/@#{user.username}")

      assert html =~ user.name
      assert html =~ "@" <> user.username
      assert html =~ user.email
    end

    test "renders logo as avatar", %{conn: conn} do
      user = user_fixture()

      {:ok, _lv, html} = live(conn, ~p"/@#{user.username}")

      assert html =~ "/images/logo.svg"
    end

    test "redirects to 404 for non-existent user", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/@nonexistentuser")

      assert html =~ "Página não encontrada"
    end
  end
end
