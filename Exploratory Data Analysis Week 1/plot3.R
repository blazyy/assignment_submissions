# Reading Data
if(!file.exists('electric_consumption.zip')){
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 'electric_consumption.zip')
    unzip('electric_consumption.zip')
}

hpc <- read.table('household_power_consumption.txt', nrows = 2075260, stringsAsFactors = FALSE, na.strings = '?', sep = ';', header = TRUE)
hpc$Date <- as.Date(strptime(hpc$Date, format = '%d/%m/%Y', tz = "")) # Converting to date format
hpc <- subset(hpc, Date == '2007-02-01' | Date == '2007-02-02') # Subsetting dates from 2007-02-01 and 2007-02-02

# Plotting 
# Explicitly setting the graphics device since dev.copy() had problems with the labels getting cut off.
png('plot3.png')
plot(hpc$Sub_metering_1, type = 'line', xaxt = 'n', ylab = 'Energy sub metering', xlab = '')
lines(hpc$Sub_metering_2, type = 'line', col = 'red')
lines(hpc$Sub_metering_3, type = 'line', col = 'blue')
legend("topright", legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lty = 1)
axis(1, at = c(quantile(1:nrow(hpc), 0), quantile(1:nrow(hpc), 0.50), quantile(1:nrow(hpc), 1.00)), labels = c("Thu", "Fri", "Sat")) # Using quantile function to mark weekday at equidistanct points
dev.off()


