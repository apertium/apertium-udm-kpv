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
APEMODE=$1-debug
INFILE=$2
cat $INFILE |
    apertium -f line -d . $APEMODE |\
    sed -e 's/^ *[*@]\?//' -e 's/ *$//' |\
    sed -e 's/^\([[:digit:]]*\)[^[:space:]]/\1/' |\
    tr ' ' '\t' |\
    awk -F '\t' '
BEGIN {ATS=0;STARS=0;HASH=0;ALL=0}
$2 ~ /^[*]/ {STARS+=$1;}
$2 ~ /^[@]/ {ATS+=$1;}
$2 ~ /^[#]/ {HASH+=$1;}
{ALL+=$1;}
END {
    printf("* %f %% (%d / %d)\n", 100*STARS/ALL, STARS, ALL);
    printf("@ %f %% (%d / %d)\n", 100*ATS/ALL, ATS, ALL);
    printf("# %f %% (%d / %d)\n", 100*HASH/ALL, HASH, ALL);
}'
