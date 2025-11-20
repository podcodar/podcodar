defmodule PodcodarWeb.UserProfileLive do
  use PodcodarWeb, :live_view

  alias Podcodar.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} locale={@locale}>
      <div class="mx-auto max-w-2xl p-8 px-8">
        <%= if @user do %>
          <div class="flex flex-col items-center gap-6">
            <div class="avatar placeholder">
              <div class="bg-neutral text-neutral-content rounded-full w-24">
                <img src={~p"/images/logo.svg"} alt={@user.username} />
              </div>
            </div>

            <div class="text-center">
              <h1 class="text-3xl font-bold">{@user.name}</h1>
              <p class="text-lg text-base-content/60">@{@user.username}</p>
            </div>

            <div class="divider" />

            <div class="card bg-base-200 shadow-sm w-full">
              <div class="card-body">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <p class="text-sm text-base-content/60">{gettext("email")}</p>
                    <p class="font-semibold">{@user.email}</p>
                  </div>
                  <div>
                    <p class="text-sm text-base-content/60">{gettext("username")}</p>
                    <p class="font-semibold">@{@user.username}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        <% else %>
          <div class="text-center">
            <h1 class="text-2xl font-bold">{gettext("user_not_found")}</h1>
            <.link navigate={~p"/"} class="btn btn-primary mt-4">
              {gettext("back_to_home")}
            </.link>
          </div>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    case Accounts.get_user_by_username(username) do
      nil ->
        {:ok, assign(socket, user: nil)}

      user ->
        {:ok, assign(socket, user: user)}
    end
  end
end
