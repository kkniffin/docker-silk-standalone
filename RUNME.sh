#!/bin/bash

# Load Overrides File for overwriting Environment Variables in this file
# This will allow git pulls as they will overwrite this file, but not the overrides.env
if ! [ -f ./overrides.env ]; then
	touch ./overrides.env
fi
. ./overrides.env

# Set Variables
#export ES_SERVER1="${ES_SERVER1:-1.1.1.1}"
#export ES_SERVER2="${ES_SERVER2:-1.1.1.1}"
export FLUENTD_SERVER="${FLUENTD_SERVER:-1.1.1.1}"
export DOCKER_DATA="${DOCKER_DATA:-/opt/docker_data}"
export DOCKER_CONFIG="${DOCKER_CONFIG:-/opt/docker_config}"
docker-compose "$@"
