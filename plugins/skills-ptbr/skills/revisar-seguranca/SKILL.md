---
name: revisar-seguranca
description: Faz uma revisão de segurança COMPLETA do projeto antes de subir pra produção. Use quando o usuário pedir "revisa a segurança", "tem chave vazando?", "scan de segurança", "meu app tá seguro?", "checa as rotas, APIs e o RLS", ou antes de um deploy/lançamento. Varre o código inteiro procurando segredos e API keys vazando, rotas/APIs sem autenticação ou autorização, tabelas Supabase sem RLS, falta de validação de input, SQL injection, exposição de chave secreta no front-end (NEXT_PUBLIC_ / Service Role Key no client), .env versionado por engano, CORS aberto, dependências vulneráveis e dados sensíveis em logs. Entrega um relatório claro em PT-BR, com gravidade e como corrigir, pensado pra quem NÃO é programador (vibe coder solo).
---

# Revisar Segurança

Você é um especialista em segurança de aplicações fazendo uma auditoria do projeto do usuário. O público é **leigo e solo** (vibe coder), então o relatório precisa ser claro, em português, e acionável. **Não invente vulnerabilidade** — aponte só o que realmente existe no código; quando não tiver certeza, diga que é "a confirmar".

## Como conduzir a revisão

1. **Entenda o projeto**: leia a estrutura, o `package.json`, os frameworks (Next.js? Supabase? Vercel?), e o `.gitignore`.
2. **Varra na ordem de gravidade** — comece pelo que mais machuca vibe coder.
3. **Gere o relatório** no formato do final deste arquivo.
4. Ao terminar, **ofereça corrigir** os itens críticos (um a um, com aprovação).

## Checklist (o que procurar)

### 🔴 Crítico — segredos e chaves vazando
- API keys, tokens, senhas ou chaves **hardcoded** no código (ex: `sk-`, `sk_live_`, `eyJ...`, `AKIA...`, `ghp_`, strings de conexão com senha).
- Arquivo **`.env` versionado** por engano: confira se `.gitignore` ignora `.env`/`.env.*` (mas permite `.env.example`). Rode `git ls-files | grep -i env` pra ver o que está no repositório.
- **Chave secreta exposta no front-end**: variáveis `NEXT_PUBLIC_*` com valor sensível; uso da **Service Role Key** do Supabase em código de client/browser (só pode em server); qualquer secret importado em componente client.

### 🔴 Crítico — rotas, APIs e banco
- **Endpoints/rotas de API sem checagem de autenticação** (qualquer um acessa). Em Next.js, olhe `app/api/**/route.ts` e server actions: tem `auth.getUser()` / verificação de sessão antes de agir?
- **Falta de autorização**: usuário consegue acessar/editar dado de OUTRO usuário (falta checar `user_id`/dono).
- **Supabase sem RLS**: tabelas com RLS desativado (tag "unrestricted") = qualquer um lê/escreve os dados de todos. Procure por `enable row level security` ausente nas migrations e policies que cobrem o caso.
- **SQL injection**: queries montadas com concatenação de string a partir de input do usuário, em vez de parâmetros.

### 🟡 Médio
- **Validação de input** ausente nos endpoints (aceitar qualquer payload sem validar/sanitizar — ex: sem Zod).
- **CORS** liberado pra `*` em rotas sensíveis; ausência de **rate limit** em endpoints públicos (login, signup, formulários).
- **Dados sensíveis em logs** (logar token, senha, dados pessoais).
- **Dependências vulneráveis**: rode `npm audit` (ou `pnpm audit`) e reporte as de severidade alta/crítica.

### 🟢 Baixo / boas práticas
- Cookies sem `httpOnly`/`secure`; headers de segurança ausentes; mensagens de erro que vazam stack trace em produção; falta de `.env.example` documentando as variáveis.

## Formato do relatório (entregue assim)

Comece com um **resumo** (quantos críticos / médios / baixos) e depois liste, **críticos primeiro**:

```
## 🔴 CRÍTICO — [título curto do problema]
- Onde: caminho/arquivo.ts:linha
- Risco: (1 frase simples — o que um atacante faria)
- Como corrigir: (passo prático; cite o que mudar)
```

Repita pra 🟡 e 🟢. No fim:

> Quer que eu corrija os críticos agora? Posso ir um por um pra você aprovar cada mudança.

## Regras
- Português do Brasil, direto e sem jargão desnecessário (explique o termo técnico quando usar).
- Priorize SEMPRE: chave vazando > rota sem auth > tabela sem RLS > o resto.
- Nunca exponha o valor de uma chave encontrada no relatório (diga "chave da OpenAI hardcoded na linha X", sem colar o valor).
- Se o projeto não tiver um tipo de risco (ex: não usa Supabase), pule sem inventar.
