# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

# Default configuration for OTRS. All changes to this file will be lost after an
#   update, please use AdminSystemConfiguration to configure your system.

## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

package Kernel::Config::Defaults;

use strict;
use warnings;
use utf8;

# Perl 5.16.0 is the required minimum version to use OTRS.
use 5.016_000;

# prepend '../Custom', '../Kernel/cpan-lib' and '../' to the module search path @INC
use File::Basename;
use FindBin qw($Bin);
use lib dirname($Bin);
use lib dirname($Bin) . '/Kernel/cpan-lib';
use lib dirname($Bin) . '/Custom';

use File::stat;
use Digest::MD5;

use Exporter qw(import);
our @EXPORT = qw(Translatable); ## no critic (allow automatic export)

our @ObjectDependencies = ();

=head1 NAME

Kernel::Config::Defaults - Base class for the ConfigObject.

=head1 DESCRIPTION

This class implements several internal functions that are used internally in
L<Kernel::Config>. The two externally used functions are documented as part
of L<Kernel::Config>, even though they are actually implemented here.

=head1 PUBLIC INTERFACE

=head2 LoadDefaults()

loads the default values of settings that are required to run OTRS even
when it was not fully configured yet.

=cut

sub LoadDefaults {
    my $Self = shift;

    # Make any created files readable by owner and group, not by others.
    # Do this on every instantiation to make sure it also works after fork()
    #   and in long-running mod_perl or similar environments.
    umask 0007;

    # --------------------------------------------------- #
    # system data                                         #
    # --------------------------------------------------- #
    # SecureMode
    # Disables the use of web-installer (installer.pl).
    # GenericAgent, PackageManager and SQL Box can only be used if SecureMode is enabled.
    $Self->{SecureMode} = 0;

    # SystemID
    # (The identify of the system. Each ticket number and
    # each HTTP session id starts with this number)
    $Self->{SystemID} = 10;

    # NodeID
    # (The identify of the node. In a clustered environment
    # each node needs a separate NodeID. On a setup with just
    # one frontend server, it is not needed to change this setting)
    $Self->{NodeID} = 1;

    # FQDN
    # (Full qualified domain name of your system.)
    $Self->{FQDN} = 'yourhost.example.com';

    # HttpType
    # In case you use HTTPS instead of plain HTTP specify it here
    $Self->{HttpType} = 'http';

    # ScriptAlias
    # Prefix to index.pl used as ScriptAlias in web config
    # (Used when emailing links to agents).
    $Self->{ScriptAlias} = 'otrs/';

    # AdminEmail
    # (Email of the system admin.)
    $Self->{AdminEmail} = 'support@<OTRS_CONFIG_FQDN>';

    # Organization
    # (If this is anything other than '', then the email will have an
    # Organization X-Header)
    $Self->{Organization} = 'Example Company';

    # ProductName
    # (Application name displayed in frontend.)
    $Self->{ProductName} = 'OTRS 6';

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
    # The database DSN for MySQL ==> more: "perldoc DBD::mysql"
    $Self->{DatabaseDSN} = "DBI:mysql:database=<OTRS_CONFIG_Database>;host=<OTRS_CONFIG_DatabaseHost>;";

    # The database DSN for PostgreSQL ==> more: "perldoc DBD::Pg"
#    $Self->{DatabaseDSN} = "DBI:Pg:dbname=<OTRS_CONFIG_Database>;host=<OTRS_CONFIG_DatabaseHost>;";

    # The database DSN for Oracle ==> more: "perldoc DBD::oracle"
#    $Self->{DatabaseDSN} = "DBI:Oracle://$Self->{DatabaseHost}:1521/$Self->{Database}";
#
#    $ENV{ORACLE_HOME}     = '/path/to/your/oracle';
#    $ENV{NLS_DATE_FORMAT} = 'YYYY-MM-DD HH24:MI:SS';
#    $ENV{NLS_LANG}        = 'AMERICAN_AMERICA.AL32UTF8';
#    $ENV{NLS_LANG}        = 'GERMAN_GERMANY.AL32UTF8';

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
        'ar_SA'   => 'Arabic (Saudi Arabia)',
        'bg'      => 'Bulgarian',
        'ca'      => 'Catalan',
        'cs'      => 'Czech',
        'da'      => 'Danish',
        'de'      => 'German',
        'en'      => 'English (United States)',
        'en_CA'   => 'English (Canada)',
        'en_GB'   => 'English (United Kingdom)',
        'es'      => 'Spanish',
        'es_CO'   => 'Spanish (Colombia)',
        'es_MX'   => 'Spanish (Mexico)',
        'et'      => 'Estonian',
        'el'      => 'Greek',
        'fa'      => 'Persian',
        'fi'      => 'Finnish',
        'fr'      => 'French',
        'fr_CA'   => 'French (Canada)',
        'gl'      => 'Galician',
        'he'      => 'Hebrew',
        'hi'      => 'Hindi',
        'hr'      => 'Croatian',
        'hu'      => 'Hungarian',
        'id'      => 'Indonesian',
        'it'      => 'Italian',
        'ja'      => 'Japanese',
        'ko'      => 'Korean',
        'lt'      => 'Lithuanian',
        'lv'      => 'Latvian',
        'mk'      => 'Macedonian',
        'ms'      => 'Malay',
        'nl'      => 'Dutch',
        'nb_NO'   => 'Norwegian',
        'pt_BR'   => 'Portuguese (Brasil)',
        'pt'      => 'Portuguese',
        'pl'      => 'Polish',
        'ro'      => 'Romanian',
        'ru'      => 'Russian',
        'sl'      => 'Slovenian',
        'sr_Latn' => 'Serbian Latin',
        'sr_Cyrl' => 'Serbian Cyrillic',
        'sk_SK'   => 'Slovak',
        'sv'      => 'Swedish',
        'sw'      => 'Swahili',
        'th_TH'   => 'Thai',
        'tr'      => 'Turkish',
        'uk'      => 'Ukrainian',
        'vi_VN'   => 'Vietnam',
        'zh_CN'   => 'Chinese (Simplified)',
        'zh_TW'   => 'Chinese (Traditional)',
    };

    $Self->{DefaultUsedLanguagesNative} = {
        'ar_SA'   => 'العَرَبِية‎',
        'bg'      => 'Български',
        'ca'      => 'Català',
        'cs'      => 'Česky',
        'da'      => 'Dansk',
        'de'      => 'Deutsch',
        'en'      => 'English (United States)',
        'en_CA'   => 'English (Canada)',
        'en_GB'   => 'English (United Kingdom)',
        'es'      => 'Español',
        'es_CO'   => 'Español (Colombia)',
        'es_MX'   => 'Español (México)',
        'et'      => 'Eesti',
        'el'      => 'Ελληνικά',
        'fa'      => 'فارسى',
        'fi'      => 'Suomi',
        'fr'      => 'Français',
        'fr_CA'   => 'Français (Canada)',
        'gl'      => 'Galego',
        'he'      => 'עברית',
        'hi'      => 'हिन्दी',
        'hr'      => 'Hrvatski',
        'hu'      => 'Magyar',
        'id'      => 'Bahasa Indonesia',
        'it'      => 'Italiano',
        'ja'      => '日本語',
        'ko'      => '한국어',
        'lt'      => 'Lietuvių kalba',
        'lv'      => 'Latvijas',
        'mk'      => 'Mакедонски',
        'ms'      => 'Melayu',
        'nl'      => 'Nederlandse',
        'nb_NO'   => 'Norsk bokmål',
        'pt_BR'   => 'Português Brasileiro',
        'pt'      => 'Português',
        'pl'      => 'Polski',
        'ro'      => 'Română',
        'ru'      => 'Русский',
        'sl'      => 'Slovenščina',
        'sr_Latn' => 'Srpski',
        'sr_Cyrl' => 'Српски',
        'sk_SK'   => 'Slovenčina',
        'sv'      => 'Svenska',
        'sw'      => 'Kiswahili',
        'th_TH'   => 'ภาษาไทย',
        'tr'      => 'Türkçe',
        'uk'      => 'Українська',
        'vi_VN'   => 'ViɆt Nam',
        'zh_CN'   => '简体中文',
        'zh_TW'   => '正體中文',
    };

    # default theme
    # (the default HTML theme) [default: Standard]
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
    $Self->{'Frontend::JavaScriptPath'} = '<OTRS_CONFIG_Frontend::WebPath>js/';

    # Frontend::CSSPath
    # (URL CSS path.)
    $Self->{'Frontend::CSSPath'} = '<OTRS_CONFIG_Frontend::WebPath>css/';

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

    # TimeInputMinutesStep
    # (default minute step in minutes dropdown) [1,2,5,10,15,30]
    $Self->{TimeInputMinutesStep} = 1;

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
    # (if syslog can't work with utf-8, force the log
    # charset with this option, on other chars will be
    # replaces with ?)
    $Self->{'LogModule::SysLog::Charset'} = 'utf-8';

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
    $Self->{'SendmailModule'}      = 'Kernel::System::Email::Sendmail';
    $Self->{'SendmailModule::CMD'} = '/usr/sbin/sendmail -i -f';

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
    # against LDAP directory, against HTTP basic auth     #
    # or against Radius server)                           #
    # --------------------------------------------------- #
    # This is the auth. module against the otrs db
    $Self->{AuthModule} = 'Kernel::System::Auth::DB';

    # defines AuthSyncBackend (AuthSyncModule) for AuthModule
    # if this key exists and is empty, there won't be a sync.
    # example values: AuthSyncBackend, AuthSyncBackend2
