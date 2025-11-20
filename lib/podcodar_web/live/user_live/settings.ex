defmodule PodcodarWeb.UserLive.Settings do
  use PodcodarWeb, :live_view

  on_mount {PodcodarWeb.UserAuth, :require_sudo_mode}

  alias Podcodar.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} locale={@locale}>
      <div class="mx-auto max-w-2xl p-8 px-8">
        <div class="text-center">
          <.header>
            {gettext("account_settings")}
            <:subtitle>{gettext("manage_account_email_password_settings")}</:subtitle>
          </.header>
        </div>

        <.form for={@profile_form} id="profile_form" phx-submit="update_profile" phx-change="validate_profile">
          <.input
            field={@profile_form[:name]}
            type="text"
            label={gettext("full_name")}
            autocomplete="name"
            required
          />
          <.input
            field={@profile_form[:username]}
            type="text"
            label={gettext("username")}
            autocomplete="username"
            required
          />
          <.input
            field={@profile_form[:email]}
            type="email"
            label={gettext("email")}
            autocomplete="username"
            required
          />
          <.button variant="primary" phx-disable-with={gettext("saving")}>
            {gettext("save_profile")}
          </.button>
        </.form>

        <div class="divider" />

        <.form
          for={@password_form}
          id="password_form"
          action={~p"/users/update-password"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            autocomplete="username"
            value={@current_email}
          />
          <.input
            field={@password_form[:password]}
            type="password"
            label={gettext("new_password")}
            autocomplete="new-password"
            required
          />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label={gettext("confirm_new_password")}
            autocomplete="new-password"
          />
          <.button variant="primary" phx-disable-with={gettext("saving")}>
            {gettext("save_password")}
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_scope.user, token) do
        {:ok, _user} ->
          put_flash(socket, :info, gettext("email_changed_successfully"))

        {:error, _} ->
          put_flash(socket, :error, gettext("email_change_link_invalid_or_expired"))
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    profile_changeset = Accounts.change_user_profile_and_email(user, %{}, validate_unique: false)
    password_changeset = Accounts.change_user_password(user, %{}, hash_password: false)

    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:profile_form, to_form(profile_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_profile", params, socket) do
    %{"user" => user_params} = params

    profile_form =
      validate_user_form(
        socket.assigns.current_scope.user,
        user_params,
        &Accounts.change_user_profile_and_email(&1, &2, validate_unique: false)
      )

    {:noreply, assign(socket, profile_form: profile_form)}
  end

  def handle_event("update_profile", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    new_email = Map.get(user_params, "email")
    email_changed = new_email && new_email != user.email

    # First, update only the profile fields (name and username)
    profile_only_params = Map.take(user_params, ["name", "username"])

    case Accounts.update_user_profile(user, profile_only_params) do
      {:ok, updated_user} ->
        socket = assign(socket, :current_scope, %{socket.assigns.current_scope | user: updated_user})

        if email_changed do
          # Validate and send email confirmation
          case Accounts.change_user_email(updated_user, %{"email" => new_email}) do
            %{valid?: true} = changeset ->
              Accounts.deliver_user_update_email_instructions(
                Ecto.Changeset.apply_action!(changeset, :insert),
                user.email,
                &url(~p"/users/settings/confirm-email/#{&1}")
              )

              {:noreply,
               socket
               |> put_flash(:info, gettext("profile_and_email_change_confirmation_link_sent"))}

            changeset ->
              {:noreply,
               socket
               |> assign(:profile_form, to_form(changeset, action: :insert))}
          end
        else
          {:noreply,
           socket
           |> put_flash(:info, gettext("profile_updated_successfully"))}
        end

      {:error, changeset} ->
        {:noreply, assign(socket, profile_form: to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"user" => user_params} = params

    password_form =
      validate_user_form(
        socket.assigns.current_scope.user,
        user_params,
        &Accounts.change_user_password(&1, &2, hash_password: false)
      )

    {:noreply, assign(socket, password_form: password_form)}
  end

  def handle_event("update_password", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    case Accounts.change_user_password(user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, password_form: to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, password_form: to_form(changeset, action: :insert))}
    end
  end

  defp validate_user_form(user, user_params, change_function) do
    user
    |> change_function.(user_params)
    |> Map.put(:action, :validate)
    |> to_form()
  end
end
