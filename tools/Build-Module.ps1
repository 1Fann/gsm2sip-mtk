#requires -Version 7.0
[CmdletBinding()]
param([Parameter(Mandatory)][string]$ApkPath)
$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot -Parent
$stage=Join-Path $repo '.work/module'
$output=Join-Path $repo '.work/dist'
$apkDir=Join-Path $stage 'system/priv-app/GSM2SIP'
$permissionDir=Join-Path $stage 'system/etc/permissions'
New-Item -ItemType Directory -Force -Path $stage,$output,$apkDir,$permissionDir | Out-Null
foreach($name in @('module.prop','customize.sh')){Copy-Item -LiteralPath (Join-Path $repo ('module/'+$name)) -Destination (Join-Path $stage $name)}
Copy-Item -LiteralPath (Join-Path $repo 'module/privapp-permissions-gsm2sip.xml') -Destination (Join-Path $permissionDir 'privapp-permissions-gsm2sip.xml')
Copy-Item -LiteralPath $ApkPath -Destination (Join-Path $apkDir 'GSM2SIP.apk')
if(@(Get-ChildItem -LiteralPath $stage -File -Recurse).Count -ne 4){throw 'Unexpected module staging files'}
$archive=Join-Path $output 'gsm2sip-bakasu-mt6893-1.2.0.2.zip'
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $archive -Force
Write-Output 'Built local-only module: .work/dist/gsm2sip-bakasu-mt6893-1.2.0.2.zip'
