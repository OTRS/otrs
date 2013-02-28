Which web server is needed?
===========================

We recommend the apache web server (http://httpd.apache.org).

Configuration
=============

Register the OTRS application with Apache
-----------------------------------------

You have two options:

### Via binary package

Install the RPM-Package ("rpm -i otrs-xxx.rpm").
This will automatically make the neccessary configuration changes for apache.

### Manual installation

Use the configuration file included in your installation
"$OTRS_HOME/scripts/apache2-httpd.include.conf" and add it to your apache configuration.
This has to be done differently on different platforms.

Example instructions for SuSE linux:

- Add the file to /etc/sysconfig/apache with HTTPD_CONF_INCLUDE_FILES

        [...]
        HTTPD_CONF_INCLUDE_FILES=/opt/otrs/scripts/apache2-httpd.include.conf
        [...]

- Start SuSEconfig and restart the web server (rcapache restart).


Permission Setup
----------------

You can either change the web server user (normally wwwrun or similar) to the OTRS user (otrs).
This has the benefit of avoiding file permission problems because the web server process uses the
same user id as the commandline tools of OTRS. If you have this option,

    User wwwrun

should become

    User otrs

Or, if you can't change the user and group of your web server (system-wide),
because you have other applications running on this server, you can
also work with group permissions in this case you can keep your default web server user.
Later on in [INSTALL.md](INSTALL.md) you can find details on the permission setup.


Restart the web server
----------------------

Now you can return to the instructions in [INSTALL.md](INSTALL.md).
