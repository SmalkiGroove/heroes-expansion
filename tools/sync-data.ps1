
$zip = @{
  Path = "..\game_data\data"
  CompressionLevel = "Optimal"
  DestinationPath = ".\mod-data.zip"
}
Compress-Archive @zip
Move-Item "mod-data.zip" "mod-data.pak" -Force
# Read-Host

$game_path = "D:\Ubisoft\Heroes of Might and Magic V\Tribes of the East"
Robocopy.exe "." "$game_path\data" "mod-data.pak" /Z
Read-Host