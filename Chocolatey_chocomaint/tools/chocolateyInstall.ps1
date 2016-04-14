$packageName = 'chocomaint'
$installerType = 'EXE' 
$url = 'https://raw.githubusercontent.com/zersh01/ChocoMain/master/InstallChocoMaint/ChocoMaint_1.0.3.4_Setup.exe'
$silentArgs = '/S'
$validExitCodes = @(0) 
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"   -validExitCodes $validExitCodes

