#!/bin/bash

NB_TEST=$1
SIZE=$2
NB_THREADS=$3

COUNTER=0
if [ $# -eq 0 ]; then
    echo "Usage : script <nombre tests> <taille tableau> <nombre threads>";
    exit;
fi

while [  $COUNTER -lt $NB_TEST ]; do
    ./creer_vecteur --size $SIZE | ./tri_threads -t --quiet --parallelism $NB_THREADS;

    let COUNTER=COUNTER+1 
done
