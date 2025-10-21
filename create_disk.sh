#!/bin/bash

# --- Usage Function ---
usage() {
    echo "Usage: sudo $0 <disk_type> <disk_size_gb> <mount_point_path>"
    echo "Example: sudo $0 pd-balanced 50 /mnt/data"
    echo "Supported disk types: pd-standard, pd-balanced, pd-ssd, pd-extreme"
    exit 1
}

# --- Check for correct number of arguments ---
if [ "$#" -ne 3 ]; then
    usage
fi

# --- Assign Arguments to Variables ---
DISK_TYPE="$1"
DISK_SIZE_GB="$2"
MOUNT_POINT="$3"
# Generate a predictable disk name from the mount point name
DISK_NAME=$(basename ${MOUNT_POINT})-disk
# Get the VM's simple instance name (not the FQDN)
INSTANCE_NAME=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)

# Get the zone directly from the metadata server
# The output is a full URL, so we use 'awk' to extract just the zone name (e.g., 'us-central1-a')
ZONE=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone | awk -F/ '{print $NF}')

# --- Validation Checks ---
if ! echo "$DISK_SIZE_GB" | grep -Eq '^[0-9]+$'; then
    echo "ERROR: Disk size must be a number."
    exit 1
fi

if [ -z "$ZONE" ] || [ -z "$INSTANCE_NAME" ]; then
    echo "ERROR: Could not determine the VM's zone or instance name."
    echo "Please ensure the script is running on a Google Compute Engine VM with network access to the metadata server (http://metadata.google.internal)."
    exit 1
fi

echo "Starting disk creation and mounting process..."
echo "  Disk Type: ${DISK_TYPE}"
echo "  Size (GB): ${DISK_SIZE_GB}"
echo "  Mount Point: ${MOUNT_POINT}"
echo "  Disk Name: ${DISK_NAME}"
echo "  VM Instance: ${INSTANCE_NAME}"
echo "  Zone: ${ZONE}"
echo "-----------------------------------"

# (1) Create a new persistent disk
gcloud compute disks create "${DISK_NAME}" \
    --size "${DISK_SIZE_GB}GB" \
    --type "${DISK_TYPE}" \
    --zone "${ZONE}" \
    --quiet

if [ $? -ne 0 ]; then
    echo "ERROR: Disk creation failed. Exiting."
    exit 1
fi

# (2) Attach the disk to the current instance
gcloud compute instances attach-disk "${INSTANCE_NAME}" \
    --disk "${DISK_NAME}" \
    --zone "${ZONE}" \
    --device-name "${DISK_NAME}" \
    --quiet

# Wait a moment for the kernel to recognize the new disk
sleep 5

# Identify the new device path
DEVICE_PATH="/dev/disk/by-id/google-${DISK_NAME}"

# (3) Format the disk with ext4
sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0 "${DEVICE_PATH}"

# (4) Create the mounting point
sudo mkdir -p "${MOUNT_POINT}"

# Get the UUID of the new filesystem
DISK_UUID=$(sudo blkid -s UUID -o value "${DEVICE_PATH}")

if [ -z "$DISK_UUID" ]; then
    echo "ERROR: Could not get UUID for the new disk. Exiting."
    exit 1
fi

# (5) Add a line to /etc/fstab for automatic mounting
FSTAB_LINE="UUID=${DISK_UUID} ${MOUNT_POINT} ext4 defaults,nofail 0 2"
if ! grep -q "^${FSTAB_LINE}$" /etc/fstab; then
    echo "${FSTAB_LINE}" | sudo tee -a /etc/fstab > /dev/null
else
    echo "  fstab entry already exists."
fi

# Mount all filesystems
sudo mount -a

# (7) Grant write permissions to the current user
CURRENT_USER="${SUDO_USER}"
sudo chown -R "${CURRENT_USER}":"${CURRENT_USER}" "${MOUNT_POINT}"

echo "-----------------------------------"
echo "Disk creation and mounting complete!"
df -h "${MOUNT_POINT}"
