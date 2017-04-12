#!/usr/bin/Rscript
# Purpose:         Milestone 1: EDA Analysis
# Date:            2017-04-03
# Author:          tim.hagmann@gmail.com
# Machine:         SAN-NB0044 | Intel i7-3540M @ 3.00GHz | 16.00 GB RAM
# R Version:       Microsoft R Open 3.3.2 -- "Sincere Pumpkin Patch"
#
# Notes:           Parallelisation requires the "RevoUtilsMath" package (if
#                  necessary, copy it manually into packrat). On Windows install 
#                  RTools in order to build packages.
################################################################################

## Options
options(scipen=10)
update_package <- FALSE
options(java.parameters="-Xmx6g")

## Init files (always execute, eta: 10s)
source("scripts/01_init.R")                   # Helper functions to load packages
source("scripts/02_packages.R")               # Load all necessary packages
source("scripts/03_functions.R")              # Load project specific functions

## Data preparation
df_genre <- read_csv("data/genres_10k_new.txt")
df_companies <- read_csv("data/companies_10k.txt")
df_info <- read_tsv("data/tmdb_movie_info.txt")

## Cleanup companies
#-------------------
# Count number of companies per movie
n_companies <- colSums(df_companies)
n_companies <- n_companies[2:length(df_companies)]

# Select companies with > 30 movies
big_30 <- names(n_companies[n_companies > 30])
df_companies <-  df_companies[, c("tmdb_id", big_30)]

# Create column with small companies
row_sum <- rowSums(df_companies[, 2:length(df_companies)])
df_companies$Small_Companies <- ifelse(row_sum == 0, 1, 0)
df_companies <- reshape2::melt(df_companies, id=1, na.rm=TRUE)
df_companies <- df_companies[df_companies$value > 0, ]
df_companies$value <- NULL

## Cleanup genres
#----------------
# Create column with small companies
df_genre <- reshape2::melt(df_genre, id=1, na.rm=TRUE)
df_genre <- df_genre[df_genre$value > 0, ]
df_genre$value <- NULL

## Inner Join (!!!!We're losing currently roughly 2/3)
#-----------------------------------------------------
df_merge <- merge(df_info, df_genre, by="tmdb_id", all=FALSE)
df_merge <- merge(df_merge, df_companies, by="tmdb_id", all=FALSE)
names(df_merge) <- tolower(names(df_merge))

# refill variables
df_merge$genres <- df_merge$variable.x
df_merge$production_company <- df_merge$variable.y

# Remove empty vars
df_merge$variable.x <- NULL
df_merge$variable.y <- NULL

## 13 Genres --> 13 Models

## Data preparation
# Dates
df_merge$release_date <- as.Date(df_merge$release_date)
df_merge$release_year <- as.character(strftime(df_merge$release_date,"%Y"))
df_merge$release_month <- month.abb[as.numeric(format(df_merge$release_date,"%m"))]
df_merge$release_decade <- as.numeric(df_merge$release_year) - as.numeric(df_merge$release_year) %% 10

rm(df_companies, df_genre, df_info, big_30, n_companies, row_sum)

## Split dataset into test and train 
## (Important before EDA)
set.seed(123)
sample_id <- sample(rownames(df_merge), size=nrow(df_merge) * 0.7, replace=FALSE)
df_merge$partition <- ifelse(rownames(df_merge) %in% sample_id, "train", "test")

# Actual spliting
df_train <- df_merge[df_merge$partition == "train", ]
df_test <- df_merge[df_merge$partition == "test", ]

