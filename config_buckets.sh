#!/bin/bash

sudo mkdir /mnt/bucket_cmip5
sudo chmod a+rw /mnt/bucket_cmip5

sudo mkdir /mnt/bucket_cmip6
sudo chmod a+rw /mnt/bucket_cmip6

sudo mkdir /mnt/bucket_mine
sudo chmod a+rw /mnt/bucket_mine

printf '\n# Alias to mount buckets\nalias mountbuckets="gcsfuse cmip5_data --implicit-dirs /mnt/bucket_cmip5;gcsfuse cmip6_data --implicit-dirs /mnt/bucket_cmip6;gcsfuse --implicit-dirs clim_data_reg_useast1 /mnt/bucket_mine"' >> ~/.bashrc
source ~/.bashrc
