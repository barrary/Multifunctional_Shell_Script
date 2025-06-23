#!/bin/bash

# Script Purpose Explanation
echo -e "\033[36mWelcome to the All-in-One Utility Script\033[0m"

# Service Management Function
MANAGE_SERVICE () {
    read -p $'\033[33mPlease select an action (stop | start | restart | status): \033[0m' ACTION
    if [[ "$ACTION" != "stop" && "$ACTION" != "start" && "$ACTION" != "restart" && "$ACTION" != "status" ]]; then
        echo -e "\033[31mInvalid input. Please enter stop, start, restart, or status.\033[0m"
        exit 1
    fi

    read -p $'\033[33mPlease specify the service name to operate on: \033[0m' SERVICE
    if [ -z "$SERVICE" ];then
      echo -e "\033[31mService name cannot be empty\033[0m"
    fi

    SERVICE_NAME="$SERVICE"
    [[ "$SERVICE_NAME" != *.service ]] && SERVICE_NAME="$SERVICE_NAME.service"

    if systemctl list-unit-files | grep -qw "^$SERVICE_NAME"; then
    :
    else
        MATCHES=$(systemctl list-unit-files | awk '{print $1}' | grep -i "$SERVICE")
        if [ -z "$MATCHES" ]; then
            echo -e "\033[31mService '$SERVICE' does not exist or is not recognized by systemctl.\033[0m"
            exit 3
        else
            echo -e "\033[31mNo exact match found for '$SERVICE'. Did you mean one of these?\033[0m"
            echo "$MATCHES"
            exit 4
        fi
    fi

    case $ACTION in
        stop)
            systemctl stop $SERVICE
            if [ $? -eq 0 ]; then
                echo -e "\033[32mSuccessfully stopped service: $SERVICE\033[0m"
            else
                echo -e "\033[31mFailed to stop service: $SERVICE\033[0m"
            fi
            ;;
        start)
            systemctl start $SERVICE
            if [ $? -eq 0 ]; then
                echo -e "\033[32mSuccessfully started service: $SERVICE\033[0m"
            else
                echo -e "\033[31mFailed to start service: $SERVICE\033[0m"
            fi
            ;;
        restart)
            systemctl restart $SERVICE
            if [ $? -eq 0 ]; then
                echo -e "\033[32mSuccessfully restarted service: $SERVICE\033[0m"
            else
                echo -e "\033[31mFailed to restart service: $SERVICE\033[0m"
            fi
            ;;
        status)
            systemctl status $SERVICE
            if [ $? -eq 0 ]; then
                echo -e "\033[32mService status checked successfully: $SERVICE\033[0m"
            else
                echo -e "\033[31mFailed to check status of service: $SERVICE\033[0m"
            fi
            ;;
        *)
            echo -e "\033[31mInvalid operation type!\033[0m"
            ;;
    esac
}

# Backup Function
BACKUP_FILES () {
    read -p $'\033[33mPlease enter the file or directory to backup: \033[0m' SOURCE
    read -p $'\033[33mPlease enter the destination path and file name for the backup: \033[0m' DESTINATION

    if [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]; then
        echo -e "\033[31mInput cannot be empty. Please try again.\033[0m"
        exit 2
    fi

    if [ ! -e "$SOURCE" ];then
      echo -e "\033[31mSource path is does not exist. please check the input!\033[0m"
      exit 3
    fi

    DEST_DIR=$(dirname "$DESTINATION")
    mkdir -p "$DEST_DIR"
    DESTINATION="${DESTINATION%.tar.gz}"

    tar -zcf "$DESTINATION".tar.gz "$SOURCE"
    if [ $? -eq 0 ]; then
        echo -e "\033[32mBackup of $SOURCE to $DESTINATION.tar.gz completed successfully.\033[0m"
    else
        echo -e "\033[31mBackup operation failed.\033[0m"
    fi
}

