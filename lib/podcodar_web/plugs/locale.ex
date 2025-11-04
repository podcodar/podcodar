defmodule PodcodarWeb.Plugs.Locale do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    default_locale =
      Application.fetch_env!(:podcodar, PodcodarWeb.Gettext)[:default_locale]
      |> to_string()

    conn = Plug.Conn.fetch_session(conn)
    locale = Plug.Conn.get_session(conn, :locale) || default_locale

    # Set Gettext locale for controllers
    Gettext.put_locale(PodcodarWeb.Gettext, locale)

    assign(conn, :locale, locale)
  end
end
