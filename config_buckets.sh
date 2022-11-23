#!/bin/bash

sudo mkdir /mnt/bucket_cmip5
sudo chmod a+rw /mnt/bucket_cmip5

sudo mkdir /mnt/bucket_mine
sudo chmod a+rw /mnt/bucket_mine

printf '\n# Alias to mount buckets\nalias mountbuckets = "gcsfuse cmip5_data /mnt/bucket_cmip5;gcsfuse clim_data_reg_useast1 /mnt/bucket_mine"' >> ~/.bashrc
source ~/.bashrc
