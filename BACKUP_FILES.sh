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
