# Troubleshooting Hot Reload no Windows

## Problema
O hot reload do Next.js não está funcionando no Docker no Windows.

## Configurações Aplicadas

✅ Variáveis de ambiente de polling configuradas:
- `WATCHPACK_POLLING=true`
- `CHOKIDAR_USEPOLLING=true`
- `CHOKIDAR_INTERVAL=500`

✅ Volumes montados corretamente
✅ Script dev.sh com polling forçado

## Soluções para Testar

### 1. Verificar Docker Desktop File Sharing

1. Abra Docker Desktop
2. Vá em **Settings** → **Resources** → **File Sharing**
3. Certifique-se de que a unidade `D:` está na lista de unidades compartilhadas
4. Se não estiver, adicione e reinicie o Docker Desktop

### 2. Testar se Arquivos Estão Sincronizando

```bash
# Dentro do container, criar um arquivo
docker-compose exec frontend touch /app/test-sync.txt

# Verificar se aparece no host
ls frontend/test-sync.txt
```

### 3. Monitorar Logs em Tempo Real

```bash
docker-compose logs -f frontend
```

Depois edite um arquivo e veja se aparece alguma mensagem de "Compiling" ou "Reloading".

### 4. Usar WSL2 (Recomendado)

Se estiver usando Windows, considere usar WSL2:

1. Instale WSL2
2. Execute o projeto dentro do WSL2
3. O hot reload funciona melhor no WSL2

### 5. Alternativa: Desabilitar Turbopack

Se o Turbopack estiver causando problemas, pode desabilitar editando `frontend/package.json`:

```json
"dev": "next dev -H 0.0.0.0 --no-turbo"
```

### 6. Verificar Permissões

```bash
# Verificar permissões dos arquivos
docker-compose exec frontend ls -la /app/app/
```

### 7. Rebuild Completo

Se nada funcionar, tente rebuild completo:

```bash
docker-compose down
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

## Teste Manual

1. Abra `http://localhost:3000` no navegador
2. Abra outro terminal e execute: `docker-compose logs -f frontend`
3. Edite `frontend/app/page.tsx` e salve
4. Observe os logs - deve aparecer "Compiling" ou similar
5. O navegador deve atualizar automaticamente

## Se Ainda Não Funcionar

O problema pode ser limitação do Docker Desktop no Windows com file watching. Nesse caso:

1. **Use WSL2** (melhor solução)
2. **Desenvolva localmente** sem Docker (npm run dev direto)
3. **Use Docker apenas para produção**

## Status Atual

- ✅ Frontend rodando em `http://localhost:3000`
- ✅ Polling configurado
- ✅ Volumes montados
- ⚠️ Hot reload pode não funcionar perfeitamente no Windows sem WSL2

