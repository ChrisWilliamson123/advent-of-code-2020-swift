#!/bin/bash

if ../compile.sh; then
    if [[ -n $1 ]]; then
        ./main test
    else
        ./main
    fi
fi
