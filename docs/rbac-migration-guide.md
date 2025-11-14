# Guia de Migração RBAC / RBAC Migration Guide

## Para Ambientes em Produção / For Production Environments

Este guia ajuda a migrar um sistema existente do Podcodar para usar o novo sistema RBAC.
This guide helps migrate an existing Podcodar system to use the new RBAC system.

### ⚠️ Antes de Começar / Before Starting

1. **Backup do banco de dados** / **Database backup**
2. **Testar em ambiente de desenvolvimento primeiro** / **Test in development environment first**
3. **Planejar janela de manutenção se necessário** / **Plan maintenance window if needed**

### 📋 Passo a Passo / Step by Step

#### 1. Deploy do Código / Code Deployment

```bash
# Pull das mudanças / Pull changes
git pull origin main

# Instalar dependências (se necessário) / Install dependencies (if needed)
mix deps.get

# Compilar / Compile
mix compile
```

#### 2. Executar Migração do Banco de Dados / Run Database Migration

A migração adiciona a coluna `role` com valor padrão "member" para todos os usuários existentes.
The migration adds the `role` column with default value "member" for all existing users.

```bash
# Produção / Production
mix ecto.migrate

# ou Docker / or Docker
docker exec -it podcodar bin/podcodar eval "Podcodar.Release.migrate"
```

**O que a migração faz / What the migration does:**
- Adiciona coluna `role` na tabela `users` / Adds `role` column to `users` table
- Define valor padrão como "member" / Sets default value as "member"
- Cria índice para performance / Creates index for performance
- **Todos os usuários existentes recebem role "member" automaticamente** / **All existing users automatically receive "member" role**

#### 3. Verificar Migração / Verify Migration

```elixir
# Via IEx / Via IEx
iex -S mix

# ou Docker / or Docker
docker exec -it podcodar bin/podcodar remote

# Verificar estrutura / Check structure
Podcodar.Repo.query!("PRAGMA table_info(users)")

# Verificar dados / Check data
Podcodar.Repo.all(Podcodar.Accounts.User) |> Enum.map(& &1.role)
# Deve mostrar "member" para todos / Should show "member" for all
```

#### 4. Atribuir Roles de Admin / Assign Admin Roles

Identifique e atualize os usuários que devem ser administradores:
Identify and update users who should be administrators:

```elixir
# Via IEx / Via IEx
alias Podcodar.Accounts

# Por email / By email
user = Accounts.get_user_by_email("admin@podcodar.org")
{:ok, _admin} = Accounts.update_user_role(user, "admin")

# Múltiplos admins / Multiple admins
admin_emails = [
  "admin1@podcodar.org",
  "admin2@podcodar.org"
]

Enum.each(admin_emails, fn email ->
  user = Accounts.get_user_by_email(email)
  if user do
    case Accounts.update_user_role(user, "admin") do
      {:ok, _} -> IO.puts("✓ #{email} agora é admin / is now admin")
      {:error, _} -> IO.puts("✗ Erro ao atualizar / Error updating #{email}")
    end
  else
    IO.puts("✗ Usuário não encontrado / User not found: #{email}")
  end
end)
```

#### 5. Atribuir Roles de Entrevistador / Assign Interviewer Roles

```elixir
interviewer_emails = [
  "interviewer1@podcodar.org",
  "interviewer2@podcodar.org"
]

Enum.each(interviewer_emails, fn email ->
  user = Accounts.get_user_by_email(email)
  if user do
    case Accounts.update_user_role(user, "interviewer") do
      {:ok, _} -> IO.puts("✓ #{email} agora é entrevistador / is now interviewer")
      {:error, _} -> IO.puts("✗ Erro ao atualizar / Error updating #{email}")
    end
  else
    IO.puts("✗ Usuário não encontrado / User not found: #{email}")
  end
end)
```

#### 6. Verificar Roles / Verify Roles

```elixir
# Listar admins / List admins
Podcodar.Repo.all(from u in Podcodar.Accounts.User, where: u.role == "admin", select: u.email)

# Listar entrevistadores / List interviewers
Podcodar.Repo.all(from u in Podcodar.Accounts.User, where: u.role == "interviewer", select: u.email)

# Contar por role / Count by role
Podcodar.Repo.all(
  from u in Podcodar.Accounts.User,
  group_by: u.role,
  select: {u.role, count(u.id)}
)
```

### 🔧 Script de Migração Completo / Complete Migration Script

Crie um arquivo `priv/repo/seeds/assign_roles.exs`:
Create a file `priv/repo/seeds/assign_roles.exs`:

