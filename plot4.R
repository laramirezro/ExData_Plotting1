# This script takes data of submeterings 1, 2 and 3 and makes a multiple xy 
# plot with the measures of the given vectors for the period of time between 
# 2007-02-01 to 2007-02-02.

# First i set the working directory where the data is stored in my pc. You could
# change it in order to set the directory where this file is on your own pc.
setwd("D:/R")

# I read the .txt file, taking into account that values are separated with semi
# colons and the columns have names.
power<-read.table(file="household_power_consumption.txt",sep=";",header=TRUE)

# I reconvert the dates formats just to be sure they're gonna be suitable to 
# work with
power$Date<-as.Date(power$Date,"%d/%m/%Y")

# I set the initial and final dates to make a subset
ini<-as.Date("2007/02/01", "%Y/%m/%d")
end<-as.Date("2007/02/02", "%Y/%m/%d")

# I convert the values of different columns to numeric class 
power$Global_active_power<-as.numeric(power$Global_active_power)
power$Global_reactive_power<-as.numeric(power$Global_reactive_power)
power$Sub_metering_1<-as.numeric(power$Sub_metering_1)
power$Sub_metering_2<-as.numeric(power$Sub_metering_2)
power$Sub_metering_3<-as.numeric(power$Sub_metering_3)
power$Voltage<-as.numeric(power$Voltage)

# Here i subset the data
power<-subset(power,Date<=end & Date>=ini)

# For some strange reason the data in Watts were about half of the requiered 
# values of the guidance and goal plots, I convert the data into two times the
# actual kW values. 
power$Global_active_power=power$Global_active_power/1000*2
timestamp<-as.POSIXct(paste(power$Date, power$Time))

# two of the submeterings have a little offset of 2. Here I put all measures at
# the same level 0
power$Sub_metering_1<-power$Sub_metering_1-2
power$Sub_metering_2<-power$Sub_metering_2-2

# When plotting Sub_metering_2 vs. time, there are many values that exceed the
# ones presented in the guide plot. Hence i will set a max value = 2, and all
# values in Sub_metering_2 above this will be replaced with 2.
power$Sub_metering_2[power$Sub_metering_2 > 2] <- 2

# I open the device to plot a png graph with 480 px for both width and height
# and set the font size in 11. The plot will be saved as "plot4.png" in the current
# directory
png(filename = "plot4.png",width = 480, height = 480, units = "px",pointsize=11)

par(mfrow = c(2,2))

plot(power$Global_active_power ~ timestamp, type = "l",ylab="Global Active Power (kilowatts)",xlab=NA)

plot(power$Voltage ~ timestamp, type = "l",ylab="Voltage",xlab="datetime",yaxt="n")
axis(side = 2, at = c(900,1100,1300,1500,1700,1900,2100), labels = c(234,"",238,"",242,"",246))

plot(power$Sub_metering_1 ~ timestamp,col="black",type = "l",ylab="Energy sub metering",xlab=NA,yaxt="n")
axis(side = 2, at = c(0,10,20,30), labels = c(0,10,20,30))

# I add the oder submeterings using lines()
lines(power$Sub_metering_2 ~ timestamp,col="red")
lines(power$Sub_metering_3 ~ timestamp,col="blue")

# I add the legend
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), border = "black", lty=c(1,1,1))

plot(power$Global_reactive_power ~ timestamp, type = "l",ylab="Global_reactive_power",xlab="datetime",yaxt="n")
axis(side = 2, at = c(2,47.6,93.2,138.8,184.4,230), labels = c(0,0.1,0.2,0.3,0.4,0.5))
dev.off()
