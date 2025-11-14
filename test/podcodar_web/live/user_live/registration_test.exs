defmodule PodcodarWeb.UserLive.RegistrationTest do
  use PodcodarWeb.ConnCase

  import Phoenix.LiveViewTest
  import Podcodar.AccountsFixtures
  use Gettext, backend: PodcodarWeb.Gettext

  setup %{conn: conn} do
    %{conn: Phoenix.ConnTest.init_test_session(conn, %{"locale" => "en"})}
  end

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/register")

      assert html =~ gettext("register_for_an_account")
      assert html =~ gettext("log_in")
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/register")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"email" => "with spaces", "username" => "ab"})

      assert result =~ gettext("register_for_an_account")
      assert result =~ gettext("must have the @ sign and no spaces")
    end
  end

  describe "register user" do
    test "creates account but does not log in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      email = unique_user_email()
      form = form(lv, "#registration_form", user: valid_user_attributes(email: email))

      {:ok, _lv, html} =
        render_submit(form)
        |> follow_redirect(conn, ~p"/users/log-in")

      assert html =~ gettext("email_sent_confirmation", email: email)
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      user = user_fixture(%{email: "test@email.com"})

      result =
        lv
        |> form("#registration_form",
          user: %{"email" => user.email, "username" => "newuser"}
        )
        |> render_submit()

      assert result =~ gettext("has already been taken")
    end

    test "renders errors for duplicated username", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      user = user_fixture(%{username: "testuser"})

      result =
        lv
        |> form("#registration_form",
          user: %{"email" => "new@email.com", "username" => user.username}
        )
        |> render_submit()

      assert result =~ gettext("has already been taken")
    end

    test "renders errors for username too short", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"username" => "ab"})

      assert result =~ gettext("should be at least %{count} character(s)", count: 3)
    end

    test "renders errors for username too long", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"username" => String.duplicate("a", 21)})

      assert result =~ gettext("should be at most %{count} character(s)", count: 20)
    end

    test "renders errors for username with invalid characters", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"username" => "user@name"})

      assert result =~ gettext("can only contain letters, numbers, and underscores")
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      {:ok, _login_live, login_html} =
        lv
        |> element("main a[href='/users/log-in']")
        |> render_click()
        |> follow_redirect(conn, ~p"/users/log-in")

      assert login_html =~ gettext("log_in")
    end
  end
end