# System Inspection Function
SYSTEM_INSPECTION () {
    echo -e "\033[34m----- Hostname -----\033[0m"
    HOSTNAME_SHORT=$(hostname | awk -F '.' '{print $1}')
    echo -e "Current hostname: $HOSTNAME_SHORT"

    echo -e "\033[34m----- OS Version -----\033[0m"
    OS_VERSION=$(grep PRETTY_NAME /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')
    echo -e "Operating System: $OS_VERSION"

    echo -e "\033[34m----- Active Users -----\033[0m"
    who | while read USER TTY MONTH DAY TIME IP; do
        IP_CLEAN=$(echo "$IP" | tr -d '()')
        if [[ -z "$IP_CLEAN" ]]; then
            IP_CLEAN="Local Login"
        fi
        echo "User: $USER | Login Time: $MONTH $DAY $TIME | IP: $IP_CLEAN"
    done

    echo -e "\033[34m----- Network Interfaces -----\033[0m"
    ip -o -4 addr show | grep -v ' lo ' | while read -r LINE; do
        IFACE=$(echo $LINE | awk '{print $2}')
        IPADDR=$(echo $LINE | awk '{print $4}')
        echo "Interface: $IFACE | IP Address: $IPADDR"
    done

    echo -e "\033[34m----- CPU Information -----\033[0m"
    CPU_MODEL=$(grep "model name" /proc/cpuinfo | uniq | awk -F ': ' '{print $2}')
    PHYSICAL_CORES=$(grep "cpu cores" /proc/cpuinfo | uniq | awk -F ': ' '{print $2}')
    VIRTUAL_CORES=$(grep "^processor" /proc/cpuinfo | wc -l)
    echo "CPU Model: $CPU_MODEL"
    echo "Physical Cores: $PHYSICAL_CORES"
    echo "Virtual Cores: $VIRTUAL_CORES"

    echo -e "\033[34m----- Memory Usage -----\033[0m"
    read -r _ TOTAL USED FREE SHARED BUFFERS AVAILABLE < <(free -h | grep Mem)
    echo "Total Memory: $TOTAL"
    echo "Used Memory: $USED"
    echo "Free Memory: $FREE"
    echo "Buffered Memory: $BUFFERS"
    echo "Available Memory: $AVAILABLE"

    echo -e "\033[34m----- Disk Usage -----\033[0m"
    read -r FILESYSTEM SIZE USED AVAIL USE_PERCENT MOUNTED < <(df -h | grep /dev/mapper/)
    echo "Filesystem: $FILESYSTEM"
    echo "Mount Point: $MOUNTED"
    echo "Total Size: $SIZE"
    echo "Used Space: $USED"
    echo "Available Space: $AVAIL"
    echo "Usage Percentage: $USE_PERCENT"
}

# Port Check Function
PORT_CHECK () {
    echo -e "\033[34m----- Port Status Check -----\033[0m"
    read -p $'\033[34mPlease enter the port number to check: \033[0m' PORT_TO_CHECK
    LISTENING_PORTS=$(netstat -tunlp 2>/dev/null | awk '/LISTEN|UDP/ && $4 ~ /:/ {split($4,a,":"); print a[length(a)]}' | sort -n | uniq)

    FOUND=0
    for PORT in $LISTENING_PORTS; do
        if [ "$PORT_TO_CHECK" -eq "$PORT" ]; then
            echo -e "\033[32mPort $PORT_TO_CHECK is currently being listened on.\033[0m"
            FOUND=1
            break
        fi
    done

    if [ $FOUND -eq 0 ]; then
        echo -e "\033[31mPort $PORT_TO_CHECK is not being listened on.\033[0m"
    fi
}

# Main Entry Point
echo -e "\033[33mPlease select a service to proceed:\033[0m"
echo -e "\033[35m1. Service Management"
echo "2. File Backup"
echo -e "3. System Inspection"
echo -e "4. Port Status Check\033[0m"
read -p $'\033[33mYour choice: \033[0m' CHOICE

case $CHOICE in
    1)
        MANAGE_SERVICE
        ;;
    2)
        BACKUP_FILES
        ;;
    3)
        SYSTEM_INSPECTION
        ;;
    4)
        PORT_CHECK
        ;;
    *)
        echo -e "\033[31mPlease select a valid option from above!\033[0m"
        exit 2
        ;;
esac
