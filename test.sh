#!/bin/bash

BEGIN_SIZE=1000

function seq {
    ./creer_vecteur --size $1 | ./tri_sequentiel -t --quiet;
}

function thd {
    ./creer_vecteur --size $1 |
        ./tri_threads -t --quiet --parallelism $2;
}

function main {
    COUNTER=0
    NB_TEST=$1
    SIZE=$BEGIN_SIZE
    MAX_SIZE=$2
    NB_THREADS="$3"
    echo "size;temps;run_id"
    while [ $SIZE -le $MAX_SIZE ]; do
        while [  $COUNTER -lt $NB_TEST ]; do
            if [ -z $NB_THREADS ]; then
                seq $SIZE;
            else
                thd $SIZE $NB_THREADS;
            fi
            let COUNTER=COUNTER+1
            echo ";$COUNTER"
        done
        let SIZE=SIZE*2
        let COUNTER=0
    done

}

if [ $# -le 1 ]; then
    echo "Usage : script <nombre tests> <taille tableau max> [nombre threads]";
    exit;
fi
if [ $2 -lt $BEGIN_SIZE ]; then
    echo "Value is too small.";
    exit;
fi
if [ $# -eq 2 ]; then
    main $1 $2;
elif  [ $# -eq 3 ]; then
    main $1 $2 $3;
fi
