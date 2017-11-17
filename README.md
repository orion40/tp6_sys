# tp6_sys

Les programmes de tri s'exécutent de la façon suivante :
./programme [ --parallelism number ] [ --quiet ] [ --time ]
        [ --rusage ] [ --arg argument ] [ --csv ][ --help ]

Ce programme lit sur son entree standard un vecteur a traiter. Il accepte comme
options --parallelism qui indique le nombre de threads/processus a creer (un
seul par defaut), --quiet qui supprime les affichages superflus, --time qui
affiche le temps total passe dans l'algorithme principal, --rusage qui affiche
le temps d'utilisation des resources attribue aux differents threads/processus,
--arg qui permet de transmettre un argument à l'algorithme execute, --time qui
affiche le temps exécution, --ressource qui affiche le temps exécution et --csv
qui affiche pour le format csv.

Nous noterons le flag --csv qui permet de controler l'affichage pour une lecture
par un humain, ou pour une sortie destinée à un fichier csv.

Le fichier test.sh fourni des tests de la façon suivante :
./test.sh [[-nt <nb_thread>]||[-s <taille_tableau>]] [ <type_affichage> ];
nb_thread >= 1 (le nombre de thread est variable);
taille_tableau >= 1000000 (la taille du tableau est variable);
type_affichage = -t || -r;

Deux tests sont effectués sur deux cas :
Un tableau de taille fixe (1000000 éléments) et un nombre de thread de 1 à 16
Un tableau de taille variable (jusqu'à 1000000 éléments) et un nombre de thread
fixé à 4.

Les deux tests sont en utilisant la valeur de gettimeofday (soit le temps
complet d'exécution de l'algorithme), puis en utilisant getrusage (soit le
temps passé dans le CPU).

On constate une augmentation quasi-linéaire en fonction de la taille du tableau,
ce qui est prévisible, que ce soit avec gettimeofday ou getrusage.

On constate également que l'ajoute de thread permet d'améliorer l'exécution,
non pas d'une façon aussi flagrante que pourrait laisser penser le graphe, mais
il s'agit tout de même d'une amélioration, en tout cas jusqu'à 4 threads, la
machine de test possédant 4 coeurs physiques.
Au dela, les performances commence à redescendre jusqu'à ce qu'elles soient
inférieure à un programme mono-thread, à des alentours des 10 à 12 threads.
