Set-Location (Join-Path $PSScriptRoot "..\documentation\generator")
python doc.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
