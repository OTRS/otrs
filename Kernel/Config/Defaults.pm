# --
# Kernel/Config/Defaults.pm - Default Config file for OTRS kernel
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Defaults.pm,v 1.226 2006-02-06 05:49:27 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
#
#  Note:
#    -->> Don't edit this file! Copy your needed settings into
#     Kernel/Config.pm. Kernel/Config.pm will not be updated. <<--
#
#   -->> All changes of this file will be lost after an update! <<--
#
#  Attention:
#   -->> Ticket Settings are in Kernel/Config/Files/Ticket.pm <<--
# --
package Kernel::Config::Defaults;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.226 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub LoadDefaults {
    my $Self = shift;

    # --------------------------------------------------- #
    # system data                                         #
    # --------------------------------------------------- #
    # SecureMode
    # (Enable this so you can't use the installer.pl)
    $Self->{SecureMode} = 0;

    # SystemID
    # (The identify of the system. Each ticket number and
    # each http session id starts with this number)
    $Self->{SystemID} = 10;

    # FQDN
    # (Full qualified domain name of your system.)
    $Self->{FQDN} = 'yourhost.example.com';

    # HttpType
    # In case you use https instead of plain http specify it here
    $Self->{HttpType} = 'http';

    # ScriptAlias
    # Prefix to index.pl used as ScriptAlias in web config
    # (Used when emailing links to agents).
    $Self->{ScriptAlias} = 'otrs/';

    # AdminEmail
    # (Email of the system admin.)
    $Self->{AdminEmail} = 'admin@example.com';

    # Organization
    # (If this is anything other than '', then the email will have an
    # Organization X-Header)
#    $Self->{Organization} = 'Example Company';
    $Self->{Organization} = '';

    # ProductName
    # (Shown application name in frontend.)
    $Self->{ProductName} = 'OTRS';

    # --------------------------------------------------- #
    # database settings                                   #
    # --------------------------------------------------- #
    # DatabaseHost
    # (The database host.)
    $Self->{DatabaseHost} = 'localhost';

    # Database
    # (The database name.)
    $Self->{Database} = 'otrs';

    # DatabaseUser
    # (The database user.)
    $Self->{DatabaseUser} = 'otrs';

    # DatabasePw
    # (The password of database user.)
    $Self->{DatabasePw} = 'some-pass';

    # DatabaseDSN
    # (The database DSN for MySQL ==> more: "man DBD::mysql")
    $Self->{DatabaseDSN} = "DBI:mysql:database=<OTRS_CONFIG_Database>;host=<OTRS_CONFIG_DatabaseHost>;";

    # (The database DSN for PostgrSQL ==> more: "man DBD::Pg")
#    $Self->{DatabaseDSN} = "DBI:Pg:dbname=<OTRS_CONFIG_Database>;host=<OTRS_CONFIG_DatabaseHost>;";

    # (The database DSN for DBI:ODBC ==> more: "man DBD::ODBC")
#    $Self->{DatabaseDSN} = "DBI:ODBC:$Self->{Database}";
    # If you use ODBC, no database auto detection is possible,
    # so set the database type here. Possible: mysq,postgresql,sapdb
#    $Self->{'Database::Type'} = 'sapdb';

    # (The database DSN for Oracle ==> more: "man DBD::oracle")
#    $Self->{DatabaseDSN} = "DBI:Oracle:sid=$Self->{Database};host=$Self->{DatabaseHost};port=1521;";
#    $Self->{DatabaseDSN} = "DBI:Oracle:sid=vingador;host=vingador;port=1521;";
    # if needed, oracle env settings
#    $ENV{ORACLE_HOME} = '/opt/ora9/product/9.2';
#    $ENV{ORACLE_HOME} = '/oracle/Ora92';
#    $ENV{NLS_DATE_FORMAT} = 'YYYY-MM-DD HH24:MI:SS';
#    $ENV{NLS_LANG} = "german_germany.we8iso8859p15";
#    $ENV{NLS_LANG} = "american_america.we8iso8859p1";

    # --------------------------------------------------- #
    # default values                                      #
    # (default values for GUIs)                           #
    # --------------------------------------------------- #
    # default valid
    $Self->{DefaultValid} = 'valid';
    # default charset
    # (default frontend charset - "utf-8" is a multi chatset for all possible
    # charsets - e. g. "iso-8859-1" is also possible for single charset)
    # [default: iso-8859-1]
    $Self->{DefaultCharset} = 'iso-8859-1';
#    $Self->{DefaultCharset} = 'utf-8';
    # default langauge
    # (the default frontend langauge) [default: en]
    $Self->{DefaultLanguage} = 'en';
    # used langauges
    # (short name = long name and file)
    $Self->{DefaultUsedLanguages} = {
#            bb => 'Bavarian',
            en => 'English',
            de => 'Deutsch',
            nl => 'Nederlands',
            fr => 'Fran&ccedil;ais',
            bg => 'Bulgarian',
            fi => 'Suomi',
            es => 'Espa&ntilde;ol',
            pt_BR => 'Portugu&ecirc;s Brasileiro',
            pt => 'Portugu&ecirc;s',
            it => 'Italiano',
            ru => 'Russian',
            cz => 'Czech',
            pl => 'Polski',
            nb_NO => 'Norsk bokm&aring;l',
            sv => 'Svenska',
            hu => 'Hungarian',
            zh_CN => 'Traditional Chinese',
#            th => 'Thai',
#            da => 'Dansk',
#            ro => 'Romanian',
#            hr => 'Croatian',
#            sk => 'Slovak',
#            sl => 'Slovenian',
#            tr => 'tr',
#            jp => 'jp',
    };
    # default theme
    # (the default html theme) [default: Standard]
    $Self->{DefaultTheme} = 'Standard';

    # DefaultTheme::HostBased
    # (set theme based on host name)
#    $Self->{'DefaultTheme::HostBased'} = {
#        'host1\.example\.com' => 'SomeTheme1',
#        'host2\.example\.com' => 'SomeTheme1',
#    };

    # DefaultViewNewLine
    # (insert new line in text messages after max x chars and
    # the next word)
    $Self->{DefaultViewNewLine} = 85;

    # DefaultPreViewLines
    # (Max viewable lines in pre view text messages (like ticket
    # lines in the QueueView)
    $Self->{DefaultPreViewLines} = 18;

    # DefaultViewLines
    # (Max viewable lines in text messages (like ticket lines
    # in QueueZoom)
    $Self->{DefaultViewLines} = 6000;

    # ShowAlwaysLongTime
    # (show always time in long /days hours minutes/ or short
    # /days hours/ format)
    $Self->{ShowAlwaysLongTime} = 0;
    $Self->{TimeShowAlwaysLong} = 0;

    # TimeInputFormat
    # (default date input format) [Option|Input]
    $Self->{TimeInputFormat} = 'Option';

    # AttachmentDownloadType
    # (if the tickets attachments will be opened in browser or just to
    # force the download) [attachment|inline]
#    $Self->{'AttachmentDownloadType'} = 'inline';
    $Self->{'AttachmentDownloadType'} = 'attachment';

    # --------------------------------------------------- #
    # Check Settings
    # --------------------------------------------------- #
    # CheckEmailAddresses
    # (Check syntax of used email addresses)
    $Self->{CheckEmailAddresses} = 1;

    # CheckMXRecord
    # (Check mx recorde of used email addresses)
    $Self->{CheckMXRecord} = 1;

    # CheckEmailValidAddress
    # (regexp of valid email addresses)
    $Self->{CheckEmailValidAddress} = '^(root@localhost|admin@localhost)$';

    # CheckEmailInvalidAddress
    # (regexp of invalid email addresses)
    $Self->{CheckEmailInvalidAddress} = '@(aa|aaa|aaaa|aaaaa|abc|any|anywhere|anonymous|bar|demo|example|foo|hello|hallo|me|nospam|nowhere|null|some|somewhere|test|teste.|there|user|xx|xxx|xxxx)\.(..|...)$';

    # --------------------------------------------------- #
    # LogModule                                           #
    # --------------------------------------------------- #
    # (log backend module)
    $Self->{'LogModule'} = 'Kernel::System::Log::SysLog';
#    $Self->{'LogModule'} = 'Kernel::System::Log::File';

    # param for LogModule Kernel::System::Log::SysLog
#    $Self->{'LogModule::SysLog::Facility'} = 'user';

    # param for LogModule Kernel::System::Log::SysLog
    # (if syslog can't work with utf-8, force the log
    # charset with this option, on other chars will be
    # replaces with ?)
    $Self->{'LogModule::SysLog::Charset'} = 'iso-8859-15';
#    $Self->{'LogModule::SysLog::Charset'} = 'utf-8';

    # param for LogModule Kernel::System::Log::File (required!)
    $Self->{'LogModule::LogFile'} = '/tmp/otrs.log';

    # param if the date (yyyy-mm) should be added as suffix to
    # logfile [0|1]
#    $Self->{'LogModule::LogFile::Date'} = 0;

    # system log cache size for admin system log (default 4k)
    # Note: use bin/CleanUp.pl before you change this
#    $Self->{'LogSystemCacheSize'} = 4*1024;

    # --------------------------------------------------- #
    # SendmailModule
    # --------------------------------------------------- #
    # (Where is sendmail located and some options.
    # See 'man sendmail' for details. Or use the SMTP backend.)
    $Self->{'SendmailModule'} = 'Kernel::System::Email::Sendmail';
    $Self->{'SendmailModule::CMD'} = '/usr/sbin/sendmail -i -f ';

#    $Self->{'SendmailModule'} = 'Kernel::System::Email::SMTP';
#    $Self->{'SendmailModule::Host'} = 'mail.example.com';
#    $Self->{'SendmailModule::Port'} = '25';
#    $Self->{'SendmailModule::AuthUser'} = '';
#    $Self->{'SendmailModule::AuthPassword'} = '';

    # SendmailBcc
    # (Send all outgoing email via bcc to...
    # Warning: use it only for external archive funktions)
    $Self->{'SendmailBcc'} = '';

    # SendmailNotificationEnvelopeFrom
    # Set a email address that is used as envelope from header in outgoing
    # notifications
#    $Self->{'SendmailNotificationEnvelopeFrom'} = '';

    # --------------------------------------------------- #
    # authentication settings                             #
    # (enable what you need, auth against otrs db,        #
    # against LDAP directory, agains HTTP basic auth      #
    # or against Radius server)                           #
    # --------------------------------------------------- #
    # This is the auth. module againt the otrs db
    $Self->{'AuthModule'} = 'Kernel::System::Auth::DB';

    # This is an example configuration for an LDAP auth. backend.
    # (take care that Net::LDAP is installed!)
#    $Self->{'AuthModule'} = 'Kernel::System::Auth::LDAP';
#    $Self->{'AuthModule::LDAP::Host'} = 'ldap.example.com';
#    $Self->{'AuthModule::LDAP::BaseDN'} = 'dc=example,dc=com';
#    $Self->{'AuthModule::LDAP::UID'} = 'uid';

    # Check if the user is allowed to auth in a posixGroup
    # (e. g. user needs to be in a group xyz to use otrs)
#    $Self->{'AuthModule::LDAP::GroupDN'} = 'cn=otrsallow,ou=posixGroups,dc=example,dc=com';
#    $Self->{'AuthModule::LDAP::AccessAttr'} = 'memberUid';
    # for ldap posixGroups objectclass (just uid)
#    $Self->{'AuthModule::LDAP::UserAttr'} = 'UID';
    # for non ldap posixGroups objectclass (with full user dn)
#    $Self->{'AuthModule::LDAP::UserAttr'} = 'DN';

    # The following is valid but would only be necessary if the
    # anonymous user do NOT have permission to read from the LDAP tree
#    $Self->{'AuthModule::LDAP::SearchUserDN'} = '';
#    $Self->{'AuthModule::LDAP::SearchUserPw'} = '';

    # in case you want to add always one filter to each ldap query, use
    # this option. e. g. AlwaysFilter => '(mail=*)' or AlwaysFilter => '(objectclass=user)'
#   $Self->{'AuthModule::LDAP::AlwaysFilter'} = '';

    # in case you want to add a suffix to each login name, then
    # you can use this option. e. g. user just want to use user but
    # in your ldap directory exists user@domain.
#    $Self->{'AuthModule::LDAP::UserSuffix'} = '@domain.com';

    # Net::LDAP new params (if needed - for more info see perldoc Net::LDAP)
#    $Self->{'AuthModule::LDAP::Params'} = {
#        port => 389,
#        timeout => 120,
#        async => 0,
#        version => 3,
#    };

    # This is an example configuration for an apache ($ENV{REMOTE_USER})
    # auth. backend. Use it if you want to have a singe login through
    # apache http-basic-auth
#   $Self->{'AuthModule'} = 'Kernel::System::Auth::HTTPBasicAuth';
    # Note:
    # If you use this module, you should use as fallback the following
    # config settings if user isn't login through apache ($ENV{REMOTE_USER})
#   $Self->{LoginURL} = 'http://host.example.com/not-authorised-for-otrs.html';
#   $Self->{LogoutURL} = 'http://host.example.com/thanks-for-using-otrs.html';

    # This is example configuration to auth. agents against a radius server
#    $Self->{'AuthModule'} = 'Kernel::System::Auth::Radius';
#    $Self->{'AuthModule::Radius::Host'} = 'radiushost';
#    $Self->{'AuthModule::Radius::Password'} = 'radiussecret';

    # UserSyncLDAPMap
    # (map if agent should create/synced from LDAP to DB after login)
#    $Self->{UserSyncLDAPMap} = {
#        # DB -> LDAP
#        Firstname => 'givenName',
#        Lastname => 'sn',
#        Email => 'mail',
#    };
    # UserSyncLDAPGroups
    # (If "LDAP" was selected for AuthModule, you can specify inital
    # user groups for first login.)
#    $Self->{UserSyncLDAPGroups} = [
#        'users',
#    ];

    # UserTable
    $Self->{DatabaseUserTable} = 'system_user';
    $Self->{DatabaseUserTableUserID} = 'id';
    $Self->{DatabaseUserTableUserPW} = 'pw';
    $Self->{DatabaseUserTableUser} = 'login';

    # --------------------------------------------------- #
    # URL login and logout settings                       #
    # --------------------------------------------------- #

    # LoginURL
    # (If this is anything other than '', then it is assumed to be the
    # URL of an alternate login screen which will be used in place of
    # the default one.)
#    $Self->{LoginURL} = '';
#    $Self->{LoginURL} = 'http://host.example.com/cgi-bin/login.pl';

    # LogoutURL
    # (If this is anything other than '', it is assumed to be the URL
    # of an alternate logout page which users will be sent to when they
    # logout.)
#    $Self->{LogoutURL} = '';
#    $Self->{LogoutURL} = 'http://host.example.com/cgi-bin/login.pl';

    # PreApplicationModule
    # (Used for every request, if defined, the PreRun() function of
    # this module will be used. This interface use useful to check
    # some user options or to redirect not accept new application
    # news)
#    $Self->{PreApplicationModule}->{AgentInfo} = 'Kernel::Modules::AgentInfo';
    # Kernel::Modules::AgentInfo check key, if this user preferences key
    # is true, then the message is already accepted
#    $Self->{InfoKey} = 'wpt22';
    # shown InfoFile located under Kernel/Output/HTML/Standard/AgentInfo.dtl
#    $Self->{InfoFile} = 'AgentInfo';

    # --------------------------------------------------- #
    # Notification Settings
    # --------------------------------------------------- #
    # agent interface notification module to check the used charset
    $Self->{'Frontend::NotifyModule'}->{'1-CharsetCheck'} = {
        Module => 'Kernel::Output::HTML::NotificationCharsetCheck',
    };
    # agent interface notification module to check the admin user id
    # (don't work with user id 1 notification)
    $Self->{'Frontend::NotifyModule'}->{'2-UID-Check'} = {
        Module => 'Kernel::Output::HTML::NotificationUIDCheck',
    };
    # show online agents
#    $Self->{'Frontend::NotifyModule'}->{'3-ShowAgentOnline'} = {
#        Module => 'Kernel::Output::HTML::NotificationAgentOnline',
#    };
    # show online customers
#    $Self->{'Frontend::NotifyModule'}->{'4-ShowCustomerOnline'} = {
#        Module => 'Kernel::Output::HTML::NotificationCustomerOnline',
#    };

    # --------------------------------------------------- #
    # Frontend::Output::PostFilter
    # --------------------------------------------------- #
    # Frontend::Output::PostFilter
    # (a output filter for application html output, e. g. to filter
    # java script, java applets, ...)
#    $Self->{'Frontend::Output::PostFilter'}->{'ActiveElementFilter'} = {
#        Module => 'Kernel::Output::HTML::OutputFilterActiveElement',
#        Debug => 0,
#    };

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                   Session stuff                     #
    #                                                     #
    # --------------------------------------------------- #

    # --------------------------------------------------- #
    # SessionModule                                       #
    # --------------------------------------------------- #
    # (How should be the session-data stored?
    # Advantage of DB is that you can split the
    # Frontendserver from the db-server. fs or ipc is faster.)
    $Self->{SessionModule} = 'Kernel::System::AuthSession::DB';
#    $Self->{SessionModule} = 'Kernel::System::AuthSession::FS';
#    $Self->{SessionModule} = 'Kernel::System::AuthSession::IPC';

    # SessionName
    # (Name of the session key. E. g. Session, SessionID, OTRS)
    $Self->{SessionName} = 'Session';

    # SessionCheckRemoteIP
    # (If the application is used via a proxy-farm then the
    # remote ip address is mostly different. In this case,
    # turn of the CheckRemoteID. ) [1|0]
    $Self->{SessionCheckRemoteIP} = 1;

    # SessionDeleteIfNotRemoteID
    # (Delete session if the session id is used with an
    # invalied remote IP?) [0|1]
    $Self->{SessionDeleteIfNotRemoteID} = 1;

    # SessionMaxTime
    # (Max valid time of one session id in second (8h = 28800).)
    $Self->{SessionMaxTime} = 10*60*60;

    # SessionMaxIdleTime
    # (After this time (in seconds) without new http request, then
    # the user get logged off)
    $Self->{SessionMaxIdleTime} = 5*60*60;

    # SessionDeleteIfTimeToOld
    # (Delete session's witch are requested and to old?) [0|1]
    $Self->{SessionDeleteIfTimeToOld} = 1;

    # SessionUseCookie
    # (Should the session management use html cookies?
    # It's more comfortable to send links -==> if you have a valid
    # session, you don't have to login again.) [0|1]
    # Note: If the client browser disabled html cookies, the system
    # will work as usual, append SessionID to links!
    $Self->{SessionUseCookie} = 1;

    # SessionUseCookieAfterBrowserClose
    # (store cookies in browser after closing a browser) [0|1]
    $Self->{SessionUseCookieAfterBrowserClose} = 0;

    # SessionDir
    # directory for all sessen id informations (just needed if
    # $Self->{SessionModule}='Kernel::System::AuthSession::FS)
    $Self->{SessionDir} = '<OTRS_CONFIG_Home>/var/sessions';

    # SessionTable*
    # (just needed if $Self->{SessionModule}='Kernel::System::AuthSession::DB)
    # SessionTable
    $Self->{SessionTable} = 'sessions';
    # SessionTable id column
    $Self->{SessionTableID} = 'session_id';
    # SessionTable value column
    $Self->{SessionTableValue} = 'session_value';

    # --------------------------------------------------- #
    # Time Settings
    # --------------------------------------------------- #
    # TimeZone
    # (set the system time zone, default is local time)
#    $Self->{'TimeZone'} = 0;

    # Time*
    # (Used for ticket age, escalation and system unlock calculation)

    # TimeWorkingHours
    # (counted hours for working time used)
    $Self->{'TimeWorkingHours'} = {
        Mon => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Tue => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Wed => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Thu => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Fri => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Sat => [  ],
        Sun => [  ],
    };

    # TimeVacationDays
    # adde new days with:
    # "$Self->{TimeVacationDays}->{10}->{27} = 'Some Info';"

    $Self->{'TimeVacationDays'} = {
        1 => {
            1 => 'New Year\'s Eve!',
        },
        5 => {
            1 => '1 St. May',
        },
        12 => {
            24 => 'Christmas',
            25 => 'First Christmas Day',
            26 => 'Second Christmas Day',
            31 => 'Silvester',
        },
    };

    # TimeVacationDaysOneTime
    # adde new own days with:
    # "$Self->{'TimeVacationDaysOneTime'}->{1977}-{10}->{27} = 'Some Info';"

    $Self->{'TimeVacationDaysOneTime'} = {
#        2004 => {
#            6 => {
#                7 => 'Some Day',
#            },
#            12 => {
#                24 => 'Some A Day',
#                31 => 'Some B Day',
#            },
#        },
#        2005 => {
#            1 => {
#                11 => 'Some Day',
#            },
#        },
    };

    # --------------------------------------------------- #
    # Web Settings
    # --------------------------------------------------- #
    # WebMaxFileUpload
    # (Max size for browser file uploads - default 5 MB)
    $Self->{WebMaxFileUpload} = 1024 * 1024 * 5;

    # WebUploadCacheModule
    # (select you WebUploadCacheModule module, default DB [DB|FS])
    $Self->{WebUploadCacheModule} = 'Kernel::System::Web::UploadCache::DB';
#    $Self->{WebUploadCacheModule} = 'Kernel::System::Web::UploadCache::FS';

    # CGILogPrefix
    $Self->{CGILogPrefix} = 'OTRS-CGI';

    # --------------------------------------------------- #
    # Agent Web Interface
    # --------------------------------------------------- #
    # LostPassword
    # (use lost password feature)
    $Self->{LostPassword} = 1;

    # ShowMotd
    # (show message of the day in login screen)
    $Self->{ShowMotd} = 0;

    # DemoSystem
    # (If this is true, no agent preferences, like language and theme, via agent
    # frontend can be updated! Just for the current session. Alow no password can
    # be changed on agent frontend.)
    $Self->{DemoSystem} = 0;

    # SwitchToUser
    # (Allow the admin to switch into a selected user session.)
    $Self->{SwitchToUser} = 0;

    # --------------------------------------------------- #
    # MIME-Viewer for online to html converter
    # --------------------------------------------------- #
    # (e. g. xlhtml (xls2html), http://chicago.sourceforge.net/xlhtml/)
#    $Self->{'MIME-Viewer'}->{'application/excel'} = 'xlhtml';
    # MIME-Viewer for online to html converter
    # (e. g. wv (word2html), http://wvware.sourceforge.net/)
#    $Self->{'MIME-Viewer'}->{'application/msword'} = 'wvWare';
    # (e. g. pdftohtml (pdf2html), http://pdftohtml.sourceforge.net/)
#    $Self->{'MIME-Viewer'}->{'application/pdf'} = 'pdftohtml -stdout -i';
    # (e. g. xml2html (xml2html))
#    $Self->{'MIME-Viewer'}->{'text/xml'} = $Self->{Home}.'/scripts/tools/xml2html.pl';

    # --------------------------------------------------- #
    # SpellChecker
    # --------------------------------------------------- #
    # (If ispell or aspell is available, then we will provide a spelling
    # checker.)
#    $Self->{SpellChecker} = 0;
    $Self->{SpellChecker} = 1;
    $Self->{SpellCheckerBin} = '/usr/bin/ispell';
    $Self->{SpellCheckerDictDefault} = 'english';

    # SpellCheckerIgnore
    # (A list of ignored words.)
    $Self->{SpellCheckerIgnore} = ['www', 'webmail', 'https', 'http', 'html', 'rfc'];

    # --------------------------------------------------- #
    # directories                                         #
    # --------------------------------------------------- #
    # root directory
    $Self->{'Home'} = '/opt/otrs';
    # tmp dir
    $Self->{'TempDir'} = '<OTRS_CONFIG_Home>/var/tmp';
    # html template dir
    $Self->{'TemplateDir'} = '<OTRS_CONFIG_Home>/Kernel/Output';

    # --------------------------------------------------- #
    #                                                     #
    #            package management options               #
    #                                                     #
    # --------------------------------------------------- #

    # Package::RepositoryRoot
    # (get online repository list, use the fist availabe result)
    $Self->{'Package::RepositoryRoot'} = [
        'http://ftp.otrs.org/pub/otrs/misc/packages/repository.xml',
        'http://otrs.org/repository.xml',
    ];

    # Package::RepositoryList
    # (repository list)
    $Self->{'Package::RepositoryList'} = {
#        'ftp://ftp.example.com/pub/otrs/misc/packages/' => '[Example] ftp://ftp.example.com/',
    };

    # Package::Timeout
    # (http/ftp timeout to get packages)
    $Self->{'Package::Timeout'} = 12;

    # Package::Proxy
    # (fetch packages via proxy)
#    $Self->{'Package::Proxy'} = 'http://proxy.sn.no:8001/';

    # --------------------------------------------------- #
    # PGP settings (supports gpg)                         #
    # --------------------------------------------------- #
    $Self->{'PGP'} = 0;
    $Self->{'PGP::Bin'} = '/usr/bin/gpg';
    $Self->{'PGP::Options'} = '--homedir /opt/otrs/.gnupg/ --batch --no-tty --yes';
#    $Self->{'PGP::Options'} = '--batch --no-tty --yes';
#    $Self->{'PGP::Key::Password'}->{'D2DF79FA'} = 1234;
#    $Self->{'PGP::Key::Password'}->{'488A0B8F'} = 1234;

    # --------------------------------------------------- #
    # S/MIME settings (supports smime)                    #
    # --------------------------------------------------- #
    $Self->{'SMIME'} = 0;
    # maybe openssl need a HOME env!
    #$ENV{HOME} = '/var/lib/wwwrun';
    $Self->{'SMIME::Bin'} = '/usr/bin/openssl';
#    $Self->{'SMIME::CertPath'} = '/etc/ssl/certs';
#    $Self->{'SMIME::PrivatePath'} = '/etc/ssl/private';

    # --------------------------------------------------- #
    # system permissions
    # --------------------------------------------------- #
    $Self->{'System::Permission'} = ['ro', 'rw'];
    $Self->{'System::Customer::Permission'} = ['ro', 'rw'];

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 Preferences stuff                   #
    #                                                     #
    # --------------------------------------------------- #

    # PreferencesTable*
    # (Stored preferences table data.)
    $Self->{PreferencesTable} = 'user_preferences';
    $Self->{PreferencesTableKey} = 'preferences_key';
    $Self->{PreferencesTableValue} = 'preferences_value';
    $Self->{PreferencesTableUserID} = 'user_id';

    # PreferencesView
    # (Order of shown items)
    $Self->{PreferencesView} = ['Frontend', 'Mail Management', 'Other Options'];

    $Self->{PreferencesGroups}->{Password} = {
        Module => 'Kernel::Output::HTML::PreferencesPassword',
        Colum => 'Other Options',
        Label => 'Change Password',
        Prio => 1000,
        Area => 'Agent',
        PasswordHistory => 0,
#        PasswordRegExp => '[a-z]|[A-z]|[0-9]|\.|;|,|:|-|\+|#|!|\$|&|\?',
        PasswordRegExp => '',
        PasswordMinSize => 0,
        PasswordMin2Lower2UpperCharacters => 0,
        PasswordMin2Characters => 0,
        PasswordNeedDigit => 0,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{SpellDict} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Other Options',
        Label => 'Spelling Dictionary',
        Desc => 'Select your default spelling dictionary.',
        Data => {
            # installed dict catalog (check your insalled catalogues, e. g. deutsch -=> german!)
            # dict => frontend (ispell)
            'english' => 'English',
            'deutsch' => 'Deutsch',
            # dict => frontend (aspell)
#            'english' => 'English',
#            'german' => 'Deutsch',
        },
        PrefKey => 'UserSpellDict',
        Prio => 5000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Comment} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Other Options',
        Label => 'Comment',
        Desc => 'Comment',
        Block => 'Input',
        Data => '$Env{"UserComment"}',
        PrefKey => 'UserComment',
        Prio => 6000,
        Activ => 0,
    };

