Set-Location C:\Users\Sri\Documents
$Global:PGVM_DIR = "C:\Code\Sdk\GVM"
$Global:GRAILS_HOME= "C:\Code\Sdk\GVM\grails\current"
$env:GRAILS_OPTS= "-server -Xmx1768M -Xms256M -XX:PermSize=64m -XX:MaxPermSize=512m -Dfile.encoding=UTF-8"

$env:NODE_ENV="development"

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
# history substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Launch posh-gvm
Import-Module posh-gvm

# Load posh-git example profile
. 'C:\Users\Sri\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

# Launch code
function code{Invoke-Expression("& 'C:\Code\Editors\Microsoft VS Code Insiders\bin\code-insiders.cmd' $args")}

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

    Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor DarkYellow
    Write-Host "$ENV:COMPUTERNAME" -NoNewline -ForegroundColor Magenta

    if ($s -ne $null) {  # color for PSSessions
        Write-Host " (`$s: " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($s.Name)" -NoNewline -ForegroundColor Yellow
        Write-Host ") " -NoNewline -ForegroundColor DarkGray
    }

    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host $($(Get-Location) -replace "C:\\Users\\Sri", "~") -NoNewline -ForegroundColor Blue
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host (Get-Date -Format G) -NoNewline -ForegroundColor DarkMagenta
    Write-Host " : " -NoNewline -ForegroundColor DarkGray

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-VcsStatus

    Write-Host ""

    return "> "
}
