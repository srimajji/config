# Install scoop 
set-executionpolicy remotesigned -s cu; iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

# Core dependencies
scoop bucket add extras
scoop bucket add versions
scoop install sudo 7zip 
scoop install openssh git coreutils which
scoop install concfg

# Front-End dependencies
scoop install php56
scoop install Mysql56
scoop install nvm
nvm install 7.9.0
scoop install yarn -i # Install yarn without node dependency


# Powershell modules
Install-Module posh-gvm
Install-Module posh-git
Install-Module PSReadline