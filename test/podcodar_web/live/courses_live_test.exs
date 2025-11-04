defmodule PodcodarWeb.CoursesLiveTest do
  use PodcodarWeb.ConnCase

  import Phoenix.LiveViewTest
  use Gettext, backend: PodcodarWeb.Gettext

  test "renders the courses page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/courses")

    assert has_element?(view, "h1", gettext("available_courses"))
  end

  test "renders courses with click-to-play thumbnails", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/courses")

    # Should show play button overlay initially, not iframe
    assert has_element?(view, "[phx-click=play_video]")
    refute has_element?(view, "iframe")

    # Click to play should show iframe
    view
    |> element("[phx-click=play_video]")
    |> render_click()

    assert has_element?(view, "iframe")
  end

  test "iframe appears after clicking play", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/courses")

    # Click to play to show iframe
    view
    |> element("[phx-click=play_video]")
    |> render_click()

    # Should have iframe with lazy loading
    html = view |> element("iframe") |> render()
    assert html =~ "loading"
  end

  test "renders courses with search query", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/courses?query=elixir")

    assert has_element?(view, "h1", gettext("available_courses"))
  end
end