#    $Self->{PreferencesGroups}->{FreeText} = {
#        Module => 'Kernel::Output::HTML::PreferencesGeneric',
#        Colum => 'Other Options',
#        Label => 'Free Text',
#        Desc => 'Example for free text.',
#        Block => 'Input',
#        Data => '$Env{"UserFreeText"}',
#        PrefKey => 'UserFreeText',
#        Prio => 7000,
#        Activ => 1,
#    };

    $Self->{PreferencesGroups}->{Language} = {
        Module => 'Kernel::Output::HTML::PreferencesLanguage',
        Colum => 'Frontend',
        Label => 'Language',
        Desc => 'Select your frontend language.',
        PrefKey => 'UserLanguage',
        Prio => 1000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Theme} = {
        Module => 'Kernel::Output::HTML::PreferencesTheme',
        Colum => 'Frontend',
        Label => 'Theme',
        Desc => 'Select your frontend Theme.',
        PrefKey => 'UserTheme',
        Prio => 2000,
        Activ => 1,
    };

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 Notification stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # --
    # notification sender
    # --
    $Self->{NotificationSenderName} = 'OTRS Notification Master';
    $Self->{NotificationSenderEmail} = 'otrs@<OTRS_CONFIG_FQDN>';

    # --
    # notification email for new password
    # --
    $Self->{NotificationSubjectLostPassword} = 'New OTRS Password!';
    $Self->{NotificationBodyLostPassword} = "
