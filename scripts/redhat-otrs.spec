# --
# RPM spec file for RedHat Linux of the OTRS package
# Copyright (C) 2002-2003 Martin Edenhofer <bugs+rpm@otrs.org>
# --
# $Id: redhat-otrs.spec,v 1.11 2003-01-05 23:51:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
#
# please send bugfixes or comments to bugs+rpm@otrs.org
#
# --
Summary:      The Open Ticket Request System. 
Name:         otrs
Version:      0.5
Copyright:    GNU GENERAL PUBLIC LICENSE Version 2, June 1991
Group:        Applications/Mail
Provides:     otrs 
Requires:     perl perl-DBI perl-DBD-MySQL perl-Digest-MD5 perl-URI mod_perl apache mysql mysqlclient9 mysql-server fetchmail procmail sendmail
Autoreqprov:  on
Release:      BETA7
Source0:      otrs-%{version}-%{release}.tar.bz2
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
The Open Ticket Request System (http://otrs.org/) is a web based ticket system.

Feedback: feedback@otrs.org


Authors:
--------
    Antti Kämäräinen <antti at seu.net>
    Carsten Gross <carsten at siski.de>
    Franz Breu <breu.franz at bogen.net>
    Fred van Dijk <fvandijk at marklin.nl>
    Nicolas Goralski <ngoralski at oceanet-technology.com>
    Stefan Wintermeyer <stefan at wintermeyer.de>
    Vladimir Gerdjikov <gerdjikov at gerdjikovs.net>
    Martin Edenhofer <martin at otrs.org>

  OTRS is an Open source Ticket Request System with many features to manage
  customer telephone calls and e-mails. It is distributed under the GNU
  General Public License (GPL) and tested on Linux, Solaris, AIX, FreeBSD
  and Mac OS 10.x. Do you receive many e-mails and want to answer them with
  a team of agents? You're going to love the OTRS!

  Feature list:

   Web-Interface:
    - Agent web interface for viewing and working on all customer requests
    - Admin web interface for changing system things
    - Customer web interface for viewing and sending infos to the agents
    - Webinterface with themes support
    - Multi language support (english, german, french, finnish, dutch and bulgarian)
    - customize the output templates (dtl) release independently
    - easy and logical to use

   Email-Interface:
    - MIME support (attachments)
    - dispatching of incoming email via email addess or x-header
    - autoresponders for customers by incoming emails (per queue)
    - email-notification to the agent by new tickets, follow ups or lock timeouts

   Ticket:
    - custom queue view and queue view of all requests
    - Ticket locking
    - Ticket replies (standard responses)
    - Ticket autoresponders per queue
    - Ticket history, evolution of ticket status and actions taken on ticket
    - abaility to add notes (with different note types) to a ticket
    - Ticket zoom feature
    - Tickets can be bounced or forwarded to other email addresses
    - Ticket can be moved to a different queue (this is helpful if emails are
       for a specific subject)
    - Ticket priority
    - Ticket time accounting
    - content Fulltext search

   System:
    - creation and configuration of user accounts, and groups
    - creation of standard responses
    - Signature configuration per queue
    - Salutation configuration per queue
    - email-notification of administrators
    - email-notification sent to problem reporter (by create, locked, deleted,
       moved and closed)
    - submitting update-info (via email or webinterface).
    - deadlines for trouble tickets 
    - ASP (activ service providing) support 
    - TicketHook free setable like 'Call#', 'MyTicket#', 'Request#' or 'Ticket#'
    - Ticket number format free setable
    - different levels of permissions/access-rights. 
    - central database, Support of different SQL databases (e. g. MySQL, PostgeSQL, ...)
    - user authentication agains database or ldap directory
    - easy to develope you own addon's (OTRS API)
    - easy to write different frontends (e. g. X11, console, ...)
    - a fast and usefull application

%prep
%setup -n otrs

%build
# copy config file
cp Kernel/Config.pm.dist Kernel/Config.pm
cd Kernel/Config/ && for foo in *.dist; do cp $foo `basename $foo .dist`; done && cd ../../
# copy all crontab dist files
for foo in var/cron/*.dist; do cp $foo var/cron/`basename $foo .dist`; done

%install
# delete old RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT
# set DESTROOT
#export DESTROOT="/opt/OpenTRS/"
export DESTROOT="/opt/otrs/"
# create RPM_BUILD_ROOT DESTROOT
mkdir -p $RPM_BUILD_ROOT/$DESTROOT/
# copy files
cp -R . $RPM_BUILD_ROOT/$DESTROOT
# install init-Script 
install -d -m 755 $RPM_BUILD_ROOT/etc/rc.d/init.d
install -d -m 755 $RPM_BUILD_ROOT/etc/sysconfig

install -m 755 scripts/redhat-rcotrs $RPM_BUILD_ROOT/etc/rc.d/init.d/otrs
install -m 644 scripts/redhat-rcotrs-config $RPM_BUILD_ROOT/etc/sysconfig/otrs

%post
# useradd
export OTRSUSER=otrs
echo -n "Check OTRS user (/etc/passwd)... " 
if cat /etc/passwd | grep $OTRSUSER > /dev/null ; then 
    echo "$OTRSUSER exists."
    # update home dir
    usermod -d /opt/otrs $OTRSUSER
else
    useradd $OTRSUSER -d /opt/otrs/ -s /bin/false -G apache -c 'OTRS System User' && echo "$OTRSUSER added."
fi

# set permission
/opt/otrs/bin/SetPermissions.sh /opt/otrs $OTRSUSER apache apache apache
# set Config.pm permission to be writable for the webserver 
chown apache /opt/otrs/Kernel/Config.pm

# add httpd.include.conf to /etc/httpd/conf/httpd.conf
APACHERC=/etc/httpd/conf/httpd.conf
OTRSINCLUDE=/opt/otrs/scripts/suse-httpd.include.conf

cat $APACHERC | grep -v "httpd.include.conf" > /tmp/httpd.conf.tmp && \
echo "Include $OTRSINCLUDE" >> /tmp/httpd.conf.tmp && mv /tmp/httpd.conf.tmp $APACHERC

# note
echo ""
echo "Next steps: "
echo ""
echo "[httpd services]"
echo " Restart httpd 'service httpd restart'"
echo ""
echo "[mysqld service]"
echo " Start mysqld 'service mysqld start'"
echo ""
echo "[OTRS services]"
echo " Start OTRS 'service otrs start' (service otrs {start|stop|status|restart)."
echo ""
echo "Have fun!"
echo ""
echo " Your OTRS Team"
echo ""

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%config(noreplace) /opt/otrs/Kernel/Config.pm
%config(noreplace) /opt/otrs/Kernel/Config/*.pm
%config(noreplace) /opt/otrs/var/log/TicketCounter.log
%config(noreplace) /opt/otrs/.procmailrc
%config(noreplace) /opt/otrs/.fetchmailrc
%config(noreplace) /opt/otrs/Kernel/Output/HTML/Standard/*.dtl
%config(noreplace) /opt/otrs/Kernel/Output/HTML/Lite/*.dtl
%config(noreplace) /opt/otrs/Kernel/Language/*.pm
%config(noreplace) /opt/otrs/var/cron/*
%config(noreplace) /etc/sysconfig/otrs

/etc/rc.d/init.d/otrs

/opt/otrs/RELEASE
/opt/otrs/Kernel/Language.pm
/opt/otrs/Kernel/Modules/*
/opt/otrs/Kernel/Output/HTML/*.pm
/opt/otrs/Kernel/System/*
/opt/otrs/bin/*
/opt/otrs/scripts/*
/opt/otrs/var/article/
/opt/otrs/var/httpd/
/opt/otrs/var/sessions/
/opt/otrs/var/spool/
/opt/otrs/var/tmp/
/opt/otrs/var/pics/stats/

/opt/otrs/install*

/opt/otrs/Kernel/cpan-lib*

# redhat doc dir
%doc INSTAL* UPGRADING TODO COPYING CHANGES READM* doc/* 


%changelog
* Thu Jan 02 2003 - martin+rpm@otrs.org
- moved from /opt/OpenTRS to /opt/otrs
* Thu Nov 12 2002 - martin+rpm@otrs.org
- moved %doc/install* to /opt/OpenTRS/ (installer problems!)
  and added Kernel/cpan-lib*
* Sun Sep 22 2002 - martin+rpm@otrs.org
- added /etc/sysconfig/otrs for rc script (Thanks to Lars Müller)
* Thu Sep 17 2002 - martin+rpm@otrs.org
- port for Redhat 7.3
* Fri Sep 06 2002 - martin+rpm@otrs.org
- added Kernel/Config/*.pm
* Sat Jun 16 2002 - martin+rpm@otrs.org
- added new modules for 0.5 BETA6
* Thu Jun 04 2002 - martin+rpm@otrs.org
- added .fetchmailrc
* Mon May 20 2002 - martin+rpm@otrs.org
- moved all .dlt and all Kernel::Language::*.pm to %config(noreplace) 
* Sat May 05 2002 - martin+rpm@otrs.org
- added Kernel/Output/HTML/Standard/Motd.dtl as config file 
* Thu Apr 16 2002 - martin+rpm@otrs.org
- moved to SuSE 8.0 support
* Sun Feb 03 2002 - martin+rpm@otrs.org
- added SuSE-Apache support
* Wed Jan 30 2002 - martin+rpm@otrs.org
- added to useradd bash=/bin/false
* Sat Jan 12 2002 - martin+rpm@otrs.org
- added SuSE like rc scripts
* Tue Jan 10 2002 - martin+rpm@otrs.org 
- new package created

