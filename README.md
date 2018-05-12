# Config
Checklist to set up my windows environment. Inspired by [mdo/config](https://github.com/mdo/config)

## Windows
With boxstarter and chocolately, it's very easy to setup your new windows machine in minutes

## What does it do?

1. Creates a windows powershell profile with some shortcuts if it doesn't exist 
2. Sets `Execution-Policy Unrestricted`
3. Install boxstart which then executes the `bostarter-config.txt`
4. Boxstarter installs basic apps for web-dev and also enables some file explorer options
5. Installs Powershell modules such as `posh-gvm`
6. Installs Java version manager (jaaba)
7. Installs jdk8 using jabba and sets up JAVA_HOME
8. Installs `posh-gvm` which lets you download various sdks such as gradle
9. Removes all the useless apps that comes with new Win10 machine
10. Disables advertisement options
11. Installs windows updates
12. Changes your computer name to `trap` which you can modify

## Installation (Powershell v3+)
```
git clone https://github.com/srimajji/config.git
cd config
./setup.ps1
```
