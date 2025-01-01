#!/bin/bash

create_backup() {

    # Ask the user for the directory to backup
    read -p "Enter the directory to backup: " dir_to_backup

    # Check if the directory exists
    if [ ! -d "$dir_to_backup" ]; then
        echo "Error: Directory $dir_to_backup does not exist."
        exit 1
    fi

    # Ask for the destination backup directory
    read -p "Enter the destination directory for backup: " backup_dest

    # Check if the destination directory exists, if not, create it
    if [ ! -d "$backup_dest" ]; then
        echo "Destination directory does not exist, creating it."
        mkdir -p "$backup_dest"
    fi

    # Get the current date and time for timestamping
    timestamp=$(date +"%Y%m%d_%H%M%S")

    # Create a compressed archive (.tar.gz) of the specified directory
    backup_file="$backup_dest/$(basename "$dir_to_backup")_$timestamp.tar.gz"

    echo "Creating backup of $dir_to_backup in $backup_file"

    # Use tar to compress and create the archive
    tar -czf "$backup_file" -C "$(dirname "$dir_to_backup")" "$(basename "$dir_to_backup")"

    # Check if the backup was successful
    if [ $? -eq 0 ]; then
        echo "Backup successful: $backup_file"
    else
        echo "Error: Backup failed."
    fi
}

while true; do
        echo "1. Add New User "
        echo "2. Add New Group "
        echo "3. Showing users"
        echo "4. Showing groups"
        echo "5. Create Backup"
        echo "6. Exit "

        read -p "Choose Choice: " choice

        case $choice in
                1)
                        read -p "Enter the user name to add: " username
                        sudo useradd "$username"
                        if [ $? -eq 0 ]; then
                                echo "$username is added successfully"
                        else
                                echo failed
                        fi
                        ;;
                2)
                        read -p "Enter the group to add: " group
                        sudo groupadd "$group"
                        if [ $? -eq 0 ]; then
                                echo "$group is added successfully"
                        else
                                echo "failed"
                        fi
                        ;;
                3)      echo "Showing users"
                        tail -n 4 /etc/passwd
                        ;;
                4)      echo "Showing groups"
                        tail -n 4 /etc/group
                        ;;
                5)      create_backup
                        ;;
                6)
                        echo "Exiting"
                        exit 0
                        ;;

        esac
done
