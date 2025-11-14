# Arquitetura do Sistema RBAC

## Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────┐
│                      Router (router.ex)                      │
│  Protege rotas usando plugs e live_session                   │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│              UserAuth Module (user_auth.ex)                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Plugs de Autorização:                                │   │
│  │ • require_admin/2                                    │   │
│  │ • require_interviewer/2                              │   │
│  │ • require_role/2                                     │   │
│  │ • require_any_role/2                                 │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ LiveView Callbacks:                                  │   │
│  │ • on_mount(:require_admin)                           │   │
│  │ • on_mount(:require_interviewer)                     │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│               Scope Module (scope.ex)                        │
│  Wrapper para verificação de roles                          │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Funções:                                             │   │
│  │ • has_role?(scope, role)                             │   │
│  │ • admin?(scope)                                      │   │
│  │ • interviewer?(scope)                                │   │
│  │ • has_any_role?(scope, roles)                        │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────────┘
                   │ delega para ↓
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                User Module (user.ex)                         │
│  Lógica principal de verificação de roles                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Schema:                                              │   │
│  │ • field :role, :string, default: "member"            │   │
│  │ • @valid_roles ~w(member interviewer admin)          │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Funções:                                             │   │
│  │ • has_role?(user, role)                              │   │
│  │ • admin?(user)                                       │   │
│  │ • interviewer?(user)                                 │   │
│  │ • has_any_role?(user, roles)                         │   │
│  │ • role_changeset(user, attrs)                        │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│              Accounts Context (accounts.ex)                  │
│  API pública para gerenciamento de roles                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Funções:                                             │   │
│  │ • update_user_role(user, role)                       │   │
│  │ • change_user_role(user, attrs)                      │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                Database (SQLite/PostgreSQL)                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ users table:                                         │   │
│  │ • id (binary_id, PK)                                 │   │
│  │ • email (string, unique)                             │   │
│  │ • role (string, default: "member", indexed)          │   │
│  │ • ... outros campos                                  │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Hierarquia de Roles

```
┌────────────────────────────────────────────────────────────┐
│                          ADMIN                              │
│  Acesso completo ao sistema                                │
│  ├─ Gerenciar usuários e roles                             │
│  ├─ Configurações do sistema                               │
│  ├─ Todas as funcionalidades de interviewer                │
│  └─ Todas as funcionalidades de member                     │
└──────────────────────────┬─────────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│                      INTERVIEWER                            │
│  Conduzir entrevistas e acessar recursos relacionados      │
│  ├─ Agendar entrevistas                                    │
│  ├─ Visualizar candidatos                                  │
│  ├─ Fornecer feedback                                      │
│  └─ Todas as funcionalidades de member                     │
└──────────────────────────┬─────────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│                        MEMBER                               │
│  Acesso básico às funcionalidades da plataforma            │
│  ├─ Visualizar cursos                                      │
│  ├─ Participar de grupos de estudo                         │
│  ├─ Atualizar perfil                                       │
│  └─ Solicitar entrevistas                                  │
└────────────────────────────────────────────────────────────┘
```

## Fluxo de Autorização

```
┌─────────────┐
│   Request   │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────────┐
│ Usuário autenticado?                    │
└──────┬──────────────────────────────────┘
       │                           não
       │ sim                       ├──────────┐
       ▼                           ▼          │
┌─────────────────────┐    ┌──────────────┐  │
│ current_scope existe│    │ Redirecionar │  │
└──────┬──────────────┘    │ para /login  │  │
       │                   └──────────────┘  │
       ▼                                     │
┌─────────────────────────────────────────┐ │
│ Role requerida?                         │ │
└──────┬──────────────────────────────────┘ │
       │                           não      │
       │ sim                       ├────────┤
       ▼                           ▼        │
┌─────────────────────┐    ┌──────────────┐│
│ Verificar role      │    │   Permitir   ││
│ do usuário          │    │   acesso     ││
└──────┬──────────────┘    └──────────────┘│
       │                                    │
       ▼                                    │
┌─────────────────────────────────────────┐│
│ Usuário tem role necessária?            ││
└──────┬──────────────────────────────────┘│
       │                           não     │
       │ sim                       ├───────┘
       ▼                           ▼
┌─────────────────────┐    ┌──────────────────┐
│   Permitir acesso   │    │ Redirecionar     │
│                     │    │ para / com erro  │
└─────────────────────┘    └──────────────────┘
```

## Exemplo de Uso no Router

```elixir
# router.ex

# Rotas públicas (sem autenticação)
scope "/", PodcodarWeb do
  pipe_through [:browser]
  
  live "/", PageLive, :home
  live "/courses", CoursesLive, :index
end

# Rotas de membros autenticados
scope "/", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user]
  
  live_session :member,
    on_mount: [{PodcodarWeb.UserAuth, :require_authenticated}] do
    live "/profile", ProfileLive, :show
    live "/study-groups", StudyGroupLive, :index
  end
end

# Rotas de entrevistadores
scope "/interviews", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_interviewer]
  
  live_session :interviewer,
    on_mount: [
      {PodcodarWeb.UserAuth, :require_authenticated},
      {PodcodarWeb.UserAuth, :require_interviewer}
    ] do
    live "/", InterviewLive.Index, :index
    live "/schedule", InterviewLive.Schedule, :new
    live "/:id", InterviewLive.Show, :show
  end
end

# Rotas administrativas
scope "/admin", PodcodarWeb do
  pipe_through [:browser, :require_authenticated_user, :require_admin]
  
  live_session :admin,
    on_mount: [
      {PodcodarWeb.UserAuth, :require_authenticated},
      {PodcodarWeb.UserAuth, :require_admin}
    ] do
    live "/", AdminLive.Dashboard, :index
    live "/users", AdminLive.Users, :index
    live "/users/:id/edit", AdminLive.Users, :edit
    live "/settings", AdminLive.Settings, :index
  end
end
```

## Verificação de Roles em Templates

```heex
<%!-- Mostrar link apenas para admins --%>
<%= if Podcodar.Accounts.Scope.admin?(@current_scope) do %>
  <.link navigate={~p"/admin"} class="nav-link">
    <.icon name="hero-cog-6-tooth" /> Admin
  </.link>
<% end %>

<%!-- Mostrar link para entrevistadores e admins --%>
<%= if Podcodar.Accounts.Scope.interviewer?(@current_scope) do %>
  <.link navigate={~p"/interviews"} class="nav-link">
    <.icon name="hero-chat-bubble-left-right" /> Entrevistas
  </.link>
<% end %>

<%!-- Conteúdo condicional baseado em múltiplas roles --%>
<%= if Podcodar.Accounts.Scope.has_any_role?(@current_scope, ["admin", "interviewer"]) do %>
  <div class="advanced-features">
    <%!-- Funcionalidades avançadas --%>
  </div>
<% end %>
```

## Testes

```elixir
# Testar plug de autorização
test "require_admin/2 allows admin users" do
  {:ok, admin_user} = Accounts.update_user_role(user, "admin")
  
  conn =
    conn
    |> assign(:current_scope, Scope.for_user(admin_user))
    |> UserAuth.require_admin([])
  
  refute conn.halted
end

# Testar LiveView callback
test "on_mount(:require_interviewer) allows interviewer users" do
  {:ok, interviewer} = Accounts.update_user_role(user, "interviewer")
  
  assert {:cont, _socket} = 
    UserAuth.on_mount(:require_interviewer, %{}, session, socket)
end
```
