defmodule PodcodarWeb.RedirectController do
  use PodcodarWeb, :controller

  require Logger

  def discord(conn, _params) do
    redirect_to_external(conn, :discord_invite_url, "discord")
  end

  def github(conn, _params) do
    redirect_to_external(conn, :github_org_url, "github")
  end

  def sponsor(conn, _params) do
    redirect_to_external(conn, :sponsor_url, "sponsor")
  end

  def random(conn, _params) do
    topic = Podcodar.Courses.get_random()
    redirect(conn, to: ~p"/courses?query=#{URI.encode_www_form(topic)}")
  end

  defp redirect_to_external(conn, config_key, service_name) do
    url = Application.get_env(:podcodar, config_key)
    Logger.info("#{service_name}_url: #{url}")
    redirect(conn, external: url)
  end
end
