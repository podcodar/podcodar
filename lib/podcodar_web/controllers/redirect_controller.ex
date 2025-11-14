defmodule PodcodarWeb.RedirectController do
  use PodcodarWeb, :controller

  require Logger

  def discord(conn, _params) do
    redirect_to_external(conn, :discord_invite_url)
  end

  def github(conn, _params) do
    redirect_to_external(conn, :github_org_url)
  end

  def sponsor(conn, _params) do
    redirect_to_external(conn, :sponsor_url)
  end

  def random(conn, _params) do
    topic = Podcodar.Courses.get_random()
    redirect(conn, to: ~p"/courses?query=#{URI.encode_www_form(topic)}")
  end

  defp redirect_to_external(conn, config_key) do
    url = Application.get_env(:podcodar, config_key)
    service_name = config_key |> Atom.to_string() |> String.replace("_invite_url", "") |> String.replace("_org_url", "") |> String.replace("_url", "")
    Logger.info("#{service_name}_url: #{url}")
    redirect(conn, external: url)
  end
end
