# Setup script for windows machine
# Author: Sri Majji (sri.majji@live.com)
# 
# Powershell setup script for a windows dev machine
# This script requires elavated prompt and powershell v3+
# 
# Execute below line in a new shell
# iex (new-object net.webclient).downloadstring("https://raw.githubusercontent.com/srimajji/config/master/setup.ps1")

Param (
  [string] $computerName
)

# get computerName
if (-not $computerName) {
  $computerName = Read-Host "? Computer name"
}

if(($PSVersionTable.PSVersion.Major) -lt 5) {
  Write-Output "PowerShell 3 or greater is required to run Scoop."
  Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
  break
}

# show notification to change execution policy:
if((get-executionpolicy) -gt 'Unrestricted') {
  Write-Output "PowerShell requires an execution policy of 'Unrestricted' to run this script."
  Write-Output "To make this change please run:"
  Write-Output "'Set-ExecutionPolicy Unrestricted -scope CurrentUser'"
  break
}

# Run as admin
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

echo "Set-ExecutionPolicy Unrestricted..."
Set-ExecutionPolicy Unrestricted  -scope CurrentUser 

# Create profile
if (-not $(Test-path $profile)) {
    echo "Creating a powershell profile"
    New-Item -path $profile -type file -force | Out-Null

    echo "Adding custom commands..."
    echo '
Set-Location "$env:USERPROFILE\Documents"
$env:JABBA_HOME = "$env:USERPROFILE\.sdk\java"
$env:NODE_ENV = "development"
Set-Alias open Invoke-Item
function cl() { clear }
function chrome() { Start-Process "chrome.exe" }
function chromelocal($port) { Start-Process "chrome.exe" "http://localhost:$port" }
function firefox() { Start-Process "firefox.exe" "www.google.com" }
function firefoxlocal($port) { Start-Process "firefox.exe" "http://localhost:$port" }
function ie() { Start-Process "msedge.exe" }
function ielocal($port) { Start-Process "msedge.exe" "http://lolcalhost:$port" }
' >> "$profile"

}

# Install boxstarter
echo "Initialize boxstarter..."
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force

# Setup Chocolately tools location
echo "Create chocolatlely tools location env variable..."
echo "$env:ProgramData\ChocoTools"
[Environment]::SetEnvironmentVariable('ChocolateyToolsLocation', "$env:ProgramData\ChocoTools", 'USER')

Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/srimajji/config/master/boxstarter-config.txt -DisableReboots

# Install powershell modules
echo "Installing powershell modules..."
Install-PackageProvider -Name Nuget

Install-Module -Name oh-my-posh -Scope CurrentUser
Install-Module -Name posh-git -Scope CurrentUser


echo '
Import-Module oh-my-posh
Set-Theme pure
Import-Module posh-git
' >> "$profile"

# Install Jabba => https://github.com/shyiko/jabba
echo "Installing jabba ... "
$env:JABBA_HOME = "$env:USERPROFILE\.sdk\java"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-Expression (
  Invoke-WebRequest https://github.com/shyiko/jabba/raw/master/install.ps1 -UseBasicParsing
).Content

# Install jdk 1.9
jabba install adopt@1.9.0-4
jabba use adopt@1.9.0-4
jabba alias default adopt@1.9.0-4

# modify global PATH & JAVA_HOME
echo "Setting up JAVA_HOME..."
$envRegKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)
$envPath=$envRegKey.GetValue('Path', $null, "DoNotExpandEnvironmentNames").replace('%JAVA_HOME%\bin;', '')
[Environment]::SetEnvironmentVariable('JAVA_HOME', "$(jabba which $(jabba current))", 'Machine')
[Environment]::SetEnvironmentVariable('PATH', "%JAVA_HOME%\bin;$envPath", 'Machine')

# Remove useless apps
Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage
Get-AppxPackage *Minecraft* | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
Get-AppxPackage *Solitaire* | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.Sway | Remove-AppxPackage
Get-AppxPackage Soda | Remove-AppxPackage
Get-AppxPackage *AutodeskSketchBook* | Remove-AppxPackage
Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage
Get-AppxPackage *DisneyMagicKingdoms* | Remove-AppxPackage
Get-AppxPackage *DolbyAccess* | Remove-AppxPackage
Get-AppxPackage *MarchofEmpires* | Remove-AppxPackage
Get-AppxPackage *candycrush* | Remove-AppxPackage
Get-AppxPackage *hiddencity* | Remove-AppxPackage
Get-AppxPackage *fitbit* | Remove-AppxPackage


#--- Windows Settings ---
# Some from: @NickCraver's gist https://gist.github.com/NickCraver/7ebf9efbfd0c3eab72e9

# Privacy: Let apps use my advertising ID: Disable
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
  New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

# WiFi Sense: HotSpot Sharing: Disable
If (-Not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
  New-Item -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting | Out-Null
}
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0


# Change Explorer home screen back to "This PC"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1
# Change it back to "Quick Access" (Windows 10 default)
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 2

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

# Requires restart, or add the -Restart flag
Rename-Computer -NewName $computerNames

echo "Finished setup. Restart and ejoy!"
