#!/bin/bash

# Format disk
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb

# Create mounting point
mkdir pers_disk

# Mount disk
sudo mount -o discard,defaults /dev/sdb ~/pers_disk

# Grant write permissions
sudo chmod a+w pers_disk

# Backup fstab file
sudo cp /etc/fstab /etc/fstab.backup

# Add line to fstab file
echo "UUID=$(blkid -s UUID -o value /dev/sdb) pers_disk ext4 discard,defaults,nofail 0 2" | sudo tee -a /etc/fstab
