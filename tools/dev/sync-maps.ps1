
$zip = @{
  Path = "..\..\game_data\maps\*"
  CompressionLevel = "Fastest"
  DestinationPath = ".\h5x-maps.zip"
}
Compress-Archive @zip
Move-Item "h5x-maps.zip" "h5x-maps.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-maps.pak" /Z /mov
# Read-Host