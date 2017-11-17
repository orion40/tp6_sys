#define _GNU_SOURCE

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <getopt.h>
#include <sys/resource.h>
#include <string.h>

#include "algo_principal.h"
#include "temps.h"
#include "commun.h"

int quiet = 0;


/* Affichage du rusage*/
void print_rusage(struct rusage ru){
    printf("user CPU time used %ld s\n", (long)ru.ru_utime.tv_sec);
    printf("user CPU time used %ld µs\n", (long)ru.ru_utime.tv_usec);
    printf("system CPU time used %ld s\n", ru.ru_stime.tv_sec);
    printf("system CPU time used %ld µs\n", ru.ru_stime.tv_usec);
    printf("maximum resident set size %ld\n", ru.ru_maxrss);
    printf("integral shared memory size %ld\n", ru.ru_ixrss);
    printf("integral unshared data size %ld\n", ru.ru_idrss);
    printf("integral unshared stack size %ld\n", ru.ru_isrss);
    printf("page reclaims %ld\n", ru.ru_minflt);
    printf("page faults %ld\n", ru.ru_majflt);
    printf("swaps %ld\n", ru.ru_nswap);
    printf("block input operations %ld\n", ru.ru_inblock);
    printf("block output operations %ld\n", ru.ru_oublock);
    printf("IPC messages sent %ld\n", ru.ru_msgsnd);
    printf("IPC messages received %ld\n", ru.ru_msgrcv);
    printf("signals received %ld\n", ru.ru_nsignals);
    printf("voluntary context switches %ld\n", ru.ru_nvcsw);
    printf("involuntary context switches %ld\n", ru.ru_nivcsw);
}


void usage(char *commande) {
    fprintf(stderr, "Usage :\n");
    fprintf(stderr, "%s [ --parallelism number ] [ --quiet ] [ --time ] "
                    "[ --rusage ] [ --arg argument ] [ --help ]\n\n",
                    commande);
    fprintf(stderr, "Ce programme lit sur son entree standard un vecteur "
                    "a traiter. Il accepte comme options --parallelism qui "
                    "indique le nombre de threads/processus a creer (un seul "
                    "par defaut), --quiet qui supprime les affichages "
                    "superflus, --time qui affiche le temps total passe "
                    "dans l'algorithme principal, --rusage qui affiche "
                    "le temps d'utilisation des resources attribue aux "
                    "differents threads/processus et --arg qui permet de "
                    "transmettre un argument à l'algorithme execute.\n");
    exit(1);
}


/* Récupération rusage timeval */
void get_rusage( struct rusage ru, struct timeval * t){
    if (getrusage(RUSAGE_THREAD, &ru) != 0){
            perror("getrusage");
            exit(1);
    }
    t[0] = ru.ru_utime;
    t[1] = ru.ru_stime;
}


/* Affichage des résultat */
void affiche_rusage(char* s,
                    struct timeval ru_start,
                    struct timeval ru_stop
                    ){

    struct timeval ru_interval;

    /*
       printf("%s start : %ld.%lds\n",
       s, ru_start.tv_sec, ru_start.tv_usec
       );
       printf("%s stop : %ld.%lds\n",
       s, ru_stop.tv_sec, ru_stop.tv_usec
       );
       */

    if(ru_start.tv_usec > ru_stop.tv_usec){
        ru_interval.tv_usec = ru_stop.tv_usec + 10000 - ru_start.tv_usec;
        ru_interval.tv_sec = ru_stop.tv_sec - ru_start.tv_sec - 1;
    }
    else{
        ru_interval.tv_usec = ru_stop.tv_usec - ru_start.tv_usec;
        ru_interval.tv_sec = ru_stop.tv_sec - ru_start.tv_sec;
    }

    /*
       printf("intervalle rusage : %ld.%lds\n",
       ru_interval.tv_sec, ru_interval.tv_usec
       );
       */
    printf("%ld.%06ld;",
            ru_interval.tv_sec, ru_interval.tv_usec
          );
}




int main(int argc, char *argv[]) {
    int opt, parallelism = 1;
    int taille, i, temps = 0, ressources = 0;
    int *tableau;
    char *arg=NULL;

    // Initialisation des variables
    struct timeval t0, t1; // pour gettimeofday
    struct rusage ru; // Récupération rusage
    struct timeval ru_utime_start, ru_stime_start;
    struct timeval ru_utime_stop, ru_stime_stop;
    ru_utime_start.tv_sec = 0;
    ru_utime_start.tv_usec = 0;
    ru_stime_start.tv_sec = 0;
    ru_stime_start.tv_usec = 0;
    ru_utime_stop.tv_sec = 0;
    ru_utime_stop.tv_usec = 0;
    ru_stime_stop.tv_sec = 0;
    ru_stime_stop.tv_usec = 0;
    struct timeval tab_temp[2];

    struct option longopts[] = {
        { "help", required_argument, NULL, 'h' },
        { "parallelism", required_argument, NULL, 'p' },
        { "quiet", no_argument, NULL, 'q' },
        { "time", no_argument, NULL, 't' },
        { "rusage", no_argument, NULL, 'r' },
        { "arg", required_argument, NULL, 'a' },
        { NULL, 0, NULL, 0 }
    };

    while ((opt = getopt_long(argc, argv, "hp:qrta:", longopts, NULL)) != -1) {
        switch (opt) {
            case 'p':
                parallelism = atoi(optarg);
                break;
            case 'q':
                quiet = 1;
                break;
            case 'r':
                ressources = 1;
                break;
            case 't':
                temps = 1;
                break;
            case 'a':
                arg = optarg;
                break;
            case 'h':
            default:
                usage(argv[0]);
        }
    }
    argc -= optind;
    argv += optind;

    affiche("Saisissez la taille du vecteur\n");
    scanf(" %d", &taille);
    tableau = (int *) malloc(taille*sizeof(int));
    if (tableau == NULL) {
        fprintf(stderr,"Erreur de malloc\n");
        exit(3);
    }
    affiche("Saisissez tous les elements du vecteur\n");
    for (i=0; i<taille; i++)
        scanf(" %d", &tableau[i]);


    /* Test PREéxécution */
    if (temps == 1){
        if (gettimeofday(&t0, NULL) != 0){
            perror("gettimeofday");
            exit(1);
        }
    }
    if (ressources == 1){
        // Récupération valeur rusage
        get_rusage(ru, tab_temp);
        ru_utime_start = tab_temp[0];
        ru_stime_start = tab_temp[1];
    }



    /* EXECUTION */
    algo_principal(parallelism, tableau, taille, arg);



    /* Test POSTéxécution */
    if (temps == 1){
        if (gettimeofday(&t1, NULL) != 0){
            perror("gettimeofday");
        }
        long result = 0;
        // Ajout des secondes au resultat
        result +=
            ((long)t1.tv_sec - (long)t0.tv_sec)*1000000;
        result += (long) t1.tv_usec - (long) t0.tv_usec;

        printf("%d;%ld", taille, result);
    }
    if (ressources == 1){
        // Récupération valeur rusage
        get_rusage(ru, tab_temp);
        ru_utime_stop = tab_temp[0];
        ru_stime_stop = tab_temp[1];

        printf("%d;", taille);
        // Affichage valeur
        affiche_rusage("utime",
                ru_utime_start,
                ru_utime_stop
                );
        /*
           affiche_rusage("stime",
           ru_stime_start,
           ru_stime_stop
           );
           */

    }


    return 0;
}


