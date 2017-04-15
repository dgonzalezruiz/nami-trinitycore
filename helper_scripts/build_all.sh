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
mkdir $workingDir/TrinityCore/bin
cd $workingDir/TrinityCore/bin
cmake ../ -DCMAKE_INSTALL_PREFIX=/tmp/trinitycore
make -j $((`nproc --all` - 1)) -k && make install
log "skipping compilation"
log "Compilation finished"
log "==================================="

## Preparing the module release
releaseFolder=$workingDir/trinitycore-nami
cp -a $workingDir/trinitycore-module $releaseFolder
mv /tmp/trinitycore $releaseFolder/files/trinitycore
mv $workingDir/TDB_full_335* $releaseFolder/files/trinitycore/
for i in sql/base sql/updates ; do
  mkdir -p $releaseFolder/files/trinitycore/$i
done
mv $workingDir/TrinityCore/sql/base/*_database.sql $releaseFolder/files/trinitycore/sql/base
mv $workingDir/TrinityCore/sql/updates $releaseFolder/files/trinitycore/sql/updates
rm $releaseFolder/files/README.md
ls -lahrtR $releaseFolder

moduleVersion=`cat $workingDir/TRINITYCORE_NAMI_VERSION`
moduleRevision=$((`cat $workingDir/TRINITYCORE_NAMI_REVISION` + 1))
sed -i 's/<<version>>/$moduleVersion/g' $releaseFolder/nami.json.tpl
sed -i 's/<<revision>>/$moduleRevision/g' $releaseFolder/nami.json.tpl
mv $releaseFolder/nami.json.tpl $releaseFolder/nami.json
cd $workingDir
tar czf trinitycore-module-${moduleVersion}-r${moduleRevision}.tar.gz trinitycore-nami

## Testing

#docker run -v $releaseFolder:/tmp/trinitycore bitnami/minideb-extras nami --log-level trace8 install /tmp/trinitycore
