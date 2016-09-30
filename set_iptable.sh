#!/bin/sh
#清除配置
iptables -P INPUT ACCEPT
iptables -F
iptables -X

#开放本地和Ping
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j drop

#配置内网白名单
#iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
#iptables -A INPUT -s 192.168.0.0/2 -j ACCEPT

#配置外网白名单
iptables -A INPUT -s 8.8.8.8 -j ACCEPT

#控制端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#拒绝其它
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP

#开放出口
iptables -A OUTPUT -j ACCEPT

iptables -nvL --line-numbers
echo "done!"
