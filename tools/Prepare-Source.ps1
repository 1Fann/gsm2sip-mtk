#requires -Version 7.0
[CmdletBinding()]
param([string]$ArchivePath)
$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot -Parent
$pin=Get-Content -LiteralPath (Join-Path $repo 'upstream.json') -Raw | ConvertFrom-Json
$work=Join-Path $repo '.work'
$archive=Join-Path $work 'upstream.zip'
$pristineParent=Join-Path $work 'pristine'
$pristine=Join-Path $pristineParent $pin.sourceDirectory
$source=Join-Path $work 'src'
$encoding=[Text.UTF8Encoding]::new($false)
New-Item -ItemType Directory -Force -Path $work | Out-Null
if($ArchivePath){
    if((Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $pin.archiveSha256){throw 'Archive SHA256 mismatch'}
    if([IO.Path]::GetFullPath($ArchivePath) -ne [IO.Path]::GetFullPath($archive)){Copy-Item -LiteralPath $ArchivePath -Destination $archive}
}elseif(!(Test-Path -LiteralPath $archive)){
    Invoke-WebRequest -Uri $pin.archiveUrl -OutFile $archive
}
if((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ne $pin.archiveSha256){throw 'Archive SHA256 mismatch'}
if(!(Test-Path -LiteralPath $pristine)){Expand-Archive -LiteralPath $archive -DestinationPath $pristineParent}
if(!(Test-Path -LiteralPath $source)){Copy-Item -LiteralPath $pristine -Destination $source -Recurse}
& (Join-Path $PSScriptRoot 'Apply-Adaptation.ps1') -SourceDir $source -PristineDir $pristine

# Build metadata only. No additional Kotlin, manifest, resource or runtime edits.
$gradleFile=Join-Path $source 'app/build.gradle.kts'
$text=[IO.File]::ReadAllText((Join-Path $pristine 'app/build.gradle.kts')).Replace("`r`n","`n")
$text=$text.Replace('compileSdk = 34',('compileSdk = '+$pin.compileSdk)).Replace('versionCode = 425',('versionCode = '+$pin.versionCode)).Replace('versionName = "1.2.0"',('versionName = "'+$pin.versionName+'"'))
$signing=@'
    signingConfigs {
        val localKey = providers.environmentVariable("GSM_KEYSTORE").orNull
        if (!localKey.isNullOrBlank()) {
            create("localRelease") {
                storeFile = file(localKey)
                storePassword = providers.environmentVariable("GSM_STORE_PASSWORD").get()
                keyAlias = providers.environmentVariable("GSM_KEY_ALIAS").orElse("gsm2sip").get()
                keyPassword = providers.environmentVariable("GSM_KEY_PASSWORD").orElse(providers.environmentVariable("GSM_STORE_PASSWORD")).get()
            }
        }
    }

    buildTypes
'@
$text=[regex]::Replace($text,'(?s)    signingConfigs \{.*?\n    \}\n\n    buildTypes',$signing)
$text=$text.Replace('signingConfig = signingConfigs.getByName("shared")','signingConfig = signingConfigs.findByName("localRelease")')
$commentStart=$text.IndexOf('    // A release build is signed')
$commentEnd=$text.IndexOf('    signingConfigs {',$commentStart)
if($commentStart -ge 0 -and $commentEnd -gt $commentStart){$text=$text.Substring(0,$commentStart)+"    // Local release signing is optional; no signing keys are shipped.`n"+$text.Substring($commentEnd)}
if($text -notmatch 'create\("localRelease"\)' -or $text -match 'androiddebugkey'){throw 'Build-signing transformation failed'}
[IO.File]::WriteAllText($gradleFile,$text,$encoding)
$wrapper=Join-Path $source 'gradle/wrapper/gradle-wrapper.properties'
$properties=[IO.File]::ReadAllText((Join-Path $pristine 'gradle/wrapper/gradle-wrapper.properties')).Replace('gradle-9.7.1-bin.zip',('gradle-'+$pin.gradleVersion+'-bin.zip'))
[IO.File]::WriteAllText($wrapper,$properties,$encoding)
& (Join-Path $PSScriptRoot 'Test-Adaptation.ps1')
Write-Output "Prepared source under .work/src at upstream $($pin.commit)."
