# --
# PostMaster.pm - the global PostMaster module for OpenTRS
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PostMaster.pm,v 1.1 2001-12-21 17:54:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::PostMaster;

use strict;
use Kernel::System::DB;
use Kernel::System::EmailParser;
use Kernel::System::Ticket;
use Kernel::System::Article;
use Kernel::System::Queue;
#use Kernel::System::PostMaster::FollowUp;
use Kernel::System::PostMaster::NewTicket;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # get Log Object
    $Self->{LogObject} = $Param{LogObject} || die "Got no LogObject!";

    # get ConfigObject
    $Self->{ConfigObject} = $Param{ConfigObject} || die "Got no ConfigObject!";
    $Self->{SystemID} = $Param{ConfigObject}->Get('SystemID');

    $Self->{DBObject} = Kernel::System::DB->new(%Param);

    # get email 
    $Self->{Email} = $Param{Email} || die "Got no EmailBody!";
    my $Email = $Param{Email} || die "Got no EmailBody!";
    my $OrigEmail = $Email;
    $Self->{ParseObject} = Kernel::System::EmailParser->new(
        Email => $Email,
        OrigEmail => $OrigEmail,
    );

    # for debug 0=off;1=on; 2=with GetHeaderParam;
    $Self->{Debug} = 0;

    # PostmasterUserID FIXME!!!
    $Self->{PostmasterUserID} = 1;
    $Self->{Priority} = 'normal';
    $Self->{State} = 'new';
    my @WantParam = (
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
    );
    $Self->{WantParam} = \@WantParam;

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    # --
    # common opjects
    my $TicketObject = Kernel::System::Ticket->new(
         DBObject => $Self->{DBObject}, 
         ConfigObject => $Self->{ConfigObject},
         LogObject => $Self->{LogObject},
    );
    my $ArticleObject = Kernel::System::Article->new(
         DBObject => $Self->{DBObject},
         LogObject => $Self->{LogObject},
         ConfigObject => $Self->{ConfigObject},
    );
    my $NewTicket = Kernel::System::PostMaster::NewTicket->new(
        ParseObject => $Self->{ParseObject},
        DBObject => $Self->{DBObject},
        ArticleObject => $ArticleObject,
        TicketObject => $TicketObject,
        LogObject => $Self->{LogObject},
        ConfigObject => $Self->{ConfigObject},
    );


    # --
    # ConfigObjectrse section / get params
    # --
    my %GetParam = $Self->GetEmailParams();
    # --
    # should i ignore the incoming mail?
    # --
    if ($GetParam{'X-OTRS-Ignore'} =~ /yes/i) {
       $Self->{LogObject}->Log(
           MSG => "Droped Email (From: $GetParam{'From'}, MSG-ID: $GetParam{'Message-ID'}) " .
           "because the X-OTRS-Ignore is set (X-OTRS-Ignore: $GetParam{'X-OTRS-Ignore'})."
       );
       exit (0);
   }
   # --
   # ticket section
   # --
   # check if follow up
   my ($Tn, $TicketID) = $Self->CheckFollowUp($GetParam{'Subject'}, $TicketObject);
   
    $NewTicket->Run(
        InmailUserID => $Self->{PostmasterUserID},
        GetParam => \%GetParam,
        Email => $Self->{Email},
        AutoResponseType => 'auto reply',
    );


}
# --
# CheckFollowUp
# --
sub CheckFollowUp {
    my $Self = shift;
    my %Param = @_;
    my $Subject = $Param{Subject} || '';
    my $TicketObject = $Param{TicketObject};
    my $SystemID = $Self->{SystemID};
    if ($Subject =~ /($SystemID\d{6,8})/) {
        my $Tn = $1;
        my $TicketID = $TicketObject->CheckTicketNr(Tn => $Tn);
        if ($Self->{Debug} > 0) {
            print STDERR "CheckFollowUp: Tn: $Tn found!\n";
        }
        if ($TicketID) {
            if ($Self->{Debug} > 0) {
                print STDERR "CheckFollowUp: ja, it's a follow up ($Tn/$TicketID)\n";
            }
            return ($Tn, $TicketID);
        }
    }
    return;
}
# --
# GetEmailParams
# --
sub GetEmailParams {
    my $Self = shift;
    my %Param = @_;
    my %GetParam;
    # parse section
    my $WantParamTmp = $Self->{WantParam} || die "Got no \@WantParam ref";
    my @WantParam = @$WantParamTmp;
    foreach (@WantParam){
        if ($Self->{Debug} > 1) {
            print STDERR "$_: " . $Self->{ParseObject}->GetParam(WHAT => $_) . " \n";
        }
        $GetParam{$_} = $Self->{ParseObject}->GetParam(WHAT => $_);
    }
    if ($GetParam{'Message-Id'}) {
        $GetParam{'Message-ID'} = $GetParam{'Message-Id'};
    }
    if ($GetParam{'Reply-To'}) {
        $GetParam{'ReplyTo'} = $GetParam{'Reply-To'};
    }
    if (!$GetParam{'X-OTRS-Priority'}) {
        $GetParam{'X-OTRS-Priority'} = $Self->{Priority};
    }
    if (!$GetParam{'X-OTRS-State'}) {
        $GetParam{'X-OTRS-State'} = $Self->{State};
    }
    if ($GetParam{'Mailing-List'} || $GetParam{'Precedence'} || $GetParam{'X-Loop'}
             || $GetParam{'X-No-Loop'} || $GetParam{'X-OTRS-Loop'}) {
        $GetParam{'X-OTRS-Loop'} = 'yes';
    }
    $GetParam{Body} = $Self->{ParseObject}->GetMessageBody();
    return %GetParam;
}
# --

1;
