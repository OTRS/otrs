Supported Database Systems
==========================

- MySQL 5.0+
- PostgreSQL 7+, 8.2+ recommended
- MSSQL 2005+
- Oracle


Where can I find the database description files?
================================================

You will find all SQL files under "$HOME_OTRS/scripts/database/*.sql".

MySQL files:
----------------
    $HOME_OTRS/scripts/database/otrs-schema.mysql.sql
    $HOME_OTRS/scripts/database/otrs-initial_insert.mysql.sql
    $HOME_OTRS/scripts/database/otrs-schema-post.mysql.sql

PostgreSQL 8.2+ files:
---------------------
    $HOME_OTRS/scripts/database/otrs-schema.postgresql.sql
    $HOME_OTRS/scripts/database/otrs-initial_insert.postgresql.sql
    $HOME_OTRS/scripts/database/otrs-schema-post.postgresql.sql

PostgreSQL files for older systems:
-----------------------------------
    $HOME_OTRS/scripts/database/otrs-schema.postgresql_before_8_2.sql
    $HOME_OTRS/scripts/database/otrs-initial_insert.postgresql_before_8_2.sql
    $HOME_OTRS/scripts/database/otrs-schema-post.postgresql_before_8_2.sql

MSSQL files:
----------------
    $HOME_OTRS/scripts/database/otrs-schema.mssql.sql
    $HOME_OTRS/scripts/database/otrs-initial_insert.mssql.sql
    $HOME_OTRS/scripts/database/otrs-schema-post.mssql.sql

Oracle files:
----------------
    $HOME_OTRS/scripts/database/otrs-schema.oracle.sql
    $HOME_OTRS/scripts/database/otrs-initial_insert.oracle.sql
    $HOME_OTRS/scripts/database/otrs-schema-post.oracle.sql


Database Setup Example (MySQL)
==============================

Create OTRS database:
---------------------
    shell> mysql -u root -p -e 'create database otrs charset utf8'

Create the OTRS tables:
-----------------------
    shell> mysql -u root -p otrs < scripts/database/otrs-schema.mysql.sql

Insert initial data:
-------------------
    shell> mysql -u root -p otrs < scripts/database/otrs-initial_insert.mysql.sql

Create foreign keys to other tables:
------------------------------------
    shell> mysql -u root -p otrs < scripts/database/otrs-schema-post.mysql.sql

Create a user for the database:
-------------------------------
    shell> mysql -u root -p -e 'GRANT ALL PRIVILEGES ON otrs.* TO otrs@localhost IDENTIFIED BY "some-pass" WITH GRANT OPTION;'

Reload the grant tables of your mysql-daemon:
---------------------------------------------
    shell> mysql -u root -p -e 'FLUSH PRIVILEGES;'


Database Setup Example (PostgreSQL):
====================================

PostgreSQL usually creates a user called 'postgres'. You should change
to the postgres user, via su, and then execute these commands.
We assume that your server can do MD5 identification; this is not
the default on most linux distributions.

Please refer to your database manuals for details. You can find general
instructions, which might be slightly different for your specific linux
version, here: https://help.ubuntu.com/10.04/serverguide/C/postgresql.html

Create a user for the database:
-------------------------------
    shell> createuser -D -P -S -R otrs

Create OTRS database:
---------------------
    shell> createdb --encoding=utf8 --owner=otrs otrs

Create the OTRS tables:
-----------------------
    shell> psql otrs < scripts/database/otrs-schema.postgresql.sql
 or
    shell> psql otrs < scripts/database/otrs-schema.postgresql_before_8_2.sql

Insert initial data:
-------------------
    shell> psql otrs < scripts/database/otrs-initial_insert.postgresql.sql
 or
    shell> psql otrs < scripts/database/otrs-initial_insert.postgresql_before_8_2.sql

Create foreign keys to other tables:
------------------------------------
    shell> psql otrs < scripts/database/otrs-schema-post.postgresql.sql
 or
    shell> psql otrs < scripts/database/otrs-schema-post.postgresql_before_8_2.sql


OTRS Database Driver Configuration:
===================================

Now add the correct database credentials to OTRS. Edit this section in your
configuration file $OTRS_HOME/Kernel/Config.pm

    [...]
    # Database name
    $Self->{Database} = 'otrs';

    # Database user
    $Self->{DatabaseUser} = 'otrs';

    # Database password
    $Self->{DatabasePw} = 'some-pass';
    [...]

If you're using PostgreSQL you should remove the comment (#)
before this line:

    #    $Self->{DatabaseDSN} = "DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost};";

If you have PostgresSQL 8.1 or earlier, activate the legacy driver by uncommenting this line:

    #    $Self->{DatabasePostgresqlBefore82} = 1;


Now save the file and run $OTRS_HOME/bin/otrs.CheckDB.pl to see if the connection
is successful. If this is working, you can log in to OTRS using the web frontend.
