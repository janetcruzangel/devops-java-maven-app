#!/usr/bin/env bash
#Set an ENV variable named IMAGE with the first parameter provided, to le later used by docker-compose.yaml
export IMAGE=$1
docker-compose -f docker-compose.yaml up --detach
echo "success"