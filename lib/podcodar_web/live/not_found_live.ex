defmodule PodcodarWeb.NotFoundLive do
  use PodcodarWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: gettext("page_not_found"))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} locale={@locale}>
      <div class="min-h-screen flex items-center justify-center px-4">
        <div class="text-center">
          <div class="text-6xl font-bold text-primary mb-4">404</div>
          <h1 class="text-2xl font-bold mb-4">{gettext("page_not_found")}</h1>
          <p class="text-gray-600 mb-8 max-w-md mx-auto">
            {gettext("page_not_found_description")}
          </p>
          <.link navigate={~p"/"} class="btn btn-primary btn-lg">
            <.icon name="hero-home" class="w-5 h-5 mr-2" /> {gettext("back_to_home")}
          </.link>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
