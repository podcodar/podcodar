defmodule PodcodarWeb.UserLive.ProfileTest do
  use PodcodarWeb.ConnCase

  import Phoenix.LiveViewTest
  import Podcodar.AccountsFixtures
  use Gettext, backend: PodcodarWeb.Gettext

  setup %{conn: conn} do
    %{conn: Phoenix.ConnTest.init_test_session(conn, %{"locale" => "en"})}
  end

  describe "User profile page" do
    test "renders profile for existing user", %{conn: conn} do
      user = user_fixture(%{username: "johndoe", name: "John Doe"})

      {:ok, _lv, html} = live(conn, ~p"/@johndoe")

      assert html =~ "@johndoe"
      assert html =~ "John Doe"
      assert html =~ gettext("profile_info")
    end

    test "shows user not found for non-existent user", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/@nonexistent")

      assert html =~ gettext("user_not_found")
      assert html =~ gettext("user_not_found_message")
    end

    test "shows edit profile button for own profile", %{conn: conn} do
      user = user_fixture(%{username: "johndoe"})

      {:ok, _lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/@johndoe")

      assert html =~ gettext("edit_profile")
    end

    test "does not show edit profile button for other users", %{conn: conn} do
      user1 = user_fixture(%{username: "johndoe"})
      user2 = user_fixture(%{username: "janedoe"})

      {:ok, _lv, html} =
        conn
        |> log_in_user(user1)
        |> live(~p"/@janedoe")

      refute html =~ gettext("edit_profile")
    end

    test "shows email only for own profile", %{conn: conn} do
      user = user_fixture(%{username: "johndoe", email: "john@example.com"})

      # Own profile - should show email
      {:ok, _lv, own_html} =
        conn
        |> log_in_user(user)
        |> live(~p"/@johndoe")

      assert own_html =~ "john@example.com"

      # Other user viewing - should not show email
      other_user = user_fixture(%{username: "janedoe"})

      {:ok, _lv, other_html} =
        conn
        |> log_in_user(other_user)
        |> live(~p"/@johndoe")

      refute other_html =~ "john@example.com"
    end

    test "clicking username in navbar navigates to profile", %{conn: conn} do
      user = user_fixture(%{username: "johndoe"})

      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/")

      {:ok, _profile_lv, profile_html} =
        lv
        |> element("a[href='/@johndoe']")
        |> render_click()
        |> follow_redirect(conn, ~p"/@johndoe")

      assert profile_html =~ "@johndoe"
      assert profile_html =~ gettext("profile_info")
    end
  end
end