```elixir
alias Podcodar.Accounts

# Lista de administradores / List of administrators
admins = [
  "admin@podcodar.org"
]

# Lista de entrevistadores / List of interviewers
interviewers = [
  "interviewer1@podcodar.org",
  "interviewer2@podcodar.org"
]

IO.puts("\n🔄 Atribuindo roles... / Assigning roles...\n")

# Atribuir admins / Assign admins
IO.puts("📝 Administradores / Administrators:")
Enum.each(admins, fn email ->
  case Accounts.get_user_by_email(email) do
    nil ->
      IO.puts("  ✗ Não encontrado / Not found: #{email}")
    user ->
      case Accounts.update_user_role(user, "admin") do
        {:ok, _} -> IO.puts("  ✓ #{email}")
        {:error, changeset} ->
          IO.puts("  ✗ Erro / Error #{email}: #{inspect(changeset.errors)}")
      end
  end
end)

# Atribuir entrevistadores / Assign interviewers
IO.puts("\n📝 Entrevistadores / Interviewers:")
Enum.each(interviewers, fn email ->
  case Accounts.get_user_by_email(email) do
    nil ->
      IO.puts("  ✗ Não encontrado / Not found: #{email}")
    user ->
      case Accounts.update_user_role(user, "interviewer") do
        {:ok, _} -> IO.puts("  ✓ #{email}")
        {:error, changeset} ->
          IO.puts("  ✗ Erro / Error #{email}: #{inspect(changeset.errors)}")
      end
  end
end)

# Mostrar resumo / Show summary
IO.puts("\n📊 Resumo / Summary:")
stats = Podcodar.Repo.all(
  from u in Podcodar.Accounts.User,
  group_by: u.role,
  select: {u.role, count(u.id)}
)

Enum.each(stats, fn {role, count} ->
  IO.puts("  #{role}: #{count} usuários / users")
end)

IO.puts("\n✅ Concluído! / Done!\n")
```

Execute o script / Run the script:

```bash
# Desenvolvimento / Development
mix run priv/repo/seeds/assign_roles.exs

# Produção / Production
MIX_ENV=prod mix run priv/repo/seeds/assign_roles.exs

# Docker
docker exec -it podcodar bin/podcodar eval "Code.eval_file(\"priv/repo/seeds/assign_roles.exs\")"
```

### 🚨 Rollback (Se Necessário) / Rollback (If Needed)

Se algo der errado, você pode reverter a migração:
If something goes wrong, you can rollback the migration:

```bash
# Reverter última migração / Rollback last migration
mix ecto.rollback

# ou Docker / or Docker
docker exec -it podcodar bin/podcodar eval "Podcodar.Release.rollback"
```

**Nota:** O rollback removerá a coluna `role`. Não afetará outras funcionalidades.
**Note:** The rollback will remove the `role` column. It won't affect other functionalities.

### 📝 Checklist de Migração / Migration Checklist

- [ ] Backup do banco de dados realizado / Database backup done
- [ ] Código atualizado (git pull) / Code updated (git pull)
- [ ] Dependências instaladas / Dependencies installed
- [ ] Aplicação compilada / Application compiled
- [ ] Migração executada / Migration executed
- [ ] Migração verificada / Migration verified
- [ ] Admins atribuídos / Admins assigned
- [ ] Entrevistadores atribuídos / Interviewers assigned
- [ ] Roles verificadas / Roles verified
- [ ] Aplicação reiniciada / Application restarted
- [ ] Funcionalidades testadas / Features tested

### 🧪 Testando em Produção / Testing in Production

Após a migração, teste as seguintes funcionalidades:
After migration, test the following features:

1. **Login como membro** / **Login as member**
   - ✓ Deve acessar páginas normais / Should access normal pages
   - ✓ Não deve acessar /admin / Should not access /admin
   - ✓ Não deve acessar /interviews / Should not access /interviews

2. **Login como entrevistador** / **Login as interviewer**
   - ✓ Deve acessar páginas normais / Should access normal pages
   - ✓ Deve acessar /interviews / Should access /interviews
   - ✓ Não deve acessar /admin / Should not access /admin

3. **Login como admin** / **Login as admin**
   - ✓ Deve acessar todas as páginas / Should access all pages
   - ✓ Deve acessar /admin / Should access /admin
   - ✓ Deve acessar /interviews / Should access /interviews

### 🔐 Segurança / Security

- ✓ A coluna `role` tem índice para performance
- ✓ Validação no nível da aplicação (apenas 3 roles válidas)
- ✓ Valor padrão seguro ("member")
- ✓ Sem possibilidade de SQL injection
- ✓ Mensagens de erro consistentes

### 📞 Suporte / Support

Se encontrar problemas durante a migração:
If you encounter problems during migration:

1. Verifique os logs / Check the logs
2. Reverta a migração se necessário / Rollback if needed
3. Abra uma issue no GitHub
4. Entre em contato com a equipe / Contact the team

### 🔄 Após a Migração / After Migration

1. **Documentar**: Anote quais usuários têm cada role
   **Document**: Note which users have each role

2. **Monitorar**: Observe logs de acesso negado
   **Monitor**: Watch for access denied logs

3. **Treinar**: Informe a equipe sobre as novas roles
   **Train**: Inform team about new roles

4. **Iterar**: Ajuste roles conforme necessário
   **Iterate**: Adjust roles as needed

### 💡 Dicas / Tips

- Comece com poucos admins e adicione conforme necessário
  Start with few admins and add as needed

- Entrevistadores podem ser promovidos de membros
  Interviewers can be promoted from members

- Roles podem ser alteradas a qualquer momento
  Roles can be changed at any time

- Considere criar uma UI de admin para gerenciar roles
  Consider creating an admin UI to manage roles

### 📊 Exemplo de Distribuição / Distribution Example

Sugestão para uma comunidade de 100 usuários:
Suggestion for a community of 100 users:

- **90 members** (90%) - Usuários regulares / Regular users
- **8 interviewers** (8%) - Voluntários fazendo entrevistas / Volunteers doing interviews
- **2 admins** (2%) - Administradores da plataforma / Platform administrators

### ✅ Conclusão / Conclusion

A migração é segura e não invasiva. Todos os usuários existentes continuam funcionando normalmente como "member" após a migração.

The migration is safe and non-invasive. All existing users continue working normally as "member" after migration.
