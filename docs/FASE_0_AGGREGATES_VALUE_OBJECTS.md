# Fase 0 - Aggregates e Value Objects

## Nota Importante
Este sistema será uma **API REST/GraphQL** para consumo no frontend Next.js. Todas as entidades e relacionamentos serão expostos via endpoints da API.

---

## Aggregates (Agregados)

### 1. Workspace Aggregate
**Raiz do Agregado**: `Workspace`

**Entidades Contidas**:
- Workspace (raiz)
- WorkspaceUser (relação)
- WorkspaceSettings

**Value Objects**:
- WorkspaceId
- WorkspaceName
- WorkspaceSlug

**Regras de Invariância**:
- Workspace deve ter pelo menos um admin
- Workspace não pode ser deletado se tiver sites ativos
- Nome do workspace deve ser único no sistema

**Repositório**: `WorkspaceRepositoryInterface`

---

### 2. Project Aggregate
**Raiz do Agregado**: `Project`

**Entidades Contidas**:
- Project (raiz)
- ProjectSettings

**Value Objects**:
- ProjectId
- ProjectName
- ProjectSlug

**Regras de Invariância**:
- Project deve pertencer a um workspace
- Project não pode ser deletado se tiver sites ativos

**Repositório**: `ProjectRepositoryInterface`

---

### 3. Site Aggregate
**Raiz do Agregado**: `Site`

**Entidades Contidas**:
- Site (raiz)
- SiteSettings
- SiteTheme (relação)

**Value Objects**:
- SiteId
- Domain
- SiteName
- SiteStatus (active, inactive, maintenance)

**Regras de Invariância**:
- Site deve pertencer a um project
- Site deve ter um tema ativo
- Domain deve ser único no sistema

**Repositório**: `SiteRepositoryInterface`

---

### 4. User Aggregate
**Raiz do Agregado**: `User`

**Entidades Contidas**:
- User (raiz)
- UserProfile
- UserPreferences

**Value Objects**:
- UserId
- Email
- UserName
- PasswordHash

**Regras de Invariância**:
- Email deve ser único no sistema
- Senha deve seguir política de segurança
- Usuário deve ter pelo menos um workspace associado

**Repositório**: `UserRepositoryInterface`

---

### 5. Page Aggregate
**Raiz do Agregado**: `Page`

**Entidades Contidas**:
- Page (raiz)
- PageSEO
- PageSnapshot (versionamento)
- PageSections (relação)

**Value Objects**:
- PageId
- PageSlug
- PageTitle
- PageContent (JSON)
- ContentStatus (draft, published, archived)
- PagePath

**Regras de Invariância**:
- Page deve pertencer a um site
- Slug deve ser único por site
- Page publicada deve ter SEO configurado
- PageSnapshot criado automaticamente em mudanças

**Repositório**: `PageRepositoryInterface`, `PageSnapshotRepositoryInterface`

---

### 6. Post Aggregate
**Raiz do Agregado**: `Post`

**Entidades Contidas**:
- Post (raiz)
- PostSEO
- PostCategory (relação)
- PostTag (relação)

**Value Objects**:
- PostId
- PostSlug
- PostTitle
- PostContent
- PostType
- ContentStatus
- PublishedAt

**Regras de Invariância**:
- Post deve pertencer a um site e uma coleção
- Slug deve ser único por site e tipo
- Post publicado deve ter data de publicação

**Repositório**: `PostRepositoryInterface`

---

### 7. MediaItem Aggregate
**Raiz do Agregado**: `MediaItem`

**Entidades Contidas**:
- MediaItem (raiz)
- MediaVersion
- MediaMetadata

**Value Objects**:
- MediaId
- MediaPath
- MediaType (image, video, document, audio)
- FileSize
- MimeType
- MediaUrl

**Regras de Invariância**:
- MediaItem deve ter pelo menos uma versão
- Arquivo deve existir no storage
- Metadados devem ser válidos

**Repositório**: `MediaRepositoryInterface`

---

### 8. Theme Aggregate
**Raiz do Agregado**: `Theme`

**Entidades Contidas**:
- Theme (raiz)
- ThemeSettings
- ThemeComponents

**Value Objects**:
- ThemeId
- ThemeName
- ThemeVersion

**Regras de Invariância**:
- Theme deve ter configurações válidas
- Nome do tema deve ser único

**Repositório**: `ThemeRepositoryInterface`

---

### 9. Form Aggregate
**Raiz do Agregado**: `Form`

