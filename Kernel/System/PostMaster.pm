# --
# Kernel/System/PostMaster.pm - the global PostMaster module for OTRS
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: PostMaster.pm,v 1.62 2006-12-14 14:18:50 martin Exp $
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
use Kernel::System::Queue;
use Kernel::System::State;
use Kernel::System::PostMaster::Reject;
use Kernel::System::PostMaster::FollowUp;
use Kernel::System::PostMaster::NewTicket;
use Kernel::System::PostMaster::DestQueue;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.62 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed objects
    foreach (qw(DBObject LogObject ConfigObject TimeObject MainObject Email)) {
        die "Got no $_" if (!$Param{$_});
    }
    # check needed config objects
    foreach (qw(PostmasterUserID PostmasterX-Header)) {
        $Self->{$_} = $Param{ConfigObject}->Get($_) || die "Found no '$_' option in Config.pm!";
    }

    # for debug 0=off; 1=info; 2=on; 3=with GetHeaderParam;
    $Self->{Debug} = $Param{Debug} || 0;

    # create common objects
    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    $Self->{ParseObject} = Kernel::System::EmailParser->new(
        Email => $Param{Email},
        %Param,
    );
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{DestQueueObject} = Kernel::System::PostMaster::DestQueue->new(
        %Param,
        QueueObject => $Self->{QueueObject},
        ParseObject => $Self->{ParseObject},
    );
    $Self->{NewTicket} = Kernel::System::PostMaster::NewTicket->new(
        %Param,
        Debug => $Self->{Debug},
        ParseObject => $Self->{ParseObject},
        TicketObject => $Self->{TicketObject},
        QueueObject => $Self->{QueueObject},
        LoopProtectionObject => $Self->{LoopProtectionObject},
    );
    $Self->{FollowUp} = Kernel::System::PostMaster::FollowUp->new(
        %Param,
        Debug => $Self->{Debug},
        TicketObject => $Self->{TicketObject},
        LoopProtectionObject => $Self->{LoopProtectionObject},
        ParseObject => $Self->{ParseObject},
    );
    $Self->{Reject} = Kernel::System::PostMaster::Reject->new(
        %Param,
        Debug => $Self->{Debug},
        TicketObject => $Self->{TicketObject},
        LoopProtectionObject => $Self->{LoopProtectionObject},
        ParseObject => $Self->{ParseObject},
    );
    # should i use the x-otrs header?
    $Self->{Trusted} = defined $Param{Trusted} ? $Param{Trusted} : 1;

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # ConfigObject section / get params
    my $GetParam = $Self->GetEmailParams();

    # check if follow up
    my ($Tn, $TicketID) = $Self->CheckFollowUp(%{$GetParam});

    # run all PreFilterModules (modify email params)
    if (ref($Self->{ConfigObject}->Get('PostMaster::PreFilterModule')) eq 'HASH') {
        my %Jobs = %{$Self->{ConfigObject}->Get('PostMaster::PreFilterModule')};
        foreach my $Job (sort keys %Jobs) {
            if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                my $FilterObject = $Jobs{$Job}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    MainObject => $Self->{MainObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    ParseObject => $Self->{ParseObject},
                    TicketObject => $Self->{TicketObject},
                    TimeObject => $Self->{TimeObject},
                    Debug => $Self->{Debug},
                );
                # modify params
                if (!$FilterObject->Run(
                    GetParam => $GetParam,
                    JobConfig => $Jobs{$Job},
                    TicketID => $TicketID,
                )) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Execute Run() of PreFilterModule $Jobs{$Job}->{Module} not successfully!",
                    );
                }
            }
        }
    }

    # should I ignore the incoming mail?
    if ($GetParam->{'X-OTRS-Ignore'} && $GetParam->{'X-OTRS-Ignore'} =~ /yes/i) {
       $Self->{LogObject}->Log(
           Priority => 'notice',
           Message => "Ignored Email (From: $GetParam->{'From'}, Message-ID: $GetParam->{'Message-ID'}) " .
           "because the X-OTRS-Ignore is set (X-OTRS-Ignore: $GetParam->{'X-OTRS-Ignore'})."
       );
       return 1;
   }
   # ----------------------
   # ticket section
   # ----------------------

   # check if follow up (again, with new GetParam)
   ($Tn, $TicketID) = $Self->CheckFollowUp(%{$GetParam});
   # check if it's a follow up ...
   if ($Tn && $TicketID) {
        # get ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
        # check if it is possible to do the follow up
        # get follow up option (possible or not)
        my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
            QueueID => $Ticket{QueueID},
        );
        # get lock option (should be the ticket locked - if closed - after the follow up)
        my $Lock = $Self->{QueueObject}->GetFollowUpLockOption(
            QueueID => $Ticket{QueueID},
        );
        # get state details
        my %State = $Self->{StateObject}->StateGet(ID => $Ticket{StateID});
        # create a new ticket
        if ($FollowUpPossible =~ /new ticket/i && $State{TypeName} =~ /^close/i) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Follow up for [$Tn] but follow up not possible ($Ticket{State}).".
                " Create new ticket."
            );
            # send mail && create new article
            # get queue if of From: and To:
            if (!$Param{QueueID}) {
              $Param{QueueID} = $Self->{DestQueueObject}->GetQueueID(
                  Params => $GetParam,
              );
            }
            # check if trusted returns a new queue id
            my $TQueueID = $Self->{DestQueueObject}->GetTrustedQueueID(
                Params => $GetParam,
            );
            if ($TQueueID) {
                $Param{QueueID} = $TQueueID;
            }
            $TicketID = $Self->{NewTicket}->Run(
                InmailUserID => $Self->{PostmasterUserID},
                GetParam => $GetParam,
                QueueID => $Param{QueueID},
                Comment => "Because the old ticket [$Tn] is '$State{Name}'",
                AutoResponseType => 'auto reply/new ticket',
            );
            if (!$TicketID) {
                return;
            }
        }
        # reject follow up
        elsif ($FollowUpPossible =~ /reject/i && $State{TypeName} =~ /^close/i) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message=>"Follow up for [$Tn] but follow up not possible. Follow up rejected."
            );
            # send reject mail && and add article to ticket
            if (!$Self->{Reject}->Run(
                TicketID => $TicketID,
                InmailUserID => $Self->{PostmasterUserID},
                GetParam => $GetParam,
                Lock => $Lock,
                Tn => $Tn,
                Comment => 'Follow up rejected.',
                AutoResponseType => 'auto reject',
            )) {
                return;
            }
        }
        # create normal follow up
        else {
            if (!$Self->{FollowUp}->Run(
                TicketID => $TicketID,
                InmailUserID => $Self->{PostmasterUserID},
                GetParam => $GetParam,
                Lock => $Lock,
                Tn => $Tn,
                AutoResponseType => 'auto follow up',
            )) {
                return;
            }
        }
    }
    # create new ticket
    else {
        if ($Param{Queue} && !$Param{QueueID}) {
            # queue lookup if queue name is given
            $Param{QueueID} = $Self->{QueueObject}->QueueLookup(Queue => $Param{Queue});
        }
        # get queue if of From: and To:
        if (!$Param{QueueID}) {
            $Param{QueueID} = $Self->{DestQueueObject}->GetQueueID(Params => $GetParam);
        }
        # check if trusted returns a new queue id
        my $TQueueID = $Self->{DestQueueObject}->GetTrustedQueueID(
            Params => $GetParam,
        );
        if ($TQueueID) {
            $Param{QueueID} = $TQueueID;
        }
        $TicketID = $Self->{NewTicket}->Run(
            InmailUserID => $Self->{PostmasterUserID},
            GetParam => $GetParam,
            QueueID => $Param{QueueID},
            AutoResponseType => 'auto reply',
        );
        if (!$TicketID) {
            return;
        }
    }

    # run all PostFilterModules (modify email params)
    if (ref($Self->{ConfigObject}->Get('PostMaster::PostFilterModule')) eq 'HASH') {
        my %Jobs = %{$Self->{ConfigObject}->Get('PostMaster::PostFilterModule')};
        foreach my $Job (sort keys %Jobs) {
            if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                my $FilterObject = $Jobs{$Job}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    MainObject => $Self->{MainObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    ParseObject => $Self->{ParseObject},
                    TicketObject => $Self->{TicketObject},
                    TimeObject => $Self->{TimeObject},
                    Debug => $Self->{Debug},
                );
                # modify params
                if (!$FilterObject->Run(
                    TicketID => $TicketID,
                    GetParam => $GetParam,
                    JobConfig => $Jobs{$Job},
                )) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Execute Run() of PostFilterModule $Jobs{$Job}->{Module} not successfully!",
                    );
                }
            }
        }
    }

    # return 1
    return 1;
}

