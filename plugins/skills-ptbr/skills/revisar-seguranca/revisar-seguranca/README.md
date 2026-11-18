# Skill: Revisar Segurança

Revisão de segurança automática do seu projeto, pensada pra vibe coder solo. O Claude varre o código e aponta chave/segredo vazando, rota e API sem autenticação, tabela do Supabase sem RLS, exposição no front-end, validação faltando e mais — com relatório simples (gravidade + como corrigir).

## Instalar
1. Descompacte e copie a pasta `revisar-seguranca` inteira para:
   - macOS/Linux: `~/.claude/skills/`
   - Windows: `%USERPROFILE%\.claude\skills\`
2. Reinicie o Claude Code (`claude`).
3. Dentro do seu projeto, é só pedir: **"revisa a segurança do meu projeto"** (ou "tem chave vazando?", "checa as rotas e o RLS"). A skill ativa sozinha.

## Não quer instalar?
Abra o `PROMPT-CLAUDE-CODE.md`, copie o prompt e cole no seu Claude Code (aberto na pasta do projeto).

## Opção avançada (CI / Pull Requests)
Pra revisar automaticamente em cada PR, use a ferramenta oficial da Anthropic:
`/security-review` + a GitHub Action de https://github.com/anthropics/claude-code-security-review
