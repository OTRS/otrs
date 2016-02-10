#!/bin/bash


if [ $DB = 'mysql' ]; then
    cp -i $TRAVIS_BUILD_DIR/scripts/tools/travis/Config.pm.travis.mysql $TRAVIS_BUILD_DIR/Kernel/Config.pm

    mysql -uroot -e "CREATE DATABASE otrs";
    mysql -uroot -e "GRANT ALL PRIVILEGES ON otrs.* TO 'otrs'@'localhost' IDENTIFIED BY 'otrs'";
    mysql -uroot -e "FLUSH PRIVILEGES";
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema.mysql.sql
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-initial_insert.mysql.sql
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema-post.mysql.sql
fi

if [ $DB = 'postgresql' ]; then
    cp -i $TRAVIS_BUILD_DIR/scripts/tools/travis/Config.pm.travis.postgresql $TRAVIS_BUILD_DIR/Kernel/Config.pm

    psql -U postgres "CREATE DATABASE otrs ENCODING=utf8"
    psql -U postgres "CREATE USER otrs WITH NOSUPERUSER NOCREATEDB NOCREATEROLE NOCREATEUSER PASSWORD 'otrs'"
    psql -U postgres otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema.postgresql.sql
    psql -U postgres otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-initial_insert.postgresql.sql
    psql -U postgres otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema-post.postgresql.sql
    psql -U postgres "ALTER DATABASE otrs OWNER TO otrs"
fi

mkdir -p $TRAVIS_BUILD_DIR/.ssl/certs
mkdir -p $TRAVIS_BUILD_DIR/.ssl/private
