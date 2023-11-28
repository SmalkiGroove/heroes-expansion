
$zip = @{
  Path = "..\game_data\texts"
  CompressionLevel = "Optimal"
  DestinationPath = ".\mod-texts.zip"
}
Compress-Archive @zip
Move-Item "mod-texts.zip" "mod-texts.pak" -Force
# Read-Host

$game_path = "D:\Ubisoft\Heroes of Might and Magic V\Tribes of the East"
Robocopy.exe "." "$game_path\data" "mod-texts.pak" /Z
Read-Host