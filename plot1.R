# This script takes data of energy consumption and makes an histogram with the
# values of Global active power for the period of time of 2007-02-01 to 
# 2007-02-02

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

# Here i subset the data
power<-subset(power,Date<=end & Date>=ini)

# For some strange reason the data in Watts were about half of the requiered 
# values of the guidance and goal plots, I convert the data into two times the
# actual kW values. 
power$Global_active_power=power$Global_active_power/1000*2

# I open the device to plot a png graph with 480 px for both width and height
# and set the font size in 9. The plot will be saved as "plot1.png" in the current
# directory
png(filename = "plot1.png",width = 480, height = 480, units = "px",pointsize=9)

hist(power$Global_active_power,seq(0,7.5,by=0.5),col="orangered",main="Global Active Power",xlab="Global Active Power (kilowatts)",xlim=c(0,8),xaxt="n")
axis(side=1,at=c(0,2,4,6),labels=c(0,2,4,6))

dev.off()
