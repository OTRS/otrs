#!/bin/sh
# --
# auto_build.sh - build automatically OTRS tar, rpm and src-rpm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

echo "auto_build.sh - build automatically OTRS tar, rpm and src-rpm"
echo "Copyright (C) 2001-2013 OTRS AG, http://otrs.org/\n";

PATH_TO_CVS_SRC=$1
PRODUCT=OTRS
VERSION=$2
RELEASE=$3
ARCHIVE_DIR="otrs-$VERSION"
PACKAGE=otrs
PACKAGE_BUILD_DIR="/tmp/$PACKAGE-build"
PACKAGE_DEST_DIR="/tmp/$PACKAGE-packages"
PACKAGE_TMP_SPEC="/tmp/$PACKAGE.spec"
RPM_BUILD="rpmbuild"
#RPM_BUILD="rpm"


if ! test $PATH_TO_CVS_SRC || ! test $VERSION || ! test $RELEASE; then
    # --
    # build src needed
    # --
    echo ""
    echo "Usage: auto_build.sh <PATH_TO_CVS_SRC> <VERSION> <BUILD>"
    echo ""
    echo "  Try: auto_build.sh /home/ernie/src/otrs 3.1.0.beta1 01"
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

# --
# build
# --
rm -rf $PACKAGE_BUILD_DIR || exit 1;
mkdir -p $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;

cp -a $PATH_TO_CVS_SRC/.*rc.dist $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
cp -a $PATH_TO_CVS_SRC/.mailfilter.dist $PACKAGE_BUILD_DIR/$ARCHIVE_DIR/ || exit 1;
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

# remove old sessions, articles and spool and other stuff
# (remainders of a running system, should not really happen)
rm -rf .gitignore var/sessions/* var/article/* var/spool/* Kernel/Config.pm
# remove development content
rm -rf development
# remove swap/temp stuff
find -name ".#*" | xargs rm -rf
find -name ".keep" | xargs rm -f

# mk ARCHIVE
bin/otrs.CheckSum.pl -a create
# Create needed files and directories
echo > var/log/TicketCounter.log
mkdir -p var/tmp var/article

function CreateArchive() {
    SUFFIX=$1
    COMMANDLINE=$2

    cd $PACKAGE_BUILD_DIR/ || exit 1;
    SOURCE_LOCATION=$SYSTEM_SOURCE_DIR/$PACKAGE-$VERSION.$SUFFIX
    rm $SOURCE_LOCATION
    echo "Building $SOURCE_LOCATION..."
    $COMMANDLINE $SOURCE_LOCATION $ARCHIVE_DIR/ > /dev/null || exit 1;
    cp $SOURCE_LOCATION $PACKAGE_DEST_DIR/
}

CreateArchive "tar.gz"  "tar -czf"
CreateArchive "tar.bz2" "tar -cjf"
CreateArchive "zip"     "zip -r"

# --
# create rpm spec files
# --
DESCRIPTION=$PATH_TO_CVS_SRC/scripts/auto_build/description.txt
FILES=$PATH_TO_CVS_SRC/scripts/auto_build/files.txt

function CreateRPM() {
    DistroName=$1
    SpecfileName=$2
    TargetPath=$3

    echo "Building $DistroName rpm..."

    specfile=$PACKAGE_TMP_SPEC
    # replace version and release
    cat $ARCHIVE_DIR/scripts/$SpecfileName | sed "s/^Version:.*/Version:      $VERSION/" | sed "s/^Release:.*/Release:      $RELEASE/" > $specfile.tmp
    # replace sourced files
    perl -e "open(SPEC, '< $specfile.tmp');while(<SPEC>){\$spec.=\$_;};open(IN, '< $FILES');while(<IN>){\$i.=\$_;}\$spec=~s/<FILES>/\$i/g;print \$spec;" > $specfile.tmp1
    # replace package description
    perl -e "open(SPEC, '< $specfile.tmp1');while(<SPEC>){\$spec.=\$_;};open(IN, '< $DESCRIPTION');while(<IN>){\$i.=\$_;}\$spec=~s/<DESCRIPTION>/\$i/g;print \$spec;" > $specfile
    $RPM_BUILD -ba --clean $specfile || exit 1;
    rm $specfile || exit 1;

    mkdir -p $PACKAGE_DEST_DIR/RPMS/$TargetPath
    mv $SYSTEM_RPM_DIR/*/$PACKAGE*$VERSION*$RELEASE*.rpm $PACKAGE_DEST_DIR/RPMS/$TargetPath
    mkdir -p $PACKAGE_DEST_DIR/SRPMS/$TargetPath
    mv $SYSTEM_SRPM_DIR/$PACKAGE*$VERSION*$RELEASE*.src.rpm $PACKAGE_DEST_DIR/SRPMS/$TargetPath
}

CreateRPM "SuSE 11.0" "suse-otrs-11.0.spec" "suse/11.0/"
CreateRPM "SuSE 10.0" "suse-otrs-10.0.spec" "suse/10.0/"
CreateRPM "Fedora 20" "fedora-otrs-20.spec" "fedora/20/"
CreateRPM "Fedora 21" "fedora-otrs-21.spec" "fedora/21/"
CreateRPM "Fedora 22" "fedora-otrs-22.spec" "fedora/22/"
CreateRPM "RHEL6"     "rhel6-otrs.spec"     "rhel/6"
CreateRPM "RHEL7"     "rhel7-otrs.spec"     "rhel/7"

echo "-----------------------------------------------------------------";
echo "You will find your tar.gz, RPMs and SRPMs in $PACKAGE_DEST_DIR";
cd $PACKAGE_DEST_DIR
find . -name "*$PACKAGE*" | xargs ls -lo
echo "-----------------------------------------------------------------";
if which md5sum >> /dev/null; then
    echo "MD5 message digest (128-bit) checksums in wiki table format";
    find . -name "*$PACKAGE*" | xargs md5sum | sed -e "s/^/| /" -e "s/\.\//| http:\/\/ftp.otrs.org\/pub\/otrs\//" -e "s/$/ |/"
else
    echo "No md5sum found in \$PATH!"
fi
echo "--------------------------------------------------------------------------";
echo "Note: You may have to tag your git tree: git tag rel-3_x_x -a -m \"3.x.x\"";
echo "--------------------------------------------------------------------------";

# --
# cleanup
# --
rm -rf $PACKAGE_BUILD_DIR
rm -rf $PACKAGE_TMP_SPEC
