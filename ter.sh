#!/bin/bash

LC_NUMERIC="en_US.UTF-8"
TER_DIR=/home/lvapeab/smt/software/ter

if [[ "$#" -ne 4 || ("$1" != "-r" && "$3" != "-r") || ("$1" != "-t" && "$3" != "-t") ]]
then
    >&2 echo "Usage: $0 -r ref -t hyp"
    exit 1
fi

if [[ "$1" == "-r" ]]
then
    REF=$2
    HYP=$4
else
    REF=$4
    HYP=$2
fi

if [[ ! -f $REF ]]
then
    >&2 echo "File "$REF" does not exist"
    exit 1
fi

if [[ ! -f $HYP ]]
then
    >&2 echo "File "$HYP" does not exist"
    exit 1
fi

for (( n = 0; n < $(cat $REF | wc -l); ++n ))
do
    echo '(sentence'$n')'
done > /tmp/aux.ids

paste $REF /tmp/aux.ids > /tmp/aux.ref
paste $HYP /tmp/aux.ids > /tmp/aux.hyp

echo "TER: `tercom.7.25 -s -r /tmp/aux.ref -h /tmp/aux.hyp  | grep TER | awk '{print $3*100}'`"

rm /tmp/aux.ids /tmp/aux.ref /tmp/aux.hyp
