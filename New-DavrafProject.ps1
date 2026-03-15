#Requires -Version 5.1
<#
.SYNOPSIS
    Crea un nuovo progetto .NET a partire dal template davraf-guidelines.
.DESCRIPTION
    Scarica il template davraf-guidelines da GitHub, crea la cartella del progetto
    e copia i file di configurazione pronti all'uso.
.EXAMPLE
    irm https://raw.githubusercontent.com/davraf-amuro/davraf-guidelines/main/New-DavrafProject.ps1 | iex
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# ---------------------------------------------------------------------------
# Costanti
# ---------------------------------------------------------------------------
$REPO_CLONE_URL  = "https://github.com/davraf-amuro/davraf-guidelines.git"
$REPO_ZIP_URL    = "https://github.com/davraf-amuro/davraf-guidelines/archive/refs/heads/main.zip"
$TEMPLATE_SUBDIR = "your-solution-root"

# ---------------------------------------------------------------------------
# Funzioni helper
# ---------------------------------------------------------------------------
function Write-Step {
    param(
        [string]$Message,
        [ValidateSet("INFO","OK","WARN","ERROR")]
        [string]$Status = "INFO"
    )
    $color = switch ($Status) {
        "OK"    { "Green"  }
        "WARN"  { "Yellow" }
        "ERROR" { "Red"    }
        default { "Cyan"   }
    }
    $prefix = switch ($Status) {
        "OK"    { "✓" }
        "WARN"  { "!" }
        "ERROR" { "✗" }
        default { "·" }
    }
    Write-Host "  $prefix  $Message" -ForegroundColor $color
}

function New-HiddenForm {
    # Finestra invisibile come owner per far apparire i dialoghi in primo piano
    $form = New-Object System.Windows.Forms.Form
    $form.Size      = New-Object System.Drawing.Size(0, 0)
    $form.StartPosition = "CenterScreen"
    $form.TopMost   = $true
    $form.ShowInTaskbar = $false
    $form.Show()
    $form.Hide()
    return $form
}

# ---------------------------------------------------------------------------
# Intestazione
# ---------------------------------------------------------------------------
Clear-Host
Write-Host ""
Write-Host "  ┌─────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "  │   Davraf Guidelines — Nuovo Progetto     │" -ForegroundColor Cyan
Write-Host "  └─────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""

$owner = New-HiddenForm

# ---------------------------------------------------------------------------
# Step 1 — Nome del progetto
# ---------------------------------------------------------------------------
$projectName = [Microsoft.VisualBasic.Interaction]::InputBox(
    "Inserisci il nome del progetto (es. MyApi):",
    "Nuovo Progetto Davraf",
    "MyProject"
)

if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Step "Operazione annullata." "WARN"
    $owner.Dispose()
    exit 0
}

# Validazione: nessun carattere illegale per cartelle Windows
if ($projectName -match '[\\/:*?"<>| ]') {
    Write-Step "Nome non valido. Evita spazi e i caratteri: \ / : * ? `" < > |" "ERROR"
    $owner.Dispose()
    exit 1
}

# ---------------------------------------------------------------------------
# Step 2 — Scelta della cartella di destinazione
# ---------------------------------------------------------------------------
$folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$folderDialog.Description       = "Scegli la cartella in cui creare '$projectName'"
$folderDialog.ShowNewFolderButton = $true
$folderDialog.RootFolder        = [System.Environment+SpecialFolder]::UserProfile

$dialogResult = $folderDialog.ShowDialog($owner)

if ($dialogResult -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Step "Operazione annullata." "WARN"
    $owner.Dispose()
    exit 0
}

$parentFolder = $folderDialog.SelectedPath
$projectPath  = Join-Path $parentFolder $projectName

Write-Host ""
Write-Step "Progetto  : $projectName"
Write-Step "Percorso  : $projectPath"
Write-Host ""

# ---------------------------------------------------------------------------
# Step 3 — Cartella già esistente?
# ---------------------------------------------------------------------------
if (Test-Path $projectPath) {
    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "La cartella '$projectPath' esiste già.`nSovrascrivere i file esistenti?",
        "Cartella esistente",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    if ($confirm -ne [System.Windows.Forms.DialogResult]::Yes) {
        Write-Step "Operazione annullata." "WARN"
        $owner.Dispose()
        exit 0
    }
}

