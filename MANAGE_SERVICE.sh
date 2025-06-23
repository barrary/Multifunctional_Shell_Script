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
