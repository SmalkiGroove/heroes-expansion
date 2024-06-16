
$zip = @{
  Path = "..\game_data\skilltree\*"
  CompressionLevel = "Optimal"
  DestinationPath = ".\mod-skilltree.zip"
}
Compress-Archive @zip
Move-Item "mod-skilltree.zip" "mod-skilltree.pak" -Force
# Read-Host

$game_path = "D:\Ubisoft\Heroes of Might and Magic V - Tribes of the East"
Robocopy.exe "." "$game_path\data" "mod-skilltree.pak" /Z /mov
Read-Host