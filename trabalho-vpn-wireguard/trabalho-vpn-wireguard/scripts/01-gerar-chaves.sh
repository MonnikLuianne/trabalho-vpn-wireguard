#!/usr/bin/env bash
# [VM 2 - Gateway] Etapa 2.1: gera o par de chaves do grupo.
# A chave PRIVADA fica só em /etc/wireguard (fora do repositório).
set -euo pipefail

DIR=/etc/wireguard
sudo mkdir -p "$DIR"

if sudo test -f "$DIR/privatekey"; then
  echo "[!] Já existe uma chave em $DIR/privatekey. Não vou sobrescrever."
else
  # umask 077: só o root lê a chave privada
  sudo bash -c "umask 077; wg genkey | tee $DIR/privatekey | wg pubkey > $DIR/publickey"
  echo "[+] Par de chaves gerado em $DIR"
fi

echo
echo "===== CHAVE PÚBLICA (enviar ao monitor) ====="
sudo cat "$DIR/publickey"
echo "============================================="
