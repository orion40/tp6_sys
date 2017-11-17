#!/bin/bash

echo "Deprecated test."

# NB_THREADS=4
#
# function thd_tests {
#     NB_TEST=$1
#     MIN_SIZE=1000
#     MAX_SIZE=1000000
#     OUT_FILE="$2"
#     SIZE=$MIN_SIZE
#
#     echo "size;temps;run_id" > $OUT_FILE;
#     while [ $SIZE -le $MAX_SIZE ]; do
#         COUNTER=0
#         echo -e "Test sur une taille de $SIZE éléments";
#         echo "Test paralélisme ($NB_THREADS threads) sur $NB_TEST";
#         while [ $COUNTER -lt $NB_TEST ]; do
#             ./creer_vecteur --size $SIZE |
#                 ./tri_threads -t --quiet --parallelism $NB_THREADS >> $OUT_FILE;
#             let COUNTER=COUNTER+1
#             echo -n ";$COUNTER" >> $OUT_FILE;
#             if [ $COUNTER -lt $NB_TEST ]; then
#                 echo "" >> $OUT_FILE
#             fi
#         done
#         echo "" >> $OUT_FILE;
#         let SIZE=SIZE*2;
#     done
# }
#
# if  [ $# -eq 2 ]; then
#     thd_tests $1 $2;
# else
#     echo "Usage : script <nombre tests> <fichier sortie>";
#     exit;
# fi
