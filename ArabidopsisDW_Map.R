# Author = Hilary Barker
# This script plots Arabidopsis thaliana dry weight on a world map with circles
# indicating dry weight value (larger the circle, larger the dry weight)

# -----------------------------------------------------------------------------
# Load libraries
# -----------------------------------------------------------------------------
devtools::install_github("dkahle/ggmap")
devtools::install_github("hadley/ggplot2")

library(maps)
library(ggmap)
library(dplyr)


# -----------------------------------------------------------------------------
# Load data
# -----------------------------------------------------------------------------
Data <- read.csv("~/Dropbox/Hils ToDo List/Data Science/ArabidopsisDW/Data.csv")
Origin <- read.csv("~/Dropbox/Hils ToDo List/Data Science/ArabidopsisDW/Origin.csv")

str(Data)
str(Origin)

Origin <- cbind.data.frame(Origin$Accession, Origin$longitude, Origin$latitude)
names(Origin) <- c("Accession", "longitude", "latitude")

# -----------------------------------------------------------------------------
# Avg plant data by accession and combine with GPS coordinates
# -----------------------------------------------------------------------------
AvgData <- Data %>% group_by(Accession) %>% summarise_each(funs(mean)) # Get plant data averaged by accession
str(AvgData)
hist(AvgData$DW.per.plant..g.)

AvgData2 <- cbind.data.frame(AvgData$Accession, AvgData$DW.per.plant..g.)
names(AvgData2) <- c("Accession", "DW_plant")

All <- merge(AvgData2, Origin, by.x = "Accession", by.y = "Accession") # merge dataframes
str(All)
View(All)
is.na(All)
All$DW_plant <- All$DW_plant*100000

# -----------------------------------------------------------------------------
# Get a world map and plot the plant dry weight at the accession origins
# -----------------------------------------------------------------------------

map <- get_map(location = c(lon = -5.35, lat = 48.8), zoom = 2, source = "stamen", maptype = "toner", crop = FALSE)
ggmap(map)

mp <- ggmap(map) + geom_point(aes(x = longitude, y = latitude, size = DW_plant),
                                          data = All, alpha = 0.5, color = "darkred")
mp





