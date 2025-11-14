# Sistema de Controle de Acesso Baseado em Funções (RBAC)

## Visão Geral

O Podcodar implementa um sistema de controle de acesso baseado em funções (RBAC - Role-Based Access Control) com três funções principais: **member** (membro), **interviewer** (entrevistador) e **admin** (administrador).

## Funções Disponíveis

### 1. Member (Membro)
- **Descrição**: Função padrão atribuída a todos os novos usuários
- **Permissões**: Acesso básico às funcionalidades da plataforma
- **Casos de uso**: Usuários regulares da comunidade

### 2. Interviewer (Entrevistador)
- **Descrição**: Função para usuários que conduzem entrevistas simuladas
- **Permissões**: Todas as permissões de membro + acesso a funcionalidades de entrevista
- **Casos de uso**: Voluntários que realizam entrevistas técnicas com os membros

### 3. Admin (Administrador)
- **Descrição**: Função com acesso completo ao sistema
- **Permissões**: Todas as permissões + gerenciamento de usuários e configurações
- **Casos de uso**: Administradores da plataforma

## Como Usar no Código

### Verificando Funções em um Controller ou LiveView

```elixir
# Verificar se o usuário é admin
if Podcodar.Accounts.Scope.admin?(socket.assigns.current_scope) do
  # código para admins
end

# Verificar se o usuário é entrevistador (ou admin)
if Podcodar.Accounts.Scope.interviewer?(socket.assigns.current_scope) do
  # código para entrevistadores e admins
end

# Verificar uma função específica
if Podcodar.Accounts.Scope.has_role?(socket.assigns.current_scope, "interviewer") do
  # código apenas para entrevistadores
end

# Verificar múltiplas funções
if Podcodar.Accounts.Scope.has_any_role?(socket.assigns.current_scope, ["admin", "interviewer"]) do
  # código para admins ou entrevistadores
end
```

### Protegendo Rotas no Router

#### Para Controllers (usando plugs):

```elixir
# Rota apenas para admins
scope "/admin", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_admin]
  
  get "/dashboard", AdminController, :dashboard
end

# Rota para entrevistadores e admins
scope "/interviews", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_interviewer]
  
  get "/", InterviewController, :index
end
```

#### Para LiveViews (usando live_session):

```elixir
# Rota LiveView apenas para admins
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

# Rota LiveView para entrevistadores
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

### Gerenciando Funções de Usuários

```elixir
# Atualizar a função de um usuário
{:ok, user} = Podcodar.Accounts.update_user_role(user, "admin")

# Verificar funções diretamente no User
Podcodar.Accounts.User.admin?(user)          # true se admin
Podcodar.Accounts.User.interviewer?(user)    # true se interviewer ou admin
Podcodar.Accounts.User.has_role?(user, "member")  # true se member
```

## Plugs Disponíveis

O módulo `PodcodarWeb.UserAuth` fornece os seguintes plugs:

- `require_role(conn, role)` - Requer uma função específica
- `require_any_role(conn, roles)` - Requer uma das funções da lista
- `require_admin(conn, opts)` - Requer função de admin
- `require_interviewer(conn, opts)` - Requer função de interviewer ou admin

## Callbacks do LiveView

Para LiveViews, use os seguintes callbacks `on_mount`:

- `:require_admin` - Requer função de admin
- `:require_interviewer` - Requer função de interviewer ou admin

## Migração do Banco de Dados

A coluna `role` foi adicionada à tabela `users` com o valor padrão `"member"`. Todos os usuários existentes recebem automaticamente a função de membro.

```sql
-- Estrutura da coluna
ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT 'member';
CREATE INDEX users_role_index ON users(role);
```

## Exemplos Práticos

### Exemplo 1: Dashboard Administrativo

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

### Exemplo 2: Sistema de Entrevistas

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

### Exemplo 3: Conteúdo Condicional em Templates

```heex
<!-- Mostrar apenas para admins -->
<%= if Podcodar.Accounts.Scope.admin?(@current_scope) do %>
  <.link navigate={~p"/admin"}>Painel Admin</.link>
<% end %>

<!-- Mostrar para entrevistadores e admins -->
<%= if Podcodar.Accounts.Scope.interviewer?(@current_scope) do %>
  <.link navigate={~p"/interviews"}>Entrevistas</.link>
<% end %>
```

## Segurança

- As funções são armazenadas diretamente na tabela de usuários
- A validação de função acontece no nível do banco de dados (enum constraint)
- Todos os plugs de autorização redirecionam usuários não autorizados para a página inicial
- As mensagens de erro são consistentes para evitar vazamento de informações

## Testes

O sistema inclui testes abrangentes para:
- Funções do módulo User (`has_role?`, `admin?`, `interviewer?`, etc.)
- Funções do módulo Scope
- Plugs de autorização
- Callbacks do LiveView

Execute os testes com:

```bash
mix test test/podcodar/accounts_test.exs
mix test test/podcodar/accounts/scope_test.exs
mix test test/podcodar_web/user_auth_test.exs
```
