# Comandos executados no laboratório

Ambiente: VMs `Filial-Gateway` e `Filial-Cliente` fornecidas pela monitoria, acessadas por SSH a partir do PowerShell do Windows. Grupo **N = 3**, com IP do Gateway na VPN `10.10.10.13`.

## Acesso às VMs (PowerShell do Windows)
```powershell
ssh -p 2222 aluno@127.0.0.1                         # Gateway
ssh -J aluno@127.0.0.1:2222 aluno@192.168.100.2     # Cliente, passando pelo Gateway
```

## Gateway – geração das chaves (Etapa 2.1)
```sh
sudo sh -c 'umask 077; cd /etc/wireguard; wg genkey > priv; wg pubkey < priv > pub'
sudo cat /etc/wireguard/pub      # chave pública enviada ao professor
```

## Gateway – configuração e túnel (Etapas 2.2 e 2.3)
```sh
sudo sed -i 's|^Address .*|Address    = 10.10.10.13/24|' /etc/wireguard/wg0.conf
sudo wg-quick up wg0
sudo wg show
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
sudo iptables -t nat -S POSTROUTING; sudo iptables -S FORWARD
```
O primeiro handshake só ocorreu após o cadastro da chave na Matriz. Depois disso, foi necessário reiniciar o túnel com `sudo wg-quick down wg0; sudo wg-quick up wg0`.

## Cliente – testes (Etapa 3)
```sh
ping -c 4 192.168.100.1
ping -c 4 10.10.10.1
curl -v http://10.10.10.1:8080/dados_confidenciais.txt
```

## Capturas (Etapa 4) – gravadas pelo VirtualBox no PowerShell do Windows
```powershell
cd "C:\Program Files\Oracle\VirtualBox"
.\VBoxManage controlvm "Filial-Cliente" nictracefile1 "$HOME\captura_interna.pcap"   # Ponto A
.\VBoxManage controlvm "Filial-Gateway" nictracefile1 "$HOME\captura_externa.pcap"   # Ponto B
.\VBoxManage controlvm "Filial-Cliente" nictrace1 on
.\VBoxManage controlvm "Filial-Gateway" nictrace1 on
# ... curl no Cliente, aguardar ~1 min ...
.\VBoxManage controlvm "Filial-Cliente" nictrace1 off
.\VBoxManage controlvm "Filial-Gateway" nictrace1 off
```
Os arquivos `.pcap` foram convertidos para `.pcapng` no Wireshark (Arquivo → Salvar como).

## Experimento do PersistentKeepalive (Q1c)
```sh
# Gateway: alterar o intervalo em tempo de execução
sudo wg set wg0 peer f/iC7Qjn/DWolU6sBpFNFS5GeSrooYaIobJJDh5Llg8= persistent-keepalive 5
# Windows: gravar ~90 s apenas no Gateway, sem tráfego do Cliente
.\VBoxManage controlvm "Filial-Gateway" nictracefile1 "$HOME\captura_keepalive_5s.pcap"
.\VBoxManage controlvm "Filial-Gateway" nictrace1 on
.\VBoxManage controlvm "Filial-Gateway" nictrace1 off
# Gateway: restaurar o padrão
sudo wg set wg0 peer f/iC7Qjn/DWolU6sBpFNFS5GeSrooYaIobJJDh5Llg8= persistent-keepalive 25
```
O mesmo procedimento foi feito com o valor padrão (25 s), gerando `captura_keepalive_25s.pcapng`.
