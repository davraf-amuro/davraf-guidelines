# davraf-guidelines

Linee guida e istruzioni personali per agenti AI applicati a progetti .NET 10 Minimal API.

Questo repository raccoglie istruzioni, prompt e configurazioni pronte all'uso per guidare GitHub Copilot e altri agenti AI nella generazione di codice coerente con le mie convenzioni di progetto.

---

## Utilizzo come Git Submodule

L'approccio consigliato è aggiungere questo repo come **submodule** nella root della solution o della working folder. Lo script `setup.ps1` crea symlink che puntano ai file del submodule, quindi un semplice `git submodule update --remote` basta per ricevere tutti gli aggiornamenti futuri.

### 1. Aggiungi il submodule al progetto

```powershell
cd C:\MioProgetto

git submodule add https://github.com/Davraf/davraf-guidelines.git davraf-guidelines
```

### 2. Esegui il setup (richiede privilegi amministratore per i symlink)

```powershell
.\davraf-guidelines\setup.ps1
```

Lo script crea symlink nella root del progetto che puntano al submodule:

| Symlink creato | Sorgente nel submodule |
|---|---|
| `.editorconfig` | `davraf-guidelines/.editorconfig` |
| `Directory.Build.props` | `davraf-guidelines/Directory.Build.props` |
| `global.json` | `davraf-guidelines/global.json` |
| `.gitignore` | `davraf-guidelines/.gitignore` |
| `.gitattributes` | `davraf-guidelines/.gitattributes` |
| `.github/` | `davraf-guidelines/.github/` |

Se `.github/` esiste già, lo script collega i singoli file invece di sostituire la cartella.

### 3. Personalizza (opzionale)

**`Directory.Build.props`** — aggiorna il nome del prodotto:
```xml
<Product>Il Mio Progetto API</Product>
```

**`.github/copilot-instructions.md`** — personalizza namespace e convenzioni specifiche del progetto.

### 4. Struttura risultante nel progetto host

```
MioProgetto/
├── davraf-guidelines/       ← submodule (git repo autonomo)
├── .github/                 ← symlink → davraf-guidelines/.github/
│   ├── copilot-instructions.md
│   ├── instructions/
│   └── prompts/
├── .editorconfig            ← symlink
├── Directory.Build.props    ← symlink
├── global.json              ← symlink
├── .gitignore               ← symlink
├── .gitattributes           ← symlink
├── src/
└── MioProgetto.sln
```

---

## Aggiornamenti

Per ricevere le ultime linee guida:

```powershell
git submodule update --remote davraf-guidelines
```

I symlink puntano già ai file aggiornati — nessuna operazione aggiuntiva necessaria.

---

## Contenuto del Repository

| File/Cartella | Scopo | Letto da Copilot |
|---|---|---|
| `.github/copilot-instructions.md` | Istruzioni principali | ✅ Automaticamente |
| `.github/instructions/*.md` | Istruzioni modulari | ✅ Referenziate |
| `.github/prompts/*.md` | Prompt riutilizzabili | ✅ Su richiesta |
| `.editorconfig` | Naming e stile | ✅ Influenza codice |
| `Directory.Build.props` | Config MSBuild | ⚠️ Indiretto |
| `global.json` | Versione .NET SDK | ❌ Solo build |
| `setup.ps1` | Script di installazione | — |

---

## Prerequisiti

- **Git** con supporto submodule
- **PowerShell** con privilegi amministratore (per la creazione di symlink su Windows)
- **GitHub Copilot** attivo in Visual Studio o VS Code

---

*Aggiornato: Marzo 2026*
