#requires -Version 7.0
[CmdletBinding()]
param([Parameter(Mandatory)][string]$ApkPath,[string]$SignerSha256)
$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot -Parent
$pin=Get-Content -LiteralPath (Join-Path $repo 'upstream.json') -Raw | ConvertFrom-Json
if($pin.versionName -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$'){throw 'Invalid release version'}
if([IO.Path]::GetExtension($ApkPath) -ne '.apk'){throw 'Expected an APK file'}
$zip=[IO.Compression.ZipFile]::OpenRead($ApkPath)
try {if(!$zip.GetEntry('AndroidManifest.xml') -or !$zip.GetEntry('classes.dex')){throw 'Not an Android APK'}} finally {$zip.Dispose()}
$directory=Join-Path $repo ('releases/v'+$pin.versionName)
$hash=(Get-FileHash -LiteralPath $ApkPath -Algorithm SHA256).Hash.ToLowerInvariant()
if(Test-Path -LiteralPath (Join-Path $directory 'manifest.json')){
    $old=Get-Content -LiteralPath (Join-Path $directory 'manifest.json') -Raw | ConvertFrom-Json
    if($old.sha256 -ne $hash){throw 'Release version already has different inputs; increase the version'}
}
New-Item -ItemType Directory -Force -Path $directory | Out-Null
$parts=@()
$stream=[IO.File]::OpenRead($ApkPath)
try {
    $index=0
    while($stream.Position -lt $stream.Length){
        $length=[int][Math]::Min(524286,$stream.Length-$stream.Position)
        $bytes=New-Object byte[] $length
        $offset=0
        while($offset -lt $length){$read=$stream.Read($bytes,$offset,$length-$offset);if(!$read){throw 'Unexpected EOF'};$offset+=$read}
        $name='apk-{0:D2}.part' -f $index
        [IO.File]::WriteAllBytes((Join-Path $directory $name),$bytes)
        $parts+=@{file=$name;size=$length}
        $index++
    }
}finally{$stream.Dispose()}
$manifest=[ordered]@{versionName=$pin.versionName;versionCode=$pin.versionCode;name='gsm2sip-mtk.apk';sha256=$hash;size=(Get-Item -LiteralPath $ApkPath).Length;parts=$parts}
if($SignerSha256){if($SignerSha256 -notmatch '^[a-fA-F0-9]{64}$'){throw 'Invalid signer fingerprint'};$manifest.signerCertificateSha256=$SignerSha256.ToLowerInvariant()}
[IO.File]::WriteAllText((Join-Path $directory 'manifest.json'),($manifest | ConvertTo-Json -Depth 5)+"`n",[Text.UTF8Encoding]::new($false))
Write-Output ('Staged signed release inputs: v'+$pin.versionName+'; SHA256='+$hash)
