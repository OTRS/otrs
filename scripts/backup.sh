#!/bin/bash
# --
# scripts/backup.sh - a backup script for OpenTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: backup.sh,v 1.2 2002-08-13 15:20:12 martin Exp $
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

echo "backup.sh - a backup script for OpenTRS <\$Revision: 1.2 $>"
echo "Copyright (c) 2002 Martin Edenhofer <martin@otrs.org>"

# --
# check needed pograms
# --
for i in bzip2 cp mysqldump tar; do
    if ! which $i >> /dev/null; then
        echo "ERROR: Can't locate $i!"
        exit 1;
    fi 
done

if ! test $1 || ! test $2 || ! test $3; then
    # --
    # usage
    # --
    echo ""
    echo "Usage: backup.sh <OTRS_BIN_DIR> <OTRS_CONFIG.PM> <BACKUP_DIR> "
    echo ""
    echo "  Try: backup.sh /opt/OpenTRS/bin /opt/OpenTRS/Kernel/Config.pm /data/otrs-backup"
    echo ""
    exit 1;
fi

# --
# get config options
# --
DATABASE_DSN=`$1/otrs.getConfig DatabaseDSN` || exit 1;
DATABASE_HOST=`$1/otrs.getConfig DatabaseHost` || exit 1;
DATABASE=`$1/otrs.getConfig Database` || exit 1;
DATABASE_USER=`$1/otrs.getConfig DatabaseUser` || exit 1;
DATABASE_PW=`$1/otrs.getConfig DatabasePw` || exit 1;
ARTICLE_DIR=`$1/otrs.getConfig ArticleDir` || exit 1;
# --
# check database type
# --
if ! echo $DATABASE_DSN | grep -i mysql >> /dev/null ; then
    echo "ERROR: Can't dump database because this script supports just mysql"
    exit 1;
fi 
# --
# create backup sub directory
# --
SUBBACKUPFOLDER=`date +%Y-%m-%d_%H-%M`
mkdir -p $3/$SUBBACKUPFOLDER || exit 1;

#echo $DATABASE_DSN
echo "dump MySQL database $DATABASE@$DATABASE_HOST "
if ! mysqldump -u$DATABASE_USER -p$DATABASE_PW -h$DATABASE_HOST $DATABASE > $3/$SUBBACKUPFOLDER/database_backup.sql; then
    echo "ERROR: Can't dump database!";
    exit 1;
fi
echo "compresses SQL-file"
if ! bzip2 $3/$SUBBACKUPFOLDER/database_backup.sql; then
    echo "ERROR: Can't compresses SQL-file ($3/$SUBBACKUPFOLDER/database_backup.sql)!"
    exit 1;
fi
# --
# config files backup
# --
echo "backup $2"
cp $2 $3/$SUBBACKUPFOLDER/ 

# --
# var backup 
# --
echo "backup $ARTICLE_DIR"
cd $ARTICLE_DIR && tar -cjf $3/$SUBBACKUPFOLDER/article_backup.tar.bz2 .

