#!/bin/sh
# --
# auto_docbuild.sh - build automatically OTRS docu 
# Copyright (C) 2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: auto_docbuild.sh,v 1.1 2003-01-05 21:45:03 martin Exp $
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

echo "auto_docbuild.sh - build automatically OTRS docu <\$Revision: 1.1 $>"
echo "Copyright (c) 2003 Martin Edenhofer <martin@otrs.org>"


PATH_TO_CVS_SRC=$1
PACKAGE=OTRSDOC
PACKAGE_BUILD_DIR="/tmp/$PACKAGE-build"
PACKAGE_DEST_DIR="/tmp/$PACKAGE-package"

if ! test $PATH_TO_CVS_SRC; then
    # --
    # build src needed
    # --
    echo ""
    echo "Usage: auto_docbuild.sh <PATH_TO_CVS_SRC> <VERSION> <RELEASE>"
    echo ""
    echo "  Try: auto_docbuild.sh /home/ernie/src/otrs "
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
# cleanup build dir
# --
rm -rf $PACKAGE_DEST_DIR
mkdir $PACKAGE_DEST_DIR

# --
# prepare build env
# --
rm -rf $PACKAGE_BUILD_DIR || exit 1;
mkdir -p $PACKAGE_BUILD_DIR/ || exit 1;
cp -a $PATH_TO_CVS_SRC/* $PACKAGE_BUILD_DIR/ || exit 1;

# remove CVS stuff
find $PACKAGE_BUILD_DIR/ -name CVS | xargs rm -rf || exit 1;
# remove swap stuff
find -name ".#*" | xargs rm -rf

# add READMEs
cd $PACKAGE_BUILD_DIR/
cp doc/manual/install-cli.sgml doc/manual/install-cli.sgml.tmp
perl -e '$IN = ""; open (IN, "< INSTALL"); while (<IN>) { $IN .= $_ if ($_ !~ /^#/); } $IN =~ s/>/&gt;/g; $IN =~ s/</&lt;/g; $IN2 = ""; open (IN2, "< doc/manual/install-cli.sgml.tmp"); while (<IN2>) { $IN2 .= $_; } $IN2 =~ s/\$\$INSTALL\$\$/$IN/; print $IN2;' > doc/manual/install-cli.sgml

cp doc/manual/install-cli.sgml doc/manual/install-cli.sgml.tmp
perl -e '$IN = ""; open (IN, "< README.database"); while (<IN>) { $IN .= $_ if ($_ !~ /^#/); } $IN =~ s/>/&gt;/g; $IN =~ s/</&lt;/g; $IN2 = ""; open (IN2, "< doc/manual/install-cli.sgml.tmp"); while (<IN2>) { $IN2 .= $_; } $IN2 =~ s/\$\$README.database\$\$/$IN/; print $IN2;' > doc/manual/install-cli.sgml

cp doc/manual/install-cli.sgml doc/manual/install-cli.sgml.tmp
perl -e '$IN = ""; open (IN, "< README.webserver"); while (<IN>) { $IN .= $_ if ($_ !~ /^#/); } $IN =~ s/>/&gt;/g; $IN =~ s/</&lt;/g; $IN2 = ""; open (IN2, "< doc/manual/install-cli.sgml.tmp"); while (<IN2>) { $IN2 .= $_; } $IN2 =~ s/\$\$README.webserver\$\$/$IN/; print $IN2;' > doc/manual/install-cli.sgml

# --
# build docu 
# --
cd $PACKAGE_BUILD_DIR/doc/manual/
db2x.sh --pdf manual.sgml
mkdir $PACKAGE_DEST_DIR/pdf
cp manual.pdf $PACKAGE_DEST_DIR/pdf/otrs.pdf

db2x.sh --html manual.sgml
mkdir $PACKAGE_DEST_DIR/html
mkdir $PACKAGE_DEST_DIR/html/screenshots
cp -R manual/* $PACKAGE_DEST_DIR/html/
cp -R screenshots/* $PACKAGE_DEST_DIR/html/screenshots/

du -sh $PACKAGE_DEST_DIR/html/
ls -l $PACKAGE_DEST_DIR/pdf/otrs.pdf
# --
# cleanup
# --
rm -rf $PACKAGE_BUILD_DIR
