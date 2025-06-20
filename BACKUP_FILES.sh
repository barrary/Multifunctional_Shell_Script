# Backup Function
BACKUP_FILES () {
    read -p $'\033[33mPlease enter the file or directory to backup: \033[0m' SOURCE
    read -p $'\033[33mPlease enter the destination path for the backup: \033[0m' DESTINATION

    if [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]; then
        echo -e "\033[31mInput cannot be empty. Please try again.\033[0m"
        exit 2
    fi

    cp -r "$SOURCE" "$DESTINATION"
    if [ $? -eq 0 ]; then
        echo -e "\033[32mBackup of $SOURCE to $DESTINATION completed successfully.\033[0m"
    else
        echo -e "\033[31mBackup operation failed.\033[0m"
    fi
}
