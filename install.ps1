param([switch]$Uninstall, [ValidateSet('it','en')][string]$Language = 'en')
$ErrorActionPreference = 'Stop'
function Message([string]$Italian, [string]$English) { if ($Language -eq 'en') { $English } else { $Italian } }
$appRoot = Join-Path $env:LOCALAPPDATA 'FirefoxDownloadRouter'
$binPath = Join-Path $appRoot 'bin'
$registryPath = 'HKCU:\Software\Mozilla\NativeMessagingHosts\org.kronos.firefox_download_router'
if ($Uninstall) {
    if (Test-Path -LiteralPath $registryPath) { Remove-Item -LiteralPath $registryPath }
    # Verify the final absolute path before removing the component directory.
    $resolvedBin = [IO.Path]::GetFullPath($binPath)
    $expectedBin = [IO.Path]::GetFullPath((Join-Path $env:LOCALAPPDATA 'FirefoxDownloadRouter\bin'))
    if ($resolvedBin -ne $expectedBin) { throw (Message 'Percorso rimozione non valido.' 'Invalid uninstall path.') }
    if (Test-Path -LiteralPath $resolvedBin) { Remove-Item -LiteralPath $resolvedBin -Recurse -Force }
    Write-Output (Message 'Componente rimosso. Le impostazioni sono state conservate.' 'Component removed. Your settings have been kept.')
    exit 0
}
$componentFolder = 'component'
$source = Join-Path (Join-Path $PSScriptRoot $componentFolder) 'DownloadRouter.Host.exe'
if (-not (Test-Path -LiteralPath $source)) { throw (Message 'Componente non trovato. Usa la cartella release completa.' 'Component not found. Use the complete release folder.') }
New-Item -ItemType Directory -Path $binPath -Force | Out-Null
Copy-Item -LiteralPath $source -Destination (Join-Path $binPath 'DownloadRouter.Host.exe') -Force
$manifest = [ordered]@{
    name = 'org.kronos.firefox_download_router'
    description = (Message 'Componente locale di FF-Download-Router' 'FF-Download-Router local component')
    path = (Join-Path $binPath 'DownloadRouter.Host.exe')
    type = 'stdio'
    allowed_extensions = @('firefox-download-router@kronos.local')
}
$manifestPath = Join-Path $binPath 'org.kronos.firefox_download_router.json'
[IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json -Depth 5), (New-Object Text.UTF8Encoding($false)))
New-Item -Path $registryPath -Force | Out-Null
Set-Item -LiteralPath $registryPath -Value $manifestPath
Write-Output (Message 'Componente 0.4.0 installato per il tuo utente. Apri le opzioni di FF-Download-Router in Firefox e premi Verifica componente.' 'Component 0.4.0 installed for your account. Open FF-Download-Router Options in Firefox and click Check component.')
