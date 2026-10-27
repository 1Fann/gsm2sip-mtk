#requires -Version 7.0
[CmdletBinding()]
param([string]$SdkDir,[string]$GradleCommand,[switch]$Offline)
$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot -Parent
$source=Join-Path $repo '.work/src'
if(!(Test-Path -LiteralPath $source)){& (Join-Path $PSScriptRoot 'Prepare-Source.ps1')}
& (Join-Path $PSScriptRoot 'Test-Adaptation.ps1')
if(!$SdkDir){$SdkDir=$env:ANDROID_SDK_ROOT}
if(!$SdkDir){$SdkDir=$env:ANDROID_HOME}
if(!$SdkDir -or !(Test-Path -LiteralPath (Join-Path $SdkDir 'platforms/android-35/android.jar'))){throw 'Set SdkDir or ANDROID_SDK_ROOT to an SDK containing Android platform 35'}
[IO.File]::WriteAllText((Join-Path $source 'local.properties'),('sdk.dir='+$SdkDir.Replace('\','/')+"`n"),[Text.UTF8Encoding]::new($false))
if(!$GradleCommand){$GradleCommand=Join-Path $source $(if($IsWindows){'gradlew.bat'}else{'gradlew'})}
if(!$IsWindows){& chmod +x (Join-Path $source 'gradlew')}
$arguments=@('-p',$source,':app:assembleRelease',':app:lintVitalRelease','--no-daemon','--console=plain')
if($Offline){$arguments+='--offline'}
& $GradleCommand @arguments
if($LASTEXITCODE){throw 'Android build failed'}
& (Join-Path $PSScriptRoot 'Test-Adaptation.ps1')
Write-Output 'Local APK output: .work/src/app/build/outputs/apk/release/'
