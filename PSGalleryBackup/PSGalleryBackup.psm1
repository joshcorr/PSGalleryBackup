$functions = Get-Childitem $PSScriptRoot\Public\*.ps1
foreach ($f in $functions) { . $F.Fullname }