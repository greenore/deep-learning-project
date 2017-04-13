#!/bin/bash

# System 
#-------

# Add repository
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'

# Upgrade system
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y

# Install ssh-server
sudo apt install openssh-server libssl-dev libxml2-dev -y

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
sudo apt install libxft-dev autoconf automake autotools-dev bzip2-doc cdbs debhelper dh-strip-nondeterminism dh-translations gettext intltool intltool-debian libarchive-zip-perl libasprintf-dev libblas-common libblas-dev libblas3 libbz2-dev libcroco3 libfile-stripnondeterminism-perl libgettextpo-dev libgettextpo0 libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev liblapack-dev liblapack3 liblzma-dev libmail-sendmail-perl libncurses5-dev libpcre16-3 libpcre3-dev libpcre32-3 libpcrecpp0v5 libreadline-dev libreadline6-dev libsys-hostname-long-perl libtinfo-dev libunistring0 m4 po-debconf python-pkg-resources python-scour python-six -y

# Fortran Dependencies
sudo apt install gfortran -y

## Install system management
sudo apt install htop -y

# Install latex
sudo apt install texlive texlive-latex-extra -y

# Install OpenJDK
sudo apt install default-jdk -y

## Git
sudo apt install git -y

# Install MRO
# mkdir -p downloads
# cd downloads
# wget https://mran.microsoft.com/install/mro/3.3.3/microsoft-r-open-3.3.3.tar.gz
# tar -xf microsoft-r-open-3.3.3.tar.gz
# cd microsoft-r-open/
# sudo ./install.sh -a -u

# Install R
sudo apt install r-base r-base-dev -y

## Maybe run the following R command
sudo R CMD javareconf

# Language dependencies
sudo apt install gnustep-base-runtime -y
defaults write org.R-project.R force.LANG en_US.UTF-8

# Cleanup
#--------
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean -y

# RStudio Server
#---------------
sudo apt-get install gdebi-core -y
cd ..
wget https://download2.rstudio.org/rstudio-server-1.0.136-amd64.deb
sudo gdebi rstudio-server-1.0.136-amd64.deb
