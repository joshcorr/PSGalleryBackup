$functions = Get-Childitem Public\*.ps1
foreach ($f in $functions) { . $F.Fullname }