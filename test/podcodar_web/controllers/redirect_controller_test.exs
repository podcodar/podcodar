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
end
