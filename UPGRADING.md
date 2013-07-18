Upgrading OTRS from 3.2 to 3.3
==============================

These instructions are for people upgrading OTRS from "3.2" to "3.3",
and applies both for RPM and source code (tarball) upgrades.

If you are running a lower version of OTRS you have to follow the upgrade path
to 3.2 first (1.1->1.2->1.3->2.0->2.1->2.2->2.3->2.4->3.0->3.1->3.2->3.3 ...)!

Please note that if you upgrade from OTRS 2.2 or earlier, you have to
take an extra step; please read http://bugs.otrs.org/show_bug.cgi?id=6798

Within a single minor version you can skip patch level releases if you want to
upgrade. For instance you can upgrade directly from OTRS 3.3.1 to version
3.3.4. If you need to do such a "patch level upgrade", you should skip steps
XXXXX.


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
    shell> tar -xzf otrs-x.x.x.tar.gz
    shell> ln -s otrs-x.x.x otrs

Restore old configuration files.

- Kernel/Config.pm
- Kernel/Config/GenericAgent.pm
- Kernel/Config/Files/ZZZAuto.pm

Restore TicketCounter.log

In order to let OTRS continue with the correct ticket number, restore the 'TicketCounter.log' to
`$OTRS_HOME/var/log/` (default: `OTRS_HOME=/opt/otrs`)

This is especially important if you are using incremental ticketnumbers.

Restore article data

If you are saving article data to the filesystem you have to restore the 'article' folder to `$OTRS_HOME/var/` (default: `OTRS_HOME=/opt/otrs`)


With the RPM:

    shell> rpm -Uvh otrs-x.x.x.-01.rpm

In this case the RPM update automatically restores the old configuration files.

6. Own themes
-------------

Note: The OTRS themes between 3.2 and 3.3 are NOT compatible, so don't use your old themes!

Themes are located under `$OTRS_HOME/Kernel/Output/HTML/*/*.dtl` (default: `OTRS_HOME=/opt/otrs`)


7. Set file permissions
-----------------------

If the tarball is used, execute:

     shell> cd /opt/otrs/
     shell> bin/otrs.SetPermissions.pl

with the permissions needed for your system setup.


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

    shell> cat scripts/DBUpdate-to-3.3.mysql.sql | mysql -p -f -u root otrs

PostgreSQL 8.2+:

    shell> cat scripts/DBUpdate-to-3.3.postgresql.sql | psql otrs otrs

PostgreSQL, older versions:

    shell> cat scripts/DBUpdate-to-3.3.postgresql_before_8_2.sql | psql otrs otrs


 NOTE: If you use PostgreSQL 8.1 or earlier, you need to activate the new legacy driver
 for these older versions. Do this by adding a new line to your Kernel/Config.pm like this:

    $Self->{DatabasePostgresqlBefore82} = 1;


### DATABASE MIGRATION SCRIPT

 Run the migration script (as user `otrs`, NOT as `root`):

    shell> scripts/DBUpdate-to-3.3.pl

 Do not continue the upgrading process if this script did not work properly for you.
 Otherwise data loss may occur.


10. Refresh the configuration cache and delete caches
-----------------------------------------------------

Please run:

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

- OTRSPostMasterFilterExtensions
- OTRSFreeTextFromCustomerUser
- OTRSExternalTicketNumberRecognition
- OTRSDashboardQueueOverview
- OTRSImportantArticles
- OTRSImportantArticlesITSM
- OTRSDashboardTicketCalendar
- OTRSMultiServiceSelect
- OTRSMultiQueueSelect
- OTRSDynamicFieldMultiLevelSelection
- OTRSKeepFAQAttachments
- OTRSTicketAclEditor


13. Check config settings of OTRSFreeTextFromCustomerUser
-------------------------------------------------------

Note: This only applies if you used the package OTRSFreeTextFromCustomerUser previously.

If you used this module previously, you need to reconfigure it.
The module is automatically uninstalled by the upgrading script as it is
now a part of the OTRS framework.

If you want to keep using it, please enable the setting
"Ticket::EventModulePost###930-DynamicFieldFromCustomerUser" to
activate this feature and configure the mapping in the setting
"DynamicFieldFromCustomerUser::Mapping".


14. Import your ACLs to the new ACL editor (optional)
-------------------------------------------------------

In OTRS 3.3, there is a graphical editor for ACLs in the administration interface. You will need to
import your existing ACLs (e.g. in Config.pm or additional files) to the editor by using
bin/otrs.ImportACLsFromConfig.pl in order to make them available in the editor. Please make sure to
delete any ACLs from Config.pm (or other files) after successfully finishing the import procedure. Also
you will need to use the deploy button in the ACL administration frontend in order to re-deploy the imported
ACLs to your system.


15. Well done!
--------------