**Entidades Contidas**:
- Form (raiz)
- FormField
- FormSubmission

**Value Objects**:
- FormId
- FormName
- FormSchema (JSON)
- FieldType
- ValidationRule

**Regras de Invariância**:
- Form deve ter pelo menos um campo
- Schema JSON deve ser válido
- Submissões devem seguir validações

**Repositório**: `FormRepositoryInterface`, `FormSubmissionRepositoryInterface`

---

### 10. Section Aggregate
**Raiz do Agregado**: `Section`

**Entidades Contidas**:
- Section (raiz)
- SectionContent (JSON)

**Value Objects**:
- SectionId
- SectionType
- SectionName
- SectionContent

**Regras de Invariância**:
- Section deve pertencer a um site
- Content JSON deve ser válido
- Section global deve ter nome único

**Repositório**: `SectionRepositoryInterface`

---

### 11. Plugin Aggregate
**Raiz do Agregado**: `Plugin`

**Entidades Contidas**:
- Plugin (raiz)
- PluginConfig
- PluginHook

**Value Objects**:
- PluginId
- PluginName
- PluginVersion
- HookName

**Regras de Invariância**:
- Plugin deve ter configuração válida
- Nome e versão devem ser únicos
- Hooks devem ser registrados corretamente

**Repositório**: `PluginRepositoryInterface`

---

## Value Objects (Objetos de Valor)

### Identificadores
- `UserId`: int > 0, imutável
- `WorkspaceId`: int > 0, imutável
- `ProjectId`: int > 0, imutável
- `SiteId`: int > 0, imutável
- `PageId`: int > 0, imutável
- `PostId`: int > 0, imutável
- `MediaId`: int > 0, imutável
- `ThemeId`: int > 0, imutável
- `FormId`: int > 0, imutável
- `SectionId`: int > 0, imutável
- `PluginId`: int > 0, imutável

### Texto e Conteúdo
- `Email`: string, validação de formato, imutável
- `UserName`: string, 1-255 caracteres, não vazio, imutável
- `PageSlug`: string, URL-friendly, único por site, imutável
- `PostSlug`: string, URL-friendly, único por site/tipo, imutável
- `Domain`: string, formato válido de domínio, único, imutável
- `MetaTitle`: string, 1-60 caracteres (SEO)
- `MetaDescription`: string, 1-160 caracteres (SEO)

### Caminhos e URLs
- `MediaPath`: string, caminho válido no storage
- `MediaUrl`: string, URL completa para acesso
- `CanonicalUrl`: string, URL válida e absoluta
- `PagePath`: string, caminho da página no site

### Status e Tipos
- `ContentStatus`: enum (draft, published, archived)
- `SiteStatus`: enum (active, inactive, maintenance)
- `MediaType`: enum (image, video, document, audio)
- `FieldType`: enum (text, email, number, select, etc.)
- `ComponentType`: enum (header, footer, text, image, etc.)

### Dados Estruturados (JSON)
- `PageContent`: JSON válido, estrutura do Page Builder
- `FormSchema`: JSON válido, estrutura do formulário
- `SectionContent`: JSON válido, conteúdo da seção
- `ComponentConfig`: JSON válido, configuração do componente
- `OpenGraphData`: JSON válido, dados OpenGraph
- `SchemaOrgData`: JSON válido, dados Schema.org

### Arquivos
- `FileSize`: int > 0, tamanho em bytes
- `MimeType`: string, tipo MIME válido
- `MediaVersion`: int > 0, versão do arquivo

### Outros
- `PasswordHash`: string, hash bcrypt válido
- `RoleName`: enum (superadmin, workspace_admin, editor, author)
- `PermissionName`: string, nome da permissão
- `Timestamp`: DateTime, timestamp válido
- `LogLevel`: enum (debug, info, warning, error, critical)

---

## Princípios dos Value Objects

1. **Imutabilidade**: Value Objects não podem ser alterados após criação
2. **Validação**: Validação ocorre no construtor
3. **Igualdade por Valor**: Dois VOs são iguais se seus valores forem iguais
4. **Sem Identidade**: VOs não têm ID próprio
5. **Composição**: Entities podem conter múltiplos VOs

---

## Nota sobre API

Todos esses Aggregates e Value Objects serão expostos via **API REST/GraphQL** para consumo no frontend Next.js. Os endpoints seguirão padrões RESTful e retornarão JSON estruturado.

