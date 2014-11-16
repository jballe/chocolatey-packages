$java_home = [Environment]::GetEnvironmentVariables("Machine")["JAVA_HOME"]

$packageName = 'Thoughtworks.Go.Server' # arbitrary name for the package, used in messages
$installerType = 'EXE' #only one of these: exe, msi, msu
$url = '{{DownloadUrl}}' # download url
$silentArgs = '/S /GO_SERVER_JAVA_HOME=$java_home' # "/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer #msi is always /quiet
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
