#!/bin/sh
# --
# scripts/backup.sh - a backup script for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: backup.sh,v 1.8 2003-02-25 20:32:03 martin Exp $
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

echo "backup.sh - a backup script for OTRS <\$Revision: 1.8 $>"

REMOVE_OLD=0
# parse user input
while getopts "rb:c:d:" Option
do
  case $Option in
    r)
      # remove backups older than a month
      REMOVE_OLD=1
    ;;
    b)
      # bin path
      OTRS_BIN=$OPTARG
    ;;
    c)
      # config path
      OTRS_CFG=$OPTARG
    ;;
    d)
      # backup path
      BACKUPDIR=$OPTARG
    ;;
  esac
done
shift $(($OPTIND - 1))

if [ "x${OTRS_BIN}" == "x" ] || [ "x${OTRS_CFG}" == "x" ] || [ "x${BACKUPDIR}" == "x" ]; then
    echo ""
    echo "Usage: backup.sh [-r] -b path/bin -c path/Kernel/Config -d backup-path "
    echo ""
    echo "  Try: backup.sh -b /opt/otrs/bin -c /opt/otrs/Kernel/Config/ -d /data/otrs-backup"
    echo "  Use the -r switch to remove backups older than a month"
    echo ""
    exit 1
fi

# --
# get config options
# --
DATABASE_DSN=`${OTRS_BIN}/otrs.getConfig DatabaseDSN` || exit 1
DATABASE_HOST=`${OTRS_BIN}/otrs.getConfig DatabaseHost` || exit 1
DATABASE=`${OTRS_BIN}/otrs.getConfig Database` || exit 1
DATABASE_USER=`${OTRS_BIN}/otrs.getConfig DatabaseUser` || exit 1
DATABASE_PW=`${OTRS_BIN}/otrs.getConfig DatabasePw` || exit 1
ARTICLE_DIR=`${OTRS_BIN}/otrs.getConfig ArticleDir` || exit 1

# --
# check what kind of db whe are running
# --
if echo $DATABASE_DSN | grep -i mysql >> /dev/null ; then
    DB=MYSQL
    DB_DUMP=mysqldump
elif echo $DATABASE_DSN | grep -i DBI:Pg >> /dev/null ; then
    DB=POSTGRES
    DB_DUMP=pg_dump
else
    echo "ERROR: Can't run backup script because there is no support for your database. Better start coding now."
    exit 1
fi

# --
# check needed pograms
# --
for i in bzip2 $DB_DUMP mkdir cp tar; do
    if ! which $i >> /dev/null; then
        echo "ERROR: Can't locate $i!"
        exit 1
    fi 
done

if [ $REMOVE_OLD == 1 ]; then
    # --
    # delete old backup sub directory
    # --

    OLDBACKUPFOLDER="$(date +%Y)-$(( $(date +%m) - 1))-$(date +%d)*"
    echo "deleting old backups in ${BACKUPDIR}/${OLDBACKUPFOLDER}"
    rm -Rf ${BACKUPDIR}/${OLDBACKUPFOLDER}
fi

# --
# create backup sub directory
# --
SUBBACKUPFOLDER=`date +%Y-%m-%d_%H-%M`
mkdir ${BACKUPDIR}/${SUBBACKUPFOLDER} || exit 1

# --
# dump database and compress
# --
if [ "$DB" == "MYSQL" ]; then
    echo "dump MySQL rdbms ${DATABASE}@${DATABASE_HOST}"
    if ! mysqldump -u $DATABASE_USER -p$DATABASE_PW -h $DATABASE_HOST $DATABASE > ${BACKUPDIR}/${SUBBACKUPFOLDER}/database_backup.sql; then
        echo "ERROR: Cannot dump database, please check!"
        exit 1
    fi
elif [ "$DB" == "POSTGRES" ]; then
    echo "dump PostgreSQL rdbms ${DATABASE}@${DATABASE_HOST}"
    if ! pg_dump -f ${BACKUPDIR}/${SUBBACKUPFOLDER}/database_backup.sql -h $DATABASE_HOST -U $DATABASE_USER $DATABASE; then
        echo "ERROR: Cannot dump database, please check!"
        exit 1
    fi
fi

echo "compresses SQL-file"
if ! bzip2 -9 ${BACKUPDIR}/${SUBBACKUPFOLDER}/database_backup.sql; then
    echo "ERROR: Can't compresses SQL-file (${BACKUPDIR}/${SUBBACKUPFOLDER}/database_backup.sql)!"
    exit 1
fi

# --
# config files backup
# --
echo "backup ${OTRS_CFG}/* ${OTRS_CFG}/../Config.pm"
mkdir ${BACKUPDIR}/${SUBBACKUPFOLDER}/Config/
cp ${OTRS_CFG}/* ${BACKUPDIR}/${SUBBACKUPFOLDER}/Config/
cp ${OTRS_CFG}/../Config.pm ${BACKUPDIR}/${SUBBACKUPFOLDER}/ 

# --
# var backup 
# --
echo "backup $ARTICLE_DIR"
cd $ARTICLE_DIR && tar -cjf $BACKUPDIR/$SUBBACKUPFOLDER/article_backup.tar.bz2 .

exit 0
