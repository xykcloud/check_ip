#!/bin/bash

# 目标域名
target_domain="example.com"

# 获取目标域名的IP地址
ip_address=$(ping -c 1 $target_domain | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

# 检查是否成功获取到IP地址
if [ -n "$ip_address" ]; then
    echo "IP地址: $ip_address"
    
    if [ -e "ip.txt" ]; then
        saved_ip=$(cat ip.txt)
        if [ "$saved_ip" == "$ip_address" ]; then
            echo "ip.txt存在，IP地址一致"
        else
            echo "ip.txt存在，IP地址不一致，新IP地址已保存到ip.txt文件中"
            echo "$ip_address" > ip.txt
            # 重启OpenLiteSpeed服务中名为example.com网站
            /usr/local/lsws/bin/lswsctrl restart example.com
        fi
    else
        echo "ip.txt不存在，IP地址已保存到ip.txt文件中"
        echo "$ip_address" > ip.txt
    fi
else
    echo "无法获取到IP地址"
fi



# 在此脚本中，首先获取目标域名的IP地址，并将其存储在ip_address变量中。然后，使用条件语句和文件检测操作进行不同的处理。
# 如果ip.txt文件存在，脚本会读取其中的IP地址并与获取到的IP地址进行比较。如果两者一致，则输出"ip.txt存在，IP地址一致"；如果不一致，则覆盖ip.txt文件并输出"ip.txt存在，IP地址不一致，新IP地址已保存到ip.txt文件中"。
# 如果ip.txt文件不存在，则直接将获取到的IP地址写入ip.txt文件，并输出"ip.txt不存在，IP地址已保存到ip.txt文件中"。
# 请确保将target_domain变量替换为您要检测的实际域名。执行脚本后，它将根据IP地址的不同情况进行相应的输出和操作。
