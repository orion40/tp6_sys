#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <getopt.h>
#include <sys/resource.h>

#include "algo_principal.h"
#include "temps.h"
#include "commun.h"

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

int quiet=0;

void print_rusage(struct rusage ru){
    printf("user CPU time used %d µs\n", ru.ru_utime.tv_usec);
    printf("system CPU time used %d µs\n", ru.ru_stime.tv_usec);
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

int main(int argc, char *argv[]) {
    int opt, parallelism = 1;
    int taille, i, temps = 0, ressources = 0;
    int *tableau;
    char *arg=NULL;

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

    // Time
    struct timeval tv_before_sort, tv_after_sort;
    struct rusage ru_before, ru_after;

    // TODO : tester si les tests influent beaucoup
    if (ressources == 1){
        getrusage(RUSAGE_SELF, &ru_before);
    }
    if (temps == 1){
        if (gettimeofday(&tv_before_sort, NULL) != 0){
            perror("gettimeofday");
        }
    }

    /* Algo */
    algo_principal(parallelism, tableau, taille, arg);

    if (temps == 1){
        if (gettimeofday(&tv_after_sort, NULL) != 0){
            perror("gettimeofday");
        }
        long result = 0;
        // Ajout des secondes au resultat
        result +=
            ((long) tv_after_sort.tv_sec - (long) tv_before_sort.tv_sec)*1000000;
        result += (long) tv_after_sort.tv_usec - (long) tv_before_sort.tv_usec;
        /*
        printf("Temps avant : %ld\nTemps après: %ld\n",
                tv_before_sort.tv_usec, tv_after_sort.tv_usec);
        printf("Le temps de traitement est de %ld µs.\n",
                result
                );
                */

        printf("%ld\n", result);

    }
    if (ressources == 1){
        getrusage(RUSAGE_SELF, &ru_after);
        printf("\n");
        printf("rusage avant calcul :\n");
        print_rusage(ru_before);
        printf("\n");
        printf("rusage après calcul :\n");
        print_rusage(ru_after);
    }

    return 0;
}
