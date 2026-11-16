# Trabalho 02 – Implementação e Análise de uma VPN (WireGuard)

**Disciplina:** Segurança em Sistemas Computacionais – UFPI
**Professor:** Carlos André Batista de Carvalho
**Grupo N =** _preencher_ → IP do gateway no túnel: `10.10.10.(10+N)`

| Integrante | Responsabilidade |
|---|---|
| Integrante 1 | Prática (etapas 1–4), capturas, Q1 e Q2 |
| Integrante 2 | Análise das capturas: Q3, Q4 e Q5 |
| Integrante 3 | Q6, Q7, Q8 e montagem do relatório |

## Estrutura
```
capturas/   captura_interna.pcapng, captura_externa.pcapng, captura_keepalive_*.pcapng
config/     wg0.conf.example, wg0.conf.grupo (sem chave privada), saida_etapa2.txt
scripts/    roteiro de execução (01 a 06)
respostas/  q1.md … q8.md
prints/     q1/ … q8/
```

## Execução (Integrante 1)

**Etapa 1 – VirtualBox:** importar as VMs e conferir os adaptadores
- VM 1 (Cliente): 1 adaptador em Rede Interna `rede_filial`
- VM 2 (Gateway): Adaptador 1 em NAT/Bridge (`eth0`), Adaptador 2 em Rede Interna `rede_filial` (`eth1`)

Na VM 2, clonar o repositório e instalar as ferramentas:
```bash
sudo apt install -y wireguard tcpdump wireshark-common   # se ainda não houver
```

| Passo | Onde | Comando |
|---|---|---|
| 2.1 Gerar chaves e enviar a pública ao monitor | VM 2 | `./scripts/01-gerar-chaves.sh` |
| 2.2 Montar o wg0.conf | VM 2 | `./scripts/02-configurar-gateway.sh <N> <IP_MATRIZ> <PUB_MATRIZ>` |
| 2.3 Subir o túnel + forwarding + NAT | VM 2 | `./scripts/03-subir-tunel.sh` |
| 4 Iniciar as capturas A e B | VM 2 | `./scripts/05-capturas.sh` |
| 3 Pings e curl (com as capturas rodando) | VM 1 | `./scripts/04-testes-cliente.sh` |
| Q1(c) Comparar keepalive de 25s e 5s | VM 2 | `./scripts/06-teste-keepalive.sh` |

> ⚠️ A chave privada fica apenas em `/etc/wireguard/` e nunca entra no repositório (ver `.gitignore`).
