#!/bin/bash
# --
# scripts/restore.sh - a restore script for OpenTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: restore.sh,v 1.2 2002-08-13 15:20:12 martin Exp $
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

echo "restore.sh - a restore script for OpenTRS <\$Revision: 1.2 $>"
echo "Copyright (c) 2002 Martin Edenhofer <martin@otrs.org>"

# --
# check needed pograms
# --
for i in bunzip2 cat cp mysql; do
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
    echo "Usage: restore.sh <OTRS_BIN_DIR> <OTRS_CONFIG_DIR> <BACKUP_DIR> [Config.pm]"
    echo ""
    echo "  Try: restore.sh /opt/OpenTRS/bin /opt/OpenTRS/Kernel/ /data/otrs-backup/<TIME>/"
    echo ""
    exit 1;
fi

# --
# config files restore
# --
if test $4; then 
    if ! test -e $2/Config.pm; then
        echo "ERROR: Can't find $2/Config.pm!"
        exit 1;
    fi
    echo "backup old $2/Config.pm to Config.pm.restore.backup"
    cp $2/Config.pm $2/Config.pm.restore.backup
    echo "restore $3/Config.pm"
    cp $3/Config.pm $2/
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
# check all needed backup files
# --
for i in $3/database_backup.sql.bz2 $3/article_backup.tar.bz2; do 
    if ! test -e $i; then
        echo "ERROR: Can't find $i!"
        exit 1;
    fi
done

# --
# restore sql file
# --
echo "create database $DATABASE"
if ! mysql -u$DATABASE_USER -p$DATABASE_PW -h$DATABASE_HOST -e "create database $DATABASE"; then
    exit 1;
fi

echo "decompresses SQL-file "
if ! bunzip2 $3/database_backup.sql.bz2; then
    echo "ERROR: Can't decompresses SQL-file ($3/database_backup.sql.bz2)"
    exit 1;
fi

echo "cat SQL-file into MySQL database $DATABASE "
if ! cat $3/database_backup.sql | mysql -u$DATABASE_USER -p$DATABASE_PW -h$DATABASE_HOST $DATABASE; then
    echo "ERROR: Can't restore database $DATABASE!"
    echo "compresses SQL-file"
    bzip2 $3/database_backup.sql
    exit 1;
fi 

echo "compresses SQL-file"
if ! bzip2 $3/database_backup.sql; then
    echo "ERROR: Can't decompresses SQL-file ($3/database_backup.sql.bz2)!"
    exit 1;
fi

# --
# var restore
# --
echo "restore $ARTICLE_DIR"
cd $ARTICLE_DIR && tar -xjf $3/article_backup.tar.bz2 

# --
# set file permissions!
# --
echo "--"
echo "Note: We recomment to set all file permissions with '$1/SetPermissions.sh'"
echo "--"

