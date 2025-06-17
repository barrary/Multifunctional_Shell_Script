#!/bin/bash

#解释脚本用途
echo -e "\033[36m这是一个全能脚本\033[0m"

#控制程序函数
SYSTEM () {
    read -p $'\033[33m请在 stop | start | restart | status 中选择一种模式: \033[0m' ST
    if [[ "$ST" != "stop" && "$ST" != "start" && "$ST" != "status" ]]; then
    echo -e "\033[31m只能输入 stop、start 或 status！\033[0m"
    exit 1
    fi

    read -p $'\033[33m请表明您要操作的服务: \033[0m' SERVER
    case $ST in
        stop)
            systemctl stop $SERVER
            if [ $? -eq 0 ]; then
                echo -e "\033[32m关闭 $SERVER 成功\033[0m"
            else
                echo -e "\033[31m关闭 $SERVER 失败\033[0m"
            fi
            ;;
        start)
            systemctl start $SERVER
            if [ $? -eq 0 ]; then
                echo -e "\033[32m启动 $SERVER 成功\033[0m"
            else
                echo -e "\033[31m启动 $SERVER 失败\033[0m"
            fi
            ;;
        restart)
            systemctl restart $SERVER
            if [ $? -eq 0 ]; then
                echo -e "\033[32m重启 $SERVER 成功\033[0m"
            else
                echo -e "\033[31m重启 $SERVER 失败\033[0m"
            fi
            ;;
        status)
            systemctl status $SERVER
            if [ $? -eq 0 ]; then
                echo -e "\033[32m查看 $SERVER 状态成功\033[0m"
            else
                echo -e "\033[31m查看 $SERVER 状态失败\033[0m"
            fi
            ;;
        *)
            echo -e "\033[31m无效的操作类型！\033[0m"
            ;;
    esac
}

#备份函数
BACKUP () {
    read -p $'\033[33m请输入你要备份的文件或目录: \033[0m' DIRECTORY
    read -p $'\033[33m请输入你备份文件的路径: \033[0m' BACKUP_PATH
    if [ -z "$DIRECTORY" ] || [ -z "$BACKUP_PATH" ]; then
        echo -e "\033[31m请按照提示正确填写！\033[0m"
        exit 2
    fi
    cp -r $DIRECTORY $BACKUP_PATH
    if [ $? -eq 0 ]; then
        echo -e "\033[32m将 $DIRECTORY 备份到 $BACKUP_PATH 成功\033[0m"
    else
        echo -e "\033[31m备份失败\033[0m"
    fi
}

#系统巡检函数
INSPECT () {
    echo -e "\033[34m----- 主机名 -----\033[0m"
    LOCALNAME=$(hostname | awk -F \. '{print $1}')
    echo -e "当前主机名为：$LOCALNAME"

    echo -e "\033[34m----- 系统版本 -----\033[0m"
    SYSTEM_VERSION=$(cat /etc/os-release | grep PRETTY_NAME | awk -F\" '{print $2}')
    echo -e "当前系统版本为：$SYSTEM_VERSION"

    echo -e "\033[34m----- 当前用户 -----\033[0m"
#    ME=$(who | awk '{print $1}')
#    for m in $ME;do
#      echo "当前登录的用户是：$m"
#    done
    who | while read USER TTY MONTH DAY TIME IP; do
     IP_CLEAN=$(echo "$IP" | tr -d '()')
     if [[ -z "$IP_CLEAN" ]]; then
         IP_CLEAN="本地登录"
     fi
     echo "当前登陆的用户是：$USER 他的登录时间为：$MONTH $DAY $TIME 他的登录IP为：$IP_CLEAN"
    done

    echo -e "\033[34m----- 网卡配置 -----\033[0m"
    ip -o -4 addr show | grep -v ' lo ' | while read -r LINE; do
        IFACE=$(echo $LINE | awk '{print $2}')
        IPADDR=$(echo $LINE | awk '{print $4}')
        echo "网卡$IFACE的IP地址为: $IPADDR"
    done

    echo -e "\033[34m----- CPU 配置 -----\033[0m"
    CPU_MODELS=$(grep "model name" /proc/cpuinfo | uniq | awk -F': ' '{print $2}')
    PHYSICAL_NUCLEUS=$(grep "cpu cores" /proc/cpuinfo | uniq | awk -F': ' '{print $2}')
    VIRTUAL_CORE=$(grep "processor" /proc/cpuinfo | wc -l)
    echo "CPU型号：$CPU_MODELS"
    echo "CPU物理核数：$PHYSICAL_NUCLEUS"
    echo "CPU虚拟核数：$VIRTUAL_CORE"

    echo -e "\033[34m----- 内存配置 -----\033[0m"
    read -r _ TOTAL USED FREE SHARED BUFF AVAILABLE < <(free -h | grep Mem)
    echo "总物理内存为：$TOTAL"
    echo "当前已使用内存为：$USED"
    echo "当前空闲内存为：$FREE"
    echo "当前缓存内存为：$BUFF"
    echo "当前可用内存为：$AVAILABLE"

    echo -e "\033[34m----- 磁盘配置 -----\033[0m"
    read -r FILESYSTEM SIZE USE AVAIL PERCENTAGES MOUNTED < <(df -h | grep /dev/mapper/)
    echo "逻辑卷名：$FILESYSTEM"
    echo "挂载点：$MOUNTED"
    echo "总容量：$SIZE"
    echo "已使用空间：$USE"
    echo "剩余空间：$AVAIL"
    echo -e "使用率：$PERCENTAGES"
}

#端口检查函数
PORT_CHECK () {
    echo -e "\033[34m----- 端口检查 -----\033[0m"
    read -p $'\033[34m请输入您要检查的端口号：\033[0m' NE
    PORTS=$(netstat -tunlp 2>/dev/null | awk '/LISTEN|UDP/ && $4 ~ /:/ {split($4, a, ":"); print a[length(a)]}' | sort -n | uniq)
    FOUND=0
    for P in $PORTS;do
      if [ $NE -eq $P ];then
        echo -e "\033[32m您所检查的$NE端口正在被监听\033[0m"
        FOUND=1
        break
      fi
    done

    if [ $FOUND -eq 0 ];then
      echo -e "\033[31m您所检查的$NE端口没有被监听\033[0m"
    fi
}  

# 主程序入口
echo -e "\033[33m请在下列服务中选择您所需要的：\033[0m"
echo -e "\033[35m1. 程序管理"
echo "2. 文件备份"
echo -e "3. 系统巡检"
echo -e "4. 端口检查\033[0m"
read -p $'\033[33m您所选的服务是: \033[0m' what

case $what in
    1)
        SYSTEM
        ;;
    2)
        BACKUP
        ;;
    3)
        INSPECT
        ;;
    4)
        PORT_CHECK
        ;;
    *)
        echo -e "\033[31m请选择上述有效的服务选项！\033[0m"
        exit 2
        ;;
esac

