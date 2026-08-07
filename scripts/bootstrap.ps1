# Разворачивает базу знаний из second-brain-starter в указанную папку.
# Использование: .\bootstrap.ps1 -Target "C:\Users\<имя>\Documents\KB"
param(
    [Parameter(Mandatory = $true)][string]$Target
)

$ErrorActionPreference = 'Stop'

if ((Test-Path $Target) -and (Get-ChildItem -Force $Target | Measure-Object).Count -gt 0) {
    throw "Папка $Target не пуста. Остановлено, чтобы ничего не затереть."
}

$tmp = Join-Path $env:TEMP ("sbs-" + [guid]::NewGuid())
git clone --depth 1 https://github.com/skive/second-brain-starter $tmp | Out-Null

New-Item -ItemType Directory -Force -Path $Target | Out-Null
Copy-Item -Path (Join-Path $tmp 'vault\*') -Destination $Target -Recurse -Force
Remove-Item -Recurse -Force $tmp
Get-ChildItem -Path $Target -Recurse -Force -Filter '.gitkeep' | Remove-Item -Force

git -C $Target init -b main | Out-Null
git -C $Target add -A
git -C $Target commit -m "База развёрнута из second-brain-starter" | Out-Null

Write-Host "Готово: $Target"
Write-Host 'Дальше откройте эту папку агентом и скажите: «Настрой мою базу знаний».'
