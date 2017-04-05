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

