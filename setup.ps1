#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Collega le linee guida Davraf alla root del progetto tramite symlink.
.DESCRIPTION
    Da eseguire dalla root del progetto host OPPURE direttamente:
        .\davraf-guidelines\setup.ps1
    Crea symlink per tutti i file di configurazione e .github/.
    I symlink puntano al submodule, quindi basta aggiornare il submodule
    per ottenere automaticamente le versioni più recenti.
.EXAMPLE
    cd C:\MioProgetto
    git submodule add https://github.com/Davraf/davraf-guidelines.git davraf-guidelines
    .\davraf-guidelines\setup.ps1
#>

$ErrorActionPreference = "Stop"

$guidelinesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot   = (Get-Item $guidelinesDir).Parent.FullName

Write-Host ""
Write-Host "Davraf Guidelines Setup" -ForegroundColor Cyan
Write-Host "  Guidelines : $guidelinesDir"
Write-Host "  Progetto   : $projectRoot"
Write-Host ""

function New-Symlink {
    param([string]$Link, [string]$Target)

    if (-not (Test-Path $Target)) {
        Write-Host "  [WARN] Target non trovato: $Target" -ForegroundColor Yellow
        return
    }
    if (Test-Path $Link) {
        Write-Host "  [SKIP] Esiste già: $(Split-Path -Leaf $Link)" -ForegroundColor DarkGray
        return
    }
    $item = Get-Item $Target
    $type = if ($item.PSIsContainer) { "Junction" } else { "SymbolicLink" }
    New-Item -ItemType $type -Path $Link -Target $Target -Force | Out-Null
    Write-Host "  [OK]   $(Split-Path -Leaf $Link)" -ForegroundColor Green
}

# --- File radice ---
Write-Host "File di configurazione:" -ForegroundColor White
foreach ($file in @(".editorconfig", "Directory.Build.props", "global.json", ".gitignore", ".gitattributes")) {
    New-Symlink `
        -Link   (Join-Path $projectRoot $file) `
        -Target (Join-Path $guidelinesDir $file)
}

# --- Cartella .github ---
Write-Host ""
Write-Host "Cartella .github:" -ForegroundColor White

$githubSrc  = Join-Path $guidelinesDir ".github"
$githubDest = Join-Path $projectRoot   ".github"

if (-not (Test-Path $githubDest)) {
    # Non esiste: junction dell'intera cartella
    New-Symlink -Link $githubDest -Target $githubSrc
} else {
    # Esiste già: collega file per file per non sovrascrivere contenuto esistente
    Write-Host "  [INFO] .github esiste, collegamento file per file..." -ForegroundColor Cyan

    $subDirs = @("", "instructions", "prompts")
    foreach ($sub in $subDirs) {
        $srcFolder  = if ($sub) { Join-Path $githubSrc  $sub } else { $githubSrc }
        $destFolder = if ($sub) { Join-Path $githubDest $sub } else { $githubDest }

        if (-not (Test-Path $destFolder)) {
            New-Item -ItemType Directory -Path $destFolder | Out-Null
        }

        if (Test-Path $srcFolder) {
            foreach ($f in Get-ChildItem $srcFolder -File) {
                New-Symlink `
                    -Link   (Join-Path $destFolder $f.Name) `
                    -Target $f.FullName
            }
        }
    }
}

Write-Host ""
Write-Host "Setup completato." -ForegroundColor Cyan
Write-Host "Per aggiornare le linee guida in futuro:" -ForegroundColor White
Write-Host "  git submodule update --remote davraf-guidelines" -ForegroundColor DarkCyan
Write-Host ""
