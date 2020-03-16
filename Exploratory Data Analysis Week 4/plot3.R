# Loading required libraries
library(dplyr)
library(ggplot2)

# Downloading Data
if(!dir.exists('data')) dir.create('data')
if(!file.exists('data/data.zip')){
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip', 'data/data.zip')
    unzip('data/data.zip', exdir = 'data')
}

# Reading in data
nei <- readRDS("data/summarySCC_PM25.rds") # NEI - National Emissions Inventory
scc <- readRDS("data/Source_Classification_Code.rds") # Source Classification Code

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

# Filtering by FIPS, grouping by year and type, and summarizing by total emissions
nei_by_type <- filter(nei, fips == '24510') %>% 
               group_by(type, year) %>%
               summarize(total_emissions = sum(Emissions))

# Plotting using ggplot2
png('plot3.png')
ggplot(nei_by_type, aes(year, total_emissions)) + 
    geom_line(aes(color = type), lwd = 1.25) +
    labs(title = expression("PM"[2.5]*" Emissions in Baltimore City, Maryland, 1999-2008")) +
    labs(x = 'Year', y = 'Total Emissions in Tons') +
    theme(plot.margin = unit(c(1, 1, 1, 1), 'cm'), plot.title = element_text(hjust = 0.5))
dev.off()
