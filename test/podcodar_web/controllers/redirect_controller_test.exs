defmodule PodcodarWeb.RedirectControllerTest do
  use PodcodarWeb.ConnCase, async: true

  describe "GET /discord" do
    test "redirects to the Discord invite URL", %{conn: conn} do
      # Set up the environment variable for Discord invite URL
      discord_url = "https://discord.com/invite/test"
      Application.put_env(:podcodar, :discord_invite_url, discord_url)

      # Make a GET request to /discord
      conn = get(conn, "/discord")

      # Assert that there is a redirect to the Discord invite URL
      assert redirected_to(conn) == discord_url
    end
  end

  describe "GET /random" do
    test "redirects to /courses with a random query", %{conn: conn} do
      topics = Podcodar.Courses.suggested_searches()

      # Make a GET request to /random
      conn = get(conn, "/random")

      # Assert that there is a redirect
      assert conn.status == 302

      # Extract the Location header
      location = redirected_to(conn)

      # Assert it starts with /courses?query=
      assert String.starts_with?(location, "/courses?query=")

      # Extract the query value
      query = String.replace(location, "/courses?query=", "")

      # Decode and assert it's one of the topics
      decoded_query = URI.decode_www_form(query)
      assert decoded_query in topics
    end
  end
end
