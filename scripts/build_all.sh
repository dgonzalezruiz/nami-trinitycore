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

tar xzf $TRAVIS_BUILD_DIR/trinitycore.tar.gz -C /tmp

## Preparing the module release
releaseFolder=$workingDir/trinitycore-nami
cp -a $workingDir/trinitycore-module $releaseFolder
mv /tmp/trinitycore $releaseFolder/files/
mv $workingDir/TDB_full_335* $releaseFolder/files/trinitycore/
mkdir -p $releaseFolder/files/trinitycore/sql/base
mv $workingDir/TrinityCore/sql/base/*_database.sql $releaseFolder/files/trinitycore/sql/base
mv $workingDir/TrinityCore/sql/updates $releaseFolder/files/trinitycore/sql/
rm $releaseFolder/files/README.md

moduleVersion=$(git tag | tail -n1 | cut -d'-' -f1)
moduleRevision=$(git tag | tail -n1 | cut -d'r' -f2)
sed -i 's/<<version>>/$moduleVersion/g' $releaseFolder/nami.json.tpl
sed -i 's/<<revision>>/$moduleRevision/g' $releaseFolder/nami.json.tpl
mv $releaseFolder/nami.json.tpl $releaseFolder/nami.json
cd $workingDir
tar czf trinitycore-module-${moduleVersion}-r${moduleRevision}.tar.gz trinitycore-nami
