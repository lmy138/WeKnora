param(
    [string]$BackendUrl = 'http://127.0.0.1:8091',
    [int]$Port = 5173
)

$ErrorActionPreference = 'Stop'
$previousTarget = $env:VITE_DEV_PROXY_TARGET
Push-Location $PSScriptRoot
try {
    if (-not (Test-Path -LiteralPath 'node_modules')) {
        throw 'Run npm.cmd ci in the frontend directory first.'
    }
    $env:VITE_DEV_PROXY_TARGET = $BackendUrl
    npm.cmd run dev -- --host 127.0.0.1 --port $Port --strictPort
    if ($LASTEXITCODE -ne 0) {
        throw "Vite exited with code $LASTEXITCODE."
    }
} finally {
    $env:VITE_DEV_PROXY_TARGET = $previousTarget
    Pop-Location
}
