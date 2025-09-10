defmodule PodcodarWeb.PageLiveTest do
  use PodcodarWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Phoenix.HTML

  test "home page shows main content", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    html = if is_binary(html), do: html, else: IO.iodata_to_binary(html)

    assert html =~ "Free technology education for everyone"
    assert html =~ "Our mission"
    assert html =~ "Platform Statistics"
  end

  test "search form validates and shows errors", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # empty submit shows required error
    html =
      view
      |> element("#home-search-form")
      |> render_submit(%{"search_query" => %{"query" => ""}})

    assert html =~
             "can't be blank"
             |> html_escape()
             |> safe_to_string()

    # too short on change shows length error
    html =
      view
      |> element("#home-search-form")
      |> render_change(%{"search_query" => %{"query" => "a"}})

    assert html =~ "should be at least"

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
             "can't be blank"
             |> html_escape()
             |> safe_to_string()
  end
end
