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

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California(fips=="06037"). Which city has seen greater changes over time in motor vehicle emissions?

# Getting rows that contain motor vehicle related sources
vehicle_source_names <- names(table(scc$EI.Sector))[grep('[vV]ehicle', names(table(scc$EI.Sector)))]

# Getting SCC codes for these sources
scc_codes_vehicle <- filter(scc, EI.Sector %in% vehicle_source_names) %>%
    select(SCC)

# Filtering NEI to get rows with vehicle sources, grouping by year, and summarizing by total emissions.
neibc <- filter(nei, (fips == '24510' | fips == '06037') & SCC %in% scc_codes_vehicle[[1]]) %>%
         group_by(year, fips) %>%
         summarize(total_vehicle_emissions = sum(Emissions)) %>%
         rename(county = fips)
        
# Placing FIPS code with country name
neibc[neibc$county == '06037', ]$county <- 'Los Angeles'
neibc[neibc$county== '24510', ]$county<- 'Baltimore City'

# Plotting using ggplot 2
png('plot6.png')
ggplot(neibc, aes(year, total_vehicle_emissions)) + 
    geom_line(aes(color = county), lwd = 1.25) + 
    labs(x = 'Year', y = 'Total Vehicle Emissions in Tons', title = 'Vehicle Emissions in Baltimore City and Los Angeles from 1999-2008') + 
    theme(plot.margin = unit(c(1.5, 1.5, 1.5, 3), 'cm'), plot.title = element_text(hjust = 0.5))
dev.off()
