##################################################
#  This script takes care of the whole           #
#  build process of the nami module              #
#  and releases it to github, marking a new tag  #
##################################################

#!/bin/bash

set -e

## We store the working directory at start so as to be careless about the working directory travisCI sets up
export workingDir=`pwd`

log() {
    echo "$@" >&2
}

cd tests

log "=================================="
log "Building Docker images for testing"
cp -a $workingDir/trinitycore-nami rootfs/
docker-compose build
log "=================================="
log "=================================="
log "Launching Containers...           "
docker-compose up -d
log "=================================="
log "Going to sleep for three minutes...    "
sleep 180
log "=================================="
log "Checking whether the build errored"
log "=================================="
if [ `docker ps | wc -l` -le 3 ] ; then
  log "Containers still running"
  dockerLogs=$(docker-compose logs --tail="all")
  echo $dockerLogs
  if [ $dockerLogs == *"ERROR"* ||  $dockerLogs == *"error"* ] ; then
    log "There was an issue in the container execution. Exiting..."
    exit 2
  fi 
else 
  log "You messed up! :)"
  exit 1
fi 
