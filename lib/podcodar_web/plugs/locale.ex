defmodule PodcodarWeb.Plugs.Locale do
  import Plug.Conn

  def init(default), do: default

  def call(conn, default) do
    conn = Plug.Conn.fetch_session(conn)
    locale = Plug.Conn.get_session(conn, :locale) || default

    assign(conn, :locale, locale)
  end
end
