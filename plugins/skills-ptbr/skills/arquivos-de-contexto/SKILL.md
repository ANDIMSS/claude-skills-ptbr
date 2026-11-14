---
name: "arquivos-de-contexto"
description: "Cria, audita e mantém os 6 arquivos de contexto (prd, architecture, rules, design, task, memory) em docs/contexto/ e aponta o agente para eles via CLAUDE.md."
---

# Os 6 arquivos de contexto

Método para a IA parar de reconstruir, a cada sessão, decisões que já foram tomadas. Tudo mora numa pasta só, `docs/contexto/`, e o agente é instruído a ler a pasta inteira antes de escrever a primeira linha. Funciona em Claude Code, Cursor, Codex ou qualquer agente que leia arquivos do projeto.

Os seis formam três pares: o que a coisa é (prd, architecture), como ela se comporta (rules, design) e o que ela lembra (task, memory).

## Escolha o modo

- "monta / cria os arquivos de contexto" em projeto **novo** → Modo A.
- Mesmo pedido em projeto **que já tem código** → Modo A com o passo A2 obrigatório.
- "audita o contexto" → Modo B.
- "registra no memory", decisão tomada, ideia descartada, erro que voltou → Modo C.
- "revisão mensal" → Modo D.

Se não estiver claro qual projeto/pasta, pergunte antes de começar.

## Regras de escrita (valem para os seis)

- Português, em frase corrida, não em tópico seco: o agente lê melhor prosa porque a relação entre as ideias está nos conectores. Listas só onde a coisa é lista (árvore de pastas, fila de tarefas, tokens de cor).
- Sem travessão.
- Nunca invente dado. Onde faltar informação, escreva a pergunta no formato `> PERGUNTA: ...`.
- Nomes técnicos em inglês, regras e explicações em português; declare esse padrão no rules.md para o agente não começar a traduzir nome de variável e pasta.
- Comece curto e cresça quando doer. Contexto longo demais esconde a instrução importante.

## Modo A: montar

### A1. Coletar o mínimo
Se o usuário não deu e não dá para tirar do código, pergunte de uma vez: o projeto em 3 a 5 frases (o que é, para quem, qual problema resolve) e a stack (linguagem, framework, banco, onde roda).

### A2. Ler o código antes (projeto existente)
O contexto tem que descrever o projeto que **existe**, não um idealizado. Leia, nesta ordem: README, package.json (ou equivalente), .env.example, configs (vite/next/tsconfig), o arquivo de tema/cores, o servidor ou as rotas, os tipos centrais e qualquer documento de especificação ou prompt que esteja na raiz. Liste a árvore de pastas ignorando node_modules, dist e .git. Anote decisões e coisas descartadas que aparecem no código ou nos comentários: elas vão para o memory.md. Anote também inconsistências encontradas (tipos divergentes, nomes de exemplo esquecidos): elas viram tarefas no task.md.

### A3. Criar a pasta
```bash
mkdir -p docs/contexto && cd docs/contexto && touch prd.md architecture.md rules.md design.md task.md memory.md
```
Se algum arquivo já existir com conteúdo, não sobrescreva: leia, preserve e complete.

### A4. prd.md e architecture.md primeiro
São os dois que dizem o que a coisa é e cortam a maior parte do retrabalho.

### A5. rules.md, design.md, task.md
Preencha com o que se sabe. No design.md use valores concretos tirados do código (hex, fontes), nunca adjetivos. Arquivo sem base fica curto, com as perguntas abertas.

### A6. memory.md
Cabeçalho, formato de registro e a primeira entrada com a data de hoje e a decisão de stack. Em projeto existente, registre também as decisões encontradas no A2, avisando que foram registradas depois.

### A7. Apontar o agente (o passo que quase todo mundo esquece)
Arquivo que ninguém lê é decoração. Adicione ao `CLAUDE.md` da raiz; se ele já existir, acrescente a seção sem apagar nem duplicar o resto. Para Codex use `AGENTS.md`; para Cursor, `.cursor/rules/`.

```markdown
## Contexto do projeto

Antes de escrever ou alterar qualquer arquivo deste projeto, leia tudo que está em docs/contexto/. O prd.md e o architecture.md definem o que estamos construindo e como. O rules.md tem restrições que você não pode violar. O design.md define o visual e vale para toda tela nova. O task.md tem a fila de tarefas: trabalhe uma por vez, na ordem. O memory.md tem o histórico de decisões: leia antes de propor mudança de rumo, e escreva ali toda vez que uma decisão importante for tomada.
```

