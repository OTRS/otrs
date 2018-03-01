#!/bin/bash

while getopts :sf opt
do
   case $opt in
       s) while read; do continue; done; exit 0;;
       f) while read; do continue; done; exit 1;;
   esac
done