Hi <OTRS_USERFIRSTNAME>,

you or someone impersonating you has requested to change your OTRS
password.

New Password: <OTRS_NEWPW>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl

Your OTRS Notification Master
";

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                CustomerPanel stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # SessionName
    # (Name of the session key. E. g. Session, SessionID, OTRS)
    $Self->{CustomerPanelSessionName} = 'CSID';

    # CustomerPanelUserID
    # (The customer panel db-uid.) [default: 1]
    $Self->{CustomerPanelUserID} = 1;

    # CustomerGroupSupport (0 = compat. to OTRS 1.1 or lower)
    # (if this is 1, the you need to set the group <-> customer user
    # relations! http://host/otrs/index.pl?Action=AdminCustomerUserGroup
    # otherway, each user is ro/rw in each group!)
    $Self->{CustomerGroupSupport} = 0;

    # CustomerGroupAlwaysGroups
    # (if CustomerGroupSupport is true and you don't want to manage
    # each customer user for this groups, then put the groups
    # for all customer user in there)
    $Self->{CustomerGroupAlwaysGroups} = ['users', 'info'];

    # show online agents
#    $Self->{'CustomerFrontend::NotifyModule'}->{'1-ShowAgentOnline'} = {
#        Module => 'Kernel::Output::HTML::NotificationAgentOnline',
#    };

    # --------------------------------------------------- #
    # login and logout settings                           #
    # --------------------------------------------------- #
    # CustomerPanelLoginURL
    # (If this is anything other than '', then it is assumed to be the
    # URL of an alternate login screen which will be used in place of
    # the default one.)
