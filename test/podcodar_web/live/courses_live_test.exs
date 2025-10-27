defmodule PodcodarWeb.CoursesLiveTest do
  use PodcodarWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "CoursesLive" do
    test "renders the courses page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/courses")

      assert has_element?(view, "h1", "Cursos Disponíveis")
    end
  end
end
