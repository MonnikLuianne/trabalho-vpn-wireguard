# Trabalho 02 – Implementação e Análise de uma VPN (WireGuard)

**Disciplina:** Segurança em Sistemas Computacionais – UFPI
**Professor:** Carlos André Batista de Carvalho
**Grupo N = 3**, com IP do Gateway da Filial na VPN `10.10.10.13`

Arquitetura Gateway-to-Gateway (Matriz–Filial) com WireGuard e análise de tráfego no Wireshark.

```
[ Cliente ] ── rede_filial ── [ Gateway ] ══ túnel WireGuard ══ [ Matriz ]
192.168.100.2           192.168.100.1   10.10.10.13            10.10.10.1
```

## Divisão do trabalho
| Integrante | Responsabilidade |
|---|---|
| Integrante 1 | Parte prática (etapas 1–4), capturas, Q1 e Q2 |
| Integrante 2 | Análise das capturas: Q3, Q4 e Q5 |
| Integrante 3 | Q6, Q7, Q8 e montagem do relatório |

## Estrutura
| Pasta | Conteúdo |
|---|---|
| `capturas/` | `captura_interna.pcapng` (Ponto A), `captura_externa.pcapng` (Ponto B), `captura_keepalive_25s.pcapng` e `captura_keepalive_5s.pcapng` (Q1c) |
| `config/` | `wg0.conf` usado no Gateway (sem chave privada) e `comandos_executados.md` |
| `respostas/` | `q1.md` … `q8.md` |
| `prints/` | `execucao/` (etapas práticas) e `q1/` … `q8/` |

## Como as capturas foram feitas
As VMs não possuem interface gráfica, então as capturas foram gravadas pelo próprio VirtualBox (`VBoxManage ... nictrace1`) e abertas no Wireshark do computador hospedeiro. O passo a passo está em [`config/comandos_executados.md`](config/comandos_executados.md).

> No Wireshark, as datas aparecem como 1969/1970 porque a gravação do VirtualBox conta o tempo a partir da inicialização da VM. A requisição analisada ocorreu em 16/11/2026, às 17:46:18 GMT (cabeçalho `Date:` da resposta HTTP).

> A chave privada do Gateway nunca saiu da VM (`/etc/wireguard/priv`) e não está no repositório.
