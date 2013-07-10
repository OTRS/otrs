Software requirements
=====================

Mandatory:
* Perl 5.8.8 or higher (not Perl6)
* Database (e. g. MySQL, PostgreSQL)
* Webserver
* a few Perl modules (see step 2 of the chapter "Installation" for details)

Optional:
* On the Apache webserver, using mod_perl2 is highly recommended
* LDAPv2 compliant server (e. g. OpenLDAP)


Installation
============

The steps below describe how to install OTRS on Linux.
This procedure describes 'installation from source'. If you want to deploy
on RedHat, CentOS, Fedora, OpenSUSE, or SLES you can also choose to
instead install using the RPM from our website at http://otrs.org/downloads
Please refer to http://doc.otrs.org/ for detailed instructions on RPM based
installation.

If you want to deploy on Windows we ship an installer that automatically
installs OTRS, Apache (a webserver), Perl including all modules, MySQL, and
sets up the cron jobs for you. Please refer to
http://doc.otrs.org/3.2/en/html/installation.html#installation-on-windows
for detailed instructions.

The OTRS system user in this example is "otrs" and the installation
directory is /opt/otrs. You can adapt these values as needed.

1. Install tar.gz
------------------

    shell> cd /opt/
    shell> tar -xzvf otrs-x.x.x.tar.gz
    shell> mv otrs-x.x.x otrs

2. Install Additional Perl Modules
----------------------------------

Use the following script to get an overview of all installed and
required cpan modules.

    shell> perl /opt/otrs/bin/otrs.CheckModules.pl

To install missing Perl modules, you can:

###a) Install the packages via the package manager of your Linux distribution.

- For Red Hat, CentOS, Fedora or compatible systems:

        shell> yum install "perl(Digest::MD5)"

- For SUSE Linux Enterprise Server, openSUSE or compatible systems:
first determine the name of the package the module is shipped in.
Usually the package for My::Module would be called "perl-My-Module".

        shell> zypper search Digest::MD5

        Then install:

        shell> zypper install perl-Digest-MD5

- For Debian, Ubuntu or compatible systems
first determine the name of the package the module is shipped in.
Usually the package for My::Module would be called "libmy-module-perl".

        shell> apt-cache search Digest::MD5

        Then install:

        shell> apt-get install libdigest-md5-perl

Please note that it might be that you can't find all modules or their
required versions in your distribution repository, in that case you might
choose to install those modules via CPAN (see below).

###or

###b) Install the required modules via the CPAN shell

note that when you're on Linux you should run CPAN as your superuser
account because the modules should be accessible both by the OTRS
account and the account under which the web server is running.

    shell> perl -MCPAN -e shell;
    ...
    install Digest::MD5
    install Crypt::PasswdMD5
    ...

Any optional modules listed by the script should be installed depending
on the special requirements of the target system.

3. Create OTRS User
-------------------

Create user:

    shell> useradd -d /opt/otrs/ -c 'OTRS user' otrs

Add user to webserver group (if the webserver is not running as the OTRS user):

    shell> usermod -G www otrs
    (SUSE=www, Red Hat/CentOS/Fedora=apache, Debian/Ubuntu=www-data)

4. Activate Default Config Files
--------------------------------

