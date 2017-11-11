#!/bin/bash

function seq_tests {
    COUNTER=0
    NB_TEST=$1
    SIZE=$2
    echo "Test sequentiel sur $NB_TEST, taille de $SIZE";
    while [  $COUNTER -lt $NB_TEST ]; do
        ./creer_vecteur --size $SIZE | ./tri_sequentiel -t --quiet;

        let COUNTER=COUNTER+1
    done
}

function thd_tests {
    COUNTER=0
    NB_TEST=$1
    SIZE=$2
    NB_THREADS=$3
    echo "Test paralélisme ($NB_THREADS threads) sur $NB_TEST, taille de $SIZE";
    while [  $COUNTER -lt $NB_TEST ]; do
        ./creer_vecteur --size $SIZE |
            ./tri_threads -t --quiet --parallelism $NB_THREADS;

        let COUNTER=COUNTER+1
    done
}

if [ $# -le 1 ]; then
    echo "Usage : script <nombre tests> <taille tableau> [nombre threads]";
    exit;
elif [ $# -eq 2 ]; then
    seq_tests $1 $2;
elif  [ $# -eq 3 ]; then
    thd_tests $1 $2 $3;
fi
