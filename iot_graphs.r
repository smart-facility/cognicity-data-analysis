require("RPostgreSQL")
drv <- drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,dbname="cognicity",host="localhost")

max_depth <- c(330,330,330,330)

for (sensor_id in 1:4) {
  df_all <- dbGetQuery(con,paste("SELECT * FROM sensor_data WHERE sensor_id=",toString(sensor_id)," ORDER BY measurement_time;",sep=""))
  metadata <- dbGetQuery(con,paste("SELECT * FROM sensor_metadata where id=",toString(sensor_id),";",sep=""))
  png(filename=paste(toString(sensor_id),"_temperature_unfiltered.png",sep=""),type="quartz",width=1024,height=768)
  par(cex.axis=1.5,cex.lab=1.5,cex.main=1.5)
  plot(df_all$measurement_time,df_all$temperature,ylim=c(0,40),xlab="time",ylab="temperature",col="red")
  dev.off()
  png(filename=paste(toString(sensor_id),"_temperature_filtered.png",sep=""),type="quartz",width=1024,height=768)
  par(cex.axis=1.5,cex.lab=1.5,cex.main=1.5)
  plot(df_all$measurement_time[df_all$temperature !=0],df_all$temperature[df_all$temperature !=0],ylim=c(0,45),xlab="time",ylab="temperature",col="red")
  dev.off()
  png(filename=paste(toString(sensor_id),"_humidity_unfiltered.png",sep=""),type="quartz",width=1024,height=768)
  par(cex.axis=1.5,cex.lab=1.5,cex.main=1.5)
  plot(df_all$measurement_time,df_all$humidity,ylim=c(0,100),xlab="time",ylab="humidityxx",col="blue")
  dev.off()
  png(filename=paste(toString(sensor_id),"_humidity_filtered.png",sep=""),type="quartz",width=1024,height=768)
  par(cex.axis=1.5,cex.lab=1.5,cex.main=1.5)
  plot(df_all$measurement_time[df_all$humidity!=0],df_all$humidity[df_all$humidity!=0],ylim=c(0,100),xlab="time",ylab="humidityxx",col="blue")
  dev.off()
  png(filename=paste(toString(sensor_id),"_depth_unfiltered.png",sep=""),type="quartz",width=1024,height=768)
  par(cex.axis=1.5,cex.lab=1.5,cex.main=1.5)
  plot(df_all$measurement_time,metadata$height_above_riverbed[1]-df_all$distance,xlab="time",ylab="depth",col="forestgreen")
  dev.off()
  df_all_distance_filtered <- dbGetQuery(con,paste("SELECT * FROM sensor_data WHERE sensor_id=",toString(sensor_id)," AND distance < ", toString(max_depth[sensor_id])," ORDER BY measurement_time;",sep=""))
  png(filename=paste(toString(sensor_id),"_depth_filtered.png",sep=""),type="quartz",width=1024,height=768)
  par(cex.axis=1.5,cex.lab=1.5,cex.main=1.5)
  plot(df_all_distance_filtered$measurement_time,metadata$height_above_riverbed[1]-df_all_distance_filtered$distance,xlab="time",ylab="depth",col="forestgreen")
  dev.off()
}
