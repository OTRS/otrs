# --
# Kernel/Config/Defaults.pm - Default Config file for OTRS kernel
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Defaults.pm,v 1.154.2.7 2005-11-20 21:41:29 martin Exp $
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
# --
package Kernel::Config::Defaults;

use strict;
use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.154.2.7 $';
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

    # TicketHook
    # (To set the Ticket identifier. Some people want to
    # set this to e. g. 'Call#', 'MyTicket#' or 'Ticket#'.)
    $Self->{TicketHook} = 'Ticket#';

    # FQDN
    # (Full qualified domain name of your system.)
    $Self->{FQDN} = 'yourhost.example.com';

    # ScriptAlias
    # Prefix to index.pl used as ScriptAlias in web config
    # (Used when emailing links to agents).
    $Self->{ScriptAlias} = 'otrs/';

    # HttpType
    # In case you use https instead of plain http specify it here
    $Self->{HttpType} = 'http';

    # AdminEmail
    # (Email of the system admin.)
    $Self->{AdminEmail} = 'admin@example.com';

    # MIME-Viewer for online to html converter
    # (e. g. xlhtml (xls2html), http://chicago.sourceforge.net/xlhtml/)
#    $Self->{'MIME-Viewer'}->{'application/excel'} = 'xlhtml';
    # MIME-Viewer for online to html converter
    # (e. g. wv (word2html), http://wvware.sourceforge.net/)
#    $Self->{'MIME-Viewer'}->{'application/msword'} = 'wvWare';
    # (e. g. pdftohtml (pdf2html), http://pdftohtml.sourceforge.net/)
#    $Self->{'MIME-Viewer'}->{'application/pdf'} = 'pdftohtml -stdout -i';

    # SendmailModule
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

    # Organization
    # (If this is anything other than '', then the email will have an
    # Organization X-Header)
#    $Self->{Organization} = 'Example Company';
    $Self->{Organization} = '';

    # TimeZone
    # (set the system time zone, default is local time)
