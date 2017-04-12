## Helper functions
#------------------

# Creat Environment
if (any(search() %in% "projEnvironment")) detach("projEnvironment")
projEnvironment <- new.env()

projEnvironment$beeplot <- function(data, x, y, title="Beeswarm",
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

attach(projEnvironment)
rm(projEnvironment)


