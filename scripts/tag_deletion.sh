#!/bin/bash

if [ ! -z $TRAVIS_TAG ] ; then
  git config --global user.email "builds@travis-ci.com"
  git config --global user.name "Travis CI"
  git fetch --tags
  git tag -d $GIT_TAG
  git push -q https://"$GH_TOKEN"@github.com/dgonzalezruiz/trinitycore-builds.git origin :refs/tags/$GIT_TAG 2>&1 1>/dev/null
fi  
