#!/bin/bash

path=${0%/*}

sudo pkill riceCrackerDaemon
sudo rm -rf /Library/LaunchDaemons/org.zysuper.ricecracker.daemon.plist
sudo rm -rf /usr/bin/riceCrackerDaemon
sudo rm -rf /var/log/rice-cracker.log

echo '卸载米果旧的守护进程完成！'
echo '卸载程序结束! '
bash read -p '按任何键退出'