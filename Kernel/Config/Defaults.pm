# --
# Kernel/Config/Defaults.pm - Default Config file for OTRS kernel
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Defaults.pm,v 1.55 2003-03-13 09:48:19 martin Exp $
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
$VERSION = '$Revision: 1.55 $';
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

    # SendmailModule
    # (Where is sendmail located and some options.
    # See 'man sendmail' for details. Or use the SMTP backend.) 
    $Self->{'SendmailModule'} = 'Kernel::System::Email::Sendmail';
    $Self->{'SendmailModule::CMD'} = '/usr/sbin/sendmail -t -i -f ';

#    $Self->{'SendmailModule'} = 'Kernel::System::Email::SMTP';
#    $Self->{'SendmailModule::Host'} = 'mail.example.com';
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

    # CustomQueue
    # (The name of custom queue.)
    $Self->{CustomQueue} = 'PersonalQueue';

    # QueueViewAllPossibleTickets
    # (show all ro and rw queues - not just rw queues)
    $Self->{QueueViewAllPossibleTickets} = 0; 

    # MoveInToAllQueues -> useful for ASP
    # (Possible to move in all queue? Not only queue which
    # the own groups) [1|0]
    $Self->{MoveInToAllQueues} = 1;

    # MoveType
    # (Show form drop down of show new page of new queues) [form|link]
    $Self->{MoveType} = 'form';
    $Self->{MoveSetState} = 0;
    # default move next state
    $Self->{DefaultNextMoveStateType} = ['new', 'open', 'closed', 'pending auto', 'pending reminder'];

    # ChangeOwnerToEveryone -> useful for ASP
    # (Possible to change owner of ticket ot everyone) [0|1]
    $Self->{ChangeOwnerToEveryone} = 0;

    # MaxFileUpload
    # (Max size for file uploads - default 5 MB)
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

    # UserTable
    $Self->{DatabaseUserTable} = 'system_user';
    $Self->{DatabaseUserTableUserID} = 'id';
    $Self->{DatabaseUserTableUserPW} = 'pw';
    $Self->{DatabaseUserTableUser} = 'login';

    # --------------------------------------------------- #
    # authentication settings                             #
    # (enable what you need, auth against otrs db or      #
    # against a LDAP directory)                           #
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

    # The following is valid but would only be necessary if the
    # anonymous user do NOT have permission to read from the LDAP tree 
#    $Self->{'AuthModule::LDAP::SearchUserDN'} = '';
#    $Self->{'AuthModule::LDAP::SearchUserPw'} = '';

    # --------------------------------------------------- #
    # default agent settings                              #
    # --------------------------------------------------- #
    # ViewableTickets
    # (The default viewable tickets a page.)
    $Self->{ViewableTickets} = 15;

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
    $Self->{MaxLimit} = 120;

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

    # --------------------------------------------------- #
    # AgentStatusView (shows all open tickets)            #
    # --------------------------------------------------- #
    $Self->{'AgentStatusView::ViewableTicketsPage'} = 75;

    # --------------------------------------------------- #
    # AgentUtil                                           #
    # --------------------------------------------------- #
    # default limit for ticket search
    # [default: 250]
    $Self->{SearchLimit} = 250;

    # defaut of shown article a page
    # [default: 15]
    $Self->{SearchPageShown} = 15;

    # viewable ticket lines by search util
    # [default: 10]
    $Self->{ViewableTicketLinesBySearch} = 10;

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

    # --------------------------------------------------- #
    # LogModule                                           #
    # --------------------------------------------------- #
    # (log backend module)
    $Self->{LogModule} = 'Kernel::System::Log::SysLog';
#    $Self->{LogModule} = 'Kernel::System::Log::File';

    # param for LogModule Kernel::System::Log::File (required!)
    $Self->{'LogModule::LogFile'} = '/tmp/otrs.log'; 

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
    # checker) 
