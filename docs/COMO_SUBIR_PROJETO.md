# Como Subir o Projeto - Guia Passo a Passo

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Docker Desktop** (Windows/Mac) ou **Docker Engine + Docker Compose** (Linux)
- **Git** (para clonar o repositório, se necessário)

---

## 🚀 Passo a Passo Completo

### 1. Verificar se Docker está rodando

```powershell
# No PowerShell (Windows)
docker --version
docker-compose --version
```

Se os comandos retornarem versões, está tudo certo! Se não, instale o Docker Desktop.

---

### 2. Criar arquivo .env

O projeto precisa de um arquivo `.env` com as configurações. Crie o arquivo na raiz do projeto:

```powershell
# No PowerShell, na raiz do projeto
@"
APP_NAME="CMS API"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=cms_db
DB_USERNAME=cms_user
DB_PASSWORD=cms_password

REDIS_HOST=redis
REDIS_PORT=6380
REDIS_PASSWORD=null

CACHE_STORE=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
"@ | Out-File -FilePath .env -Encoding utf8
```

**⚠️ IMPORTANTE**: 
- `DB_HOST=mysql` (nome do container, não `127.0.0.1`)
- `REDIS_HOST=redis` (nome do container, não `127.0.0.1`)
- `REDIS_PORT=6380` (porta externa, pode ser diferente se 6379 estiver em uso)

---

### 3. Subir os containers Docker

```powershell
# Construir as imagens e iniciar todos os serviços
docker-compose up -d
```

O `-d` roda em background (detached mode).

**O que acontece:**
- Baixa as imagens (nginx, mysql, redis) se necessário
- Constrói a imagem do PHP (app e queue) com extensão Redis
- Cria a network `cms-network`
- Cria os volumes para MySQL e Redis
- Inicia todos os serviços na ordem correta

**⏱️ Tempo estimado**: 1-3 minutos na primeira vez (download de imagens)

---

### 4. Verificar se tudo está rodando

```powershell
# Ver status dos containers
docker-compose ps
```

Você deve ver algo como:

```
NAME              STATUS                    PORTS
cms-api-app       Up                       9000/tcp
cms-api-mysql     Up (healthy)              0.0.0.0:3306->3306/tcp
cms-api-nginx     Up                        0.0.0.0:8000->80/tcp
cms-api-queue     Up                        9000/tcp
cms-api-redis     Up (healthy)              0.0.0.0:6380->6379/tcp
```

**Aguarde até MySQL e Redis ficarem "healthy"** antes de continuar (pode levar 10-20 segundos).

---

### 5. Instalar dependências do Composer

```powershell
# Executar dentro do container app
docker-compose exec app composer install
```

Isso instalará todas as dependências do Laravel.

---

### 6. Gerar chave da aplicação

```powershell
# Gerar APP_KEY no .env
docker-compose exec app php artisan key:generate
```

**⚠️ CRÍTICO**: Sem a APP_KEY, a aplicação não funcionará (erro de criptografia).

---

### 7. Limpar e recarregar configurações

```powershell
# Limpar cache de configuração
docker-compose exec app php artisan config:clear

# Recarregar configurações
docker-compose exec app php artisan config:cache
```

Isso garante que o Laravel use as configurações corretas do `.env`.

---

### 8. Criar o banco de dados e rodar migrations

```powershell
# Criar o banco (se não existir - geralmente já é criado automaticamente)
docker-compose exec mysql mysql -u root -proot_password -e "CREATE DATABASE IF NOT EXISTS cms_db;"

# Rodar migrations
docker-compose exec app php artisan migrate
```

Isso criará todas as tabelas necessárias no banco de dados.

---

### 9. Reiniciar containers para aplicar mudanças

```powershell
# Reiniciar app e nginx para garantir que tudo está atualizado
docker-compose restart app nginx
```

---

### 10. Acessar a aplicação

Abra seu navegador e acesse:

```
http://localhost:8000
```

Você deve ver a página inicial do Laravel! 🎉

---

## 🔍 Comandos Úteis

### Ver logs dos containers

