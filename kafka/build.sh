#!/bin/bash
VERSION="kafka-2.13.2.6.1-10"
docker build -t rehanchy/kafka:${VERSION} .
docker push rehanchy/kafka:${VERSION}
