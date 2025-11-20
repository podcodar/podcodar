defmodule PodcodarWeb.UserLive.Registration do
  use PodcodarWeb, :live_view

  alias Podcodar.Accounts
  alias Podcodar.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} locale={@locale}>
      <div class="mx-auto max-w-sm px-8">
        <div class="text-center">
          <.header>
            {gettext("register_for_an_account")}
            <:subtitle>
              {gettext("already_registered")}
              <.link navigate={~p"/users/log-in"} class="font-semibold text-brand hover:underline">
                {gettext("log_in")}
              </.link>
              {gettext("to_your_account_now")}
            </:subtitle>
          </.header>
        </div>

        <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
          <.input
            field={@form[:name]}
            type="text"
            label={gettext("full_name")}
            autocomplete="name"
            required
            phx-mounted={JS.focus()}
          />

          <.input
            field={@form[:username]}
            type="text"
            label={gettext("username")}
            autocomplete="username"
            required
          />

          <.input
            field={@form[:email]}
            type="email"
            label={gettext("email")}
            autocomplete="email"
            required
          />

          <.button phx-disable-with={gettext("creating_account")} class="btn btn-primary w-full">
            {gettext("create_an_account")}
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: PodcodarWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = User.registration_changeset(%User{}, %{}, validate_unique: false)
    form = to_form(changeset, as: "user")

    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           gettext("email_sent_confirmation", email: user.email)
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        form = to_form(changeset, as: "user")
        {:noreply, assign(socket, form: form)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = User.registration_changeset(%User{}, user_params, validate_unique: false)
    form = to_form(Map.put(changeset, :action, :validate), as: "user")
    {:noreply, assign(socket, form: form)}
  end
end
