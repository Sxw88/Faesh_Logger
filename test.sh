#!/usr/bin/bash

source faesh_logger.sh

retention_period=$(get_retention_from_conf doesnotexist)

retention_period=$(($retention_period))

if [ $retention_period -lt 100 ]; then
	echo LESS THAN 100
	echo $retention_period
else
	echo MORE THAN 100
	echo $retention_period
fi	
