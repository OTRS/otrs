# --
# RPM spec file for SuSE Linux of the OpenTRS package
# Copyright (C) 2002 Martin Edenhofer <bugs+rpm@otrs.org>
# --
# $Id: suse-otrs.spec,v 1.4 2002-01-30 21:57:28 martin Exp $
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
Version:      1.0
Copyright:    GNU GENERAL PUBLIC LICENSE Version 2, June 1991
Group:        Applications/Mail
Provides:     otrs 
Requires:     perl perl-DBI perl-Date-Calc perl-GD perl-MIME-Base64 perl-MailTools perl-MIME-Lite perl-MIME-tools perl-Net-DNS perl-Syslog perl-Digest-MD5 apache mod_perl mysql mysql-client perl-Msql-Mysql-modules mysql-shared
Autoreqprov:  on
Release:      BETA1
Source0:      otrs-%{version}-%{release}.tar.gz
BuildRoot:    /var/tmp/%{name}-buildroot


%description
The Open Ticket Request System (http://otrs.org/) is a web based ticket system.

Feedback: feedback@otrs.org

Authors:
--------
    Stefan Wintermeyer <stefan+rpm@otrs.org>
    Martin Edenhofer <martin+rpm@otrs.org>

SuSE series: n


%prep
%setup -n otrs
# remove CVS dirs
find . -name CVS | xargs rm -rf
# remove old sessions, articles and spool
rm -f var/sessions/*
rm -rf var/article/*
rm -rf var/spool/*


%build
# nothing


%install
# delete old RPM_BUILD_ROOT
rm -rf $RPM_BUILD_ROOT
# set DESTROOT
export DESTROOT="/opt/OpenTRS/"
# create RPM_BUILD_ROOT DESTROOT
mkdir -p $RPM_BUILD_ROOT/$DESTROOT/
# copy files
cp -R . $RPM_BUILD_ROOT/$DESTROOT
# Install init-Script and rc.config entry
install -d -m 755 $RPM_BUILD_ROOT/etc/init.d
install -d -m 755 $RPM_BUILD_ROOT/usr/sbin
install -d -m 744 $RPM_BUILD_ROOT/var/adm/fillup-templates
install -m 644 scripts/suse-fillup-template-rc.config.otrs $RPM_BUILD_ROOT/var/adm/fillup-templates/rc.config.otrs
install -m 755 scripts/suse-rcotrs $RPM_BUILD_ROOT/etc/init.d/otrs
rm -f $RPM_BUILD_ROOT/sbin/otrs
ln -s ../../etc/init.d/otrs $RPM_BUILD_ROOT/usr/sbin/rcotrs


%post
# rpm -i
export OTRSUSER=otrs
export OTRSDEST=/opt/OpenTRS
# useradd
echo -n "Check OpenTRS user (/etc/passwd)... " 
if cat /etc/passwd | grep $OTRSUSER > /dev/null ; then 
    echo "$OTRSUSER exists."
else
    useradd $OTRSUSER -d /opt/OpenTRS/ -s /bin/false && echo "$OTRSUSER added."
fi
# set permission
echo -n "Setting file permissions... "
if chown -R root $OTRSDEST && chown -R $OTRSUSER $OTRSDEST/var/ ; then 
    echo "(chown -R root $OTRSDEST && chown -R $OTRSUSER $OTRSDEST/var/) "
fi
# rc.config
sbin/insserv etc/init.d/otrs
echo "Updating etc/rc.config..."
if [ -x bin/fillup ] ; then
  bin/fillup -q -d = etc/rc.config var/adm/fillup-templates/rc.config.otrs
else
  echo "ERROR: fillup not found. This should not happen. Please compare"
  echo "/etc/rc.config and /var/adm/fillup-templates/rc.config.mysql and update by hand."
fi
# note
echo "Note: You have to create a MySQL database and tables (see README.database "
echo " or follow the short setup description)"
echo ""
echo "[short database setup]"
echo " Create a database:"
echo "  shell> mysql -u root -p -e 'create database OpenTRS'"
echo " Create the OpenTRS tables"
echo "  shell> mysql -u root -p OpenTRS < /usr/share/doc/packages/otrs/install/database/OpenTRS-schema.sql"
echo " Insert inital data:"
echo "  shell> mysql -u root -p OpenTRS < /usr/share/doc/packages/otrs/install/database/initial_insert.sql"
echo " Create an database user:"
echo "  shell> mysql -u root -p -e 'GRANT ALL PRIVILEGES ON OpenTRS.* TO otrs@localhost " 
echo "     IDENTIFIED BY \"some_pass\" WITH GRANT OPTION;'"
echo ""
echo "[OpenTRS services]"
echo " use rcotrs {start|stop|status|restart} to manage your OpenTRS system."
echo ""
echo "Have fun!"
echo ""
echo " Your OpenTRS Team"
echo ""

%postun
# rpm -e
export OTRSUSER=otrs
if userdel $OTRSUSER ; then 
    echo "Delete OpenTRS user ($OTRSUSER) ... done"
else 
    echo "Delete OpenTRS user ($OTRSUSER) ... faild"
fi
# 
sbin/insserv etc/init.d/

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%config(noreplace) /opt/OpenTRS/Kernel/Config.pm
%config(noreplace) /opt/OpenTRS/var/log/TicketCounter.log
%config(noreplace) /opt/OpenTRS/.procmailrc

/etc/init.d/otrs
/usr/sbin/rcotrs

/opt/OpenTRS/Kernel/Language.pm
/opt/OpenTRS/Kernel/Language/*
/opt/OpenTRS/Kernel/Modules/*
/opt/OpenTRS/Kernel/Output/*
/opt/OpenTRS/Kernel/System/*
/opt/OpenTRS/bin/*
/opt/OpenTRS/scripts/*
/opt/OpenTRS/var/article/
/opt/OpenTRS/var/httpd/*
/opt/OpenTRS/var/sessions/
/opt/OpenTRS/var/spool/

/var/adm/fillup-templates/rc.config.otrs

%doc INSTALL TODO COPYING READM* doc/* install*


%changelog 
* Wed Jan 30 2002 - martin+rpm@otrs.org
- added to useradd bash=/bin/false
* Sat Jan 12 2002 - martin+rpm@otrs.org
- added SuSE like rc scripts
* Tue Jan 10 2002 - martin+rpm@otrs.org 
- new package created

