#!/bin/sh
# --
# auto_build.sh - build automatically OTRS tar, rpm and src-rpm
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: auto_build.sh,v 1.11 2003-01-09 20:56:53 martin Exp $
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

echo "auto_build.sh - build automatically OTRS tar, rpm and src-rpm <\$Revision: 1.11 $>"
echo "Copyright (c) 2002-2003 Martin Edenhofer <martin@otrs.org>"


PATH_TO_CVS_SRC=$1
PRODUCT=OTRS
VERSION=$2
RELEASE=$3
#ARCHIVE_DIR="otrs-$VERSION-$RELEASE"
#ARCHIVE_DIR="OpenTRS"
ARCHIVE_DIR="otrs"
PACKAGE=otrs
PACKAGE_BUILD_DIR="/tmp/$PACKAGE-build"
PACKAGE_DEST_DIR="/tmp/$PACKAGE-packages"
PACKAGE_TMP_SPEC="/tmp/$PACKAGE-spec.$$"

if ! test $PATH_TO_CVS_SRC || ! test $VERSION || ! test $RELEASE; then
    # --
    # build src needed
    # --
    echo ""
    echo "Usage: auto_build.sh <PATH_TO_CVS_SRC> <VERSION> <RELEASE>"
    echo ""
    echo "  Try: auto_build.sh /home/ernie/src/otrs 1.0.2 01"
    echo ""
    exit 1;
else
    # --
    # check dir 
    # --
    if ! test -e $PATH_TO_CVS_SRC/RELEASE; then
        echo "Error: $PATH_TO_CVS_SRC is not OTRS CVS directory!"
        exit 1;
    fi
fi

# --
# get system info
# --
if test -d /usr/src/redhat/RPMS/; then
    SYSTEM_RPM_DIR=/usr/src/redhat/RPMS/
else
    SYSTEM_RPM_DIR=/usr/src/packages/RPMS/
fi

if test -d /usr/src/redhat/SRPMS/; then
    SYSTEM_SRPM_DIR=/usr/src/redhat/SRPMS/
else 
    SYSTEM_SRPM_DIR=/usr/src/packages/SRPMS/
fi

if test -d /usr/src/redhat/SOURCES/; then
    SYSTEM_SOURCE_DIR=/usr/src/redhat/SOURCES/
else
    SYSTEM_SOURCE_DIR=/usr/src/packages/SOURCES/
fi

# --
# cleanup system dirs
# --
rm -rf $SYSTEM_RPM_DIR/*/$PACKAGE*$VERSION*$RELEASE*.rpm
rm -rf $SYSTEM_SRPM_DIR/$PACKAGE*$VERSION*$RELEASE*.src.rpm

# --
# RPM and SRPM dir
# --
rm -rf $PACKAGE_DEST_DIR
mkdir $PACKAGE_DEST_DIR
mkdir $PACKAGE_DEST_DIR/RPMS
mkdir $PACKAGE_DEST_DIR/RPMS/suse
mkdir $PACKAGE_DEST_DIR/RPMS/suse/7.3
mkdir $PACKAGE_DEST_DIR/RPMS/suse/8.x
mkdir $PACKAGE_DEST_DIR/RPMS/redhat
mkdir $PACKAGE_DEST_DIR/RPMS/redhat/7.x
mkdir $PACKAGE_DEST_DIR/SRPMS
mkdir $PACKAGE_DEST_DIR/SRPMS/suse
mkdir $PACKAGE_DEST_DIR/SRPMS/suse/7.3
mkdir $PACKAGE_DEST_DIR/SRPMS/suse/8.x
mkdir $PACKAGE_DEST_DIR/SRPMS/redhat
mkdir $PACKAGE_DEST_DIR/SRPMS/redhat/7.x

# --
# build 
# --
rm -rf $PACKAGE_BUILD_DIR || exit 1;
mkdir -p $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;

cp -a $PATH_TO_CVS_SRC/.*rc $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
cp -a $PATH_TO_CVS_SRC/* $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;

# --
# update RELEASE
# --
RELEASEFILE=$PACKAGE_BUILD_DIR/$ARCHIVE_DIR/RELEASE
echo "PRODUCT = $PRODUCT" > $RELEASEFILE 
echo "VERSION = $VERSION" >> $RELEASEFILE 
echo "BUILDDATE = `date`" >> $RELEASEFILE 
echo "BUILDHOST = `hostname -f`" >> $RELEASEFILE 

# --
# cleanup
# --
cd $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
# remove CVS dirs
find $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ -name CVS | xargs rm -rf || exit 1;
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
rm -rf doc/manual/screenshots
# remove doc stuff
rm -rf doc/manual
# remove swap stuff
find -name ".#*" | xargs rm -rf
# remove Kernel/Config.pm if exists
rm -rf Kernel/Config.pm 

# build html docu
$PATH_TO_CVS_SRC/scripts/auto_docbuild.sh $PATH_TO_CVS_SRC > /dev/null
mkdir doc/manual
mkdir doc/manual/html
mkdir doc/manual/pdf
mkdir doc/manual/sgml
cp -R /tmp/OTRSDOC-package/html/* doc/manual/html/
cp -R /tmp/OTRSDOC-package/pdf/* doc/manual/pdf/
cp -R /tmp/OTRSDOC-package/sgml/* doc/manual/sgml/

# --
# create tar
# --
cd $PACKAGE_BUILD_DIR/ || exit 1;
SOURCE_LOCATION=$SYSTEM_SOURCE_DIR/$PACKAGE-$VERSION-$RELEASE.tar.gz
tar -czf $SOURCE_LOCATION $ARCHIVE_DIR/ $ARCHIVE_DIR/.*rc || exit 1;
cp $SOURCE_LOCATION $PACKAGE_DEST_DIR/

# --
# create bzip2
# --
cd $PACKAGE_BUILD_DIR/ || exit 1;
SOURCE_LOCATION=$SYSTEM_SOURCE_DIR/$PACKAGE-$VERSION-$RELEASE.tar.bz2
tar -cjf $SOURCE_LOCATION $ARCHIVE_DIR/ $ARCHIVE_DIR/.*rc || exit 1;
cp $SOURCE_LOCATION $PACKAGE_DEST_DIR/


# --
# build SuSE 8.x rpm 
# --
specfile=$PACKAGE_TMP_SPEC
cat $ARCHIVE_DIR/scripts/suse-otrs.spec | sed "s/^Version:.*/Version:      $VERSION/" | sed "s/^Release:.*/Release:      $RELEASE/" > $specfile
rpm -ba --clean $specfile || exit 1;
rm -f $specfile

