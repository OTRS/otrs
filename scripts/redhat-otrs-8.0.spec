# --
# RPM spec file for RedHat Linux of the OTRS package
# Copyright (C) 2002-2003 Martin Edenhofer <bugs+rpm@otrs.org>
# --
# $Id: redhat-otrs-8.0.spec,v 1.1 2003-02-15 11:58:30 martin Exp $
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
Requires:     perl perl-DBI perl-DBD-MySQL perl-URI mod_perl httpd mysql mysql-server fetchmail procmail sendmail
Autoreqprov:  no
Release:      01
Source0:      otrs-%{version}-%{release}.tar.bz2
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
<DESCRIPTION>

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

install -m 755 scripts/redhat-rcotrs $RPM_BUILD_ROOT/etc/rc.d/init.d/otrs
install -m 644 scripts/redhat-rcotrs-config $RPM_BUILD_ROOT/etc/sysconfig/otrs

# set permission
export OTRSUSER=otrs
useradd $OTRSUSER || : 
useradd apache || :
groupadd apache || :
$RPM_BUILD_ROOT/opt/otrs/bin/SetPermissions.sh $RPM_BUILD_ROOT/opt/otrs $OTRSUSER apache apache apache

%post
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

# copy apache2-httpd.include.conf to /etc/httpd/conf.d/otrs.conf 
cp /opt/otrs/scripts/apache2-httpd.include.conf /etc/httpd/conf.d/otrs.conf

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
%config(noreplace) /etc/sysconfig/otrs
/etc/rc.d/init.d/otrs

<FILES>

%changelog
* Thu Feb 12 2003 - martin+rpm@otrs.org
- spec for RedHat 8.0 created 

