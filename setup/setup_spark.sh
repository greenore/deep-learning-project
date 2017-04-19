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

# Java 8
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer -y
sudo apt-get install oracle-java8-set-default -y

# Spark
mkdir -p downloads
cd downloads
sudo wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
tar -xvzf spark-2.1.0-bin-hadoop2.7.tgz
cd spark-2.1.0-bin-hadoop2.7

# Create and launch AMI

# Start the Master node


# Start Slave node
sudo bash spark-2.1.0-bin-hadoop2.7/sbin/start-slave.sh spark://spark-2.1.0-bin-hadoop2.7:7077


# Cleanup
#--------
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean -y
