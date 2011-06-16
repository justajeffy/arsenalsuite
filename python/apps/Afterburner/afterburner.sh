#!/bin/bash

HOST=$1

while read e; do export "$e"; done < <(/drd/software/int/bin/launcher.sh --project hf2 --dept rnd --printEnv farm)

cd /drd/software/int/sys/Afterburner/source/
/usr/bin/python2.5 afterburner.py $HOST
