defmodule PodcodarWeb.Hooks.SetLocale do
  @moduledoc """
  Hook to configure Gettext locale and assign for all LiveViews.

  Reads locale from session and sets it for Gettext and socket assigns.
  The locale is already configured in the plug, but we need to set it
  in the socket for LiveView templates.
  """

  def on_mount(:set_locale, _params, session, socket) do
    locale = session["locale"] || "pt_BR"

    # Configure Gettext locale (already set in plug, but ensure it's set here too)
    Gettext.put_locale(PodcodarWeb.Gettext, locale)

    # Convert to HTML lang format (pt_BR -> pt-br) for use in templates
    html_lang = locale |> String.downcase() |> String.replace("_", "-")

    socket = Phoenix.Component.assign(socket, :locale, html_lang)

    {:cont, socket}
  end
end
