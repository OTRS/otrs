# --
# RPM spec file for RedHat Linux of the OTRS package
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: redhat-otrs-7.3.spec,v 1.14 2007-08-09 21:43:57 martin Exp $
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
Version:      0.0
Copyright:    GNU GENERAL PUBLIC LICENSE Version 2, June 1991
Group:        Applications/Mail
Provides:     otrs
Requires:     perl perl-DBI perl-DBD-MySQL perl-Digest-MD5 perl-URI perl-MIME-Base64 mod_perl apache mysql mysqlclient9 mysql-server procmail perl-libwww-perl
Autoreqprov:  no
Release:      01
Source0:      otrs-%{version}.tar.bz2
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
<DESCRIPTION>

%prep
%setup

%build
# copy config file
cp Kernel/Config.pm.dist Kernel/Config.pm
cd Kernel/Config/ && for foo in *.dist; do cp $foo `basename $foo .dist`; done && cd ../../
# copy all crontab dist files
for foo in var/cron/*.dist; do mv $foo var/cron/`basename $foo .dist`; done
# copy all .dist files
cp .procmailrc.dist .procmailrc
cp .fetchmailrc.dist .fetchmailrc
cp .mailfilter.dist .mailfilter

%install
# delete old RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT
# set DESTROOT
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

# set permission
export OTRSUSER=otrs
useradd $OTRSUSER || :
useradd apache || :
groupadd apache || :
$RPM_BUILD_ROOT/opt/otrs/bin/SetPermissions.sh $RPM_BUILD_ROOT/opt/otrs $OTRSUSER apache apache apache

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
# add httpd.include.conf to /etc/httpd/conf/httpd.conf
APACHERC=/etc/httpd/conf/httpd.conf
OTRSINCLUDE=/opt/otrs/scripts/apache-httpd.include.conf

cat $APACHERC | grep -v "httpd.include.conf" > /tmp/httpd.conf.tmp && \
echo "Include $OTRSINCLUDE" >> /tmp/httpd.conf.tmp && mv /tmp/httpd.conf.tmp $APACHERC

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

# OTRS 2.0 -> OTRS 2.1
# remove old ticket config file
if test -e /opt/otrs/Kernel/Config/Files/Ticket.pm; then
    mv /opt/otrs/Kernel/Config/Files/Ticket.pm /opt/otrs/Kernel/Config/Files/Ticket.pm.not_longer_used
fi;
# remove old ticket postmaster config file
if test -e /opt/otrs/Kernel/Config/Files/TicketPostMaster.pm; then
    mv /opt/otrs/Kernel/Config/Files/TicketPostMaster.pm /opt/otrs/Kernel/Config/Files/TicketPostMaster.pm.not_longer_used;
fi
# remove old faq config file
if test -e /opt/otrs/Kernel/Config/Files/FAQ.pm; then
    mv /opt/otrs/Kernel/Config/Files/FAQ.pm /opt/otrs/Kernel/Config/Files/FAQ.pm.not_longer_used;
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
echo "((enjoy))"
echo ""
echo " Your OTRS Team"
echo ""

%clean
rm -rf $RPM_BUILD_ROOT

%files
%config(noreplace) /etc/sysconfig/otrs

/etc/rc.d/init.d/otrs

<FILES>

%changelog
* Thu Oct 18 2006 - martin+rpm@otrs.org
- added rename of old /opt/otrs/Kernel/Config/Files/(Ticket|TicketPostMaster|FAQ).pm files
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

