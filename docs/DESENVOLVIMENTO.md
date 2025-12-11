# Guia de Desenvolvimento

## Hot Reload - Sem necessidade de rebuild

Agora você pode desenvolver sem precisar fazer rebuild do Docker toda vez que mudar algo no código!

### Backend (Laravel)

O backend já está configurado com volumes, então:
- ✅ Mudanças em arquivos PHP são refletidas **automaticamente**
- ✅ Não precisa rebuildar
- ✅ Apenas salve o arquivo e teste

**Exemplo:**
```bash
# Edite qualquer arquivo em backend/app/
# Salve o arquivo
# As mudanças já estão ativas!
```

### Frontend (Next.js)

O frontend agora usa modo de desenvolvimento com hot-reload:
- ✅ Mudanças em arquivos React/TypeScript são refletidas **automaticamente**
- ✅ Hot-reload do Next.js ativo
- ✅ Não precisa rebuildar
- ✅ Apenas salve o arquivo e veja as mudanças no navegador

**Exemplo:**
```bash
# Edite qualquer arquivo em frontend/app/
# Salve o arquivo
# O navegador atualiza automaticamente!
```

## Comandos Úteis

### Iniciar o ambiente de desenvolvimento
```bash
docker-compose up -d
```

### Ver logs do frontend
```bash
docker-compose logs -f frontend
```

### Ver logs do backend
```bash
docker-compose logs -f app
```

### Rebuild apenas quando necessário
Você só precisa rebuildar quando:
- Adicionar novas dependências (composer/npm)
- Mudar configurações do Dockerfile
- Mudar configurações do docker-compose.yml

```bash
# Rebuild apenas o frontend
docker-compose build frontend
docker-compose up -d frontend

# Rebuild apenas o backend
docker-compose build app
docker-compose up -d app

# Rebuild tudo
docker-compose build
docker-compose up -d
```

### Instalar novas dependências

**Backend (Laravel):**
```bash
docker-compose exec app composer require nome-do-pacote
```

**Frontend (Next.js):**
```bash
docker-compose exec frontend npm install nome-do-pacote
```

## Modo Produção

Para produção, use o `Dockerfile` original (não o `.dev`):
```bash
# No docker-compose.yml, mude:
dockerfile: Dockerfile.dev  # para
dockerfile: Dockerfile
```

E altere `NODE_ENV=development` para `NODE_ENV=production`

