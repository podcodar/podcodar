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
        |> render_change(user: %{"email" => "with spaces"})

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
          user: %{"email" => user.email}
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
          user: valid_user_attributes(username: user.username)
        )
        |> render_submit()

      assert result =~ gettext("has already been taken")
    end

    test "renders errors for invalid username format", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> form("#registration_form",
          user: valid_user_attributes(username: "Invalid_User")
        )
        |> render_submit()

      assert result =~
               gettext("must contain only lowercase letters, numbers, underscores and hyphens")
    end

    test "renders errors for username too short", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> form("#registration_form",
          user: valid_user_attributes(username: "ab")
        )
        |> render_submit()

      assert result =~ "should be at least 3 character(s)"
    end

    test "renders errors for username too long", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      long_username = String.duplicate("a", 31)

      result =
        lv
        |> form("#registration_form",
          user: valid_user_attributes(username: long_username)
        )
        |> render_submit()

      assert result =~ "should be at most 30 character(s)"
    end

    test "renders errors for name too short", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> form("#registration_form",
          user: valid_user_attributes(name: "A")
        )
        |> render_submit()

      assert result =~ "should be at least 2 character(s)"
    end

    test "renders errors for name too long", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      long_name = String.duplicate("a", 161)

      result =
        lv
        |> form("#registration_form",
          user: valid_user_attributes(name: long_name)
        )
        |> render_submit()

      assert result =~ "should be at most 160 character(s)"
    end

    test "registers user with name, username, and email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      attrs =
        valid_user_attributes(
          email: "newuser@example.com",
          name: "John Doe",
          username: "johndoe123"
        )

      form = form(lv, "#registration_form", user: attrs)

      {:ok, _lv, html} =
        render_submit(form)
        |> follow_redirect(conn, ~p"/users/log-in")

      assert html =~ gettext("email_sent_confirmation", email: "newuser@example.com")

      # Verify user was created with all fields
      user = Podcodar.Accounts.get_user_by_email("newuser@example.com")
      assert user.name == "John Doe"
      assert user.username == "johndoe123"
      assert user.email == "newuser@example.com"
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