#    $Self->{'AuthModule::UseSyncBackend'} = '';

    # password crypt type (bcrypt|sha2|sha1|md5|apr1|crypt|plain)
#    $Self->{'AuthModule::DB::CryptType'} = 'sha2';

    # If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing.
    #   Currently max. supported cost value is 31.
    # $Self->{'AuthModule::DB::bcryptCost'} = 12;

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
    # or if you want to filter with a locigal OR-Expression, like AlwaysFilter => '(|(mail=*abc.com)(mail=*xyz.com))'
#    $Self->{'AuthModule::LDAP::AlwaysFilter'} = '';

    # in case you want to add a suffix to each login name, then
    # you can use this option. e. g. user just want to use user but
    # in your ldap directory exists user@domain.
#    $Self->{'AuthModule::LDAP::UserSuffix'} = '@domain.com';

    # In case you want to convert all given usernames to lower letters you
    # should activate this option. It might be helpful if databases are
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
    # 2 factor authentication settings                    #
    # check a otp (one-time password)                     #
    # after successful authentication                     #
    # as an extra security measure                        #
    # --------------------------------------------------- #
    # This is the auth module using the google authenticator mechanism
#    $Self->{'AuthTwoFactorModule'} = 'Kernel::System::Auth::TwoFactor::GoogleAuthenticator';

    # defines user preference where the secret key is stored
#    $Self->{'AuthTwoFactorModule::SecretPreferencesKey'} = 'UserGoogleAuthenticatorSecretKey';

    # defines if users can login without a 2 factor authentication if they have no stored shared secret
#    $Self->{'AuthTwoFactorModule::AllowEmptySecret'} = '1';

    # defines if the otp for the previous timespan (30-60sec ago) will also be valid
    # helpful to account for timing issues (server and entry based)
#    $Self->{'AuthTwoFactorModule::AllowPreviousToken'} = '1';

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
    # or if you want to filter with a logical OR-Expression, like AlwaysFilter => '(|(mail=*abc.com)(mail=*xyz.com))'
#    $Self->{'AuthSyncModule::LDAP::AlwaysFilter'} = '';

    # AuthSyncModule::LDAP::UserSyncMap
    # (map if agent should create/synced from LDAP to DB after successful login)
    # you may specify LDAP-Fields as either
    #  * list, which will check each field. first existing will be picked ( ["givenName","cn","_empty"] )
    #  * name of an LDAP-Field (may return empty strings) ("givenName")
    #  * fixed strings, prefixed with an underscore: "_test", which will always return this fixed string
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
    # shown InfoFile located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt
