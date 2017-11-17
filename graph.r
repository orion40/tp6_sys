library(ggplot2)
library(plyr)
library(reshape2)

gettime_var_table_file="varying_size.csv"
gettime_var_thd_file="varying_thd.csv"
rusage_var_table_file="vsize_rusage.csv"
rusage_var_thd_file="vthd_rusage.csv"

draw_gettime_varying_size <- function(){
    data_size<- data.frame(read.csv2(file=gettime_var_table_file,sep=';', dec='.'));
    stat_size<-ddply(data_size,c("size"),summarise,N=length(temps),
                     mean=mean(temps))
    gettime_var_table <- ggplot();
    gettime_var_table <- gettime_var_table +
        geom_point(data=stat_size, group=1,
                   aes(x=size, y=mean, colour = "Taille des tableaux")) +
geom_line(data=stat_size, aes(x=size, y=mean, colour = "Taille des tableaux"));

    gettime_var_table <- gettime_var_table + xlab("Taille des tableaux")
    gettime_var_table <- gettime_var_table + ylab("Temps de calcul (s)")

    gettime_var_table <-  gettime_var_table +
        theme(panel.background = element_rect(fill = "lightgrey"),
              panel.grid.minor = element_line(colour = "black",
                                              linetype="dashed", size = 0.1),
              panel.grid.major = element_line(colour = "black", size = 0.1),
              legend.position="bottom")

    cols_table <- c("Taille des tableaux"="red")
    gettime_var_table <- gettime_var_table +
        scale_colour_manual("", values = cols_table)
    gettime_var_table <- gettime_var_table +
        ggtitle("Variation du temps de calcul sur 4 threads")

    gettime_var_table
}

draw_gettime_varying_thds <- function(){
    data_thd<- data.frame(read.csv2(file=gettime_var_thd_file,sep=';', dec='.'));
    stat_thd<-ddply(data_thd,c("nb_thread"),
                    summarise,N=length(temps),mean=mean(temps))
    gettime_var_thd <- ggplot();
    gettime_var_thd <- gettime_var_thd +
        geom_point(data=stat_thd, group=1,
                   aes(x=nb_thread, y=mean, colour = "Nombre de thread")) +
    geom_line(data=stat_thd, aes(x=nb_thread, y=mean, colour = "Nombre de thread"));

    gettime_var_thd <- gettime_var_thd + xlab("Nombre de thread")
    gettime_var_thd <- gettime_var_thd + ylab("Temps de calcul (s)")

    gettime_var_thd <-  gettime_var_thd +
        theme(panel.background = element_rect(fill = "lightgrey"),
              panel.grid.minor = element_line(colour = "black",
                                              linetype="dashed", size = 0.1),
              panel.grid.major = element_line(colour = "black", size = 0.1),
              legend.position="bottom")

    cols_threads <- c("Nombre de thread"="red")
    gettime_var_thd <- gettime_var_thd +
        scale_colour_manual("", values = cols_threads)

    gettime_var_thd <- gettime_var_thd +
        ggtitle("Variation du temps de calcul sur 100000 éléments")

    gettime_var_thd
}

draw_getrusage_size <- function(){
    rusage_size<- data.frame(read.csv2(file=rusage_var_table_file,
                                       sep=';', dec='.'));
    stat_rusage_size<-ddply(rusage_size,c("size"),summarise,
                            N=length(temps),mean=mean(temps))
    rusage_var_table <- ggplot();

    rusage_var_table <- rusage_var_table +
        geom_point(data=stat_rusage_size, group=1,
                   aes(x=size, y=mean, colour = "Nombre de thread")) +
    geom_line(data=stat_rusage_size, aes(x=size, y=mean, colour = "Nombre de thread"));
    rusage_var_table <- rusage_var_table + xlab("Nombre de thread")
    rusage_var_table <- rusage_var_table + ylab("Temps de calcul (s)")

    rusage_var_table <-  rusage_var_table +
        theme(panel.background = element_rect(fill = "lightgrey"),
              panel.grid.minor = element_line(colour = "black",
                                              linetype="dashed", size = 0.1),
              panel.grid.major = element_line(colour = "black", size = 0.1),
              legend.position="bottom")

    cols_threads <- c("Nombre de thread"="red")
    rusage_var_table <- rusage_var_table +
        scale_colour_manual("", values = cols_threads)

    rusage_var_table <- rusage_var_table +
        ggtitle("Variation du temps total de calcul sur 100000 éléments")

    rusage_var_table
}

draw_getrusage_thds <- function(){
    rusage_thd<- data.frame(read.csv2(file=rusage_var_thd_file,sep=';', dec='.'));
    stat_rusage_thd<-ddply(rusage_thd,c("nb_thread"),summarise,
                           N=length(temps),mean=mean(temps))
    rusage_var_thd <- ggplot();

    rusage_var_thd <- rusage_var_thd +
        geom_point(data=stat_rusage_thd, group=1,
                   aes(x=nb_thread, y=mean, colour = "Nombre de thread")) +
    geom_line(data=stat_rusage_thd, aes(x=nb_thread, y=mean, colour = "Nombre de thread"));
    rusage_var_thd <- rusage_var_thd + xlab("Nombre de thread")
    rusage_var_thd <- rusage_var_thd + ylab("Temps de calcul (s)")

    rusage_var_thd <-  rusage_var_thd +
        theme(panel.background = element_rect(fill = "lightgrey"),
              panel.grid.minor = element_line(colour = "black",
                                              linetype="dashed", size = 0.1),
              panel.grid.major = element_line(colour = "black", size = 0.1),
              legend.position="bottom")

    cols_threads <- c("Nombre de thread"="red")
    rusage_var_thd <- rusage_var_thd +
        scale_colour_manual("", values = cols_threads)

    rusage_var_thd <- rusage_var_thd +
        ggtitle("Variation du temps de calcul sur 100000 éléments")


    rusage_var_thd
}

draw_gettime_varying_size()
draw_gettime_varying_thds()

draw_getrusage_size()
draw_getrusage_thds()
