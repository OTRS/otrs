# --
# RPM spec file for RedHat Linux of the OTRS package
# Copyright (C) 2002-2003 Martin Edenhofer <bugs+rpm@otrs.org>
# --
# $Id: fedora-otrs-1.0.spec,v 1.1 2004-03-14 02:01:37 robert Exp $
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
Version:      1.2.0
Copyright:    GNU GENERAL PUBLIC LICENSE Version 2, June 1991
Group:        Applications/Mail
Provides:     otrs 
Requires:     perl perl-DBI perl-DBD-MySQL perl-URI mod_perl httpd mysql mysql-server fetchmail procmail sendmail
Autoreqprov:  no
Release:      beta3
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
    Gilberto Cezar de Almeida <gilberto at visaonet.com.br>
    Jorge Becerra <jorge at icc-cuba.com>
    Nicolas Goralski <ngoralski at oceanet-technology.com>
    Remo Catelotti <Remo.Catelotti at bull.it>
    Stefan Wintermeyer <stefan at wintermeyer.de>
    Vladimir Gerdjikov <gerdjikov at gerdjikovs.net>
    Martin Edenhofer <martin at otrs.org>
  
  OTRS is an Open source Ticket Request System with many features to manage
  customer telephone calls and e-mails. It is distributed under the GNU
  General Public License (GPL) and tested on Linux, Solaris, AIX, FreeBSD, 
  OpenBSD and Mac OS 10.x. Do you receive many e-mails and want to answer 
  them with a team of agents? You're going to love the OTRS!
  
  Feature list:

   Web-Interface: 
    - Agent web interface for viewing and working on all customer requests
    - Admin web interface for changing system things
    - Customer web interface for viewing and sending infos to the agents
    - Webinterface with themes support
    - Multi language support (Brazilian Portuguese, Bulgarian, Dutch, English,
       Finnish, French, German, Italian and Spanish)
    - customize the output templates (dtl) release independently
    - Webinterface with attachment support
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
for foo in var/cron/*.dist; do mv $foo var/cron/`basename $foo .dist`; done

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
install -d -m 755 $RPM_BUILD_ROOT/etc/httpd/conf.d

install -m 755 scripts/redhat-rcotrs $RPM_BUILD_ROOT/etc/rc.d/init.d/otrs
install -m 644 scripts/redhat-rcotrs-config $RPM_BUILD_ROOT/etc/sysconfig/otrs

# copy apache2-httpd.include.conf to /etc/httpd/conf.d/otrs.conf 
install -m 644 scripts/apache2-httpd.include.conf $RPM_BUILD_ROOT/etc/httpd/conf.d/otrs.conf

# set permission
export OTRSUSER=otrs
useradd $OTRSUSER || : 
useradd apache || :
groupadd apache || :
$RPM_BUILD_ROOT/opt/otrs/bin/SetPermissions.sh $RPM_BUILD_ROOT/opt/otrs $OTRSUSER apache apache apache

# remove some files from $RPM_BUILD_ROOT/$DESTROOT to avoid documentation packaging conflicts
rm -f $RPM_BUILD_ROOT/$DESTROOT/{CHANGES,COPYING,CREDITS,INSTALL,INSTALL.RedHat,INSTALL.SuSE,README,README.application-module,README.database,README.dtl,README.webserver,RELEASE,TODO,UPGRADING}
rm -rf $RPM_BUILD_ROOT/$DESTROOT/doc
rm -f $RPM_BUILD_ROOT/$DESTROOT/Kernel/Config.pm.dist

%pre
# remember about the installed version
if test -e /opt/otrs/RELEASE; then
    cat /opt/otrs/RELEASE|grep VERSION|sed 's/VERSION = //'|sed 's/ /-/g' > /tmp/otrs-old.tmp
fi
# useradd
export OTRSUSER=otrs
echo -n "Check OTRS user (/etc/passwd)... " 
if cat /etc/passwd | grep $OTRSUSER > /dev/null ; then 
    echo "$OTRSUSER exists."
    # update home dir
    usermod -d /opt/otrs $OTRSUSER
else
    useradd $OTRSUSER -d /opt/otrs/ -s /bin/false -g apache -c 'OTRS System User' && echo "$OTRSUSER added."
fi


%post
# if it's a major-update backup old version templates (maybe not compatible!)
if test -e /tmp/otrs-old.tmp; then
    TOINSTALL=`echo %{version}| sed 's/..$//'`
    OLDOTRS=`cat /tmp/otrs-old.tmp`
    if echo $OLDOTRS | grep -v "$TOINSTALL" > /dev/null; then
        echo "backup old (maybe not compatible) templates (of $OLDOTRS)"
        for i in /opt/otrs/Kernel/Output/HTML/Standard/*.rpmnew;
            do BF=`echo $i|sed 's/.rpmnew$//'`; mv -v $BF $BF.backup_maybe_not_compat_to.$OLDOTRS; mv $i $BF;
        done
    fi
    rm -rf /tmp/otrs-old.tmp
fi

# note
HOST=`hostname -f`
echo ""
echo "Next steps: "
echo ""
echo "[httpd services]"
echo " Restart httpd 'service httpd restart'"
echo ""
echo "[mysqld service]"
echo " Start mysqld 'service mysqld start'"
echo ""
echo "[install the OTRS database]"
echo " Use a webbrowser and open this link:"
echo " http://$HOST/otrs/installer.pl"
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
%doc CHANGES COPYING CREDITS INSTALL INSTALL.RedHat INSTALL.SuSE README README.application-module README.database README.dtl README.webserver RELEASE TODO UPGRADING doc/* Kernel/Config.pm.dist
#
%config(noreplace) /etc/sysconfig/otrs
%config /etc/httpd/conf.d/otrs.conf
/etc/rc.d/init.d/otrs
#
%config(noreplace) /opt/otrs/Kernel/Config.pm
%config(noreplace) /opt/otrs/Kernel/Config/GenericAgent.pm
%config(noreplace) /opt/otrs/Kernel/Config/ModulesCusto*.pm
%config(noreplace) /opt/otrs/var/log/TicketCounter.log
%config(noreplace) /opt/otrs/.procmailrc
%config(noreplace) /opt/otrs/.fetchmailrc
%config(noreplace) /opt/otrs/.mailfilter
%config(noreplace) /opt/otrs/Kernel/Output/HTML/Standard/*.dtl
%config(noreplace) /opt/otrs/Kernel/Output/HTML/Lite/*.dtl
%config(noreplace) /opt/otrs/Kernel/Language/*.pm
%config(noreplace) /opt/otrs/var/cron/*
#
/opt/otrs/Kernel/Config/Modules.pm
/opt/otrs/Kernel/Config/GenericAgent.pm.dist
/opt/otrs/Kernel/Config/GenericAgent.pm.examples
/opt/otrs/Kernel/Config/Defaults.pm
/opt/otrs/Kernel/Language.pm
/opt/otrs/Kernel/Modules/*.pm
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
#
/opt/otrs/Kernel/cpan-lib*

%changelog
* Tue Feb 10 2004 Patrick <rpms@puzzled.xs4all.nl>
- make specfile work for Red Hat Fedora Core 1

* Thu Feb 12 2003 - martin+rpm@otrs.org
- spec for RedHat 8.0 created 

