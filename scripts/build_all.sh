##################################################
#  This script takes care of the whole           #
#  build process of the nami module              #
#  and releases it to github, marking a new tag  #
##################################################

#!/bin/bash

set -e

log() {
    echo "$@" >&2
}

tcd() {
  cd $TRAVIS_BUILD_DIR/$1
}

tar xzf $TRAVIS_BUILD_DIR/trinitycore.tar.gz -C /tmp

## Preparing the module release
releaseFolder=$TRAVIS_BUILD_DIR/trinitycore-nami
cp -a $TRAVIS_BUILD_DIR/trinitycore-module $releaseFolder
mv /tmp/trinitycore $releaseFolder/files/
mv $TRAVIS_BUILD_DIR/TDB_full_335* $releaseFolder/files/trinitycore/
mkdir -p $releaseFolder/files/trinitycore/sql/base
mv $TRAVIS_BUILD_DIR/TrinityCore/sql/base/*_database.sql $releaseFolder/files/trinitycore/sql/base
mv $TRAVIS_BUILD_DIR/TrinityCore/sql/updates $releaseFolder/files/trinitycore/sql/
rm $releaseFolder/files/README.md

moduleVersion=$(git tag | tail -n1 | cut -d'-' -f1)
moduleRevision=$(git tag | tail -n1 | cut -d'r' -f2)
sed -i 's/<<version>>/$moduleVersion/g' $releaseFolder/nami.json.tpl
sed -i 's/<<revision>>/$moduleRevision/g' $releaseFolder/nami.json.tpl
mv $releaseFolder/nami.json.tpl $releaseFolder/nami.json
tcd
tar czf trinitycore-module-${moduleVersion}-r${moduleRevision}.tar.gz trinitycore-nami
