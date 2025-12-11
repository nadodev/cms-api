# Fase 0 - Bounded Contexts Definidos

## Bounded Contexts do Sistema CMS

### 1. Auth & RBAC (Autenticação e Controle de Acesso)
**Responsabilidade**: Gerenciar autenticação, autorização e controle de acesso

**Entidades Principais**:
- User
- Role
- Permission
- WorkspaceUser (relação many-to-many)

**Value Objects**:
- UserId
- Email
- RoleName
- PermissionName

**Regras de Negócio**:
- Usuário pode pertencer a múltiplos workspaces
- Cada workspace tem seu próprio conjunto de roles
- RBAC define permissões fixas por role
- ABAC aplica regras contextuais (workspace_id, site_id)

**Interfaces (Ports)**:
- UserRepositoryInterface
- RoleRepositoryInterface
- PermissionServiceInterface

---

### 2. CMS Content (Conteúdo do CMS)
**Responsabilidade**: Gerenciar todo conteúdo editorial (Pages, Posts, Sections)

**Entidades Principais**:
- Page
- Post
- Collection (tipo de post)
- Section
- PageSnapshot (versionamento)

**Value Objects**:
- PageId
- PageSlug
- PostId
- ContentStatus (draft, published, archived)
- PageContent (JSON)

**Regras de Negócio**:
- Páginas pertencem a um site
- Posts pertencem a uma coleção e um site
- Sections podem ser globais ou por página
- Versionamento automático em mudanças
- Apenas editores podem publicar

**Interfaces (Ports)**:
- PageRepositoryInterface
- PostRepositoryInterface
- SectionRepositoryInterface
- PageSnapshotRepositoryInterface

---

### 3. Page Builder
**Responsabilidade**: Editor visual e renderização de páginas

**Entidades Principais**:
- Component (componentes do builder)
- ComponentSchema (definição JSON)
- PageTemplate

**Value Objects**:
- ComponentType
- ComponentConfig (JSON)
- BuilderSchema

**Regras de Negócio**:
- Componentes seguem schema JSON definido
- Preview em tempo real via WebSocket
- Renderização server-side via Next.js
- Validação de estrutura antes de salvar

**Interfaces (Ports)**:
- ComponentRepositoryInterface
- PageRenderServiceInterface
- PreviewServiceInterface

---

### 4. Media Management
**Responsabilidade**: Upload, armazenamento e gerenciamento de arquivos de mídia

**Entidades Principais**:
- MediaItem
- MediaVersion
- MediaFolder

**Value Objects**:
- MediaId
- MediaPath
- MediaType
- FileSize
- MimeType

**Regras de Negócio**:
- Upload com validação de MIME type e tamanho
- Conversão automática (thumbnails, WebP)
- Versionamento de arquivos
- Organização por pastas/categorias
- Políticas de segurança (sanitização)

**Interfaces (Ports)**:
- MediaRepositoryInterface
- MediaStorageServiceInterface
- MediaConversionServiceInterface

---

### 5. Plugin System
**Responsabilidade**: Sistema de extensões e plugins

**Entidades Principais**:
- Plugin
- PluginHook
- PluginConfig

**Value Objects**:
- PluginId
- PluginName
- HookName
- PluginVersion

**Regras de Negócio**:
- Plugins podem registrar novos tipos de conteúdo
- Hooks permitem extensão de funcionalidades
- Plugins podem criar endpoints customizados
- Validação de segurança antes de ativar

**Interfaces (Ports)**:
- PluginRepositoryInterface
- PluginRegistryInterface
- HookDispatcherInterface

---

### 6. Analytics / Observability
**Responsabilidade**: Logs, métricas, rastreamento e auditoria

**Entidades Principais**:
- AuditLog
- Metric
- ErrorLog
- Trace

**Value Objects**:
- LogLevel
- MetricName
- TraceId
- Timestamp

**Regras de Negócio**:
- Todas ações críticas geram audit log
- Logs estruturados para análise
- Métricas coletadas automaticamente
- Tracing distribuído para requests

**Interfaces (Ports)**:
- AuditLogRepositoryInterface
- MetricsServiceInterface
- LoggingServiceInterface

---

### 7. SEO (Search Engine Optimization)
**Responsabilidade**: Otimização para mecanismos de busca

**Entidades Principais**:
- PageSEO
- Sitemap
- RobotsConfig

**Value Objects**:
- MetaTitle
- MetaDescription
- CanonicalUrl
- OpenGraphData
- SchemaOrgData

**Regras de Negócio**:
- Cada página tem configuração SEO própria
- Validação de comprimento de meta tags
- Geração automática de sitemap
- Schema.org JSON-LD por página

**Interfaces (Ports)**:
- SEORepositoryInterface
- SitemapServiceInterface
- SEOServiceInterface

---

### 8. Workspace & Tenant
**Responsabilidade**: Multi-tenancy e isolamento de dados

**Entidades Principais**:
- Workspace
- Project
- Site

**Value Objects**:
- WorkspaceId
- ProjectId
- SiteId
- Domain
- WorkspaceName

**Regras de Negócio**:
- Workspace isola completamente dados
- Project agrupa sites relacionados
- Site tem domínio próprio
- Isolamento total entre workspaces

**Interfaces (Ports)**:
- WorkspaceRepositoryInterface
- ProjectRepositoryInterface
- SiteRepositoryInterface

---

### 9. Themes & Sections
**Responsabilidade**: Templates e componentes reutilizáveis

**Entidades Principais**:
- Theme
- Section
- SectionTemplate

**Value Objects**:
- ThemeId
- ThemeName
- SectionId
- SectionType

**Regras de Negócio**:
- Um site tem um tema ativo
- Sections podem ser globais ou locais
- Templates são reutilizáveis
- Aplicação de tema não afeta conteúdo existente

**Interfaces (Ports)**:
- ThemeRepositoryInterface
- SectionRepositoryInterface

---

### 10. Forms Builder
**Responsabilidade**: Criação e gerenciamento de formulários

**Entidades Principais**:
- Form
- FormField
- FormSubmission

**Value Objects**:
- FormId
- FieldType
- ValidationRule
- FormSchema (JSON)

**Regras de Negócio**:
- Forms têm estrutura JSON
- Validações customizadas por campo
- Submissões podem ir para banco ou fila
- Versionamento de formulários

**Interfaces (Ports)**:
- FormRepositoryInterface
- FormSubmissionRepositoryInterface

