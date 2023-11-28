
$zip = @{
  Path = "..\game_data\lua"
  CompressionLevel = "Optimal"
  DestinationPath = ".\mod-lua.zip"
}
Compress-Archive @zip
Move-Item "mod-lua.zip" "mod-lua.pak" -Force
# Read-Host

$game_path = "D:\Ubisoft\Heroes of Might and Magic V\Tribes of the East"
Robocopy.exe "." "$game_path\data" "mod-lua.pak" /Z
Read-Host