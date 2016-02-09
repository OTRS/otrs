#!/bin/bash

BUILD_ROOT=/home/travis/build/OTRS/otrs
cp -i $BUILD_ROOT/scripts/tools/travis/Config.pm.travis.postgresql $BUILD_ROOT/Kernel/Config.pm
