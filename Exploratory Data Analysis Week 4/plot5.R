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

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Getting rows that contain motor vehicle related sources
vehicle_source_names <- names(table(scc$EI.Sector))[grep('[vV]ehicle', names(table(scc$EI.Sector)))]

# Getting SCC codes for these sources
scc_codes_vehicle <- filter(scc, EI.Sector %in% vehicle_source_names) %>%
    select(SCC)

# Filtering NEI to get rows with vehicle sources, grouping by year, and summarizing by total emissions.
nei_baltimore_vehicles <- filter(nei, fips == '24510' & SCC %in% scc_codes_vehicle[[1]]) %>%
                          group_by(year) %>%
                          summarize(total_vehicle_emissions = sum(Emissions))

# Plotting using ggplot 2
png('plot5.png')
ggplot(nei_baltimore_vehicles, aes(year, total_vehicle_emissions)) + 
    geom_line() +
    labs(x = 'Year', y = 'Total Vehicle Emissions in Tons', title = expression("PM"[2.5]*" Motor Vehicle Emissions in Baltimore City, Maryland, 1999-2008")) +
    theme(plot.margin = unit(c(1, 1, 1, 1), 'cm'), plot.title = element_text(hjust = 0.5))
dev.off()
