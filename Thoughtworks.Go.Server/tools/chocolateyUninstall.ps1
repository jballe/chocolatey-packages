$name = "Go Server"

$node = Get-ItemProperty "registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\ThoughtWorks Studios\$name" -ErrorAction SilentlyContinue
if($node -eq $null) {
    $node = Get-ItemProperty "registry::HKEY_LOCAL_MACHINE\SOFTWARE\ThoughtWorks Studios\$name" -ErrorAction SilentlyContinue
}

$path = $null
if($node -ne $null) {
    $path = Join-Path $node.Install_Dir "install.exe"
}

if($node -eq $null) {
    Write-Warning "Could not find install entry from registry. Will not call uninstall program"
} elseif(Test-Path $path -eq $false) {
    Write-Warning "Could not find uninstall program at $path"
} else {
    Start-Process $path -ArgumentList @("/s") -NoNewWindow -PassThru -Wait
}
