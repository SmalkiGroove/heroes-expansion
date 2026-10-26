# Builds the launchers H5X.exe and H5X-Duel.exe (game_binary/bin) with MSVC and copies them
# to the game's root folder. Requires Visual Studio with the C++ desktop workload.
$ErrorActionPreference = "Stop"

$src = $PSScriptRoot
$out = Join-Path $src "..\bin"

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (-not $vs) { throw "Visual Studio with the C++ tools was not found" }
$vcvars = Join-Path $vs "VC\Auxiliary\Build\vcvars32.bat"

$launchers = @(
  @{ Name = "H5X"; Defines = "" },
  @{ Name = "H5X-Duel"; Defines = "/DH5X_DUEL" }
)

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}

foreach ($launcher in $launchers) {
  $name = $launcher.Name
  $defines = $launcher.Defines
  $obj = Join-Path $out "launcher-obj\$name"
  New-Item -ItemType Directory -Force $obj | Out-Null

  $build = @(
    "set `"PATH=$(Split-Path $vswhere);%PATH%`"",
    "call `"$vcvars`" >nul",
    "rc /nologo $defines /fo `"$obj\launcher.res`" `"$src\launcher.rc`"",
    "cl /nologo /O1 /MT /EHsc /W4 /DUNICODE /D_UNICODE $defines /Fo`"$obj\\`" `"$src\launcher.cpp`" `"$obj\launcher.res`" /Fe`"$out\$name.exe`" /link /SUBSYSTEM:WINDOWS /MANIFEST:EMBED /MANIFESTUAC:`"level='asInvoker' uiAccess='false'`" user32.lib shell32.lib shlwapi.lib advapi32.lib"
  ) -join " && "
  cmd /c $build
  if ($LASTEXITCODE) { throw "Build of $name.exe failed" }

  Copy-Item "$out\$name.exe" $game_path
}
