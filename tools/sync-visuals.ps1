
$zip = @{
  Path = "..\game_data\visuals\*"
  CompressionLevel = "Optimal"
  DestinationPath = ".\mod-visuals.zip"
}
Compress-Archive @zip
Move-Item "mod-visuals.zip" "mod-visuals.pak" -Force
# Read-Host

$game_path = "D:\Ubisoft\Heroes of Might and Magic V - Tribes of the East"
Robocopy.exe "." "$game_path\data" "mod-visuals.pak" /Z /mov
Read-Host