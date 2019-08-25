#!/usr/bin/env bash

curl 'https://github.com/revarbat/BOSL/archive/v1.0.zip' -L -o bosl.zip
unzip bosl.zip -d lib
mv lib/BOSL-1.0 lib/BOSL
rm bosl.zip