#    $Self->{CustomerPanelLoginURL} = '';
#    $Self->{CustomerPanelLoginURL} = 'http://host.example.com/cgi-bin/login.pl';

    # CustomerPanelLogoutURL
    # (If this is anything other than '', it is assumed to be the URL
    # of an alternate logout page which users will be sent to when they
    # logout.)
#    $Self->{CustomerPanelLogoutURL} = '';
#    $Self->{CustomerPanelLogoutURL} = 'http://host.example.com/cgi-bin/login.pl';

    # CustomerPanelPreApplicationModule
    # (Used for every request, if defined, the PreRun() function of
    # this module will be used. This interface use useful to check
    # some user options or to redirect not accept new application
    # news)
#    $Self->{CustomerPanelPreApplicationModule}->{CustomerAccept} = 'Kernel::Modules::CustomerAccept';
    # Kernel::Modules::CustomerAccept check key, if this user preferences key
    # is true, then the message is already accepted
#    $Self->{'CustomerPanel::InfoKey'} = 'CustomerAccept1';
    # shown InfoFile located under Kernel/Output/HTML/Standard/CustomerAccept.dtl
#    $Self->{'CustomerPanel::InfoFile'} = 'CustomerAccept';

    # CustomerPanelLostPassword
    # (use lost passowrd feature)
    $Self->{CustomerPanelLostPassword} = 1;

    # CustomerPanelCreateAccount
    # (use create cutomer account self feature)
    $Self->{CustomerPanelCreateAccount} = 1;

    # --------------------------------------------------- #
    # notification email about new password               #
    # --------------------------------------------------- #
    $Self->{CustomerPanelSubjectLostPassword} = 'New OTRS Password!';
    $Self->{CustomerPanelBodyLostPassword} = "
