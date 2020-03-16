# Loading required libraries
library(dplyr)

# Downloading Data
if(!dir.exists('data')) dir.create('data')
if(!file.exists('data/data.zip')){
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip', 'data/data.zip')
    unzip('data/data.zip', exdir = 'data')
}

# Reading in data
nei <- readRDS("data/summarySCC_PM25.rds") # NEI - National Emissions Inventory
scc <- readRDS("data/Source_Classification_Code.rds") # Source Classification Code

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Grouping by year, and summarizing by total emissions across all sources
nei_by_year <- group_by(nei, year) %>% summarize(total_emissions = sum(Emissions))

# Plotting using base plotting system
png('plot1.png')
par(mar = c(5, 6, 5, 4))
plot(nei_by_year, type = 'l', xlab = 'Year', ylab = 'Total Emissions in Tons', xaxt = 'n')
title(main = expression("Total PM"[2.5]*" Emissions in the U.S., 1999-2008"))
axis(1, at = c(1999, 2002, 2005, 2008))
dev.off()
