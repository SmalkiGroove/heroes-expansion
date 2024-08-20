
$zip = @{
  Path = "..\game_data\texts\*"
  CompressionLevel = "Optimal"
  DestinationPath = ".\h5x-texts.zip"
}
Compress-Archive @zip
Move-Item "h5x-texts.zip" "h5x-texts.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"D:\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-texts.pak" /Z /mov
Read-Host