### A8. Conferir antes de entregar
- [ ] Os seis arquivos existem e estão na mesma pasta.
- [ ] Há instrução escrita mandando o agente ler a pasta.
- [ ] O architecture.md descreve a árvore de pastas real.
- [ ] Cada tarefa do task.md cabe numa conversa.
- [ ] O memory.md tem pelo menos uma entrada com data.

Feche com um resumo curto: onde os arquivos ficaram, o que de relevante apareceu no código, as `> PERGUNTA:` principais e a próxima tarefa.

## Modelos

### prd.md
```markdown
# PRD: [Nome]

## O produto
[O que é, para quem e qual problema resolve, em frase corrida.]

## O problema
[A dor de hoje e por que a solução atual é ruim.]

## Usuário alvo
[Quem usa, papéis, contexto.]

## Funcionalidades
### Primeira versão (ou "Já existe")
- [funcionalidade]: [o que faz]
### Depois
- [funcionalidade]: [por que ficou para depois]

## Fora de escopo
[O que o produto deliberadamente não faz.]
```

### architecture.md
```markdown
# Arquitetura

## Stack
[Front, back, banco, hospedagem, e o porquê de cada escolha.]

## Fluxo do aplicativo
[Em prosa: do primeiro acesso até a ação principal, e o que acontece por trás.]

## Árvore de pastas
(bloco de código com a árvore real e uma linha explicando cada pasta importante)

## Como as partes conversam
[Quem chama quem, autenticação, grupos de rotas, variáveis de ambiente por nome.]
```

### rules.md
```markdown
# Regras

## Idioma
Nomes técnicos em inglês; interface, comentários e docs em português. Nunca traduzir nome existente.

## Bibliotecas
[Quais usar para cada coisa, quais são proibidas e por quê.]

## Tratamento de erro
[Como o erro aparece para o usuário e onde é registrado.]

## Nunca fazer
[Restrições invioláveis, cada uma com o porquê.]

## Antes de entregar
[Comandos que precisam passar: lint, typecheck, build, testes.]
```

### design.md
```markdown
# Design

## Cores
- Primária / secundária / fundo / superfície / texto / borda / estados: [hex]

## Tipografia
- Título e texto: [fonte, pesos]; escala: [tamanhos]

## Espaçamento e forma
[Escala de espaçamento, raios, sombras.]

## Componentes
[Botão, input, card, modal, estados de carregamento/erro/vazio, com valores.]
```

### task.md
```markdown
# Tarefas

Trabalhe uma por vez, na ordem. Marque [x] ao concluir. Se não couber numa conversa, quebre em duas.

- [ ] 1. [Tarefa pequena com uma entrega clara]
```
Pedido grande é onde a IA se perde; pedido pequeno é onde ela acerta.

### memory.md
```markdown
# Memória do projeto

Histórico de decisões, erros recorrentes e mudanças de rumo. Leia antes de propor mudança de rumo. Cada entrada tem data, decisão e porquê, em duas ou três linhas, e o que foi tentado e descartado.

## AAAA-MM-DD: [título curto]
[Decisão, porquê, o que foi descartado.]
```

## Modo B: auditar

Leia todos os arquivos de `docs/contexto/` e o código relevante. **Não conserte nada.** Entregue uma lista curta, com o caminho de cada arquivo envolvido:

1. Informação que um desenvolvedor novo precisaria e não está escrita em lugar nenhum.
2. Onde dois arquivos se contradizem.
3. Qual regra do rules.md o código está violando, com arquivo e linha.
4. Qual decisão importante aparece no código e não está no memory.md.

Confira também o checklist do A8. No fim, pergunte o que o usuário quer corrigir.

## Modo C: registrar no memory.md

1. Data real de hoje, a decisão e o porquê, em duas ou três linhas.
2. O que foi tentado e descartado, não só o que ficou.
3. Erro que voltou pela segunda vez merece entrada.
4. Se a decisão muda algo descrito em outro arquivo (stack, árvore, regra, cor), atualize esse arquivo também.

## Modo D: revisão mensal

Leia o memory.md inteiro e proponha o que apagar ou condensar. Um memory.md parado por duas semanas está mentindo, e contexto errado é pior que nenhum. Confira também se architecture.md e task.md ainda batem com o projeto.

## Onde isso costuma falhar

- Criar os arquivos e não apontar o agente para eles.
- Escrever seis arquivos gigantes no primeiro dia.
- Deixar o memory.md parado.

Se só der para escrever um, escreva o memory.md: os outros dá para reconstruir lendo o código, o histórico de decisões não.

Método baseado em "Os 6 arquivos de contexto" (fabiano.app).