#    $Self->{SpellChecker} = '';
    $Self->{SpellChecker} = '/usr/bin/ispell';
    $Self->{SpellCheckerDictDefault} = 'english';

    # DemoSystem
    # (If this is true, no agent preferences, like language and theme, via agent 
    # frontend can be updated! Just for the current session. Alow no password can
    # be changed on agent frontend.)
    $Self->{DemoSystem} = 0;

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
    # (where attachments and co is stored - switch from fs -> db possible
    # but not from db -> fs - old attachments are not shown) 
    $Self->{TicketStorageModule} = 'Kernel::System::Ticket::ArticleStorageDB';
    # FS is faster but webserver user should be the otrs user)
#    $Self->{TicketStorageModule} = 'Kernel::System::Ticket::ArticleStorageFS';

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
 
    # --------------------------------------------------- #
    # TicketViewAccelerator                               #
    # --------------------------------------------------- #
    # choose your backend TicketViewAccelerator module

    # RuntimeDB 
    # (generate each queue view on the fly from ticket table
    # you will not have performance trouble till ~ 50.000 tickets 
    # in your system)
    $Self->{TicketIndexModule} = 'Kernel::System::Ticket::IndexAccelerator::RuntimeDB';

    # StaticDB
    # (the most powerfull module, it should be used over 80.000 
    # tickets in a system - use a extra ticket_index table, works like a view -
    # use bin/RebuildTicketIndex.pl for initial index update)
#    $Self->{TicketIndexModule} = 'Kernel::System::Ticket::IndexAccelerator::StaticDB';

    # --------------------------------------------------- #
    # default values                                      #
    # (default values for GUIs)                           #
    # --------------------------------------------------- #
    # default valid
    $Self->{DefaultValid} = 'valid';
    # default charset
    # (default frontend charset) [default: iso-8859-1]
    $Self->{DefaultCharset} = 'iso-8859-1';
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
            fr => 'Français',
            bg => 'Bulgarian',
            fi => 'Suomi',
            es => 'Espaniol',
            pt_BR => 'Português Brasileiro',
#            cs => 'Czech', 
#            hu => 'Hungarian',
#            pl => 'Polski',
#            ro => 'Romanian',
#            hr => 'Croatian',
#            sk => 'Slovak', 
#            sl => 'Slovenian',
#            pt => 'Portuguese',
#            it => 'Italiano',
#            da => 'Dansk',
#            sv => 'Svenska',
#            no => 'Norwegian',
    };
    # default theme
    # (the default html theme) [default: Standard]
    $Self->{DefaultTheme} = 'Standard';
    # OnChangeSubmit 
    # (Use the onchange=submit() function for ticket move in
    # QueueView and TicketZoom) [default: 1] [0|1]
    $Self->{OnChangeSubmit} = 1;
    # StdResponsesMethod
    # (should the standard responses selection be a form or links?) [Form|Link]
    $Self->{StdResponsesMethod} = 'Link';
    # TicketZoomExpand
    # (show article expanded int ticket zoom)
    $Self->{TicketZoomExpand} = 0;
    # TimeUnits
    # (your choice of your used time units, minutes, hours, work units, ...)
