#!/bin/sh

CURRENT=`dirname ${0}` 

rascut -s --log=${HOME}/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt ${CURRENT}/src/HatarakiZakari.mxml -c"-load-config+=${CURRENT}/build/HatarakiZakari.xml -define CONFIG::DEBUG true -output ${CURRENT}/bin/HatarakiZakari.swf" -m "${CURRENT}/test=test" -I ${CURRENT}/bin/HatarakiZakari.swf

