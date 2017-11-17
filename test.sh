#!/bin/bash

echo "Deprecated test."

#NB_TEST=30
#BEGIN_SIZE=10000
#MAX_FIXE_SIZE=100000
#NB_THREAD_FIXE=4
#
#function seq {
#    ./creer_vecteur --size $1 | ./tri_sequentiel -t --quiet;
#}
#
#function thd {
#    ./creer_vecteur --size $1 |
#        ./tri_threads -t --quiet --parallelism $2;
#}
#
#function size_fixe {
#    COUNTER=0
#    SIZE=$BEGIN_SIZE
#    MAX_SIZE=$2
#    NB_THREADS=$NB_THREAD_FIXE
#    INCREMENT=10000
#    echo "size;temps;run_id"
#    while [ $SIZE -le $MAX_SIZE ]; do
#        while [  $COUNTER -lt $NB_TEST ]; do
#            if [ -z $NB_THREADS ]; then
#                seq $SIZE;
#            else
#                thd $SIZE $NB_THREADS;
#            fi
#            let COUNTER=COUNTER+1
#            echo ";$COUNTER"
#        done
#        let SIZE=SIZE+$INCREMENT
#        let COUNTER=0
#    done
#
#    exit 0;
#}
#
#function thd_fixe {
#    COUNTER=0
#    SIZE=$BEGIN_SIZE
#    MAX_SIZE=$MAX_FIXE_SIZE
#    NB_THREADS="$1"
#    INCREMENT=10000
#    echo "size;temps;run_id"
#    while [ $SIZE -le $MAX_SIZE ]; do
#        while [  $COUNTER -lt $NB_TEST ]; do
#            thd $SIZE $NB_THREADS;
#            let COUNTER=COUNTER+1
#            echo ";$COUNTER"
#        done
#        let SIZE=SIZE+$INCREMENT
#        let COUNTER=0
#    done
#
#    exit 0;
#}
#
#if [ $# -le 1 ]; then
#    echo "Usage : script [-t <nb_thread>] [-s <taille_tableau>]";
#    exit;
#fi
#if [ $2 -lt $BEGIN_SIZE ]; then
#    echo "Value is too small.";
#    exit;
#fi
#if [ $# -eq 3 ]; then
#    if [ $1 = "-t" ]; then
#        thd_fixe $2;
#    elif [ $1 = "-s" ]; then
#        size_fixe $2;
#    else
#        echo "Usage : script [-t <nb_thread>] [-s <taille_tableau>]";
#        exit;
#    fi
#fi
