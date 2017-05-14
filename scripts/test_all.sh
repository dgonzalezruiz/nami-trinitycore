##################################################
#  This script takes care of the whole           #
#  build process of the nami module              #
#  and releases it to github, marking a new tag  #
##################################################

#!/bin/bash

set -e

## We store the working directory at start so as to be careless about the working directory travisCI sets up
export TRAVIS_BUILD_DIR=`pwd`

log() {
    echo "$@" >&2
}

tcd() {
  cd $TRAVIS_BUILD_DIR/$1
}

tcd tests

log "=================================="
log "Building Docker images for testing"
cp -a $TRAVIS_BUILD_DIR/trinitycore-nami rootfs/
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
  docker-compose logs --tail="all"
  if [[ $dockerLogs == *"ERROR"* || $dockerLogs == *"error"* ]] ; then
    log "There was an issue in the container execution. Exiting..."
    exit 2
  fi 
else 
  log "You messed up! :)"
  exit 1
fi 
