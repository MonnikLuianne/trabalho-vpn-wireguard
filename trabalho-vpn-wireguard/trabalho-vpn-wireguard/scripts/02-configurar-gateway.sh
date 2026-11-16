#!/usr/bin/env bash
# [VM 2 - Gateway] Etapa 2.2: monta /etc/wireguard/wg0.conf com os dados do grupo.
# Uso: ./02-configurar-gateway.sh <N_GRUPO> <IP_PUBLICO_MATRIZ> <CHAVE_PUBLICA_MATRIZ> [KEEPALIVE]
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Uso: $0 <N_GRUPO> <IP_PUBLICO_MATRIZ> <CHAVE_PUBLICA_MATRIZ> [KEEPALIVE=25]"
  exit 1
fi

N=$1; MATRIZ_IP=$2; MATRIZ_PUB=$3; KEEPALIVE=${4:-25}
IP_TUNEL="10.10.10.$((10 + N))"
PRIV=$(sudo cat /etc/wireguard/privatekey)

gerar_conf() {  # $1 = chave privada a escrever
cat << CONF
[Interface]
Address    = ${IP_TUNEL}/24
PrivateKey = $1
ListenPort = 51820

[Peer]
PublicKey           = ${MATRIZ_PUB}
Endpoint            = ${MATRIZ_IP}:51820
AllowedIPs          = 10.10.10.0/24
PersistentKeepalive = ${KEEPALIVE}
CONF
}

gerar_conf "$PRIV" | sudo tee /etc/wireguard/wg0.conf > /dev/null
sudo chmod 600 /etc/wireguard/wg0.conf
echo "[+] /etc/wireguard/wg0.conf criado (IP do túnel: $IP_TUNEL)"

# Cópia sem a chave privada para o repositório (evidência para o relatório)
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
gerar_conf "<OMITIDA>" > "$REPO_DIR/config/wg0.conf.grupo"
echo "[+] Cópia segura salva em config/wg0.conf.grupo"

# Garante o IP da interface interna (eth1) do gateway
if ! ip -4 addr show eth1 | grep -q "192.168.100.1/24"; then
  sudo ip addr add 192.168.100.1/24 dev eth1
  sudo ip link set eth1 up
  echo "[+] eth1 configurada com 192.168.100.1/24"
fi