```powershell
# Todos os containers
docker-compose logs -f

# Apenas um container específico
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f mysql
docker-compose logs -f queue
```

### Parar os containers

```powershell
# Parar sem remover
docker-compose stop

# Parar e remover containers (mas mantém volumes)
docker-compose down

# Parar, remover containers E volumes (CUIDADO: apaga dados!)
docker-compose down -v
```

### Reiniciar um serviço específico

```powershell
docker-compose restart app
docker-compose restart nginx
docker-compose restart queue
```

### Executar comandos Artisan

```powershell
# Qualquer comando artisan
docker-compose exec app php artisan [comando]

# Exemplos:
docker-compose exec app php artisan migrate
docker-compose exec app php artisan route:list
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
```

### Acessar o banco de dados

```powershell
# Via MySQL CLI
docker-compose exec mysql mysql -u cms_user -pcms_password cms_db

# Ou como root
docker-compose exec mysql mysql -u root -proot_password cms_db
```

### Acessar Redis CLI

```powershell
docker-compose exec redis redis-cli
```

### Verificar configurações

```powershell
# Ver configuração do banco
docker-compose exec app php artisan config:show database.connections.mysql

# Ver configuração de cache
docker-compose exec app php artisan config:show cache.stores.redis

# Ver APP_KEY
docker-compose exec app php artisan config:show app.key
```

---

## 🐛 Troubleshooting (Solução de Problemas)

### Problema: Porta 6379 (Redis) já está em uso

**Sintoma**: `Bind for 0.0.0.0:6379 failed: port is already allocated`

**Solução**: 
1. Altere a porta no `docker-compose.yml`:
```yaml
ports:
  - "${REDIS_PORT:-6380}:6379"  # Mude para 6380 ou outra porta
```

2. Atualize o `.env`:
```env
REDIS_PORT=6380
```

3. Reinicie:
```powershell
docker-compose down
docker-compose up -d
```

---

### Problema: Erro "Class Redis not found"

**Sintoma**: `Class "Redis" not found` no container queue

**Solução**: A extensão Redis não está instalada. Reconstrua as imagens:

```powershell
docker-compose down
docker-compose build app queue
docker-compose up -d
```

---

### Problema: Erro "Access denied for user 'root'"

**Sintoma**: `Access denied for user 'root'@'...' (using password: NO)`

**Solução**: 
1. Verifique o `.env` - deve ter:
```env
DB_HOST=mysql
DB_USERNAME=cms_user
DB_PASSWORD=cms_password
```

2. Limpe o cache de configuração:
```powershell
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan config:cache
docker-compose restart app
```

---

### Problema: Erro "Unsupported cipher or incorrect key length"

**Sintoma**: `Unsupported cipher or incorrect key length` ao acessar a aplicação

**Solução**: A APP_KEY não foi gerada ou está inválida:

```powershell
# Gerar nova chave
docker-compose exec app php artisan key:generate --force

# Limpar cache
docker-compose exec app php artisan config:clear

# Reiniciar
docker-compose restart app nginx
```

---

### Problema: Container não inicia

**Solução**: Verifique os logs:

```powershell
docker-compose logs app
docker-compose logs mysql
docker-compose logs nginx
```

---

### Problema: Erro de conexão com banco

**Solução**: 
1. Verifique se MySQL está healthy: `docker-compose ps`
2. Verifique as variáveis no `.env` (DB_HOST deve ser `mysql`, não `127.0.0.1`)
3. Aguarde alguns segundos para MySQL inicializar completamente
4. Teste a conexão:
```powershell
docker-compose exec app php artisan migrate:status
```

---

### Problema: Permissões de arquivo

**Solução**: Ajuste permissões (se necessário):

```powershell
docker-compose exec app chown -R www-data:www-data /var/www/html/storage
docker-compose exec app chmod -R 775 /var/www/html/storage
```

---

### Problema: Cache do Laravel

**Solução**: Limpe todos os caches:

```powershell
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear
```

---

### Problema: Arquivo .env com BOM (Byte Order Mark)

**Sintoma**: Erro ao fazer build: `unexpected character "\ufeff"`

**Solução**: Remova o BOM do arquivo:

