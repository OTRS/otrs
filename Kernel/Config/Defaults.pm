# Kernel/Config/Defaults.pm - Default Config file for OTRS kernel
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
#
#  Note:
#    -->> Don't edit this file! Copy your needed settings into
#     Kernel/Config.pm. Kernel/Config.pm will not be updated. <<--
#
#   -->> All changes of this file will be lost after an update! <<--
#
# --

package Kernel::Config::Defaults;

use strict;
use warnings;
use utf8;

# Perl 5.10.0 is the required minimum version to use OTRS.
use 5.010_000;

# make any created files readable by owner and group, not by others
umask 0007;

# prepend '../Custom', '../Kernel/cpan-lib' and '../' to the module search path @INC
use File::Basename;
use FindBin qw($Bin);
use lib dirname($Bin);
use lib dirname($Bin) . '/Kernel/cpan-lib';
use lib dirname($Bin) . '/Custom';

use File::stat;
use Digest::MD5;

sub LoadDefaults {
    my $Self = shift;

    # --------------------------------------------------- #
    # system data                                         #
    # --------------------------------------------------- #
    # SecureMode
    # Disables the use of web-installer (installer.pl).
    # GenericAgent, PackageManager and SQL Box can only be used if SecureMode is enabled.
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
    # (Application name displayed in frontend.)
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

# (The database DSN for PostgreSQL ==> more: "man DBD::Pg")
#    $Self->{DatabaseDSN} = "DBI:Pg:dbname=<OTRS_CONFIG_Database>;host=<OTRS_CONFIG_DatabaseHost>;";

    # (The database DSN for DBI:ODBC ==> more: "man DBD::ODBC")
    #    $Self->{DatabaseDSN} = "DBI:ODBC:$Self->{Database}";
    # If you use ODBC, no database auto detection is possible,
    # so set the database type here. Possible: mysq,postgresql,mssql,oracle
    #    $Self->{'Database::Type'} = 'mssql';

# (The database DSN for Oracle ==> more: "man DBD::oracle")
#    $Self->{DatabaseDSN} = "DBI:Oracle:sid=$Self->{Database};host=$Self->{DatabaseHost};port=1521;";
#    $Self->{DatabaseDSN} = "DBI:Oracle:sid=vingador;host=vingador;port=1521;";
# if needed, oracle env settings
#    $ENV{ORACLE_HOME} = '/opt/ora9/product/9.2';
#    $ENV{ORACLE_HOME} = '/oracle/Ora92';
#    $ENV{NLS_DATE_FORMAT} = 'YYYY-MM-DD HH24:MI:SS';
#    $ENV{NLS_LANG} = "german_germany.utf8";
#    $ENV{NLS_LANG} = "german_germany.we8iso8859p15";
#    $ENV{NLS_LANG} = "american_america.we8iso8859p1";

    # If you want to use an init sql after connect, use this here.
    # (e. g. can be used for mysql encoding between client and server)
    #    $Self->{'Database::Connect'} = 'SET NAMES utf8';

    # If you want to use the sql slow log feature, enable this here.
    # (To log every sql query which takes longer the 4 sec.)
    #    $Self->{'Database::SlowLog'} = 0;

    # --------------------------------------------------- #
    # default values                                      #
    # (default values for GUIs)                           #
    # --------------------------------------------------- #
    # default valid
    $Self->{DefaultValid} = 'valid';

    # DEPRECATED. Compatibilty setting for older 3.0 code.
    # Internal charset must always be utf-8.
    $Self->{DefaultCharset} = 'utf-8';

    # default language
    # (the default frontend language) [default: en]
    $Self->{DefaultLanguage} = 'en';

    # used languages
    # (short name = long name and file)
    $Self->{DefaultUsedLanguages} = {
        ar_SA   => 'Arabic (Saudi Arabia)',
        bg      => 'Bulgarian (&#x0411;&#x044a;&#x043b;&#x0433;&#x0430;&#x0440;&#x0441;&#x043a;&#x0438;)',
        ca      => 'Catal&agrave;',
        cs      => 'Czech (&#x010c;esky)',
        da      => 'Dansk',
        de      => 'Deutsch',
        en      => 'English (United States)',
        en_CA   => 'English (Canada)',
        en_GB   => 'English (United Kingdom)',
        el      => 'Greek (&#x0395;&#x03bb;&#x03bb;&#x03b7;&#x03bd;&#x03b9;&#x03ba;&#x03ac;)',
        es      => 'Espa&ntilde;ol',
        es_CO   => 'Espa&ntilde;ol (Colombia)',
        es_MX   => 'Espa&ntilde;ol (M&eacute;xico)',
        et      => 'Eesti',
        fa      => 'Persian (&#x0641;&#x0627;&#x0631;&#x0633;&#x0649;)',
        fr      => 'Fran&ccedil;ais',
        fr_CA   => 'Fran&ccedil;ais (Canada)',
        fi      => 'Suomi',
        hi      => 'Hindi',
        hr      => 'Hrvatski',
        hu      => 'Magyar',
        it      => 'Italiano',
        ja      => 'Japanese (&#x65e5;&#x672c;&#x8a9e)',
        lt      => 'Lietuvi&#371; kalba',
        lv      => 'Latvijas',
        ms      => 'Malay',
        nl      => 'Nederlands',
        nb_NO   => 'Norsk bokm&aring;l',
        pt_BR   => 'Portugu&ecirc;s Brasileiro',
        pt      => 'Portugu&ecirc;s',
        pl      => 'Polski',
        ru      => 'Russian (&#x0420;&#x0443;&#x0441;&#x0441;&#x043a;&#x0438;&#x0439;)',
        sl      => 'Slovenian (Sloven&#x0161;&#x010d;ina)',
        sk_SK   => 'Slovak (Sloven&#x010d;ina)',
        sr_Cyrl => 'Serbian Latin (Srpski)',
        sr_Latn => 'Serbian Cyrillic (&#1089;&#1088;&#1087;&#1089;&#1082;&#1080;)',
        sv      => 'Svenska',
        tr      => 'T&uuml;rk&ccedil;e',
        uk      => 'Ukrainian (&#x0423;&#x043a;&#x0440;&#x0430;&#x0457;&#x043d;&#x0441;&#x044c;&#x043a;&#x0430;)',
        vi_VN   => 'Vietnam (Vi&#x0246;t Nam)',
        zh_CN   => 'Chinese (Sim.) (&#x7b80;&#x4f53;&#x4e2d;&#x6587;)',
        zh_TW   => 'Chinese (Tradi.) (&#x6b63;&#x9ad4;&#x4e2d;&#x6587;)',

#            th => 'Thai (&#x0e44;&#x0e17;&#x0e22;)',
#            ro => 'Rom&acirc;n&auml;',
#            hr => 'Croatian',
#            jp => 'Japanese (&#x65e5;&#x672c;&#x8a9e;)',
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

    # Frontend::WebPath
    # (URL base path of icons, CSS and Java Script.)
    $Self->{'Frontend::WebPath'} = '/otrs-web/';

    # Frontend::JavaScriptPath
    # (URL JavaScript path.)
    $Self->{'Frontend::JavaScriptPath'} =  '<OTRS_CONFIG_Frontend::WebPath>js/';

    # Frontend::CSSPath
    # (URL CSS path.)
    $Self->{'Frontend::CSSPath'} =  '<OTRS_CONFIG_Frontend::WebPath>css/';

    # Frontend::ImagePath
    # (URL image path of icons for navigation.)
    $Self->{'Frontend::ImagePath'} = '<OTRS_CONFIG_Frontend::WebPath>skins/Agent/default/img/';

    # DefaultViewNewLine
    # (insert new line in text messages after max x chars and
    # the next word)
    $Self->{DefaultViewNewLine} = 90;

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
    $Self->{AttachmentDownloadType} = 'attachment';

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
    $Self->{CheckEmailInvalidAddress} = '@(example)\.(..|...)$';

    # --------------------------------------------------- #
    # LogModule                                           #
    # --------------------------------------------------- #
    # (log backend module)
    $Self->{LogModule} = 'Kernel::System::Log::SysLog';

#    $Self->{'LogModule'} = 'Kernel::System::Log::File';

    # param for LogModule Kernel::System::Log::SysLog
    $Self->{'LogModule::SysLog::Facility'} = 'user';

    # param for LogModule Kernel::System::Log::SysLog
    # (Depends on you sys log system environment. 'unix' is default, on
    # solaris you may need to use 'stream'.)
    $Self->{'LogModule::SysLog::LogSock'} = 'unix';

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

    # system log cache size for admin system log (default 32k)
    # $Self->{'LogSystemCacheSize'} = 32 * 1024;

    # --------------------------------------------------- #
    # SendmailModule
    # --------------------------------------------------- #
    # (Where is sendmail located and some options.
    # See 'man sendmail' for details. Or use the SMTP backend.)
    $Self->{SendmailModule}      = 'Kernel::System::Email::Sendmail';
    $Self->{'SendmailModule::CMD'} = '/usr/sbin/sendmail -i -f ';

#    $Self->{'SendmailModule'} = 'Kernel::System::Email::SMTP';
#    $Self->{'SendmailModule::Host'} = 'mail.example.com';
#    $Self->{'SendmailModule::Port'} = '25';
#    $Self->{'SendmailModule::AuthUser'} = '';
#    $Self->{'SendmailModule::AuthPassword'} = '';

    # SendmailBcc
    # (Send all outgoing email via bcc to...
    # Warning: use it only for external archive functions)
    $Self->{SendmailBcc} = '';

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
    # This is the auth. module against the otrs db
    $Self->{AuthModule} = 'Kernel::System::Auth::DB';

    # defines AuthSyncBackend (AuthSyncModule) for AuthModule
    # if this key exists and is empty, there won't be a sync.
    # example values: AuthSyncBackend, AuthSyncBackend2
#    $Self->{'AuthModule::UseSyncBackend'} = '';

    # password crypt type (bcrypt|sha2|sha1|md5|crypt|plain)
#    $Self->{'AuthModule::DB::CryptType'} = 'bcrypt';

    # This is an example configuration for an LDAP auth. backend.
    # (take care that Net::LDAP is installed!)
#    $Self->{AuthModule} = 'Kernel::System::Auth::LDAP';
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
#    $Self->{'AuthModule::LDAP::AlwaysFilter'} = '';

    # in case you want to add a suffix to each login name, then
    # you can use this option. e. g. user just want to use user but
    # in your ldap directory exists user@domain.
#    $Self->{'AuthModule::LDAP::UserSuffix'} = '@domain.com';

    # In case you want to convert all given usernames to lower letters you
    # should activate this option. It might be helpfull if databases are
    # in use that do not distinguish selects for upper and lower case letters
    # (Oracle, postgresql). User might be synched twice, if this option
    # is not in use.
#    $Self->{'AuthModule::LDAP::UserLowerCase'} = 0;

    # In case you need to use OTRS in iso-charset, you can define this
    # by using this option (converts utf-8 data from LDAP to iso).
#    $Self->{'AuthModule::LDAP::Charset'} = 'iso-8859-1';

    # Net::LDAP new params (if needed - for more info see perldoc Net::LDAP)
#    $Self->{'AuthModule::LDAP::Params'} = {
#        port    => 389,
#        timeout => 120,
#        async   => 0,
#        version => 3,
#    };

    # Die if backend can't work, e. g. can't connect to server.
#    $Self->{'AuthModule::LDAP::Die'} = 1;

    # This is an example configuration for an apache ($ENV{REMOTE_USER})
    # auth. backend. Use it if you want to have a singe login through
    # apache http-basic-auth.
#    $Self->{AuthModule} = 'Kernel::System::Auth::HTTPBasicAuth';
    # In case there is a leading domain in the REMOTE_USER, you can
    # replace it by the next config option.
#    $Self->{'AuthModule::HTTPBasicAuth::Replace'} = 'example_domain\\';
    # In case you need to replace some part of the REMOTE_USER, you can
    # use the following RegExp ($1 will be new login).
#    $Self->{'AuthModule::HTTPBasicAuth::ReplaceRegExp'} = '^(.+?)@.+?$';
    # Note:
    # If you use this module, you should use as fallback the following
    # config settings if user isn't login through apache ($ENV{REMOTE_USER}).
#    $Self->{LoginURL} = 'http://host.example.com/not-authorised-for-otrs.html';
#    $Self->{LogoutURL} = 'http://host.example.com/thanks-for-using-otrs.html';

    # This is example configuration to auth. agents against a radius server.
#    $Self->{'AuthModule'} = 'Kernel::System::Auth::Radius';
#    $Self->{'AuthModule::Radius::Host'} = 'radiushost';
#    $Self->{'AuthModule::Radius::Password'} = 'radiussecret';

    # Die if backend can't work, e. g. can't connect to server.
#    $Self->{'AuthModule::Radius::Die'} = 1;

    # --------------------------------------------------- #
    # authentication sync settings                        #
    # (enable agent data sync. after succsessful          #
    # authentication)                                     #
    # --------------------------------------------------- #
    # This is an example configuration for an LDAP auth sync. backend.
    # (take care that Net::LDAP is installed!)
#    $Self->{AuthSyncModule} = 'Kernel::System::Auth::Sync::LDAP';
#    $Self->{'AuthSyncModule::LDAP::Host'} = 'ldap.example.com';
#    $Self->{'AuthSyncModule::LDAP::BaseDN'} = 'dc=example,dc=com';
#    $Self->{'AuthSyncModule::LDAP::UID'} = 'uid';

    # The following is valid but would only be necessary if the
    # anonymous user do NOT have permission to read from the LDAP tree
#    $Self->{'AuthSyncModule::LDAP::SearchUserDN'} = '';
#    $Self->{'AuthSyncModule::LDAP::SearchUserPw'} = '';

    # in case you want to add always one filter to each ldap query, use
    # this option. e. g. AlwaysFilter => '(mail=*)' or AlwaysFilter => '(objectclass=user)'
#    $Self->{'AuthSyncModule::LDAP::AlwaysFilter'} = '';

    # AuthSyncModule::LDAP::UserSyncMap
    # (map if agent should create/synced from LDAP to DB after successful login)
#    $Self->{'AuthSyncModule::LDAP::UserSyncMap'} = {
#        # DB -> LDAP
#        UserFirstname => 'givenName',
#        UserLastname  => 'sn',
#        UserEmail     => 'mail',
#    };

    # In case you need to use OTRS in iso-charset, you can define this
    # by using this option (converts utf-8 data from LDAP to iso).
#    $Self->{'AuthSyncModule::LDAP::Charset'} = 'iso-8859-1';

    # Net::LDAP new params (if needed - for more info see perldoc Net::LDAP)
#    $Self->{'AuthSyncModule::LDAP::Params'} = {
#        port    => 389,
#        timeout => 120,
#        async   => 0,
#        version => 3,
#    };

    # Die if backend can't work, e. g. can't connect to server.
#    $Self->{'AuthSyncModule::LDAP::Die'} = 1;

    # Attributes needed for group syncs
    # (attribute name for group value key)
#    $Self->{'AuthSyncModule::LDAP::AccessAttr'} = 'memberUid';
    # (attribute for type of group content UID/DN for full ldap name)
#    $Self->{'AuthSyncModule::LDAP::UserAttr'} = 'UID';
#    $Self->{'AuthSyncModule::LDAP::UserAttr'} = 'DN';

    # AuthSyncModule::LDAP::UserSyncInitialGroups
    # (sync following group with rw permission after initial create of first agent
    # login)
#    $Self->{'AuthSyncModule::LDAP::UserSyncInitialGroups'} = [
#        'users',
#    ];

    # AuthSyncModule::LDAP::UserSyncGroupsDefinition
    # (If "LDAP" was selected for AuthModule and you want to sync LDAP
    # groups to otrs groups, define the following.)
#    $Self->{'AuthSyncModule::LDAP::UserSyncGroupsDefinition'} = {
#        # ldap group
#        'cn=agent,o=otrs' => {
#            # otrs group
#            'admin' => {
#                # permission
#                rw => 1,
#                ro => 1,
#            },
#            'faq' => {
#                rw => 0,
#                ro => 1,
#            },
#        },
#        'cn=agent2,o=otrs' => {
#            'users' => {
#                rw => 1,
#                ro => 1,
#            },
#        }
#    };

    # AuthSyncModule::LDAP::UserSyncRolesDefinition
    # (If "LDAP" was selected for AuthModule and you want to sync LDAP
    # groups to otrs roles, define the following.)
#    $Self->{'AuthSyncModule::LDAP::UserSyncRolesDefinition'} = {
#        # ldap group
#        'cn=agent,o=otrs' => {
#            # otrs role
#            'role1' => 1,
#            'role2' => 0,
#        },
#        'cn=agent2,o=otrs' => {
#            'role3' => 1,
#        }
#    };

    # AuthSyncModule::LDAP::UserSyncAttributeGroupsDefinition
    # (If "LDAP" was selected for AuthModule and you want to sync LDAP
    # attributes to otrs groups, define the following.)
#    $Self->{'AuthSyncModule::LDAP::UserSyncAttributeGroupsDefinition'} = {
#        # ldap attribute
#        'LDAPAttribute' => {
#            # ldap attribute value
#            'LDAPAttributeValue1' => {
#                # otrs group
#                'admin' => {
#                    # permission
#                    rw => 1,
#                    ro => 1,
#                },
#                'faq' => {
#                    rw => 0,
#                    ro => 1,
#                },
#            },
#        },
#        'LDAPAttribute2' => {
#            'LDAPAttributeValue' => {
#                'users' => {
#                    rw => 1,
#                    ro => 1,
#                },
#            },
#         }
#    };

    # AuthSyncModule::LDAP::UserSyncAttributeRolesDefinition
    # (If "LDAP" was selected for AuthModule and you want to sync LDAP
    # attributes to otrs roles, define the following.)
#    $Self->{'AuthSyncModule::LDAP::UserSyncAttributeRolesDefinition'} = {
#        # ldap attribute
#        'LDAPAttribute' => {
#            # ldap attribute value
#            'LDAPAttributeValue1' => {
#                # otrs role
#                'role1' => 1,
#                'role2' => 1,
#            },
#        },
#        'LDAPAttribute2' => {
#            'LDAPAttributeValue1' => {
#                'role3' => 1,
#            },
#        },
#    };

    # UserTable
    $Self->{DatabaseUserTable}       = 'users';
    $Self->{DatabaseUserTableUserID} = 'id';
    $Self->{DatabaseUserTableUserPW} = 'pw';
    $Self->{DatabaseUserTableUser}   = 'login';

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

    # agent interface notification module to check the admin user id
    # (don't work with user id 1 notification)
    $Self->{'Frontend::NotifyModule'}->{'200-UID-Check'} = {
        Module => 'Kernel::Output::HTML::NotificationUIDCheck',
    };

    # show online agents
#    $Self->{'Frontend::NotifyModule'}->{'3-ShowAgentOnline'} = {
#        Module      => 'Kernel::Output::HTML::NotificationAgentOnline',
#        ShowEmail   => 1,
#        IdleMinutes => 60,
#    };
    # show online customers
#    $Self->{'Frontend::NotifyModule'}->{'4-ShowCustomerOnline'} = {
#        Module      => 'Kernel::Output::HTML::NotificationCustomerOnline',
#        ShowEmail   => 1,
#        IdleMinutes => 60,
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
    # Frontendserver from the db-server. fs is faster.)
    $Self->{SessionModule} = 'Kernel::System::AuthSession::DB';

#    $Self->{SessionModule} = 'Kernel::System::AuthSession::FS';

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
    $Self->{SessionMaxTime} = 16 * 60 * 60;

    # SessionMaxIdleTime
    # (After this time (in seconds) without new http request, then
    # the user get logged off)
    $Self->{SessionMaxIdleTime} = 6 * 60 * 60;

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
    # directory for all sessen id information (just needed if
    # $Self->{SessionModule}='Kernel::System::AuthSession::FS)
    $Self->{SessionDir} = '<OTRS_CONFIG_Home>/var/sessions';

    # SessionTable*
    # (just needed if $Self->{SessionModule}='Kernel::System::AuthSession::DB)
    # SessionTable
    $Self->{SessionTable} = 'sessions';

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
    $Self->{TimeWorkingHours} = {
        Mon => [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ],
        Tue => [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ],
        Wed => [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ],
        Thu => [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ],
        Fri => [ 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ],
        Sat => [],
        Sun => [],
    };

    # TimeVacationDays
    # adde new days with:
    # "$Self->{TimeVacationDays}->{10}->{27} = 'Some Info';"

    $Self->{TimeVacationDays} = {
        1  => { 1 => 'New Year\'s Eve!', },
        5  => { 1 => '1 St. May', },
        12 => {
            24 => 'Christmas',
            25 => 'Christmas Day',
            26 => 'Boxing Day',
            31 => 'Silvester',
        },
    };

    # TimeVacationDaysOneTime
    # adde new own days with:
# "$Self->{TimeVacationDaysOneTime}->{1977}-{10}->{27} = 'Some Info';"

    $Self->{TimeVacationDaysOneTime} = {
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
    # (Max size for browser file uploads - default ~ 24 MB)
    $Self->{WebMaxFileUpload} = 24000000;

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
    $Self->{SpellChecker}            = 1;
    $Self->{SpellCheckerBin}         = '/usr/bin/ispell';
    $Self->{SpellCheckerDictDefault} = 'english';

    # SpellCheckerIgnore
    # (A list of ignored words.)
    $Self->{SpellCheckerIgnore} = [ 'www', 'webmail', 'https', 'http', 'html', 'rfc' ];

    # --------------------------------------------------- #
    # directories                                         #
    # --------------------------------------------------- #
    # root directory
    $Self->{Home} = '/opt/otrs';

    # tmp dir
    $Self->{TempDir} = '<OTRS_CONFIG_Home>/var/tmp';

    # html template dirs
    $Self->{TemplateDir}       = '<OTRS_CONFIG_Home>/Kernel/Output';
    $Self->{CustomTemplateDir} = '<OTRS_CONFIG_Home>/Custom/Kernel/Output';

    # --------------------------------------------------- #
    # CommonCSS                                           #
    # --------------------------------------------------- #

    # Customer Common CSS
    $Self->{'Loader::Customer::CommonCSS'}->{'000-Framework'} =  [
      'Core.Reset.css',
      'Core.Default.css',
      'Core.Form.css',
      'Core.Login.css',
      'Core.Control.css',
      'Core.Table.css',
      'Core.TicketZoom.css',
      'Core.Print.css'
    ];

    # Customer Common CSS for IE8
    $Self->{'Loader::Customer::CommonCSS::IE8'}->{'000-Framework'} =  [];

    # Agent Common CSS
    $Self->{'Loader::Agent::CommonCSS'}->{'000-Framework'} =  [
      'Core.Reset.css',
      'Core.Default.css',
      'Core.Header.css',
      'Core.OverviewControl.css',
      'Core.OverviewSmall.css',
      'Core.OverviewMedium.css',
      'Core.OverviewLarge.css',
      'Core.Footer.css',
      'Core.PageLayout.css',
      'Core.Form.css',
      'Core.Table.css',
      'Core.Widget.css',
      'Core.WidgetMenu.css',
      'Core.TicketDetail.css',
      'Core.Tooltip.css',
      'Core.Dialog.css',
      'Core.Print.css'
    ];

    # Agent Common CSS for IE8
    $Self->{'Loader::Agent::CommonCSS::IE8'}->{'000-Framework'} =  [
      'Core.OverviewSmall.IE8.css'
    ];

    # --------------------------------------------------- #
    # CommonJS                                           #
    # --------------------------------------------------- #

    # Customer Common JS
    $Self->{'Loader::Customer::CommonJS'}->{'000-Framework'} =  [
      'thirdparty/jquery-1.10.0/jquery.js',
      'thirdparty/jquery-browser-detection/jquery-browser-detection.js',
      'thirdparty/jquery-migrate-1.2.1/jquery-migrate.js',
      'thirdparty/stacktrace-0.4/stacktrace.js',
      'thirdparty/jquery-pubsub/pubsub.js',
      'Core.Debug.js',
      'Core.Exception.js',
      'Core.Config.js',
      'Core.App.js',
      'Core.Customer.js',
      'Core.JavaScriptEnhancements.js',
      'Core.UI.RichTextEditor.js'
    ];

    # Agent Common JS
    $Self->{'Loader::Agent::CommonJS'}->{'000-Framework'} =  [
      'thirdparty/json/json2.js',
      'thirdparty/jquery-1.10.0/jquery.js',
      'thirdparty/jquery-browser-detection/jquery-browser-detection.js',
      'thirdparty/jquery-migrate-1.2.1/jquery-migrate.js',
      'thirdparty/jquery-ui-1.10.3/jquery-ui.js',
      'thirdparty/jquery-validate-1.11.1/jquery.validate.js',
      'thirdparty/stacktrace-0.4/stacktrace.js',
      'thirdparty/jquery-pubsub/pubsub.js',
      'Core.JavaScriptEnhancements.js',
      'Core.Debug.js',
      'Core.Data.js',
      'Core.Config.js',
      'Core.Exception.js',
      'Core.JSON.js',
      'Core.AJAX.js',
      'Core.App.js',
      'Core.UI.js',
      'Core.UI.Accordion.js',
      'Core.UI.Datepicker.js',
      'Core.UI.Resizable.js',
      'Core.UI.Table.js',
      'Core.UI.Accessibility.js',
      'Core.UI.RichTextEditor.js',
      'Core.UI.TreeSelection.js',
      'Core.Form.js',
      'Core.Form.ErrorTooltips.js',
      'Core.UI.Dialog.js',
      'Core.Form.Validate.js',
      'Core.UI.ActionRow.js',
      'Core.UI.Popup.js',
      'Core.Agent.js'
    ];

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
#    $Self->{'Package::RepositoryList'} = {
#        'ftp://ftp.example.com/pub/otrs/misc/packages/' => '[Example] ftp://ftp.example.com/',
#    };

    # Package::Timeout
    # (http/ftp timeout to get packages)
    $Self->{'Package::Timeout'} = 15;

    # Package::Proxy
    # (fetch packages via proxy)
#    $Self->{'Package::Proxy'} = 'http://proxy.sn.no:8001/';

    # --------------------------------------------------- #
    # PGP settings (supports gpg)                         #
    # --------------------------------------------------- #
    $Self->{PGP}          = 0;
    $Self->{'PGP::Bin'}     = '/usr/bin/gpg';
    $Self->{'PGP::Options'} = '--homedir /opt/otrs/.gnupg/ --batch --no-tty --yes';

#    $Self->{'PGP::Options'} = '--batch --no-tty --yes';
#    $Self->{'PGP::Key::Password'}->{'D2DF79FA'} = 1234;
#    $Self->{'PGP::Key::Password'}->{'488A0B8F'} = 1234;

    # --------------------------------------------------- #
    # S/MIME settings (supports smime)                    #
    # --------------------------------------------------- #
    $Self->{SMIME} = 0;

    # maybe openssl need a HOME env!
    #$ENV{HOME} = '/var/lib/wwwrun';
    $Self->{'SMIME::Bin'} = '/usr/bin/openssl';

#    $Self->{'SMIME::CertPath'} = '/etc/ssl/certs';
#    $Self->{'SMIME::PrivatePath'} = '/etc/ssl/private';

    # --------------------------------------------------- #
    # system permissions
    # --------------------------------------------------- #
    $Self->{'System::Permission'}           = [ 'ro', 'rw' ];
    $Self->{'System::Customer::Permission'} = [ 'ro', 'rw' ];

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 Preferences stuff                   #
    #                                                     #
    # --------------------------------------------------- #

    # PreferencesTable*
    # (Stored preferences table data.)
    $Self->{PreferencesTable}       = 'user_preferences';
    $Self->{PreferencesTableKey}    = 'preferences_key';
    $Self->{PreferencesTableValue}  = 'preferences_value';
    $Self->{PreferencesTableUserID} = 'user_id';

    # PreferencesView
    # (Order of shown items)
    $Self->{PreferencesView} = [ 'User Profile', 'Email Settings', 'Other Settings' ];

    $Self->{PreferencesGroups}->{Password} = {
        Module          => 'Kernel::Output::HTML::PreferencesPassword',
        Column          => 'Other Options',
        Label           => 'Change Password',
        Prio            => 1000,
        Area            => 'Agent',

#        PasswordRegExp => '[a-z]|[A-z]|[0-9]|\.|;|,|:|-|\+|#|!|\$|&|\?',
        PasswordRegExp                    => '',
        PasswordMinSize                   => 0,
        PasswordMin2Lower2UpperCharacters => 0,
        PasswordMin2Characters            => 0,
        PasswordNeedDigit                 => 0,
        Active                             => 1,
    };
    $Self->{PreferencesGroups}->{SpellDict} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Column => 'Other Options',
        Label  => 'Spelling Dictionary',
        Desc   => 'Select your default spelling dictionary.',
        Data   => {

            # installed dict catalog (check your insalled catalogues, e. g. deutsch -=> german!)
            # dict => frontend (ispell)
            'english' => 'English',
            'deutsch' => 'Deutsch',

            # dict => frontend (aspell)
#            'english' => 'English',
#            'german'  => 'Deutsch',
        },
        PrefKey => 'UserSpellDict',
        Prio    => 5000,
        Active   => 1,
    };
    $Self->{PreferencesGroups}->{Comment} = {
        Module  => 'Kernel::Output::HTML::PreferencesGeneric',
        Column  => 'Other Options',
        Label   => 'Comment',
        Desc    => 'Comment',
        Block   => 'Input',
        Data    => '$Env{"UserComment"}',
        PrefKey => 'UserComment',
        Prio    => 6000,
        Active   => 0,
    };

    $Self->{PreferencesGroups}->{Language} = {
        Module  => 'Kernel::Output::HTML::PreferencesLanguage',
        Column  => 'Frontend',
        Label   => 'Language',
        Desc    => 'Select your frontend language.',
        PrefKey => 'UserLanguage',
        Prio    => 1000,
        Active   => 1,
    };
    $Self->{PreferencesGroups}->{Theme} = {
        Module  => 'Kernel::Output::HTML::PreferencesTheme',
        Column  => 'Frontend',
        Label   => 'Theme',
        Desc    => 'Select your frontend Theme.',
        PrefKey => 'UserTheme',
        Prio    => 2000,
        Active   => 1,
    };

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 Notification stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # notification sender
    $Self->{NotificationSenderName}  = 'OTRS Notification Master';
    $Self->{NotificationSenderEmail} = 'otrs@<OTRS_CONFIG_FQDN>';

    # notification email for new password
    $Self->{NotificationSubjectLostPassword} = 'New OTRS Password!';
    $Self->{NotificationBodyLostPassword}    = "
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
    $Self->{CustomerGroupAlwaysGroups} = [ 'users', 'info' ];

    # show online agents
#    $Self->{'CustomerFrontend::NotifyModule'}->{'1-ShowAgentOnline'} = {
#        Module      => 'Kernel::Output::HTML::NotificationAgentOnline',
#        ShowEmail   => 1,
#        IdleMinutes => 60,
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
    $Self->{CustomerPanelBodyLostPassword}    = "
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
    $Self->{CustomerPanelBodyNewAccount}    = "
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
    # This is the auth. module for the otrs db
    # you can also configure it using a remote database
    $Self->{'Customer::AuthModule'}                       = 'Kernel::System::CustomerAuth::DB';
    $Self->{'Customer::AuthModule::DB::Table'}            = 'customer_user';
    $Self->{'Customer::AuthModule::DB::CustomerKey'}      = 'login';
    $Self->{'Customer::AuthModule::DB::CustomerPassword'} = 'pw';

#    $Self->{'Customer::AuthModule::DB::DSN'} = "DBI:mysql:database=customerdb;host=customerdbhost";
#    $Self->{'Customer::AuthModule::DB::User'} = "some_user";
#    $Self->{'Customer::AuthModule::DB::Password'} = "some_password";

    # if you use odbc or you want to define a database type (without autodetection)
#    $Self->{'Customer::AuthModule::DB::Type'} = 'mysql';

    # password crypt type (bcrypt|sha2|sha1|md5|crypt|plain)
#    $Self->{'Customer::AuthModule::DB::CryptType'} = 'bcrypt';

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
#        port    => 389,
#        timeout => 120,
#        async   => 0,
#        version => 3,
#    };

    # Die if backend can't work, e. g. can't connect to server.
#    $Self->{'Customer::AuthModule::LDAP::Die'} = 1;

    # This is an example configuration for an apache ($ENV{REMOTE_USER})
    # auth. backend. Use it if you want to have a singe login through
    # apache http-basic-auth
#   $Self->{'Customer::AuthModule'} = 'Kernel::System::CustomerAuth::HTTPBasicAuth';

    # In case there is a leading domain in the REMOTE_USER, you can
    # replace it by the next config option.
#   $Self->{'Customer::AuthModule::HTTPBasicAuth::Replace'} = 'example_domain\\';
    # Note:
    # In case you need to replace some part of the REMOTE_USER, you can
    # use the following RegExp ($1 will be new login).
#    $Self->{'Customer::AuthModule::HTTPBasicAuth::ReplaceRegExp'} = '^(.+?)@.+?$';
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
        Name   => 'Database Backend',
        Module => 'Kernel::System::CustomerUser::DB',
        Params => {
            # if you want to use an external database, add the
            # required settings
#            DSN  => 'DBI:odbc:yourdsn',
#            Type => 'mssql', # only for ODBC connections
#            DSN => 'DBI:mysql:database=customerdb;host=customerdbhost',
#            User => '',
#            Password => '',
            Table => 'customer_user',
            # if your frontend is unicode and the charset of your
            # customer database server is iso-8859-1, use these options.
#           SourceCharset => 'iso-8859-1',
#           DestCharset => 'utf-8',

            # CaseSensitive will control if the SQL statements need LOWER()
            #   function calls to work case insensitively. Setting this to
            #   1 will improve performance dramatically on large databases.
            CaseSensitive => 0,
        },

        # customer unique id
        CustomerKey => 'login',

        # customer #
        CustomerID             => 'customer_id',
        CustomerValid          => 'valid_id',
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],

#        CustomerUserListFields => ['login', 'first_name', 'last_name', 'customer_id', 'email'],
        CustomerUserSearchFields           => [ 'login', 'first_name', 'last_name', 'customer_id' ],
        CustomerUserSearchPrefix           => '*',
        CustomerUserSearchSuffix           => '*',
        CustomerUserSearchListLimit        => 250,
        CustomerUserPostMasterSearchFields => ['email'],
        CustomerUserNameFields             => [ 'title', 'first_name', 'last_name' ],
        CustomerUserEmailUniqCheck         => 1,

#        # show now own tickets in customer panel, CompanyTickets
#        CustomerUserExcludePrimaryCustomerID => 0,
#        # generate auto logins
#        AutoLoginCreation => 0,
#        # generate auto login prefix
#        AutoLoginCreationPrefix => 'auto',
#        # admin can change customer preferences
#        AdminSetPreferences => 1,
#        # use customer company support (reference to company, See CustomerCompany settings)
#        CustomerCompanySupport => 1,
        # cache time to live in sec. - cache any database queries
        CacheTTL => 60 * 60 * 24,
#        # just a read only source
#        ReadOnly => 1,
        Map => [

            # note: Login, Email and CustomerID needed!
            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly, http-link-target, link class(es)
            [ 'UserTitle',      'Title',      'title',      1, 0, 'var', '', 0 ],
            [ 'UserFirstname',  'Firstname',  'first_name', 1, 1, 'var', '', 0 ],
            [ 'UserLastname',   'Lastname',   'last_name',  1, 1, 'var', '', 0 ],
            [ 'UserLogin',      'Username',   'login',      1, 1, 'var', '', 0 ],
            [ 'UserPassword',   'Password',   'pw',         0, 0, 'var', '', 0 ],
            [ 'UserEmail',      'Email',      'email',      1, 1, 'var', '', 0 ],
#            [ 'UserEmail',      'Email', 'email',           1, 1, 'var', '$Env{"CGIHandle"}?Action=AgentTicketCompose;ResponseID=1;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}', 0, '', 'AsPopup OTRSPopup_TicketAction' ],
            [ 'UserCustomerID', 'CustomerID', 'customer_id', 0, 1, 'var', '', 0 ],
#            [ 'UserCustomerIDs', 'CustomerIDs', 'customer_ids', 1, 0, 'var', '', 0 ],
            [ 'UserPhone',        'Phone',       'phone',        1, 0, 'var', '', 0 ],
            [ 'UserFax',          'Fax',         'fax',          1, 0, 'var', '', 0 ],
            [ 'UserMobile',       'Mobile',      'mobile',       1, 0, 'var', '', 0 ],
            [ 'UserStreet',       'Street',      'street',       1, 0, 'var', '', 0 ],
            [ 'UserZip',          'Zip',         'zip',          1, 0, 'var', '', 0 ],
            [ 'UserCity',         'City',        'city',         1, 0, 'var', '', 0 ],
            [ 'UserCountry',      'Country',     'country',      1, 0, 'var', '', 0 ],
            [ 'UserComment',      'Comment',     'comments',     1, 0, 'var', '', 0 ],
            [ 'ValidID',          'Valid',       'valid_id',     0, 1, 'int', '', 0 ],
        ],

        # default selections
        Selections => {

#            UserTitle => {
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
#            # if both your frontend and your LDAP are unicode, use this:
#            SourceCharset => 'utf-8',
#            DestCharset   => 'utf-8',
#            # if your frontend is unicode and the charset of your
#            # ldap server is iso-8859-1, use these options.
#            # SourceCharset => 'iso-8859-1',
#            # DestCharset => 'utf-8',
#            # die if backend can't work, e. g. can't connect to server
#            Die => 0,
#            # Net::LDAP new params (if needed - for more info see perldoc Net::LDAP)
#            Params => {
#                port    => 389,
#                timeout => 120,
#                async   => 0,
#                version => 3,
#            },
#        },
#        # customer unique id
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
#        # CustomerUserValidFilter => '(!(description=gesperrt))',
#        # admin can't change customer preferences
#        AdminSetPreferences => 0,
#        # cache time to live in sec. - cache any ldap queries
#        CacheTTL => 0,
#        Map => [
#            # note: Login, Email and CustomerID needed!
#            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly
#            [ 'UserTitle',      'Title',      'title',           1, 0, 'var', '', 0 ],
#            [ 'UserFirstname',  'Firstname',  'givenname',       1, 1, 'var', '', 0 ],
#            [ 'UserLastname',   'Lastname',   'sn',              1, 1, 'var', '', 0 ],
#            [ 'UserLogin',      'Username',   'uid',             1, 1, 'var', '', 0 ],
#            [ 'UserEmail',      'Email',      'mail',            1, 1, 'var', '', 0 ],
#            [ 'UserCustomerID', 'CustomerID', 'mail',            0, 1, 'var', '', 0 ],
#            # [ 'UserCustomerIDs', 'CustomerIDs', 'second_customer_ids', 1, 0, 'var', '', 0 ],
#            [ 'UserPhone',      'Phone',      'telephonenumber', 1, 0, 'var', '', 0 ],
#            [ 'UserAddress',    'Address',    'postaladdress',   1, 0, 'var', '', 0 ],
#            [ 'UserComment',    'Comment',    'description',     1, 0, 'var', '', 0 ],
#        ],
#    };

    $Self->{CustomerCompany} = {
        Name   => 'Database Backend',
        Module => 'Kernel::System::CustomerCompany::DB',
        Params => {
            # if you want to use an external database, add the
            # required settings
#            DSN  => 'DBI:odbc:yourdsn',
#            Type => 'mssql', # only for ODBC connections
#            DSN => 'DBI:mysql:database=customerdb;host=customerdbhost',
#            User => '',
#            Password => '',
            Table => 'customer_company',
#            ForeignDB => 0,    # set this to 1 if your table does not have create_time, create_by, change_time and change_by fields

            # CaseSensitive will control if the SQL statements need LOWER()
            #   function calls to work case insensitively. Setting this to
            #   1 will improve performance dramatically on large databases.
            CaseSensitive => 0,
        },

        # company unique id
        CustomerCompanyKey             => 'customer_id',
        CustomerCompanyValid           => 'valid_id',
        CustomerCompanyListFields      => [ 'customer_id', 'name' ],
        CustomerCompanySearchFields    => ['customer_id', 'name'],
        CustomerCompanySearchPrefix    => '',
        CustomerCompanySearchSuffix    => '*',
        CustomerCompanySearchListLimit => 250,
        CacheTTL                       => 60 * 60 * 24, # use 0 to turn off cache

        Map => [
            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly
            [ 'CustomerID',             'CustomerID', 'customer_id', 0, 1, 'var', '', 0 ],
            [ 'CustomerCompanyName',    'Company',    'name',        1, 1, 'var', '', 0 ],
            [ 'CustomerCompanyStreet',  'Street',     'street',      1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyZIP',     'Zip',        'zip',         1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyCity',    'City',       'city',        1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyCountry', 'Country',    'country',     1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyURL',     'URL',        'url',         1, 0, 'var', '$Data{"CustomerCompanyURL"}', 0 ],
            [ 'CustomerCompanyComment', 'Comment',    'comments',    1, 0, 'var', '', 0 ],
            [ 'ValidID',                'Valid',      'valid_id',    0, 1, 'int', '', 0 ],
        ],
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
        Action => 'AdminInit',
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

    # admin interface
    $Self->{'Frontend::Module'}->{Admin} = {
        Group       => ['admin'],
        Description => 'Admin-Area',
        Title       => '',
        NavBarName  => 'Admin',
        NavBar      => [
            {   Description => 'Admin-Area',
                Type        => 'Menu',
                Block       => 'ItemArea',
                Name        => 'Admin',
                Image       => 'admin.png',
                Link        => 'Action=Admin',
                NavBar      => 'Admin',
                Prio        => 10000,
                AccessKey   => 'a',
            },
        ],
        NavBarModule => { Module => 'Kernel::Output::HTML::NavBarModuleAdmin', },
    };
    $Self->{'Frontend::Module'}->{AdminInit} = {
        Group       => ['admin'],
        Description => 'Admin',
        Title       => 'Init',
    };
    $Self->{'Frontend::Module'}->{AdminLog} = {
        Group        => ['admin'],
        Description  => 'Admin',
        Title        => 'System Log',
        NavBarName   => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name   => 'System Log',
            Block  => 'Block4',
            Prio   => 600,
        },
    };
    $Self->{'Frontend::Module'}->{AdminSysConfig} = {
        Group        => ['admin'],
        Description  => 'Admin',
        Title        => 'SysConfig',
        NavBarName   => 'Admin',
        NavBarModule => {
            Module      => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name        => 'SysConfig',
            Description => 'Edit the system configuration settings.',
            Block       => 'System',
            Prio        => 800,
        },
        Loader       => {
            CSS => [
                'Core.Agent.Admin.SysConfig.css',
            ],
            JavaScript => [
                'Core.Agent.Admin.SysConfig.js',
            ],
        },
    };
    $Self->{'Frontend::Module'}->{AdminPackageManager} = {
        Group        => ['admin'],
        Description  => 'Software Package Manager',
        Title        => 'Package Manager',
        NavBarName   => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name   => 'Package Manager',
            Block  => 'Block4',
            Prio   => 1000,
        },
    };
    # specify Loader settings for Login screens
    $Self->{'Frontend::Module'}->{Login} = {
        Loader       => {
            JavaScript => [
                'Core.Agent.Login.js',
            ],
        },
    };
    $Self->{'CustomerFrontend::Module'}->{CustomerLogin} = {
        Loader       => {
            JavaScript => [
                'Core.Customer.Login.js',
            ],
        },
    };

    # specify Loader settings for the installer
    $Self->{'Frontend::Module'}->{Installer} = {
        Loader       => {
            JavaScript => [
                'Core.Installer.js',
            ],
            CSS => [
                'Core.Installer.css'
            ],
        },
    };
    # --------------------------------------------------- #
    return;
}

