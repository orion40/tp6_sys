library(ggplot2)
library(plyr)
library(reshape2)

data_size<- data.frame(read.csv2(file="varying_size.csv",sep=';', dec='.'));
data_thd<- data.frame(read.csv2(file="varying_thd.csv",sep=';', dec='.'));

stat_size<-ddply(data_size,c("size"),summarise,N=length(temps),mean=mean(temps))
stat_thd<-ddply(data_thd,c("num_thread"),summarise,N=length(temps),mean=mean(temps))
p <- ggplot();
q <- ggplot();

p <- p + geom_point(data=stat_size, group=1, aes(x=size, y=mean, colour = "Taille des tableaux")) + geom_line(data=stat_size, aes(x=size, y=mean, colour = "Taille des tableaux"));
q <- q + geom_point(data=stat_thd, group=1, aes(x=num_thread, y=mean, colour = "Nombre de thread")) + geom_line(data=stat_thd, aes(x=num_thread, y=mean, colour = "Nombre de thread"));

p <- p + xlab("Taille des tableaux")
p <- p + ylab("Temps de calcul (µs)")

p <-  p + theme(panel.background = element_rect(fill = "lightgrey"),
                panel.grid.minor = element_line(colour = "black",
                linetype="dashed", size = 0.1),
                panel.grid.major = element_line(colour = "black", size = 0.1),
                legend.position="bottom")

cols_table <- c("Taille des tableaux"="red")
p <- p + scale_colour_manual("",
                             values = cols_table)
p <- p + ggtitle("Variation du temps de calcul sur 4 threads")

q <- q + xlab("Nombre de thread")
q <- q + ylab("Temps de calcul (µs)")

q <-  q + theme(panel.background = element_rect(fill = "lightgrey"),
                panel.grid.minor = element_line(colour = "black",
                linetype="dashed", size = 0.1),
                panel.grid.major = element_line(colour = "black", size = 0.1),
                legend.position="bottom")

cols_threads <- c("Nombre de thread"="red")
q <- q + scale_colour_manual("",
                             values = cols_threads)

q <- q + ggtitle("Variation du temps de calcul sur 100000 éléments")

# p <- p + scale_colour_manual("", 
#                              values = cols)
# 
# p <-  p + theme(panel.background = element_rect(fill = "lightgrey"),
#                 panel.grid.minor = element_line(colour = "black", linetype="dashed", size = 0.1),
#                 panel.grid.major = element_line(colour = "black", size = 0.1),
#                 legend.position="bottom")

p
q
# stat_naif<-ddply(data_para_naif,c("Taille_mat"),summarise,N=length(Time),mean=mean(Time),sd=sd(Time),se=1.96*(sd/sqrt(N)))

# script R permettant de comparer les temps moyens de calcul des produits
# de matrices carrées entre algo classique et algo transposée
# pour des tailles variant de 2000 à 5000

# analyse statistique

# stat_naif<-ddply(data_para_naif,c("Taille_mat"),summarise,N=length(Time),mean=mean(Time),sd=sd(Time),se=1.96*(sd/sqrt(N)))

# tracé des résultats obtenus
# p <- ggplot()
# p <- p + geom_point(data=stat_naif, aes(x=Taille_mat, y=mean, colour = "algorithme naïf")) + geom_line(data=stat_naif, aes(x=Taille_mat, y=mean, colour = "algorithme naïf")) 
# p <- p + geom_errorbar(data=stat_naif,aes(x=Taille_mat,ymin=mean-se,ymax=mean+se),width=.2,position=position_dodge())
# 
# 
# p <- p + xlab("Taille des matrices")
# p <- p + ylab("Temps de calcul (s)")
# 
# cols <- c("algorithme naïf"="red","algorithme transposée"="blue")
# p <- p + scale_colour_manual("", 
#                              values = cols)
# 
# p <-  p + theme(panel.background = element_rect(fill = "lightgrey"),
#                 panel.grid.minor = element_line(colour = "black", linetype="dashed", size = 0.1),
#                 panel.grid.major = element_line(colour = "black", size = 0.1),
#                 legend.position="bottom")
#show(p)
