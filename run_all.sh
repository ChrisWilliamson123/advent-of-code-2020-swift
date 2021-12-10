#!/bin/bash

for i in $(ls -d */); do
    cd $i
    echo "$i"
    ./run
    cd ..
    printf "\n"
done