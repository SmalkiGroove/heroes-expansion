
$zip = @{
  Path = "..\game_data\doc-skills\*"
  CompressionLevel = "Fastest"
  DestinationPath = ".\h5x-doc-skills.zip"
}
Compress-Archive @zip
Move-Item "h5x-doc-skills.zip" "h5x-doc-skills.pak" -Force
# Read-Host

$game_path = if ($env:H5_Folder) {$env:H5_Folder} else {"C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic V - Tribes of the East"}
Robocopy.exe "." "$game_path\data" "h5x-doc-skills.pak" /Z /mov
# Read-Host