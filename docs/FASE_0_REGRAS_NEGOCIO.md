# Fase 0 - Regras de Negócio por Contexto

## Nota Importante
Este sistema será uma **API REST/GraphQL** para consumo no frontend Next.js. Todas as regras de negócio serão validadas na API antes de retornar respostas.

---

## 1. Auth & RBAC (Autenticação e Controle de Acesso)

### Regras de Criação
- **Workspace**: Apenas `superadmin` pode criar workspaces
- **User**: `superadmin` e `workspace_admin` podem criar usuários
- **Role**: Apenas `superadmin` pode criar/modificar roles

### Regras de Edição
- **Próprio Perfil**: Qualquer usuário pode editar seu próprio perfil (exceto email e role)
- **Outros Usuários**: Apenas `superadmin` e `workspace_admin` do mesmo workspace
- **Workspace Settings**: Apenas `superadmin` e `workspace_admin` do workspace

### Regras de Publicação/Acesso
- **Login**: Qualquer usuário ativo pode fazer login
- **Acesso ao Workspace**: Usuário deve estar associado ao workspace
- **Refresh Token**: Válido por 7 dias, renovável

### Regras RBAC (Role-Based Access Control)
- **superadmin**: Acesso total ao sistema, todos os workspaces
- **workspace_admin**: Acesso total ao workspace específico
- **editor**: Pode criar, editar e publicar conteúdo no workspace
- **author**: Pode criar e editar apenas próprio conteúdo, não pode publicar

### Regras ABAC (Attribute-Based Access Control)
- **Workspace Context**: Permissões são válidas apenas no workspace do usuário
- **Site Context**: Editor pode editar apenas sites do workspace
- **Content Context**: Author pode editar apenas conteúdo próprio
- **Feature Flags**: Permissões podem ser alteradas por feature flags por workspace/site

### Regras de Exclusão
- **User**: Não pode ser deletado se for único admin do workspace
- **Workspace**: Não pode ser deletado se tiver sites ativos
- **Role**: Não pode ser deletado se estiver em uso

---

## 2. CMS Content (Conteúdo do CMS)

### Regras de Criação
- **Page**: `editor` e `author` podem criar páginas
- **Post**: `editor` e `author` podem criar posts
- **Section**: Apenas `editor` pode criar sections globais
- **Collection**: Apenas `workspace_admin` e `editor` podem criar coleções

### Regras de Edição
- **Page**: 
  - `editor` pode editar qualquer página
  - `author` pode editar apenas próprias páginas
- **Post**:
  - `editor` pode editar qualquer post
  - `author` pode editar apenas próprios posts
- **Section Global**: Apenas `editor` pode editar
- **Section Local**: Quem pode editar a página pode editar a section

### Regras de Publicação
- **Page**: Apenas `editor` e `workspace_admin` podem publicar
- **Post**: Apenas `editor` e `workspace_admin` podem publicar
- **Author**: Não pode publicar, apenas salvar como draft
- **Publicação Automática**: Pode ser agendada por `editor`

### Regras de Versionamento
- **Snapshot Automático**: Criado automaticamente antes de qualquer edição
- **Rollback**: Apenas `editor` e `workspace_admin` podem fazer rollback
- **Histórico**: Mantido por 30 dias (configurável)

### Regras de Exclusão
- **Page Publicada**: Não pode ser deletada, apenas arquivada
- **Post Publicado**: Não pode ser deletado, apenas arquivado
- **Section Global**: Não pode ser deletada se estiver em uso
- **Collection**: Não pode ser deletada se tiver posts

---

## 3. Page Builder

### Regras de Criação
- **Component**: Apenas `editor` pode criar componentes customizados
- **Template**: Apenas `workspace_admin` e `editor` podem criar templates

### Regras de Edição
- **Page Builder**: Quem pode editar a página pode usar o builder
- **Componentes**: Componentes padrão não podem ser modificados
- **Componentes Custom**: Podem ser modificados pelo criador ou `editor`

### Regras de Validação
- **Schema JSON**: Deve ser válido antes de salvar
- **Componentes**: Devem seguir schema definido
- **Preview**: Validação em tempo real via WebSocket

### Regras de Renderização
- **Server-Side**: Renderização via Next.js no servidor
- **Preview**: Preview em tempo real via WebSocket
- **Publicação**: Renderização final ao publicar

---

## 4. Media Management

