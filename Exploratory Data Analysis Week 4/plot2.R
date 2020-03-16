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

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question

# Filtering by FIPS, grouping by year, and the summarizing by total emissions across all years
nei_baltimore <- filter(nei, fips == '24510') %>% 
                 group_by(year) %>% 
                 summarize(total_emissions = sum(Emissions))

# Plotting using base plotting system
png('plot2.png')
par(mar = c(5, 6, 5, 5))
plot(nei_baltimore, type= 'line', xlab = 'Year', ylab = 'Total Emissions in Tons', xaxt = 'n')
title(main = 'Total Emissions in Baltimore City, Maryland from 1999 to 2008')
axis(1, at = c(1999, 2002, 2005, 2008))
dev.off()
