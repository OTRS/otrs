# --
# RPM spec file for SuSE Linux of the OTRS package
# Copyright (C) 2002-2003 Martin Edenhofer <bugs+rpm@otrs.org>
# --
# $Id: suse-otrs-7.3.spec,v 1.21 2003-04-13 11:42:58 martin Exp $
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
Requires:     perl perl-DBI perl-GD perl-Net-DNS perl-Digest-MD5 apache mod_perl mysql mysql-client perl-Msql-Mysql-modules mysql-shared fetchmail procmail perl-MIME-Base64
Autoreqprov:  on
Release:      01
Source0:      otrs-%{version}-%{release}.tar.bz2
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
<DESCRIPTION>

SuSE series: ap

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
export DESTROOT="/opt/otrs/"
# create RPM_BUILD_ROOT DESTROOT
mkdir -p $RPM_BUILD_ROOT/$DESTROOT/
# copy files
cp -R . $RPM_BUILD_ROOT/$DESTROOT
# install init-Script and rc.config entry
install -d -m 755 $RPM_BUILD_ROOT/etc/init.d
install -d -m 755 $RPM_BUILD_ROOT/usr/sbin
install -d -m 755 $RPM_BUILD_ROOT/etc/rc.config.d
install -d -m 744 $RPM_BUILD_ROOT/var/adm/fillup-templates

# check suse release
install -m 644 scripts/suse-fillup-template-rc.config.otrs $RPM_BUILD_ROOT/var/adm/fillup-templates/rc.config.otrs
install -m 644 scripts/suse-rcotrs-config $RPM_BUILD_ROOT/etc/rc.config.d/otrs

install -m 755 scripts/suse-rcotrs $RPM_BUILD_ROOT/etc/init.d/otrs
rm -f $RPM_BUILD_ROOT/sbin/otrs
ln -s ../../etc/init.d/otrs $RPM_BUILD_ROOT/usr/sbin/rcotrs

# set permission
export OTRSUSER=otrs
useradd $OTRSUSER || :
useradd wwwrun || :
groupadd nogroup || :
$RPM_BUILD_ROOT/opt/otrs/bin/SetPermissions.sh $RPM_BUILD_ROOT/opt/otrs $OTRSUSER wwwrun

%pre
# backup old version templates (not compatible!)
TOINSTALL=`echo %{version}| sed 's/..$//'`
INSTALLEDVERSION=`cat /opt/otrs/RELEASE|grep VERSION|sed 's/VERSION = //'|sed 's/ /-/g'`
if echo $INSTALLEDVERSION | grep -v "$TOINSTALL"; then
    echo "backup old - not compatible templates (.$INSTALLEDVERSION)"
    for foo in /opt/otrs/Kernel/Output/HTML/Standard/*.dtl;
        do mv $foo $foo.$INSTALLEDVERSION.backup;
    done
fi

%post
# useradd
export OTRSUSER=otrs
echo -n "Check OTRS user (/etc/passwd)... " 
if cat /etc/passwd | grep $OTRSUSER > /dev/null ; then 
    echo "$OTRSUSER exists."
    # update groups
    usermod -g nogroup $OTRSUSER
    # update home dir
    usermod -d /opt/otrs $OTRSUSER
else
    useradd $OTRSUSER -d /opt/otrs/ -s /bin/false -g nogroup -c 'OTRS System User' && echo "$OTRSUSER added."
fi

# rc.config
%{fillup_and_insserv -s otrs START_OTRS}

# add apache-httpd.include.conf to apache.rc.config
APACHERC=/etc/rc.config.d/apache.rc.config

OTRSINCLUDE=/opt/otrs/scripts/apache-httpd.include.conf
sed 's+^HTTPD_CONF_INCLUDE_FILES=.*$+HTTPD_CONF_INCLUDE_FILES='$OTRSINCLUDE'+' \
$APACHERC > /tmp/apache.rc.config.tmp && mv /tmp/apache.rc.config.tmp $APACHERC 

# note
HOST=`hostname -f`
echo ""
echo "Next steps: "
echo ""
echo "[SuSEconfig]"
echo " Execute 'SuSEconfig' to configure the webserver."
echo ""
echo "[start Apache and MySQL]"
echo " Execute 'rcapache start' and 'rcmysql start' in case they don't run."
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
%config(noreplace) /etc/rc.config.d/otrs

/etc/init.d/otrs
/usr/sbin/rcotrs

<FILES>

%changelog
* Thu Jan 02 2003 - martin+rpm@otrs.org
- moved from /opt/OpenTRS to /opt/otrs
* Thu Nov 12 2002 - martin+rpm@otrs.org
- moved %doc/install* to /opt/OpenTRS/ (installer problems!)
  and added Kernel/cpan-lib*
* Sun Sep 22 2002 - martin+rpm@otrs.org
- added /etc/rc.config.d/otrs for rc script (Thanks to Lars Müller)
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

