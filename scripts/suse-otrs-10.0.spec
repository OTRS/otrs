# --
# RPM spec file for SUSE Linux 9.1 of the OTRS package
# Copyright (C) 2001-2004 Martin Edenhofer <bugs+rpm@otrs.org>
# --
# $Id: suse-otrs-10.0.spec,v 1.1 2006-03-25 22:49:09 martin Exp $
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
Requires:     perl perl-DBI perl-GD perl-GDGraph perl-GDTextUtil perl-Net-DNS perl-Digest-MD5 apache2 apache2-mod_perl mysql mysql-client perl-Msql-Mysql-modules mysql-shared fetchmail procmail
Autoreqprov:  on
Release:      01
Source0:      otrs-%{version}.tar.bz2
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
<DESCRIPTION>

SuSE series: ap

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
# install init-Script and rc.config entry
install -d -m 755 $RPM_BUILD_ROOT/etc/init.d
install -d -m 755 $RPM_BUILD_ROOT/usr/sbin
install -d -m 755 $RPM_BUILD_ROOT/etc/sysconfig
install -d -m 744 $RPM_BUILD_ROOT/var/adm/fillup-templates
install -d -m 755 $RPM_BUILD_ROOT/etc/apache2/conf.d

# replace apache with apache2
sed  "s/rcapache/rcapache2/" scripts/suse-rcotrs-config > /tmp.otrs.$$ && mv /tmp.otrs.$$ scripts/suse-rcotrs-config
sed  "s/apache/apache2/" scripts/suse-rcotrs > /tmp.otrs.$$ && mv /tmp.otrs.$$ scripts/suse-rcotrs
install -m 644 scripts/suse-rcotrs-config $RPM_BUILD_ROOT/etc/sysconfig/otrs

install -m 755 scripts/suse-rcotrs $RPM_BUILD_ROOT/etc/init.d/otrs
rm -f $RPM_BUILD_ROOT/sbin/otrs
ln -s ../../etc/init.d/otrs $RPM_BUILD_ROOT/usr/sbin/rcotrs

install -m 644 scripts/apache2-httpd-new.include.conf $RPM_BUILD_ROOT/etc/apache2/conf.d/otrs.conf

# set permission
export OTRSUSER=otrs
useradd $OTRSUSER || :
useradd wwwrun || :
groupadd www || :
$RPM_BUILD_ROOT/opt/otrs/bin/SetPermissions.sh $RPM_BUILD_ROOT/opt/otrs $OTRSUSER wwwrun www www

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
    # update groups
    usermod -g www $OTRSUSER
    # update home dir
    usermod -d /opt/otrs $OTRSUSER
else
    useradd $OTRSUSER -d /opt/otrs/ -s /bin/false -g nogroup -c 'OTRS System User' && echo "$OTRSUSER added."
fi


%post
# sysconfig
%{fillup_and_insserv -s otrs START_OTRS}

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
echo "[SuSEconfig]"
echo " Execute 'SuSEconfig' to configure the webserver."
echo ""
echo "[start Apache and MySQL]"
echo " Execute 'rcapache2 restart' and 'rcmysql start' in case they don't run."
echo ""
echo "[install the OTRS database]"
echo " Use a webbrowser and open this link:"
echo " http://$HOST/otrs/installer.pl"
echo ""
echo "[OTRS services]"
echo " Start OTRS 'rcotrs start-force' (rcotrs {start|stop|status|restart|start-force|stop-force})."
echo ""
echo "Have fun!"
echo ""
echo " Your OTRS Team"
echo " http://otrs.org/"
echo ""

%clean
rm -rf $RPM_BUILD_ROOT

%files
%config(noreplace) /etc/sysconfig/otrs
%config /etc/apache2/conf.d/otrs.conf

/etc/init.d/otrs
/usr/sbin/rcotrs

<FILES>

%changelog
* Sun Mar 25 2006 - martin+rpm@otrs.org
- added SUSE 10.0 support

