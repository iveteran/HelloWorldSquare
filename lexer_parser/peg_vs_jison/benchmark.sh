#!/bin/sh

GENERAGED_SOURCES="JisonCalc.js PegCalc.js"

if [[ ! -f $GENERAGED_SOURCES ]]
then
  echo Generating source...
  ./generate.sh
fi

echo Benchmark...
node index.js

rm $GENERAGED_SOURCES
