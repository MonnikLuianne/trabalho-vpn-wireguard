#!/usr/bin/env bash
# [VM 1 - Cliente] Etapa 3: testes de conectividade e requisição HTTP.
set -uo pipefail

# Garante IP e rota para a Matriz via gateway (se a VM não vier configurada)
ip -4 addr show eth0 | grep -q "192.168.100.2/24" || {
  sudo ip addr add 192.168.100.2/24 dev eth0; sudo ip link set eth0 up; }
ip route | grep -q "10.10.10.0/24" || \
  sudo ip route add 10.10.10.0/24 via 192.168.100.1

echo "### Ping para o Gateway";  ping -c 4 192.168.100.1
echo; echo "### Ping para a Matriz"; ping -c 4 10.10.10.1
echo; echo "### Requisição HTTP"
curl -v http://10.10.10.1:8080/dados_confidenciais.txt