#    $Self->{InfoFile} = 'AgentInfo';

    # --------------------------------------------------- #
    # Notification Settings
    # --------------------------------------------------- #

    # agent interface notification module to check the admin user id
    # (don't work with user id 1 notification)
    $Self->{'Frontend::NotifyModule'} = {
        '1000-CloudServicesDisabled' => {
            Group  => 'admin',
            Module => 'Kernel::Output::HTML::Notification::AgentCloudServicesDisabled',
        },
        '1100-OTRSBusiness' => {
            Group  => 'admin',
            Module => 'Kernel::Output::HTML::Notification::AgentOTRSBusiness',
        },
        '2000-UID-Check' => {
            Module => 'Kernel::Output::HTML::Notification::UIDCheck',
        },
        '2500-AgentSessionLimit' => {
          'Module' => 'Kernel::Output::HTML::Notification::AgentSessionLimit',
        },
        '5000-SystemConfigurationIsDirty-Check' => {
            Group  => 'admin',
            Module => 'Kernel::Output::HTML::Notification::SystemConfigurationIsDirtyCheck',
        },
        '5200-SystemConfigurationInvalid-Check' => {
            Group  => 'admin',
            Module => 'Kernel::Output::HTML::Notification::SystemConfigurationInvalidCheck',
        },
        '5500-OutofOffice-Check' => {
            Module => 'Kernel::Output::HTML::Notification::OutofOfficeCheck',
        },
        '6000-SystemMaintenance-Check' => {
            Module => 'Kernel::Output::HTML::Notification::SystemMaintenanceCheck',
        },
        '6050-SystemConfiguration-OutOfSync-Check' =>  {
            Module => 'Kernel::Output::HTML::Notification::SystemConfigurationOutOfSyncCheck',
            AllowedDelayMinutes => '5',
        },
        '7000-AgentTimeZone-Check' => {
            Module => 'Kernel::Output::HTML::Notification::AgentTimeZoneCheck',
        },
        '8000-Daemon-Check' => {
            Module => 'Kernel::Output::HTML::Notification::DaemonCheck',
        },
    };

    # Make sure the daemon is able to deploy the configuration to all cluster nodes that have no ZZZAAuto.pm yet.
    $Self->{DaemonModules}->{SystemConfigurationSyncManager} =  {
      Module => 'Kernel::System::Daemon::DaemonModules::SystemConfigurationSyncManager'
    };

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
    $Self->{SessionName} = 'OTRSAgentInterface';

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
    $Self->{SessionMaxIdleTime} = 2 * 60 * 60;

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
    # (set the OTRS time zone, default is UTC)
