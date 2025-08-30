
$zip = @{
  Path = "..\game_data\doc-artifacts\*"
  CompressionLevel = "Optimal"
  DestinationPath = ".\h5x-doc-artifacts.zip"
}
Compress-Archive @zip
Move-Item "h5x-doc-artifacts.zip" "h5x-doc-artifacts.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"D:\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-doc-artifacts.pak" /Z /mov
Read-Host