There are two OTRS config files bundled in $OTRS_HOME/Kernel/*.dist
and $OTRS_HOME/Kernel/Config/*.dist. You must activate them by copying
them without the ".dist" filename extension.

    shell> cd /opt/otrs/
    shell> cp Kernel/Config.pm.dist Kernel/Config.pm
    shell> cp Kernel/Config/GenericAgent.pm.dist Kernel/Config/GenericAgent.pm

Or if you are installing OTRS an a Windows system:

    shell> copy Kernel/Config.pm.dist Kernel/Config.pm
    shell> copy Kernel/Config/GenericAgent.pm.dist Kernel/Config/GenericAgent.pm

5. Check if all needed modules are installed
--------------------------------------------

    shell> perl -cw /opt/otrs/bin/cgi-bin/index.pl
    /opt/otrs/bin/cgi-bin/index.pl syntax OK

    shell> perl -cw /opt/otrs/bin/cgi-bin/customer.pl
    /opt/otrs/bin/cgi-bin/customer.pl syntax OK

    shell> perl -cw /opt/otrs/bin/otrs.PostMaster.pl
    /opt/otrs/bin/otrs.PostMaster.pl syntax OK

"syntax OK" tells you all mandatory perl modules are installed.

6. Web Server
-------------

Please follow [README.webserver.md](README.webserver.md).

7. File Permissions
-------------------
File permissions need to be adjusted to allow OTRS to read and write files:

    shell> bin/otrs.SetPermissions.pl --otrs-user=<OTRS_USER> --web-user=<WEBSERVER_USER> [--otrs-group=<OTRS_GROUP>] [--web-group=<WEB_GROUP>] <OTRS_HOME>

For example:

- Web server which runs as the OTRS user:

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=otrs /opt/otrs

- Webserver with wwwrun user (e. g. SUSE):

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=wwwrun /opt/otrs

- Webserver with apache user (e. g. Red Hat, CentOS):

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=apache --otrs-group=apache --web-group=apache /opt/otrs

- Webserver with www-data user (e. g. Debian, Ubuntu):

        shell> bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=www-data --otrs-group=www-data --web-group=www-data /opt/otrs

8. Database setup
-----------------

If you use MySQL, you can use the Web based installer (http://yourhost/otrs/installer.pl).
Otherwise, please follow README.database for instructions.

9. First login
--------------

    http://yourhost/otrs/index.pl
    User: root@localhost
    PW: root

With this step, the basic system setup is finished.

10. First email
---------------

To check email reception, you can pipe an email directly into /opt/otrs/bin/otrs.Postmaster.pl:

    shell> cat /opt/otrs/doc/sample_mails/test-email-1.box | /opt/otrs/bin/otrs.PostMaster.pl

11. Cronjobs for the OTRS user
------------------------------

There are several OTRS default cronjobs in $OTRS_HOME/var/cron/*.dist.
They can be activated by copying them without the ".dist" filename extension.

    shell> cd var/cron
    shell> for foo in *.dist; do cp $foo `basename $foo .dist`; done

To schedule these cronjobs on your system, you can use the script Cron.sh.
Make sure to execute it as the OTRS system user!

- Scheduling the cronjobs for the first time:

        shell> /opt/otrs/bin/Cron.sh start

- Updating the cronjob schedules if you made changes:

        shell> /opt/otrs/bin/Cron.sh restart

- Stopping the cronjobs (useful for maintenance):

        shell> /opt/otrs/bin/Cron.sh stop

12. OTRS Scheduler Service
---------------------------

This step is optional. OTRS comes with a scheduler service. You'll only need
to set up the scheduler service if you're using the Generic Interface with
web services that need polling (OTRS as a consumer) or with web services
where requests are sent asynchronously.

The OTRS RPMs will set up the Scheduler Service automatically.
If you install from source, you can install the service by copying the
scripts/otrs-scheduler-linux file to /etc/init.d and give it the appropriate
permissions. This will make sure the scheduler service starts when the system
starts up.

Notes
=====

We advise you to read the OTRS performance tuning chapter on our homepage:
http://doc.otrs.org/3.2/en/html/performance-tuning.html.

If you encounter problems with the installation, you can send a message to our
mailing list otrs@otrs.org (http://lists.otrs.org/).

You can also ask the OTRS Group to either help you in planning or deploying
OTRS, or review your installed OTRS system. Our professional services are
designed to help you deploy OTRS faster and to get the most benefit out of
OTRS. See for more information: http://www.otrs.com/en/services/


((enjoy))

 Your OTRS Team
