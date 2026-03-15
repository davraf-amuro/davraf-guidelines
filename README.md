# davraf-guidelines

my personal instructons and promps for ia agents

Questo repository contiene un **template completo** per progetti .NET 10 Minimal API con linee guida integrate per GitHub Copilot.

## 📦 Contenuto del Template

La cartella `your-solution-root/` contiene tutti i file che devono essere copiati nella root di un nuovo progetto Visual Studio.

### File Inclusi

| File/Cartella | Scopo | Influenza Copilot |
|---------------|-------|-------------------|
| `.github/copilot-instructions.md` | Istruzioni principali per Copilot | ✅ SÌ - Letto automaticamente |
| `.github/instructions/*.md` | Istruzioni modulari dettagliate | ✅ SÌ - Referenziate da Copilot |
| `.editorconfig` | Stile di codice e naming conventions | ✅ SÌ - Influenza codice generato |
| `Directory.Build.props` | Configurazione MSBuild centralizzata | ⚠️ Indiretto - Standard di progetto |
| `global.json` | Versione .NET SDK | ❌ NO - Solo per build |
| `.gitignore` | File ignorati da Git | ❌ NO - Solo per Git |
| `.gitattributes` | Normalizzazione line endings | ❌ NO - Solo per Git |
| `README.md` | Documentazione del progetto | ⚠️ Possibile - Copilot può leggerlo |

## 🚀 Avvio Rapido

Apri **PowerShell** ed esegui un solo comando:

```powershell
irm https://raw.githubusercontent.com/davraf-amuro/davraf-guidelines/main/New-DavrafProject.ps1 | iex
```

Lo script chiede il nome del progetto e la cartella di destinazione, copia tutti i file del template e apre la cartella in Explorer. Nessuna installazione richiesta.

> **Prerequisiti:** PowerShell 5.1+, connessione internet. Git opzionale (usato se disponibile, altrimenti scarica ZIP).

---

## 📋 Procedura Manuale (alternativa)

### 1. Crea un Nuovo Progetto Visual Studio

```powershell
# Opzione A: Crea solution vuota in Visual Studio
# File > New > Project > Blank Solution

# Opzione B: Usa dotnet CLI
dotnet new sln -n MioProgetto
cd MioProgetto
dotnet new webapi -minimal -n MioProgetto.Api -o src/MioProgetto.Api
dotnet sln add src/MioProgetto.Api
```

### 2. Copia i File del Template

```powershell
# Dalla cartella del tuo nuovo progetto
cd C:\Path\To\MioProgetto

# Copia TUTTO il contenuto di your-solution-root
xcopy "C:\TWTCollection\Raffagli\Davraf_Guidelines\your-solution-root\*" . /E /H /I /Y

# Oppure copia manualmente con Esplora File
```

**ATTENZIONE**: Assicurati di copiare anche i file nascosti (`.editorconfig`, `.gitignore`, `.gitattributes`, `.github/`)

### 3. Personalizza i File

#### A. `Directory.Build.props`

```xml
<PropertyGroup>
  <!-- Aggiorna con il nome del tuo progetto -->
  <Product>Il Mio Progetto API</Product>
</PropertyGroup>
```

#### B. `.github/copilot-instructions.md`

Opzionale: Personalizza la sezione "Naming" se usi convenzioni diverse:

```markdown
### Naming
- Namespace: `mio_progetto.api` (aggiorna con il tuo namespace)
```

#### C. `README.md`

Sostituisci il contenuto con informazioni specifiche del tuo progetto.

### 4. Verifica GitHub Copilot

1. Apri Visual Studio
2. Vai su **Tools** > **Options** > **GitHub Copilot**
3. Verifica che Copilot sia abilitato
4. Prova a scrivere codice e verifica che Copilot suggerisca codice secondo le tue linee guida

### 5. Inizia lo Sviluppo

GitHub Copilot ora:
- ✅ Seguirà le convenzioni di naming definite in `.editorconfig`
- ✅ Userà i pattern architetturali definiti in `.github/copilot-instructions.md`
- ✅ Genererà endpoint seguendo le 9 regole di `minimal-api-architecture.instructions.md`
- ✅ Creerà provider database seguendo il template in `database-provider.instructions.md`

