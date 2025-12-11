# Fase 0 - Mapeamento do Domínio Principal

## 1. Domínio Principal Mapeado

### Workspaces
- **Descrição**: Espaços de trabalho isolados que agrupam usuários, projetos e sites
- **Características**: Multi-tenant, isolamento de dados, configurações próprias
- **Relacionamentos**: Um workspace tem muitos usuários, projetos e sites

### Projects
- **Descrição**: Agrupamento lógico de sites relacionados
- **Características**: Organiza sites por cliente, marca ou propósito
- **Relacionamentos**: Pertence a um workspace, contém muitos sites

### Sites
- **Descrição**: Instâncias de websites gerenciados pelo CMS
- **Características**: Domínio próprio, configurações de tema, SEO, conteúdo
- **Relacionamentos**: Pertence a um project, tem muitas páginas, posts, mídia

### Users e Roles (RBAC)
- **Descrição**: Usuários do sistema com diferentes níveis de acesso
- **Roles Fixos**:
  - `superadmin`: Acesso total ao sistema
  - `workspace_admin`: Administrador de workspace específico
  - `editor`: Pode editar e publicar conteúdo
  - `author`: Pode criar e editar próprio conteúdo
- **Características**: Multi-workspace, permissões contextuais (ABAC)
- **Relacionamentos**: Usuário pertence a muitos workspaces, tem um role por workspace

### Pages
- **Descrição**: Páginas estáticas do site
- **Características**: Estrutura JSON (Page Builder), versionamento, SEO, status (draft/published)
- **Relacionamentos**: Pertence a um site, pode ter muitas seções, mídia associada

### Posts / Coleções
- **Descrição**: Conteúdo dinâmico (blog, cursos, eventos, etc.)
- **Características**: Tipos de coleção configuráveis, categorias, tags, status
- **Relacionamentos**: Pertence a um site, pode ter mídia associada

### Sections
- **Descrição**: Blocos reutilizáveis (header, footer, blocos customizáveis)
- **Características**: Estrutura JSON, podem ser globais ou por página
- **Relacionamentos**: Pertence a um site, pode ser usado em muitas páginas

### Media
- **Descrição**: Arquivos de mídia (imagens, PDFs, vídeos)
- **Características**: Upload, versionamento, conversão (thumbnails, WebP), metadados
- **Relacionamentos**: Pertence a um workspace/site, associado a páginas/posts

### Themes
- **Descrição**: Templates base para sites
- **Características**: Configurações de estilo, componentes padrão, aplicação por site
- **Relacionamentos**: Um site tem um tema ativo

### Forms
- **Descrição**: Formulários criados com Form Builder
- **Características**: Estrutura JSON, validações customizadas, submissões
- **Relacionamentos**: Pertence a um site, pode estar em páginas

### Plugins
- **Descrição**: Extensões do sistema
- **Características**: Registrar novos tipos de conteúdo, widgets, hooks, endpoints
- **Relacionamentos**: Pode estender qualquer módulo do sistema

