#!/bin/bash 
set -e

log() {
    echo "$@" >&2
}

## The released tarball with the compiled binaries is retrieved
## The tag that will be downloaded is fetched from the original repo
git clone https://github.com/dgonzalezruiz/trinitycore-builds.git
cd trinitycore-builds
git fetch --tags
GIT_TAG="$(git tag | tail -n1)"
cd ../

log "==============================="
log "Going to fetch version $GIT_TAG"
log "==============================="
URL="https://github.com/dgonzalezruiz/trinitycore-builds/releases/download/$GIT_TAG/trinitycore-$GIT_TAG.tar.gz"
URL_STATUS="curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL"
while [[ "$($URL_STATUS)" == *"4"* || "$($URL_STATUS)" == *"5"* ]] ; do 
  sleep 1 
  echo "Waiting for released binary to be available..." 
done

curl -L $URL > $TRAVIS_BUILD_DIR/trinitycore.tar.gz 

## The repository with the source to compile is cloned 
git clone -b 3.3.5 --single-branch https://github.com/TrinityCore/TrinityCore 

## The source SQL files are retrieved and extracted
wget $WORLD_SQL_URL
p7zip -d $WORLD_SQL.7z