```powershell
$content = Get-Content .env -Raw
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Resolve-Path .env), $content, $utf8NoBom)
```

---

## 📝 Checklist Rápido

Use este checklist para garantir que tudo está configurado:

- [ ] Docker instalado e rodando
- [ ] Arquivo `.env` criado com todas as variáveis
- [ ] `docker-compose up -d` executado com sucesso
- [ ] Containers rodando (`docker-compose ps` mostra todos "Up")
- [ ] MySQL e Redis estão "healthy"
- [ ] `composer install` executado
- [ ] `php artisan key:generate` executado
- [ ] `php artisan config:clear` executado
- [ ] `php artisan migrate` executado
- [ ] Containers reiniciados (`docker-compose restart app nginx`)
- [ ] Aplicação acessível em `http://localhost:8000`

---

## 🎯 Próximos Passos

Após subir o projeto com sucesso:

1. **Testar a API**: Quando rotas estiverem criadas, acesse `http://localhost:8000/api`
2. **Verificar logs**: `docker-compose logs -f app` para ver requisições
3. **Criar usuário de teste**: Quando a Fase 2 (Autenticação) estiver pronta
4. **Configurar IDE**: Conectar ao container para debug (opcional)

---

## 💡 Dicas Importantes

### Desenvolvimento
- Use `docker-compose up` (sem `-d`) para ver logs em tempo real
- Sempre limpe o cache após mudanças no `.env`: `php artisan config:clear`
- Verifique logs regularmente: `docker-compose logs -f app`

### Produção
- Sempre use `docker-compose up -d` para rodar em background
- Configure variáveis de ambiente adequadas (APP_DEBUG=false, etc.)
- Use secrets management para senhas e chaves

### Performance
- Se estiver lento, verifique recursos do Docker Desktop
- Aumente memória/CPU do Docker se necessário
- Use `docker-compose build --no-cache` apenas quando necessário

### Backup
- Antes de `docker-compose down -v`, faça backup dos volumes se necessário
- Dados do MySQL estão em volume `ddd_mysql_data`
- Dados do Redis estão em volume `ddd_redis_data`

---

## 🔧 Configurações Importantes

### Portas Padrão
- **Aplicação**: `http://localhost:8000`
- **MySQL**: `localhost:3306`
- **Redis**: `localhost:6380` (ou 6379 se disponível)

### Credenciais Padrão
- **MySQL User**: `cms_user`
- **MySQL Password**: `cms_password`
- **MySQL Root Password**: `root_password`
- **MySQL Database**: `cms_db`

### Variáveis de Ambiente Críticas
```env
APP_KEY=base64:...          # DEVE estar preenchida
DB_HOST=mysql               # Nome do container, não IP
REDIS_HOST=redis            # Nome do container, não IP
SESSION_DRIVER=redis        # Usa Redis para sessões
QUEUE_CONNECTION=redis      # Usa Redis para filas
```

---

## 📚 Referências

- [Documentação Docker Compose](https://docs.docker.com/compose/)
- [Laravel Documentation](https://laravel.com/docs)
- Documentação do projeto: `docs/FASE_1_INFRAESTRUTURA.md`

---

## ✅ Resumo do Fluxo Completo

```powershell
# 1. Criar .env
@"
APP_NAME="CMS API"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=cms_db
DB_USERNAME=cms_user
DB_PASSWORD=cms_password
REDIS_HOST=redis
REDIS_PORT=6380
REDIS_PASSWORD=null
CACHE_STORE=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
"@ | Out-File -FilePath .env -Encoding utf8

# 2. Subir containers
docker-compose up -d

# 3. Aguardar MySQL e Redis ficarem healthy
docker-compose ps

# 4. Instalar dependências
docker-compose exec app composer install

# 5. Gerar chave
docker-compose exec app php artisan key:generate

# 6. Limpar cache
docker-compose exec app php artisan config:clear

# 7. Rodar migrations
docker-compose exec app php artisan migrate

# 8. Reiniciar
docker-compose restart app nginx

# 9. Acessar
# http://localhost:8000
```

---

**🎉 Pronto! Seu projeto está rodando!**
