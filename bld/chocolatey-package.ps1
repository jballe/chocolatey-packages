$file = $env:GO_PACKAGE_URL_GO_SERVER_LABEL;

if($file -eq $null) {
    $file = "go-server-14.3.0-1186-setup.exe";
}
$basepath = "http://download.go.cd/gocd/"

$appname = $env:GO_PIPLINE_NAME;
if($appname -eq $null) {
    $appname = "Thoughtworks.Go.Server"
}

$source = $env:SOURCE_URL
$apikey = $env:SOURCE_APIKEY

if($source -eq $null) {
    $source = "https://chocolatey.org/"
    $apikey = "a2a5f65a-d07b-40c3-b486-a0c6deeb6936"
}

$packagesroot = $pwd # "D:\Priv\chocolatey\packages\"

#Files
$cpack = "cpack" # "C:\Chocolatey\bin\cpack.exe"
$nuget = "nuget" # "C:\Chocolatey\lib\NuGet.CommandLine.2.8.2\tools\NuGet.exe"


$found = $file -match '\d+(\.\d+(\.\d+([\-\.]\d+)?)?)?'
if(!$found) {
    write-error "no version found in $file"
    return
}

$version = $Matches[0].Replace("-", ".")

$fullurl = $basepath + $file
$target = join-path $pwd $file

#write-host "Download to $target from $fullurl"
#$wc = new-object System.Net.WebClient
#$wc.DownloadFile($fullurl, $file);

# make replacements
$packageroot = join-path $packagesroot $appname
$nuspecfile = $appname + ".nuspec"
$nuspec = join-path $packageroot $nuspecfile
$install = join-path $packageroot "tools\chocolateyInstall.ps1"
$expected = join-path $pwd $nuspecfile.Replace(".nuspec", ".$version.nupkg")

write-host "Replace content in $nuspec..."

(Get-Content $nuspec).Replace("{{PackageVersion}}", $version) | Set-Content $nuspec
(Get-Content $install).Replace("{{DownloadUrl}}", $fullurl) | Set-Content $install

# make package

write-host "Generate package..."
Start-Process -NoNewWindow -Wait -RedirectStandardOutput $true -FilePath $cpack -ArgumentList @($nuspec)

if((Test-Path $expected) -eq $false) {
    write-error "No package found on $expected"
    return
}

# todo test package


# push package
write-host "Push package to $source"

Start-Process -NoNewWindow -Wait -RedirectStandardOutput $true -FilePath $nuget -ArgumentList @("SetApiKey", $apikey, "-Source", $source)

Start-Process -NoNewWindow -Wait -RedirectStandardOutput $true -FilePath $nuget -ArgumentList @("push", $expected, "-Source", $source)

