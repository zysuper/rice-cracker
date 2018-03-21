#!/bin/bash

path=${0%/*}

sudo cp "$path/org.zysuper.ricecracker.daemon.plist" /Library/LaunchAgents
sudo cp "$path/riceCrackerDaemon" /usr/bin
sudo launchctl load /Library/LaunchAgents/org.zysuper.ricecracker.daemon.plist

echo '安装米果HiScale守护进程完成！'
echo '安装程序结束，请重启电脑！！！'
bash read -p '按任何键退出'