#    $Self->{TimeUnits} = ' (minutes)';
#    $Self->{TimeUnits} = ' (hours)';
    $Self->{TimeUnits} = ' (work units)';
    # PendingDiffTime
    # (Time in sec. which "pending date" shows per default) [default: 24*60*60 -=> 1d]
    $Self->{PendingDiffTime} = 24*60*60;
    # FrontendNeedAccountedTime
    # (time must be accounted)
    $Self->{FrontendNeedAccountedTime} = 0;
    # FrontendNeedSpellCheck
    # (compose message must be spell checked)
    $Self->{FrontendNeedSpellCheck} = 0;

    # --------------------------------------------------- #
    # defaults for add note                               #
    # --------------------------------------------------- #
    # default note type
    $Self->{DefaultNoteType} = 'note-internal';
    # default note subject
    $Self->{DefaultNoteSubject} = 'Note!';
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
    # new line after x chars and onew word
    $Self->{ComposeTicketNewLine} = 75;
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
      'is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.';

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
    # [Kernel::System::PostMaster::LoopProtection(FS|DB)] default is DB
    $Self->{LoopProtectionModule} = 'Kernel::System::PostMaster::LoopProtection::DB';
    # loop protection Log (just needed for FS module)
    $Self->{LoopProtectionLog} = '<OTRS_CONFIG_Home>/var/log/LoopProtection';

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
      'Precedence',
      'Mailing-List',
      'X-Loop',
      'X-No-Loop',
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
      'X-OTRS-TicketKey1',
      'X-OTRS-TicketKey2',
      'X-OTRS-TicketValue1',
      'X-OTRS-TicketValue2',
    ];

    # --------------------------------------------------- #
    # Auto Response                                       #
    # --------------------------------------------------- #

    # SendNoAutoResponseRegExp
    # (if this regexp is matching on senders From or ReplyTo, not
    # auto response will be sent)
    $Self->{SendNoAutoResponseRegExp} = '(MAILDER-DAEMON|postmaster|abuse)@.+?\..+?';


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
    $Self->{SessionMaxTime} = 28800;

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
            'Language', 'Charset', 'Theme', 'RefreshTime', 'QueueView', 
        ],
        'Other Options' => [
            'Password', 'CustomQueue', 'SpellDict', 'FreeText',
        ],
    };
  
    # PreferencesGroups
    # (All possible items)
    $Self->{PreferencesGroups}->{NewTicketNotify} = {
        Colum => 'Mail Management', 
        Label => 'New ticket notification',
        Desc => 'Send me a notification if there is a new ticket in my custom queues.', 
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
        Desc => 'Send me a notification if a ticket is moved into a custom queue.', 
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
        Label => 'Custom Queue',
        Type => 'CustomQueue',
        Desc => 'Select your custom queues.', 
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
    $Self->{PreferencesGroups}->{Charset} = {
        Colum => 'Frontend', 
        Label => 'Charset',
        Desc => 'Select your frontend Charset.', 
        Type => 'Generic',
        PrefKey => 'UserCharset',
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
    # new ticket in queue
    # --
#    $Self->{NotificationAlwaysCcNewTicket} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcNewTicket} = '';
    $Self->{NotificationSubjectNewTicket} = 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyNewTicket} = "
Hi,

there is a new ticket in '<OTRS_QUEUE>'!

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[16]>
<snip>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # new phone ticket in queue
    # --
    $Self->{NotificationAlwaysCcPhoneCallCustomer} = $Self->{NotificationAlwaysCcNewTicket};
    $Self->{NotificationSubjectPhoneCallCustomer} = $Self->{NotificationSubjectNewTicket}; 
    $Self->{NotificationBodyPhoneCallCustomer} = $Self->{NotificationBodyNewTicket};

    # --
    # ticket follow up from customer
    # --
#    $Self->{NotificationAlwaysCcFollowUp} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcFollowUp} = '';
    $Self->{NotificationSubjectFollowUp} = 'You got follow up! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyFollowUp} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

you got a follow up!

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[16]>
<snip>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # ticket lock timeout by system
    # --
#    $Self->{NotificationAlwaysCcLockTimeout} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcLockTimeout} = '';
    $Self->{NotificationSubjectLockTimeout} = 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyLockTimeout} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

unlocked (lock timeout) your locked ticket [<OTRS_TICKET_NUMBER>].

<OTRS_CUSTOMER_FROM> wrote:
<snip>
<OTRS_CUSTOMER_EMAIL[8]>
<snip>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";

    # --
    # mail to new owner by owner update
    # --
#    $Self->{NotificationAlwaysCcOwnerUpdate} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcOwnerUpdate} = '';
    $Self->{NotificationSubjectOwnerUpdate} = 'Ticket assigned to you! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyOwnerUpdate} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

a ticket [<OTRS_TICKET_NUMBER>] is assigned to you by '<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>'.

Comment: 
<OTRS_COMMENT>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # mail to owner by note add
    # --
#    $Self->{NotificationAlwaysCcNote} = '';
    $Self->{NotificationSubjectAddNote} = 'New note! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyAddNote} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

