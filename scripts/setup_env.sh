#!/bin/bash 
set -e

## The released tarball with the compiled binaries is retrieved
## The tag that will be downloaded is fetched from the original repo
git clone https://github.com/dgonzalezruiz/trinitycore-builds.git
cd trinitycore-builds
git fetch --tags
GIT_TAG="$(git tag | tail -n1)"
cd ../

URL="https://github.com/dgonzalezruiz/trinitycore-builds/releases/download/$GIT_TAG/trinitycore-$GIT_TAG.tar.gz"
URL_STATUS="curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL"
while [[ "$($URL_STATUS)" == *"4"* || "$($URL_STATUS)" == *"5"* ]] ; do 
  sleep 1 
  echo "Waiting for released binary to be available..." 
done

curl -L $URL > $TRAVIS_BUILD_DIR/trinitycore.tar.gz 

##Update mirrors for CLANG overriding
wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
yes | sudo add-apt-repository 'deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.9 main'

## Packages are installed now
sudo apt-get update -qq
sudo apt-get -qq install clang-3.9 build-essential libtool make cmake cmake-data openssl \
                         libssl-dev libmysqlclient-dev libmysql++-dev libreadline6-dev   \
                         zlib1g-dev libbz2-dev libboost1.55-dev libboost-thread1.55-dev  \
                         libboost-filesystem1.55-dev libboost-system1.55-dev             \
                         libboost-program-options1.55-dev libboost-iostreams1.55-dev p7zip

## Set up proper compiler variables 
export CC=clang-3.9 CXX=clang++-3.9

## The repository with the source to compile is cloned 
git clone -b 3.3.5 --single-branch https://github.com/TrinityCore/TrinityCore 

## The source SQL files are retrieved and extracted
wget $WORLD_SQL_URL
p7zip -d $WORLD_SQL.7z