#    $Self->{'OTRSTimeZone'} = 'UTC';

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

    $Self->{TimeVacationDays} = {
        1 => {
            1 => 'New Year\'s Day',
        },
        5 => {
            1 => 'International Workers\' Day',
        },
        12 => {
            24 => 'Christmas Eve',
            25 => 'First Christmas Day',
            26 => 'Second Christmas Day',
            31 => 'New Year\'s Eve',
        },
    };

    $Self->{TimeVacationDaysOneTime} = {
        2004 => {
            1 => {
                1 => 'test',
            },
        },
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
    # directories                                         #
    # --------------------------------------------------- #
    # root directory
    $Self->{Home} = '/opt/otrs';

    # tmp dir
    $Self->{TempDir} = '<OTRS_CONFIG_Home>/var/tmp';

    # article dir
    $Self->{'Ticket::Article::Backend::MIMEBase::ArticleDataDir'} = '<OTRS_CONFIG_Home>/var/article';

    # html template dirs
    $Self->{TemplateDir}       = '<OTRS_CONFIG_Home>/Kernel/Output';
    $Self->{CustomTemplateDir} = '<OTRS_CONFIG_Home>/Custom/Kernel/Output';

    # --------------------------------------------------- #
    # CommonCSS                                           #
    # --------------------------------------------------- #

    # Customer Common CSS
    $Self->{'Loader::Customer::CommonCSS'}->{'000-Framework'} = [
        'Core.Reset.css',
        'Core.Default.css',
        'Core.Form.css',
        'Core.Dialog.css',
        'Core.Tooltip.css',
        'Core.Login.css',
        'Core.Control.css',
        'Core.Table.css',
        'Core.TicketZoom.css',
        'Core.InputFields.css',
        'Core.Print.css',
        'Core.Animations.css',
    ];

    # Agent Common CSS
    $Self->{'Loader::Agent::CommonCSS'}->{'000-Framework'} = [
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
        'Core.Login.css',
        'Core.Widget.css',
        'Core.WidgetMenu.css',
        'Core.TicketDetail.css',
        'Core.Tooltip.css',
        'Core.Dialog.css',
        'Core.InputFields.css',
        'Core.Print.css',
        'Core.Animations.css',
    ];

    # --------------------------------------------------- #
    # CommonJS                                           #
    # --------------------------------------------------- #

    # Customer Common JS
    $Self->{'Loader::Customer::CommonJS'}->{'000-Framework'} = [
        'thirdparty/jquery-3.4.1/jquery.js',
        'thirdparty/jquery-browser-detection/jquery-browser-detection.js',
        'thirdparty/jquery-validate-1.16.0/jquery.validate.js',
        'thirdparty/jquery-ui-1.12.1/jquery-ui.js',
        'thirdparty/jquery-pubsub/pubsub.js',
        'thirdparty/jquery-jstree-3.3.7/jquery.jstree.js',
        'thirdparty/nunjucks-3.0.1/nunjucks.js',
        'Core.Init.js',
        'Core.Debug.js',
        'Core.Exception.js',
        'Core.Data.js',
        'Core.JSON.js',
        'Core.JavaScriptEnhancements.js',
        'Core.Config.js',
        'Core.Language.js',
        'Core.Template.js',
        'Core.App.js',
        'Core.App.Responsive.js',
        'Core.AJAX.js',
        'Core.UI.js',
        'Core.UI.InputFields.js',
        'Core.UI.Accessibility.js',
        'Core.UI.Dialog.js',
        'Core.UI.Floater.js',
        'Core.UI.RichTextEditor.js',
        'Core.UI.Datepicker.js',
        'Core.UI.Popup.js',
        'Core.UI.TreeSelection.js',
        'Core.UI.Autocomplete.js',
        'Core.Form.js',
        'Core.Form.ErrorTooltips.js',
        'Core.Form.Validate.js',
        'Core.Customer.js',
        'Core.Customer.Responsive.js',
    ];

    # Agent Common JS
    $Self->{'Loader::Agent::CommonJS'}->{'000-Framework'} = [
        'thirdparty/jquery-3.4.1/jquery.js',
        'thirdparty/jquery-browser-detection/jquery-browser-detection.js',
        'thirdparty/jquery-ui-1.12.1/jquery-ui.js',
        'thirdparty/jquery-ui-touch-punch-0.2.3/jquery.ui.touch-punch.js',
        'thirdparty/jquery-validate-1.16.0/jquery.validate.js',
        'thirdparty/jquery-pubsub/pubsub.js',
        'thirdparty/jquery-jstree-3.3.7/jquery.jstree.js',
        'thirdparty/nunjucks-3.0.1/nunjucks.js',
        'Core.Init.js',
        'Core.JavaScriptEnhancements.js',
        'Core.Debug.js',
        'Core.Exception.js',
        'Core.Data.js',
        'Core.Config.js',
        'Core.Language.js',
        'Core.Template.js',
        'Core.JSON.js',
        'Core.App.js',
        'Core.App.Responsive.js',
        'Core.AJAX.js',
        'Core.UI.js',
        'Core.UI.InputFields.js',
        'Core.UI.Accordion.js',
        'Core.UI.Datepicker.js',
        'Core.UI.DnD.js',
        'Core.UI.Floater.js',
        'Core.UI.Resizable.js',
        'Core.UI.Table.js',
        'Core.UI.Accessibility.js',
        'Core.UI.RichTextEditor.js',
        'Core.UI.Dialog.js',
        'Core.UI.ActionRow.js',
        'Core.UI.Popup.js',
        'Core.UI.TreeSelection.js',
        'Core.UI.Autocomplete.js',
        'Core.Form.js',
        'Core.Form.ErrorTooltips.js',
        'Core.Form.Validate.js',
        'Core.Agent.js',
        'Core.Agent.Search.js',
        'Core.Agent.CustomerInformationCenterSearch.js',
        'Core.Agent.CustomerSearch.js',
        'Core.Agent.CustomerUserInformationCenterSearch.js',
        'Core.Agent.Header.js',
        'Core.UI.Notification.js',
        'Core.Agent.Responsive.js',
    ];

    # --------------------------------------------------- #
    #                                                     #
    #            package management options               #
    #                                                     #
    # --------------------------------------------------- #

    # Package::RepositoryRoot
    # (get online repository list, use the fist availabe result)
    $Self->{'Package::RepositoryRoot'} = [
        'https://ftp.otrs.org/pub/otrs/misc/packages/repository.xml',
    ];

    # Package::RepositoryList
    # (repository list)
#    $Self->{'Package::RepositoryList'} = {
#        'ftp://ftp.example.com/pub/otrs/misc/packages/' => '[Example] ftp://ftp.example.com/',
#    };

    # Package::Timeout
    # (http/ftp timeout to get packages)
    $Self->{'Package::Timeout'} = 120;

    # Package::Proxy
    # (fetch packages via proxy)
#    $Self->{'Package::Proxy'} = 'http://proxy.sn.no:8001/';

    # --------------------------------------------------- #
    # PGP settings (supports gpg)                         #
    # --------------------------------------------------- #
    $Self->{PGP}            = 0;
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
    $Self->{'System::Permission'} = [
        'ro',
        'move_into',
        'create',
        'note',
        'owner',
        'priority',
        'rw',
    ];
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
    $Self->{PreferencesView} = [ 'User Profile', 'Notification Settings', 'Other Settings' ];

    $Self->{PreferencesGroups}->{Password} = {
        'Active'                            => '1',
        'Area'                              => 'Agent',
        'PreferenceGroup'                   => 'UserProfile',
        'Label'                             => 'Change password',
        'Module'                            => 'Kernel::Output::HTML::Preferences::Password',
        'PasswordMaxLoginFailed'            => '0',
        'PasswordMin2Characters'            => '0',
        'PasswordMin2Lower2UpperCharacters' => '0',
        'PasswordMinSize'                   => '0',
        'PasswordNeedDigit'                 => '0',
        'PasswordRegExp'                    => '',
        'Prio'                              => '0500',
        'Desc'                              => 'Set a new password by filling in your current password and a new one.',
    };
    $Self->{PreferencesGroups}->{Comment} = {
        'Active'  => '0',
        'Block'   => 'Input',
        'PreferenceGroup' => 'Miscellaneous',
        'Data'    => '[% Env("UserComment") %]',
        'Desc'    => 'This is a Description for Comment on Framework.',
        'Key'     => 'Comment',
        'Label'   => 'Comment',
        'Module'  => 'Kernel::Output::HTML::Preferences::Generic',
        'PrefKey' => 'UserComment',
        'Prio'    => '6000',
    };

    $Self->{PreferencesGroups}->{Language} = {
        'Active'  => '1',
        'PreferenceGroup'  => 'UserProfile',
        'Key'     => '',
        'Label'   => 'Language',
        'Desc'    => 'Select the main interface language.',
        'Module'  => 'Kernel::Output::HTML::Preferences::Language',
        'PrefKey' => 'UserLanguage',
        'Prio'    => '1000',
        'NeedsReload' => 1,
    };
    $Self->{PreferencesGroups}->{Theme} = {
        'Active'  => '1',
        'PreferenceGroup'  => 'Miscellaneous',
        'Key'     => '',
        'Label'   => 'Theme',
        'Desc'    => 'Select your preferred theme for OTRS.',
        'Module'  => 'Kernel::Output::HTML::Preferences::Theme',
        'PrefKey' => 'UserTheme',
        'Prio'    => '3000',
        'NeedsReload' => 1,
    };

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 Notification stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # notification sender
    $Self->{NotificationSenderName}  = 'OTRS Notifications';
    $Self->{NotificationSenderEmail} = 'otrs@<OTRS_CONFIG_FQDN>';

    # notification email for new password
    $Self->{NotificationSubjectLostPassword} = 'New OTRS password';
    $Self->{NotificationBodyLostPassword}    = 'Hi <OTRS_USERFIRSTNAME>,


Here\'s your new OTRS password.

New password: <OTRS_NEWPW>

You can log in via the following URL:

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl
            ';

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                CustomerPanel stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # SessionName
    # (Name of the session key. E. g. Session, SessionID, OTRS)
    $Self->{CustomerPanelSessionName} = 'OTRSCustomerInterface';

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
    $Self->{CustomerGroupAlwaysGroups} = [ 'users', ];

    # show online agents
#    $Self->{'CustomerFrontend::NotifyModule'}->{'1-ShowAgentOnline'} = {
#        Module      => 'Kernel::Output::HTML::Notification::AgentOnline',
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
    # shown InfoFile located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt
#    $Self->{'CustomerPanel::InfoFile'} = 'CustomerAccept';

    # CustomerPanelLostPassword
    # (use lost password feature)
    $Self->{CustomerPanelLostPassword} = 1;

    # CustomerPanelCreateAccount
    # (use create cutomer account self feature)
    $Self->{CustomerPanelCreateAccount} = 1;

    # --------------------------------------------------- #
    # notification email about new password               #
    # --------------------------------------------------- #
    $Self->{CustomerPanelSubjectLostPassword} = 'New OTRS password';
    $Self->{CustomerPanelBodyLostPassword}    = 'Hi <OTRS_USERFIRSTNAME>,


New password: <OTRS_NEWPW>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl
            ';

    # --------------------------------------------------- #
    # notification email about new account                #
    # --------------------------------------------------- #
    $Self->{CustomerPanelSubjectNewAccount} = 'New OTRS Account!';
    $Self->{CustomerPanelBodyNewAccount}    = 'Hi <OTRS_USERFIRSTNAME>,

You or someone impersonating you has created a new OTRS account for
you.

Full name: <OTRS_USERFIRSTNAME> <OTRS_USERLASTNAME>
User name: <OTRS_USERLOGIN>
Password : <OTRS_USERPASSWORD>

You can log in via the following URL. We encourage you to change your password
via the Preferences button after logging in.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl
            ';

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

    # password crypt type (bcrypt|sha2|sha1|md5|apr1|crypt|plain)
#    $Self->{'Customer::AuthModule::DB::CryptType'} = 'sha2';

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
    # 2 factor customer authentication settings           #
    # check a otp (one-time password)                     #
    # after successful authentication                     #
    # as an extra security measure                        #
    # --------------------------------------------------- #
    # This is the auth module using the google authenticator mechanism
#    $Self->{'Customer::AuthTwoFactorModule'} = 'Kernel::System::CustomerAuth::TwoFactor::GoogleAuthenticator';

    # defines user preference where the secret key is stored
#    $Self->{'Customer::AuthTwoFactorModule::SecretPreferencesKey'} = 'UserGoogleAuthenticatorSecretKey';

    # defines if users can login without a 2 factor authentication if they have no stored shared secret
#    $Self->{'Customer::AuthTwoFactorModule::AllowEmptySecret'} = '1';

    # defines if the otp for the previous timespan (30-60sec ago) will also be valid
    # helpful to account for timing issues (server and entry based)
#    $Self->{'Customer::AuthTwoFactorModule::AllowPreviousToken'} = '1';

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 CustomerUser stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # CustomerUser
    # (customer user database backend and settings)
    $Self->{CustomerUser} = {
        Name   => Translatable('Database Backend'),
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
#            ForeignDB => 0,    # set this to 1 if your table does not have create_time, create_by, change_time and change_by fields

            # CaseSensitive defines if the data storage of your DBMS is case sensitive and will be
            # preconfigured within the database driver by default.
            # If the collation of your data storage differs from the default settings,
            # you can set the current behavior ( either 1 = CaseSensitive or 0 = CaseINSensitive )
            # to fit your environment.
            #
#            CaseSensitive => 0,

            # SearchCaseSensitive will control if the searches within the data storage are performed
            # case sensitively (if possible) or not. Change this option to 1, if you want to search case sensitive.
            # This can improve the performance dramatically on large databases.
            SearchCaseSensitive => 0,
        },

        # customer unique id
        CustomerKey => 'login',

        # customer #
        CustomerID    => 'customer_id',
        CustomerValid => 'valid_id',

        # The last field must always be the email address so that a valid
        #   email address like "John Doe" <john.doe@domain.com> can be constructed from the fields.
        CustomerUserListFields => [ 'first_name', 'last_name', 'email' ],

#        CustomerUserListFields => ['login', 'first_name', 'last_name', 'customer_id', 'email'],
        CustomerUserSearchFields           => [ 'login', 'first_name', 'last_name', 'customer_id' ],
        CustomerUserSearchPrefix           => '*',
        CustomerUserSearchSuffix           => '*',
        CustomerUserSearchListLimit        => 250,
        CustomerUserPostMasterSearchFields => ['email'],
        CustomerUserNameFields             => [ 'title', 'first_name', 'last_name' ],
        CustomerUserEmailUniqCheck         => 1,

#        # Configures the character for joining customer user name parts. Join single space if it is not defined.
#        # CustomerUserNameFieldsJoin => '',

#        # show now own tickets in customer panel, CompanyTickets
#        CustomerUserExcludePrimaryCustomerID => 0,
#        # generate auto logins
#        AutoLoginCreation => 0,
#        # generate auto login prefix
#        AutoLoginCreationPrefix => 'auto',
#        # admin can change customer preferences
#        AdminSetPreferences => 1,
        # use customer company support (reference to company, See CustomerCompany settings)
        CustomerCompanySupport => 1,
        # cache time to live in sec. - cache any database queries
        CacheTTL => 60 * 60 * 24,
#        # Consider this source read only.
#        ReadOnly => 1,
        Map => [

            # Info about dynamic fields:
            #
            # Dynamic Fields of type CustomerUser can be used within the mapping (see example below).
            # The given storage (third column) then can also be used within the following configurations (see above):
            # CustomerUserSearchFields, CustomerUserPostMasterSearchFields, CustomerUserListFields, CustomerUserNameFields
            #
            # Note that the columns 'frontend' and 'readonly' will be ignored for dynamic fields.

            # note: Login, Email and CustomerID needed!
            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly, http-link-target, link class(es)
            [ 'UserTitle',        Translatable('Title or salutation'), 'title',          1, 0, 'var', '', 0, undef, undef ],
            [ 'UserFirstname',    Translatable('Firstname'),           'first_name',     1, 1, 'var', '', 0, undef, undef ],
            [ 'UserLastname',     Translatable('Lastname'),            'last_name',      1, 1, 'var', '', 0, undef, undef ],
            [ 'UserLogin',        Translatable('Username'),            'login',          1, 1, 'var', '', 0, undef, undef ],
            [ 'UserPassword',     Translatable('Password'),            'pw',             0, 0, 'var', '', 0, undef, undef ],
            [ 'UserEmail',        Translatable('Email'),               'email',          1, 1, 'var', '', 0, undef, undef ],
#            [ 'UserEmail',        Translatable('Email'),               'email',          1, 1, 'var', '[% Env("CGIHandle") %]?Action=AgentTicketCompose;ResponseID=1;TicketID=[% Data.TicketID | uri %];ArticleID=[% Data.ArticleID | uri %]', 0, '', 'AsPopup OTRSPopup_TicketAction' ],
            [ 'UserCustomerID',   Translatable('CustomerID'),          'customer_id',    0, 1, 'var', '', 0, undef, undef ],
#            [ 'UserCustomerIDs',  Translatable('CustomerIDs'),         'customer_ids',   1, 0, 'var', '', 0, undef, undef ],
            [ 'UserPhone',        Translatable('Phone'),               'phone',          1, 0, 'var', '', 0, undef, undef ],
            [ 'UserFax',          Translatable('Fax'),                 'fax',            1, 0, 'var', '', 0, undef, undef ],
            [ 'UserMobile',       Translatable('Mobile'),              'mobile',         1, 0, 'var', '', 0, undef, undef ],
            [ 'UserStreet',       Translatable('Street'),              'street',         1, 0, 'var', '', 0, undef, undef ],
            [ 'UserZip',          Translatable('Zip'),                 'zip',            1, 0, 'var', '', 0, undef, undef ],
            [ 'UserCity',         Translatable('City'),                'city',           1, 0, 'var', '', 0, undef, undef ],
            [ 'UserCountry',      Translatable('Country'),             'country',        1, 0, 'var', '', 0, undef, undef ],
            [ 'UserComment',      Translatable('Comment'),             'comments',       1, 0, 'var', '', 0, undef, undef ],
            [ 'ValidID',          Translatable('Valid'),               'valid_id',       0, 1, 'int', '', 0, undef, undef ],

            # Dynamic field example
#            [ 'DynamicField_Name_X', undef, 'Name_X', 0, 0, 'dynamic_field', undef, 0, undef, undef ],
        ],

        # default selections
        Selections => {

#            UserTitle => {
#                'Mr.' => Translatable('Mr.'),
#                'Mrs.' => Translatable('Mrs.'),
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
#            # if the charset of your ldap server is iso-8859-1, use this:
#            # SourceCharset => 'iso-8859-1',
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
#        # Configures the character for joining customer user name parts. Join single space if it is not defined.
#        CustomerUserNameFieldsJoin => '',
#        # show customer user and customer tickets in customer interface
#        CustomerUserExcludePrimaryCustomerID => 0,
#        # add a ldap filter for valid users (expert setting)
#        # CustomerUserValidFilter => '(!(description=gesperrt))',
#        # admin can't change customer preferences
#        AdminSetPreferences => 0,
#        # cache time to live in sec. - cache any ldap queries
#        CacheTTL => 0,
#        Map => [
#            # note: Login, Email and CustomerID needed!
#            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly, http-link-target, link class(es)
#            [ 'UserTitle',       Translatable('Title or salutation'), 'title',               1, 0, 'var', '', 1, undef, undef ],
#            [ 'UserFirstname',   Translatable('Firstname'),           'givenname',           1, 1, 'var', '', 1, undef, undef ],
#            [ 'UserLastname',    Translatable('Lastname'),            'sn',                  1, 1, 'var', '', 1, undef, undef ],
#            [ 'UserLogin',       Translatable('Username'),            'uid',                 1, 1, 'var', '', 1, undef, undef ],
#            [ 'UserEmail',       Translatable('Email'),               'mail',                1, 1, 'var', '', 1, undef, undef ],
#            [ 'UserCustomerID',  Translatable('CustomerID'),          'mail',                0, 1, 'var', '', 1, undef, undef ],
#            # [ 'UserCustomerIDs', Translatable('CustomerIDs'),         'second_customer_ids', 1, 0, 'var', '', 1, undef, undef ],
#            [ 'UserPhone',       Translatable('Phone'),               'telephonenumber',     1, 0, 'var', '', 1, undef, undef ],
#            [ 'UserAddress',     Translatable('Address'),             'postaladdress',       1, 0, 'var', '', 1, undef, undef ],
#            [ 'UserComment',     Translatable('Comment'),             'description',         1, 0, 'var', '', 1, undef, undef ],
#
#            # this is needed, if "SMIME::FetchFromCustomer" is active
#            # [ 'UserSMIMECertificate', 'SMIMECertificate', 'userSMIMECertificate', 0, 1, 'var', '', 1, undef, undef ],
#
#            # Dynamic field example
#            # [ 'DynamicField_Name_X', undef, 'Name_X', 0, 0, 'dynamic_field', undef, 0, undef, undef ],
#        ],
#    };

    $Self->{CustomerCompany} = {
        Name   => Translatable('Database Backend'),
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

            # CaseSensitive defines if the data storage of your DBMS is case sensitive and will be
            # preconfigured within the database driver by default.
            # If the collation of your data storage differs from the default settings,
            # you can set the current behavior ( either 1 = CaseSensitive or 0 = CaseINSensitive )
            # to fit your environment.
            #
#            CaseSensitive => 0,

            # SearchCaseSensitive will control if the searches within the data storage are performed
            # case sensitively (if possible) or not. Change this option to 1, if you want to search case sensitive.
            # This can improve the performance dramatically on large databases.
            SearchCaseSensitive => 0,
        },

        # company unique id
        CustomerCompanyKey             => 'customer_id',
        CustomerCompanyValid           => 'valid_id',
        CustomerCompanyListFields      => [ 'customer_id', 'name' ],
        CustomerCompanySearchFields    => [ 'customer_id', 'name' ],
        CustomerCompanySearchPrefix    => '*',
        CustomerCompanySearchSuffix    => '*',
        CustomerCompanySearchListLimit => 250,
        CacheTTL                       => 60 * 60 * 24, # use 0 to turn off cache

        Map => [
            # Info about dynamic fields:
            #
            # Dynamic Fields of type CustomerCompany can be used within the mapping (see example below).
            # The given storage (third column) then can also be used within the following configurations (see above):
            # CustomerCompanySearchFields, CustomerCompanyListFields
            #
            # Note that the columns 'frontend' and 'readonly' will be ignored for dynamic fields.

            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly
            [ 'CustomerID',             'CustomerID', 'customer_id', 0, 1, 'var', '', 0 ],
            [ 'CustomerCompanyName',    'Customer',   'name',        1, 1, 'var', '', 0 ],
            [ 'CustomerCompanyStreet',  'Street',     'street',      1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyZIP',     'Zip',        'zip',         1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyCity',    'City',       'city',        1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyCountry', 'Country',    'country',     1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyURL',     'URL',        'url',         1, 0, 'var', '[% Data.CustomerCompanyURL | html %]', 0 ],
            [ 'CustomerCompanyComment', 'Comment',    'comments',    1, 0, 'var', '', 0 ],
            [ 'ValidID',                'Valid',      'valid_id',    0, 1, 'int', '', 0 ],

            # Dynamic field example
#            [ 'DynamicField_Name_Y', undef, 'Name_Y', 0, 0, 'dynamic_field', undef, 0 ],
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

    $Self->{'Frontend::CommonParam'} = {

        # param => default value
#        SomeParam => 'DefaultValue',
        Action => 'AdminInit',
    };

    $Self->{'CustomerFrontend::CommonParam'} = {

        # param => default value
#        SomeParam => 'DefaultValue',
    };

    $Self->{'PublicFrontend::CommonParam'} = {

        # param => default value
#        SomeParam => 'DefaultValue',
    };

    # If the public interface is protected with .htaccess
    # we can specify the htaccess login data here,
    # this is necessary for the support data collector
    # $Self->{'PublicFrontend::AuthUser'} = '';
    # $Self->{'PublicFrontend::AuthPassword'} = '';

    # --------------------------------------------------- #
    # Frontend Module Registry (Agent)
    # --------------------------------------------------- #
    # Module (from Kernel/Modules/*.pm) => Group

    # admin interface
    $Self->{'Frontend::Module'}->{Admin} = {
        Description => 'Admin Area.',
        Group       => [
            'admin',
        ],
        GroupRo     => [],
        NavBarName => 'Admin',
        Title      => '',
    };
    $Self->{'Loader::Module::Admin'}->{'000-Defaults'} = {
        CSS => [
            'Core.Agent.Admin.css',
        ],
        JavaScript => [
            'Core.Agent.Admin.js',
            'Core.UI.AllocationList.js',
            'Core.Agent.TableFilters.js',
        ],
    };
    $Self->{'Frontend::Navigation'}->{Admin}->{'001-Framework'} = [
        {
            Group       => [
                'admin',
            ],
            GroupRo     => [],
            AccessKey   => 'a',
            Block       => 'ItemArea',
            Description => 'Admin modules overview.',
            Link        => 'Action=Admin',
            LinkOption  => '',
            Name        => 'Admin',
            NavBar      => 'Admin',
            Prio        => '10000',
            Type        => 'Menu',
        },
    ];
    $Self->{'Frontend::NavigationModule'}->{Admin} = {
        Group       => [
            'admin',
        ],
        GroupRo     => [],
        Module => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
        Description => 'Admin modules overview.',
        IconBig => '',
        IconSmall => '',
        Name => '',
        Block => '',
    };

    $Self->{'Frontend::Module'}->{AdminInit} = {
        Description => 'Admin',
        Group       => [
            'admin',
        ],
        GroupRo     => [],
        NavBarName => '',
        Title      => 'Init',
    };
    $Self->{'Frontend::Module'}->{AdminLog} = {
        Description => 'Admin',
        Group       => [
            'admin',
        ],
        GroupRo     => [],
        NavBarName => 'Admin',
        Title      => 'System Log',
    };
    $Self->{'Loader::Module::AdminLog'}->{'000-Defaults'} = {
        JavaScript => [
          'Core.Agent.Admin.Log.js'
        ],
    };
    $Self->{'Frontend::NavigationModule'}->{AdminLog} = {
        GroupRo     => [],
        Group       => [
            'admin',
        ],
        Description => Translatable('View system log messages.'),
        IconBig     => 'fa-file-text-o',
        IconSmall   => '',
        Module      => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
        Name        => Translatable('System Log'),
        Block => 'Administration',
    };

    $Self->{'Frontend::Module'}->{AdminSystemConfiguration} = {
        Group        => ['admin'],
        GroupRo     => [],
        Description  => 'Admin.',
        Title        => 'System Configuration',
        NavBarName   => 'Admin',
    };
    $Self->{'Loader::Module::AdminSystemConfiguration'}->{'000-Defaults'} = {
        CSS => [
            'Core.Agent.Admin.SystemConfiguration.css',
        ],
        JavaScript => [
            'thirdparty/clipboardjs-1.7.1/clipboard.min.js',
            'Core.SystemConfiguration.js',
            'Core.SystemConfiguration.Date.js',
            'Core.Agent.Admin.SystemConfiguration.js',
        ],
    };
    $Self->{'Frontend::NavigationModule'}->{AdminSystemConfiguration} = {
        Group        => ['admin'],
        GroupRo      => [],
        Module      => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
        Name        => Translatable('System Configuration'),
        Description => Translatable('Edit the system configuration settings.'),
        Block       => 'System',
        IconBig     => '',
        IconSmall    => '',
        Block => 'Administration',
    };

    $Self->{'Frontend::Module'}->{AdminPackageManager} = {
        Description => 'Software Package Manager.',
        Group       => [
            'admin',
        ],
        GroupRo     => [],
        NavBarName => 'Admin',
        Title      => 'Package Manager',
    };
    $Self->{'Frontend::NavigationModule'}->{AdminPackageManager} = {
        Group       => [
            'admin',
        ],
        GroupRo      => [],
        IconBig     => 'fa-plug',
        IconSmall => '',
        Description => Translatable('Update and extend your system with software packages.'),
        Module      => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
        Name        => Translatable('Package Manager'),
        Block => 'Administration',
    };

    # specify Loader settings for Login screens
    $Self->{'Loader::Module::Login'}->{'000-Defaults'} = {
        JavaScript => [
            'Core.Agent.Login.js',
        ],
    };

    $Self->{'Loader::Module::CustomerLogin'}->{'000-Defaults'} = {
        JavaScript => [
            'Core.Customer.Login.js',
        ],
    };

    # specify Loader settings for the installer
    $Self->{'Loader::Module::Installer'}->{'000-Defaults'} = {
        JavaScript => [
            'Core.Installer.js',
        ],
        CSS => [
            'Core.Installer.css',
        ],
    };

    return 1;
}

#
# Hereafter the functions should be documented in Kernel::Config (Kernel/Config.pod.dist), not in
#   Kernel::Config:Defaults.
#

# Please see the documentation in Kernel/Config.pod.dist.
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

        # Resorting the filelist.
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

        FILE:
        for my $File (@Files) {

            # do not use ZZZ files
            if ( $Param{Level} && $Param{Level} eq 'Default' && $File =~ /ZZZ/ ) {
                next FILE;
            }

            my $RelativeFile = $File =~ s{\Q$Self->{Home}\E/*}{}gr;

            # Extract package name and load it.
            my $Package = $RelativeFile;
            $Package =~ s/^\///g;
            $Package =~ s/\/{2,}/\//g;
            $Package =~ s/\//::/g;
            $Package =~ s/\.pm$//g;

            eval {

                # Try to load file.
                if ( !require $RelativeFile ) {
                    die "ERROR: Could not load $File: $!\n";
                }

                # Check if package has loaded and has a Load() method.
                if (!$Package->can('Load')) {
                    die "$Package has no Load() method.";
                }

                # Call package method but pass $Self as instance.
                $Package->Load($Self);
            };

            if ( $@ ) {
                my $ErrorMessage = $@;
                print STDERR $@;
                next FILE;
            }
        }
    }

    # load RELEASE file
    if ( -e !"$Self->{Home}/RELEASE" ) {
        print STDERR
            "ERROR: $Self->{Home}/RELEASE does not exist! This file is needed by central system parts of OTRS, the system will not work without this file.\n";
        die;
    }

    if ( open( my $Product, '<', "$Self->{Home}/RELEASE" ) ) {    ## no critic

        while ( my $Line = <$Product> ) {

            # filtering of comment lines
            if ( $Line !~ /^#/ ) {

                if ( $Line =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Self->{Product} = $1;
                }
                elsif ( $Line =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Self->{Version} = $1;
                }
            }
        }

        close $Product;
    }
    else {
        print STDERR
            "ERROR: Can't read $Self->{Home}/RELEASE: $! This file is needed by central system parts of OTRS, the system will not work without this file.\n";
        die;
    }

    # load config (again)
    $Self->Load();

    # do not use ZZZ files
    if ( !$Param{Level} ) {

        # replace config variables in config variables
        KEY:
        for my $Key ( sort keys %{$Self} ) {

            next KEY if !defined $Key;

            if ( defined $Self->{$Key} ) {
                $Self->{$Key} =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{$1}/g;
            }
            else {
                print STDERR "ERROR: $Key not defined!\n";
            }
        }
    }

    $Self->AutoloadPerlPackages();

    return $Self;
}

# Please see the documentation in Kernel/Config.pod.dist.
sub Get {
    my ( $Self, $What ) = @_;

    # debug
    if ( $Self->{Debug} > 1 ) {
        my $Value = defined $Self->{$What} ? $Self->{$What} : '<undef>';
        print STDERR "Debug: Config.pm ->Get('$What') --> $Value\n";
    }

    return $Self->{$What};
}

# Please see the documentation in Kernel/Config.pod.dist.
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

## nofilter(TidyAll::Plugin::OTRS::Perl::Translatable)

# This is a no-op to mark a text as translatable in the Perl code.
#   We use our own version here instead of importing Language::Translatable to not add a dependency.

sub Translatable {
    return shift;
}

# Please see the documentation in Kernel/Config.pod.dist.
sub ConfigChecksum {
    my $Self = shift;

    my @Files = glob( $Self->{Home} . "/Kernel/Config/Files/*.pm" );

    # Ignore ZZZAAuto.pm, because this is only a cached version of the XML files which
    # will be in the checksum. Otherwise the SysConfig cannot use its cache files.
    @Files = grep { $_ !~ m/ZZZAAuto\.pm$/smx } @Files;

    push @Files, glob( $Self->{Home} . "/Kernel/Config/Files/*.xml" );
    push @Files, $Self->{Home} . "/Kernel/Config/Defaults.pm";
    push @Files, $Self->{Home} . "/Kernel/Config.pm";

    # Create a string with filenames and file mtimes of the config files
    my $ConfigString;
    for my $File (@Files) {

        # get file metadata
        my $Stat = stat($File);

        if ( !$Stat ) {
            print STDERR "Error: cannot stat file '$File': $!";
            return;
        }

        $ConfigString .= $File . $Stat->mtime();
    }

    return Digest::MD5::md5_hex($ConfigString);
}

sub AutoloadPerlPackages {
    my ($Self) = @_;

    return 1 if !$Self->{AutoloadPerlPackages};
    return 1 if ref $Self->{AutoloadPerlPackages} ne 'HASH';
    my %AutoloadConfiguration = %{ $Self->{AutoloadPerlPackages} };
    return 1 if !%AutoloadConfiguration;

    CONFIGKEY:
    for my $ConfigKey (sort keys %AutoloadConfiguration) {

        my $ConfigValue = $AutoloadConfiguration{$ConfigKey};

        next CONFIGKEY if ref $ConfigValue ne 'ARRAY';

        PACKAGE:
        for my $Package ( @{$ConfigValue} ) {

            next PACKAGE if !$Package;

            if ( substr($Package, 0, 16) ne 'Kernel::Autoload' ) {
                print STDERR "Error: Autoload packages must be located in Kernel/Autoload, skipping $Package\n";
                next PACKAGE;
            }

            # Don't use the MainObject here to load the file.
            eval {
                my $FileName = $Package =~ s{::}{/}smxgr;
                require $FileName . '.pm'; ## nofilter(TidyAll::Plugin::OTRS::Perl::Require)
            };
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
