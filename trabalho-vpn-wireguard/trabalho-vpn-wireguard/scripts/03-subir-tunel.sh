#!/usr/bin/env bash
# [VM 2 - Gateway] Etapa 2.3: sobe o túnel, ativa o roteamento e o NAT.
# Rodar só DEPOIS que o monitor cadastrar a chave pública na Matriz.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$REPO_DIR/config/saida_etapa2.txt"

{
  echo "### 1. Ativar o túnel WireGuard"
  sudo wg-quick up wg0 2>&1 || echo "(wg0 já estava ativo)"

  echo; echo "### 2. Status e handshake"
  sleep 3
  sudo wg show

  echo; echo "### 3. IP forwarding e NAT"
  sudo sysctl -w net.ipv4.ip_forward=1
  # -C verifica se a regra já existe, para não duplicá-la
  sudo iptables -t nat -C POSTROUTING -o wg0 -j MASQUERADE 2>/dev/null \
    || sudo iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE

  echo; echo "### Regras iptables ativas (evidência para a Q2)"
  sudo iptables -t nat -L POSTROUTING -n -v
  sudo iptables -L FORWARD -n -v
  echo; echo "### Rotas"
  ip route
} 2>&1 | tee "$LOG"

echo; echo "[+] Saída salva em config/saida_etapa2.txt (tire print também!)"
