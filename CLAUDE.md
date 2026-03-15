# Linee guida per Claude Code

## Lingua
- Rispondi sempre in **italiano**

## Standard di progetto .NET
@my-minimalapi.md

## Skill Claude Code

### `/tavolo` — Tavolo di Lavoro Multi-Agente
> `.claude/skills/tavolo/SKILL.md`

Lancia 4 agenti in parallelo con ruoli distinti per analizzare una domanda tecnica o di prodotto da più angolazioni:

| Sigla | Ruolo | Focus |
|-------|-------|-------|
| ARCH | Architetto Software | Visione sistemica, debito tecnico, funzione critica |
| BE | Backend Expert | API, database, performance, sicurezza |
| UI | Interface Expert | Componenti, design system, accessibilità |
| UX | User Experience | Flussi utente, bisogni reali, impatto percepito |

**Uso:** `/tavolo [domanda o argomento tecnico]`

**Output:** Posizioni dei 4 esperti → Punti di Tensione → Raccomandazione