#    $Self->{TimeZone} = 0;
#    $Self->{TimeZone} = +9;

    # TimeWeekdaysCounted
    # (counted days for sla time used)
    $Self->{TimeWeekdaysCounted} = {
        Mon => 1,
        Tue => 1,
        Wed => 1,
        Thu => 1,
        Fri => 1,
        Sat => 0,
        Sun => 0,
    };

    # TimeWorkingHours
    # (counted hours for sla time used)
    $Self->{TimeWorkingHours} = {
        Mon => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Tue => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Wed => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Thu => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Fri => [ 8,9,10,11,12,13,14,15,16,17,18,19,20 ],
        Sat => [  ],
        Sun => [  ],
    };

    # TimeVacationDays
    # adde new own days with:
    # "$Self->{TimeVacationDays}->{10}->{27} = 'Some Info';"

    $Self->{TimeVacationDays} = {
        1 => {
            01 => 'New Year\'s Eve!',
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
    # "$Self->{TimeVacationDaysOneTime}->{1977}-{10}->{27} = 'Some Info';"

    $Self->{TimeVacationDaysOneTime} = {
#        2004 => {
#          6 => {
#              07 => 'Some Day',
#          },
#          12 => {
#              24 => 'Some A Day',
#              31 => 'Some B Day',
#          },
#        },
#        2005 => {
#          1 => {
#              11 => 'Some Day',
#          },
#        },
    };

    # CustomQueue
    # (The name of custom queue.)
    $Self->{CustomQueue} = 'My Queues';

    # QueueViewAllPossibleTickets
    # (show all ro and rw queues - not just rw queues)
    $Self->{QueueViewAllPossibleTickets} = 0;

    # QueueListType
    # (show queues in system as tree or as list) [tree|list]
    $Self->{QueueListType} = 'tree';

    # MoveType
    # (Show form drop down of show new page of new queues) [form|link]
    $Self->{MoveType} = 'form';
    $Self->{MoveSetState} = 0;
    # default move next state
    $Self->{DefaultNextMoveStateType} = ['open', 'closed'];

    # NoteSetState
    # (possible to set ticket state via AgentNote)
    $Self->{NoteSetState} = 0;
    # default note next state
    $Self->{DefaultNextNoteStateType} = ['new', 'open', 'closed'];

    # ChangeOwnerToEveryone -> useful for ASP
    # (Possible to change owner of ticket ot everyone) [0|1]
    $Self->{ChangeOwnerToEveryone} = 0;

    # MaxFileUpload
    # (Max size for browser file uploads - default 5 MB)
    $Self->{MaxFileUpload} = 1024 * 1024 * 5;

    # CheckEmailAddresses
    # (Check syntax of used email addresses)
    $Self->{CheckEmailAddresses} = 1;

    # CheckMXRecord
    # (Check mx recorde of used email addresses)
    $Self->{CheckMXRecord} = 1;

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

    # UserTable
    $Self->{DatabaseUserTable} = 'system_user';
    $Self->{DatabaseUserTableUserID} = 'id';
    $Self->{DatabaseUserTableUserPW} = 'pw';
    $Self->{DatabaseUserTableUser} = 'login';

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
    $Self->{UserSyncLDAPMap} = {
        # DB -> LDAP
        Firstname => 'givenName',
        Lastname => 'sn',
        Email => 'mail',
    };

    # --------------------------------------------------- #
    # default agent settings                              #
    # --------------------------------------------------- #
    # ViewableTicketLines
    # (Max viewable ticket lines in the QueueView.)
    $Self->{ViewableTicketLines} = 18;

    # ViewableTicketNewLine
    # (insert new line in ticket-article after max x chars and
    # the next word)
    $Self->{ViewableTicketNewLine} = 85;

    # ViewableTicketLinesZoom
    # (Max viewable ticket lines in the QueueZoom.)
    $Self->{ViewableTicketLinesZoom} = 6000;

    # MaxLimit
    # (Max viewable tickets a page.)
    $Self->{MaxLimit} = 1200;

    # TextAreaEmailWindow
    # (width of compose email windows)
    $Self->{TextAreaEmailWindow} = 78;

    # TextAreaNoteWindow
    # (width of compose note windows)
    $Self->{TextAreaNoteWindow} = 60;

    # Highligh*
    # (Set the age and the color for highlighting of old queue
    # in the QueueView.)
    # highlight age1 in min
    $Self->{HighlightAge1} = 1440;
    $Self->{HighlightColor1} = 'orange';
    # highlight age2 in min
    $Self->{HighlightAge2} = 2880;
    $Self->{HighlightColor2} = 'red';

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


    # agent interface article notification module to check gpg
    $Self->{'Frontend::ArticleModule'}->{'1-PGP'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckPGP',
    };
    # agent interface article notification module to check smime
    $Self->{'Frontend::ArticleModule'}->{'1-SMIME'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckSMIME',
    };

    # agent interface article notification module to check gpg
    $Self->{'Frontend::ArticlePreViewModule'}->{'1-PGP'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckPGP',
    };
    # agent interface article notification module to check smime
    $Self->{'Frontend::ArticlePreViewModule'}->{'1-SMIME'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckSMIME',
    };

    $Self->{'Frontend::ArticleComposeModule'}->{'1-SignEmail'} = {
        Module => 'Kernel::Output::HTML::ArticleComposeSign',
    };
    $Self->{'Frontend::ArticleComposeModule'}->{'2-CryptEmail'} = {
        Module => 'Kernel::Output::HTML::ArticleComposeCrypt',
    };

    # Frontend::Output::PostFilter
    # (a output filter for application html output, e. g. to filter
    # java script, java applets, ...)
#    $Self->{'Frontend::Output::PostFilter'}->{'ActiveElementFilter'} = {
#        Module => 'Kernel::Output::HTML::OutputFilterActiveElement',
#        Debug => 0,
#    };

    # AgentQueueSortDefault
    # (default sort order of the queue view / after priority sort)
    # ASC: oldest on top, default
    # DESC: youngest on top
    $Self->{AgentQueueSortDefault} = 'ASC';

    # AgentQueueSort
    # (sort a queue ascending or descending / after priority sort)
    #
    # assignment: QueueID -> Value
    # where value is one of:
    # 0: ascending (oldest on top, default)
    # 1: descending (youngest on top)
    #
#    $Self->{AgentQueueSort} = {
#        7 => 1,
#        3 => 0,
#    };

    # --------------------------------------------------- #
    # AgentStatusView (shows all open tickets)            #
    # --------------------------------------------------- #
    $Self->{'AgentStatusView::ViewableTicketsPage'} = 50;

    # --------------------------------------------------- #
    # AgentUtil                                           #
    # --------------------------------------------------- #
    # default limit for ticket search
    # [default: 1000]
    $Self->{SearchLimit} = 1000;

    # defaut of shown article a page
    # [default: 15]
    $Self->{SearchPageShown} = 40;

    # viewable ticket lines by search util
    # [default: 10]
    $Self->{ViewableTicketLinesBySearch} = 10;

    # AgentUtilArticleTreeCSV
    # export also whole article tree in search result export
    # (take care of your performance!)
    # [default: 0]
    $Self->{AgentUtilArticleTreeCSV} = 0;

    # AgentUtilCSVData
    # (used csv data)
    $Self->{AgentUtilCSVData} = ['TicketNumber','Age','Created','State','Priority','Queue','Lock','Owner','UserFirstname','UserLastname','CustomerID','CustomerName','From','Subject','AccountedTime','TicketFreeKey1','TicketFreeText1','TicketFreeKey2','TicketFreeText2','TicketFreeKey3','TicketFreeText3','TicketFreeKey4','TicketFreeText4','TicketFreeKey5','TicketFreeText5','TicketFreeKey6','TicketFreeText6','TicketFreeKey7','TicketFreeText7','TicketFreeKey8','TicketFreeText8','ArticleTree',''];

    # AgentUtil::DB::*
    # (if you want to use a mirror database for agent ticket fulltext search)
#    $Self->{'AgentUtil::DB::DSN'} = "DBI:mysql:database=mirrordb;host=mirrordbhost";
#    $Self->{'AgentUtil::DB::User'} = "some_user";
#    $Self->{'AgentUtil::DB::Password'} = "some_password";

    # SystemStats
    $Self->{SystemStatsMap}->{"OTRS::Stats1"} = {
        Name => 'New Tickets',
        Module => 'Kernel::System::Stats::NewTickets',
        Desc => 'New created tickets for each queue in selected month.',
        SumCol => 1,
        SumRow => 1,
#        UseResultCache => 1,
#        Output => ['Print', 'CSV', 'GraphLine', 'GraphBars', 'GraphPie'],
        Output => ['Print', 'CSV', 'Graph'],
        OutputDefault => 'Print',
    };
    $Self->{SystemStatsMap}->{"OTRS::Stats2"} = {
        Name => 'Ticket Overview',
        Module => 'Kernel::System::Stats::TicketOverview',
        Desc => 'Overview of the tickets in queue at the end of this month.',
        SumCol => 1,
        SumRow => 1,
        UseResultCache => 1,
#        Output => ['Print', 'CSV', 'GraphLine', 'GraphBars', 'GraphPie'],
        Output => ['Print', 'CSV', 'Graph'],
        OutputDefault => 'Print',
    };
    $Self->{SystemStatsMap}->{"OTRS::Stats4"} = {
        Name => 'State Action Overview',
        Module => 'Kernel::System::Stats::StateAction',
        Desc => 'Trace system activities (Replacement of old bin/mkStats.pl).',
        SumCol => 1,
        SumRow => 1,
#        UseResultCache => 1,
#        Output => ['Print', 'CSV', 'GraphLine', 'GraphBars', 'GraphPie'],
        Output => ['Print', 'CSV', 'Graph'],
        OutputDefault => 'Graph',
    };

    # --------------------------------------------------- #
    # URL login and logout settings                       #
    # --------------------------------------------------- #

    # LoginURL
    # (If this is anything other than '', then it is assumed to be the
    # URL of an alternate login screen which will be used in place of
    # the default one.)
    $Self->{LoginURL} = '';
#    $Self->{LoginURL} = 'http://host.example.com/cgi-bin/login.pl';

    # LogoutURL
    # (If this is anything other than '', it is assumed to be the URL
    # of an alternate logout page which users will be sent to when they
    # logout.)
    $Self->{LogoutURL} = '';
#    $Self->{LogoutURL} = 'http://host.example.com/cgi-bin/login.pl';

    # PreApplicationModule
    # (Used for every request, if defined, the PreRun() function of
    # this module will be used. This interface use useful to check
    # some user options or to redirect not accept new application
    # news)
#    $Self->{PreApplicationModule} = 'Kernel::Modules::AgentInfo';
    # Kernel::Modules::AgentInfo check key, if this user preferences key
    # is true, then the message is already accepted
#    $Self->{InfoKey} = 'wpt22';
    # shown InfoFile located under Kernel/Output/HTML/Standard/AgentInfo.dtl
#    $Self->{InfoFile} = 'AgentInfo';

    # --------------------------------------------------- #
    # LogModule                                           #
    # --------------------------------------------------- #
    # (log backend module)
    $Self->{LogModule} = 'Kernel::System::Log::SysLog';
#    $Self->{LogModule} = 'Kernel::System::Log::File';

    # param for LogModule Kernel::System::Log::SysLog
#    $Self->{'LogModule::SysLog::Facility'} = 'user';

    # param for LogModule Kernel::System::Log::SysLog
    # (if syslog can't work with utf-8, force the log
    # charset with this option, on other chars will be
    # replaces with ?)
#    $Self->{'LogModule::SysLog::Charset'} = 'iso-8859-15';
#    $Self->{'LogModule::SysLog::Charset'} = 'utf-8';

    # param for LogModule Kernel::System::Log::File (required!)
    $Self->{'LogModule::LogFile'} = '/tmp/otrs.log';

    # param if the date (yyyy-mm) should be added as suffix to
    # logfile [0|1]
#    $Self->{'LogModule::LogFile::Date'} = 0;

    # system log cache size for admin system log (default 4k)
#    $Self->{LogSystemCacheSize} = 4*1024;
    # --------------------------------------------------- #
    # web stuff                                           #
    # --------------------------------------------------- #
    # CGIHandle
    # (Global CGI handle.)
    # !!$Self->{CGIHandle} = 'index.pl';!!
    # -=> CGIHandle not longer exists. CGIHandle is automatically the
    #     script name (It is possible to rename index.pl to otrs.cgi!).

    # CGILogPrefix
    $Self->{CGILogPrefix} = 'OTRS-CGI';

    # LostPassword
    # (use lost password feature)
    $Self->{LostPassword} = 1;

    # ShowMotd
    # (show message of the day in login screen)
    $Self->{ShowMotd} = 0;

    # SpellChecker
    # (If ispell or aspell is available, then we will provide a spelling
    # checker.)
#    $Self->{SpellChecker} = '';
    $Self->{SpellChecker} = '/usr/bin/ispell';
    $Self->{SpellCheckerDictDefault} = 'english';

    # SpellCheckerIgnore
    # (A list of ignored words.)
    $Self->{SpellCheckerIgnore} = ['www', 'webmail', 'https', 'http', 'html'];

    # DemoSystem
    # (If this is true, no agent preferences, like language and theme, via agent
    # frontend can be updated! Just for the current session. Alow no password can
    # be changed on agent frontend.)
    $Self->{DemoSystem} = 0;

    # AgentCanBeCustomer
    # (use this if an agent can also be a customer via the agent interface)
    $Self->{AgentCanBeCustomer} = 0;

    # Agent::DownloadType
    # (if the tickets attachments will be opened in browser or just to
    # force the download) [attachment|inline]
#    $Self->{'Agent::DownloadType'} = 'inline';
    $Self->{'Agent::DownloadType'} = 'attachment';

    # --------------------------------------------------- #
    # directories                                         #
    # --------------------------------------------------- #
    # root directory
    $Self->{Home} = '/opt/otrs';
    # counter log
    $Self->{CounterLog} = '<OTRS_CONFIG_Home>/var/log/TicketCounter.log';
    # article fs dir
    $Self->{ArticleDir} = '<OTRS_CONFIG_Home>/var/article';
    # stats dir
    $Self->{StatsPicDir} = '<OTRS_CONFIG_Home>/var/pics/stats';
    # html template dir
    $Self->{TemplateDir} = '<OTRS_CONFIG_Home>/Kernel/Output';
    # tmp dir
    $Self->{TempDir} = '<OTRS_CONFIG_Home>/var/tmp';

    # --------------------------------------------------- #
    # Ticket stuff                                        #
    # (Viewable tickets in queue view)                    #
    # --------------------------------------------------- #
    # ViewableSenderTypes
    #  default:  ["'customer'"]
    $Self->{ViewableSenderTypes} = ["'customer'"];

    # ViewableLocks
    # default: ["'unlock'", "'tmp_lock'"]
    $Self->{ViewableLocks} = ["'unlock'", "'tmp_lock'"];

    # ViewableStateType
    # (see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{ViewableStateType} = ['new', 'open', 'pending reminder', 'pending auto'];

    # UnlockStateType
    # (Tickets which can be unlocked by bin/UnlockTickets.pl
    # (see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{UnlockStateType} = ['open', 'new'];

    # PendingReminderStateType
    # (used for reminder notifications
    # see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{PendingReminderStateType} = ['pending reminder'];

    # PendingAutoStateType
    # (used for pending states which changed state after reached pending time
    # see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{PendingAutoStateType} = ['pending auto'];

    # state after pending
    # (state after pending time has reached)
    $Self->{StateAfterPending} = {
        'pending auto close+' => 'closed successful',
        'pending auto close-' => 'closed unsuccessful',
    };

    # TicketStorageModule (Don't use it for big emails/attachments!)
    # (where attachments and co is stored - switch from fs -> db and
    # db -> fs is possible)
    $Self->{TicketStorageModule} = 'Kernel::System::Ticket::ArticleStorageDB';
    # FS is faster but webserver user should be the otrs user)
#    $Self->{TicketStorageModule} = 'Kernel::System::Ticket::ArticleStorageFS';

    # TicketCustomModule
    # (custom functions to redefine Kernel::System::Ticket functions)
#    $Self->{TicketCustomModule} = 'Kernel::System::Ticket::Custom';

    $Self->{'TicketACL::Default::Action'} = {
        AgentLock => 1,
        AgentZoom => 1,
        AgentClose => 1,
        AgentPending => 1,
        AgentNote => 1,
        AgentHistory => 1,
        AgentPriority => 1,
        AgentFreeText => 1,
        AgentHistory => 1,
        AgentCompose => 1,
        AgentBounce => 1,
        AgentTicketPrint => 1,
        AgentForward => 1,
        AgentTicketLink => 1,
        AgentPrint => 1,
        AgentPhone => 1,
        AgentCustomer => 1,
        AgentOwner => 1,
    };

    # UncountedUnlockTime
    # (don't count this hours as unlock time - weekdays: Mon,Tue,Wed,Thu,Fri,Sat,Sun;)
    $Self->{UncountedUnlockTime} = {
        Fri => [ 16,17,18,19,20,21,22,23 ],
        Sat => [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 ],
        Sun => [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 ],
        Mon => [ 0,1,2,3,4,5,6,7,8 ],
    };

    # SendNoPendingNotificationTime
    # (send no pending notification this hours)
    $Self->{SendNoPendingNotificationTime} = {
        Mon => [ 0,1,2,3,4,5,6 ],
        Tue => [ 0,1,2,3,4,5,6 ],
        Wed => [ 0,1,2,3,4,5,6 ],
        Thu => [ 0,1,2,3,4,5,6 ],
        Fri => [ 0,1,2,3,4,5,6,21,22,23 ],
        Sat => [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 ],
        Sun => [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 ],
    };

    # Lock::ForceNewStateAfterLock
    # (force a new ticket state after lock action)
#    $Self->{'Lock::ForceNewStateAfterLock'} = {
#        'new' => 'open',
#    };

    # Move::ForceUnlockAfterMove
    # (force to unlock a ticket after move action)
    $Self->{'Move::ForceUnlockAfterMove'} = 0;

    # --------------------------------------------------- #
    # TicketNumberGenerator                               #
    # --------------------------------------------------- #
    # Kernel::System::Ticket::Number::AutoIncrement (default) --> auto increment
    #   ticket numbers "SystemID.Counter" like 1010138 and 1010139.
    #
    # Kernel::System::Ticket::Number::Date --> ticket numbers with date
    #   "Year.Month.Day.SystemID.Counter" like 200206231010138 and 200206231010139.
    #
    # Kernel::System::Ticket::Number::DateChecksum --> ticket numbers with date and
    #   check sum and the counter will be rotated daily (my favorite)
    #   "Year.Month.Day.SystemID.Counter.CheckSum" like 2002070110101520 and 2002070110101535.
    #
    # Kernel::System::Ticket::Number::Random -->
    #   random ticket numbers "SystemID.Random" like 100057866352 and 103745394596.
#    $Self->{TicketNumberGenerator} = 'Kernel::System::Ticket::Number::Date';
#    $Self->{TicketNumberGenerator} = 'Kernel::System::Ticket::Number::DateChecksum';
#    $Self->{TicketNumberGenerator} = 'Kernel::System::Ticket::Number::Random';
#    $Self->{TicketNumberGenerator} = 'Kernel::System::Ticket::Number::AutoIncrement';

    $Self->{TicketNumberGenerator} = 'Kernel::System::Ticket::Number::DateChecksum';

    # further config option for Kernel::System::Ticket::Number::AutoIncrement
    # (min ticket counter size)
#    $Self->{'TicketNumberGenerator::AutoIncrement::MinCounterSize'} = 5;

    # --------------------------------------------------- #
    # TicketViewAccelerator                               #
    # --------------------------------------------------- #
    # choose your backend TicketViewAccelerator module

    # RuntimeDB
    # (generate each queue view on the fly from ticket table you will not
    # have performance trouble till ~ 60.000 tickets (till 6.000 open tickets)
    # in your system)
    $Self->{TicketIndexModule} = 'Kernel::System::Ticket::IndexAccelerator::RuntimeDB';

    # StaticDB
    # (the most powerfull module, it should be used over 80.000 (more the 6.000
    # open tickets) tickets in a system - use a extra ticket_index table, works
    # like a view - use bin/RebuildTicketIndex.pl for initial index update)
#    $Self->{TicketIndexModule} = 'Kernel::System::Ticket::IndexAccelerator::StaticDB';

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
#            ro => 'Romanian',
#            hr => 'Croatian',
#            sk => 'Slovak',
#            sl => 'Slovenian',
#            da => 'Dansk',
#            jp => 'jp',
    };
    # default theme
    # (the default html theme) [default: Standard]
    $Self->{DefaultTheme} = 'Standard';
    # OnChangeSubmit
    # (Use the onchange=submit() function for ticket move in
    # QueueView and TicketZoom) [default: 0] [0|1]
    $Self->{OnChangeSubmit} = 0;
    # StdResponsesMethod
    # (should the standard responses selection be a form or links?) [Form|Link]
    $Self->{StdResponsesMethod} = 'Link';
    # TicketZoomExpand
    # (show article expanded int ticket zoom)
    $Self->{TicketZoomExpand} = 0;
    # TicketZoomExpandSort
    # (show article normal or in reverse order) [normal|reverse]
#    $Self->{TicketZoomExpandSort} = 'reverse';
    $Self->{TicketZoomExpandSort} = 'normal';
    # TimeUnits
    # (your choice of your used time units, minutes, hours, work units, ...)
#    $Self->{TimeUnits} = ' (minutes)';
#    $Self->{TimeUnits} = ' (hours)';
    $Self->{TimeUnits} = ' (work units)';
    # ShowAlwaysLongTime
    # (show always time in long /days hours minutes/ or short
    # /days hours/ format)
    $Self->{ShowAlwaysLongTime} = 0;
    # PendingDiffTime
    # (Time in sec. which "pending date" shows per default) [default: 24*60*60 -=> 1d]
    $Self->{PendingDiffTime} = 24*60*60;
    # FrontendNeedAccountedTime
    # (time must be accounted)
    $Self->{FrontendNeedAccountedTime} = 0;
    # FrontendNeedSpellCheck
    # (compose message must be spell checked)
    $Self->{FrontendNeedSpellCheck} = 0;
    # FrontendBulkFeature
    # (a agent frontend feature to work on more then one ticket
    # at on time)
    $Self->{FrontendBulkFeature} = 1;
    # FrontendBulkFeatureJavaScriptAlert
    # (enable/disable java script popup if a bulk ticket is selected)
    $Self->{FrontendBulkFeatureJavaScriptAlert} = 1;
    # --------------------------------------------------- #
    # TicketFreeText                                      #
    # (define free text options for frontend)             #
    # --------------------------------------------------- #
#    $Self->{"TicketFreeKey1"} = {
#        '' => '-',
#        'Product' => 'Product',
#    };
#    $Self->{"TicketFreeText1"} = {
#        '' => '-',
#        'PC' => 'PC',
#        'Notebook' => 'Notebook',
#        'LCD' => 'LCD',
#        'Phone' => 'Phone',
#    };
#    $Self->{"TicketFreeKey2"} = {
#        '' => '-',
#        'Support' => 'Support',
#    };

    # default selections (if wanted)
    # $Self->{"TicketFreeText1::DefaultSelection"} = 'Notebook';

    # --------------------------------------------------- #
    # defaults for add note                               #
    # --------------------------------------------------- #
    # default note type
    $Self->{DefaultNoteType} = 'note-internal';
    $Self->{DefaultNoteTypes} = {
        'note-internal' => 1,
        'note-external' => 0,
        'note-report' => 0,
    };
    # default note subject
    $Self->{DefaultNoteSubject} = '$Text{"Note!"}';
    # default note text
    $Self->{DefaultNoteText} = '';

    # --------------------------------------------------- #
    # defaults for pending ticket                         #
    # --------------------------------------------------- #
    # PendingNoteSubject
    $Self->{DefaultPendingNoteSubject} = 'Pending!';
    # PendingNoteText
    $Self->{DefaultPendingNoteText} = '';
    # next possible states for pendinf screen
    $Self->{DefaultPendingNextStateType} = ['pending reminder', 'pending auto'];

    # --------------------------------------------------- #
    # defaults for close ticket                           #
    # --------------------------------------------------- #
    # CloseNoteType
    $Self->{DefaultCloseNoteType} = 'note-internal';
    # CloseNoteSubject
    $Self->{DefaultCloseNoteSubject} = 'Close!';
    # CloseNoteText
    $Self->{DefaultCloseNoteText} = '';
    # CloseType
    $Self->{DefaultCloseType} = 'closed successful';
    # next possible states for close screen
    $Self->{DefaultCloseNextStateType} = ['closed'];

    # --------------------------------------------------- #
    # defaults for compose message                        #
    # --------------------------------------------------- #
    # default compose next state
    $Self->{DefaultNextComposeType} = 'open';
    # new line after x chars and one word
    $Self->{ComposeTicketNewLine} = 72;
    # next possible states for compose message
    $Self->{DefaultNextComposeStateType} = ['open', 'closed', 'pending auto', 'pending reminder'];
    # unix_style
    $Self->{ResponseFormat} = '$Data{"Salutation"}
$Data{"OrigFrom"} $Text{"wrote"}:
$Data{"Body"}

$Data{"StdResponse"}

$Data{"Signature"}
';
    # ms_style
#    $Self->{ResponseFormat} = '$Data{"Salutation"}
#
#$Data{"StdResponse"}
#
#$Data{"OrigFrom"} $Text{"wrote"}:
#$Data{"Body"}
#
#$Data{"Signature"}
#';

    # --------------------------------------------------- #
    # defaults for bounce                                 #
    # --------------------------------------------------- #
    # default bounce next state
    $Self->{DefaultNextBounceType} = 'closed successful';
    # next possible states for bounce message
    $Self->{DefaultNextBounceStateType} = ['open', 'closed'];
    # default note text
    $Self->{DefaultBounceText} = 'Your email with ticket number "<OTRS_TICKET>" '.
      'is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.';

    # --------------------------------------------------- #
    # defaults for forward message                        #
    # --------------------------------------------------- #
    # next possible states for forward message
    $Self->{DefaultNextForwardStateType} = ['open', 'closed'];
    # possible email type
    $Self->{DefaultForwardEmailType} = [
        'email-external',
        'email-internal',
    ];
    $Self->{DefaultForwardEmailTypeSelected} = 'email-external';

    # --------------------------------------------------- #
    # add std responses when a new queue is created       #
    # --------------------------------------------------- #
    # array of std responses
    $Self->{StdResponse2QueueByCreating} = [
         'empty answer',
    ];
    # array of std response ids
    $Self->{StdResponseID2QueueByCreating} = [
#        1,
    ];

    # --------------------------------------------------- #
    # user preferences settings                           #
    # (allow you to add simply more user preferences)     #
    # --------------------------------------------------- #
    $Self->{UserPreferencesMaskUse} = [
      # keys
      # html params in dtl files
      'ID',
      'Salutation',
      'Login',
      'Firstname',
      'Lastname',
      'Email',
      'ValidID',
      'Pw',
    ];

    # --------------------------------------------------- #
    #  default queue  settings                            #
    #  these settings are used by the CLI version         #
    # --------------------------------------------------- #
    $Self->{QueueDefaults} = {
        UnlockTimeout => 0,
        EscalationTime => 0,
        FollowUpLock => 0,
        SystemAddressID => 1,
        SalutationID => 1,
        SignatureID => 1,
        FollowUpID => 1,
        FollowUpLock => 0,
        MoveNotify => 0,
        LockNotify => 0,
        StateNotify => 0,
    };

    # --------------------------------------------------- #
    # external customer db settings                       #
    # --------------------------------------------------- #
#    $Self->{CustomerDBLink} = 'http://yourhost/customer.php?CID=$Data{"CustomerID"}';
    $Self->{CustomerDBLink} = '$Env{"CGIHandle"}?Action=AgentCustomer&TicketID=$Data{"TicketID"}';
#    $Self->{CustomerDBLink} = '';
    $Self->{CustomerDBLinkTarget} = '';
#    $Self->{CustomerDBLinkTarget} = 'target="cdb"';

    # --------------------------------------------------- #
    # misc                                                #
    # --------------------------------------------------- #
    # yes / no options
    $Self->{YesNoOptions} = {
        1 => 'Yes',
        0 => 'No',
    };

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 PostMaster stuff                    #
    #                                                     #
    # --------------------------------------------------- #

    # PostmasterMaxEmails
    # (Max post master daemon email to own email-address a day.
    # Loop-Protection!) [default: 40]
    $Self->{PostmasterMaxEmails} = 40;
    # PostMasterPOP3MaxSize
    # (max. email size)
    $Self->{PostMasterPOP3MaxEmailSize} = 1024 * 6;
    # [Kernel::System::PostMaster::LoopProtection(FS|DB)] default is DB
    $Self->{LoopProtectionModule} = 'Kernel::System::PostMaster::LoopProtection::DB';
    # loop protection Log (just needed for FS module)
    $Self->{LoopProtectionLog} = '<OTRS_CONFIG_Home>/var/log/LoopProtection';

    # PostmasterAutoHTML2Text
    # (sould OTRS convert html email only to text?)
    $Self->{PostmasterAutoHTML2Text} = 1;

    # PostmasterFollowUpSearchInReferences
    # (If no ticket number in subject, otrs also looks in In-Reply-To
    # and References for follow up checks)
    $Self->{PostmasterFollowUpSearchInReferences} = 0;

    # PostmasterUserID
    # (The post master db-uid.) [default: 1]
    $Self->{PostmasterUserID} = 1;

    # PostmasterDefaultQueue
    # (The default queue of all.) [default: Raw]
    $Self->{PostmasterDefaultQueue} = 'Raw';

    # PostmasterDefaultPriority
    # (The default priority of new tickets.) [default: '3 normal']
    $Self->{PostmasterDefaultPriority} = '3 normal';

    # PostmasterDefaultState
    # (The default state of new tickets.) [default: new]
    $Self->{PostmasterDefaultState} = 'new';

    # PostmasterFollowUpState
    # (The state if a ticket got a follow up.) [default: open]
    $Self->{PostmasterFollowUpState} = 'open';

    # X-Header
    # (All scanned x-headers.)
    $Self->{'PostmasterX-Header'} = [
      'From',
      'To',
      'Cc',
      'Reply-To',
      'ReplyTo',
      'Subject',
      'Message-ID',
      'Message-Id',
      'Resent-To',
      'Resent-From',
      'Precedence',
      'Mailing-List',
      'List-Id',
      'List-Archive',
      'Errors-To',
      'References',
      'In-Reply-To',
      'X-Loop',
      'X-Spam-Flag',
      'X-Spam-Status',
      'X-No-Loop',
      'X-Priority',
      'Importance',
      'X-Mailer',
      'User-Agent',
      'Organization',
      'X-Original-To',
      'Delivered-To',
      'X-OTRS-Loop',
      'X-OTRS-Info',
      'X-OTRS-Priority',
      'X-OTRS-Queue',
      'X-OTRS-Ignore',
      'X-OTRS-State',
      'X-OTRS-CustomerNo',
      'X-OTRS-CustomerUser',
      'X-OTRS-ArticleKey1',
      'X-OTRS-ArticleKey2',
      'X-OTRS-ArticleKey3',
      'X-OTRS-ArticleValue1',
      'X-OTRS-ArticleValue2',
      'X-OTRS-ArticleValue3',
      'X-OTRS-SenderType',
      'X-OTRS-ArticleType',
      'X-OTRS-TicketKey1',
      'X-OTRS-TicketKey2',
      'X-OTRS-TicketKey3',
      'X-OTRS-TicketKey4',
      'X-OTRS-TicketKey5',
      'X-OTRS-TicketKey6',
      'X-OTRS-TicketKey7',
      'X-OTRS-TicketKey8',
      'X-OTRS-TicketValue1',
      'X-OTRS-TicketValue2',
      'X-OTRS-TicketValue3',
      'X-OTRS-TicketValue4',
      'X-OTRS-TicketValue5',
      'X-OTRS-TicketValue6',
      'X-OTRS-TicketValue7',
      'X-OTRS-TicketValue8',
    ];

    # --------------------------------------------------- #
    # PostMaster Filter Modules                           #
    # --------------------------------------------------- #
    # PostMaster::PreFilterModule
    # (filtering and manipulaiting of incoming emails)

    # Job Name: 1-Match
    # (block/ignore all spam email with From: noreply@)
#    $Self->{'PostMaster::PreFilterModule'}->{'1-Match'} = {
#        Module => 'Kernel::System::PostMaster::Filter::Match',
#        Match => {
#            From => 'noreply@',
#        },
#        Set => {
#            'X-OTRS-Ignore' => 'yes',
#        },
#    };
    # Job Name: 2-Match
    # (get a 4 digit number to ticket free text, use regex in Match
    # e. g. From => '(.+?)@.+?', and use () as [***] in Set =>)
#    $Self->{'PostMaster::PreFilterModule'}->{'2-Match'} = {
#        Module => 'Kernel::System::PostMaster::Filter::Match',
#        Match => {
#            Subject => 'SomeNumber:(\d\d\d\d)',
#        },
#        Set => {
#            'X-OTRS-TicketKey-1' => 'SomeNumber',
#            'X-OTRS-TicketValue-1' => '[***]',
#        },
#    };
    # Job Name: 5-SpamAssassin
    # (SpamAssassin example setup, ignore spam emails)
#    $Self->{'PostMaster::PreFilterModule'}->{'5-SpamAssassin'} = {
#        Module => 'Kernel::System::PostMaster::Filter::CMD',
#        CMD => '/usr/bin/spamassassin | grep -i "X-Spam-Status: yes"',
#        Set => {
#            'X-OTRS-Ignore' => 'yes',
#        },
#    };
    # (SpamAssassin example setup, move it to spam queue)
#    $Self->{'PostMaster::PreFilterModule'}->{'5-SpamAssassin'} = {
#        Module => 'Kernel::System::PostMaster::Filter::CMD',
#        CMD => '/usr/bin/spamassassin | grep -i "X-Spam-Status: yes"',
#        Set => {
#            'X-OTRS-Queue' => 'spam',
#        },
#    };

    # module to use database filter storage (use it at first)
    $Self->{'PostMaster::PreFilterModule'}->{'000-MatchDBSource'} = {
        Module => 'Kernel::System::PostMaster::Filter::MatchDBSource',
    };

    # --------------------------------------------------- #
    # Auto Response                                       #
    # --------------------------------------------------- #

    # SendNoAutoResponseRegExp
    # (if this regexp is matching on senders From or ReplyTo, no
    # auto response will be sent)
    $Self->{SendNoAutoResponseRegExp} = '(MAILER-DAEMON|postmaster|abuse)@.+?\..+?';


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
#    $Self->{SessionModule} = 'Kernel::System::AuthSession::DB';
#    $Self->{SessionModule} = 'Kernel::System::AuthSession::FS';
    $Self->{SessionModule} = 'Kernel::System::AuthSession::IPC';

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
    $Self->{SessionMaxTime} = 8*60*60;

    # SessionMaxIdleTime
    # (After this time (in seconds) without new http request, then
    # the user get logged off)
    $Self->{SessionMaxIdleTime} = 4*60*60;

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
    $Self->{SessionTable} = 'session';
    # SessionTable id column
    $Self->{SessionTableID} = 'session_id';
    # SessionTable value column
    $Self->{SessionTableValue} = 'value';

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
    $Self->{PreferencesView} = {
        'Mail Management' => [
            'NewTicketNotify', 'FollowUpNotify', 'LockTimeoutNotify', 'MoveNotify',
        ],
        Frontend => [
            'Language', 'Theme', 'QueueViewShownTickets', 'QueueView', 'RefreshTime', 'CreateNextMask',
        ],
        'Other Options' => [
            'Password', 'CustomQueue', 'SpellDict', 'FreeText', 'Comment',
        ],
    };

    # PreferencesGroups
    # (All possible items)
    $Self->{PreferencesGroups}->{NewTicketNotify} = {
        Colum => 'Mail Management',
        Label => 'New ticket notification',
        Desc => 'Send me a notification if there is a new ticket in "My Queues".',
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendNewTicketNotification',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{FollowUpNotify} = {
        Colum => 'Mail Management',
        Label => 'Follow up notification',
        Desc => "Send me a notification if a customer sends a follow up and I'm the owner of this ticket.",
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendFollowUpNotification',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{LockTimeoutNotify} = {
        Colum => 'Mail Management',
        Label => 'Ticket lock timeout notification',
        Desc => 'Send me a notification if a ticket is unlocked by the system.',
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendLockTimeoutNotification',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{MoveNotify} = {
        Colum => 'Mail Management',
        Label => 'Move notification',
        Desc => 'Send me a notification if a ticket is moved into one of "My Queues".',
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        PrefKey => 'UserSendMoveNotification',
        Activ => 1,
    };


    $Self->{PreferencesGroups}->{Password} = {
        Colum => 'Other Options',
        Label => 'Change Password',
        Type => 'Password',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{CustomQueue} = {
        Colum => 'Other Options',
        Label => 'Your Queues',
        Type => 'CustomQueue',
        Desc => 'Select your queues.',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{SpellDict} = {
        Colum => 'Other Options',
        Label => 'Spelling Dictionary',
        Desc => 'Select your default spelling dictionary.',
        Type => 'Generic',
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
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Comment} = {
        Colum => 'Other Options',
        Label => 'Comment',
        Type => 'Generic',
        Desc => 'Comment',
        Data => '$Env{"UserComment"}',
        PrefKey => 'UserComment',
        Activ => 0,
    };

#    $Self->{PreferencesGroups}->{FreeText} = {
#        Colum => 'Other Options',
#        Label => 'Free Text',
#        Type => 'Generic',
#        Desc => 'Example for free text.',
#        Data => '$Env{"UserFreeText"}',
#        PrefKey => 'UserFreeText',
#        Activ => 1,
#    };


    $Self->{PreferencesGroups}->{RefreshTime} = {
        Colum => 'Frontend',
        Label => 'QueueView refresh time',
        Desc => 'Select your QueueView refresh time.',
        Type => 'Generic',
        Data => {
            '' => 'off',
            2 => ' 2 minutes',
            5 => ' 5 minutes',
            7 => ' 7 minutes',
            10 => '10 minutes',
            15 => '15 minutes',
        },
        PrefKey => 'UserRefreshTime',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Language} = {
        Colum => 'Frontend',
        Label => 'Language',
        Desc => 'Select your frontend language.',
        Type => 'Generic',
        PrefKey => 'UserLanguage',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{Theme} = {
        Colum => 'Frontend',
        Label => 'Theme',
        Desc => 'Select your frontend Theme.',
        Type => 'Generic',
        PrefKey => 'UserTheme',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{QueueView} = {
        Colum => 'Frontend',
        Label => 'QueueView',
        Desc => 'Select your frontend QueueView.',
        Type => 'Generic',
        Data => {
            TicketView => 'Standard',
            TicketViewLite => 'Lite',
        },
        DataSelected => 'TicketView',
        PrefKey => 'UserQueueView',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{QueueViewShownTickets} = {
        Colum => 'Frontend',
        Label => 'Shown Tickets',
        Desc => 'Max. shown Tickets a page in QueueView.',
        Type => 'Generic',
        Data => {
            10 => 10,
            15 => 15,
            20 => 20,
            25 => 25,
        },
        DataSelected => 15,
        PrefKey => 'UserQueueViewShowTickets',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{CreateNextMask} = {
        Colum => 'Frontend',
        Label => 'Screen after new ticket',
        Desc => 'Select your screen after creating a new ticket.',
        Type => 'Generic',
        Data => {
            '' => 'CreateTicket',
            AgentZoom => 'TicketZoom',
        },
        DataSelected => '',
#        DataSelected => 'AgentZoom',
        PrefKey => 'UserCreateNextMask',
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
    $Self->{CustomerPanelLoginURL} = '';
#    $Self->{CustomerPanelLoginURL} = 'http://host.example.com/cgi-bin/login.pl';

    # CustomerPanelLogoutURL
    # (If this is anything other than '', it is assumed to be the URL
    # of an alternate logout page which users will be sent to when they
    # logout.)
    $Self->{CustomerPanelLogoutURL} = '';
#    $Self->{CustomerPanelLogoutURL} = 'http://host.example.com/cgi-bin/login.pl';

    # CustomerPanelPreApplicationModule
    # (Used for every request, if defined, the PreRun() function of
    # this module will be used. This interface use useful to check
    # some user options or to redirect not accept new application
    # news)
#    $Self->{CustomerPanelPreApplicationModule} = 'Kernel::Modules::CustomerAccept';
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

    # CustomerPriority
    # (If the customer can set the ticket priority)
    $Self->{CustomerPriority} = 1;
    # CustomerDefaultPriority
    # (default priority of new customer tickets)
    $Self->{CustomerDefaultPriority} = '3 normal';

    # CustomerDefaultState
    # (default state of new customer tickets)
    $Self->{CustomerDefaultState} = 'new';

    # CustomerNextScreenAfterNewTicket
#    $Self->{CustomerNextScreenAfterNewTicket} = 'CustomerZoom';
    $Self->{CustomerNextScreenAfterNewTicket} = 'CustomerTicketOverView';

    # --------------------------------------------------- #
    # customer message settings                           #
    # --------------------------------------------------- #
    # default note type
    $Self->{CustomerPanelArticleType} = 'webrequest';
    $Self->{CustomerPanelSenderType} = 'customer';
    # default history type
    $Self->{CustomerPanelHistoryType} = 'FollowUp';
    $Self->{CustomerPanelHistoryComment} = '';

    # default compose follow up next state
    $Self->{CustomerPanelDefaultNextComposeType} = 'open';
    $Self->{CustomerPanelNextComposeState} = 1;
    # next possible states for compose message
    $Self->{CustomerPanelDefaultNextComposeStateType} = ['open', 'closed'];

    # default article type
    $Self->{CustomerPanelNewArticleType} = 'webrequest';
    $Self->{CustomerPanelNewSenderType} = 'customer';
    # default history type
    $Self->{CustomerPanelNewHistoryType} = 'WebRequestCustomer';
    $Self->{CustomerPanelNewHistoryComment} = '';

    # CustomerPanelSelectionType
    # (To: seection type. Queue => show all queues, SystemAddress => show all system
    # addresses;) [Queue|SystemAddress]
    $Self->{CustomerPanelSelectionType} = 'Queue';
#    $Self->{CustomerPanelSelectionType} = 'SystemAddress';

    # CustomerPanelSelectionString
    # (String for To: selection.)
    # use this for CustomerPanelSelectionType = Queue
#    $Self->{CustomerPanelSelectionString} = 'Queue: <Queue> - <QueueComment>';
    $Self->{CustomerPanelSelectionString} = '<Queue>';
    # use this for CustomerPanelSelectionType = SystemAddress
#    $Self->{CustomerPanelSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';

    # CustomerPanelOwnSelection
    # (If this is in use, "just this selection is valid" for the CustomMessage.)
#    $Self->{CustomerPanelOwnSelection} = {
#        # Queue => Frontend-Name
#        'Junk' => 'First Queue!',
#        'Misc' => 'Second Queue!',
#        # QueueID => Frontend-Name (or optional with QueueID)
##        '1' => 'First Queue!',
##        '2' => 'Second Queue!',
#    };

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

    # ShowCustomerInfo*
    # (show customer user info on Compose (Phone and Email), Zoom and Queue view)
    $Self->{ShowCustomerInfoCompose} = 1;
    $Self->{ShowCustomerInfoZoom} = 1;
    $Self->{ShowCustomerInfoQueue} = 0;

    # ShowCustomerInfo*MaxSize
    # (max size (in characters) of customer info table)
    $Self->{ShowCustomerInfoComposeMaxSize} = 22;
    $Self->{ShowCustomerInfoZoomMaxSize} = 22;
    $Self->{ShowCustomerInfoQueueMaxSize} = 18;

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
        CustomerUserSearchFields => ['login', 'last_name', 'customer_id'],
        CustomerUserSearchPrefix => '',
        CustomerUserSearchSuffix => '*',
        CustomerUserSearchListLimit => 250,
        CustomerUserPostMasterSearchFields => ['email'],
        CustomerUserNameFields => ['salutation', 'first_name', 'last_name'],
        CustomerUserEmailUniqCheck => 1,
#        AutoLoginCreation => 0,
#        AutoLoginCreationPrefix => 'auto',
#        AdminSetPreferences => 1,
#        ReadOnly => 1,
        Map => [
            # note: Login, Email and CustomerID needed!
            # var, frontend, storage, shown, required, storage-type, http-link, readonly
            [ 'UserSalutation', 'Salutation', 'salutation', 1, 0, 'var', '', 0 ],
            [ 'UserFirstname', 'Firstname', 'first_name', 1, 1, 'var', '', 0 ],
            [ 'UserLastname', 'Lastname', 'last_name', 1, 1, 'var', '', 0 ],
            [ 'UserLogin', 'Username', 'login', 1, 1, 'var', '', 0 ],
            [ 'UserPassword', 'Password', 'pw', 0, 1, 'var', '', 0 ],
            [ 'UserEmail', 'Email', 'email', 0, 1, 'var', '', 0 ],
#            [ 'UserEmail', 'Email', 'email', 1, 1, 'var', '$Env{"CGIHandle"}?Action=AgentCompose&ResponseID=1&TicketID=$Data{"TicketID"}&ArticleID=$Data{"ArticleID"}', 0 ],
            [ 'UserCustomerID', 'CustomerID', 'customer_id', 0, 1, 'var', '', 0 ],
#            [ 'UserCustomerIDs', 'CustomerIDs', 'customer_ids', 1, 0, 'var', '', 0 ],
            [ 'UserComment', 'Comment', 'comments', 1, 0, 'var', '', 0 ],
            [ 'ValidID', 'Valid', 'valid_id', 0, 1, 'int', '', 0 ],
        ],
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
#        AdminSetPreferences => 0,
#        Map => [
#            # note: Login, Email and CustomerID needed!
#            # var, frontend, storage, shown, required, storage-type, http-link, readonly
#            [ 'UserSalutation', 'Title', 'title', 1, 0, 'var', '', 0 ],
#            [ 'UserFirstname', 'Firstname', 'givenname', 1, 1, 'var', '', 0 ],
#            [ 'UserLastname', 'Lastname', 'sn', 1, 1, 'var', '', 0 ],
#            [ 'UserLogin', 'Username', 'uid', 1, 1, 'var', '', 0 ],
#            [ 'UserEmail', 'Email', 'mail', 1, 1, 'var', '', 0 ],
#            [ 'UserCustomerID', 'CustomerID', 'mail', 0, 1, 'var', '', 0 ],
##            [ 'UserCustomerIDs', 'CustomerIDs', 'second_customer_ids', 1, 0, 'var', '', 0 ],
#            [ 'UserPhone', 'Phone', 'telephonenumber', 1, 0, 'var', '', 0 ],
#            [ 'UserAddress', 'Address', 'postaladdress', 1, 0, 'var', '', 0 ],
#            [ 'UserComment', 'Comment', 'description', 1, 0, 'var', '', 0 ],
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
    $Self->{CustomerPreferencesView} = {
        Frontend => [
            'ShownTickets', 'RefreshTime', 'Language', 'Theme',
        ],
        'Other Options' => [
            'Password', 'ClosedTickets', 'PGP', 'SMIME',
        ],
    };

    # CustomerPreferencesGroups
    # (All possible items)
    $Self->{CustomerPreferencesGroups}->{Password} = {
        Colum => 'Other Options',
        Label => 'Change Password',
        Type => 'Password',
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{ClosedTickets} = {
        Colum => 'Other Options',
        Label => 'Closed Tickets',
        Desc => 'Show closed tickets.',
        Type => 'Generic',
        Data => $Self->Get('YesNoOptions'),
        DataSelected => 1,
        PrefKey => 'UserShowClosedTickets',
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{ShownTickets} = {
        Colum => 'Frontend',
        Label => 'Shown Tickets',
        Desc => 'Max. shown Tickets a page in Overview.',
        Type => 'Generic',
        Data => {
            15 => 15,
            20 => 20,
            25 => 25,
            30 => 30,
        },
        DataSelected => 25,
        PrefKey => 'UserShowTickets',
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{RefreshTime} = {
        Colum => 'Frontend',
        Label => 'QueueView refresh time',
        Desc => 'Select your QueueView refresh time.',
        Type => 'Generic',
        Data => {
            '' => 'off',
            2 => ' 2 minutes',
            5 => ' 5 minutes',
            7 => ' 7 minutes',
            10 => '10 minutes',
            15 => '15 minutes',
        },
        PrefKey => 'UserRefreshTime',
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{Language} = {
        Colum => 'Frontend',
        Label => 'Language',
        Desc => 'Select your frontend language.',
        Type => 'Generic',
        Data => $Self->Get('DefaultUsedLanguages'),
        PrefKey => 'UserLanguage',
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{Theme} = {
        Colum => 'Frontend',
        Label => 'Theme',
        Desc => 'Select your frontend Theme.',
        Type => 'Generic',
        PrefKey => 'UserTheme',
        Activ => 0,
    };
#    $Self->{CustomerPreferencesGroups}->{PGP} = {
#        Colum => 'Other Options',
#        Label => 'PGP Key',
#        Desc => 'PGP Key Upload',
#        Type => 'Upload',
#        PrefKey => 'UserPGPKey',
#        Activ => 0,
#    };
#    $Self->{CustomerPreferencesGroups}->{SMIME} = {
#        Colum => 'Other Options',
#        Label => 'SMIME Certificate',
#        Desc => 'SMIME Certificate Upload',
#        Type => 'Upload',
#        PrefKey => 'UserSMIMEKey',
#        Activ => 0,
#    };

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                    Phone stuff                      #
    #                                                     #
    # --------------------------------------------------- #

    # --------------------------------------------------- #
    # defaults for phone stuff                            #
    # --------------------------------------------------- #
    # default note type
    $Self->{PhoneDefaultArticleType} = 'phone';
    $Self->{PhoneDefaultSenderType} = 'agent';
    # default note subject
    $Self->{PhoneDefaultSubject} = '$Text{"Phone call at %s", "Time(DateFormatLong)"}';
    # default note text
    $Self->{PhoneDefaultNoteText} = '$Text{"Customer called"}';
    # next possible states after phone
    $Self->{PhoneDefaultNextStateType} = ['open', 'pending auto', 'pending reminder', 'closed'];

    # default next state
    $Self->{PhoneDefaultNextState} = 'closed successful';
    # default history type
    $Self->{PhoneDefaultHistoryType} = 'PhoneCallAgent';
    $Self->{PhoneDefaultHistoryComment} = '';


    # default article type
    $Self->{PhoneDefaultNewArticleType} = 'phone';
    $Self->{PhoneDefaultNewSenderType} = 'customer';
    # default note subject
#    $Self->{PhoneDefaultNewSubject} = '$Text{"Phone call at %s", "Time(DateFormatLong)"}';
    $Self->{PhoneDefaultNewSubject} = '';
    # default note text
#    $Self->{PhoneDefaultNewNoteText} = 'New ticket via call.';
    $Self->{PhoneDefaultNewNoteText} = '';
    # default next state [default: open]
    $Self->{PhoneDefaultNewNextState} = 'open';
    # default lock (lock|unlock) [default: unlock]
    $Self->{PhoneDefaultNewLock} = 'unlock';
    # default priority [default: 3 normal]
    $Self->{PhoneDefaultPriority} = '3 normal';
    # default history type
    $Self->{PhoneDefaultNewHistoryType} = 'PhoneCallCustomer';
    $Self->{PhoneDefaultNewHistoryComment} = '';

    # PhoneViewOwnerSelection
    $Self->{PhoneViewOwnerSelection} = 1;

    # PhoneViewSelectionType
    # (To: seection type. Queue => show all queues, SystemAddress => show all system
    # addresses;) [Queue|SystemAddress]
    $Self->{PhoneViewSelectionType} = 'Queue';
#    $Self->{PhoneViewSelectionType} = 'SystemAddress';

    # PhoneViewSelectionString
    # (String for To: selection.)
    # use this for PhoneViewSelectionType = Queue
#   $Self->{PhoneViewSelectionString} = 'Queue: <Queue> - <QueueComment>';
   $Self->{PhoneViewSelectionString} = '<Queue>';
    # use this for PhoneViewSelectionType = SystemAddress
#    $Self->{PhoneViewSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';
#    $Self->{PhoneViewSelectionString} = '<Realname> <<Email>> - Queue: <Queue>';

    # PhoneViewOwnSelection
    # (If this is in use, "just this selection is valid" for the PhoneView.)
#    $Self->{PhoneViewOwnSelection} = {
#        # QueueID => String
#        '1' => 'First Queue!',
#        '2' => 'Second Queue!',
#    };

    # --------------------------------------------------- #
    # agent compose email stuff
    # --------------------------------------------------- #
    # default lock (lock|unlock) [default: unlock]
    $Self->{EmailDefaultNewLock} = 'unlock';

    # default priority [default: 3 normal]
    $Self->{EmailDefaultPriority} = '3 normal';

    # default article type
    $Self->{EmailDefaultNewArticleType} = 'email-external';
    # default sender type
    $Self->{EmailDefaultNewSenderType} = 'agent';

    # history
    $Self->{EmailDefaultNewHistoryType} = 'EmailAgent';
    $Self->{EmailDefaultNewHistoryComment} = '';

    # default note text
    $Self->{EmailDefaultNoteText} = '';

    # next possible states after phone
    $Self->{EmailDefaultNextStateType} = ['open', 'pending auto', 'pending reminder', 'closed'];

    # default next state
    $Self->{EmailDefaultNewNextState} = 'open';

    # --------------------------------------------------- #
    # PGP settings (supports gpg)                         #
    # --------------------------------------------------- #
    $Self->{'PGP'} = 0;
    $Self->{'PGP::Bin'} = '/usr/bin/gpg';
    $Self->{'PGP::Options'} = '--homedir /var/lib/wwwrun/.gnupg/ --batch --no-tty --yes';
#    $Self->{'PGP::Options'} = '--batch --no-tty --yes';
#    $Self->{'PGP::Key::Password::D2DF79FA'} = 1234;
#    $Self->{'PGP::Key::Password::488A0B8F'} = 1234;

    # --------------------------------------------------- #
    # S/MIME settings (supports smime)                    #
    # --------------------------------------------------- #
    $Self->{'SMIME'} = 0;
    # maybe openssl need a HOME env!
    #$ENV{HOME} = '/var/lib/wwwrun';
    $Self->{'SMIME::Bin'} = '/usr/bin/openssl';
#    $Self->{'SMIME::CertPath'} = '/etc/ssl/certs';
#    $Self->{'SMIME::PrivatePath'} = '/etc/ssl/private/private';

    # --------------------------------------------------- #
    # system permissions
    # --------------------------------------------------- #
    $Self->{'System::Permission'} = ['ro', 'move_into', 'create', 'owner', 'priority', 'rw'];
#    $Self->{'System::Permission'} = ['ro', 'move_into', 'create', 'note', 'close', 'pending', 'owner', 'priority', 'customer', 'freetext', 'forward', 'bounce', 'move', 'rw'];
    $Self->{'System::Customer::Permission'} = ['ro', 'rw'];

    # --------------------------------------------------- #
    # agent ticket permissions
    # --------------------------------------------------- #
    # Module Name: 1-OwnerCheck
    # (if the current owner is already the user, grant access)
    $Self->{'Ticket::Permission'}->{'1-OwnerCheck'} = {
        Module => 'Kernel::System::Ticket::Permission::OwnerCheck',
        # if this check is needed
        Required => 0,
        # if this check is true, don't do more checks
        Granted => 0,
    };
    # Module Name: 2-GroupCheck
    # (if the user is in this group with type ro|rw|..., grant access)
    $Self->{'Ticket::Permission'}->{'2-GroupCheck'} = {
        Module => 'Kernel::System::Ticket::Permission::GroupCheck',
        # if this check is needed
        Required => 0,
        # if this check is true, don't do more checks
        Granted => 0,
    };

    # --------------------------------------------------- #
    # customer ticket permissions
    # --------------------------------------------------- #
    # Module Name: 1-CustomerIDGroupCheck
    # (grant access, if customer id is the same and group is accessable)
    $Self->{'CustomerTicket::Permission'}->{'1-CustomerIDCheck'} = {
        Module => 'Kernel::System::Ticket::CustomerPermission::CustomerIDCheck',
        # if this check is needed
        Required => 1,
        # if this check is true, don't do more checks
        Granted => 0,
    };
    $Self->{'CustomerTicket::Permission'}->{'2-GroupCheck'} = {
        Module => 'Kernel::System::Ticket::CustomerPermission::GroupCheck',
        # if this check is needed
        Required => 1,
        # if this check is true, don't do more checks
        Granted => 0,
    };

    # --------------------------------------------------- #
    # FAQ settings
    # --------------------------------------------------- #

    $Self->{'FAQ::Default::State'} = 'internal (agent)';

    $Self->{'FAQ::Field1'} = 'Symptom';
    $Self->{'FAQ::Field2'} = 'Problem';
    $Self->{'FAQ::Field3'} = 'Solution';
    $Self->{'FAQ::Field4'} = 'field4';
    $Self->{'FAQ::Field5'} = 'field5';
    $Self->{'FAQ::Field6'} = 'Comment (internal)';

    # --------------------------------------------------- #
    # module group permissions
    # --------------------------------------------------- #
    # Module (from Kernel/Modules/*.pm) => Group
    $Self->{'Module::Permission'}->{'Admin'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminAttachment'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminAutoResponse'} = 'admin';
#    $Self->{'Module::Permission'}->{'AdminCustomerUser'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminCustomerUser'} = ['admin', 'users'];
    $Self->{'Module::Permission'}->{'AdminCustomerUserGroup'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminEmail'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminGroup'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminLog'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminNotification'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminPGP'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminPOP3'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminPostMasterFilter'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminQueueAutoResponse'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminQueue'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminQueueResponses'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminResponseAttachment'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminResponse'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminSalutation'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminSelectBox'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminSession'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminSignature'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminState'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminSystemAddress'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminUserGroup'} = 'admin';
    $Self->{'Module::Permission'}->{'AdminUser'} = 'admin';

    $Self->{'Module::Permission::Ro'}->{'FAQ'} = ['faq'];
    $Self->{'Module::Permission::Ro'}->{'FAQHistory'} = ['faq'];
    $Self->{'Module::Permission'}->{'FAQCategory'} = ['faq'];
    $Self->{'Module::Permission'}->{'FAQLanguage'} = ['faq'];
    $Self->{'Module::Permission'}->{'FAQArticle'} = ['faq'];

    $Self->{'Module::Permission'}->{'SystemStats'} = ['admin', 'stats'];


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
    # load defaults
    $Self->LoadDefaults;
    # load config
    $Self->Load();
    # replace config variables in config variables
    foreach (keys %{$Self}) {
        if ($_) {
           $Self->{$_} =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{$1}/g;
        }
    }

    return $Self;
}
# --

1;
