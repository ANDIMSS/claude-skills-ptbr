# Os 111 conceitos de engenharia que ninguem conta pros vibe coders

> Fonte: PDF "111-conceitos-engenharia-vibe-coders" (fabiano.app). Lista, top 15 e prompts de auditoria pra usar com o Claude Code.

Nao tente aprender os 111 de uma vez: o caminho e auditar, corrigir o top 15 e depois um grupo por semana.

## Como usar

1. Abra o projeto no Claude Code (a auditoria precisa enxergar o codigo inteiro).
2. Este arquivo e a lista de referencia: todo prompt pode citar `docs/111-conceitos.md` em vez de colar a lista de novo.
3. Rode a auditoria completa (prompt 2): tabela por conceito, 10 correcoes mais urgentes com esforco em horas, e o que NAO faz sentido pro tamanho atual.
4. Corrija o top 15 antes de qualquer outra coisa. Peca o plano antes da mudanca, rode os testes depois de cada correcao, faca um commit por correcao.
5. Troque toda chave que ja esteve exposta: gere uma nova, revogue a antiga, so entao mova a nova pra variavel de ambiente (apagar a linha nao tira do historico do git).
6. Ligue o RLS em toda tabela exposta (Supabase): a chave anon vai no frontend.
7. Um grupo por semana: seguranca, banco, deploy, observabilidade, resiliencia e custo.
8. Peca pro Claude explicar um conceito usando o seu proprio codigo. Ex.: "Explique o conceito 14, Idempotencia, usando o meu webhook de pagamento como exemplo, e mostre o que acontece hoje se o mesmo aviso chegar duas vezes."

## Top 15 que mais quebra app de vibe coder

| # | Conceito | Por que |
|---|---|---|
| 67 | Gestao de Segredos | Chave da OpenAI, Stripe ou Supabase com permissao total no repositorio ou no JS do navegador: qualquer um usa a sua conta. |
| 68 | IAM | Tabela num schema exposto sem RLS pode ser lida e escrita por qualquer papel com permissao nela, e a chave anon vai no frontend. |
| 78 | SQL Injection | Query concatenando texto do usuario aparece quando a IA nao usa ORM ou parametros (OWASP Top 10 2025, A05). |
| 79 | XSS | Mostrar comentario, nome ou resposta de IA como HTML sem limpar deixa um usuario rodar script no navegador dos outros. |
| 1 | Limite de Requisicoes | Endpoint que chama IA sem limite por usuario vira conta de API estourada no primeiro robo. |
| 84 | Backups | Sem backup testado, um DELETE sem WHERE vira perda definitiva. |
| 25 | Indices no Banco | Sem indice nas colunas de filtro e juncao, a pagina fica lenta conforme a tabela cresce. |
| 27 | Queries N+1 | Laco com uma query por item: motivo numero um de lista lenta. |
| 14 | Idempotencia | Webhook de pagamento chega repetido por design; sem chave de idempotencia voce libera ou cobra duas vezes. |
| 76 | CORS | Asterisco faz o erro sumir e abre a API pra qualquer site. |
| 81 | Migrations de Banco | Mudar producao direto no painel deixa producao e teste diferentes e quebra o proximo deploy. |
| 11 | Timeouts | Chamada de IA sem timeout segura a funcao serverless ate o limite e voce paga pelo tempo parado. |
| 88 | Otimizacao de Custos | Sem limite de gasto e custo por usuario, recurso de IA popular da prejuizo por usuario ativo. |
| 62 | Alertas | Sem alerta de taxa de erro, voce descobre que o login quebrou pela reclamacao no Instagram. |
| 28 | Pool de Conexoes | Serverless abrindo conexao nova a cada chamada esgota o Postgres no primeiro pico. |

## Os 111, por grupo

