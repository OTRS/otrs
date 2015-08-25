# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

Summary:      OTRS Help Desk.
Name:         otrs
Version:      0.0
Copyright:    GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007
Group:        Applications/Mail
Provides:     otrs
Requires:     cronie httpd mod_perl perl perl(Archive::Zip) perl(Crypt::SSLeay) perl(Date::Format) perl(DBI) perl(Digest::SHA) perl(IO::Socket::SSL) perl(LWP::UserAgent) perl(Net::DNS) perl(Net::LDAP) perl(Template) perl(URI) perl(XML::LibXML) perl(XML::LibXSLT) perl(XML::Parser) perl-core procmail
AutoReqProv:  no
Release:      01
Source0:      otrs-%{version}.tar.bz2
BuildArch:    noarch
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
OTRS is an Open source Ticket Request System with many features to manage
customer telephone calls and e-mails. It is distributed under the GNU
AFFERO General Public License (AGPL) and tested on Linux, Solaris, AIX,
FreeBSD, OpenBSD and Mac OS. Do you receive many e-mails and want to
answer them with a team of agents? You're going to love OTRS!

%prep
%setup

%build
# copy config file
cp Kernel/Config.pm.dist Kernel/Config.pm
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
install -d -m 755 $RPM_BUILD_ROOT/etc/httpd/conf.d
install -m 644 scripts/apache2-httpd.include.conf $RPM_BUILD_ROOT/etc/httpd/conf.d/zzz_otrs.conf

# set permissions
export OTRSUSER=otrs
useradd $OTRSUSER || :
useradd apache || :
groupadd apache || :
$RPM_BUILD_ROOT/opt/otrs/bin/otrs.SetPermissions.pl --web-group=apache

%pre
# useradd
export OTRSUSER=otrs
echo -n "Check OTRS user ... "
if id $OTRSUSER >/dev/null 2>&1; then
    echo "$OTRSUSER exists."
    # update home dir
    usermod -d /opt/otrs $OTRSUSER
else
    useradd $OTRSUSER -d /opt/otrs/ -s /bin/bash -g apache -c 'OTRS System User' && echo "$OTRSUSER added."
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
echo "[httpd services]"
echo " Restart httpd 'service httpd restart'"
echo ""
echo "[install the OTRS database]"
echo " Make sure your database server is running."
echo " Use a web browser and open this link:"
echo " http://$HOST/otrs/installer.pl"
echo ""
echo "((enjoy))"
echo ""
echo " Your OTRS Team"
echo ""

%clean
rm -rf $RPM_BUILD_ROOT

%files
%config /etc/httpd/conf.d/zzz_otrs.conf

%config(noreplace) /opt/otrs/Kernel/Config.pm
%config(noreplace) /opt/otrs/.procmailrc
%config(noreplace) /opt/otrs/.fetchmailrc
%config(noreplace) /opt/otrs/.mailfilter

%dir /opt/otrs/
/opt/otrs/RELEASE
/opt/otrs/ARCHIVE
/opt/otrs/.bash_completion
/opt/otrs/.procmailrc.dist
/opt/otrs/.fetchmailrc.dist
/opt/otrs/.mailfilter.dist

%dir /opt/otrs/Custom/
/opt/otrs/Custom/README

%dir /opt/otrs/Kernel/

%dir /opt/otrs/Kernel/Config/
/opt/otrs/Kernel/Config.pm.dist
/opt/otrs/Kernel/Config/Files/
/opt/otrs/Kernel/Config/Defaults.pm

/opt/otrs/Kernel/GenericInterface*

/opt/otrs/Kernel/Language.pm
%dir /opt/otrs/Kernel/Language/
/opt/otrs/Kernel/Language/*.pm

/opt/otrs/bin*
/opt/otrs/Kernel/Modules*
/opt/otrs/Kernel/Output*
/opt/otrs/Kernel/System*
/opt/otrs/scripts*
/opt/otrs/i18n/otrs/*

%dir /opt/otrs/var/
%dir /opt/otrs/var/article/
/opt/otrs/var/fonts/
/opt/otrs/var/httpd/
/opt/otrs/var/logo-otrs.png
%dir /opt/otrs/var/cron/
%dir /opt/otrs/var/log/
%dir /opt/otrs/var/sessions/
%dir /opt/otrs/var/spool/
/opt/otrs/var/cron/*
%dir /opt/otrs/var/tmp/
%dir /opt/otrs/var/stats/
/opt/otrs/var/stats/*.xml
/opt/otrs/var/processes/examples/*.yml

/opt/otrs/Kernel/cpan-lib*

%doc /opt/otrs/*.md
%doc /opt/otrs/COPYING
%doc /opt/otrs/COPYING-Third-Party
%doc /opt/otrs/doc*
