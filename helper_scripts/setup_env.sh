#!/bin/bash 
set -e

## SQL set release used; will be downloaded and integrated in the released tarball
SQL_FILES=TDB_full_335.62_2016_10_17
SERVER_SQL=https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.62/$SQL_FILES.7z

## Packages are installed now
sudo apt-get update -qq
sudo apt-get -qq install build-essential libtool make cmake cmake-data openssl p7zip   \
                        libssl-dev libmysqlclient-dev libmysql++-dev libreadline6-dev  \
                        zlib1g-dev libbz2-dev libboost1.55-dev libboost-thread1.55-dev \
                        libboost-filesystem1.55-dev libboost-system1.55-dev            \
                        libboost-program-options1.55-dev libboost-iostreams1.55-dev    \
                        libboost-regex1.55-dev

## The repository with the source to compile is cloned 
git clone -b 3.3.5 --single-branch https://github.com/TrinityCore/TrinityCore 

## The source SQL files are retrieved and extracted
wget $SERVER_SQL
p7zip -d $SQL_FILES.7z
