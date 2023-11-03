#!/bin/bash
#
docker system prune
docker kill -f $(docker ps -aq)
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images)

docker network create my-read-me-network