mv $SYSTEM_RPM_DIR/*/$PACKAGE*$VERSION*$RELEASE*.rpm $PACKAGE_DEST_DIR/RPMS/suse/8.x/
mv $SYSTEM_SRPM_DIR/$PACKAGE*$VERSION*$RELEASE*.src.rpm $PACKAGE_DEST_DIR/SRPMS/suse/8.x/

# --
# build SuSE 7.3 rpm 
# --
specfile=$PACKAGE_TMP_SPEC
cat $ARCHIVE_DIR/scripts/suse-otrs-7.3.spec | sed "s/^Version:.*/Version:      $VERSION/" | sed "s/^Release:.*/Release:      $RELEASE/" > $specfile
rpm -ba --clean $specfile || exit 1;
rm -f $specfile

mv $SYSTEM_RPM_DIR/*/$PACKAGE*$VERSION*$RELEASE*.rpm $PACKAGE_DEST_DIR/RPMS/suse/7.3/
mv $SYSTEM_SRPM_DIR/$PACKAGE*$VERSION*$RELEASE*.src.rpm $PACKAGE_DEST_DIR/SRPMS/suse/7.3/

# --
# build Redhat 7.x rpm
# --
cp $ARCHIVE_DIR/scripts/redhat-rpmmacros ~/.rpmmacros
specfile=$PACKAGE_TMP_SPEC
cat $ARCHIVE_DIR/scripts/redhat-otrs.spec | sed "s/^Version:.*/Version:      $VERSION/" | sed "s/^Release:.*/Release:      $RELEASE/" > $specfile
rpm -ba --clean $specfile || exit 1;
rm -f $specfile
rm -f ~/.rpmmacros

mv $SYSTEM_RPM_DIR/*/$PACKAGE*$VERSION*$RELEASE*.rpm $PACKAGE_DEST_DIR/RPMS/redhat/7.x/
mv $SYSTEM_SRPM_DIR/$PACKAGE*$VERSION*$RELEASE*.src.rpm $PACKAGE_DEST_DIR/SRPMS/redhat/7.x/

# --
# stats
# --
echo "-----------------------------------------------------------------";
echo -n "Source code lines (*.sh) : "
find $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ -name *.sh | xargs cat | wc -l
echo -n "Source code lines (*.pl) : "
find $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ -name *.pl | xargs cat | wc -l
echo -n "Source code lines (*.pm) : "
find $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ -name *.pm | xargs cat | wc -l
echo -n "Source code lines (*.dtl): "
find $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ -name *.dtl | xargs cat | wc -l
echo "-----------------------------------------------------------------";
echo "You will find your tar.gz, RPMs and SRPMs in $PACKAGE_DEST_DIR";
cd $PACKAGE_DEST_DIR
find . -name "*$PACKAGE*" | xargs ls -lo
echo "-----------------------------------------------------------------";
if which md5sum >> /dev/null; then
    echo "MD5 message digest (128-bit) checksums";
    find . -name "*$PACKAGE*" | xargs md5sum
else
    echo "No md5sum found in \$PATH!"
fi
echo "-----------------------------------------------------------------";

# --
# cleanup
# --
rm -rf $PACKAGE_BUILD_DIR
rm -rf $PACKAGE_TMP_SPEC
