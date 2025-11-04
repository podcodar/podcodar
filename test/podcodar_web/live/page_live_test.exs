defmodule PodcodarWeb.PageLiveTest do
  use PodcodarWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Phoenix.HTML
  use Gettext, backend: PodcodarWeb.Gettext

  setup %{conn: conn} do
    %{conn: Phoenix.ConnTest.init_test_session(conn, %{"locale" => "en"})}
  end

  test "home page shows main content", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ gettext("accessible_tech_education")
    assert html =~ gettext("our_mission")
    assert html =~ gettext("platform_statistics")
  end

  test "search form validates and shows errors", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # empty submit shows required error
    html =
      view
      |> element("#home-search-form")
      |> render_submit(%{"search_query" => %{"query" => ""}})

    assert html =~
             gettext("can't be blank")
             |> html_escape()
             |> safe_to_string()

    # too short on change shows length error
    html =
      view
      |> element("#home-search-form")
      |> render_change(%{"search_query" => %{"query" => "a"}})

    assert html =~ gettext("should be at least")

    # valid input clears errors
    html =
      view
      |> element("#home-search-form")
      |> render_change(%{"search_query" => %{"query" => "elixir"}})

    assert html =~ "elixir"

    html =
      view
      |> element("#home-search-form")
      |> render_change(%{"search_query" => %{"query" => ""}})

    assert html =~
             gettext("can't be blank")
             |> html_escape()
             |> safe_to_string()
  end

  test "home page shows corrected copy", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    # Check corrected copy in translations
    assert html =~ gettext("accessible_tech_education")
    assert html =~ gettext("mission_paragraph_1")

    assert html =~ gettext("mission_point_1")
  end

  test "external links have security attributes", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    # Check links have security attributes
    assert html =~ "noopener"
    assert html =~ "_blank"
  end
end
