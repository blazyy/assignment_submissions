# Reading Data
if(!file.exists('electric_consumption.zip')){
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 'electric_consumption.zip')
    unzip('electric_consumption.zip')
}

hpc <- read.table('household_power_consumption.txt', nrows = 2075260, stringsAsFactors = FALSE, na.strings = '?', sep = ';', header = TRUE)
hpc$Date <- as.Date(strptime(hpc$Date, format = '%d/%m/%Y', tz = "")) # Converting to date format
hpc <- subset(hpc, Date == '2007-02-01' | Date == '2007-02-02') # Subsetting dates from 2007-02-01 and 2007-02-02

# Plotting
hist(hpc$Global_active_power, col = 'red', xlab = "Global Active Power (kilowatts", ylab = "Frequency", main = "Global Active Power")

# Downloading .png
dev.copy(png, file = "plot1.png") # Default height and width is 480, so not specifying here.
dev.off()
