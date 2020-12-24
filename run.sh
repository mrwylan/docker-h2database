#!/bin/sh
docker run -d --name h2database -p 8082:8082 -p 9092:9092 -p 9010:9010 docker-h2database:${1:-2019-10-14}