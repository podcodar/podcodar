defmodule PodcodarWeb.UserLive.Profile do
  use PodcodarWeb, :live_view

  alias Podcodar.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} locale={@locale}>
      <div class="max-w-4xl mx-auto p-8">
        <%= if @user do %>
          <div class="card bg-base-200 shadow-xl">
            <div class="card-body">
              <div class="flex items-center gap-4 mb-6">
                <div class="avatar placeholder">
                  <div class="bg-primary text-primary-content rounded-full w-24">
                    <span class="text-3xl">{String.first(@user.username) |> String.upcase()}</span>
                  </div>
                </div>
                <div>
                  <h1 class="text-3xl font-bold">@{@user.username}</h1>
                  <%= if @user.name do %>
                    <p class="text-xl text-base-content/70">{@user.name}</p>
                  <% end %>
                </div>
              </div>

              <div class="divider"></div>

              <div class="space-y-4">
                <div>
                  <h2 class="text-xl font-semibold mb-2">{gettext("profile_info")}</h2>
                  <div class="space-y-2">
                    <p>
                      <span class="font-semibold">{gettext("username")}:</span> @{@user.username}
                    </p>
                    <%= if @user.name do %>
                      <p>
                        <span class="font-semibold">{gettext("name")}:</span>
                        {@user.name}
                      </p>
                    <% end %>
                    <%= if @show_email do %>
                      <p>
                        <span class="font-semibold">{gettext("email")}:</span>
                        {@user.email}
                      </p>
                    <% end %>
                    <%= if @user.confirmed_at do %>
                      <p>
                        <span class="font-semibold">{gettext("member_since")}:</span>
                        {Calendar.strftime(@user.confirmed_at, "%B %d, %Y")}
                      </p>
                    <% end %>
                  </div>
                </div>

                <%= if @is_own_profile do %>
                  <div class="card-actions justify-end">
                    <.link navigate={~p"/users/settings"} class="btn btn-primary">
                      <.icon name="hero-cog-6-tooth" class="w-4 h-4" />
                      {gettext("edit_profile")}
                    </.link>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        <% else %>
          <div class="card bg-base-200 shadow-xl">
            <div class="card-body text-center">
              <h1 class="text-3xl font-bold">{gettext("user_not_found")}</h1>
              <p class="text-lg text-base-content/70">{gettext("user_not_found_message")}</p>
              <div class="card-actions justify-center mt-4">
                <.link navigate={~p"/"} class="btn btn-primary">
                  {gettext("go_home")}
                </.link>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username(username)

    is_own_profile =
      case socket.assigns.current_scope do
        %{user: current_user} when not is_nil(current_user) ->
          user && current_user.id == user.id

        _ ->
          false
      end

    show_email = is_own_profile

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:is_own_profile, is_own_profile)
     |> assign(:show_email, show_email)
     |> assign(:page_title, if(user, do: "@#{user.username}", else: "User not found"))}
  end
end
