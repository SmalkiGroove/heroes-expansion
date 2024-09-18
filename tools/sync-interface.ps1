
$zip = @{
  Path = "..\game_data\interface\*"
  CompressionLevel = "Optimal"
  DestinationPath = ".\h5x-interface.zip"
}
Compress-Archive @zip
Move-Item "h5x-interface.zip" "h5x-interface.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"D:\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-interface.pak" /Z /mov
Read-Host