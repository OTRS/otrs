#!/bin/bash
# --
# auto_build.sh - build automatically OpenTRS tar, rpm and src-rpm
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: auto_build.sh,v 1.2 2002-08-21 10:35:16 stefan Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

echo "auto_build.sh - build automatically OpenTRS tar, rpm and src-rpm <\$Revision: 1.2 $>"
echo "Copyright (c) 2002 Martin Edenhofer <martin@otrs.org>"

if ! test $1 || ! test $2 || ! test $3; then
    # --
    # build src needed
    # --
    echo ""
    echo "Usage: auto_build.sh <PATH_TO_CVS_SRC> <VERSION> <RELEASE>"
    echo ""
    echo "  Try: auto_build.sh /home/ernie/src/otrs 0.5 BETA42"
    echo ""
    exit 1;
else
    # --
    # check dir 
    # --
    if ! test -e $1/RELEASE; then
        echo "Error: $1 is not OTRS CVS directory!"
        exit 1;
    fi
fi

# --
# build 
# --
rm -rf /tmp/otrs_build || exit 1;
mkdir -p /tmp/otrs_build/OpenTRS/ || exit 1;

cp -a $1/.fetch* /tmp/otrs_build/OpenTRS/ || exit 1;
cp -a $1/.procm* /tmp/otrs_build/OpenTRS/ || exit 1;
cp -a $1/* /tmp/otrs_build/OpenTRS/ || exit 1;

# --
# cleanup
# --
cd /tmp/otrs_build/OpenTRS/ || exit 1;
# remove CVS dirs
find /tmp/otrs_build/OpenTRS/ -name CVS | xargs rm -rf || exit 1;
# remove old sessions, articles and spool
rm -f var/sessions/*
rm -rf var/article/*
rm -rf var/spool/*
# remove old docu stuff
for i in aux log out tex; do
  rm -rf doc/manual/manual.$i;
  rm -rf doc/manual/README.$i;
done;
rm -rf doc/screenshots

# --
# create tar
# --
cd /tmp/otrs_build/ || exit 1;
tar -czf /usr/src/packages/SOURCES/otrs-$2-$3.tar.gz OpenTRS/ OpenTRS/.procm* OpenTRS/.fetch* || exit 1;

# --
# build SuSE 8.0 rpm 
# --
specfile=/tmp/specfile$$
cat OpenTRS/scripts/suse-otrs.spec | sed "s/^Version:.*/Version:      $2/" | sed "s/^Release:.*/Release:      $3/" > $specfile
rpm -ba --clean $specfile || exit 1;
rm -f $specfile

# --
# build SuSE 7.3 rpm 
# --
specfile=/tmp/specfile$$
cat OpenTRS/scripts/suse-otrs-7.3.spec | sed "s/^Version:.*/Version:      $2/" | sed "s/^Release:.*/Release:      $3/" > $specfile
rpm -ba --clean $specfile || exit 1;
rm -f $specfile

# --
# stats
# --
echo -n "Source code lines (*.sh) : "
find /tmp/otrs_build/OpenTRS/ -name *.sh | xargs cat | wc -l
echo -n "Source code lines (*.pl) : "
find /tmp/otrs_build/OpenTRS/ -name *.pl | xargs cat | wc -l
echo -n "Source code lines (*.pm) : "
find /tmp/otrs_build/OpenTRS/ -name *.pm | xargs cat | wc -l
echo -n "Source code lines (*.dtl): "
find /tmp/otrs_build/OpenTRS/ -name *.dtl | xargs cat | wc -l

# --
# cleanup
# --
rm -rf /tmp/otrs_build/
