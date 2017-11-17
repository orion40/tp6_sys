#!/bin/bash

# VARIABLE GLOBAL
NB_TEST=30
BEGIN_SIZE=10000
BEGIN_THREAD=1
NB_THREAD_FIXE=4
SIZE_FIXE=1000000


# Appel au fonction Fournis #
function seq {
    ./creer_vecteur --size $1 | ./tri_sequentiel -t -q;
}

function thd {
    ./creer_vecteur --size $1 |
        ./tri_threads -t -q -p $2;
}


# Lancement des teste en fonction des paramètre #
# Taille fixe, nb thread variable
function size_fixe {
    SIZE=$SIZE_FIXE # taille du tableau
    MAX_THREAD=$1 # nombre de thread max
    COUNTER=0 # nombre de teste éfféctuer par parmaètre
    NB_THREADS=$BEGIN_THREAD # nombre de thread de départ
    INCREMENT=1 # incrément du nombre de thread (pas)
    echo "size;temps;num_thread;run_id"
    while [ $NB_THREADS -le $MAX_THREAD ]; do
        while [  $COUNTER -lt $NB_TEST ]; do
            thd $SIZE $NB_THREADS;
            let COUNTER=COUNTER+1
            echo ";$NB_THREADS;$COUNTER"
        done
        let NB_THREADS=$NB_THREADS+$INCREMENT
        let COUNTER=0
    done

    exit 0;
}

# Nb thread fixe, taille variable
function thd_fixe {
    NB_THREADS=$NB_THREAD_FIXE # nombre de thread
    MAX_SIZE=$1 # taille tableau max
    COUNTER=0 # nombre de teste éfféctuer par parmaètre
    SIZE=$BEGIN_SIZE # taille tableau de départ
    INCREMENT=10000 # incrément de la taille tableau (pas)
    echo "size;temps;num_thread;run_id"
    while [ $SIZE -le $MAX_SIZE ]; do
        while [  $COUNTER -lt $NB_TEST ]; do
            thd $SIZE $NB_THREADS;
            let COUNTER=COUNTER+1
            echo ";$NB_THREADS;$COUNTER"
        done
        let SIZE=SIZE+$INCREMENT
        let COUNTER=0
    done

    exit 0;
}

if [ $# -le 1 ]; then
    echo "Usage : script [-t <nb_thread>] [-s <taille_tableau>]";
    exit;
fi
if [ $# -eq 2 ]; then
    if [ $1 = "-t" ]; then
        size_fixe $2;
    elif [ $1 = "-s" ]; then
        thd_fixe $2;
    else
        echo "Usage : script [-t <nb_thread>] [-s <taille_tableau>]";
        exit;
    fi
fi