# CheckFollowUp

sub CheckFollowUp {
    my $Self = shift;
    my %Param = @_;
    my $Subject = $Param{Subject} || '';
    if (my $Tn = $Self->{TicketObject}->GetTNByString($Subject)) {
        my $TicketID = $Self->{TicketObject}->TicketCheckNumber(Tn => $Tn);
        if ($TicketID) {
            my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                  Priority => 'debug',
                  Message => "CheckFollowUp: ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
                );
            }
            return ($Ticket{TicketNumber}, $TicketID);
        }
    }
    # There is no valid ticket number in the subject.
    # Try to find ticket number in References and In-Reply-To header.
    if ($Self->{ConfigObject}->Get('PostmasterFollowUpSearchInReferences')) {
        my @References = $Self->{ParseObject}->GetReferences();
        foreach (@References) {
            # get ticket id of message id
            my $TicketID = $Self->{TicketObject}->ArticleGetTicketIDOfMessageID(
                MessageID => "<$_>",
            );
            if ($TicketID) {
                my $Tn = $Self->{TicketObject}->TicketNumberLookup(
                     TicketID => $TicketID,
                );
                if ($TicketID && $Tn) {
                    return ($Tn, $TicketID);
                }
            }
        }
    }
    # do body ticket number lookup
    if ($Self->{ConfigObject}->Get('PostmasterFollowUpSearchInBody')) {
        if (my $Tn = $Self->{TicketObject}->GetTNByString($Self->{ParseObject}->GetMessageBody())) {
            my $TicketID = $Self->{TicketObject}->TicketCheckNumber(Tn => $Tn);
            if ($TicketID) {
                my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                      Priority => 'debug',
                      Message => "CheckFollowUp (in body): ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
                    );
                }
                return ($Ticket{TicketNumber}, $TicketID);
            }
        }
    }
    # do attachment ticket number lookup
    if ($Self->{ConfigObject}->Get('PostmasterFollowUpSearchInAttachment')) {
        foreach my $Attachment ($Self->{ParseObject}->GetAttachments()) {
            if (my $Tn = $Self->{TicketObject}->GetTNByString($Attachment->{Content})) {
                my $TicketID = $Self->{TicketObject}->TicketCheckNumber(Tn => $Tn);
                if ($TicketID) {
                    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
                    if ($Self->{Debug} > 1) {
                        $Self->{LogObject}->Log(
                          Priority => 'debug',
                          Message => "CheckFollowUp (in attachment): ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
                        );
                    }
                    return ($Ticket{TicketNumber}, $TicketID);
                }
            }
        }
    }
    # do plain/raw ticket number lookup
    if ($Self->{ConfigObject}->Get('PostmasterFollowUpSearchInRaw')) {
        if (my $Tn = $Self->{TicketObject}->GetTNByString($Self->{ParseObject}->GetPlainEmail())) {
            my $TicketID = $Self->{TicketObject}->TicketCheckNumber(Tn => $Tn);
            if ($TicketID) {
                my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                      Priority => 'debug',
                      Message => "CheckFollowUp (in plain/raw): ja, it's a follow up ($Ticket{TicketNumber}/$TicketID)",
                    );
                }
                return ($Ticket{TicketNumber}, $TicketID);
            }
        }
    }
    return;
}

