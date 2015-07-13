# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
#
# please send bugfixes or comments to bugs+rpm@otrs.org
#
# --
Summary:      OTRS Help Desk.
Name:         otrs
Version:      0.0
Copyright:    GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007
Group:        Applications/Mail
Provides:     otrs
Requires:     apache2 apache2-mod_perl perl perl-Archive-Zip perl-DBI perl-Digest-MD5 perl-IO-Socket-SSL perl-ldap perl-libwww-perl perl-Net-DNS perl-Template-Toolkit perl-TimeDate procmail
Autoreqprov:  on
Release:      01
Source0:      otrs-%{version}.tar.bz2
BuildArch:    noarch
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
# configure apache
install -d -m 755 $RPM_BUILD_ROOT/etc/apache2/conf.d
install -m 644 scripts/apache2-httpd.include.conf $RPM_BUILD_ROOT/etc/apache2/conf.d/otrs.conf

# set permission
export OTRSUSER=otrs
useradd $OTRSUSER || :
useradd wwwrun || :
groupadd www || :
$RPM_BUILD_ROOT/opt/otrs/bin/otrs.SetPermissions.pl --web-group=www

%pre
# useradd
export OTRSUSER=otrs
echo -n "Check OTRS user ... "
if id $OTRSUSER >/dev/null 2>&1; then
    echo "$OTRSUSER exists."
    # update groups
    usermod -g www $OTRSUSER
    # update home dir
    usermod -d /opt/otrs $OTRSUSER
else
    useradd $OTRSUSER -d /opt/otrs/ -s /bin/bash -g www -c 'OTRS System User' && echo "$OTRSUSER added."
fi


%post
export OTRSUSER=otrs
if test -e /opt/otrs/Kernel/Config/Files/ZZZAAuto.pm; then
    su $OTRSUSER -s /bin/bash -c "/opt/otrs/bin/otrs.Console.pl Maint::Config::Rebuild";
    su $OTRSUSER -s /bin/bash -c "/opt/otrs/bin/otrs.Console.pl Maint::Cache::Delete";
fi

# note
HOST=`hostname -f`
echo ""
echo "Next steps: "
echo ""
echo "[start database and Apache]"
echo " Make sure your database is running and execute 'rcapache2 restart'."
echo ""
echo "[install the OTRS database]"
echo " Use a webbrowser and open this link:"
echo " http://$HOST/otrs/installer.pl"
echo ""
echo "((enjoy))"
echo ""
echo " Your OTRS Team"
echo " http://otrs.org/"
echo ""

%clean
rm -rf $RPM_BUILD_ROOT

%files
%config /etc/apache2/conf.d/otrs.conf
<FILES>
