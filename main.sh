source ./BACKUP_FILES.sh
source ./MANAGE_SERVICE.sh
source ./PORT_CHECK.sh
source ./SYSTEM_INSPECTION.sh

# Script Purpose Explanation
echo -e "\033[36mWelcome to the All-in-One Utility Script\033[0m"

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
