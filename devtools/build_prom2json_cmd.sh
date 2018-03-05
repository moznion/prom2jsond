#!/bin/bash

set -eu

REPO_ROOT="$(cd ./"$(git rev-parse --show-cdup)" || exit; pwd)"
PROM2JSON_PATH="$REPO_ROOT/vendor/github.com/prometheus/prom2json"
BIN_PATH="$REPO_ROOT/bin"

(cd "$PROM2JSON_PATH" && go build cmd/prom2json/main.go)
cp "$PROM2JSON_PATH/main" "$BIN_PATH/prom2json"

