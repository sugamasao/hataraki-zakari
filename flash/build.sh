#!/bin/sh

FLEX_SDK=/opt/flex/bin
BASE=`dirname ${0}`
NAME=Hataraki-Zakari
# make output dir 
mkdir -p ${BASE}/bin

# execute!
${FLEX_SDK}/mxmlc -output ${BASE}/bin/${NAME}.swf ${BASE}/src/${NAME}.mxml


