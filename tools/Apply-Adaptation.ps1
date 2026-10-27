#requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$SourceDir,
    [Parameter(Mandatory)][string]$PristineDir
)
$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot -Parent
$pin=Get-Content -LiteralPath (Join-Path $repo 'upstream.json') -Raw | ConvertFrom-Json
$encoding=[Text.UTF8Encoding]::new($false)
function Get-AdaptedText([string]$relative,[string]$original){
    $text=$original.Replace("`r`n","`n")
    if($relative.EndsWith('/RootShell.kt')){
        $persistent='Runtime.getRuntime().exec("su")'
        $fallback='arrayOf("su", "-c", cmd)'
        if(([regex]::Matches($text,[regex]::Escape($persistent))).Count -ne 1 -or
           ([regex]::Matches($text,[regex]::Escape($fallback))).Count -ne 2){throw 'Unexpected upstream root-shell call sites'}
        return $text.Replace($persistent,'Runtime.getRuntime().exec(arrayOf("su", "-M"))').Replace($fallback,'arrayOf("su", "-M", "-c", cmd)')
    }
    $selection='                // Unknown device — minimal mixer interaction'
    $profile='        /** Unknown device — no mixer hacks, pure Android APIs */'
    if(([regex]::Matches($text,[regex]::Escape($selection))).Count -ne 1 -or
       ([regex]::Matches($text,[regex]::Escape($profile))).Count -ne 1){throw 'Unexpected upstream profile insertion points'}
    $branch=@'
                // MT6893 telephony route; cellular two-way audio is not yet verified.
                chip.contains("mt6893") -> mt6893Experimental()

'@
    $function=@'
        /** MT6893: Android telephony routing, retaining upstream capture fallbacks. */
        fun mt6893Experimental() = generic().copy(
            name = "MediaTek MT6893 (experimental)",
            requireSpeakerMode = false,
            silenceLocalAudio = true,
            incallMusicParam = "",
            captureFromTelephonyRx = true,
            playbackToTelephonyTx = true,
            playbackStereo = true,
            playbackLeaksIntoCapture = false,
            captureSilenceFrames = 500,
        )

'@
    return $text.Replace($selection,$branch+"`n"+$selection).Replace($profile,$function+"`n"+$profile)
}
foreach($entry in $pin.baselineFiles.PSObject.Properties){
    $relative=$entry.Name
    $baseline=Join-Path $PristineDir $relative
    $target=Join-Path $SourceDir $relative
    if((Get-FileHash -LiteralPath $baseline -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.Value){throw "Wrong upstream file: $relative"}
    $original=[IO.File]::ReadAllText($baseline)
    $expected=Get-AdaptedText $relative $original
    $current=[IO.File]::ReadAllText($target)
    if($current -ceq $expected){continue}
    if($current -cne $original){throw "Refusing to overwrite unexpected local edits: $relative"}
    [IO.File]::WriteAllText($target,$expected,$encoding)
}
Write-Output 'Applied exactly two runtime adaptations: BakaSU shell and MT6893 profile.'
