defmodule Podcodar.Accounts.Scope do
  @moduledoc """
  Defines the scope of the caller to be used throughout the app.

  The `Podcodar.Accounts.Scope` allows public interfaces to receive
  information about the caller, such as if the call is initiated from an
  end-user, and if so, which user. Additionally, such a scope can carry fields
  such as "super user" or other privileges for use as authorization, or to
  ensure specific code paths can only be access for a given scope.

  It is useful for logging as well as for scoping pubsub subscriptions and
  broadcasts when a caller subscribes to an interface or performs a particular
  action.

  Feel free to extend the fields on this struct to fit the needs of
  growing application requirements.
  """

  alias Podcodar.Accounts.User

  defstruct user: nil

  @doc """
  Creates a scope for the given user.

  Returns nil if no user is given.
  """
  def for_user(%User{} = user) do
    %__MODULE__{user: user}
  end

  def for_user(nil), do: nil

  @doc """
  Returns true if the scope has the given role.
  """
  def has_role?(%__MODULE__{user: %User{} = user}, role) do
    User.has_role?(user, role)
  end

  def has_role?(_, _), do: false

  @doc """
  Returns true if the scope is an admin.
  """
  def admin?(%__MODULE__{user: %User{} = user}), do: User.admin?(user)
  def admin?(_), do: false

  @doc """
  Returns true if the scope is an interviewer or admin.
  """
  def interviewer?(%__MODULE__{user: %User{} = user}), do: User.interviewer?(user)
  def interviewer?(_), do: false

  @doc """
  Returns true if the scope has at least one of the given roles.
  """
  def has_any_role?(%__MODULE__{user: %User{} = user}, roles) do
    User.has_any_role?(user, roles)
  end

  def has_any_role?(_, _), do: false
end
