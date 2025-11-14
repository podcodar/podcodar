# RBAC Quick Reference / Referência Rápida RBAC

## Roles / Funções

| Role | PT-BR | Permissions |
|------|-------|-------------|
| `member` | Membro | Acesso básico |
| `interviewer` | Entrevistador | Entrevistas + member |
| `admin` | Administrador | Tudo |

## Verificar Roles / Check Roles

### No Template / In Templates
```heex
<%!-- Admin apenas / Admin only --%>
<%= if Scope.admin?(@current_scope) do %>
  ...
<% end %>

<%!-- Entrevistador ou Admin / Interviewer or Admin --%>
<%= if Scope.interviewer?(@current_scope) do %>
  ...
<% end %>

<%!-- Role específica / Specific role --%>
<%= if Scope.has_role?(@current_scope, "member") do %>
  ...
<% end %>

<%!-- Múltiplas roles / Multiple roles --%>
<%= if Scope.has_any_role?(@current_scope, ["admin", "interviewer"]) do %>
  ...
<% end %>
```

### No Código / In Code
```elixir
# No LiveView ou Controller / In LiveView or Controller
alias Podcodar.Accounts.Scope

Scope.admin?(socket.assigns.current_scope)
Scope.interviewer?(socket.assigns.current_scope)
Scope.has_role?(socket.assigns.current_scope, "member")
Scope.has_any_role?(socket.assigns.current_scope, ["admin", "interviewer"])

# Direto no User / Directly on User
alias Podcodar.Accounts.User

User.admin?(user)
User.interviewer?(user)
User.has_role?(user, "admin")
User.has_any_role?(user, ["admin", "interviewer"])
```

## Proteger Rotas / Protect Routes

### Controller Routes / Rotas de Controller
```elixir
# Apenas admin / Admin only
scope "/admin", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_admin]
  get "/dashboard", AdminController, :dashboard
end

# Entrevistador ou Admin / Interviewer or Admin
scope "/interviews", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_interviewer]
  get "/", InterviewController, :index
end
```

### LiveView Routes / Rotas LiveView
```elixir
# Apenas admin / Admin only
live_session :admin,
  on_mount: [
    {PodcodarWeb.UserAuth, :require_authenticated},
    {PodcodarWeb.UserAuth, :require_admin}
  ] do
  live "/admin", AdminLive.Dashboard
end

# Entrevistador ou Admin / Interviewer or Admin
live_session :interviewer,
  on_mount: [
    {PodcodarWeb.UserAuth, :require_authenticated},
    {PodcodarWeb.UserAuth, :require_interviewer}
  ] do
  live "/interviews", InterviewLive.Index
end
```

## Gerenciar Roles / Manage Roles

### Atualizar Role / Update Role
```elixir
# Atualizar role de um usuário / Update user role
{:ok, user} = Accounts.update_user_role(user, "admin")
{:ok, user} = Accounts.update_user_role(user, "interviewer")
{:ok, user} = Accounts.update_user_role(user, "member")

# Obter changeset / Get changeset
changeset = Accounts.change_user_role(user, %{role: "admin"})
```

## Plugs Disponíveis / Available Plugs

| Plug | Permite / Allows |
|------|------------------|
| `require_admin/2` | admin |
| `require_interviewer/2` | interviewer, admin |
| `require_role/2` | role específica / specific role |
| `require_any_role/2` | qualquer das roles / any of roles |

### Uso / Usage
```elixir
# No pipeline / In pipeline
pipe_through [:browser, :require_authenticated_user, :require_admin]

# Direto no controller / Directly in controller
def my_action(conn, params) do
  conn
  |> UserAuth.require_admin([])
  |> ...
end
```

## LiveView Callbacks

| Callback | Permite / Allows |
|----------|------------------|
| `:require_admin` | admin |
| `:require_interviewer` | interviewer, admin |

### Uso / Usage
```elixir
live_session :protected,
  on_mount: [
    {PodcodarWeb.UserAuth, :require_authenticated},
    {PodcodarWeb.UserAuth, :require_admin}
  ] do
  ...
end
```

## Testes / Tests

```elixir
# Setup
import Podcodar.AccountsFixtures
alias Podcodar.Accounts
alias Podcodar.Accounts.Scope

# Criar usuário com role específica / Create user with specific role
user = user_fixture()
{:ok, admin} = Accounts.update_user_role(user, "admin")
{:ok, interviewer} = Accounts.update_user_role(user, "interviewer")

# Testar verificação de role / Test role check
assert User.admin?(admin)
assert User.interviewer?(interviewer)
refute User.admin?(user)

# Testar Scope / Test Scope
scope = Scope.for_user(admin)
assert Scope.admin?(scope)

# Testar plug / Test plug
conn
|> assign(:current_scope, Scope.for_user(admin))
|> UserAuth.require_admin([])

refute conn.halted  # Sucesso / Success

# Testar LiveView callback / Test LiveView callback
assert {:cont, _socket} = 
  UserAuth.on_mount(:require_admin, %{}, session, socket)
```

## Mensagens de Erro / Error Messages

| Situação / Situation | Redirecionamento / Redirect | Mensagem / Message |
|----------------------|----------------------------|-------------------|
| Não autenticado / Not authenticated | `/users/log-in` | "You must log in to access this page." |
| Sem permissão / No permission | `/` | "You do not have permission to access this page." |

## Migrations

```elixir
# Adicionar role na criação / Add role on creation
%User{}
|> User.email_changeset(%{email: "user@example.com"})
|> Ecto.Changeset.put_change(:role, "admin")
|> Repo.insert()

# Nota: Por padrão, novos usuários recebem role "member"
# Note: By default, new users receive "member" role
```

## Valores Válidos / Valid Values

```elixir
@valid_roles ~w(member interviewer admin)
```

Apenas estas três roles são aceitas / Only these three roles are accepted.

## Links Úteis / Useful Links

- 📚 Guia Completo / Complete Guide: `docs/rbac.md` (PT-BR)
- 📚 Complete Guide: `specs/rbac.md` (EN)
- 🏗️ Arquitetura / Architecture: `docs/rbac-architecture.md`
- 🧪 Testes / Tests:
  - `test/podcodar/accounts_test.exs`
  - `test/podcodar/accounts/scope_test.exs`
  - `test/podcodar_web/user_auth_test.exs`

## Exemplos Rápidos / Quick Examples

### 1. Página Admin / Admin Page
```elixir
# router.ex
scope "/admin", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_admin]
  
  live_session :admin,
    on_mount: [
      {PodcodarWeb.UserAuth, :require_authenticated},
      {PodcodarWeb.UserAuth, :require_admin}
    ] do
    live "/", AdminLive.Index
  end
end

# admin_live.ex
defmodule PodcodarWeb.AdminLive.Index do
  use PodcodarWeb, :live_view
  
  def mount(_params, _session, socket) do
    # Usuário já foi validado como admin pelos callbacks
    # User already validated as admin by callbacks
    {:ok, socket}
  end
end
```

### 2. Botão Condicional / Conditional Button
```heex
<%= if Scope.admin?(@current_scope) do %>
  <.button phx-click="delete_user">Deletar Usuário</.button>
<% end %>
```

### 3. Seção Protegida / Protected Section
```elixir
def handle_event("admin_action", _params, socket) do
  if Scope.admin?(socket.assigns.current_scope) do
    # Executar ação / Execute action
    {:noreply, socket}
  else
    {:noreply, put_flash(socket, :error, "Acesso negado")}
  end
end
```
