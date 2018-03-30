# Netgear r6900 to r7000 flash

Below steps will show you how to prepare netgear r6900(costco) router for dd-wrt

## r6900 to r7000
Since the dd-wrt firmware is only available for r7000, we need to first change the boardID via telnet

1. Download telneteable.exe and execute
2. `./ telnetable router-ip router-mac admin password`
3. If you are using windows, allow port 23 via windows firewall rules
4. In a console, execute `telnet 192.168.1.1`

### Flash dd-wrt
1. Download firmware from  http://www.desipro.de/ddwrt/K3-AC-Arm/
2. Login to router shell via http://192.168.1.1
3. Go to `Administration`
4. Upload firmware and wait till router reboots

[Source](https://www.dd-wrt.com/phpBB2/viewtopic.php?t=301328&postdays=0&postorder=asc&start=0)
