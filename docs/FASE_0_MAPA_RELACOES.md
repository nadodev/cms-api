# Fase 0 - Mapa de Relações (Diagrama Entidade-Relacionamento)

## Nota Importante
Este sistema será uma **API REST/GraphQL** para consumo no frontend Next.js. Todos os relacionamentos serão expostos via endpoints da API.

---

## Diagrama de Relações

```
┌─────────────────┐
│   Workspace     │
│  (Aggregate)    │
│────────────────│
│ id              │
│ name            │
│ slug            │
│ settings (JSON) │
└────────┬────────┘
         │ 1
         │
         │ N
┌────────▼────────┐         ┌─────────────────┐
│ WorkspaceUser   │         │      User        │
│  (Join Table)   │         │   (Aggregate)    │
│─────────────────│         │─────────────────│
│ workspace_id    │─────────▶│ id               │
│ user_id         │     N    │ email            │
│ role            │         │ name              │
│ permissions     │         │ password_hash     │
└─────────────────┘         │ profile (JSON)   │
                             └─────────────────┘

┌─────────────────┐
│   Workspace     │
└────────┬────────┘
         │ 1
         │
         │ N
┌────────▼────────┐
│    Project      │
│  (Aggregate)    │
│─────────────────│
│ id              │
│ workspace_id    │
│ name            │
│ slug            │
│ settings (JSON) │
└────────┬────────┘
         │ 1
         │
         │ N
┌────────▼────────┐
│      Site       │
│  (Aggregate)    │
│─────────────────│
│ id              │
│ project_id     │
│ theme_id       │
│ domain         │
│ name           │
│ status         │
│ settings (JSON)│
└────┬───────┬────┘
     │ 1     │ 1
     │       │
     │ N     │ 1
┌────▼───┐ ┌─▼──────────┐
│  Page  │ │   Theme    │
│(Agg)   │ │  (Agg)     │
│────────│ │────────────│
│ id     │ │ id         │
│site_id │ │ name       │
│slug    │ │ version    │
│title   │ │ config(JSON)│
│content │ │            │
│status  │ │            │
│seo_id  │ │            │
└────┬───┘ └────────────┘
     │ 1
     │
     │ N
┌────▼──────────────┐
│  PageSEO          │
│───────────────────│
│ id                │
│ page_id           │
│ meta_title        │
│ meta_description  │
│ og_image          │
│ canonical_url     │
│ schema_json       │
└───────────────────┘

┌───────┐
│  Site │
└───┬───┘
    │ 1
    │
    │ N
┌───▼────────┐         ┌──────────────┐
│    Post    │         │  Collection  │
│  (Agg)     │         │──────────────│
│────────────│         │ id           │
│ id         │         │ site_id      │
│ site_id    │         │ name         │
│collection_id│────────▶│ type         │
│ slug       │         │ config (JSON)│
│ title      │         └──────────────┘
│ content    │
│ status     │
│ published_at│
│ seo_id     │
└────┬───────┘
     │ 1
     │
     │ N
┌────▼──────────┐
│  PostSEO      │
│───────────────│
│ id            │
│ post_id       │
│ meta_title    │
│ meta_description│
│ og_image      │
│ canonical_url │
│ schema_json   │
└───────────────┘

┌───────┐
│  Site │
└───┬───┘
    │ 1
    │
    │ N
┌───▼────────┐
│  Section   │
│  (Agg)     │
│────────────│
│ id         │
│ site_id    │
│ type       │
│ name       │
│ content(JSON)│
│ is_global  │
└────────────┘

┌───────┐
│Workspace│
└───┬───┘
    │ 1
    │
    │ N
┌───▼──────────┐
│  MediaItem   │
│   (Agg)      │
│──────────────│
│ id           │
│ workspace_id │
│ site_id      │
│ path         │
│ url          │
│ type         │
│ mime_type    │
│ size         │
│ metadata(JSON)│
└────┬─────────┘
     │ 1
     │
     │ N
┌────▼──────────┐
│ MediaVersion  │
│───────────────│
│ id            │
│ media_id      │
│ version       │
│ path          │
│ url           │
│ created_at    │
└───────────────┘

┌───────┐
│  Site │
└───┬───┘
    │ 1
    │
    │ N
┌───▼────────┐
│    Form    │
│   (Agg)    │
│────────────│
│ id         │
│ site_id    │
│ name       │
│ schema(JSON)│
│ status     │
└────┬───────┘
     │ 1
     │
     │ N
┌────▼────────────┐
│  FormField       │
│──────────────────│
│ id               │
│ form_id          │
│ name             │
│ type             │
│ validation_rules │
│ order            │
└──────────────────┘

┌───────┐
│  Form │
└───┬───┘
    │ 1
    │
    │ N
┌───▼──────────────┐
│ FormSubmission   │
│──────────────────│
│ id               │
│ form_id          │
│ data (JSON)      │
│ submitted_at     │
│ ip_address       │
└──────────────────┘

┌───────┐
│  Page │
└───┬───┘
    │ 1
    │
    │ N
┌───▼──────────────┐
│  PageSnapshot    │
│──────────────────│
│ id               │
│ page_id          │
│ version          │
│ content (JSON)   │
│ created_at       │
│ created_by       │
└──────────────────┘

┌──────────────┐
│    Plugin    │
│   (Agg)      │
│──────────────│
│ id           │
│ name         │
│ version      │
│ config(JSON) │
│ status       │
└──────┬───────┘
       │ 1
       │
       │ N
┌──────▼──────────┐
│  PluginHook      │
│──────────────────│
│ id               │
│ plugin_id        │
│ hook_name        │
│ handler          │
│ priority         │
└──────────────────┘

┌──────────────┐
│  AuditLog    │
│──────────────│
│ id           │
│ user_id      │
│ workspace_id │
│ site_id      │
│ action       │
│ resource_type│
│ resource_id  │
│ data (JSON)  │
│ created_at   │
└──────────────┘
```

---

## Relacionamentos Resumidos

### Workspace
- **1:N** com Project
- **1:N** com WorkspaceUser
- **1:N** com MediaItem
- **1:N** com AuditLog

### Project
- **N:1** com Workspace
- **1:N** com Site

### Site
- **N:1** com Project
- **1:1** com Theme (tema ativo)
- **1:N** com Page
- **1:N** com Post
- **1:N** com Section
- **1:N** com Form
- **1:N** com MediaItem
- **1:N** com Collection

### User
- **N:N** com Workspace (via WorkspaceUser)
- **1:N** com AuditLog

### Page
- **N:1** com Site
- **1:1** com PageSEO
- **1:N** com PageSnapshot
- **N:N** com Section (via página)

### Post
- **N:1** com Site
- **N:1** com Collection
- **1:1** com PostSEO
- **N:N** com MediaItem

### MediaItem
- **N:1** com Workspace
- **N:1** com Site (opcional)
- **1:N** com MediaVersion
- **N:N** com Page
- **N:N** com Post

### Theme
- **1:N** com Site

### Form
- **N:1** com Site
- **1:N** com FormField
- **1:N** com FormSubmission

### Section
- **N:1** com Site
- **N:N** com Page

### Plugin
- **1:N** com PluginHook

---

## Nota sobre API

Todos esses relacionamentos serão expostos via **API REST/GraphQL**:
- Relacionamentos **1:N** serão expostos como arrays/coleções
- Relacionamentos **N:1** serão expostos como objetos aninhados ou IDs
- Relacionamentos **N:N** serão expostos como arrays
- Endpoints seguirão padrões RESTful: `/api/workspaces/{id}/projects`, `/api/sites/{id}/pages`, etc.

