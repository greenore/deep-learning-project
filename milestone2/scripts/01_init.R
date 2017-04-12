#!/usr/bin/Rscript
# Purpose:         Small initialization script
# Date:            2014-11-12
# Author:          Tim Hagmann
# Notes:           WINDOWS: In order to build packages, RTools() should be installed
# R Version:       R version 3.1.1 -- "Sock it to Me"
################################################################################

## Creat Environment
if(any(search() %in% "initEnv")) detach("initEnv")
initEnv <- new.env()

## Library Functions

# Check if a certain variable is defined in the ls, if not, set a value
initEnv$setMissingVar <- function(var_name, value){
  glob_env <- ls(envir = .GlobalEnv)

  if (!var_name %in% glob_env) {
    msg <- "\nManually set the variable '%s' to %s\n"
    message(sprintf(msg, var_name, value))
    assign(var_name, value, envir = .GlobalEnv)
  } else {
    eval(parse(text = var_name))
  }
}

# Function to load libraries
initEnv$loadPackage <- function(required_packages, lib.loc=NULL){
  required_packages <- cutTxt(x=required_packages, identifier="@", cut2="right") # Remove @ dev etc.

  for(i in seq_along(required_packages)){
    library(required_packages[i], character.only=TRUE, lib.loc)
    message(paste0("loaded package: ", required_packages[i]))
  }
}

# Function to detach libraries
initEnv$detachPackage <- function(required_packages){
  for(i in seq_along(required_packages)){
    package_name <- paste0("package:", required_packages[i])
    if(any(search() %in% package_name)){
      suppressWarnings(detach(package_name, unload=TRUE, character.only=TRUE))
      message(paste0("detached package: ", package_name))
      if(any(grepl("packrat", .libPaths()))){Sys.sleep(2)}
    }
  }  
}

# Function to find missing packages
initEnv$findMissingPackages <- function(required_packages){
  required_packages_cut <- cutTxt(x=required_packages, identifier="@", cut2="right") # Remove @ dev etc.
  missing_packages <- required_packages[!(required_packages_cut %in% installed.packages()[ ,"Package"])]
  missing_packages
}

# Function to install and/or load packages from CRAN
initEnv$packagesCRAN <- function(required_packages, update=FALSE, lib.loc=NULL){
  missing_packages <- findMissingPackages(required_packages)

  if(length(missing_packages) > 0 || update){
    if(update){missing_packages <- required_packages} # Base (required)
    detachPackage(missing_packages)
    install.packages(missing_packages)
  }

  loadPackage(required_packages, lib.loc=NULL)
}

# Function to install and/or load missing packages from Bioconductor
initEnv$packagesBioconductor <- function(required_packages, update=FALSE, lib.loc=NULL){
  missing_packages <- findMissingPackages(required_packages)

  if(length(missing_packages) > 0 || update){
    if(update){missing_packages <- required_packages} # Base (required)

    if(Sys.info()["sysname"][[1]] == "Linux"){
      source(pipe(paste("wget -O -", "https://rawgit.com/greenore/initR/master/biocLite.R")))
    } else {
      source("https://rawgit.com/greenore/initR/master/biocLite.R")
    }

    detachPackage(missing_packages)
    biocLite(missing_packages)
  }

  loadPackage(required_packages, lib.loc=NULL)
}

# Function to install and/or load missing packages from Github
initEnv$packagesGithub <- function(required_packages, repo_name, auth_token=NULL,
                           proxy_url=NULL, port=NULL,
                           update=FALSE, lib.loc=NULL){
  packagesCRAN(c("devtools", "RCurl"))

  missing_packages <- findMissingPackages(required_packages)

  if(length(missing_packages) > 0 || update){
    setProxy(proxy_url=proxy_url, port=port)
    full_repo_name <- paste0(repo_name, '/', missing_packages)    # Base (missing)

    if(update) {
      full_repo_name <- paste0(repo_name, '/', required_packages) # Base (required)
    }

    for(i in seq_along(full_repo_name)){
      detachPackage(missing_packages)
      install_github(repo=full_repo_name[i], auth_token=auth_token)
    }
  }

  loadPackage(required_packages, lib.loc=NULL)
}

## Proxy Functions
# Function to ping a server (i.e., does the server exist)
initEnv$pingServer <- function(url, stderr=FALSE, stdout=FALSE, ...){
  vec <- suppressWarnings(system2("ping", url, stderr=stderr, stdout=stdout, ...))
  if (vec == 0){TRUE} else {FALSE}
}

# Function to set a proxy
initEnv$setProxy <- function(proxy_url, port){
  packagesCRAN("httr")

  port <- as.numeric(port)

  if(pingServer(proxy_url)){
    usr <- readline("Username: ")
    pwd <- readline("Password: ")
    cat("\14")

    reset_config()
    set_config(use_proxy(url=proxy_url, port=port, username=usr, password=pwd))
  }
}

## Additional helper functions
# Cut txt to either the left or right of an identifier
initEnv$cutTxt <- function(x, identifier, regex="[[:alnum:]]{1, }", cut2="right"){
  if(cut2=="right"){
    x <- gsub(paste0(identifier, regex), "", x)
  }

  if(cut2=="left"){
    x <- gsub(paste0(regex, identifier), "", x)
  }
  x
}

## Attach environment
attach(initEnv)
rm(initEnv)
