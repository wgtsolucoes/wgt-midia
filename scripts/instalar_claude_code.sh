#!/usr/bin/env bash
#
# Instalação do Claude Code + Bun para Ubuntu 24.04 (funciona headless, sem GUI)
# Uso: chmod +x instalar_claude_code.sh && ./instalar_claude_code.sh
#
set -e

echo "=== 1/5: Verificando sistema ==="
if ! grep -q "Ubuntu" /etc/os-release; then
  echo "Aviso: isso não parece ser Ubuntu. Continuando mesmo assim..."
fi
lsb_release -a 2>/dev/null || cat /etc/os-release

echo ""
echo "=== 2/5: Atualizando pacotes e instalando dependências básicas ==="
sudo apt update
sudo apt install -y curl ca-certificates gnupg git build-essential unzip

echo ""
echo "=== 3/5: Instalando o Claude Code (instalador nativo) ==="
curl -fsSL https://claude.ai/install.sh | bash

# garante que o binário fica no PATH desta sessão e das futuras
if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "=== 4/5: Instalando o Bun (necessário para o plugin do Telegram) ==="
curl -fsSL https://bun.sh/install | bash

if ! grep -q '.bun/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.bun/bin:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/.bun/bin:$PATH"

echo ""
echo "=== 5/5: Verificando instalação ==="
source "$HOME/.bashrc" 2>/dev/null || true
claude --version 2>/dev/null && echo "✓ Claude Code instalado" || echo "⚠ Rode 'source ~/.bashrc' ou abra um terminal novo e teste 'claude --version'"
bun --version 2>/dev/null && echo "✓ Bun instalado" || echo "⚠ Rode 'source ~/.bashrc' ou abra um terminal novo e teste 'bun --version'"

cat <<'EOF'

==========================================================
INSTALAÇÃO CONCLUÍDA. PRÓXIMOS PASSOS (manuais):
==========================================================

1) Abra um terminal novo (ou rode: source ~/.bashrc)

2) Autentique o Claude Code:
     claude
   Como é servidor headless, ele vai IMPRIMIR uma URL no terminal
   (não abre navegador sozinho). Copie essa URL, abra em qualquer
   navegador (pode ser no seu celular), faça login com sua conta
   Claude (Pro/Max/Team/Enterprise ou Console com billing),
   e volte pro terminal.

3) Dentro da sessão do Claude Code, instale o plugin do Telegram:
     /plugin install telegram@claude-plugins-official
     /reload-plugins

4) Configure o token do bot (peça pro @BotFather no Telegram):
     /telegram:configure SEU_TOKEN_AQUI

5) Saia e reinicie com o canal ativado:
     claude --channels plugin:telegram@claude-plugins-official

6) Mande uma DM pro seu bot no Telegram, copie o código de 6
   dígitos que ele responder, e na sessão do Claude Code:
     /telegram:access pair <codigo>

7) Trave o acesso (importante!):
     /telegram:access policy allowlist

==========================================================
EOF
