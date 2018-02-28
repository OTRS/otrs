#!/bin/sh

while getopts :sf opt
do
   case $opt in
       s) read; exit 0;;
       f) exit 1;;
   esac
done
