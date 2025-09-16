
$zip = @{
  Path = "..\game_data\data\*"
  CompressionLevel = "Fastest"
  DestinationPath = ".\h5x-data.zip"
}
Compress-Archive @zip
Move-Item "h5x-data.zip" "h5x-data.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-data.pak" /Z /mov
Read-Host