# GetEmailParams

sub GetEmailParams {
    my $Self = shift;
    my %Param = @_;
    my %GetParam;
    # parse section
    my $WantParamTmp = $Self->{'PostmasterX-Header'} || die "Got no \@WantParam ref";
    my @WantParam = @$WantParamTmp;
    foreach (@WantParam){
        if (!$Self->{Trusted} && $_ =~ /^x-otrs/i) {
            # scan not x-otrs header if it's not trusted
        }
        else {
            if ($Self->{Debug} > 2) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "$_: " . $Self->{ParseObject}->GetParam(WHAT => $_),
                );
            }
            $GetParam{$_} = $Self->{ParseObject}->GetParam(WHAT => $_);
        }
    }
    # set compat. headers
    if ($GetParam{'Message-Id'}) {
        $GetParam{'Message-ID'} = $GetParam{'Message-Id'};
    }
    if ($GetParam{'Reply-To'}) {
        $GetParam{'ReplyTo'} = $GetParam{'Reply-To'};
    }
    if ($GetParam{'Mailing-List'} || $GetParam{'Precedence'} || $GetParam{'X-Loop'}
             || $GetParam{'X-No-Loop'} || $GetParam{'X-OTRS-Loop'}) {
        $GetParam{'X-OTRS-Loop'} = 'yes';
    }
    if (!$GetParam{'X-Sender'}) {
        # get sender email
        my @EmailAddresses = $Self->{ParseObject}->SplitAddressLine(
            Line => $GetParam{From},
        );
        foreach (@EmailAddresses) {
            $GetParam{'X-Sender'} = $Self->{ParseObject}->GetEmailAddress(
                Email => $_,
            );
        }
    }
    # set sender type if not given
    foreach my $Key (qw(X-OTRS-SenderType X-OTRS-FollowUp-SenderType)) {
        if (!$GetParam{$Key}) {
            $GetParam{$Key} = 'customer';
        }
        # check if X-OTRS-SenderType exists, if not, set customer
        if (!$Self->{TicketObject}->ArticleSenderTypeLookup(SenderType => $GetParam{$Key})) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't find sender type '$GetParam{$Key}' in db, take 'customer'",
            );
            $GetParam{$Key} = 'customer';
        }
    }
    # set article type if not given
    foreach my $Key (qw(X-OTRS-ArticleType X-OTRS-FollowUp-ArticleType)) {
        if (!$GetParam{$Key}) {
            $GetParam{$Key} = 'email-external';
        }
        # check if X-OTRS-ArticleType exists, if not, set 'email'
        if (!$Self->{TicketObject}->ArticleTypeLookup(ArticleType => $GetParam{$Key})) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't find article type '$GetParam{$Key}' in db, take 'email-external'",
            );
            $GetParam{$Key} = 'email-external';
        }
    }
    # get body
    $GetParam{'Body'} = $Self->{ParseObject}->GetMessageBody();
    # get content type
    $GetParam{'Content-Type'} = $Self->{ParseObject}->GetReturnContentType();
    $GetParam{'Charset'} = $Self->{ParseObject}->GetReturnCharset();
    return \%GetParam;
}

1;
