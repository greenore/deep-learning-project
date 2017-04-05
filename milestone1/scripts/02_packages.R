## Set Java path if necessary
if (Sys.info()["sysname"] == "Windows" & Sys.getenv("JAVA_HOME") == "") {
  java_path <- "C:/Program Files (x86)/Java/jre7"
  Sys.setenv(JAVA_HOME=java_path)
  cat(paste("Set Java path to", java_path))
}

## CRAN packages
tidyverse_packages <- c("tidyverse", "stringr")
visualization_packages <- c("RColorBrewer", "pander", "scales",
                            "gridExtra", "ggbeeswarm", "corrplot",
                            "ggfortify", "factoextra")
modelling_packages <- c("e1071", "caret", "MASS")
cluster_packages <- c("cluster", "mclust", "NbClust", "dbscan")

required_packages <- c(tidyverse_packages, visualization_packages, 
                       modelling_packages, cluster_packages)
packagesCRAN(required_packages,
             update=setMissingVar(var_name="update_package",
                                  value=FALSE))

## Clear Workspace
rm(list=ls())
