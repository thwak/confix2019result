#!/bin/sh
if [ "$#" -ne 1 ] || ! [ -d "$1" ]; then
  echo "Usage: $0 DIRECTORY" >&2
  exit 1
fi
CDIR=$(pwd)
DIR=$1
PROP="confix.properties"
echo "Create confix.properties for $1"
cp $PROP.sample $1/$PROP
cd $1

#Export properties
value=$(defects4j export -p dir.src.classes)
echo "src.dir=$value" >> $PROP
value=$(defects4j export -p dir.bin.classes)
echo "target.dir=$value" >> $PROP
value=$(defects4j export -p dir.src.tests)
echo "test.dir=$value" >> $PROP
value=$(defects4j export -p cp.compile)
echo "cp.compile=$value" >> $PROP
value=$(defects4j export -p cp.test)
echo "cp.test=$value" >> $PROP

#Create test lists
defects4j export -p tests.all > tests.all
defects4j export -p tests.relevant > tests.relevant
defects4j export -p tests.trigger > tests.trigger

cd $CDIR
