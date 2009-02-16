#!/bin/sh
# --
# auto_docbuild.sh - build automatically OTRS docu
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: auto_docbuild.sh,v 1.7 2009-02-16 12:50:17 tr Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

echo "auto_docbuild.sh - build automatically OTRS docu <\$Revision: 1.7 $>"
echo "Copyright (C) 2001-2008 OTRS AG, http://otrs.org/"

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
    echo "  Try: auto_docbuild.sh /home/ernie/src/otrs-doc "
    echo ""
    exit 1;
else
    # check dir
    if ! test -e $PATH_TO_CVS_SRC/de; then
        echo "Error: $PATH_TO_CVS_SRC is not OTRS CVS directory!"
        exit 1;
    fi
fi

# cleanup build dir
rm -rf $PACKAGE_DEST_DIR
mkdir -p $PACKAGE_DEST_DIR/


for Language in en de; do

    # prepare build env
    rm -rf $PACKAGE_BUILD_DIR || exit 1;
    mkdir -p $PACKAGE_BUILD_DIR/ || exit 1;
    cp -a $PATH_TO_CVS_SRC/* $PACKAGE_BUILD_DIR/ || exit 1;

    # remove CVS stuff
    find $PACKAGE_BUILD_DIR/ -name CVS | xargs rm -rf || exit 1;
    # remove swap stuff
    find -name ".#*" | xargs rm -rf

    # build docu
    mkdir $PACKAGE_BUILD_DIR/$Language/
    cd $PACKAGE_BUILD_DIR/$Language/

    # add READMEs
    cp install-cli.sgml install-cli.sgml.tmp
    perl -e '$IN = ""; open (IN, "< INSTALL"); while (<IN>) { $IN .= $_ if ($_ !~ /^#/); } $IN =~ s/>/&gt;/g; $IN =~ s/</&lt;/g; $IN2 = ""; open (IN2, "< install-cli.sgml.tmp"); while (<IN2>) { $IN2 .= $_; } $IN2 =~ s/\$\$INSTALL\$\$/$IN/; print $IN2;' > install-cli.sgml

    cp install-cli.sgml install-cli.sgml.tmp
    perl -e '$IN = ""; open (IN, "< README.database"); while (<IN>) { $IN .= $_ if ($_ !~ /^#/); } $IN =~ s/>/&gt;/g; $IN =~ s/</&lt;/g; $IN2 = ""; open (IN2, "< install-cli.sgml.tmp"); while (<IN2>) { $IN2 .= $_; } $IN2 =~ s/\$\$README.database\$\$/$IN/; print $IN2;' > install-cli.sgml

    cp install-cli.sgml install-cli.sgml.tmp
    perl -e '$IN = ""; open (IN, "< README.webserver"); while (<IN>) { $IN .= $_ if ($_ !~ /^#/); } $IN =~ s/>/&gt;/g; $IN =~ s/</&lt;/g; $IN2 = ""; open (IN2, "< install-cli.sgml.tmp"); while (<IN2>) { $IN2 .= $_; } $IN2 =~ s/\$\$README.webserver\$\$/$IN/; print $IN2;' > install-cli.sgml

    # pdf
    db2x.sh --pdf manual.sgml
    mkdir -p $PACKAGE_DEST_DIR/$Language/pdf
    cp manual.pdf $PACKAGE_DEST_DIR/$Language/pdf/otrs.pdf

    # html
    db2x.sh --html manual.sgml
    mkdir -p $PACKAGE_DEST_DIR/$Language/html
    mkdir -p $PACKAGE_DEST_DIR/$Language/html/screenshots
    mkdir -p $PACKAGE_DEST_DIR/$Language/html/images
    cp -R manual/* $PACKAGE_DEST_DIR/$Language/html/
    cp -R screenshots/* $PACKAGE_DEST_DIR/$Language/html/screenshots/
    cp -R images/* $PACKAGE_DEST_DIR/$Language/html/images/

    # sgml
    mkdir -p $PACKAGE_DEST_DIR/$Language/sgml
    cp -R *.sgml $PACKAGE_DEST_DIR/$Language/sgml/

    # cleanup
    rm -rf $PACKAGE_BUILD_DIR

done;

# show result
for Language in en de; do
    du -sh $PACKAGE_DEST_DIR/$Language/sgml/;
    du -sh $PACKAGE_DEST_DIR/$Language/html/;
    du -sh $PACKAGE_DEST_DIR/$Language/pdf/;
    ls -l $PACKAGE_DEST_DIR/$Language/pdf/otrs.pdf;
done;
