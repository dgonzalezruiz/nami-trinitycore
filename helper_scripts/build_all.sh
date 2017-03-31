##################################################
#  This script takes care of the whole           #
#  build process of the nami module              #
#  and releases it to github, marking a new tag  #
##################################################

#!/bin/bash -e

## We store the working directory at start so as to be careless about the working directory travisCI sets up
export workingDir=`pwd`

log() {
    echo "$@" >&2
}
## Build environment set up
log "=================================="
log "Setting up building environment..."
. $cwd/helper_scripts/setup_env.sh
log "Building environment set up"
log "=================================="

log "=================================="
log "Performing compilation..."
blacksmith containerized-build trinitycore:$workingDir/trinitycore.tar.gz > /tmp/blacksmith_output
log "Compilation finished"
log "==================================="

## Artifacts tarball is retrieved
artifactsDir=`cat /tmp/blacksmith_output | cut -d: -f2 | grep artifacts`
mv $artifactsDir/*.tar.gz /tmp

## Testing

WIP

## Release

WIP




