defmodule PodcodarWeb.CoursesLiveTest do
  use PodcodarWeb.ConnCase

  import Phoenix.LiveViewTest
  use Gettext, backend: PodcodarWeb.Gettext

  test "renders the courses page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/courses")

    assert has_element?(view, "h1", gettext("available_courses"))
  end

  test "renders courses with iframes", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/courses")

    # Should show iframe directly
    assert has_element?(view, "iframe")
  end

  test "renders courses with search query", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/courses?query=elixir")

    assert has_element?(view, "h1", gettext("available_courses"))
  end
end
