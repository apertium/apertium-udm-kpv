#!/bin/bash
#set -x
function usage() {
    echo Usage: $0 DIR FILE
    echo
    echo DIR is udm-kpv or kpv-udm
    echo FILE should be result of uniq -c
    echo
}
if test $# != 2 ; then
    usage
    exit 1
fi
APEMODE=$1-dgen
INFILE=$2
cat $INFILE |
    sed -e 's/$/ ¤¤./' |
    apertium -d . $APEMODE |\
    sed -e 's/¤.*//' |\
    sed -e 's/^ *\*//' -e 's/ *$//' |\
    tr ' ' '\t' |\
    awk '
BEGIN {COV=0;UNK=0;}
/\t[*@]/ {UNK+=$1;}
/\t[^*@]/ {COV+=$1;}
END {printf("%f %% (%d / %d)\n", 100*COV/(UNK+COV), COV, UNK+COV);}'
