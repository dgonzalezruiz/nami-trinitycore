#!/bin/bash 
set -e

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
