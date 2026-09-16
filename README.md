# davraf-guidelines — repository non più mantenuto

> ⚠️ **Questo repository è stato sostituito dalla suite `dr-*`.** Il contenuto è stato migrato nei repository elencati sotto; qui non vengono più accettate modifiche. Per segnalazioni e richieste, apri una issue nel repository del pacchetto pertinente.

Le linee guida personali per progetti integrati con GitHub Copilot e Claude Code vivevano in un unico repository, aggiunto ai progetti come submodule git. Oggi sono divise in pacchetti installabili singolarmente: un progetto host installa solo quelli che gli servono, tramite installer standalone e senza `.gitmodules`.

## Dove è finito il contenuto

| Pacchetto | Repository | Cosa contiene |
|---|---|---|
| **dr-guidelines** (core) | [davraf-amuro/dr-guidelines](https://github.com/davraf-amuro/dr-guidelines) | Istruzioni e skill trasversali (ciclo di sviluppo, tracciamento piani, dati sensibili, validazione, logging, documentazione), catalogo dei pacchetti e meccanismo di installazione |
| dr-dotnet-backend | [davraf-amuro/dr-dotnet-backend](https://github.com/davraf-amuro/dr-dotnet-backend) | Base backend .NET condivisa, audit del codice backend |
| dr-minimalapi | [davraf-amuro/dr-minimalapi](https://github.com/davraf-amuro/dr-minimalapi) | Architettura Minimal API .NET, prompt endpoint e scaffolding |
| dr-winsvc | [davraf-amuro/dr-winsvc](https://github.com/davraf-amuro/dr-winsvc) | Windows Service / Worker .NET |
| dr-efdb | [davraf-amuro/dr-efdb](https://github.com/davraf-amuro/dr-efdb) | Entity Framework Core, provider database, resilienza in avvio |
| dr-fe | [davraf-amuro/dr-fe](https://github.com/davraf-amuro/dr-fe) | Organizzazione frontend e audit |
| dr-devops | [davraf-amuro/dr-devops](https://github.com/davraf-amuro/dr-devops) | Docker Swarm, Portainer, CI/CD |

## Come si usa adesso

Tutte le istruzioni aggiornate — installazione su un progetto nuovo o esistente, aggiornamento dei pacchetti, elenco delle skill — stanno nel README del core:

**→ [davraf-amuro/dr-guidelines](https://github.com/davraf-amuro/dr-guidelines)**

## Se hai ancora questo repository come submodule

Il submodule continua a funzionare e nessun progetto si rompe: semplicemente non riceverà più aggiornamenti. Per passare alla suite `dr-*`, esegui dalla radice del progetto host l'installer del core e poi quello dei pacchetti di dominio che ti servono (procedura nel README del core), quindi rimuovi il submodule quando hai verificato che tutto è al suo posto.

---

*Contenuto migrato nella suite `dr-*` il 2026-09-16 — questo repository non è più mantenuto*
