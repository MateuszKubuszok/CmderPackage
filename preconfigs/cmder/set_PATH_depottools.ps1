$PathRegister = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'
$CurrentDir = split-path -parent $MyInvocation.MyCommand.Definition
$DepotToolsDir = "$CurrentDir\cygwin\opt\depot_tools"
$DepotToolsPythonDir = "$DepotToolsDir\python276_bin"
$OldPATH = (Get-ItemProperty -Path $PathRegister -Name PATH).Path
$NewPATH = "$OldPATH;$DepotToolsDir;DepotToolsPythonDir"
Set-ItemProperty -Path $PathRegister -Name PATH –Value $NewPATH