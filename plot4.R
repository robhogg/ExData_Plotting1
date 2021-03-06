# Get script directory and move into it
oldwd <- getwd()
setwd(script.dir <- dirname(sys.frame(1)$ofile))

filepath = "../data/household_power_consumption.txt"

# Dates for filtering
mindate <- strptime("2007-02-01 00:00:00","%Y-%m-%d %H:%M:%S") 
maxdate <- strptime("2007-02-02 23:59:59","%Y-%m-%d %H:%M:%S")
# Dates in file appear to be in U.K. date format: dd/mm/yyyy
dateformat <- "%d/%m/%Y %H:%M:%S"

readData <- read.csv(filepath,sep=";",stringsAsFactors=FALSE, comment.char="",
                     colClasses=c("character","character",NA,NA,NA,NA,NA,NA,NA))

# Convert date column from text to full DateTime
readData$Date <- as.POSIXlt(sprintf("%s %s",readData$Date,readData$Time),
                                    format = dateformat)

# Extract subset of data
targetData <- readData[readData$Date >= mindate & readData$Date <= maxdate,]

# Free up memory
rm(readData)

png("plot4.png", width=480, height=480, units="px")

# Set layout of device.
par(mfcol=c(2,2))

# Produce plots and annotate.
# Top left
plot(targetData$Date, targetData$Global_active_power,
     pch="",
     ylab="Global Active Power",
     xlab="")
lines(targetData$Date,targetData$Global_active_power)
# Bottom left
plot(targetData$Date, targetData$Sub_metering_1,
     pch="",
     ylab="Energy sub-metering",
     xlab="")
lines(targetData$Date,targetData$Sub_metering_1,col="black")
lines(targetData$Date,targetData$Sub_metering_2,col="red")
lines(targetData$Date,targetData$Sub_metering_3,col="blue")

legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"),lwd=1, bty="n", cex=0.7)
#Top right
plot(targetData$Date, as.numeric(targetData$Voltage),
     pch="",
     ylab="Voltage",
     xlab="datetime")
lines(targetData$Date,targetData$Voltage)
#Bottom right
plot(targetData$Date, targetData$Global_reactive_power,
     pch="",
     ylab="Global Rective Power",
     xlab="datetime")
lines(targetData$Date,targetData$Global_reactive_power)


dev.off()

# move back to original directory
setwd(oldwd)