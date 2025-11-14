# Role-Based Access Control (RBAC) System

## Overview

Podcodar implements a Role-Based Access Control (RBAC) system with three main roles: **member**, **interviewer**, and **admin**.

## Available Roles

### 1. Member
- **Description**: Default role assigned to all new users
- **Permissions**: Basic access to platform features
- **Use cases**: Regular community users

### 2. Interviewer
- **Description**: Role for users who conduct mock interviews
- **Permissions**: All member permissions + access to interview features
- **Use cases**: Volunteers who conduct technical interviews with members

### 3. Admin
- **Description**: Role with full system access
- **Permissions**: All permissions + user management and settings
- **Use cases**: Platform administrators

## Usage in Code

### Checking Roles in Controllers or LiveViews

```elixir
# Check if user is admin
if Podcodar.Accounts.Scope.admin?(socket.assigns.current_scope) do
  # admin code
end

# Check if user is interviewer (or admin)
if Podcodar.Accounts.Scope.interviewer?(socket.assigns.current_scope) do
  # code for interviewers and admins
end

# Check for a specific role
if Podcodar.Accounts.Scope.has_role?(socket.assigns.current_scope, "interviewer") do
  # code for interviewers only
end

# Check for multiple roles
if Podcodar.Accounts.Scope.has_any_role?(socket.assigns.current_scope, ["admin", "interviewer"]) do
  # code for admins or interviewers
end
```

### Protecting Routes in Router

#### For Controllers (using plugs):

```elixir
# Admin-only route
scope "/admin", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_admin]
  
  get "/dashboard", AdminController, :dashboard
end

# Route for interviewers and admins
scope "/interviews", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_interviewer]
  
  get "/", InterviewController, :index
end
```

#### For LiveViews (using live_session):

```elixir
# Admin-only LiveView route
scope "/admin", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user]
  
  live_session :require_admin,
    on_mount: [
      {PodcodarWeb.UserAuth, :require_authenticated},
      {PodcodarWeb.UserAuth, :require_admin}
    ] do
    live "/users", AdminLive.Users, :index
  end
end

# Interviewer LiveView route
scope "/interviews", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user]
  
  live_session :require_interviewer,
    on_mount: [
      {PodcodarWeb.UserAuth, :require_authenticated},
      {PodcodarWeb.UserAuth, :require_interviewer}
    ] do
    live "/schedule", InterviewLive.Schedule, :index
  end
end
```

### Managing User Roles

```elixir
# Update a user's role
{:ok, user} = Podcodar.Accounts.update_user_role(user, "admin")

# Check roles directly on User
Podcodar.Accounts.User.admin?(user)          # true if admin
Podcodar.Accounts.User.interviewer?(user)    # true if interviewer or admin
Podcodar.Accounts.User.has_role?(user, "member")  # true if member
```

## Available Plugs

The `PodcodarWeb.UserAuth` module provides the following plugs:

- `require_role(conn, role)` - Requires a specific role
- `require_any_role(conn, roles)` - Requires one of the roles from the list
- `require_admin(conn, opts)` - Requires admin role
- `require_interviewer(conn, opts)` - Requires interviewer or admin role

## LiveView Callbacks

For LiveViews, use the following `on_mount` callbacks:

- `:require_admin` - Requires admin role
- `:require_interviewer` - Requires interviewer or admin role

## Database Migration

The `role` column was added to the `users` table with a default value of `"member"`. All existing users automatically receive the member role.

```sql
-- Column structure
ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT 'member';
CREATE INDEX users_role_index ON users(role);
```

## Practical Examples

### Example 1: Admin Dashboard

```elixir
# router.ex
scope "/admin", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_admin]
  
  live_session :admin_dashboard,
    on_mount: [
      {PodcodarWeb.UserAuth, :require_authenticated},
      {PodcodarWeb.UserAuth, :require_admin}
    ] do
    live "/", AdminLive.Dashboard, :index
    live "/users", AdminLive.Users, :index
    live "/settings", AdminLive.Settings, :index
  end
end
```

### Example 2: Interview System

```elixir
# router.ex
scope "/interviews", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_interviewer]
  
  live_session :interviews,
    on_mount: [
      {PodcodarWeb.UserAuth, :require_authenticated},
      {PodcodarWeb.UserAuth, :require_interviewer}
    ] do
    live "/", InterviewLive.Index, :index
    live "/new", InterviewLive.New, :new
    live "/:id", InterviewLive.Show, :show
  end
end
```

### Example 3: Conditional Content in Templates

```heex
<!-- Show only for admins -->
<%= if Podcodar.Accounts.Scope.admin?(@current_scope) do %>
  <.link navigate={~p"/admin"}>Admin Panel</.link>
<% end %>

<!-- Show for interviewers and admins -->
<%= if Podcodar.Accounts.Scope.interviewer?(@current_scope) do %>
  <.link navigate={~p"/interviews"}>Interviews</.link>
<% end %>
```

## Security

- Roles are stored directly in the users table
- Role validation happens at the database level (enum constraint)
- All authorization plugs redirect unauthorized users to the home page
- Error messages are consistent to avoid information leakage

## Testing

The system includes comprehensive tests for:
- User module functions (`has_role?`, `admin?`, `interviewer?`, etc.)
- Scope module functions
- Authorization plugs
- LiveView callbacks

Run tests with:

```bash
mix test test/podcodar/accounts_test.exs
mix test test/podcodar/accounts/scope_test.exs
mix test test/podcodar_web/user_auth_test.exs
```
