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

pwd
echo $workingDir
## Build environment set up
log "=================================="
log "Setting up building environment..."
. $workingDir/helper_scripts/setup_env.sh
log "Building environment set up"
log "=================================="

log "=================================="
log "Performing compilation..."
#$workingDir/blacksmith/bin/blacksmith --log-level=trace8 containerized-build trinitycore:$workingDir/trinitycore.tar.gz | tee /tmp/blacksmith_output
mkdir $workingDir/TrinityCore/bin
cd $workingDir/TrinityCore/bin
cmake ../ -DCMAKE_INSTALL_PREFIX=/tmp/trinity-core
make -j 8 -k && make install
ls /tmp/trinity-core
cd $workingDir/TrinityCore
tar czf trinitycore.tar.gz /tmp/trinity-core


log "Compilation finished"
log "==================================="

## Preparing the module release
cp -a $workingDir/trinitycore-module $workingDir/trinityrelease

## Artifacts tarball is retrieved
#artifactsDir=`cat /tmp/blacksmith_output | cut -d: -f2 | grep artifacts | grep tmp`
artifactsDir=$workingDir/TrinityCore
cp $artifactsDir/*.tar.gz $workingDir/trinityrelease/files
cd $workingDir/trinityrelease/files 
tar xzf $workingDir/trinityrelease/files/*.tar.gz 
rm $workingDir/trinityrelease/files/*.tar.gz
sed -i 's/<<version>>/3.3.5/g' $workingDir/trinityrelease/nami.json.tpl
sed -i 's/<<revision>>/1/g' $workingDir/trinityrelease/nami.json.tpl
mv $workingDir/trinityrelease/nami.json.tpl $workingDir/trinityrelease/nami.json
cd $workingDir
tar czf trinitycore-module-3.3.5-r1.tar.gz $workingDir/trinityrelease
## 



## Testing



WIP