### Rede, entrada e protocolos
- **3. Balanceamento de Carga** — distribuir requisicoes entre varias copias; sem ele um servidor lotado derruba o app.
- **4. Proxies Reversos** — Nginx/Cloudflare na frente do app; morde quando o IP real some dos logs.
- **5. API Gateways** — porta unica com autenticacao, limite e roteamento; falta quando cada rota faz seguranca de um jeito.
- **9. Descoberta de Servicos** — como um servico acha o outro quando IPs mudam; quebra com endereco fixo no codigo.
- **22. WebSockets** — conexao bidirecional; morde quando o serverless derruba a conexao ou o numero estoura o plano.
- **23. Long Polling** — servidor segura a resposta ate ter novidade; plano B quando WebSocket falha.
- **24. Server-Sent Events** — servidor empurra eventos via HTTP; jeito simples de streaming de IA, quebra atras de proxy com buffer.
- **48. CDN** — arquivos estaticos perto do usuario.
- **95. Particoes de Rede** — partes do sistema perdem contato e tomam decisoes diferentes.
- **96. Clock Skew** — relogios fora de sincronia; token expira antes da hora, eventos fora de ordem.
- **97. DNS** — mudanca leva horas pra propagar no dia do lancamento.
- **98. TCP vs UDP** — entrega garantida vs velocidade; importa pra jogo, voz e video.
- **99. HTTP/2 e HTTP/3** — varias requisicoes na mesma conexao; normalmente prontas na CDN.
- **100. gRPC** — binario e tipado entre servicos; dificil de chamar direto do navegador.
- **101. Webhooks** — servico avisa o seu por HTTP; quebra sem conferir assinatura ou processando o mesmo aviso duas vezes.

### Desempenho e cache
- **2. Cache** — guardar resultado caro; sem ele cada visita refaz a mesma query.
- **49. Cache na Borda** — respostas na CDN; morde quando dado de um usuario e servido pra outro.
- **50. Invalidacao de Cache** — saber quando jogar fora o cache velho; preco desatualizado inexplicavel.
- **89. Cold Starts** — atraso da primeira chamada serverless.
- **91. Latencia** — cada chamada em serie soma no tempo de espera.
- **92. Throughput** — requisicoes por segundo que o sistema aguenta.
- **93. Latencia P99** — o 1% mais lento; a media esconde.
- **94. Latencia de Cauda** — basta uma chamada lenta pra pagina inteira ficar lenta.

### Resiliencia
- **1. Limite de Requisicoes** — teto por usuario/IP; sem ele um script derruba a API ou queima o credito de IA.
- **10. Circuit Breakers** — parar de chamar servico que falha; senao a API de terceiro derruba o seu app junto.
- **11. Timeouts** — tempo maximo de espera; sem ele chamadas penduradas travam o servidor.
- **12. Retries** — tentar de novo; morde quando repete cobranca ou e-mail.
- **13. Backoff Exponencial** — esperar cada vez mais, com aleatoriedade (jitter).
- **14. Idempotencia** — mesma operacao duas vezes, mesmo resultado; evita cobranca dupla.
- **44. Backpressure** — mandar o produtor ir mais devagar; senao a fila cresce ate a memoria acabar.
- **56. Health Checks** — rota que diz se o app esta vivo.
- **57. Liveness e Readiness Probes** — vivo vs pronto pra trafego; confundir reinicia o app em loop.

### Filas, eventos e tarefas
- **15. Filas de Mensagens** — trabalho pesado (PDF, e-mail, IA) fora da requisicao.
- **16. Pub/Sub** — evento entregue a varios assinantes; assinante caido perde mensagens em silencio.
- **17. Arquitetura Orientada a Eventos** — reacao a eventos; complica o debug.
- **18. Transacoes Distribuidas** — pagamento passa e o pedido nao e criado.
- **19. Padrao Saga** — passos com acao de desfazer pra estornar falhas parciais.
- **20. Dead Letter Queues** — destino de mensagens que falharam varias vezes.
- **21. Cron Jobs** — rodam em duas instancias ao mesmo tempo ou param sem ninguem perceber.

