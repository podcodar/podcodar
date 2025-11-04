defmodule PodcodarWeb.Hooks.SetLocale do
  @moduledoc """
  Hook to configure Gettext locale and assign for all LiveViews.

  Reads locale from session and sets it for Gettext and socket assigns.
  The locale is already configured in the plug, but we need to set it
  in the socket for LiveView templates.
  """
  import Phoenix.Component

  def on_mount(:default, _params, %{"locale" => locale}, socket) do
    Gettext.put_locale(PodcodarWeb.Gettext, locale)

    {:cont, assign(socket, :locale, locale)}
  end

  # catch-all case
  def on_mount(:default, _params, _session, socket) do
    default_locale =
      Application.fetch_env!(:podcodar, PodcodarWeb.Gettext)[:default_locale]
      |> to_string()

    Gettext.put_locale(PodcodarWeb.Gettext, default_locale)

    {:cont, assign(socket, :locale, default_locale)}
  end
end
