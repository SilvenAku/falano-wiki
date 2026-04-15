# sync-falano.ps1
# Synchronisiert den FalanoSync Obsidian Vault mit dem Quartz Wiki
# Aufruf: ./sync-falano.ps1

$VaultPath = "$env:USERPROFILE\OneDrive\Anwendungen\remotely-save\FalanoSync"
$QuartzContent = "$PSScriptRoot\content"

# Ordner die NICHT veröffentlicht werden sollen
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

Write-Host "🌌 Falano Universe – Sync gestartet" -ForegroundColor Cyan
Write-Host "Quelle: $VaultPath"
Write-Host "Ziel:   $QuartzContent"
Write-Host ""

# Stelle sicher, dass der content-Ordner existiert
if (-not (Test-Path $QuartzContent)) {
    New-Item -ItemType Directory -Path $QuartzContent | Out-Null
}

# Baue den Exclude-Filter für robocopy
$ExcludeArgs = $ExcludeFolders | ForEach-Object { "/XD", $_ }

# Synchronisiere Markdown-Dateien
Write-Host "📄 Synchronisiere Markdown-Dateien..." -ForegroundColor Yellow
$robocopyArgs = @(
    $VaultPath,
    $QuartzContent,
    "*.md",
    "/S",           # Unterordner einschließen
    "/PURGE",       # Gelöschte Dateien auch löschen
    "/NJH",         # Keine Job-Header
    "/NJS",         # Keine Job-Zusammenfassung
    "/NFL",         # Keine Dateiliste (saubere Ausgabe)
    "/NDL"          # Keine Verzeichnisliste
) + $ExcludeArgs

& robocopy @robocopyArgs | Out-Null

# Synchronisiere Bilder aus ZZ Media
Write-Host "🖼️  Synchronisiere Medien..." -ForegroundColor Yellow
$MediaSource = Join-Path $VaultPath "ZZ Media"
$MediaDest = Join-Path $QuartzContent "ZZ Media"

if (Test-Path $MediaSource) {
    & robocopy $MediaSource $MediaDest /S /PURGE /NJH /NJS /NFL /NDL | Out-Null
}

# Zähle synchronisierte Dateien
$mdCount = (Get-ChildItem $QuartzContent -Filter "*.md" -Recurse).Count
$imgCount = (Get-ChildItem $QuartzContent -Include "*.png","*.jpg","*.jpeg","*.gif","*.webp" -Recurse).Count

Write-Host ""
Write-Host "✅ Sync abgeschlossen!" -ForegroundColor Green
Write-Host "   $mdCount Markdown-Dateien"
Write-Host "   $imgCount Bilder"
Write-Host ""

# Frage wie weiter verfahren werden soll
Write-Host "Was möchtest du jetzt tun?" -ForegroundColor White
Write-Host "  [l] Lokal testen (http://localhost:8080)"
Write-Host "  [p] Veröffentlichen (Git Push → Cloudflare baut automatisch)"
Write-Host "  [b] Beides"
Write-Host "  [n] Nichts"
$action = Read-Host "Auswahl"

if ($action -eq "l" -or $action -eq "b") {
    Write-Host "Starte lokalen Server..." -ForegroundColor Cyan
    Write-Host "Öffne http://localhost:8080 im Browser. Mit Strg+C beenden." -ForegroundColor Gray
    npx quartz build --serve
}

if ($action -eq "p" -or $action -eq "b") {
    Write-Host ""
    Write-Host "🚀 Veröffentliche auf Cloudflare..." -ForegroundColor Cyan

    Set-Location $PSScriptRoot

    # Git Status prüfen
    $status = git status --porcelain
    if ($status) {
        $commitMsg = Read-Host "📝 Commit-Nachricht (z.B. 'Update: Falano Core erweitert')"
        if (-not $commitMsg) { $commitMsg = "Update: Inhalte aktualisiert" }

        git add .
        git commit -m $commitMsg
        git push

        Write-Host ""
        Write-Host "✅ Veröffentlicht! Cloudflare baut die Seite jetzt automatisch." -ForegroundColor Green
        Write-Host "   Status: https://dash.cloudflare.com → Pages → falano-wiki" -ForegroundColor Gray
    } else {
        Write-Host "ℹ️  Keine Änderungen seit dem letzten Push." -ForegroundColor Yellow
    }
}
