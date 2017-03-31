#!/bin/bash -e

## Retrieve all stuff required from the internet
git clone https://github.com/TrinityCore/TrinityCore $BRANCH_BUILT
git clone https://github.com/bitnami/blacksmith

## Add stuff to path
export PATH=$workingDir/blacksmith/bin:$PATH

## Build the docker image that we'll use later for compilation purposes
docker build compilation -t buildEnvironment

## Set up the compilation tool
cd $cwd/blacksmith
npm install
npm run install-runtime
blacksmith --help
blacksmith configure containerizedBuild.images[0].id buildEnvironment
blacksmith configure paths.output /tmp/trinitycore/blacksmith-output
blacksmith configure paths.sandbox /tmp/trinitycore/blacksmith-sandbox
blacksmith configure paths.recipes $cwd/compilation
blacksmith configure compilation.prefix /opt/trinitycore

## Compress the source repo for compilation
cd $workingDir
tar czf trinitycore.tar.gz TrinityCore


