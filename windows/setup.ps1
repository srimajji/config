# Setup script for windows machine
# Author: Sri Majji (sri.majji@live.com)

# requires -v 3
echo "
__      __                  __                                                  __                                                           __      
/\ \  __/\ \  __            /\ \                                                /\ \__                                             __        /\ \__   
\ \ \/\ \ \ \/\_\    ___    \_\ \    ___   __  __  __    ____        ____     __\ \ ,_\  __  __  _____         ____    ___   _ __ /\_\  _____\ \ ,_\  
 \ \ \ \ \ \ \/\ \ /' _ `\  /'_` \  / __`\/\ \/\ \/\ \  /',__\      /',__\  /'__`\ \ \/ /\ \/\ \/\ '__`\      /',__\  /'___\/\`'__\/\ \/\ '__`\ \ \/  
  \ \ \_/ \_\ \ \ \/\ \/\ \/\ \L\ \/\ \L\ \ \ \_/ \_/ \/\__, `\    /\__, `\/\  __/\ \ \_\ \ \_\ \ \ \L\ \    /\__, `\/\ \__/\ \ \/ \ \ \ \ \L\ \ \ \_ 
   \ `\___x___/\ \_\ \_\ \_\ \___,_\ \____/\ \___x___/'\/\____/    \/\____/\ \____\\ \__\\ \____/\ \ ,__/    \/\____/\ \____\\ \_\  \ \_\ \ ,__/\ \__\
    '\/__//__/  \/_/\/_/\/_/\/__,_ /\/___/  \/__//__/   \/___/      \/___/  \/____/ \/__/ \/___/  \ \ \/      \/___/  \/____/ \/_/   \/_/\ \ \/  \/__/
                                                                                                   \ \_\                                  \ \_\       
                                                                                                    \/_/                                   \/_/       
           ____                                                                                                                                       
          /\  _`\          __      /'\_/`\             __      __  __                                                                                 
          \ \,\L\_\  _ __ /\_\    /\      \     __    /\_\    /\_\/\_\                                                                                
 _______   \/_\__ \ /\`'__\/\ \   \ \ \__\ \  /'__`\  \/\ \   \/\ \/\ \                                                                               
/\______\    /\ \L\ \ \ \/ \ \ \   \ \ \_/\ \/\ \L\.\_ \ \ \   \ \ \ \ \                                                                              
\/______/    \ `\____\ \_\  \ \_\   \ \_\\ \_\ \__/.\_\_\ \ \  _\ \ \ \_\                                                                             
              \/_____/\/_/   \/_/    \/_/ \/_/\/__/\/_/\ \_\ \/\ \_\ \/_/                                                                             
                                                      \ \____/\ \____/                                                                                
                                                       \/___/  \/___/                                                                                 

"

if(($PSVersionTable.PSVersion.Major) -lt 3) {
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

echo "Set-ExecutionPolicy AllSigned..."
Set-ExecutionPolicy Unrestricted  -scope CurrentUser 

# Create profile
if (-not $(Test-path $profile)) {
    echo "Creating a powershell profile"
    New-Item -path $profile -type file -force | Out-Null

    echo "Adding custom commands..."
    echo '
Set-Location C:\Users\Sri\Documents
$env:PGVM_DIR = "$env:USERPROFILE\.sdk"
$env:GRAILS_HOME = "$env:USERPROFILE\.sdk\grails\current"
$env:JABBA_HOME = "$env:USERPROFILE\.sdk\java"
$env:NODE_ENV = "development"
Set-Alias open Invoke-Item
function g2($args) { jabba use system@1.7.0; gvm use grails 2.3.11; grails "$args" }
function g3($args) { jabba use system@1.8.0; gvm use grails 3.2.11; grails "$args" }
function cl() { clear }
function chrome() { Start-Process "chrome.exe" }
function chromelocal($port) { Start-Process "chrome.exe" "http://localhost:$port" }
function firefox() { Start-Process "firefox.exe" "www.google.com" }
function firefoxlocal($port) { Start-Process "firefox.exe" "http://localhost:$port" }
function ie() { Start-Process "edge.exe" }
function ielocal($port) { Start-Process "edge.exe" "http://lolcalhost:$port" }
' >> "$profile"

}

# Setup Chocolately tools location
echo "Create chocolatlely tools location env variable..."
echo "$env:ProgramData\ChocoTools"
[Environment]::SetEnvironmentVariable('ChocolatelyToolsLocation', "$env:ProgramData\ChocoTools", 'Machine')

# Install boxstarter
echo "Initialize boxstarter..."
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
Install-BoxstarterPackage -PackgeName https://raw.githubusercontent.com/srimajji/config/master/windows/boxstart-config.txt -DisableReboots

# Install powershell modules
echo "Installing powershell modules..."
Install-PackageProvider -Name Nuget
Install-Module -Name PowerShellGet
Install-Module -Name posh-git
Install-Module oh-my-posh

Import-Module PowerShellGet -Force
Import-Module posh-git -Force
Import-Module oh-my-posh -Force

echo '
ImportModule PowerShellGet
ImportModule posh-git
ImportModule oh-my-posh
' >> "$profile"

# Install Jabba => https://github.com/shyiko/jabba
echo "Installing jabba ... "
$env:JABBA_HOME = "$env:USERPROFILE\.sdk\java"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-Expression (
  Invoke-WebRequest https://github.com/shyiko/jabba/raw/master/install.ps1 -UseBasicParsing
).Content

# Install jdk 1.8
jabba install 1.8
jabba use 1.8
jabba alias default 1.8

# modify global PATH & JAVA_HOME
echo "Setting up JAVA_HOME..."
$envRegKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)
$envPath=$envRegKey.GetValue('Path', $null, "DoNotExpandEnvironmentNames").replace('%JAVA_HOME%\bin;', '')
[Environment]::SetEnvironmentVariable('JAVA_HOME', "$(jabba which $(jabba current))", 'Machine')
[Environment]::SetEnvironmentVariable('PATH', "%JAVA_HOME%\bin;$envPath", 'Machine')


# Install posh-gvm => https://github.com/flofreud/posh-gvm
$global:PGVM_DIR = "$env:USERPROFILE\.sdk"
(new-object Net.WebClient).DownloadString('https://raw.githubusercontent.com/flofreud/posh-gvm/master/GetPoshGvm.ps1') | iex
Import-Module posh-gvm -Force
echo "Import-Module posh-gvm" >> "$profile"

# Set up grails
gvm install grails 2.5.6
gvm use grails 2.5.6
$env:GRAILS_HOME = "$env:USERPROFILE\.sdk\grails\current"

# nvm
echo "Finished setup. Enjoy!"