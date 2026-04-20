# sync-falano.ps1
# Synchronisiert den FalanoSync Obsidian Vault mit dem Quartz Wiki
# Aufruf: ./sync-falano.ps1

$VaultPath = "$env:USERPROFILE\OneDrive\Anwendungen\remotely-save\FalanoSync"
$QuartzContent = "$PSScriptRoot\content"

# Ordner die NICHT veroeffentlicht werden sollen
$ExcludeFolders = @(
    ".obsidian",
    ".trash",
    ".space",
    ".makemd",
    "copilot",
    "ZZ Templates",
    "Ideas",
    "Tags"
)

# Dateimuster die NICHT synchronisiert werden sollen
$ExcludeFiles = @("*.mdb", "*.db", "def.json", "views.mdb")

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  FALANO UNIVERSE - Wiki Sync" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Quelle: $VaultPath"
Write-Host "Ziel:   $QuartzContent"
Write-Host ""

# Stelle sicher, dass der content-Ordner existiert
if (-not (Test-Path $QuartzContent)) {
    New-Item -ItemType Directory -Path $QuartzContent | Out-Null
}

# Baue den Exclude-Filter fuer robocopy
$ExcludeArgs = $ExcludeFolders | ForEach-Object { "/XD", $_ }
$ExcludeFileArgs = $ExcludeFiles | ForEach-Object { "/XF", $_ }

# Synchronisiere Markdown-Dateien
Write-Host "[>>] Synchronisiere Markdown-Dateien..." -ForegroundColor Yellow
$robocopyArgs = @(
    $VaultPath,
    $QuartzContent,
    "*.md",
    "/S",           # Unterordner einschliessen
    "/PURGE",       # Geloeschte Dateien auch loeschen
    "/NJH",         # Keine Job-Header
    "/NJS",         # Keine Job-Zusammenfassung
    "/NFL",         # Keine Dateiliste (saubere Ausgabe)
    "/NDL"          # Keine Verzeichnisliste
) + $ExcludeArgs + $ExcludeFileArgs

& robocopy @robocopyArgs | Out-Null

# Synchronisiere Bilder aus ZZ Media
Write-Host "[>>] Synchronisiere Medien..." -ForegroundColor Yellow
$MediaSource = Join-Path $VaultPath "ZZ Media"
$MediaDest = Join-Path $QuartzContent "ZZ Media"

if (Test-Path $MediaSource) {
    & robocopy $MediaSource $MediaDest /S /PURGE /NJH /NJS /NFL /NDL | Out-Null
}

# Zaehle synchronisierte Dateien
$mdCount = (Get-ChildItem $QuartzContent -Filter "*.md" -Recurse).Count
$imgCount = (Get-ChildItem $QuartzContent -Include "*.png","*.jpg","*.jpeg","*.gif","*.webp" -Recurse).Count

# Zaehle Seiten mit draft: true (werden im Wiki ausgeblendet)
$hiddenCount = 0
$hiddenPages = @()
Get-ChildItem $QuartzContent -Filter "*.md" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match "(?m)^draft:\s*true") {
        $hiddenCount++
        $hiddenPages += $_.Name
    }
}

Write-Host ""
Write-Host "[OK] Sync abgeschlossen!" -ForegroundColor Green
Write-Host "     $mdCount Markdown-Dateien"
Write-Host "     $imgCount Bilder"
if ($hiddenCount -gt 0) {
    Write-Host "     [!] $hiddenCount Seite(n) mit 'draft: true' (werden im Wiki ausgeblendet):" -ForegroundColor Yellow
    $hiddenPages | ForEach-Object { Write-Host "         - $_" -ForegroundColor DarkYellow }
}
Write-Host ""

# Frage wie weiter verfahren werden soll
Write-Host "Was moechtest du jetzt tun?" -ForegroundColor White
Write-Host "  [l] Lokal testen (http://localhost:8080)"
Write-Host "  [p] Veroeffentlichen (Git Push -> Cloudflare baut automatisch)"
Write-Host "  [b] Beides"
Write-Host "  [n] Nichts"
$action = Read-Host "Auswahl"

if ($action -eq "l" -or $action -eq "b") {
    Write-Host "Starte lokalen Server..." -ForegroundColor Cyan
    Write-Host "Oeffne http://localhost:8080 im Browser. Mit Strg+C beenden." -ForegroundColor Gray
    npx quartz build --serve
}

if ($action -eq "p" -or $action -eq "b") {
    Write-Host ""
    Write-Host "[>>] Veroeffentliche auf Cloudflare..." -ForegroundColor Cyan

    Set-Location $PSScriptRoot

    # Git Status pruefen
    $status = git status --porcelain
    if ($status) {
        $commitMsg = Read-Host "Commit-Nachricht (z.B. Update: Falano Core erweitert)"
        if (-not $commitMsg) { $commitMsg = "Update: Inhalte aktualisiert" }

        git add .
        git commit -m $commitMsg

        Write-Host "[>>] Hole neueste Aenderungen vom Server..." -ForegroundColor Cyan
        git pull --rebase 2>&1 | Out-String | Write-Host

        # Pruefen ob Rebase wirklich fehlgeschlagen ist (Konflikte), nicht nur Aufraeumfehler
        $rebaseConflict = git status --porcelain 2>&1 | Select-String "^(AA|UU|DD|AU|UA|DU|UD)"
        if ($rebaseConflict) {
            Write-Host "[!] Merge-Konflikt erkannt. Bitte Konflikte manuell loesen und dann erneut pushen." -ForegroundColor Red
            exit 1
        }

        git push

        Write-Host ""
        Write-Host "[OK] Veroeffentlicht! Cloudflare baut die Seite jetzt automatisch." -ForegroundColor Green
        Write-Host "     Status: https://dash.cloudflare.com > Pages > falano-wiki" -ForegroundColor Gray
    } else {
        Write-Host "[i] Keine Aenderungen seit dem letzten Push." -ForegroundColor Yellow
    }
}
