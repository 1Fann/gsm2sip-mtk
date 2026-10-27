#requires -Version 7.0
[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot -Parent
$pin=Get-Content -LiteralPath (Join-Path $repo 'upstream.json') -Raw | ConvertFrom-Json
$pristine=Join-Path $repo ('.work/pristine/'+$pin.sourceDirectory)
$source=Join-Path $repo '.work/src'
$runtime=@($pin.baselineFiles.PSObject.Properties.Name | Sort-Object)
$buildMetadata=@('app/build.gradle.kts','gradle/wrapper/gradle-wrapper.properties')
$differences=@()
foreach($file in Get-ChildItem -LiteralPath (Join-Path $source 'app/src') -File -Recurse){
    $relative=[IO.Path]::GetRelativePath($source,$file.FullName)
    if(!(Test-Path -LiteralPath (Join-Path $pristine $relative))){throw "Unexpected extra runtime file: $relative"}
}
foreach($file in Get-ChildItem -LiteralPath $pristine -File -Recurse){
    $relative=[IO.Path]::GetRelativePath($pristine,$file.FullName).Replace('\','/')
    $candidate=Join-Path $source $relative
    if(!(Test-Path -LiteralPath $candidate)){throw "Missing upstream file: $relative"}
    if((Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $candidate -Algorithm SHA256).Hash){
        $differences+=$relative
        if($relative -notin $runtime -and $relative -notin $buildMetadata){throw "Unexpected upstream change: $relative"}
    }
}
$runtimeDifferences=@($differences | Where-Object {$_ -notin $buildMetadata} | Sort-Object)
if(($runtimeDifferences -join '|') -cne ($runtime -join '|')){throw 'Runtime change set is not exactly the two approved Kotlin files'}
$gradle=Get-Content -LiteralPath (Join-Path $source 'app/build.gradle.kts') -Raw
if($gradle -notmatch ('versionCode = '+$pin.versionCode) -or $gradle -notmatch [regex]::Escape('versionName = "'+$pin.versionName+'"')){throw 'Wrong version metadata'}
Write-Output ('Verified: '+($runtimeDifferences -join ', '))
Write-Output 'Every other upstream runtime, manifest and resource file is byte-identical.'
