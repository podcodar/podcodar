defmodule PodcodarWeb.RedirectController do
  use PodcodarWeb, :controller

  require Logger

  def discord(conn, _params) do
    discord_url = Application.get_env(:podcodar, :discord_invite_url)
    Logger.info("discord_url: #{discord_url}")
    redirect(conn, external: discord_url)
  end
end
