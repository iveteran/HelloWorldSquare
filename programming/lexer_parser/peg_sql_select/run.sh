#!/bin/sh

GENERATED_SOURCES=sql_select.js

if [[ ! -f $GENERATED_SOURCES ]]
then
  echo Generating source...
  ./generate.sh
fi

echo Run test...
node index.js

rm $GENERATED_SOURCES
