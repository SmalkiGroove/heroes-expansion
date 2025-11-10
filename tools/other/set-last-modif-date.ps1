attrib -r "..\..\game_data\*.*" /s

foreach ($file in Get-ChildItem "..\..\game_data\" -Recurse)
{
    $file.LastWriteTime = (Get-Date)
}
Read-Host