### Banco de dados
- **25. Indices no Banco** — query que voava com 100 linhas leva segundos com 1 milhao.
- **26. Otimizacao de Queries** — ler so o que precisa; evitar SELECT de tudo.
- **27. Queries N+1** — erro mais comum de codigo gerado por IA.
- **28. Pool de Conexoes** — reaproveitar conexoes; serverless sem pool esgota o Postgres.
- **29. Replicas de Leitura** — usuario salva e nao ve a mudanca por ler da replica atrasada.
- **30. Sharding** — dividir dados em varios bancos; caro de desfazer.
- **31. Particionamento** — dividir tabela grande (ex.: por data).
- **32. Replicacao** — copias sincronizadas; meca o atraso.
- **33. Eleicao de Lider** — evita dois servidores rodando o mesmo job.
- **34. Teorema CAP** — com a rede caindo, escolher entre disponibilidade e consistencia.
- **35. Consistencia Eventual** — saldo diferente em duas telas.
- **36. Lock Otimista** — salvar so se a versao nao mudou; senao uma edicao apaga a outra.
- **37. Lock Pessimista** — travar o registro; morde quando a trava fica presa.
- **38. Locks Distribuidos** — trava entre servidores (ex.: Redis).
- **81. Migrations de Banco** — mudancas versionadas e aplicadas em ordem.
- **82. Versionamento de Schema** — mudanca que nao quebra a versao do app ainda no ar.

### Concorrencia e memoria
- **39. Condicoes de Corrida** — dois usuarios comprando o ultimo ingresso.
- **40. Deadlocks** — transacoes esperando uma pela outra pra sempre.
- **41. Vazamento de Memoria** — servidor mais lento a cada hora.
- **42. Coleta de Lixo** — pausas aleatorias na resposta.
- **43. Thread Safety** — variavel global vira bagunca sob carga.

### Escala e infraestrutura
- **7. Docker** — resolve o "funciona na minha maquina".
- **8. Kubernetes** — morde quando adotado cedo demais.
- **45. Autoscaling** — escala sem teto e a fatura chega multiplicada.
- **46. Escala Horizontal** — mais maquinas iguais; exige app sem estado em memoria.
- **47. Escala Vertical** — maquina maior; tem teto e e ponto unico de falha.
- **86. Deploy Multirregiao** — dobra custo e complexidade; quase nunca e o primeiro passo.
- **90. Limites do Serverless** — tempo, memoria e tamanho de resposta; geracao com IA cortada no meio.
- **104. Infraestrutura como Codigo** — ambiente recriavel a partir de arquivos versionados.
- **105. Terraform** — ferramenta mais usada de IaC.
- **106. Helm Charts** — so fazem sentido se voce ja usa Kubernetes.

### Deploy e versoes
- **6. CI/CD** — testar e publicar automaticamente a cada commit.
- **51. Feature Flags** — desligar em 1 minuto a funcao que quebrou.
- **52. Deploy Blue-Green** — dois ambientes, troca de uma vez, volta trocando de novo.
- **53. Releases Canario** — versao nova pra uma fatia pequena primeiro.
- **54. Rolling Deploys** — servidores atualizados aos poucos; versoes nova e velha convivem.
- **55. Rollbacks** — caminho testado pra voltar rapido.
- **102. Versionamento de API** — app de celular desatualizado continua funcionando.
- **103. Versionamento Semantico** — maior.menor.correcao.
- **107. Cache de Build** — deploys mais rapidos e baratos.
- **108. Inferno de Dependencias** — a IA adora instalar pacote que conflita.

### Observabilidade
- **58. Monitoramento** — CPU, memoria, erros e tempo de resposta o tempo todo.
- **59. Logs** — falta o log do erro, ou ele grava senha e token.
- **60. Rastreamento Distribuido** — qual servico deixou a pagina lenta.
- **61. Metricas** — requisicoes por minuto, taxa de erro.
- **62. Alertas** — alerta demais vira ruido.
- **63. SLOs** — meta de confiabilidade (ex.: 99,9% sem erro).
- **64. SLIs** — numero medido (ex.: % de respostas < 300 ms).
- **65. Error Budgets** — acabou o orcamento, prioridade vira estabilidade.
- **66. Observabilidade** — entender o sistema por logs, metricas e rastros.

