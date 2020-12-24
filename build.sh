#!/bin/sh
#
# you can overwrite the h2 database version by specifying the release date as argument
# e.g: ./build.sh "2019-10-14"
docker build --build-arg RELEASE_DATE=${1:-""} --tag docker-h2database:${1:-2019-10-14} .