---
name: auditoria-111
description: Audita um projeto contra os 111 conceitos de engenharia que quebram apps feitos com IA (segredos, RLS/permissoes, SQL injection, XSS, rate limit, backup, idempotencia, CORS, migrations, timeouts, custo, alertas, pool de conexoes etc.). Use quando o usuario pedir /auditoria-111, "auditar o projeto", "rodar o top 15", "checar antes de lancar", "revisar seguranca/banco/deploy/observabilidade/resiliencia/custo", ou "explicar o conceito N" da lista dos 111. Aceita argumentos: top15 (padrao), completa, grupo <nome>, explicar <numero>.
---

# Auditoria dos 111 conceitos

Referencia completa (lista, top 15, grupos, prompts, links): [references/111-conceitos.md](references/111-conceitos.md). Leia a secao relevante antes de auditar.

## Modos

Escolha pelo argumento recebido; sem argumento, use `top15`.

| Argumento | O que fazer |
|---|---|
| `top15` | Conferir os 15 pontos da secao "Top 15", nesta ordem. |
| `completa` | Auditar o projeto contra os 111. |
| `grupo <nome>` | Um dos 6 grupos: `seguranca`, `banco`, `deploy`, `observabilidade`, `resiliencia`, `custo`. Use os itens e o "foco do grupo" da tabela de prompts por grupo. |
| `explicar <n>` | Explicar o conceito N usando um trecho real do projeto como exemplo, mostrando o que acontece hoje no codigo. Sem correcao, a menos que o usuario peca. |

## Procedimento

1. **Contexto primeiro.** Descubra pelo codigo (package.json, configs, estrutura) o que o app faz, a stack, se tem backend, banco, pagamento, dado pessoal, chamadas a APIs pagas. So pergunte ao usuario o que o codigo nao responde (ex.: numero de usuarios, fase: prototipo/beta/producao).
2. **Calibre pelo tamanho.** Um app estatico ou um jogo client-side nao tem banco, webhook nem RLS: marque `nao se aplica` com o motivo em uma frase, sem inventar risco. Kubernetes, multirregiao, sharding e afins quase sempre ficam em "nao faz sentido agora".
3. **Investigue de verdade.** Use Grep/Glob/Read. Para segredos, cheque tambem o historico do git (`git log -p -S <padrao>`) quando houver repositorio, e o codigo que vai pro navegador (variaveis `NEXT_PUBLIC_`, `VITE_`, bundles).
4. **Relate** no formato abaixo.
5. **Corrija so com aprovacao.** Mostre o plano antes de mudar qualquer coisa. Uma correcao por vez, com teste ou verificacao, e diga como conferir que funcionou. Sugira um commit por correcao.

## Regras

- Trabalhe so com o que existe no codigo; cite `arquivo:linha` em todo achado.
- Nao invente problema pra preencher lista. `ok` e `nao se aplica` sao respostas validas.
- Chave secreta exposta: apagar a linha nao resolve. Oriente gerar chave nova no painel do servico, revogar a antiga e so entao mover a nova pra variavel de ambiente. Nunca repita o valor da chave na resposta.
- Nao rode nada destrutivo no banco nem em producao.

## Formato do relatorio

**top15 / grupo:** tabela `# | Conceito | Situacao (ok / problema / nao se aplica) | Evidencia (arquivo:linha) | Correcao proposta`, seguida das correcoes de prioridade alta em ordem.

**completa:**
1. Tabela `# | Conceito | Situacao (ok / falta / nao se aplica agora) | Evidencia | Risco`.
2. As 10 correcoes mais urgentes, por impacto e facilidade, com esforco estimado em horas.
3. Os conceitos que NAO fazem sentido pro tamanho atual, com o motivo.

Feche sempre com o checklist "antes de usuario pagante" da referencia, marcado conforme o que foi encontrado (quando o projeto tiver usuarios/pagamento).
