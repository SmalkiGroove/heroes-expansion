
$zip = @{
  Path = "..\..\game_data\lua\*"
  CompressionLevel = "Fastest"
  DestinationPath = ".\h5x-lua.zip"
}
Compress-Archive @zip
Move-Item "h5x-lua.zip" "h5x-lua.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-lua.pak" /Z /mov
# Read-Host