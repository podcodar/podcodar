defmodule PodcodarWeb.RedirectController do
  use PodcodarWeb, :controller

  require Logger

  def discord(conn, _params) do
    discord_url = Application.get_env(:podcodar, :discord_invite_url)
    Logger.info("discord_url: #{discord_url}")
    redirect(conn, external: discord_url)
  end

  def github(conn, _params) do
    github_url = Application.get_env(:podcodar, :github_org_url)
    Logger.info("github_url: #{github_url}")
    redirect(conn, external: github_url)
  end

  def sponsor(conn, _params) do
    sponsor_url = Application.get_env(:podcodar, :sponsor_url)
    Logger.info("sponsor_url: #{sponsor_url}")
    redirect(conn, external: sponsor_url)
  end

  def random(conn, _params) do
    topic = Podcodar.Courses.get_random()
    redirect(conn, to: "/courses?query=#{URI.encode_www_form(topic)}")
  end
end
