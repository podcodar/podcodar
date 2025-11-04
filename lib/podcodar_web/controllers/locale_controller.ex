defmodule PodcodarWeb.LocaleController do
  use PodcodarWeb, :controller

  def update(conn, %{"locale" => locale}) when locale in ["en", "pt_BR"] do
    # Get referer from header or default to root
    redirect_path =
      case get_req_header(conn, "referer") do
        [referer] -> URI.parse(referer).path || ~p"/"
        [] -> ~p"/"
      end

    conn
    |> put_session(:locale, locale)
    |> redirect(to: redirect_path)
  end

  def update(conn, _params) do
    redirect_path =
      case get_req_header(conn, "referer") do
        [referer] -> URI.parse(referer).path || ~p"/"
        [] -> ~p"/"
      end

    conn
    |> put_flash(:error, "Invalid locale")
    |> redirect(to: redirect_path)
  end
end
