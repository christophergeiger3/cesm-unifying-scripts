#!/bin/bash

[[ "$1" = "-h" ]] && printf "Usage: $0 [VERSION]\nDefaults to cesm2.1.1\n" && exit
[[ -z "$1" ]] && version=2.1.1 || version="$1"

dirname="cesm${version}"

git clone -b "release-cesm${version}" https://github.com/ESCOMP/CESM.git "$dirname"
cd "$dirname" && ./manage_externals/checkout_externals