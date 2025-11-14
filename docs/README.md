# Documentação do Podcodar / Podcodar Documentation

Bem-vindo à documentação técnica do Podcodar! 
Welcome to Podcodar's technical documentation!

## 📚 Índice / Table of Contents

### 🔐 Sistema de Controle de Acesso (RBAC) / Access Control System

O Podcodar implementa um sistema de controle de acesso baseado em funções (RBAC) com três níveis:
Podcodar implements a role-based access control (RBAC) system with three levels:

- **[RBAC - Guia Completo (PT-BR)](rbac.md)** 
  Guia detalhado sobre como usar o sistema RBAC em português
  
- **[RBAC - Complete Guide (EN)](../specs/rbac.md)**
  Detailed guide on how to use the RBAC system in English

- **[RBAC - Arquitetura](rbac-architecture.md)**
  Diagramas de componentes e fluxos de autorização
  Component diagrams and authorization flows

- **[RBAC - Referência Rápida](rbac-quick-reference.md)**
  Guia de referência rápida bilíngue para desenvolvedores
  Bilingual quick reference guide for developers

- **[RBAC - Guia de Migração](rbac-migration-guide.md)**
  Passo a passo para implantar RBAC em produção
  Step-by-step guide to deploy RBAC in production

#### Funções Disponíveis / Available Roles

| Role | Descrição PT | Description EN |
|------|--------------|----------------|
| `member` | Membro regular da comunidade | Regular community member |
| `interviewer` | Voluntário que conduz entrevistas | Volunteer who conducts interviews |
| `admin` | Administrador com acesso completo | Administrator with full access |

---

### 🔧 Configuração e Setup / Configuration and Setup

- **[Configurações](configs.md)**
  Configuração do ambiente e variáveis
  Environment and variables configuration

- **[Configuração de Email](email-setup.md)**
  Setup do sistema de emails
  Email system setup

---

### 🚀 CI/CD e Deploy / CI/CD and Deployment

- **[Pipelines de CI](ci_pipelines.md)**
  Configuração dos pipelines de integração contínua
  Continuous integration pipeline configuration

---

### 🤝 Contribuindo / Contributing

- **[Guia de Contribuição](contributing-guidelines.md)**
  Como contribuir para o projeto
  How to contribute to the project

---

## 🔍 Encontrando Documentação / Finding Documentation

### Por Tópico / By Topic

#### Autenticação e Autorização / Authentication and Authorization
- RBAC (Controle de Acesso) → [rbac.md](rbac.md)
- Email de Login → [email-setup.md](email-setup.md)

#### Desenvolvimento / Development
- Guia Rápido RBAC → [rbac-quick-reference.md](rbac-quick-reference.md)
- Contribuindo → [contributing-guidelines.md](contributing-guidelines.md)

#### Operações / Operations
- Deploy RBAC → [rbac-migration-guide.md](rbac-migration-guide.md)
- Pipelines CI → [ci_pipelines.md](ci_pipelines.md)
- Configurações → [configs.md](configs.md)

#### Arquitetura / Architecture
- Arquitetura RBAC → [rbac-architecture.md](rbac-architecture.md)

---

## 🆕 Últimas Adições / Latest Additions

### Sistema RBAC (Novembro 2024)

Um sistema completo de controle de acesso baseado em funções foi adicionado ao Podcodar:

A complete role-based access control system was added to Podcodar:

- ✅ Migração de banco de dados segura
- ✅ Três funções: member, interviewer, admin
- ✅ Plugs e callbacks para autorização
- ✅ Testes abrangentes
- ✅ Documentação completa em PT e EN

Features:
- ✅ Safe database migration
- ✅ Three roles: member, interviewer, admin
- ✅ Plugs and callbacks for authorization
- ✅ Comprehensive tests
- ✅ Complete documentation in PT and EN

**Começar com RBAC:** [rbac-quick-reference.md](rbac-quick-reference.md)
**Get started with RBAC:** [rbac-quick-reference.md](rbac-quick-reference.md)

---

## 📖 Documentação Adicional / Additional Documentation

Para documentação específica em inglês, consulte a pasta `specs/`:
For English-specific documentation, check the `specs/` folder:

- [../specs/rbac.md](../specs/rbac.md) - RBAC Complete Guide (English)

---

## 🆘 Precisa de Ajuda? / Need Help?

1. Verifique a documentação relevante acima
   Check the relevant documentation above

2. Procure por issues existentes no GitHub
   Search for existing issues on GitHub

3. Abra uma nova issue se necessário
   Open a new issue if needed

4. Entre no Discord da comunidade Podcodar
   Join the Podcodar community Discord

---

## 🔄 Atualizando Documentação / Updating Documentation

Ao adicionar nova funcionalidade:
When adding new functionality:

1. ✅ Adicione documentação técnica em `docs/` (PT-BR)
2. ✅ Adicione especificação em `specs/` (EN) se aplicável
3. ✅ Atualize este README se for uma funcionalidade importante
4. ✅ Inclua exemplos de código
5. ✅ Adicione diagramas se apropriado

---

**Última atualização / Last updated:** Novembro 2024
