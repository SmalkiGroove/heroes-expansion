
$zip = @{
  Path = "..\..\game_data\battlefields\*"
  CompressionLevel = "Fastest"
  DestinationPath = ".\h5x-battlefields.zip"
}
Compress-Archive @zip
Move-Item "h5x-battlefields.zip" "h5x-battlefields.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-battlefields.pak" /Z /mov
# Read-Host