### Regras de Upload
- **Tamanho Máximo**: 10MB por arquivo (configurável por workspace)
- **Tipos Permitidos**: image/*, application/pdf, video/* (configurável)
- **Validação MIME**: Tipo MIME deve corresponder à extensão
- **Sanitização**: Nome do arquivo sanitizado automaticamente

### Regras de Acesso
- **Workspace**: Usuário só acessa mídia do próprio workspace
- **Site**: Mídia pode ser restrita a um site específico
- **Pública**: Mídia pode ser marcada como pública (acessível sem auth)

### Regras de Conversão
- **Imagens**: Conversão automática para WebP e thumbnails
- **Vídeos**: Geração automática de thumbnail
- **Versionamento**: Versões mantidas por 90 dias

### Regras de Exclusão
- **Em Uso**: Mídia em uso não pode ser deletada
- **Versões Antigas**: Versões antigas podem ser deletadas automaticamente
- **Workspace**: Apenas `workspace_admin` pode deletar mídia do workspace

---

## 5. Plugin System

### Regras de Instalação
- **Apenas superadmin**: Pode instalar plugins
- **Validação**: Plugin deve passar validação de segurança
- **Ativação**: Plugin deve ser ativado por `workspace_admin` ou `superadmin`

### Regras de Uso
- **Hooks**: Plugins podem registrar hooks em pontos específicos
- **Endpoints**: Plugins podem criar endpoints customizados
- **Permissões**: Plugins respeitam RBAC/ABAC do sistema

### Regras de Desativação
- **Dependências**: Plugin não pode ser desativado se houver dependências
- **Dados**: Dados do plugin são mantidos após desativação
- **Reativação**: Plugin pode ser reativado sem perder dados

---

## 6. Analytics / Observability

### Regras de Logging
- **Audit Log**: Todas ações críticas geram log automático
- **Retenção**: Logs mantidos por 1 ano (configurável)
- **Acesso**: Apenas `superadmin` e `workspace_admin` podem ver logs

### Regras de Métricas
- **Coleta Automática**: Métricas coletadas automaticamente
- **Acesso**: Dashboard de métricas acessível por `workspace_admin`
- **Alertas**: Alertas configuráveis por `workspace_admin`

### Regras de Tracing
- **Requests Críticos**: Tracing automático para operações críticas
- **Performance**: Tracing de performance para otimização
- **Acesso**: Apenas `superadmin` pode acessar traces completos

---

## 7. SEO (Search Engine Optimization)

### Regras de Configuração
- **Page SEO**: Cada página pode ter SEO próprio
- **Post SEO**: Cada post pode ter SEO próprio
- **Site SEO**: Configurações padrão por site

### Regras de Validação
- **Meta Title**: Máximo 60 caracteres (recomendado)
- **Meta Description**: Máximo 160 caracteres (recomendado)
- **Slug**: Deve ser único por site
- **Canonical URL**: Deve ser URL absoluta válida

### Regras de Geração
- **Sitemap**: Gerado automaticamente para cada site
- **Robots.txt**: Gerado automaticamente por site
- **Schema.org**: JSON-LD gerado automaticamente

---

## 8. Workspace & Tenant

### Regras de Criação
- **Workspace**: Apenas `superadmin` pode criar
- **Project**: `workspace_admin` e `editor` podem criar
- **Site**: `workspace_admin` e `editor` podem criar

### Regras de Isolamento
- **Dados**: Dados completamente isolados entre workspaces
- **Acesso**: Usuário só acessa dados do workspace associado
- **Configurações**: Cada workspace tem configurações próprias

### Regras de Exclusão
- **Workspace**: Não pode ser deletado se tiver sites ativos
- **Project**: Não pode ser deletado se tiver sites ativos
- **Site**: Não pode ser deletado se tiver páginas publicadas (apenas arquivar)

---

## 9. Themes & Sections

### Regras de Aplicação
- **Tema por Site**: Um site tem um tema ativo
- **Mudança de Tema**: Não afeta conteúdo existente
- **Sections Globais**: Aplicadas automaticamente em todas as páginas

### Regras de Criação
- **Theme**: Apenas `workspace_admin` pode criar temas
- **Section Global**: Apenas `editor` pode criar
- **Section Local**: Quem pode editar página pode criar

### Regras de Exclusão
- **Tema em Uso**: Tema não pode ser deletado se estiver em uso
- **Section Global**: Não pode ser deletada se estiver em uso

---

## 10. Forms Builder

### Regras de Criação
- **Form**: `editor` e `author` podem criar formulários
- **Validações**: Validações customizadas podem ser definidas

### Regras de Submissão
- **Público**: Formulários podem ser públicos (sem auth)
- **Privado**: Formulários podem requerer autenticação
- **Rate Limiting**: Máximo 10 submissões por IP/hora

### Regras de Acesso a Dados
- **Submissões**: Apenas `editor` e `workspace_admin` podem ver submissões
- **Exportação**: Apenas `workspace_admin` pode exportar dados

---

## Regras Gerais Aplicáveis a Todos os Contextos

### Validação de Dados
- Todos os dados de entrada são validados antes de processar
- Value Objects validam seus próprios valores
- JSON schemas são validados antes de salvar

### Auditoria
- Todas ações críticas geram audit log
- Log inclui: usuário, workspace, site, ação, timestamp, dados

### Performance
- Queries otimizadas com eager loading
- Cache para dados frequentemente acessados
- Paginação em todas listagens

### Segurança
- Sanitização de todos inputs
- Validação de permissões em todas operações
- Rate limiting em endpoints públicos
- CORS configurado adequadamente

---

## Nota sobre API

Todas essas regras serão implementadas e validadas na **API REST/GraphQL**:
- Validações retornam erros HTTP apropriados (400, 403, 404, etc.)
- Respostas incluem informações sobre permissões quando aplicável
- Endpoints seguem padrões RESTful com códigos de status corretos

