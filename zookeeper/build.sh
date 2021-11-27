#!/bin/bash
set -x
VERSION="zookeeper-3.6.2-10"
docker build -t rehanchy/zookeeper:"${VERSION}" .
docker push rehanchy/zookeeper:${VERSION}
