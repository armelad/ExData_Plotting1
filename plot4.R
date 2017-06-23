#load library for quick load of the csv data
library(readr)

if (!file.exists("data.zip")) {
        #assign the location of the file
        fileUrl <-
                "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        # download the file
        download.file(fileUrl, destfile = "data.zip", method = "libcurl")
        
        #UNzip the file
        unzip ("data.zip", exdir = ".")
}

#get the current folder
curdir <- getwd()

#get the file name with path
data_file <-
        paste0(curdir, "/", unzip(paste0(curdir, "/", "data.zip"), list = TRUE)[1])

#function that processes the file and subsets the required data
proc_file <- function(filepath) {
        full_df <- read.csv2(filepath)
        result <-
                full_df[full_df$Date %in% c('1/2/2007', '2/2/2007'),]
        return(result)
        
}
working_df <- proc_file(data_file)

#Convert characters to dates and times

working_df$Time <-
        strptime(paste(working_df$Date, working_df$Time), "%d/%m/%Y %H:%M:%S")
#Convert factors to numbers
working_df$Global_active_power <-
        as.numeric(as.character(working_df$Global_active_power))
working_df$Global_reactive_power <-
        as.numeric(as.character(working_df$Global_reactive_power))
working_df$Voltage <- as.numeric(as.character(working_df$Voltage))
working_df$Sub_metering_1 <-
        as.numeric(as.character(working_df$Sub_metering_1))
working_df$Sub_metering_2 <-
        as.numeric(as.character(working_df$Sub_metering_2))
working_df$Sub_metering_3 <-
        as.numeric(as.character(working_df$Sub_metering_3))




# Plot #4
png("plot4.png",
    width = 480,
    height = 480,
    res = 72)
par(mfrow = c(2, 2))
with(working_df, {
        plot(
                Time,
                Global_active_power,
                type = "l",
                xlab = "",
                ylab = "Globa Active Power(kilowatts)"
        )
        plot(Time,
             Voltage,
             type = "l",
             ylab = "Voltage",
             xlab = "datetime")
        plot(Time,
             Sub_metering_1,
             type = "l",
             ylab = "Energy sub metering")
        lines(Time, Sub_metering_2, col = "red")
        lines(Time, Sub_metering_3, col = "blue")
        plot(
                Time,
                Global_reactive_power,
                type = "l",
                xlab = "datetime",
                ylab = "Global reactive power"
        )
})
dev.off()
rm(list=ls()) 