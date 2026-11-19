# Trabalho 02 – Implementação e Análise de uma VPN (WireGuard)

**Disciplina:** Segurança em Sistemas Computacionais – UFPI
**Professor:** Carlos André Batista de Carvalho
**Integrantes:** Monnik Luianne Oliveira Nascimento Veloso Barbosa, Luidge Sousa Carvalho e Francielio Evangelista dos Santos Castro
**Grupo N = 3**, com IP do Gateway da Filial na VPN `10.10.10.13`

Arquitetura Gateway-to-Gateway (Matriz–Filial) com WireGuard e análise de tráfego no Wireshark.

```
[ Cliente ] ── rede_filial ── [ Gateway ] ══ túnel WireGuard ══ [ Matriz ]
192.168.100.2           192.168.100.1   10.10.10.13            10.10.10.1
```

## Divisão do trabalho
| Integrante | Responsabilidade |
|---|---|
| Monnik Luianne | Parte prática (etapas 1–4), capturas, Q1 e Q2 |
| Luidge Sousa Carvalho | Análise das capturas: Q3, Q4 e Q5 |
| Francielio Evangelista dos Santos Castro | Q6, Q7, Q8 e montagem do relatório |

## Relatório
O relatório completo, com as Questões 1 a 8 e as figuras numeradas, está em [`relatorio.pdf`](relatorio.pdf) (versão para entrega) e em [`relatorio.md`](relatorio.md) (mesmo conteúdo, para leitura no GitHub).

**Entrega:** `relatorio.pdf` + `capturas/captura_interna.pcapng` + `capturas/captura_externa.pcapng`.

## Estrutura
| Pasta / arquivo | Conteúdo |
|---|---|
| `relatorio.pdf`, `relatorio.md` | Relatório final (capa, ambiente, execução, Q1–Q8, conclusão e referências) |
| `capturas/` | `captura_interna.pcapng` (Ponto A), `captura_externa.pcapng` (Ponto B), `captura_keepalive_25s.pcapng` e `captura_keepalive_5s.pcapng` (Q1c) |
| `config/` | `wg0.conf` usado no Gateway (sem chave privada) e `comandos_executados.md` |
| `respostas/` | `q1.md` … `q8.md`, uma resposta por arquivo |
| `prints/` | `execucao/` (etapas práticas) e `q1/` … `q8/`. Os prints de Q6–Q8 são saídas do `tshark` (Wireshark em linha de comando) sobre as mesmas capturas |

## Como as capturas foram feitas
As VMs não possuem interface gráfica, então as capturas foram gravadas pelo próprio VirtualBox (`VBoxManage ... nictrace1`) e abertas no Wireshark do computador hospedeiro. O passo a passo está em [`config/comandos_executados.md`](config/comandos_executados.md).

> No Wireshark, as datas aparecem como 1969/1970 porque a gravação do VirtualBox conta o tempo a partir da inicialização da VM. A requisição analisada ocorreu em 16/11/2026, às 17:46:18 GMT (cabeçalho `Date:` da resposta HTTP).

> A chave privada do Gateway nunca saiu da VM (`/etc/wireguard/priv`) e não está no repositório.
