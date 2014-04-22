Upgrading OTRS from 3.3 to 3.4
==============================

These instructions are for people upgrading OTRS from *3.3* to *3.4*,
and applies both for RPM and source code (tarball) upgrades.

If you are running a lower version of OTRS you have to follow the upgrade path
to 3.3 first (1.1->1.2->1.3->2.0->2.1->2.2->2.3->2.4->3.0->3.1->3.2->3.3->3.4 ...)!
You need to perform a full upgrade to every version in between, including
database changes and the upgrading perl script.

Please note that if you upgrade from OTRS 2.2 or earlier, you have to
take an extra step; please read http://bugs.otrs.org/show_bug.cgi?id=6798

Within a single minor version you can skip patch level releases if you want to
upgrade. For instance you can upgrade directly from OTRS 3.4.1 to version
3.4.4. If you need to do such a "patch level upgrade", you should skip steps
xxxxx.


1. Stop all relevant services
-----------------------------

e. g. (depends on used services):

    shell> /etc/init.d/cron stop
    shell> /etc/init.d/postfix stop
    shell> /etc/init.d/apache stop


2. Backup everything below $OTRS_HOME (default: OTRS_HOME=/opt/otrs)
--------------------------------------------------------------------

- Kernel/Config.pm
- Kernel/Config/GenericAgent.pm
- Kernel/Config/Files/ZZZAuto.pm
- var/*
- as well as the database


3. Make sure that you have backed up everything ;-)
---------------------------------------------------


4. Setup new system (optional)
------------------------------

If possible try this install on a separate machine for testing first.


5. Install the new release (tar or RPM)
---------------------------------------

With the tarball:

    shell> cd /opt
    shell> mv otrs otrs-old
    shell> tar -xzf otrs-x.x.x.tar.gz
    shell> mv otrs-x.x.x otrs

Restore old configuration files

- Kernel/Config.pm
- Kernel/Config/GenericAgent.pm
- Kernel/Config/Files/ZZZAuto.pm

Restore TicketCounter.log

In order to let OTRS continue with the correct ticket number, restore the `TicketCounter.log` to
`$OTRS_HOME/var/log/` (default: `OTRS_HOME=/opt/otrs`). This is especially important if you use incremental ticketnumbers.

Restore article data

If you configured OTRS to store article data in the filesystem you have to restore the `article` folder to `$OTRS_HOME/var/` (default: `OTRS_HOME=/opt/otrs`).


With the RPM:

    shell> rpm -Uvh otrs-x.x.x.-01.rpm

In this case the RPM update automatically restores the old configuration files.


6. Own themes
-------------

Note: The OTRS themes of 3.3 are NOT compatible with 3.4, so don't use your old themes!

Themes are located under `$OTRS_HOME/Kernel/Output/HTML/*/*.dtl` (default: `OTRS_HOME=/opt/otrs`)


7. Set file permissions
-----------------------

If the tarball is used, execute:

     shell> cd /opt/otrs/
     shell> bin/otrs.SetPermissions.pl

with the permissions needed for your system setup.


For example:

- Web server which runs as the OTRS user:

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=otrs /opt/otrs

- Webserver with wwwrun user (e. g. SUSE):

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=wwwrun /opt/otrs

- Webserver with apache user (e. g. Red Hat, CentOS):

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=apache --otrs-group=apache --web-group=apache /opt/otrs

- Webserver with www-data user (e. g. Debian, Ubuntu):

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=www-data --otrs-group=www-data --web-group=www-data /opt/otrs


8. Check needed Perl modules
----------------------------

Verify that all needed perl modules are installed on your system and install
any modules that might be missing.

     shell> /opt/otrs/bin/otrs.CheckModules.pl


9. Apply the database changes
-----------------------------

     shell> cd /opt/otrs/


### SCHEMA UPDATE

MySQL:

 Note: new tables created in the MySQL UPGRADING process will be created with the
 default table storage engine set in your MySQL server.
 In MySQL 5.5 the new default type is InnoDB.
 If existing tables, e.g. "users", have the table storage engine e.g. MyISAM,
 then an error will be displayed when creating the foreign key constraints.

 You have two options: you can change the default storage engine of MySQL back to MyISAM
 so that new tables will have the same engine as the existing tables,
 or change the existing tables to use InnoDB as storage engine.

 Any problems with regards to the storage engine will be reported by the
 `otrs.CheckDB.pl` script, so please run it to check for possible issues.

    shell> bin/otrs.CheckDB.pl

    shell> cat scripts/DBUpdate-to-3.4.mysql.sql | mysql -p -f -u root otrs

PostgreSQL 8.2+:

    shell> cat scripts/DBUpdate-to-3.4.postgresql.sql | psql --set ON_ERROR_STOP=on --single-transaction otrs otrs

PostgreSQL, older versions:

    shell> cat scripts/DBUpdate-to-3.4.postgresql_before_8_2.sql | psql --set ON_ERROR_STOP=on --single-transaction otrs otrs


 NOTE: If you use PostgreSQL 8.1 or earlier, you need to activate the new legacy driver
 for these older versions. Do this by adding a new line to your Kernel/Config.pm like this:

    $Self->{DatabasePostgresqlBefore82} = 1;


### DATABASE MIGRATION SCRIPT

 Run the migration script (as user `otrs`, NOT as `root`):

    shell> scripts/DBUpdate-to-3.4.pl

 Do not continue the upgrading process if this script did not work properly for you.
 Otherwise data loss may occur.


10. Refresh the configuration cache and delete caches
-----------------------------------------------------

Please run (as user `otrs`, NOT as `root`):

    shell> bin/otrs.RebuildConfig.pl
    shell> bin/otrs.DeleteCache.pl


11. Restart your services
-------------------------

e. g. (depends on used services):

    shell> /etc/init.d/apache start
    shell> /etc/init.d/postfix start
    shell> /etc/init.d/cron start

Now you can log into your system.


12. Check installed packages
----------------------------

In the package manager, check if all packages are still marked as
correctly installed or if any require reinstallation or even a package upgrade.

The following packages are automatically uninstalled after the upgrade process (if they where
installed before):

- XXX

13. Update and activate cronjobs
--------------------------------

There are several OTRS default cronjobs in $OTRS_HOME/var/cron/*.dist.
They can be activated by copying them without the ".dist" filename extension.
Do this to make sure you get the latest versions of the cronjobs and new cronjobs
as well.

    shell> cd var/cron
    shell> for foo in *.dist; do cp $foo `basename $foo .dist`; done

Please check the copied files and re-apply any customizations that you might have made.

To schedule these cronjobs on your system, you can use the script Cron.sh.
Make sure to execute it as the OTRS system user!

    shell> /opt/otrs/bin/Cron.sh start

Note: From OTRS 3.3.7 OTRS Scheduler uses a cronjob to start-up and keep alive. Please make sure
that scheduler_watchdog cronjob is activated.

14. Well done!
--------------
