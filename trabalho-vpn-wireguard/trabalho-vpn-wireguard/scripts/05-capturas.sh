#!/usr/bin/env bash
# [VM 2 - Gateway] Etapa 4: captura SIMULTÂNEA nos pontos A e B.
#   Ponto A (LAN): eth1  -> captura_interna.pcapng
#   Ponto B (WAN): eth0  -> captura_externa.pcapng
# Uso: ./05-capturas.sh  -> enquanto roda, execute o 04-testes-cliente.sh na VM 1
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO_DIR/capturas"
TMP=/tmp/capturas_vpn; mkdir -p "$TMP"

# dumpcap/tshark gravam pcapng direto; tcpdump grava pcap (convertido no fim)
if command -v dumpcap > /dev/null; then
  CAP() { sudo dumpcap -q -i "$1" -w "$2.pcapng" & }
  EXT=pcapng
else
  CAP() { sudo tcpdump -i "$1" -U -w "$2.pcap" 2>/dev/null & }
  EXT=pcap
fi

echo "[+] Iniciando capturas em eth1 (A) e eth0 (B)..."
CAP eth1 "$TMP/captura_interna"; PID_A=$!
CAP eth0 "$TMP/captura_externa"; PID_B=$!
sleep 2

echo ">>> Agora rode na VM 1:  ./04-testes-cliente.sh"
echo ">>> Depois aguarde ~30s (para pegar keepalives) e pressione ENTER aqui."
read -r

sudo kill -INT "$PID_A" "$PID_B" 2>/dev/null || true
sleep 2

for f in captura_interna captura_externa; do
  if [ "$EXT" = "pcap" ] && command -v editcap > /dev/null; then
    editcap -F pcapng "$TMP/$f.pcap" "$OUT/$f.pcapng"
  else
    sudo cp "$TMP/$f.$EXT" "$OUT/$f.$EXT"
  fi
done
sudo chown "$USER" "$OUT"/* 2>/dev/null || true
echo "[+] Capturas salvas em capturas/"
ls -lh "$OUT"
