
# Image

### Version 1.1
Boot disk: Ubuntu 22.04 LTS x86/64; 10 GB  
Project-wide SSH keys blocked: `Advanced options > Security > Block project-wide SSH keys`

SSH as root and run:
```
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable # spatial libraries

wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc # R
sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

sudo add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+ # additional R binaries

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s` # gcsfuse
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc
```

Update and install:
```
sudo apt update
sudo apt -y --no-install-recommends install software-properties-common build-essential gfortran wget tasksel nano nethogs libudunits2-dev libgdal-dev libgeos-dev libproj-dev libnetcdf-dev git qgis cdo netcdf-bin dirmngr r-base r-cran-tidyverse r-cran-devtools r-cran-tidymodels gdebi-core gcsfuse
```

Start R and run:
```
install.packages(c("sf", "terra", "stars", "ncmeta", "ncdf4", "cubelyr", "mapview", "tmap", "furrr", "future.apply", "tictoc", "colorspace", "zoo", "patchwork", "PCICt", "reticulate"))
```
Exit R

Install RStudio:
```
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.09.0-375-amd64.deb
sudo gdebi rstudio-server-2024.09.0-375-amd64.deb
rm rstudio-server-2024.09.0-375-amd64.deb
```

gcsfuse https://cloud.google.com/storage/docs/gcsfuse-install
