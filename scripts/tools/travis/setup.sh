#!/bin/bash
# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

set -ev

if [ $DB = 'mysql' ]; then

    # Tweak some mysql settings for OTRS.
    sudo su - <<MODIFY_MYSQL_CONFIG
cat - <<MYSQL_CONFIG >> /etc/mysql/my.cnf
[mysqld]
max_allowed_packet   = 24M
innodb_log_file_size = 256M
MYSQL_CONFIG
MODIFY_MYSQL_CONFIG
    sudo service mysql restart
    mysql -e "SHOW VARIABLES LIKE 'max_allowed_packet';"
    mysql -e "SHOW VARIABLES LIKE 'innodb_log_file_size';"

    # Now create OTRS specific users and databases.
    cp -i $TRAVIS_BUILD_DIR/scripts/tools/travis/Config.mysql.pm $TRAVIS_BUILD_DIR/Kernel/Config.pm

    mysql -uroot -e "CREATE DATABASE otrs CHARACTER SET utf8";
    mysql -uroot -e "GRANT ALL PRIVILEGES ON otrs.* TO 'otrs'@'localhost' IDENTIFIED BY 'otrs'";
    mysql -uroot -e "CREATE DATABASE otrstest CHARACTER SET utf8";
    mysql -uroot -e "GRANT ALL PRIVILEGES ON otrstest.* TO 'otrstest'@'localhost' IDENTIFIED BY 'otrstest'";
    mysql -uroot -e "FLUSH PRIVILEGES";
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema.mysql.sql
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-initial_insert.mysql.sql
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema-post.mysql.sql
fi

if [ $DB = 'postgresql' ]; then
    cp -i $TRAVIS_BUILD_DIR/scripts/tools/travis/Config.postgresql.pm $TRAVIS_BUILD_DIR/Kernel/Config.pm

    psql -U postgres -c "CREATE ROLE otrs LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE"
    psql -U postgres -c "CREATE DATABASE otrs OWNER otrs ENCODING 'UTF8'"
    psql -U postgres -c "CREATE ROLE otrstest LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE"
    psql -U postgres -c "CREATE DATABASE otrstest OWNER otrstest ENCODING 'UTF8'"
    psql -U otrs otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema.postgresql.sql > /dev/null
    psql -U otrs otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-initial_insert.postgresql.sql > /dev/null
    psql -U otrs otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema-post.postgresql.sql > /dev/null
    psql -U postgres -c "ALTER ROLE otrs PASSWORD 'otrs'"
    psql -U postgres -c "ALTER ROLE otrstest PASSWORD 'otrstest'"
fi
