Set-Location C:\Users\Sri\Documents
$Global:PGVM_DIR = "C:\Code\Sdk\GVM"
$Global:GRAILS_HOME= "C:\Code\Sdk\GVM\grails\current"
$env:SCOOP = "C:\Users\Sri\AppData\Local\Scoop"
$env:NODE_ENV = "development"

# Import Modules
Import-Module PsGet

# Launch posh-gvm
Import-Module posh-gvm

# Load posh-git example profile
Import-Module posh-git

# Alias
Set-Alias g2 runGrails2
Set-Alias g3 runGrails3
Set-Alias open Invoke-Item

# Remove powershell curl (use curl from coreutils)
Remove-Item alias:curl

# Launch get-childItem-color profile
. 'C:\Users\Sri\Documents\WindowsPowerShell\Modules\Get-ChildItem-Color\Get-ChildItem-Color.ps1'
Set-Alias ls Get-ChildItem-Color -option AllScope -Force
Set-Alias dir Get-ChildItem-Color -option AllScope -Force

# Launch PSReadLine
. 'C:\Users\Sri\Documents\WindowsPowerShell\Modules\PSReadLine\SamplePSReadlineProfile.ps1'

Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000

# History substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Custom functions
function runGrails2($args) { jabba use system@1.7.0; gvm use grails 2.3.11; grails $args }
function runGrails3($args) { jabba use system@1.8.0; gvm use grails 3.2.11; grails $args }
#function code{Invoke-Expression("& 'C:\Code\Editors\Microsoft VS Code Insiders\bin\code-insiders.cmd' $args")}

# Load custom prompt
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    if (Test-Administrator) {  # Use different username if elevated
        Write-Host "(Elevated) " -NoNewline -ForegroundColor White
    }

    # Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor DarkYellow
    # Write-Host "$ENV:COMPUTERNAME" -NoNewline -ForegroundColor Magenta

    if ($s -ne $null) {  # color for PSSessions
        Write-Host " (`$s: " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($s.Name)" -NoNewline -ForegroundColor Yellow
        Write-Host ") " -NoNewline -ForegroundColor DarkGray
    }

    # Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host $($(Get-Location) -replace "C:\\Users\\Sri", "~") -NoNewline -ForegroundColor Blue
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host (Get-Date -Format G) -NoNewline -ForegroundColor DarkMagenta
    # Write-Host " : " -NoNewline -ForegroundColor DarkGray

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-VcsStatus

    Write-Host ""

    return "> "
}

if (Test-Path "C:\Users\Sri\.jabba\jabba.ps1") { . "C:\Users\Sri\.jabba\jabba.ps1" }
