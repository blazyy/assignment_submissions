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

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Getting rows that contain coal combustion-related sources
coal_sources_names <- names(table(scc$EI.Sector))[grepl('[Cc]oal', names(table(scc$EI.Sector)))]

# Getting the SCC codes for these sources
scc_codes_coal <- filter(scc, EI.Sector %in% coal_sources_names) %>% 
    select(SCC)

# Filtering NEI to get rows with coal sources, grouping by year, and summarizing by total emissions.
nei_coal <- filter(nei, SCC %in% scc_codes_coal[[1]]) %>%
            group_by(year) %>%
            summarize(total_coal_emissions = sum(Emissions))

# Plotting using ggplot 2
png('plot4.png')
ggplot(nei_coal, aes(year, total_emissions)) + 
    geom_line() + 
    labs(x = 'Year', y = 'Total Coal Emissions in Tons', title = 'Coal combustion emissions in the U.S. from 1999-2008') + 
    theme(plot.margin = unit(c(1, 1, 1, 1), 'cm'), plot.title = element_text(hjust = 0.5))
dev.off()
