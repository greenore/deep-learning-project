#!/bin/bash

# System 
#-------
# Upgrade system
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y

# Install ssh-server
sudo apt install openssh-server -y

# Installs Microsoft Core Fonts (Arial,Times New Roman and  many more)
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install ttf-mscorefonts-installer -y

## Data Science
#---------------
# Curl Dependencies
sudo apt install libcurl4-openssl-dev  -y

# GEOS Dependencies
sudo apt install libgeos-dev -y

# RODBC Dependencies
sudo apt install libiodbc2 libiodbc2-dev -y

# R Dependencies
sudo apt install libxft-dev -y

# Install MRO
mkdir -p downloads
cd downloads
wget https://mran.microsoft.com/install/mro/3.3.3/microsoft-r-open-3.3.3.tar.gz
tar -xf microsoft-r-open-3.3.3.tar.gz
cd microsoft-r-open/
sudo ./install.sh -a -u

## Install system management
sudo apt install htop -y

# Install latex
sudo apt install texlive texlive-latex-extra -y

# Install OpenJDK
sudo apt install default-jdk -y

## Maybe run the following R command
sudo R CMD javareconf

## Git
sudo apt install git -y

# Cleanup
#--------
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean -y

# RStudio Server
sudo apt-get install gdebi-core -y
cd ..
wget https://download2.rstudio.org/rstudio-server-1.0.136-amd64.deb
sudo gdebi rstudio-server-1.0.136-amd64.deb