$owner.Dispose()

# ---------------------------------------------------------------------------
# Step 4 — Scarica il template (git clone con fallback ZIP)
# ---------------------------------------------------------------------------
$tempDir = Join-Path $env:TEMP "davraf-tmp-$(Get-Random)"
Write-Step "Download template..." "INFO"

$gitAvailable = $null -ne (Get-Command git -ErrorAction SilentlyContinue)

if ($gitAvailable) {
    Write-Step "Clono il repository con git..." "INFO"
    git clone --depth 1 --quiet $REPO_CLONE_URL $tempDir 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Step "git clone fallito. Passo al download ZIP..." "WARN"
        $gitAvailable = $false
    }
}

if (-not $gitAvailable) {
    Write-Step "Scarico il template come archivio ZIP..." "INFO"
    $zipPath = Join-Path $env:TEMP "davraf-tmp-$(Get-Random).zip"
    try {
        Invoke-WebRequest -Uri $REPO_ZIP_URL -OutFile $zipPath -UseBasicParsing -ErrorAction Stop
        Expand-Archive -Path $zipPath -DestinationPath $env:TEMP -Force -ErrorAction Stop
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue

        # GitHub espande in una cartella tipo "davraf-guidelines-main"
        $extracted = Get-ChildItem $env:TEMP -Filter "davraf-guidelines-*" -Directory |
                     Sort-Object LastWriteTime -Descending |
                     Select-Object -First 1
        if (-not $extracted) { throw "Cartella estratta non trovata." }
        Rename-Item $extracted.FullName $tempDir -ErrorAction Stop
    }
    catch {
        Write-Step "Download fallito: $_" "ERROR"
        exit 1
    }
}

# ---------------------------------------------------------------------------
# Step 5 — Copia il template nella cartella del progetto
# ---------------------------------------------------------------------------
$templateSource = Join-Path $tempDir $TEMPLATE_SUBDIR
if (-not (Test-Path $templateSource)) {
    Write-Step "Cartella template '$TEMPLATE_SUBDIR' non trovata nel repository." "ERROR"
    Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    exit 1
}

Write-Step "Creo la struttura del progetto..." "INFO"
New-Item -ItemType Directory -Path $projectPath -Force | Out-Null

# Copia tutti i file inclusi quelli nascosti (.github, .editorconfig, ecc.)
Get-ChildItem -Path $templateSource -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $projectPath -Recurse -Force
}

# Rimuovi .template.config — non serve nel progetto finale
$templateConfig = Join-Path $projectPath ".template.config"
if (Test-Path $templateConfig) {
    Remove-Item $templateConfig -Recurse -Force
}

# ---------------------------------------------------------------------------
# Step 6 — Git init
# ---------------------------------------------------------------------------
if ($gitAvailable) {
    Write-Step "Inizializzo il repository Git..." "INFO"
    Push-Location $projectPath
    git init --quiet 2>&1 | Out-Null
    git add . 2>&1 | Out-Null
    git commit --quiet -m "Initial commit from davraf-guidelines template" 2>&1 | Out-Null
    Pop-Location
} else {
    Write-Step "git non disponibile: salta git init. Potrai farlo manualmente." "WARN"
}

# ---------------------------------------------------------------------------
# Step 7 — Pulizia temporanei
# ---------------------------------------------------------------------------
Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# ---------------------------------------------------------------------------
# Step 8 — Messaggio finale e apertura Explorer
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "  ┌─────────────────────────────────────────┐" -ForegroundColor Green
Write-Host "  │   ✓  Progetto '$projectName' creato!$((' ' * [Math]::Max(0, 16 - $projectName.Length)))│" -ForegroundColor Green
Write-Host "  └─────────────────────────────────────────┘" -ForegroundColor Green
Write-Host ""
Write-Step "$projectPath" "OK"
Write-Host ""
Write-Host "  Prossimi passi:" -ForegroundColor White
Write-Host "  1. Crea la solution in Visual Studio puntando a: $projectPath" -ForegroundColor DarkGray
Write-Host "  2. Personalizza Directory.Build.props con il nome del prodotto" -ForegroundColor DarkGray
Write-Host "  3. Consulta .github/copilot-instructions.md per le istruzioni AI" -ForegroundColor DarkGray
Write-Host ""

Start-Process explorer.exe $projectPath
