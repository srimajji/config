# Install scoop 
set-executionpolicy remotesigned -s cu; iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

# Core dependencies
scoop install git
scoop bucket add extras
scoop bucket add versions
scoop install sudo 7zip 
scoop install openssh coreutils which
scoop install concfg
scoop install curl

# Front-End dependencies
scoop install php56
scoop install Mysql56
scoop install nvm
scoop install yarn -i # Install yarn without node dependency


# Powershell modules
Install-Module posh-gvm
Install-Module posh-git
Install-Module PSReadline