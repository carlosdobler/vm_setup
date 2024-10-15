This repo contains scripts to finalize the configuration of a Google virtual machine created from a `risk-img-4ru` image (see [here](image.md) the steps followed to create the image). 

### Steps to finalize configuration:

1. Clone this repo by running `git clone https://github.com/carlosdobler/vm_setup.git` **in the home directory**.
2. Configure git: `bash vm_setup/config_git.sh <id (any)>` (e.g. "cdobler-risk-vm-04")
3. ~Install R packages: `bash vm_setup/config_r_packages.sh`~ (no longer needed under the new image)
4. Configure the persistent disk (format, automatic mount): `bash vm_setup/config_pers_disk.sh`
5. Install and setup cdsapi: `bash vm_setup/config_cdsapi.sh "key: <key>"`.
6. Authenticate yourself with:
  ```
  gcloud auth application-default login
  gcloud auth login
  ```
6. Configure buckets' mount points and alias: `bash vm_setup/config_buckets.sh`. Alias to mount: `mountbuckets`.
7. Create a password to log into RStudio Server: `sudo passwd <username>`