## 🧪 Test del Template

Per verificare che tutto funzioni:

### Test 1: EditorConfig
1. Crea una nuova classe C# in Visual Studio
2. Visual Studio dovrebbe formattare automaticamente secondo `.editorconfig`
3. I campi privati dovrebbero avere prefisso `_`

### Test 2: Copilot Instructions
1. Crea un nuovo file `Endpoints/TestMapping.cs`
2. Inizia a scrivere: `public static class TestMapping`
3. Copilot dovrebbe suggerire un extension method con il pattern corretto:
   ```csharp
   public static IEndpointRouteBuilder MapTestEndpoints(
       this IEndpointRouteBuilder routes,
       ApiVersionSet versionSet)
   ```

### Test 3: Directory.Build.props
1. Apri le proprietà del progetto
2. Verifica che Target Framework sia `.NET 10`
3. Verifica che Nullable sia abilitato

## 📁 Struttura Raccomandata Post-Setup

Dopo aver copiato il template, la struttura dovrebbe essere:

```
MioProgetto/
├── .github/
│   ├── copilot-instructions.md
│   └── instructions/
│       ├── minimal-api-architecture.instructions.md
│       └── database-provider.instructions.md
├── src/
│   └── MioProgetto.Api/
│       ├── MioProgetto.Api.csproj
│       ├── Program.cs
│       ├── Endpoints/
│       ├── Infrastructure/
│       ├── Dto/
│       └── Transformers/
├── test/
│   └── MioProgetto.Tests/
├── .editorconfig
├── .gitignore
├── .gitattributes
├── Directory.Build.props
├── global.json
├── MioProgetto.sln
└── README.md
```

## ❓ FAQ

### Q: Devo committare i file `.github/`?
**A:** SÌ! Questi file devono essere in Git per essere letti da Copilot.

### Q: Posso modificare le istruzioni di Copilot?
**A:** SÌ, personalizza `.github/copilot-instructions.md` e i file in `instructions/` per il tuo progetto.

### Q: Funziona con Visual Studio Code?
**A:** SÌ, ma per VS Code è consigliabile aggiungere anche `.vscode/settings.json` con configurazioni specifiche.

### Q: Funziona con Rider?
**A:** SÌ, `.editorconfig` e GitHub Copilot funzionano anche in JetBrains Rider.

### Q: Posso usare .NET 8 invece di .NET 10?
**A:** SÌ, modifica `Directory.Build.props` e `global.json` con la versione desiderata.

### Q: GitHub Copilot non segue le mie istruzioni
**A:** Verifica che:
   1. Il file `.github/copilot-instructions.md` sia committato in Git
   2. Copilot sia abilitato in Visual Studio
   3. Hai riavviato Visual Studio dopo aver aggiunto i file

## 🆘 Troubleshooting

### Problema: EditorConfig non viene applicato
**Soluzione:**
- Visual Studio: Tools > Options > Text Editor > C# > Code Style > General > Verifica che "Enable EditorConfig support" sia attivo
- Riavvia Visual Studio

### Problema: Copilot non legge le istruzioni
**Soluzione:**
- Verifica che il file sia in `.github/copilot-instructions.md` (non `copilot_instructions` o altre varianti)
- Assicurati che il file sia committato in Git
- Chiudi e riapri la solution

### Problema: Build errors con Directory.Build.props
**Soluzione:**
- Verifica che la versione .NET specificata sia installata
- Controlla che non ci siano conflitti con impostazioni nei file `.csproj`

---

## 🤖 Claude Code Skills

Questo repository include anche skill per **Claude Code** nella cartella `.claude/skills/`.

### `/tavolo` — Tavolo di Lavoro Multi-Agente

Simula una sessione di review con 4 esperti in parallelo (Architetto, Backend, Interface, UX) che analizzano una domanda tecnica o di prodotto da angolazioni diverse.

**Setup:** copia `.claude/skills/` nella tua `~/.claude/skills/` per renderla disponibile globalmente.

```
cp -r .claude/skills/tavolo ~/.claude/skills/tavolo
```

**Uso in Claude Code:**
```
/tavolo come strutturiamo l'autenticazione in questa Minimal API?
```

---

*Documento aggiornato: Gennaio 2025*
