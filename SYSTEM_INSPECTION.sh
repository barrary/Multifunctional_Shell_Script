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
