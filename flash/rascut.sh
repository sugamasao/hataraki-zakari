#!/bin/sh

CURRENT=`dirname ${0}` 

#ruby ${CURRENT}/test/data/server.rb &

rascut -s -v  --log=${HOME}/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt ${CURRENT}/src/HatarakiZakari.mxml -c"-load-config+=${CURRENT}/build/HatarakiZakari.xml -define CONFIG::DEBUG true -output ${CURRENT}/bin/HatarakiZakari.swf" -m "${CURRENT}/test=test" --swf-path ${CURRENT}/bin/HatarakiZakari.swf 


