#!/bin/bash 

set -e
## SQL set release used
export SQL_FILES=TDB_full_335.62_2016_10_17
SERVER_SQL=https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.62/$SQL_FILES.7z


## Install required packages
apt-get update && apt-get install wget p7zip -y

## Retrieve all stuff required from the internet
git clone -b 3.3.5 --single-branch https://github.com/TrinityCore/TrinityCore 
git clone https://github.com/bitnami/blacksmith
wget $SERVER_SQL

## Move SQL set to compilation environment
p7zip -d $SQL_FILES.7z
#mv $SQL_FILES $workingDir/TrinityCore


## Add stuff to path
export PATH=$workingDir/blacksmith/bin:$PATH

## Build the docker image that we'll use later for compilation purposes
docker build compilation -t buildenvironment

## Set up the compilation tool
cd $workingDir/blacksmith
npm install
npm run install-runtime
blacksmith=$workingDir/blacksmith/bin/blacksmith
$blacksmith --help
$blacksmith configure containerizedBuild.images[0].id buildenvironment
$blacksmith configure paths.output /tmp/trinitycore/blacksmith-output
$blacksmith configure paths.sandbox /tmp/trinitycore/blacksmith-sandbox
$blacksmith configure paths.recipes $workingDir/compilation
$blacksmith configure compilation.prefix /opt/trinitycore

## Compress the source repo for compilation
cd $workingDir
tar czf trinitycore.tar.gz TrinityCore