Hi <OTRS_USERFIRSTNAME>,

you or someone impersonating you has requested to change your OTRS
password.

New Password: <OTRS_NEWPW>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl

Your OTRS Notification Master
";
    # --------------------------------------------------- #
    # notification email about new account                #
    # --------------------------------------------------- #
    $Self->{CustomerPanelSubjectNewAccount} = 'New OTRS Account!';
    $Self->{CustomerPanelBodyNewAccount} = "
Hi <OTRS_USERFIRSTNAME>,

you or someone impersonating you has created a new OTRS account for
you (<OTRS_USERFIRSTNAME> <OTRS_USERLASTNAME>).

Login: <OTRS_USERLOGIN>
Password: <OTRS_USERPASSWORD>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl

Your OTRS Notification Master
";

    # --------------------------------------------------- #
    # customer authentication settings                    #
    # (enable what you need, auth against otrs db,        #
    # against a LDAP directory, against HTTP basic        #
    # authentication and against Radius server)           #
    # --------------------------------------------------- #
    # This is the auth. module againt the otrs db
    $Self->{'Customer::AuthModule'} = 'Kernel::System::CustomerAuth::DB';
    $Self->{'Customer::AuthModule::DB::Table'} = 'customer_user';
    $Self->{'Customer::AuthModule::DB::CustomerKey'} = 'login';
    $Self->{'Customer::AuthModule::DB::CustomerPassword'} = 'pw';
#    $Self->{'Customer::AuthModule::DB::DSN'} = "DBI:mysql:database=customerdb;host=customerdbhost";
#    $Self->{'Customer::AuthModule::DB::User'} = "some_user";
#    $Self->{'Customer::AuthModule::DB::Password'} = "some_password";

    # This is an example configuration for an LDAP auth. backend.
    # (take care that Net::LDAP is installed!)
#    $Self->{'Customer::AuthModule'} = 'Kernel::System::CustomerAuth::LDAP';
#    $Self->{'Customer::AuthModule::LDAP::Host'} = 'ldap.example.com';
#    $Self->{'Customer::AuthModule::LDAP::BaseDN'} = 'dc=example,dc=com';
#    $Self->{'Customer::AuthModule::LDAP::UID'} = 'uid';

    # Check if the user is allowed to auth in a posixGroup
    # (e. g. user needs to be in a group xyz to use otrs)
#    $Self->{'Customer::AuthModule::LDAP::GroupDN'} = 'cn=otrsallow,ou=posixGroups,dc=example,dc=com';
#    $Self->{'Customer::AuthModule::LDAP::AccessAttr'} = 'memberUid';
    # for ldap posixGroups objectclass (just uid)
#    $Self->{'Customer::AuthModule::LDAP::UserAttr'} = 'UID';
    # for non ldap posixGroups objectclass (full user dn)
#    $Self->{'Customer::AuthModule::LDAP::UserAttr'} = 'DN';

    # The following is valid but would only be necessary if the
    # anonymous user do NOT have permission to read from the LDAP tree
#    $Self->{'Customer::AuthModule::LDAP::SearchUserDN'} = '';
#    $Self->{'Customer::AuthModule::LDAP::SearchUserPw'} = '';

    # in case you want to add always one filter to each ldap query, use
    # this option. e. g. AlwaysFilter => '(mail=*)' or AlwaysFilter => '(objectclass=user)'
