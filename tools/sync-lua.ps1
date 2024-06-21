
$zip = @{
  Path = "..\game_data\lua\*"
  CompressionLevel = "Optimal"
  DestinationPath = ".\h5x-lua.zip"
}
Compress-Archive @zip
Move-Item "h5x-lua.zip" "h5x-lua.pak" -Force
# Read-Host

$game_path = "D:\Ubisoft\Heroes of Might and Magic V - Tribes of the East"
Robocopy.exe "." "$game_path\data" "h5x-lua.pak" /Z /mov
Read-Host