# --
# Config.pm - Config file for OpenTRS kernel
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.16 2002-02-05 21:05:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
 
package Kernel::Config;

use strict;
use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get Log Object
    $Self->{LogObject} = $Param{LogObject};
    # 0=off; 1=log if there exists no entry; 2=log all;
    $Self->{Debug} = 0;
    # load config
    $Self->Load();
    return $Self;
}
# --
sub Load {
    my $Self = shift;
    # debug
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(Priority=>'debug', MSG=>'Kernel::Config->Load()');
    }

    # ----------------------------------------------------
    # system data
    # ----------------------------------------------------

    # SecureMode
    # (Enable this so you can't use the installer.pl)
    $Self->{SecureMode} = 0;

    # CheckRemoteIP 
    # (If the application is used via a proxy-farm then the 
    # remote ip address is mostly different. In this case,
    # turn of the CheckRemoteID. ) [1|0] 
    $Self->{CheckRemoteID} = 1;

    # SystemID
    # (The identify oh the system. Each ticket number and
    # each http session id starts with this number)
    $Self->{SystemID} = 10; 

    # TicketHook 
    # (To set the Ticket identifier. Some people want to 
    # set this to e. g. Call# oder MyTicket# .)
    $Self->{TicketHook} = 'Ticket#',

    # FQDN
    # (Full qualified domain name of your system.)
    $Self->{FQDN} = 'avro.linuxatwork.de';

    # Sendmail
    # (Where is sendmail located and some options.
    # See 'man sendmail' for details.) 
    $Self->{Sendmail} = '/usr/sbin/sendmail -t -f ';

    # SendmailBcc
    # (Send all outgoing email via bcc to...)
    $Self->{SendmailBcc} = '';

    # CustomQueue
    # (The name of custom queue.)
    $Self->{CustomQueue} = 'PersonalQueue';

    # ----------------------------------------------------
    # DB settings
    # ----------------------------------------------------

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
    # (The database DNS.)
    $Self->{DatabaseDSN} = 'DBI:mysql:database='.
        $Self->{Database}.';host='.$Self->{DatabaseHost}.';';


    # ----------------------------------------------------
    # default agent settings
    # ----------------------------------------------------

    # ViewableTickets
    # (The default viewable tickets a page.)
    $Self->{ViewableTickets} = 25;

    # MaxLimit
    # (Max viewable tickets a page.)
    $Self->{MaxLimit} = 150;
    
    # Refresh
    # (Default reload time for teh QueueView.)
    $Self->{Refresh} = 180;

    # Highligh*
    # (Set the age and the collor for highlighting of old queues
    # in the QueueView.)
    # highlight age1 in min
    $Self->{HighlightAge1} = 1440;
    $Self->{HighlightColor1} = 'orange';
    # highlight age2 in min
    $Self->{HighlightAge2} = 2880;
    $Self->{HighlightColor2} = 'red';

    # ----------------------------------------------------
    # AgentUtil
    # ----------------------------------------------------
    # default limit for Tn search
    $Self->{SearchLimitTn} = 20;
    # default limit for Txt search
    $Self->{SearchLimitTxt} = 20;

    # ----------------------------------------------------
    # directories
    # ----------------------------------------------------
    # root directory
    $Self->{Home} = '/opt/OpenTRS';
    # directory for all sessen id informations
    $Self->{SessionDir} = $Self->{Home} . '/var/sessions';
    # counter log
    $Self->{CounterLog} = $Self->{Home} . '/var/log/TicketCounter.log';
    # article fs dir
    $Self->{ArticleDir} = $Self->{Home} . '/var/article';
    # loop protection Log
    $Self->{LoopProtectionLog} = $Self->{Home} . '/var/log/LoopProtection';

    # ----------------------------------------------------
    # web stuff
    # ----------------------------------------------------

    # CGIHandle
    # (Global CGI handle.)
    $Self->{CGIHandle} = 'index.pl';

    # MaxSessionTime
    # (Max valid time of one session id in second (8h = 28800).)
    $Self->{MaxSessionTime} = 28800;

    # ----------------------------------------------------
    # Ticket stuff
    # ----------------------------------------------------
    # ViewableLocks
    $Self->{ViewableLocks} = ["'unlock'", "'tmp_lock'"];

    # ViewableStats
    $Self->{ViewableStats} = ["'open'", "'new'"];

    # ViewableSenderTypes
    $Self->{ViewableSenderTypes} = ["'customer'"];

    # ----------------------------------------------------
    # PostMaster stuff
    # ----------------------------------------------------
   
    # MaxPostMasterEmails
    # (Max post master daemon email to own email-address a day.)
    $Self->{MaxPostMasterEmails} = 20;

    # PostmasterUserID
    # (The post master db-uid)
    $Self->{PostmasterUserID} = 1;

    # DefaultQueue
    # (The default queue of all)
    $Self->{DefaultQueue} = 'Raw';

    # DefaultPriority
    # (The default priority of new tickets.)
    $Self->{DefaultPriority} = 'normal';

    # DefaultState
    # (The default state of new tickets.)
    $Self->{DefaultState} = 'new';

    # X-Header
    # (All scanned x-headers.)
    $Self->{"X-Header"} = [
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

    # ----------------------------------------------------
    # default values
    # (default values for GUIs)
    # ----------------------------------------------------
    # default valid
    $Self->{DefaultValid} = 'valid';
    # default charset
    $Self->{DefaultCharset} = 'iso-8859-1';
    # default langauge
    $Self->{DefaultLanguage} = 'German';
    # default theme
    $Self->{DefaultTheme} = 'Standard';

    # ----------------------------------------------------
    # defaults for add note
    # ----------------------------------------------------
    # default note type
    $Self->{DefaultNoteType} = 'note-internal';
    # default note subject
    $Self->{DefaultNoteSubject} = 'Note!';
    # default note text
    $Self->{DefaultNoteText} = '';

    # ----------------------------------------------------
    # defaults for close ticket
    # ----------------------------------------------------
    # CloseNoteType
    $Self->{DefaultCloseNoteType} = 'note-internal';
    # CloseNoteSubject
    $Self->{DefaultCloseNoteSubject} = 'Close!';
    # CloseNoteText
    $Self->{DefaultCloseNoteText} = '';
    # CloseType
    $Self->{DefaultCloseType} = 'closed succsessful';

    # ----------------------------------------------------
    # defaults for compose message
    # ----------------------------------------------------
    # default compose next state
    $Self->{DefaultNextComposeType} = 'open';
    # next possible states for compose message
    $Self->{DefaultNextComposeTypePossible} = [
        'open', 
        'closed succsessful', 
        'closed unsuccsessful',
    ];

}
# --
sub Get {
    my $Self = shift;
    my $What = shift;
    # debug
    if ($Self->{Debug} > 1) {
        $Self->{LogObject}->Log(
          Priority=>'debug', 
          MSG=>"->Get('$What') --> $Self->{$What}"
        );
    }
    # warn if the value is not def
    if (!$Self->{$What} && $Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority=>'error',
          MSG=>"No value for '$What' in Config.pm found!"
        );
    }
    return $Self->{$What};
}
# --

1;

