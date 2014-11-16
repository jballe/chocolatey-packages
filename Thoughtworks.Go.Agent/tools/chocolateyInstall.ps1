$java_home = [Environment]::GetEnvironmentVariables("Machine")["JAVA_HOME"]

$packageName = 'Thoughtworks.Go.Agent'
$installerType = 'EXE'
$url = '{{DownloadUrl}}'
$silentArgs = '/S /GO_AGENT_JAVA_HOME=$java_home'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes
# download and unpack a zip file
# if removing $url64, please remove from here

