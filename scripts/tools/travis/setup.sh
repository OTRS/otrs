#!/bin/bash


if [ $DB = 'mysql' ]; then
    cp -i $TRAVIS_BUILD_DIR/scripts/tools/travis/Config.pm.travis.mysql $TRAVIS_BUILD_DIR/Kernel/Config.pm

    mysql -uroot -e "CREATE DATABASE otrs CHARACTER SET utf8";
    mysql -uroot -e "GRANT ALL PRIVILEGES ON otrs.* TO 'otrs'@'localhost' IDENTIFIED BY 'otrs'";
    mysql -uroot -e "FLUSH PRIVILEGES";
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema.mysql.sql
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-initial_insert.mysql.sql
    mysql -uroot otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema-post.mysql.sql
fi

if [ $DB = 'postgresql' ]; then
    cp -i $TRAVIS_BUILD_DIR/scripts/tools/travis/Config.pm.travis.postgresql $TRAVIS_BUILD_DIR/Kernel/Config.pm

    psql -U postgres -c "CREATE ROLE otrs LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE"
    psql -U postgres -c "CREATE DATABASE otrs OWNER otrs ENCODING 'UTF8'"
    psql -U otrs otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema.postgresql.sql > /dev/null
    psql -U otrs otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-initial_insert.postgresql.sql > /dev/null
    psql -U otrs otrs < $TRAVIS_BUILD_DIR/scripts/database/otrs-schema-post.postgresql.sql > /dev/null
    psql -U postgres -c "ALTER ROLE otrs PASSWORD 'otrs'"
fi
