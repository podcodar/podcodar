defmodule PodcodarWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PodcodarWeb, :html

  # Embed templates in layouts/*
  embed_templates "layouts/*"

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_scope, :map, default: nil, doc: "the current scope"
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <.flash_group flash={@flash} />

    <!-- Settings Modal -->
    <input type="checkbox" id="settings-modal" class="modal-toggle" />
    <div class="modal">
      <div class="modal-box">
        <h3 class="font-bold text-lg">Settings</h3>
        <p class="py-4">Choose your preferred theme:</p>
        <div class="flex justify-center py-4">
          <.theme_toggle id="modal-theme-toggle" />
        </div>
        <div class="modal-action">
          <label for="settings-modal" class="btn">Close</label>
        </div>
      </div>
    </div>

    <div class="bg-base-100 drawer">
      <input id="my-drawer-3" type="checkbox" class="drawer-toggle" />

      <div class="drawer-content flex flex-col min-h-screen">
        <.navbar current_scope={@current_scope} />

        <main class="flex-grow">
          {render_slot(@inner_block)}
        </main>

        <.footer />
      </div>

      <.drawer current_scope={@current_scope} />
    </div>

    <script>
      window.addEventListener("phx:toggle-settings-modal", () => {
        document.getElementById("settings-modal").checked = true;
      });
    </script>
    """
  end

  def drawer(assigns) do
    ~H"""
    <div class="drawer-side">
      <label for="my-drawer-3" class="drawer-overlay"></label>
      <ul class="menu p-4 w-80 min-h-full bg-base-200 gap-2">
        <div class="spacer mt-24" />

        <.social_links />

        <div class="spacer flex-1" />

        <.menu_links current_scope={@current_scope} />
      </ul>
    </div>
    """
  end

  def navbar(assigns) do
    ~H"""
    <div class="navbar none sticky top-0 p-4 z-50">
      <div class="flex bg-opacity-80 backdrop-blur-sm shadow-md rounded-lg w-full py-2 px-4 z-50">
        <div class="flex-none lg:hidden">
          <label for="my-drawer-3" class="btn btn-square btn-ghost">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              class="inline-block w-6 h-6 stroke-current"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h16M4 18h16"
              >
              </path>
            </svg>
          </label>
        </div>

        <div class="flex flex-1 mr-12 justify-center lg:justify-start">
          <a href="/" class="flex items-center gap-2">
            <img src={~p"/images/logo.svg"} width="36" alt="PodCodar logo" />
            <span class="text-lg font-bold">PodCodar</span>
          </a>

          <ul class="menu menu-horizontal gap-2 hidden lg:flex">
            <.social_links />
          </ul>
        </div>

        <div class="flex-none hidden lg:flex">
          <ul class="menu menu-horizontal gap-2">
            <.menu_links current_scope={@current_scope} />
          </ul>
        </div>
      </div>
    </div>
    """
  end

  def menu_links(assigns) do
    ~H"""
    <li class="hidden lg:flex">
      <button
        class="btn btn-ghost"
        phx-click={JS.dispatch("phx:toggle-settings-modal")}
      >
        <.icon name="hero-cog-6-tooth" class="w-4 h-4" />
      </button>
    </li>

    <%= if @current_scope do %>
      <li>
        <.link navigate={~p"/users/settings"}>
          <.icon name="hero-user" class="w-4 h-4" /> {@current_scope.user.email}
        </.link>
      </li>
      <li>
        <.link
          href={~p"/users/log-out"}
          method="delete"
          data-confirm="Are you sure you want to log out?"
        >
          <.icon name="hero-arrow-left-on-rectangle" class="w-4 h-4" /> Log out
        </.link>
      </li>
    <% else %>
      <li>
        <.link navigate={~p"/users/register"}>
          <.icon name="hero-user-plus" class="w-4 h-4" /> Register
        </.link>
      </li>
      <li>
        <.link navigate={~p"/users/log-in"} class="btn btn-primary">
          <.icon name="hero-arrow-right-on-rectangle" class="w-4 h-4" /> Log in
        </.link>
      </li>
    <% end %>

    <li class="flex lg:hidden btn-sm">
      <.theme_toggle />
    </li>
    """
  end

  def social_links(assigns) do
    ~H"""
    <li>
      <.link navigate={~p"/discord"} target="_blank" rel="noopener">
        <.icon name="hero-chat-bubble-left-right" class="w-4 h-4" /> Discord
      </.link>
    </li>

    <li>
      <.link navigate={~p"/github"} target="_blank" rel="noopener">
        <.icon name="hero-code-bracket" class="w-4 h-4" /> GitHub
      </.link>
    </li>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer class="footer footer-center p-6 bg-base-200 text-base-content">
      <div>
        <p>Copyright © {Date.utc_today().year} - Todos os direitos reservados a PodCodar</p>
      </div>
    </footer>
    """
  end

  attr :flash, :map, required: true
  attr :id, :string, default: "flash-group"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} class="toast toast-top mt-18 toast-end z-50" aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>
    </div>
    """
  end
end