# Boxplot
beeplot <- function(data, x, y, title="Beeswarm",
                    subtitle="X vs. y",
                    xlab="X-Axis", ylab="Y-Axis"){
  # Select data
  df_tmp <- data[data[, y] > 0 & complete.cases(data[, y]), ]
  df_median <- aggregate(df_tmp[, y] ~ df_tmp[, x], FUN=median)

  # Reorder levels
  ordered_levels <- levels(df_tmp[, x])[order(df_median[, "df_tmp[, y]"], decreasing=TRUE)]
  df_tmp$genres <- factor(df_tmp[, x], levels=ordered_levels)
  df_tmp <- df_tmp[!is.na(df_tmp[, x]), ]
  
  ggplot(data=df_tmp,
         aes_string(x=x, y=y)) + 
    labs(title=title,
         subtitle=subtitle) +
    geom_boxplot(outlier.shape=NA) + 
    geom_beeswarm(color="black", alpha=0.5, size=0.4, priority="density", cex=0.2) + 
    xlab(xlab) + 
    ylab(ylab) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
}

# Budget
beeplot(df_train, "genres", "budget", title="Plot I: Beeswarm",
        subtitle="Pickup count vs. day of the week",
        xlab="Genre", ylab="Budget")

# Revenue
beeplot(df_train, "genres", "revenue", title="Plot I: Beeswarm",
        subtitle="Pickup count vs. day of the week",
        xlab="Genre", ylab="Revenue")

# Rating
beeplot(df_train, "genres", "user_rating", title="Plot I: Beeswarm",
        subtitle="Pickup count vs. day of the week",
        xlab="Genre", ylab="Revenue")

# Runtime
beeplot(df_train, "genres", "runtime", title="Plot I: Beeswarm",
        subtitle="Pickup count vs. day of the week",
        xlab="Genre", ylab="Revenue")

# Popularity
beeplot(df_train[df_train$popularity < 10, ], "genres", "popularity", title="Plot I: Beeswarm",
        subtitle="Pickup count vs. day of the week",
        xlab="Genre", ylab="Revenue")

# Production company vs genre
df_company_count <- reshape2::dcast(df_train, production_company ~ genres, length)
df_company_perc <- df_company_count
df_company_perc[, 2:length(df_company_perc)] <- df_company_count[, 2:length(df_company_count)] / rowSums(df_company_count[, 2:length(df_company_count)]) * 100
df_company_perc <- reshape2::melt(df_company_perc)
names(df_company_perc) <- c("production_company", "genres", "percentage")

# Colors
colourCount <- length(unique(df_company_perc$genres))
getPalette <- colorRampPalette(brewer.pal(12, "Paired"))

# Reorder genres
df_mean <- aggregate(percentage ~ genres, data=df_company_perc, FUN=mean)
ordered_levels <- levels(df_mean$genres)[order(df_mean$percentage, decreasing=FALSE)]
df_company_perc$genres <- factor(df_company_perc$genres, levels=ordered_levels)

# Reorder companies
ordered_levels <- levels(df_company_perc$production_company)[order(df_company_perc[df_company_perc$genres == "Drama", "percentage"])]
df_company_perc$production_company <- factor(df_company_perc$production_company, levels=ordered_levels)

# Actual ploting
ggplot(df_company_perc, aes(x=production_company, y=percentage, fill=genres)) +
  geom_bar(position=position_stack(), stat="identity", width = .7) +
  coord_flip() + 
  theme_bw() +
  geom_text(aes(label=paste0(round(percentage), "%")), 
            position=position_stack(vjust=0.5), size=2) +
  xlab("Production Company") +
  ylab("Percentage") +
  scale_fill_manual(values=getPalette(colourCount))


## Genres over the years
#Percentage of movies over the years
df_year_count <- reshape2::dcast(df_train, release_decade ~ genres, length)
df_year_perc <- df_year_count
df_year_perc[, 2:length(df_year_perc)] <- df_year_perc[, 2:length(df_year_perc)] / rowSums(df_year_perc[, 2:length(df_year_perc)]) * 100
df_year_perc <- reshape2::melt(df_year_perc, id.vars="release_decade")
names(df_year_perc) <- c("release_decade", "genres", "percentage")
df_year_perc <- df_year_perc[!is.na(df_year_perc$release_decade), ]

# Linechart
ggplot(df_year_perc,
       aes(x=release_decade, y=percentage, group=genres, color=genres)) + 
  geom_line() + 
  ylab(label="Percentage") + 
  xlab("Year") +
  theme_bw()

