# Como Subir o Projeto - Guia Passo a Passo

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Docker Desktop** (Windows/Mac) ou **Docker Engine + Docker Compose** (Linux)
- **Git** (para clonar o repositório, se necessário)

---

## 🚀 Passo a Passo

### 1. Verificar se Docker está rodando

```powershell
# No PowerShell (Windows)
docker --version
docker-compose --version
```

Se os comandos retornarem versões, está tudo certo! Se não, instale o Docker Desktop.

---

### 2. Criar arquivo .env

O projeto precisa de um arquivo `.env` com as configurações. Você pode copiar do `.env.example`:

```powershell
# No PowerShell, na raiz do projeto
Copy-Item .env.example .env
```

Ou criar manualmente com estas configurações mínimas:

```env
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
REDIS_PORT=6379
REDIS_PASSWORD=null

CACHE_STORE=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

**Importante**: Note que `DB_HOST=mysql` e `REDIS_HOST=redis` (nomes dos containers Docker, não `127.0.0.1`)

---

### 3. Gerar chave da aplicação

```powershell
# Se ainda não tiver a chave APP_KEY no .env
docker-compose exec app php artisan key:generate
```

Ou se preferir fazer antes de subir os containers:

```powershell
# Instalar dependências localmente primeiro (se tiver PHP)
composer install
php artisan key:generate
```

---

### 4. Subir os containers Docker

```powershell
# Construir as imagens e iniciar todos os serviços
docker-compose up -d
```

O `-d` roda em background (detached mode).

**O que acontece:**
- Baixa as imagens (nginx, mysql, redis) se necessário
- Constrói a imagem do PHP (app e queue)
- Cria a network `cms-network`
- Cria os volumes para MySQL e Redis
- Inicia todos os serviços na ordem correta

---

### 5. Verificar se tudo está rodando

```powershell
# Ver status dos containers
docker-compose ps
```

Você deve ver algo como:

```
NAME              STATUS          PORTS
cms-api-app       Up              ...
cms-api-mysql     Up (healthy)    0.0.0.0:3306->3306/tcp
cms-api-nginx     Up              0.0.0.0:8000->80/tcp
cms-api-queue     Up              ...
cms-api-redis     Up (healthy)    0.0.0.0:6379->6379/tcp
```

---

### 6. Instalar dependências do Composer

```powershell
# Executar dentro do container app
docker-compose exec app composer install
```

---

### 7. Criar o banco de dados e rodar migrations

```powershell
# Criar o banco (se não existir)
docker-compose exec mysql mysql -u root -proot_password -e "CREATE DATABASE IF NOT EXISTS cms_db;"

# Rodar migrations
docker-compose exec app php artisan migrate
```

---

### 8. Acessar a aplicação

Abra seu navegador e acesse:

```
http://localhost:8000
```

Você deve ver a página inicial do Laravel!

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
```

### Executar comandos Artisan

```powershell
# Qualquer comando artisan
docker-compose exec app php artisan [comando]

# Exemplos:
docker-compose exec app php artisan migrate
docker-compose exec app php artisan route:list
docker-compose exec app php artisan tinker
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

### Verificar se serviços estão saudáveis

```powershell
# Ver health status
docker-compose ps

# Ver logs de healthcheck
docker inspect cms-api-mysql | Select-String -Pattern "Health"
```

---

## 🐛 Troubleshooting (Solução de Problemas)

### Problema: Porta 8000 já está em uso

**Solução**: Altere a porta no `.env` ou `docker-compose.yml`:

```yaml
# docker-compose.yml
ports:
  - "${APP_PORT:-8001}:80"  # Mude para 8001
```

### Problema: Container não inicia

**Solução**: Verifique os logs:

```powershell
docker-compose logs app
docker-compose logs mysql
```

### Problema: Erro de conexão com banco

**Solução**: 
1. Verifique se MySQL está healthy: `docker-compose ps`
2. Verifique as variáveis no `.env` (DB_HOST deve ser `mysql`, não `127.0.0.1`)
3. Aguarde alguns segundos para MySQL inicializar completamente

### Problema: Permissões de arquivo

**Solução**: Ajuste permissões (se necessário):

```powershell
docker-compose exec app chown -R www-data:www-data /var/www/html/storage
docker-compose exec app chmod -R 775 /var/www/html/storage
```

### Problema: Cache do Laravel

**Solução**: Limpe o cache:

```powershell
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear
```

---

## 📝 Checklist Rápido

- [ ] Docker instalado e rodando
- [ ] Arquivo `.env` criado e configurado
- [ ] `docker-compose up -d` executado
- [ ] Containers rodando (`docker-compose ps`)
- [ ] `composer install` executado
- [ ] `php artisan key:generate` executado
- [ ] `php artisan migrate` executado
- [ ] Aplicação acessível em `http://localhost:8000`

---

## 🎯 Próximos Passos

Após subir o projeto com sucesso:

1. **Testar a API**: Acesse `http://localhost:8000/api` (quando rotas estiverem criadas)
2. **Verificar logs**: `docker-compose logs -f app`
3. **Criar usuário de teste**: Quando a Fase 2 (Autenticação) estiver pronta
4. **Configurar IDE**: Conectar ao container para debug (opcional)

---

## 💡 Dicas

1. **Desenvolvimento**: Use `docker-compose up` (sem `-d`) para ver logs em tempo real
2. **Produção**: Sempre use `docker-compose up -d` para rodar em background
3. **Performance**: Se estiver lento, verifique recursos do Docker Desktop
4. **Backup**: Antes de `docker-compose down -v`, faça backup dos volumes se necessário

---

## 📚 Referências

- [Documentação Docker Compose](https://docs.docker.com/compose/)
- [Laravel Documentation](https://laravel.com/docs)
- Documentação do projeto: `docs/FASE_1_INFRAESTRUTURA.md`