#   $Self->{'Customer::AuthModule::LDAP::AlwaysFilter'} = '';

    # in case you want to add a suffix to each customer login name, then
    # you can use this option. e. g. user just want to use user but
    # in your ldap directory exists user@domain.
#    $Self->{'Customer::AuthModule::LDAP::UserSuffix'} = '@domain.com';

    # Net::LDAP new params (if needed - for more info see perldoc Net::LDAP)
#    $Self->{'Customer::AuthModule::LDAP::Params'} = {
#        port => 389,
#        timeout => 120,
#        async => 0,
#        version => 3,
#    };


    # This is an example configuration for an apache ($ENV{REMOTE_USER})
    # auth. backend. Use it if you want to have a singe login through
    # apache http-basic-auth
#   $Self->{'Customer::AuthModule'} = 'Kernel::System::CustomerAuth::HTTPBasicAuth';
    # Note:
    # If you use this module, you should use as fallback the following
    # config settings if user isn't login through apache ($ENV{REMOTE_USER})
#    $Self->{CustomerPanelLoginURL} = 'http://host.example.com/not-authorised-for-otrs.html';
#    $Self->{CustomerPanelLogoutURL} = 'http://host.example.com/thanks-for-using-otrs.html';

    # This is example configuration to auth. agents against a radius server
#    $Self->{'Customer::AuthModule'} = 'Kernel::System::Auth::Radius';
#    $Self->{'Customer::AuthModule::Radius::Host'} = 'radiushost';
#    $Self->{'Customer::AuthModule::Radius::Password'} = 'radiussecret';

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 CustomerUser stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # CustomerUser
    # (customer user database backend and settings)
    $Self->{CustomerUser} = {
        Name => 'Database Backend',
        Module => 'Kernel::System::CustomerUser::DB',
        Params => {
            # if you want to use an external database, add the
            # required settings
#            DSN => 'DBI:odbc:yourdsn',
#            DSN => 'DBI:mysql:database=customerdb;host=customerdbhost',
#            User => '',
#            Password => '',
            Table => 'customer_user',
        },
        # customer uniq id
        CustomerKey => 'login',
        # customer #
        CustomerID => 'customer_id',
        CustomerValid => 'valid_id',
        CustomerUserListFields => ['first_name', 'last_name', 'email'],
#        CustomerUserListFields => ['login', 'first_name', 'last_name', 'customer_id', 'email'],
        CustomerUserSearchFields => ['login', 'first_name', 'last_name', 'customer_id'],
        CustomerUserSearchPrefix => '',
        CustomerUserSearchSuffix => '*',
        CustomerUserSearchListLimit => 250,
        CustomerUserPostMasterSearchFields => ['email'],
        CustomerUserNameFields => ['salutation', 'first_name', 'last_name'],
        CustomerUserEmailUniqCheck => 1,
#        # show now own tickets in customer panel, CompanyTickets
#        CustomerUserExcludePrimaryCustomerID => 0,
#        # generate auto logins
#        AutoLoginCreation => 0,
#        # generate auto login prefix
#        AutoLoginCreationPrefix => 'auto',
#        # admin can change customer preferences
#        AdminSetPreferences => 1,
#        # just a read only source
#        ReadOnly => 1,
        Map => [
            # note: Login, Email and CustomerID needed!
            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly
            [ 'UserSalutation', 'Salutation', 'salutation',  1, 0, 'var', '', 0 ],
            [ 'UserFirstname',  'Firstname',  'first_name',  1, 1, 'var', '', 0 ],
            [ 'UserLastname',   'Lastname',   'last_name',   1, 1, 'var', '', 0 ],
            [ 'UserLogin',      'Username',   'login',       1, 1, 'var', '', 0 ],
            [ 'UserPassword',   'Password',   'pw',          0, 0, 'var', '', 0 ],
            [ 'UserEmail',      'Email',      'email',       0, 1, 'var', '', 0 ],
#            [ 'UserEmail',      'Email', 'email',           1, 1, 'var', '$Env{"CGIHandle"}?Action=AgentTicketCompose&ResponseID=1&TicketID=$Data{"TicketID"}&ArticleID=$Data{"ArticleID"}', 0 ],
            [ 'UserCustomerID', 'CustomerID', 'customer_id', 0, 1, 'var', '', 0 ],
#            [ 'UserCustomerIDs', 'CustomerIDs', 'customer_ids', 1, 0, 'var', '', 0 ],
            [ 'UserComment',     'Comment',   'comments',    1, 0, 'var', '', 0 ],
            [ 'ValidID',         'Valid',     'valid_id',    0, 1, 'int', '', 0 ],
        ],
        # default selections
        Selections => {
#            UserSalutation => {
#                'Mr.' => 'Mr.',
#                'Mrs.' => 'Mrs.',
#            },
        },
    };

    # CustomerUser
    # (customer user ldap backend and settings)
