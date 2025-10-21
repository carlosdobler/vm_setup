#!/bin/bash

# Define the create_disk() function block
CREATE_FUNCTION_BLOCK='
# Function to create, format, and mount a persistent disk
create_disk() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: create_disk <disk_type> <disk_size_gb> <mount_point_path>"
        echo "Example: create_disk pd-ssd 50 /mnt/new-disk"
        return 1
    fi

    # Execute the underlying creation script with sudo
    sudo bash ~/vm_setup/create_disk.sh "$@"
}
'

# Define the delete_disk() function block
DELETE_FUNCTION_BLOCK='
# Function to unmount, delete fstab entry, and delete the persistent disk
delete_disk() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: delete_disk <mount_point_path>"
        echo "Example: delete_disk /mnt/new-disk"
        return 1
    fi

    # Execute the underlying deletion script with sudo
    sudo bash ~/vm_setup/delete_disk.sh "$@"
}
'

# ----------------- Installation Logic -----------------

# Check and install create_disk()
if grep -q "create_disk()" "$HOME/.bashrc"; then
    echo "The 'create_disk' function already exists in ~/.bashrc. Skipping installation."
else
    printf "%s\n" "$CREATE_FUNCTION_BLOCK" >> "$HOME/.bashrc"
fi

# Check and install delete_disk()
if grep -q "delete_disk()" "$HOME/.bashrc"; then
    echo "The 'delete_disk' function already exists in ~/.bashrc. Skipping installation."
else
    printf "%s\n" "$DELETE_FUNCTION_BLOCK" >> "$HOME/.bashrc"
fi

source ~/.bashrc
