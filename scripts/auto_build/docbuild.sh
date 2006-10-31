#!/bin/sh
# --
# scripts/auto_build/docbuild.sh - Automated creation of the  OTRS docu
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: docbuild.sh,v 1.7 2006-10-31 15:43:24 tr Exp $
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

echo "docbuild.sh - Automated creation of the  OTRS docu"
echo "Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/"

PATH_TO_CVS_SRC=$1
PATH_TO_CVS_FRAMEWORK_SRC=$2
PACKAGE=OTRSDOC
TMP="/tmp"
PACKAGE_BUILD_DIR="$TMP/$PACKAGE-build"
PACKAGE_DEST_DIR="$TMP/$PACKAGE-package"

if ! test -e $PATH_TO_CVS_SRC; then
    # --
    # build src needed
    # --
    echo ""
    echo "Usage: docbuild.sh <PATH_TO_CVS_SRC> <PATH_TO_CVS_FRAMEWORK_SRC>"
    echo ""
    echo "  Try: docbuild.sh /home/ernie/src/otrs-doc /home/ernie/src/otrs-cvs"
    echo ""
    exit 1;
fi
if ! test -e $PATH_TO_CVS_FRAMEWORK_SRC; then
    # --
    # build src needed
    # --
    echo ""
    echo "Usage: docbuild.sh <PATH_TO_CVS_SRC> <PATH_TO_CVS_FRAMEWORK_SRC>"
    echo ""
    echo "  Try: docbuild.sh /home/ernie/src/otrs-doc /home/ernie/src/otrs-cvs"
    echo ""
    exit 1;
fi
# check dir
if ! test -e $PATH_TO_CVS_SRC/de; then
    echo "Error: $PATH_TO_CVS_SRC is not OTRS CVS directory!"
    exit 1;
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
    mkdir -p $PACKAGE_BUILD_DIR/$Language/
    cd $PACKAGE_BUILD_DIR/$Language/

    # create all config params in xml
    $PATH_TO_CVS_FRAMEWORK_SRC/scripts/auto_build/xml2docbook.pl -l $Language > $PACKAGE_BUILD_DIR/$Language/all-config-parameters.xml
    $PATH_TO_CVS_FRAMEWORK_SRC/scripts/tools/charset-convert.pl -s utf-8 -d iso-8859-1 -f $PACKAGE_BUILD_DIR/$Language/all-config-parameters.xml

    # create one big xml file with all chapters
    xmllint --xinclude book.xml > otrs_admin_book.xml

    # pdf
    docbook2pdf otrs_admin_book.xml
    mkdir -p $PACKAGE_DEST_DIR/$Language/pdf
    cp otrs_admin_book.pdf $PACKAGE_DEST_DIR/$Language/pdf/otrs_admin_book.pdf

    # txt
    docbook2txt otrs_admin_book.xml
    mkdir -p $PACKAGE_DEST_DIR/$Language/txt
    cp otrs_admin_book.txt $PACKAGE_DEST_DIR/$Language/txt/otrs_admin_book.txt

    # html
    docbook2html otrs_admin_book.xml
    mkdir -p $PACKAGE_DEST_DIR/$Language/html
    mkdir -p $PACKAGE_DEST_DIR/$Language/html/screenshots
    mkdir -p $PACKAGE_DEST_DIR/$Language/images
    cp -R *.html $PACKAGE_DEST_DIR/$Language/html/
    cp -R screenshots/* $PACKAGE_DEST_DIR/$Language/html/screenshots/
    cp -R images/* $PACKAGE_DEST_DIR/$Language/images/

    # test for convert included in imagemagick package
    if [ -x /usr/bin/convert ] || [ -x /bin/convert ] ; then
        # convert images to 60% of orig. size
        CONVERT=`which convert`
        for i in $PACKAGE_DEST_DIR/$Language/html/screenshots/*.png ; do
            echo "convert image to 60% $i"
        $CONVERT $i -resize 60% $i
    done;
    fi

    # xml
    mkdir -p $PACKAGE_DEST_DIR/$Language/xml
    cp -R *.xml $PACKAGE_DEST_DIR/$Language/xml/

    # cleanup
    rm -rf $PACKAGE_BUILD_DIR

done;

# show result
echo ""
echo "Builded packages and files:"
echo "---------------------------"
for Language in en de; do
    du -sh $PACKAGE_DEST_DIR/$Language/xml/
    du -sh $PACKAGE_DEST_DIR/$Language/html/
    du -sh $PACKAGE_DEST_DIR/$Language/pdf/
    du -sh $PACKAGE_DEST_DIR/$Language/txt/
    echo ""
    ls -l $PACKAGE_DEST_DIR/$Language/pdf/otrs_admin_book.pdf;
    ls -l $PACKAGE_DEST_DIR/$Language/txt/otrs_admin_book.txt;
    echo ""
done;
