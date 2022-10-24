#!/bin/bash

sudo mkdir /mnt/bucket_cmip5
sudo chmod a+rw /mnt/bucket_cmip5
gcsfuse cmip5_data /mnt/bucket_cmip5
