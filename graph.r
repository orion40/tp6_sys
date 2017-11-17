library(ggplot2)
library(plyr)
library(reshape2)

# obtention des données
data_size<- data.frame(read.csv2(file="varying_size.csv",sep=';', dec='.'));
data_thd<- data.frame(read.csv2(file="varying_thd.csv",sep=';', dec='.'));
rusage_size<- data.frame(read.csv2(file="vsize_rusage.csv",sep=';', dec='.'));
rusage_thd<- data.frame(read.csv2(file="vthd_rusage.csv",sep=';', dec='.'));

stat_size<-ddply(data_size,c("size"),summarise,N=length(temps),mean=mean(temps))
stat_thd<-ddply(data_thd,c("num_thread"),summarise,N=length(temps),mean=mean(temps))
stat_rusage_size<-ddply(rusage_size,c("num_thread"),summarise,N=length(temps),mean=mean(temps))
stat_rusage_thd<-ddply(rusage_thd,c("num_thread"),summarise,N=length(temps),mean=mean(temps))

gettime_var_table <- ggplot();
gettime_var_thd <- ggplot();
rusage_var_table <- ggplot();
rusage_var_thd <- ggplot();

gettime_var_table <- gettime_var_table + geom_point(data=stat_size, group=1, aes(x=size, y=mean, colour = "Taille des tableaux")) + geom_line(data=stat_size, aes(x=size, y=mean, colour = "Taille des tableaux"));
gettime_var_thd <- gettime_var_thd + geom_point(data=stat_thd, group=1, aes(x=num_thread, y=mean, colour = "Nombre de thread")) + geom_line(data=stat_thd, aes(x=num_thread, y=mean, colour = "Nombre de thread"));

gettime_var_table <- gettime_var_table + xlab("Taille des tableaux")
gettime_var_table <- gettime_var_table + ylab("Temps de calcul (µs)")

gettime_var_table <-  gettime_var_table + theme(panel.background = element_rect(fill = "lightgrey"),
                panel.grid.minor = element_line(colour = "black",
                linetype="dashed", size = 0.1),
                panel.grid.major = element_line(colour = "black", size = 0.1),
                legend.position="bottom")

cols_table <- c("Taille des tableaux"="red")
gettime_var_table <- gettime_var_table + scale_colour_manual("",
                             values = cols_table)
gettime_var_table <- gettime_var_table + ggtitle("Variation du temps de calcul sur 4 threads")

gettime_var_thd <- gettime_var_thd + xlab("Nombre de thread")
gettime_var_thd <- gettime_var_thd + ylab("Temps de calcul (µs)")

gettime_var_thd <-  gettime_var_thd + theme(panel.background = element_rect(fill = "lightgrey"),
                panel.grid.minor = element_line(colour = "black",
                linetype="dashed", size = 0.1),
                panel.grid.major = element_line(colour = "black", size = 0.1),
                legend.position="bottom")

cols_threads <- c("Nombre de thread"="red")
gettime_var_thd <- gettime_var_thd + scale_colour_manual("",
                             values = cols_threads)

gettime_var_thd <- gettime_var_thd + ggtitle("Variation du temps de calcul sur 100000 éléments")

gettime_var_table
gettime_var_thd
rusage_var_table
rusage_var_thd