sub Get {
    my ( $Self, $What ) = @_;

    # debug
    if ( $Self->{Debug} > 1 ) {
        my $Value = defined $Self->{$What} ? $Self->{$What} : '<undef>';
        print STDERR "Debug: Config.pm ->Get('$What') --> $Value\n";
    }

    return $Self->{$What};
}

sub Set {
    my ( $Self, %Param ) = @_;

    for (qw(Key)) {
        if ( !defined $Param{$_} ) {
            $Param{$_} = '';
        }
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        my $Value = defined $Param{Value} ? $Param{Value} : '<undef>';
        print STDERR "Debug: Config.pm ->Set(Key => $Param{Key}, Value => $Value)\n";
    }

    # set runtime config option
    if ( $Param{Key} =~ /^(.+?)###(.+?)$/ ) {
        if ( !defined $Param{Value} ) {
            delete $Self->{$1}->{$2};
        }
        else {
            $Self->{$1}->{$2} = $Param{Value};
        }
    }
    else {
        if ( !defined $Param{Value} ) {
            delete $Self->{ $Param{Key} };
        }
        else {
            $Self->{ $Param{Key} } = $Param{Value};
        }
    }
    return 1;
}

#
# ConfigChecksum
#
# This function returns an MD5 sum that is generated from all available
#   config files (Kernel/Config.pm, Kernel/Config/Defaults.pm, Kernel/Config/Files/*.(pm|xml) except ZZZAAuto.pm) and their
#   modification timestamps. Whenever a file is changed, added or removed,
#   this checksum will change.
#
sub ConfigChecksum {
    my $Self = shift;

    my @Files = glob( $Self->{Home} . "/Kernel/Config/Files/*.pm");

    # Ignore ZZZAAuto.pm, because this is only a cached version of the XML files which
    # will be in the checksum. Otherwise the SysConfig cannot use its cache files.
    @Files = grep { $_!~ m/ZZZAAuto\.pm$/smx } @Files;

    push @Files, glob( $Self->{Home} . "/Kernel/Config/Files/*.xml");
    push @Files, $Self->{Home} . "/Kernel/Config/Defaults.pm" ;
    push @Files, $Self->{Home} . "/Kernel/Config.pm";

    # Create a string with filenames and file mtimes of the config files
    my $ConfigString;
    for my $File (@Files) {

        # get file metadata
        my $Stat = stat( $File );

        if ( !$Stat ) {
            print STDERR "Error: cannot stat file '$File': $!";
            return;
        }

        $ConfigString .= $File . $Stat->mtime();
    }

    return Digest::MD5::md5_hex( $ConfigString );
}

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=log if there exists no entry; 2=log all;
    $Self->{Debug} = 0;

    # return on clear level
    if ( $Param{Level} && $Param{Level} eq 'Clear' ) {

        # load config
        $Self->Load();
        return $Self;
    }

    # load defaults
    $Self->LoadDefaults();

    # load config
    $Self->Load();

    # load extra config files
    if ( -e "$Self->{Home}/Kernel/Config/Files/" ) {
        my @Files = glob("$Self->{Home}/Kernel/Config/Files/*.pm");

        # sort
        my @NewFileOrderPre  = ();
        my @NewFileOrderPost = ();
        for my $File (@Files) {
            if ( $File =~ /Ticket/ ) {
                push @NewFileOrderPre, $File;
            }
            else {
                push @NewFileOrderPost, $File;
            }
        }
        @Files = ( @NewFileOrderPre, @NewFileOrderPost );
        for my $File (@Files) {

            # do not use ZZZ files
            if ( $Param{Level} && $Param{Level} eq 'Default' && $File =~ /ZZZ/ ) {
                next;
            }

            # check config file format - use 1.0 as eval string, 1.1 as require or do
            my $FileFormat = 1;
            my $ConfigFile = '';
            ## no critic
            if ( open( my $In, '<', $File ) ) {
            ## use critic

                # only try to find # VERSION:1.1 in the first 8 lines
                my $TryCount = 0;
                while ( my $Line = <$In> ) {
                    if ($Line =~ /^\Q# VERSION:1.1\E/) {
                        $FileFormat = 1.1;
                        last;
                    }

                    $TryCount++;
                    if ( $TryCount >= 8 ) {
                        last;
                    }
                }
                close($In);

                # read file format 1.0 - file as string
                if ( $FileFormat == 1 ) {
                    open( my $In, '<', $File );
                    $ConfigFile = do {local $/; <$In>};
                    close $In;
                }
            }
            else {
                print STDERR "ERROR: $!: $File\n";
            }

            # use file format of config file
            if ( $FileFormat == 1.1 ) {

                # check if mod_perl is used
                my $Require = 1;
                if ( exists $ENV{MOD_PERL} ) {

                    # if mod_perl 2.x is used, check if Apache::Reload is use
                    # on win32 Apache::Reload is not working correctly, so do also use "do"
                    my $OS = $^O;
                    ## no critic
                    if ( $mod_perl::VERSION >= 1.99 && $OS ne 'MSWin32') {
                    ## use critic
                        my $ApacheReload = 0;
                        for my $Module ( sort keys %INC ) {
                            $Module =~ s/\//::/g;
                            $Module =~ s/\.pm$//g;
                            if ( $Module eq 'Apache::Reload' || $Module eq 'Apache2::Reload' ) {
                                $ApacheReload = 1;
                                last;
                            }
                        }
                        if ( !$ApacheReload ) {
                            $Require = 0;
                        }
                    }

                    # if mod_perl 1.x is used, do not use require
                    else {
                        $Require = 0;
                    }
                }

                # if require is usable, use it (because of better performance,
                # if not, use do to do it on runtime)
                ## no critic
                if ( $Require ) {
                    if (! require $File ) {
                        die "ERROR: $!\n";
                    }
                }
                else {
                    if (! do $File ) {
                        die "ERROR: $!\n";
                    }
                }
                ## use critic

                # prepare file
                $File =~ s/\Q$Self->{Home}\E//g;
                $File =~ s/^\///g;
                $File =~ s/\/\//\//g;
                $File =~ s/\//::/g;
                $File =~ s/.pm//g;
                $File->Load($Self);
            }
            else {

                # use eval for old file format
                if ($ConfigFile) {
                    if ( !eval $ConfigFile ) { ## no critic
                        print STDERR "ERROR: Syntax error in $File: $@\n";
                    }

                    # print STDERR "Notice: Loaded: $File\n";
                }
            }
        }
    }

    # load RELEASE file
    if ( -e ! "$Self->{Home}/RELEASE" ) {
        print STDERR "ERROR: $Self->{Home}/RELEASE does not exist! This file is needed by central system parts of OTRS, the system will not work without this file.\n";
        die;
    }
    if ( open( my $Product, '<', "$Self->{Home}/RELEASE" ) ) { ## no critic
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Self->{Product} = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Self->{Version} = $1;
                }
            }
        }
        close($Product);
    }
    else {
        print STDERR "ERROR: Can't read $Self->{Home}/RELEASE: $! This file is needed by central system parts of OTRS, the system will not work without this file.\n";
        die;
    }

    # load config (again)
    $Self->Load();

    # do not use ZZZ files
    if ( !$Param{Level} ) {

        # replace config variables in config variables
        for my $Key ( sort keys %{$Self} ) {
            next if !defined $Key;
            if ( defined $Self->{$Key} ) {
                $Self->{$Key} =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{$1}/g;
            }
            else {
                print STDERR "ERROR: $Key not defined!\n";
            }
        }
    }

    return $Self;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