### Seguranca
- **67. Gestao de Segredos** — chaves fora do codigo, em variaveis de ambiente ou cofre.
- **68. IAM** — quem pode fazer o que; nada rodando como admin, nenhuma tabela aberta.
- **69. OAuth** — validar state e redirect.
- **70. Rotacao de JWT** — senao um token vazado vale pra sempre.
- **71. TLS** — servico interno ou webhook aceitando HTTP puro.
- **72. Criptografia em Repouso** — backup vazado legivel.
- **73. Criptografia em Transito** — inclusive entre seus servicos e o banco.
- **74. WAF** — bloqueia ataque conhecido antes do codigo.
- **75. Protecao contra DDoS** — ataque barato tira o app do ar ou estoura a conta.
- **76. CORS** — nunca asterisco.
- **77. CSRF** — site malicioso usa o navegador logado do usuario.
- **78. SQL Injection** — query por concatenacao de string.
- **79. XSS** — HTML do usuario sem limpar.
- **80. SSRF** — servidor buscando URL interna; risco de importar link ou gerar previa.

### Recuperacao e operacao
- **83. Recuperacao de Desastres** — quanto dado da pra perder e em quanto tempo volta.
- **84. Backups** — backup nunca restaurado e so uma esperanca.
- **85. Failover** — trafego pra reserva, de preferencia automatico e testado.
- **87. Engenharia do Caos** — quebrar de proposito em ambiente controlado.
- **88. Otimizacao de Custos** — custo de cada recurso e chamada de IA.
- **109. Incidentes em Producao** — jeito combinado de detectar, comunicar e resolver.
- **110. Plantao** — alguem responde alertas fora do horario.
- **111. Postmortems** — analise sem culpado: causa, impacto, o que muda.

---

## Prompts

Todos assumem que o Claude esta dentro da pasta do projeto. Regras comuns (cole ao final de cada prompt):

> Regras: trabalhe so com o que existe no meu codigo, cite o arquivo e a linha de cada achado, nao invente problema pra preencher lista, e nao mude nada sem me mostrar o plano antes. Faca uma mudanca por vez, com teste, e me diga como conferir que funcionou.

### 1. Auditoria completa por prioridade

```
Voce e um engenheiro senior revisando um app feito com IA antes de ele receber usuarios de verdade. A lista de 111 conceitos de engenharia esta em docs/111-conceitos.md.

Contexto: [O QUE O APP FAZ], stack [STACK], [NUMERO] usuarios hoje, [TEM OU NAO] pagamento, [TEM OU NAO] dado pessoal de cliente.

Audite o meu projeto contra a lista e me entregue:
1. Uma tabela com: numero do conceito, situacao no meu projeto (ok, falta, nao se aplica agora), evidencia com arquivo e linha, e risco.
2. As 10 correcoes mais urgentes, ordenadas por impacto e facilidade, cada uma com o esforco estimado em horas.
3. Os conceitos que NAO fazem sentido pro meu tamanho hoje, com o motivo, pra eu nao perder tempo.

[REGRAS]
```

### 2. Top 15

```
Confira o meu projeto nestes 15 pontos, nesta ordem, e corrija o que estiver errado:
1. Gestao de segredos: nenhuma chave secreta no repositorio, no historico do git ou no codigo que vai pro navegador.
2. Permissoes: toda tabela exposta com RLS ligado e politica por usuario, e nenhuma rota de admin aberta.
3. SQL injection: nenhuma query montada concatenando texto do usuario.
4. XSS: nenhum HTML vindo do usuario ou da IA renderizado sem sanitizar.
5. Limite de requisicoes em login, cadastro e em toda rota que chama IA ou manda e-mail.
6. Backups automaticos e um teste de restauracao documentado.
7. Indices nas colunas usadas em filtro, ordenacao e juncao.
8. Queries N+1 em listas.
9. Idempotencia em webhooks de pagamento e em qualquer acao que cobra ou envia algo.
10. CORS restrito aos meus dominios.
11. Toda mudanca de banco por migration versionada.
12. Timeout em toda chamada externa, inclusive APIs de IA.
13. Limite de gasto e custo por usuario das APIs pagas.
14. Alerta de taxa de erro e de queda.
15. Pool de conexoes com o banco nas funcoes serverless.

Pra cada ponto: ok ou problema, evidencia com arquivo e linha, e a correcao.

[REGRAS]
```

