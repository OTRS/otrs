# --
# Config.pm - Config file for OpenTRS kernel
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Config.pm,v 1.11 2002-01-23 23:01:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
 
package Kernel::Config;

use strict;
use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.11 $';
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

    # --
    # system data
    # --
    # system ID
    $Self->{SystemID} = 10; 
    # ticket Hook 
    $Self->{TicketHook} = 'Ticket#',
    # full qualified domain name of your system
    $Self->{FQDN} = 'avro.linuxatwork.de';
    # where is sendmail located
    $Self->{Sendmail} = '/usr/sbin/sendmail -t -f ';
    # send all outgoing email via bcc to
    $Self->{SendmailBcc} = '';
    # name of custom queues
    $Self->{CustomQueue} = 'PersonalQueue';

    # --
    # DB settings
    # --
    # database host
    $Self->{DatabaseHost} = 'localhost';
    # database name
#    $Self->{Database} = 'OpenTRS';
    $Self->{Database} = 'otrs';
    # database user
    $Self->{DatabaseUser} = 'root';
    # password of database user
    $Self->{DatabasePw} = '';
    # database DNS
    $Self->{DatabaseDSN} = 'DBI:mysql:database='.
        $Self->{Database}.';host='.$Self->{DatabaseHost}.';';


    # --
    # default agent settings
    # --
    # default viewable tickets a page
    $Self->{ViewableTickets} = 25;
    # max viewable tickets a page
    $Self->{MaxLimit} = 150;
    # default reload time
    $Self->{Refresh} = 180;
    # highlight age1 in min
    $Self->{HighlightAge1} = 1440;
    $Self->{HighlightColor1} = 'orange';
    # highlight age2 in min
    $Self->{HighlightAge2} = 2880;
    $Self->{HighlightColor2} = 'red';

    # --
    # AgentUtil
    # --
    # default limit for Tn search
    $Self->{SearchLimitTn} = 20;
    # default limit for Txt search
    $Self->{SearchLimitTxt} = 20;

    # --
    # directories
    # --
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

    # --
    # web stuff
    # --
    # global CGI handle
    $Self->{CGIHandle} = 'index.pl';
    # max valid time of one session id
    # in second (8h = 28800)
    $Self->{MaxSessionTime} = 28800;

    # --
    # Ticket stuff
    # --
    # ViewableLocks
    $Self->{ViewableLocks} = ["'unlock'", "'tmp_lock'"];

    # ViewableStats
    $Self->{ViewableStats} = ["'open'", "'new'"];

    # ViewableSenderTypes
    $Self->{ViewableSenderTypes} = ["'customer'"];

    # --
    # PostMaster stuff
    # --
    # max post master daemon email to own email-address a day
    $Self->{MaxPostMasterEmails} = 20;
    # post master id
    $Self->{PostmasterUserID} = 1;
    # default queue of all
    $Self->{DefaultQueue} = 'Raw';
    # default priority
    $Self->{DefaultPriority} = 'normal';
    # default state 
    $Self->{DefaultState} = 'new';
    # scanned x-headers
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

    # --
    # default values
    # --
    # default valid
    $Self->{DefaultValid} = 'valid';
    # default charset
    $Self->{DefaultCharset} = 'iso-8859-1';
    # default langauge
    $Self->{DefaultLanguage} = 'German';
    # default theme
    $Self->{DefaultTheme} = 'Standard';

    # default note type
    $Self->{DefaultNoteType} = 'note-internal';
    # default note subject
    $Self->{DefaultNoteSubject} = 'Note!';
    # default note text
    $Self->{DefaultNoteText} = '';

    # CloseNoteType
    $Self->{DefaultCloseNoteType} = 'note-internal';
    # CloseNoteSubject
    $Self->{DefaultCloseNoteSubject} = 'Close!';
    # CloseNoteText
    $Self->{DefaultCloseNoteText} = '';
    # CloseType
    $Self->{DefaultCloseType} = 'closed succsessful';


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