#    $Self->{CustomerUser} = {
#        Name => 'LDAP Backend',
#        Module => 'Kernel::System::CustomerUser::LDAP',
#        Params => {
#            # ldap host
#            Host => 'bay.csuhayward.edu',
#            # ldap base dn
#            BaseDN => 'ou=seas,o=csuh',
#            # search scope (one|sub)
#            SSCOPE => 'sub',
#            # The following is valid but would only be necessary if the
#            # anonymous user does NOT have permission to read from the LDAP tree
#            UserDN => '',
#            UserPw => '',
#            # in case you want to add always one filter to each ldap query, use
#            # this option. e. g. AlwaysFilter => '(mail=*)' or AlwaysFilter => '(objectclass=user)'
#            AlwaysFilter => '',
#            # if your frontend is e. g. iso-8859-1 and the charset of your
#            # ldap server is utf-8, use this options (if not, ignore it)
#            SourceCharset => 'utf-8',
#            DestCharset => 'iso-8859-1',
#            # Net::LDAP new params (if needed - for more info see perldoc Net::LDAP)
#            Params => {
#                port => 389,
#                timeout => 120,
#                async => 0,
#                version => 3,
#            },
#        },
#        # customer uniq id
#        CustomerKey => 'uid',
#        # customer #
#        CustomerID => 'mail',
#        CustomerUserListFields => ['cn', 'mail'],
#        CustomerUserSearchFields => ['uid', 'cn', 'mail'],
#        CustomerUserSearchPrefix => '',
#        CustomerUserSearchSuffix => '*',
#        CustomerUserSearchListLimit => 250,
#        CustomerUserPostMasterSearchFields => ['mail'],
#        CustomerUserNameFields => ['givenname', 'sn'],
#        # show now own tickets in customer panel, CompanyTickets
#        CustomerUserExcludePrimaryCustomerID => 0,
#        # add a ldap filter for valid users (expert setting)
##       CustomerUserValidFilter => '(!(description=gesperrt))',
#        # admin can't change customer preferences
#        AdminSetPreferences => 0,
#        Map => [
#            # note: Login, Email and CustomerID needed!
#            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly
#            [ 'UserSalutation', 'Title',      'title',           1, 0, 'var', '', 0 ],
#            [ 'UserFirstname',  'Firstname',  'givenname',       1, 1, 'var', '', 0 ],
#            [ 'UserLastname',   'Lastname',   'sn',              1, 1, 'var', '', 0 ],
#            [ 'UserLogin',      'Username',   'uid',             1, 1, 'var', '', 0 ],
#            [ 'UserEmail',      'Email',      'mail',            1, 1, 'var', '', 0 ],
#            [ 'UserCustomerID', 'CustomerID', 'mail',            0, 1, 'var', '', 0 ],
##            [ 'UserCustomerIDs', 'CustomerIDs', 'second_customer_ids', 1, 0, 'var', '', 0 ],
#            [ 'UserPhone',      'Phone',      'telephonenumber', 1, 0, 'var', '', 0 ],
#            [ 'UserAddress',    'Address',    'postaladdress',   1, 0, 'var', '', 0 ],
#            [ 'UserComment',    'Comment',    'description',     1, 0, 'var', '', 0 ],
#        ],
#    };

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #              CustomerPreferences stuff              #
    #                                                     #
    # --------------------------------------------------- #

    # CustomerPreferences
    # (customer preferences module)
    $Self->{'CustomerPreferences'} = {
        Module => 'Kernel::System::CustomerUser::Preferences::DB',
        Params => {
             Table => 'customer_preferences',
             TableKey => 'preferences_key',
             TableValue => 'preferences_value',
             TableUserID => 'user_id',
        },
    };

    # CustomerPreferencesView
    # (Order of shown items)
    $Self->{CustomerPreferencesView} = ['Frontend', 'Other Options'];

    # CustomerPreferencesGroups
    # (All possible items)
    $Self->{CustomerPreferencesGroups}->{Password} = {
        Module => 'Kernel::Output::HTML::PreferencesPassword',
        Colum => 'Other Options',
        Label => 'Change Password',
        Prio => 1000,
        Area => 'Customer',
        PasswordHistory => 0,
#        PasswordRegExp => '[a-z]|[A-z]|[0-9]|\.|;|,|:|-|\+|#|!|\$|&|\?',
        PasswordRegExp => '',
        PasswordMinSize => 0,
        PasswordMin2Lower2UpperCharacters => 0,
        PasswordMin2Characters => 0,
        PasswordNeedDigit => 0,
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{Language} = {
        Module => 'Kernel::Output::HTML::PreferencesLanguage',
        Colum => 'Frontend',
        Label => 'Language',
        Desc => 'Select your frontend language.',
        PrefKey => 'UserLanguage',
        Prio => 2000,
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{Theme} = {
        Module => 'Kernel::Output::HTML::PreferencesTheme',
        Colum => 'Frontend',
        Label => 'Theme',
        Desc => 'Select your frontend Theme.',
        PrefKey => 'UserTheme',
        Prio => 1000,
        Activ => 0,
    };
    $Self->{CustomerPreferencesGroups}->{PGP} = {
        Module => 'Kernel::Output::HTML::PreferencesPGP',
        Colum => 'Other Options',
        Label => 'PGP Key',
        Desc => 'PGP Key Upload',
        PrefKey => 'UserPGPKey',
        Prio => 10000,
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{SMIME} = {
        Module => 'Kernel::Output::HTML::PreferencesSMIME',
        Colum => 'Other Options',
        Label => 'SMIME Certificate',
        Desc => 'SMIME Certificate Upload',
        PrefKey => 'UserSMIMEKey',
        Prio => 11000,
        Activ => 1,
    };

    # --------------------------------------------------- #
    # misc
    # --------------------------------------------------- #
    # yes / no options
    $Self->{YesNoOptions} = {
        1 => 'Yes',
        0 => 'No',
    };

    # --------------------------------------------------- #
    # default core objects and params in frontend
    # --------------------------------------------------- #
    $Self->{'Frontend::CommonObject'} = {
        # key => module
#        SomeObject => 'Kernel::System::Some',
    };
    $Self->{'Frontend::CommonParam'} = {
        # param => default value
#        SomeParam => 'DefaultValue',
    };
    # --------------------------------------------------- #
    # default core objects and params in customer frontend
    # --------------------------------------------------- #
    $Self->{'CustomerFrontend::CommonObject'} = {
        # key => module
#        SomeObject => 'Kernel::System::Some',
    };
    $Self->{'CustomerFrontend::CommonParam'} = {
        # param => default value
#        SomeParam => 'DefaultValue',
    };
    # --------------------------------------------------- #
    # default core objects and params in public frontend
    # --------------------------------------------------- #
    $Self->{'PublicFrontend::CommonObject'} = {
        # key => module
#        SomeObject => 'Kernel::System::Some',
    };
    $Self->{'PublicFrontend::CommonParam'} = {
        # param => default value
#        SomeParam => 'DefaultValue',
    };
    # --------------------------------------------------- #
    # Frontend Module Registry (Agent)
    # --------------------------------------------------- #
    # Module (from Kernel/Modules/*.pm) => Group

    $Self->{'Frontend::Module'}->{'Logout'} = {
        Description => 'Logout',
        NavBar => [
          {
            Description => 'Logout',
            Name => 'Logout',
            Image => 'exit.png',
            Link => 'Action=Logout',
            NavBar => '',
            Block => 'ItemPre',
            Prio => 100,
            AccessKey => 'l',
          },
        ],
    };

    $Self->{'Frontend::Module'}->{'AgentPreferences'} = {
        Description => 'Agent Preferences',
        Title => 'Preferences',
        NavBar => [
          {
            Description => 'Agent Preferences',
            Name => 'Preferences',
            Image => 'prefer.png',
            Link => 'Action=AgentPreferences',
            Prio => 1000,
            AccessKey => 'p',
         },
       ],
    };
    $Self->{'Frontend::Module'}->{'AgentSpelling'} = {
        Description => 'Spell checker',
        Title => 'Spell Checker',
    };
    $Self->{'Frontend::Module'}->{'AgentBook'} = {
        Description => 'Address book of CustomerUser sources',
        Title => 'Address Book',
    };
    $Self->{'Frontend::Module'}->{'AgentLookup'} = {
        Description => 'Data table lookup module.',
        Title => 'Lookup',
    };
    $Self->{'Frontend::Module'}->{'AgentLinkObject'} = {
        Description => 'Link Object',
        Title => 'Link Object',
    };
    $Self->{'Frontend::Module'}->{'AgentInfo'} = {
        Description => 'Generic Info module',
        Title => 'Info',
    };
    $Self->{'Frontend::Module'}->{'AgentCalendarSmall'} = {
        Description     => 'Small calendar for date selection.',
        NavBarName      => '',
        Title           => 'Calendar',
    };
    # stats
    $Self->{'Frontend::Module'}->{'SystemStats'} = {
        GroupRo => ['stats'],
        Description => 'Stats',
        Title => 'Stats',
        NavBarName => 'Ticket',
        NavBar => [
          {
            Description => 'Stats-Area',
            Name => 'Stats',
            Image => 'stats.png',
            Link => 'Action=SystemStats',
            NavBar => 'Ticket',
            Prio => 400,
            AccessKey => 't',
          },
        ],
    };
    # admin interface
    $Self->{'Frontend::Module'}->{'Admin'} = {
        Group => ['admin'],
        Description => 'Admin-Area',
        Title => '',
        NavBarName => 'Admin',
        NavBar => [
          {
            Description => 'Admin-Area',
            Type => 'Menu',
            Block => 'ItemArea',
            Name => 'Admin',
            Image => 'admin.png',
            Link => 'Action=Admin',
            NavBar => 'Admin',
            Prio => 10000,
            AccessKey => 'a',
          },
        ],
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
        },
    };
    $Self->{'Frontend::Module'}->{'AdminUser'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'User',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Users',
            Block => 'Block1',
            Prio => 100,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminGroup'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Group',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Groups',
            Block => 'Block1',
            Prio => 150,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminUserGroup'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Users <-> Groups',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Users <-> Groups',
            Block => 'Block1',
            Prio => 200,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminCustomerUser'} = {
        GroupRo => [],
        Group => ['admin', 'users'],
        Description => 'Edit Customer Users',
        Title => 'Customer User',
        NavBarName => '',
        NavBar => [
          {
            Description => 'Edit Customer Users',
            Name => 'Customer',
            Image => 'folder_yellow.png',
            Link => 'Action=AdminCustomerUser&Nav=Agent',
            NavBar => 'Ticket',
            Prio => 9000,
            AccessKey => 'c',
          }
        ],
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Customer Users',
            Block => 'Block1',
            Prio => 300,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminCustomerUserGroup'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Customer Users <-> Groups',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Customer Users <-> Groups',
            Block => 'Block1',
            Prio => 400,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminRole'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Role',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Roles',
            Block => 'Block1',
            Prio => 500,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminRoleUser'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Roles <-> Users',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Roles <-> Users',
            Block => 'Block1',
            Prio => 600,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminRoleGroup'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Roles <-> Groups',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Roles <-> Groups',
            Block => 'Block1',
            Prio => 700,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminSMIME'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'SMIME Management',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'SMIME',
            Block => 'Block3',
            Prio => 500,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminPGP'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'PGP Key Management',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'PGP',
            Block => 'Block3',
            Prio => 600,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminSysConfig'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'SysConfig',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'SysConfig',
            Block => 'Block3',
            Prio => 1100,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminPOP3'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'POP3 Account',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'PostMaster POP3 Account',
            Block => 'Block4',
            Prio => 100,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminPostMasterFilter'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'PostMaster Filter',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'PostMaster Filter',
            Block => 'Block4',
            Prio => 200,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminEmail'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Admin-Email',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Admin Notification',
            Block => 'Block4',
            Prio => 400,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminSession'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Session Management',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Session Management',
            Block => 'Block4',
            Prio => 500,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminLog'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'System Log',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'System Log',
            Block => 'Block4',
            Prio => 600,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminSelectBox'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'SQL Box',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'SQL Box',
            Block => 'Block4',
            Prio => 700,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminPackageManager'} = {
        Group => ['admin'],
        Description => 'Software Package Manager',
        Title => 'Package Manager',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Package Manager',
            Block => 'Block4',
            Prio => 1000,
        },
    };

    # --------------------------------------------------- #
    # Frontend Module Registry (Customer)
    # --------------------------------------------------- #
    $Self->{'CustomerFrontend::Module'}->{'Logout'} = {
        Description => 'Logout of customer panel.',
        NavBarName => '',
        Title => 'Preferences',
        NavBar => [
          {
            Description => 'Logout',
            Name => 'Logout',
            Image => 'exit.png',
            Link => 'Action=Logout',
            Prio => 10,
            AccessKey => 'l',
          },
        ],
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerPreferences'} = {
        Description => 'Customer preferences.',
        NavBarName => '',
        Title => 'Preferences',
        NavBar => [
          {
            Description => 'Preferences',
            Name => 'Preferences',
            Image => 'prefer.png',
            Link => 'Action=CustomerPreferences',
            Prio => 1000,
            AccessKey => 'p',
          },
        ],
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerCalendarSmall'} = {
        Description     => 'Small calendar for date selection.',
        NavBarName      => '',
        Title           => 'Calendar',
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerAccept'} = {
        Description => 'To accept login infos',
        NavBarName      => '',
        Title => 'Info',
    };

    # --------------------------------------------------- #
}
# --
sub Get {
    my $Self = shift;
    my $What = shift;
    # debug
    if ($Self->{Debug} > 1) {
        print STDERR "Debug: Config.pm ->Get('$What') --> $Self->{$What}\n";
    }
    # warn if the value is not def
    if (!$Self->{$What} && $Self->{Debug} > 0) {
        print STDERR "Error: Config.pm No value for '$What' in Config.pm found!\n";
    }
    return $Self->{$What};
}
# --
sub Set {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(Key Value)) {
        if (!defined $Param{$_}) {
            $Param{$_} = '';
        }
    }
    # debug
    if ($Self->{Debug} > 1) {
        print STDERR "Debug: Config.pm ->Set(Key => $Param{Key}, Value => $Param{Value})\n";
    }
    $Self->{$Param{Key}} = $Param{Value};
    return 1;
}
# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # 0=off; 1=log if there exists no entry; 2=log all;
    $Self->{Debug} = 0;
    # return on clear level
    if ($Param{Level} && $Param{Level} eq 'Clear') {
        # load config
        $Self->Load();
        return $Self;
    }
    # load defaults
    $Self->LoadDefaults();
    # load config
    $Self->Load();
    # load extra config files
    if (-e "$Self->{Home}/Kernel/Config/Files/") {
        my @Files = glob("$Self->{Home}/Kernel/Config/Files/*.pm");
        # sort
        my @NewFileOrderPre = ();
        my @NewFileOrderPost = ();
        foreach my $File (@Files) {
            if ($File =~ /Ticket/) {
                push (@NewFileOrderPre, $File);
            }
            else {
                push (@NewFileOrderPost, $File);
            }
        }
        @Files = (@NewFileOrderPre, @NewFileOrderPost);
        foreach my $File (@Files) {
            # do not use ZZZ files
            if ($Param{Level} && $Param{Level} eq 'Default' && $File =~ /ZZZ/) {
                next;
            }
            my $ConfigFile = '';
            if (open (IN, "< $File")) {
                while (<IN>) {
                    $ConfigFile .= $_;
                }
                close (IN);
            }
            else {
                print STDERR "ERROR: $!: $File\n";
            }
            if ($ConfigFile) {
                if (! eval $ConfigFile) {
                    print STDERR "ERROR: Syntax error in $File: $@\n";
                }
                else {
                    # file loaded
#                    print STDERR "Notice: Loaded: $File\n";
                }
            }
        }
    }
    # load RELEASE file
    if (-e "$Self->{Home}/RELEASE") {
        if (open (PRODUCT, "< $Self->{Home}/RELEASE")) {
            while (<PRODUCT>) {
                # filtering of comment lines
                if ($_ !~ /^#/) {
                    if ($_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i) {
                        $Self->{Product} = $1;
                    }
                    elsif ($_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i) {
                        $Self->{Version} = $1;
                    }
                }
            }
        }
        else {
            print STDERR "ERROR: Can't read $Self->{Home}/RELEASE: $!";
        }
    }
    # load config (again)
    $Self->Load();

    # do not use ZZZ files
    if (!$Param{Level}) {
        # replace config variables in config variables
        foreach (keys %{$Self}) {
            if ($_) {
                if (defined($Self->{$_})) {
                    $Self->{$_} =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{$1}/g;
                }
                else {
                    print STDERR "ERROR: $_ not defined!\n";
                }
            }
        }
    }

    return $Self;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.226 $ $Date: 2006-02-06 05:49:27 $

=cut
