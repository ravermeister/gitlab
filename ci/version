#!/usr/bin/env bash

set -eo pipefail

if [ "$1" = "arm32" ]; then
  version=$(sed -e '2!d;s/^v//g' VERSION)
elif [ "$1" = "arm64" ]; then
  version=$(sed -e '4!d;s/^v//g' VERSION)
else
  echo "no Version information found" >&2
  exit 1
fi

echo -n "${version}"