### 3. Prompt por grupo (modelo)

```
Analise o meu projeto inteiro olhando so o grupo [GRUPO]:
[ITENS DO GRUPO]

Contexto do projeto: [STACK, EX.: NEXT.JS NA VERCEL, SUPABASE, STRIPE, OPENAI]. Usuarios hoje: [NUMERO]. Fase: [PROTOTIPO, BETA OU EM PRODUCAO COM CLIENTE PAGANDO].

Pra cada item: diga se ele se aplica ao meu projeto, o que esta certo, o que falta e o risco real em uma frase. [FOCO DO GRUPO]

Depois, corrija os problemas de prioridade alta, um de cada vez.
[REGRAS]
```

| Grupo | Itens | Foco do grupo |
|---|---|---|
| Seguranca | Gestao de Segredos, IAM, OAuth, Rotacao de JWT, TLS, Criptografia em Repouso, Criptografia em Transito, WAF, Protecao contra DDoS, CORS, CSRF, SQL Injection, XSS, SSRF | Use o OWASP Top 10 de 2025 como referencia e comece por segredos expostos, permissoes e injecao. |
| Banco de dados | Indices no Banco, Otimizacao de Queries, Queries N+1, Pool de Conexoes, Replicas de Leitura, Consistencia Eventual, Lock Otimista, Condicoes de Corrida, Migrations de Banco, Versionamento de Schema, Backups | Rode EXPLAIN nas 5 queries mais usadas e mostre o antes e o depois de cada indice. |
| Deploy e versoes | CI/CD, Feature Flags, Deploy Blue-Green, Releases Canario, Rollbacks, Health Checks, Liveness e Readiness Probes, Versionamento de API, Cache de Build, Inferno de Dependencias | Quero sair com um caminho de rollback testado e um pipeline que roda teste antes de publicar. |
| Observabilidade | Monitoramento, Logs, Rastreamento Distribuido, Metricas, Alertas, SLOs, SLIs, Error Budgets, Observabilidade | Proponha 3 SLIs e 1 SLO realistas pro meu tamanho e os alertas minimos, sem ferramenta paga se der. |
| Resiliencia e filas | Limite de Requisicoes, Circuit Breakers, Timeouts, Retries, Backoff Exponencial, Idempotencia, Filas de Mensagens, Dead Letter Queues, Cron Jobs, Backpressure, Webhooks | Comece pelas chamadas a APIs de terceiros e pelos webhooks. |
| Custo e recuperacao | Autoscaling, Recuperacao de Desastres, Backups, Failover, Otimizacao de Custos, Cold Starts, Limites do Serverless, Incidentes em Producao, Plantao, Postmortems | Calcule o custo por usuario ativo das APIs pagas e escreva o plano de 1 pagina do que fazer quando o app cair. |

---

## Checklist antes de usuario pagante

- [ ] Nenhuma chave secreta no repositorio nem no codigo do navegador
- [ ] Toda tabela exposta tem RLS ou regra de acesso por usuario
- [ ] Login, cadastro e rotas de IA tem limite de requisicoes
- [ ] O backup existe e ja foi restaurado em teste
- [ ] O webhook de pagamento aguenta o mesmo aviso chegando duas vezes
- [ ] Existe alerta quando a taxa de erro sobe

## Links

- OWASP Top 10 2025: https://owasp.org/Top10/2025/
- OWASP Cheat Sheets: https://cheatsheetseries.owasp.org/
- Secrets Management: https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
- RLS no Supabase: https://supabase.com/docs/guides/database/postgres/row-level-security
- Idempotencia no Stripe: https://docs.stripe.com/api/idempotent_requests
- Timeouts, retries e backoff: https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/
- SLOs (Google SRE): https://sre.google/sre-book/service-level-objectives/
- Postmortem sem culpado: https://sre.google/sre-book/postmortem-culture/
- Twelve-Factor config: https://12factor.net/config
- Claude Code: https://code.claude.com/docs/en/overview
