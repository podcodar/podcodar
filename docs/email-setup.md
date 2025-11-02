# Email Setup Guide

Este documento descreve como configurar e testar o sistema de email do PodCodar.

## Visão Geral

O PodCodar usa **Resend** como provedor de email em produção e **Swoosh Local Adapter** para desenvolvimento (mailbox preview). O sistema suporta diferentes configurações dependendo do ambiente e variáveis de ambiente definidas.

## Configuração de Email

### Arquivos de Configuração

- `config/config.exs` - Configuração base (Local adapter como padrão)
- `config/dev.exs` - Configuração de desenvolvimento
- `config/runtime.exs` - Configuração em runtime (produção e desenvolvimento opcional)
- `lib/podcodar/accounts/user_notifier.ex` - Módulo que envia os emails

### Adaptadores por Ambiente

| Ambiente | Adapter Padrão | Como Mudar |
|----------|---------------|------------|
| **Desenvolvimento** | `Swoosh.Adapters.Local` | Definir `RESEND_API_KEY` para usar Resend |
| **Teste** | `Swoosh.Adapters.Test` | Não envia emails reais |
| **Produção** | `Resend.Swoosh.Adapter` | Requer `RESEND_API_KEY` |

## Como Testar

### Opção 1: Testar com Mailbox Local (Padrão em Desenvolvimento)

Esta é a forma mais simples de testar sem enviar emails reais.

```bash
# Inicie o servidor normalmente
mix phx.server

# Acesse o mailbox preview em:
# http://localhost:4000/dev/mailbox
```

**Comportamento:**
- Todos os emails são capturados e exibidos no mailbox preview
- Nenhum email real é enviado
- Perfeito para desenvolvimento e testes locais
- Não requer configuração adicional

### Opção 2: Testar com Resend em Desenvolvimento

Para testar emails reais do Resend antes de fazer deploy em produção:

```bash
# 1. Exporte a API key do Resend
export RESEND_API_KEY=sua_api_key_aqui

# 2. Opcionalmente, configure o endereço de envio
export EMAIL_FROM_ADDRESS=noreply@seudominio.com
export EMAIL_FROM_NAME="PodCodar"

# 3. Inicie o servidor
mix phx.server
```

**Comportamento:**
- Emails são enviados pelo Resend de verdade
- Útil para testar formato, deliverability e integração antes do deploy
- Requer API key válida do Resend
- O endereço precisa estar verificado no Resend

**Nota:** Para voltar ao mailbox local, simplesmente remova a variável `RESEND_API_KEY`:
```bash
unset RESEND_API_KEY
mix phx.server
```

#### Como Funciona: RESEND_API_KEY em Desenvolvimento

O sistema detecta automaticamente se `RESEND_API_KEY` está definida em desenvolvimento através de `config/runtime.exs`:

```elixir
if config_env() == :dev do
  if System.get_env("RESEND_API_KEY") do
    # Usa Resend adapter
    config :podcodar, Podcodar.Mailer,
      adapter: Resend.Swoosh.Adapter
  else
    # Usa Local adapter (mailbox preview)
    config :podcodar, Podcodar.Mailer,
      adapter: Swoosh.Adapters.Local
  end
end
```

**Comportamento:**
- Se `RESEND_API_KEY` **não estiver definida**: usa mailbox local (`/dev/mailbox`)
- Se `RESEND_API_KEY` **estiver definida**: usa Resend e envia emails reais

**Dica:** Você pode definir `RESEND_API_KEY` usando um arquivo `.env` ou exportando diretamente no terminal. O sistema detecta automaticamente qual adapter usar em runtime. Veja mais detalhes sobre ordem de configuração em `docs/configs.md`.

### Opção 3: Testar em Produção

Após fazer deploy, configure as variáveis de ambiente no Fly.io:

```bash
# Configure as variáveis secretas no Fly.io
fly secrets set RESEND_API_KEY=sua_api_key_aqui
fly secrets set EMAIL_FROM_ADDRESS=noreply@seudominio.com
fly secrets set EMAIL_FROM_NAME="PodCodar"

# Faça deploy
fly deploy

# Teste o envio de emails fazendo login/registro
```

## Variáveis de Ambiente

### Obrigatórias (Produção)

- `RESEND_API_KEY` - API key do Resend para envio de emails

### Opcionais

- `EMAIL_FROM_ADDRESS` - Endereço de email do remetente (padrão: `contact@example.com`)
- `EMAIL_FROM_NAME` - Nome do remetente (padrão: `Podcodar`)

## Configuração do Resend

### 1. Criar Conta no Resend

1. Acesse [resend.com](https://resend.com)
2. Crie uma conta ou faça login
3. Obtenha sua API key na dashboard

### 2. Verificar Domínio

Para enviar emails em produção, você precisa verificar seu domínio:

1. No dashboard do Resend, vá em **Domains**
2. Adicione seu domínio (ex: `podcodar.com`)
3. Configure os registros DNS conforme instruções
4. Aguarde a verificação

### 3. Configurar API Key

**Em Desenvolvimento (para testes):**
```bash
export RESEND_API_KEY=re_xxxxxxxxxxxxx
```

**Em Produção (Fly.io):**
```bash
fly secrets set RESEND_API_KEY=re_xxxxxxxxxxxxx
```

## Tipos de Email Enviados

O sistema envia os seguintes tipos de email:

1. **Confirmation Instructions** - Confirmação de conta para novos usuários
2. **Login Instructions** - Magic link para login sem senha
3. **Update Email Instructions** - Instruções para atualizar email

Todos os emails são enviados através do módulo `Podcodar.Accounts.UserNotifier`.

## Troubleshooting

### Emails não aparecem no mailbox local

- Verifique se não há `RESEND_API_KEY` definida
- Confirme que está acessando `http://localhost:4000/dev/mailbox`
- Reinicie o servidor após remover variáveis de ambiente

### Erro ao enviar com Resend

- Verifique se a `RESEND_API_KEY` está correta
- Confirme que o domínio está verificado no Resend
- Verifique os logs do servidor para mais detalhes
- Teste com um endereço de email verificado no Resend

### Emails indo para spam

- Verifique as configurações de SPF/DKIM no Resend
- Configure corretamente o `EMAIL_FROM_ADDRESS` com domínio verificado
- Evite usar domínios como `example.com` em produção

## Fluxo de Configuração Recomendado

1. **Desenvolvimento Inicial**: Use mailbox local (sem configuração)
2. **Teste Local com Resend**: Configure `RESEND_API_KEY` para testar integração
3. **Verificação de Domínio**: Configure DNS no Resend antes do deploy
4. **Deploy em Produção**: Configure secrets no Fly.io e teste

## Segurança

- **Nunca** commite API keys no código
- Use sempre variáveis de ambiente para credenciais
- O mailbox preview (`/dev/mailbox`) está **desabilitado em produção** automaticamente
- Mantenha suas API keys seguras e rotacione-as periodicamente

## Referências

- [Resend Documentation](https://resend.com/docs)
- [Swoosh Documentation](https://hexdocs.pm/swoosh)
- [Phoenix Email Guide](https://hexdocs.pm/phoenix/emails.html)