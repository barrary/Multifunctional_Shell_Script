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
