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

echo "Starting disk deletion and unmounting process..."
echo "  Mount Point: ${MOUNT_POINT}"
echo "  Expected Disk Name: ${DISK_NAME}"
echo "  VM Instance: ${INSTANCE_NAME}"
echo "  Zone: ${ZONE}"
echo "-----------------------------------"

# 1. Unmount the disk
if mountpoint -q "${MOUNT_POINT}"; then
    echo "1. Unmounting disk at '${MOUNT_POINT}'..."
    sudo umount "${MOUNT_POINT}"
    if [ $? -ne 0 ]; then
        echo "ERROR: Unmounting failed. Ensure no processes are using the mount point. Exiting."
        exit 1
    fi
else
    echo "1. Disk is not currently mounted at '${MOUNT_POINT}'. Skipping unmount."
fi

# 2. Remove the entry from /etc/fstab
echo "2. Removing entry from /etc/fstab..."
# Escape the path for sed to handle slashes correctly
ESCAPED_MOUNT_POINT=$(echo "${MOUNT_POINT}" | sed 's/\//\\\//g')
sudo sed -i.bak "/${ESCAPED_MOUNT_POINT}/d" /etc/fstab
if [ $? -eq 0 ]; then
    echo "  fstab entry removed. Backup created at /etc/fstab.bak"
else
    echo "  WARNING: Failed to remove fstab entry."
fi

# 3. Delete the mounting point directory
echo "3. Deleting mount point directory '${MOUNT_POINT}'..."
if [ -d "${MOUNT_POINT}" ]; then
    sudo rm -rf "${MOUNT_POINT}"
    echo "  Directory deleted."
else
    echo "  Directory does not exist. Skipping."
fi

# 4. Detach the disk from the current instance
echo "4. Detaching disk '${DISK_NAME}' from the current VM instance '${INSTANCE_NAME}'..."
gcloud compute instances detach-disk "${INSTANCE_NAME}" \
    --disk "${DISK_NAME}" \
    --zone "${ZONE}" \
    --quiet

# 5. Delete the persistent disk
echo "5. Deleting persistent disk '${DISK_NAME}'..."
gcloud compute disks delete "${DISK_NAME}" \
    --zone "${ZONE}" \
    --quiet

if [ $? -ne 0 ]; then
    echo "ERROR: Disk deletion failed. You may need to delete it manually via gcloud or the GCP console."
    exit 1
fi

echo "-----------------------------------"
echo "✅ Disk deletion and cleanup complete!"