'<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>' added a new note to ticket [<OTRS_TICKET_NUMBER>].

Note: 
<OTRS_CUSTOMER_BODY>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # mail to queue subscriber by move 
    # --
#    $Self->{NotificationAlwaysCcMove} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcMove} = '';
    $Self->{NotificationSubjectMove} = 'Moved ticket in "<OTRS_CUSTOMER_QUEUE>" queue! (<OTRS_CUSTOMER_SUBJECT[18]>)';
    $Self->{NotificationBodyMove} = "
Hi,

'<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>' moved a ticket [<OTRS_TICKET_NUMBER>] into '<OTRS_CUSTOMER_QUEUE>'.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";
    # --
    # ticket reminder notification
    # --
#    $Self->{NotificationAlwaysCcPendingReminder} = 'Maybe a Mailinglist <list@example.com>';
    $Self->{NotificationAlwaysCcPendingReminder} = '';
    $Self->{NotificationSubjectPendingReminder} = 'Ticket Reminder!';
    $Self->{NotificationBodyPendingReminder} = "
Hi <OTRS_OWNER_USERFIRSTNAME>,

the ticket '<OTRS_TICKET_NUMBER>' has reached the reminder time!

Please have a look at:
 
<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

";

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
    $Self->{CustomerPanelHistoryComment} = 'Customer sent follow up via web.';

    # default compose follow up next state
    $Self->{CustomerPanelDefaultNextComposeType} = 'open';
    $Self->{CustomerPanelNextComposeState} = 1;
    # next possible states for compose message
    $Self->{CustomerPanelDefaultNextComposeStateType} = ['open', 'closed'];

    # default article type
    $Self->{CustomerPanelNewArticleType} = 'webrequest';
    $Self->{CustomerPanelNewSenderType} = 'customer';
    # default history type
    $Self->{CustomerPanelNewHistoryType} = 'NewTicket';
    $Self->{CustomerPanelNewHistoryComment} = 'Customer sent new ticket via web.';

    # CustomerPanelSelectionType 
    # (To: seection type. Queue => show all queues, SystemAddress => show all system 
    # addresses;) [Queue|SystemAddress]
#    $Self->{CustomerPanelSelectionType} = 'Queue';
    $Self->{CustomerPanelSelectionType} = 'SystemAddress';

    # CustomerPanelSelectionString
    # (String for To: selection.) 
    # use this for CustomerPanelSelectionType = Queue
