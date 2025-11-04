defmodule PodcodarWeb.UserLive.Confirmation do
  use PodcodarWeb, :live_view

  alias Podcodar.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} locale={@locale}>
      <div class="mx-auto max-w-sm">
        <div class="text-center">
          <.header>{gettext("welcome")} {@user.email}</.header>
        </div>

        <.form
          :if={!@user.confirmed_at}
          for={@form}
          id="confirmation_form"
          phx-mounted={JS.focus_first()}
          phx-submit="submit"
          action={~p"/users/log-in?_action=confirmed"}
          phx-trigger-action={@trigger_submit}
        >
          <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
          <.button
            name={@form[:remember_me].name}
            value="true"
            phx-disable-with={gettext("confirming")}
            class="btn btn-primary w-full"
          >
            {gettext("confirm_and_stay_logged_in")}
          </.button>
          <.button
            phx-disable-with={gettext("confirming")}
            class="btn btn-primary btn-soft w-full mt-2"
          >
            {gettext("confirm_and_log_in_only_this_time")}
          </.button>
        </.form>

        <.form
          :if={@user.confirmed_at}
          for={@form}
          id="login_form"
          phx-submit="submit"
          phx-mounted={JS.focus_first()}
          action={~p"/users/log-in"}
          phx-trigger-action={@trigger_submit}
        >
          <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
          <%= if @current_scope do %>
            <.button phx-disable-with={gettext("logging_in")} class="btn btn-primary w-full">
              {gettext("log_in")}
            </.button>
          <% else %>
            <.button
              name={@form[:remember_me].name}
              value="true"
              phx-disable-with={gettext("logging_in")}
              class="btn btn-primary w-full"
            >
              {gettext("keep_me_logged_in_on_this_device")}
            </.button>
            <.button
              phx-disable-with={gettext("logging_in")}
              class="btn btn-primary btn-soft w-full mt-2"
            >
              {gettext("log_me_in_only_this_time")}
            </.button>
          <% end %>
        </.form>

        <p :if={!@user.confirmed_at} class="alert alert-outline mt-8">
          {gettext("tip_enable_passwords_in_settings")}
        </p>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    if user = Accounts.get_user_by_magic_link_token(token) do
      form = to_form(%{"token" => token}, as: "user")

      {:ok, assign(socket, user: user, form: form, trigger_submit: false),
       temporary_assigns: [form: nil]}
    else
      {:ok,
       socket
       |> put_flash(:error, gettext("magic_link_invalid_or_expired"))
       |> push_navigate(to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"), trigger_submit: true)}
  end
end
