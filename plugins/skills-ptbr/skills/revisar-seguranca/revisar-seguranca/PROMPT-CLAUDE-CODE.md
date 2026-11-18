# Prompt — Revisão de Segurança (copie e cole no seu Claude Code)

> Use isto se você NÃO quiser instalar a skill. Abra o Claude Code DENTRO da pasta do seu projeto e cole o prompt abaixo.

```
Você é um especialista em segurança de aplicações. Faça uma REVISÃO DE SEGURANÇA COMPLETA deste projeto e me entregue um relatório claro, em português, que eu (que não sou programador) consiga entender e agir. Não invente problema, aponte só o que realmente existe no código.

Analise o projeto inteiro procurando, nesta ordem de prioridade:

1) CHAVES E SEGREDOS VAZANDO (o mais crítico)
   - API keys, tokens, senhas ou chaves hardcoded no código
   - Arquivo .env versionado por engano (confira o .gitignore e rode: git ls-files | grep -i env)
   - Chave secreta exposta no front-end (variável NEXT_PUBLIC_ com valor sensível, ou Service Role Key do Supabase usada no client)

2) ROTAS E APIs DESPROTEGIDAS
   - Endpoints/rotas de API sem checagem de autenticação (qualquer um acessa)
   - Falta de autorização (um usuário acessando dado de outro)
   - Falta de validação dos dados que chegam (input validation)

3) BANCO DE DADOS
   - Tabelas do Supabase SEM Row-Level Security (RLS) ativo
   - Queries vulneráveis a SQL injection

4) OUTROS
   - CORS aberto demais, falta de rate limit em rotas públicas
   - Dependências com vulnerabilidade conhecida (rode npm audit ou pnpm audit)
   - Dados sensíveis em logs

Pra cada problema, me diga:
- 🔴 crítico / 🟡 médio / 🟢 baixo
- o arquivo e a linha
- o risco em 1 frase simples
- como corrigir

Comece me mostrando primeiro os problemas CRÍTICOS. Nunca cole o valor de uma chave que encontrar (só diga onde está). No fim, me pergunte se quero que você corrija os críticos, um por um.
```

## Depois do relatório
- Peça pra ele **corrigir os críticos primeiro** (chave vazando, rota sem auth, tabela sem RLS).
- Se ele achar chave vazada, **troque/rotacione a chave** no provedor (a antiga já foi exposta) e remova do código.
- Rode de novo antes de cada deploy importante.
