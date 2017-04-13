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

log "=================================="
log "Performing compilation..."
#$workingDir/blacksmith/bin/blacksmith --log-level=trace8 containerized-build trinitycore:$workingDir/trinitycore.tar.gz | tee /tmp/blacksmith_output
#mkdir $workingDir/TrinityCore/bin
#cd $workingDir/TrinityCore/bin
#cmake ../ -DCMAKE_INSTALL_PREFIX=/tmp/trinity-core
#make -j 8 -k && make install
log "skipping compilation"
log "Compilation finished"
log "==================================="

## Preparing the module release
releaseFolder=$workingDir/trinitycore-nami
cp -a $workingDir/trinitycore-module $releaseFolder
mkdir -p $releaseFolder/files/trinitycore
mv $workingDir/TDB_full_335* $releaseFolder/files/trinitycore
for i in sql/base sql/updates ; do
  mkdir -p $releaseFolder/files/$i
done
mv $workingDir/TrinityCore/sql/base/*_database.sql $releaseFolder/files/trinitycore/sql/base
mv $workingDir/TrinityCore/sql/updates $releaseFolder/files/trinitycore/sql/updates
rm $releaseFolder/files/README.md
ls -lahrtR $releaseFolder

## Artifacts tarball is retrieved
#artifactsDir=`cat /tmp/blacksmith_output | cut -d: -f2 | grep artifacts | grep tmp`
#artifactsDir=$workingDir/TrinityCore
#cp $artifactsDir/*.tar.gz $workingDir/trinityrelease/files
#cd $workingDir/trinityrelease/files 
#tar xzf $workingDir/trinityrelease/files/*.tar.gz 
#rm $workingDir/trinityrelease/files/*.tar.gz
#sed -i 's/<<version>>/3.3.5/g' $workingDir/trinityrelease/nami.json.tpl
#sed -i 's/<<revision>>/1/g' $workingDir/trinityrelease/nami.json.tpl
## 

## Testing

#WIP

