defmodule PodcodarWeb.NotFoundLiveTest do
  use PodcodarWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders 404 page for non-existent routes", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/non-existent-route")

    assert has_element?(view, "h1", "Página não encontrada")
    assert has_element?(view, "[href='/']", "Voltar ao início")
  end

  test "404 page uses app layout", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/not-found")

    # Should have navbar and footer from app layout
    assert has_element?(view, ".navbar")
    assert has_element?(view, ".footer")
  end
end
