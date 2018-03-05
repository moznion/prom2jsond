#!/bin/bash

set -eu

if [ $# -lt 1 ]; then
  echo '[ERROR] Usage: docker_tag_n_push.sh <version>'
  exit 1;
fi

VERSION=$1
docker tag prom2jsond:latest "moznion/prom2jsond:$VERSION"
docker login
docker push "moznion/prom2jsond:$VERSION"