#    $Self->{CustomerPanelSelectionString} = 'Queue: <Queue> - <QueueComment>';
    # use this for CustomerPanelSelectionType = SystemAddress
    $Self->{CustomerPanelSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';

    # CustomerPanelOwnSelection
    # (If this is in use, "just this selection is valid" for the CustomMessage.)
#    $Self->{CustomerPanelOwnSelection} = { 
#        # QueueID => String
#        '1' => 'First Queue!',
#        '2' => 'Second Queue!',
#    };
    
    # --------------------------------------------------- #
    # notification email for new password                 #
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
    # notification email for state update                 #
    # --------------------------------------------------- #
    $Self->{CustomerNotificationSubjectStateUpdate} = "New State '<OTRS_CUSTOMER_State>'!";
    $Self->{CustomerNotificationBodyStateUpdate} = "
*** THIS IS JUST A NOTE ***

The state of your ticket '<OTRS_TICKET_NUMBER>' has been chaned by 
'<OTRS_OWNER_UserFirstname> <OTRS_OWNER_UserLastname>' to '<OTRS_CUSTOMER_State>'.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

*** THIS IS JUST A NOTE ***
";
    # --------------------------------------------------- #
    # notification email for owner update                 #
    # --------------------------------------------------- #
    $Self->{CustomerNotificationSubjectOwnerUpdate} = "New Owner '<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>'!";
    $Self->{CustomerNotificationBodyOwnerUpdate} = "
*** THIS IS JUST A NOTE ***

The owner of your ticket '<OTRS_TICKET_NUMBER>' has been changed to 
'<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>'.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

*** THIS IS JUST A NOTE ***
";

    # --------------------------------------------------- #
    # notification email for queue update                 #
    # --------------------------------------------------- #
    $Self->{CustomerNotificationSubjectQueueUpdate} = "New Queue '<OTRS_CUSTOMER_Queue>'!";
    $Self->{CustomerNotificationBodyQueueUpdate} = "
*** THIS IS JUST A NOTE ***

The queue of your ticket '<OTRS_TICKET_NUMBER>' has been changed by
'<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>' to '<OTRS_CUSTOMER_Queue>'.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

*** THIS IS JUST A NOTE ***
";

    # --------------------------------------------------- #
    # customer authentication settings                    #
    # (enable what you need, auth against otrs db or      #
    # against a LDAP directory)                           #
    # --------------------------------------------------- #
    # This is the auth. module againt the otrs db
    $Self->{'Customer::AuthModule'} = 'Kernel::System::CustomerAuth::DB';

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

    # The following is valid but would only be necessary if the
    # anonymous user do NOT have permission to read from the LDAP tree 
#    $Self->{'Customer::AuthModule::LDAP::SearchUserDN'} = '';
#    $Self->{'Customer::AuthModule::LDAP::SearchUserPw'} = '';

    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 CustomerUser stuff                  #
    #                                                     #
    # --------------------------------------------------- #

    # ShowCustomerInfo*
    # (show customer user info on Phone, Zoom and Queue view)
    $Self->{ShowCustomerInfoPhone} = 1;
    $Self->{ShowCustomerInfoZoom} = 1;
    $Self->{ShowCustomerInfoQueue} = 0;

    # CustomerUser 
    # (customer user database backend and settings)
    $Self->{CustomerUser} = {
        Module => 'Kernel::System::CustomerUser::DB',
        Params => {
#            Host => '',
#            User => '',
#            Password => '',
#            Database => '',
            Table => 'customer_user',
        }, 
        # customer uniq id
        CustomerKey => 'login',
        # customer #
        CustomerID => 'customer_id',
        CustomerValid => 'valid_id',
#        CustomerUserListFields => ['login', 'first_name', 'last_name', 'email'],
        CustomerUserListFields => ['login', 'first_name', 'last_name', 'customer_id', 'email'],
        CustomerUserSearchFields => ['login', 'last_name', 'customer_id'],
        CustomerUserNameFields => ['salutation', 'first_name', 'last_name'],
#        ReadOnly => 1,
        Map => [
            # note: Login, Email and CustomerID needed!
            # var, frontend, storage, shown, required, storage-type, http-link
            [ 'UserSalutation', 'Salutation', 'salutation', 1, 0, 'var' ],
            [ 'UserFirstname', 'Firstname', 'first_name', 1, 1, 'var' ],
            [ 'UserLastname', 'Lastname', 'last_name', 1, 1, 'var' ],
            [ 'UserLogin', 'Login', 'login', 1, 1, 'var' ],
            [ 'UserPassword', 'Password', 'pw', 0, 1, 'var' ],
            [ 'UserEmail', 'Email', 'email', 0, 1, 'var' ],
#            [ 'UserEmail', 'Email', 'email', 1, 1, 'var', '$Env{"CGIHandle"}?Action=AgentCompose&ResponseID=1&TicketID=$Data{"TicketID"}&ArticleID=$Data{"ArticleID"}' ],
            [ 'UserCustomerID', 'CustomerID', 'customer_id', 0, 1, 'var' ],
            [ 'UserComment', 'Comment', 'comment', 1, 0, 'var' ],
            [ 'ValidID', 'Valid', 'valid_id', 0, 1, 'int' ],
        ],
    };

    # CustomerUser 
    # (customer user ldap backend and settings)
#    $Self->{CustomerUser} = {
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
#        }, 
#        # customer uniq id
#        CustomerKey => 'uid',
#        # customer #
#        CustomerID => 'mail',
#        CustomerUserListFields => ['uid', 'cn', 'mail'],
#        CustomerUserSearchFields => ['uid', 'cn', 'mail'],
#        CustomerUserNameFields => ['givenname', 'sn'],
#        Map => [
#            # note: Login, Email and CustomerID needed!
#            # var, frontend, storage, shown, required, storage-type
#            [ 'UserSalutation', 'Title', 'title', 1, 0, 'var' ],
#            [ 'UserFirstname', 'Firstname', 'givenname', 1, 1, 'var' ],
#            [ 'UserLastname', 'Lastname', 'sn', 1, 1, 'var' ],
#            [ 'UserLogin', 'Login', 'uid', 1, 1, 'var' ],
#            [ 'UserEmail', 'Email', 'mail', 1, 1, 'var' ],
#            [ 'UserCustomerID', 'CustomerID', 'mail', 0, 1, 'var' ],
#            [ 'UserPhone', 'Phone', 'telephonenumber', 1, 0, 'var' ],
#            [ 'UserAddress', 'Address', 'postaladdress', 1, 0, 'var' ],
#            [ 'UserComment', 'Comment', 'description', 1, 0, 'var' ],
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
            'RefreshTime', 'Language', 'Charset', 'Theme', 
        ],
        'Other Options' => [
            'Password', 'ClosedTickets',
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
    $Self->{CustomerPreferencesGroups}->{Charset} = {
        Colum => 'Frontend', 
        Label => 'Charset',
        Desc => 'Select your frontend Charset.', 
        Type => 'Generic',
        PrefKey => 'UserCharset',
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
    $Self->{PhoneDefaultNoteText} = 'Customer called';
    # next possible states after phone
    $Self->{PhoneDefaultNextStateType} = ['open', 'pending auto', 'pending reminder', 'closed'];
    
    # default next state
    $Self->{PhoneDefaultNextState} = 'closed successful';
    # default history type
    $Self->{PhoneDefaultHistoryType} = 'PhoneCallAgent';
    $Self->{PhoneDefaultHistoryComment} = 'Called customer.';


    # default article type
    $Self->{PhoneDefaultNewArticleType} = 'phone';
    $Self->{PhoneDefaultNewSenderType} = 'customer';
    # default note subject
    $Self->{PhoneDefaultNewSubject} = '$Text{"Phone call at %s", "Time(DateFormatLong)"}';
    # default note text
    $Self->{PhoneDefaultNewNoteText} = 'New ticket via call.';
    # default next state
    $Self->{PhoneDefaultNewNextState} = 'open';
    # default lock
    $Self->{PhoneDefaultNewLock} = 'lock';
    # default priority
    $Self->{PhoneDefaultPriority} = '3 normal';
    # default history type
    $Self->{PhoneDefaultNewHistoryType} = 'PhoneCallCustomer';
    $Self->{PhoneDefaultNewHistoryComment} = 'Customer called us.';

    # PhoneViewASP -> useful for ASP
    # (Possible to create in all queue? Not only queue which
    # the own groups) [0|1]
    $Self->{PhoneViewASP} = 1;

    # PhoneViewOwnerSelection
    $Self->{PhoneViewOwnerSelection} = 0;

    # PhoneViewSelectionType 
    # (To: seection type. Queue => show all queues, SystemAddress => show all system 
    # addresses;) [Queue|SystemAddress]
#    $Self->{PhoneViewSelectionType} = 'Queue';
    $Self->{PhoneViewSelectionType} = 'SystemAddress';

    # PhoneViewSelectionString
    # (String for To: selection.) 
    # use this for PhoneViewSelectionType = Queue
#   $Self->{PhoneViewSelectionString} = 'Queue: <Queue> - <QueueComment>';
#   $Self->{PhoneViewSelectionString} = '<Queue>';
    # use this for PhoneViewSelectionType = SystemAddress
    $Self->{PhoneViewSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';

    # PhoneViewOwnSelection
    # (If this is in use, "just this selection is valid" for the PhoneView.)
#    $Self->{PhoneViewOwnSelection} = {
#        # QueueID => String
#        '1' => 'First Queue!',
#        '2' => 'Second Queue!',
#    };

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
