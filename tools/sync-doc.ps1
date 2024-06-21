
$zip = @{
  Path = "..\game_data\doc\*"
  CompressionLevel = "Optimal"
  DestinationPath = ".\h5x-doc.zip"
}
Compress-Archive @zip
Move-Item "h5x-doc.zip" "h5x-doc.pak" -Force
# Read-Host

$game_path = "D:\Ubisoft\Heroes of Might and Magic V - Tribes of the East"
Robocopy.exe "." "$game_path\data" "h5x-doc.pak" /Z /mov
Read-Host