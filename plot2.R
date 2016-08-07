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

png("plot2.png", width=480, height=480, units="px")

# Produce plot.
plot(targetData$Date, targetData$Global_active_power,
     pch="",
     ylab="Global Active Power (kilowatts)",
     xlab="")
lines(targetData$Date,targetData$Global_active_power)

dev.off()

# move back to original directory
setwd(oldwd)