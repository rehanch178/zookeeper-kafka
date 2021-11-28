#!/bin/bash
VERSION="kafka-acl-2.13.2.6.1-1"
docker build -t rehanchy/kafka:${VERSION} .
docker push rehanchy/kafka:${VERSION}
