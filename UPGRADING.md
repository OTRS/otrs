Upgrading OTRS from 3.1 to 3.2
==============================

These instructions are for people upgrading OTRS from "3.1" to "3.2",
and applies both for RPM and source code (tarball) upgrades.

If you are running a lower version of OTRS you have to follow the upgrade path
to 3.1 first (1.1->1.2->1.3->2.0->2.1->2.2->2.3->2.4->3.0->3.1->3.2 ...)!

Please note that if you upgrade from OTRS 2.2 or earlier, you have to
take an extra step; please read http://bugs.otrs.org/show_bug.cgi?id=6798

Please note that for upgrades from 3.2.0.beta1, an additional step 9
is needed!

Within a single minor version you can skip patch level releases if you want to
upgrade. For instance you can upgrade directly from OTRS 3.2.1 to version
3.2.4. If you need to do such a "patch level upgrade", you should skip steps
9, 13, 15, 16 and 17.


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

Note: The OTRS themes between 3.1 and 3.2 are NOT compatible, so don't use your old themes!

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

    shell> cat scripts/DBUpdate-to-3.2.mysql.sql | mysql -p -f -u root otrs

PostgreSQL 8.2+:

    shell> cat scripts/DBUpdate-to-3.2.postgresql.sql | psql otrs otrs

PostgreSQL, older versions:

    shell> cat scripts/DBUpdate-to-3.2.postgresql_before_8_2.sql | psql otrs otrs


 NOTE: If you use PostgreSQL 8.1 or earlier, you need to activate the new legacy driver
 for these older versions. Do this by adding a new line to your Kernel/Config.pm like this:

    $Self->{DatabasePostgresqlBefore82} = 1;


### DATABASE MIGRATION SCRIPT

 Run the migration script (as user `otrs`, NOT as `root`):

    shell> scripts/DBUpdate-to-3.2.pl

 Do not continue the upgrading process if this script did not work properly for you.
 Otherwise data loss may occur.


10. Database Upgrade During Beta Phase
--------------------------------------

This step is ONLY needed if you upgrade from 3.2.0.beta1!

Please apply the required database changes as follows:

MySQL:

    shell> cat scripts/DBUpdate-3.2.beta.mysql.sql | mysql -p -f -u root otrs

PostgreSQL 8.2+:

    shell> cat scripts/DBUpdate-3.2.beta.postgresql.sql | psql otrs otrs

PostgreSQL, older versions:

    shell> cat scripts/DBUpdate-3.2.beta.postgresql_before_8_2.sql | psql otrs otrs



11. Refresh the configuration cache and delete caches
-----------------------------------------------------

Please run:

    shell> bin/otrs.RebuildConfig.pl
    shell> bin/otrs.DeleteCache.pl


12. Restart your services
-------------------------

e. g. (depends on used services):

    shell> /etc/init.d/apache start
    shell> /etc/init.d/postfix start
    shell> /etc/init.d/cron start

Now you can log into your system.


13. Check 'Cache::Module' setting
---------------------------------

The file cache backend 'FileRaw' was removed in favor of the faster 'FileStorable'.
The `DBUpdate-to-3.2.pl` automatically updates the config setting `Cache::Module`, but
you need to change it manually if you defined this setting in `Kernel/Config.pm` directly.
It needs to be changed from 'Kernel::System::Cache::FileRaw' to
'Kernel::System::Cache::FileStorable'.


14. Check installed packages
----------------------------

In the package manager, check if all packages are still marked as
correctly installed or if any require reinstallation or even a package upgrade.


15. Cleanup metadata of archived tickets
----------------------------------------

Note: This step only applies if you use the ticket archiving feature of OTRS.

With OTRS 3.2, when tickets are archived, the information which agent read the
ticket and articles can be removed, as well as the ticket subscriptions of agents.
This is active by default and helps reduce the amount of data in the database on
large systems with many tickets and agents.

If you also want to cleanup this information for existing archived tickets,
please run this script:

    shell> bin/otrs.CleanupTicketMetadata.pl --archived

If you want to KEEP this information instead, please set these
SysConfig settings to "No":

    Ticket::ArchiveSystem::RemoveSeenFlags
    Ticket::ArchiveSystem::RemoveTicketWatchers


16. Review (Modify) ACLs for Dynamic Fields
-------------------------------------------
Note: This step only applies if you use ACLs to limit Dynamic Fields Dropdown or Multiselect
possible values.

Now in OTRS 3.2 the Possible and PossibleNot ACL sections for Dynamic Fields Dropdown and
Multiselect must refer to the key (internal values) rather than the value (shown values).

###Example

For the defined field "Dropdown1"  with possible values:

    1 => 'A',
    2 => 'B',
    3 => 'C',

ACLs prior OTRS 3.2 should look like:

    $Self->{TicketAcl}->{'Limit Dropdown1 entries'} = {
       Properties => {},
       Possible => {
           Ticket => {
               # White list entries with VALUES containing 'B' and 'C'
               DynamicField_Dropdown1 => [ 'B', 'C' ],
           },
       },
    };

These ACLs must be modified to:

    $Self->{TicketAcl}->{'Limit Dropdown1 entries'} = {
       Properties => {},
       Possible => {
           Ticket => {
               # White list entries with VALUES containing 'B' and 'C' (now using KEYS)
               DynamicField_Dropdown1 => [ '2', '3' ],
           },
       },
    };

By doing this change ACLs will look much more consistent, since Possible and PossibleDatabase
sections already use Keys instead of Values, please look at the following example:

    $Self->{TicketAcl}->{'Limit Dropdown1 entries based in Dropdown2'} = {
        Properties => {
            Ticket => {
                # Match on the DropDown2 KEY '1'
                DynamicField_Dropdown2 => ['1'],
            },
        },
        Possible => {
            Ticket => {
                # White list Dropdown1 entries with VALUES containing 'B' and 'C' (now using KEYS)
                DynamicField_Dropdown1 => ['1', '2'],
            },
        },
    };


17. Adapt custom event handler modules
--------------------------------------

Note: this only applies if you have any custom developed event handler modules.

Since OTRS 3.2, the data payload for event handler modules is no longer copied
into the `%Param` hash. You need to explicitly access it through `$Param{Data}`.

Old:

    # get ticket
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        UserID        => 1,
    );

New:

    # get ticket
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => 1,
    );


18. Well done!
--------------
