#!/bin/bash

NB_TEST=30
BEGIN_SIZE=10000
NB_THREAD_FIXE=4
SIZE_FIXE=100000

function seq {
    ./creer_vecteur --size $1 | ./tri_sequentiel -t --quiet;
}

function thd {
    ./creer_vecteur --size $1 |
        ./tri_threads -t --quiet --parallelism $2;
}

# Nb taille fixe, nb thread variable
function size_fixe {
    SIZE=$SIZE_FIXE
    MAX_THREAD=$1
    COUNTER=0
    NB_THREADS=1
    INCREMENT=1
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

# Nb de thread fixe, taille variable
function thd_fixe {
    NB_THREADS=$NB_THREAD_FIXE
    MAX_SIZE=$1
    COUNTER=0
    SIZE=$BEGIN_SIZE
    INCREMENT=10000
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

