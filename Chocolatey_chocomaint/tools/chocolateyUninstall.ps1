$packageName = 'chocomaint'
 $fileType = 'exe'
 $silentArgs = '/S'
 
 $uninstallString = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ChocoMaint').UninstallString

 if ($uninstallString -ne ") {
     Uninstall-ChocolateyPackage $packageName $fileType $silentArgs $uninstallString
 }







