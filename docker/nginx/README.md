# Configuração do Nginx

A configuração do Nginx está dividida em arquivos separados para melhor organização:

## Estrutura de Arquivos

- **`default.conf`** - Arquivo principal do servidor que inclui as outras configurações
- **`nginx-backend.conf`** - Configurações específicas do backend Laravel (rotas `/api`)
- **`nginx-frontend.conf`** - Configurações específicas do frontend Next.js (rotas `/`)
- **`nginx-common.conf`** - Configurações comuns (favicon, robots.txt, security headers)
- **`nginx.conf`** - Configuração principal do Nginx (worker processes, etc.)

## Como Funciona

O `default.conf` inclui os outros arquivos usando a diretiva `include`:

```nginx
server {
    listen 80;
    server_name localhost;
    
    # Include backend configuration
    include /etc/nginx/conf.d/backend.conf;
    
    # Include frontend configuration
    include /etc/nginx/conf.d/frontend.conf;
    
    # Include common configuration
    include /etc/nginx/conf.d/common.conf;
}
```

## Modificando Configurações

### Backend (Laravel)
Edite `nginx-backend.conf` para alterar:
- Rotas da API
- Configurações do PHP-FPM
- Regras de rewrite

### Frontend (Next.js)
Edite `nginx-frontend.conf` para alterar:
- Configurações do proxy reverso
- Headers HTTP
- Timeouts

### Configurações Comuns
Edite `nginx-common.conf` para alterar:
- Security headers
- Configurações de favicon/robots.txt
- Regras de acesso

## Aplicar Mudanças

Após modificar qualquer arquivo de configuração:

```bash
docker-compose restart nginx
```

Ou para testar a configuração antes de reiniciar:

```bash
docker-compose exec nginx nginx -t
```

