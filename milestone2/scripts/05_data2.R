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

## Genres over the years
#Percentage of movies over the years
df_year_count <- reshape2::dcast(df_train, release_decade ~ genres, length)
df_year_perc <- df_year_count
df_year_perc[, 2:length(df_year_perc)] <- df_year_perc[, 2:length(df_year_perc)] / rowSums(df_year_perc[, 2:length(df_year_perc)]) * 100
df_year_perc <- reshape2::melt(df_year_perc, id.vars="release_decade")
names(df_year_perc) <- c("release_decade", "genres", "percentage")
df_year_perc <- df_year_perc[!is.na(df_year_perc$release_decade), ]

# Colors
colourCount2 <- length(unique(df_year_perc$genres))
getPalette2 <- colorRampPalette(brewer.pal(12, "Paired"))

# Reorder genres
df_mean <- aggregate(percentage ~ genres, data=df_year_perc, FUN=mean)
ordered_levels <- levels(df_mean$genres)[order(df_mean$percentage, decreasing=FALSE)]
df_year_perc$genres <- factor(df_year_perc$genres, levels=ordered_levels)