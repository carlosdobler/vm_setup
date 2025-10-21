
# Image changelog

### Version 1.3
Boot disk: Ubuntu Minimal 24.04 LTS x86/64; 10 GB
Other conifurations:
- Project-wide SSH keys blocked: `Advanced options > Security > Block project-wide SSH keys`
- Access scopes: `Set access for each API > Compute Engine: Read Write`
(to ensure `create_disk.sh` and `delete_disk.sh` scripts run)
  
SSH as root (`gcloud compute ssh root@<name_of_instance>`) and run:

```
# R (from: https://github.com/eddelbuettel/r2u)
wget https://raw.githubusercontent.com/eddelbuettel/r2u/refs/heads/master/inst/scripts/add_cranapt_noble.sh;
bash add_cranapt_noble.sh;
rm add_cranapt_noble.sh;

# ubuntugis for spatial libraries
apt install software-properties-common -y --no-install-recommends; # for apt-get-repository
add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable;

# gcsfuse (from: https://cloud.google.com/storage/docs/gcsfuse-install)
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`;
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list;
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc;

# qgis
wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntu-ltr $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/qgis.list > /dev/null

```

Update and install:
```
apt update && apt upgrade -y;
apt -y --no-install-recommends install build-essential gfortran tasksel nano nethogs libudunits2-dev libgdal-dev libgeos-dev libproj-dev libnetcdf-dev git cdo netcdf-bin gdebi-core gcsfuse qgis
```

Install R libraries:
```
Rscript -e 'install.packages(c("tidyverse", "devtools", "tidymodels", "sf", "terra", "stars", "ncmeta", "ncdf4", "cubelyr", "mapview", "tmap", "furrr", "future.apply", "tictoc", "colorspace", "zoo", "patchwork", "PCICt", "reticulate", "mirai", "carrier", "mcptools"))';

Rscript -e 'install.packages("btw", repos = "https://posit-dev.r-universe.dev")'
```

Install uv:
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Install RStudio Server:
```
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.1-401-amd64.deb;
sudo gdebi rstudio-server-2025.09.1-401-amd64.deb;
rm rstudio-server-2025.09.1-401-amd64.deb
```
-----

### Version 1.2(1)
`config_pers_disk.sh` was replaced by a new pipeline: `create_disk.sh` + `delete_disk.sh` + `config.disk.sh`.  
  
Other configurations:
- Access scopes: `Set access for each API > Compute Engine: Read Write`
(to ensure `create_disk.sh` and `delete_disk.sh` scripts run)

### Version 1.2(0)
Boot disk: Ubuntu Minimal 24.04 LTS x86/64; 10 GB
Other conifurations:
- Project-wide SSH keys blocked: `Advanced options > Security > Block project-wide SSH keys`

SSH as root (`gcloud compute ssh root@<name_of_instance>`) and run:

```
# R (from: https://github.com/eddelbuettel/r2u)
wget https://raw.githubusercontent.com/eddelbuettel/r2u/refs/heads/master/inst/scripts/add_cranapt_noble.sh;
bash add_cranapt_noble.sh;
rm add_cranapt_noble.sh;

# ubuntugis for spatial libraries
apt install software-properties-common -y --no-install-recommends; # for apt-get-repository
add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable;

# gcsfuse (from: https://cloud.google.com/storage/docs/gcsfuse-install)
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`;
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list;
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc;

# qgis
wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntu-ltr $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/qgis.list > /dev/null

```

Update and install:
```
apt update && apt upgrade -y;
apt -y --no-install-recommends install build-essential gfortran tasksel nano nethogs libudunits2-dev libgdal-dev libgeos-dev libproj-dev libnetcdf-dev git cdo netcdf-bin r-cran-tidyverse r-cran-devtools r-cran-tidymodels gdebi-core gcsfuse qgis

```

Start R and run:
```
install.packages(c("sf", "terra", "stars", "ncmeta", "ncdf4", "cubelyr", "mapview", "tmap", "furrr", "future.apply", "tictoc", "colorspace", "zoo", "patchwork", "PCICt", "reticulate"))
```
Exit R

Install RStudio:
```
wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.12.1-563-amd64.deb;
sudo gdebi rstudio-server-2024.12.1-563-amd64.deb;
rm rstudio-server-2024.12.1-563-amd64.deb
```
To avoid being logged-off when idle for more than 60 min, run `nano /etc/rstudio/rserver.conf` and add these lines to the file:
```
auth-timeout-minutes=0
auth-stay-signed-in-days=30
```

-----

### Version 1.1
Boot disk: Ubuntu 22.04 LTS x86/64; 10 GB
Other configurations:
- Project-wide SSH keys blocked: `Advanced options > Security > Block project-wide SSH keys`

SSH as root (`gcloud compute ssh root@<name_of_instance>`) and run:
```
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable # spatial libraries

wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc # R
sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

sudo add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+ # additional R binaries

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s` # gcsfuse: https://cloud.google.com/storage/docs/gcsfuse-install
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
To avoid being logged-off when idle for more than 60 min, run `sudo nano /etc/rstudio/rserver.conf` and add these lines to the file:
```
auth-timeout-minutes=0
auth-stay-signed-in-days=30
```
