#!/usr/bin/env bash
# [VM 2 - Gateway] Q1(c): compara capturas externas com keepalive diferentes.
# Gera captura_keepalive_25s.pcapng e captura_keepalive_5s.pcapng (60s cada, sem tráfego do cliente)
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO_DIR/capturas"
DURACAO=60
PEER=$(sudo wg show wg0 peers | head -n1)   # chave pública da Matriz

capturar() {  # $1 = intervalo de keepalive
  sudo wg set wg0 peer "$PEER" persistent-keepalive "$1"
  echo "[+] Keepalive = $1s, capturando ${DURACAO}s em eth0..."
  sudo timeout "$DURACAO" tcpdump -i eth0 -U udp port 51820 \
       -w "/tmp/ka_$1.pcap" 2>/dev/null || true
  if command -v editcap > /dev/null; then
    editcap -F pcapng "/tmp/ka_$1.pcap" "$OUT/captura_keepalive_${1}s.pcapng"
  else
    cp "/tmp/ka_$1.pcap" "$OUT/captura_keepalive_${1}s.pcap"
  fi
  echo "    Pacotes capturados: $(tcpdump -r /tmp/ka_$1.pcap 2>/dev/null | wc -l)"
}

capturar 25
capturar 5
sudo wg set wg0 peer "$PEER" persistent-keepalive 25   # restaura o padrão
echo "[+] Keepalive restaurado para 25s. Arquivos em capturas/"
