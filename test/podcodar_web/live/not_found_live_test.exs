defmodule PodcodarWeb.NotFoundLiveTest do
  use PodcodarWeb.ConnCase

  import Phoenix.LiveViewTest
  use Gettext, backend: PodcodarWeb.Gettext

  test "renders 404 page for non-existent routes", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/non-existent-route")

    assert has_element?(view, "h1", gettext("page_not_found"))
    # Check if the link to home exists
    html = render(view)
    assert html =~ gettext("back_to_home")
  end

  test "404 page uses app layout", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/not-found")

    # Should have navbar and footer from app layout
    assert has_element?(view, ".navbar")
    assert has_element?(view, ".footer")
  end
end
