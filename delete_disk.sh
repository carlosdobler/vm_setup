#!/bin/bash

# --- Usage Function ---
usage() {
    echo "Usage: sudo $0 <mount_point_path>"
    echo "Example: sudo $0 /mnt/data"
    exit 1
}

# --- Check for correct number of arguments ---
if [ "$#" -ne 1 ]; then
    usage
fi

# --- Assign Arguments to Variables ---
MOUNT_POINT="$1"
DISK_NAME=$(basename ${MOUNT_POINT})-disk # Recreate the disk name
# Get the VM's simple instance name (not the FQDN)
INSTANCE_NAME=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)

# *** CRITICAL CHANGE: Get the zone directly from the metadata server ***
ZONE=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone | awk -F/ '{print $NF}')

# --- Validation Checks ---
if [ -z "$ZONE" ] || [ -z "$INSTANCE_NAME" ]; then
    echo "ERROR: Could not determine the VM's zone or instance name. Exiting."
    exit 1
fi

# 1. Unmount the disk
if mountpoint -q "${MOUNT_POINT}"; then
    sudo umount "${MOUNT_POINT}"
    if [ $? -ne 0 ]; then
        echo "ERROR: Unmounting failed. Ensure no processes are using the mount point. Exiting."
        exit 1
    fi
else
    echo "Disk is not currently mounted at '${MOUNT_POINT}'. Skipping unmount."
fi

# 2. Remove the entry from /etc/fstab
# Escape the path for sed to handle slashes correctly
ESCAPED_MOUNT_POINT=$(echo "${MOUNT_POINT}" | sed 's/\//\\\//g')
sudo sed -i.bak "/${ESCAPED_MOUNT_POINT}/d" /etc/fstab

# 3. Delete the mounting point directory
if [ -d "${MOUNT_POINT}" ]; then
    sudo rm -rf "${MOUNT_POINT}"
else
    echo "  Directory does not exist. Skipping."
fi

# 4. Detach the disk from the current instance
gcloud compute instances detach-disk "${INSTANCE_NAME}" \
    --disk "${DISK_NAME}" \
    --zone "${ZONE}" \
    --quiet

# 5. Delete the persistent disk
gcloud compute disks delete "${DISK_NAME}" \
    --zone "${ZONE}" \
    --quiet

if [ $? -ne 0 ]; then
    exit 1
fi

echo "-----------------------------------"
echo "Disk deletion complete!"
