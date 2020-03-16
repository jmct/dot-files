#!/bin/bash
#
# Author: JMCT
#

set -e
set -C

export ROOT_REPO="$PWD"
OUTPUT_TAR=$ROOT_REPO/$2

echo "> Archive the root repo"
git archive --prefix $1/  --format "tar" -o $OUTPUT_TAR HEAD

mkdir $ROOT_REPO/subs/

echo "> Archiving each submodule"
git submodule foreach --recursive \
  'echo "$name";\
   echo "$path";\
   git archive --verbose --prefix=$1/$path/ --format tar HEAD --output $ROOT_REPO/subs/$name-$sha1.tar'

if [[ $(ls subs/*.tar | wc -l) != 0  ]]; then
  # combine all archives into one tar
  echo "> combining all tars"
  tar --concatenate --file $OUTPUT_TAR subs/*.tar

  # remove sub tars
  echo "> removing all sub tars"
  rm -rf subs
fi
