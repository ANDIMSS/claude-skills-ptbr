# Skills PT-BR para Claude Code

Skills em português para quem cria apps com IA e quer checar o projeto antes de lançar.

| Skill | O que faz | Como chamar |
|---|---|---|
| `revisar-seguranca` | Varre o projeto atrás de chaves vazando, rotas sem autenticação, tabelas Supabase sem RLS, SQL injection, CORS aberto, `.env` versionado e dependências vulneráveis. Entrega relatório com gravidade e correção. | `/revisar-seguranca` ou "revisa a segurança" |
| `auditoria-111` | Audita o projeto contra 111 conceitos de engenharia (segredos, permissões, backup, idempotência, migrations, timeouts, custo, alertas...). Modos `top15`, `completa`, `grupo <nome>`, `explicar <n>`. | `/auditoria-111 top15` |

## Instalar (recomendado: plugin)

No Claude Code:

```
/plugin marketplace add ANDIMSS/claude-skills-ptbr
/plugin install skills-ptbr@skills-ptbr
```

## Instalar manualmente

```bash
git clone https://github.com/ANDIMSS/claude-skills-ptbr
cp -r claude-skills-ptbr/plugins/skills-ptbr/skills/* ~/.claude/skills/
```

Reinicie o Claude Code depois de copiar.

## Licença

MIT
