# Ruleaza din directorul proiectului: source("setup.R")
if (!file.exists("JobSat.Rmd")) {
  stop("Ruleaza setup.R din directorul care contine JobSat.Rmd.")
}

options(repos = c(CRAN = "https://cloud.r-project.org"))
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

if (file.exists("renv.lock")) {
  # Pastreaza versiunile deja salvate; nu actualiza pachetele automat.
  renv::restore(prompt = FALSE)
} else {
  renv::init(bare = TRUE, restart = FALSE)
  # Lista explicita: incarcarea dinamica din Rmd nu permite detectarea
  # automata a tuturor pachetelor folosite.
  pachete <- c(
    "knitr", "rmarkdown", "RColorBrewer", "scales", "tidyverse",
    "dplyr", "plyr", "ggplot2", "gganimate", "Rmisc", "Hmisc",
    "randomForest", "rattle", "rpart.plot", "caret", "gmodels",
    "PresenceAbsence", "broom", "rlang", "cutpointr", "pROC",
    "ROCR", "ca", "plotROC", "ROSE", "devtools", "rpart",
    "readxl", "ellipsis", "gridExtra", "smotefamily"
  )
  renv::install(pachete)
  renv::settings$snapshot.type("all")
  renv::snapshot(prompt = FALSE)
}

renv::status()
