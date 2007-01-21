# --
# Kernel/System/PostMaster/Filter/AgentInterface.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentInterface.pm,v 1.7 2007-01-21 01:26:10 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::Filter::AgentInterface;

use strict;
use Kernel::System::Email;
use Kernel::System::Queue;
use Kernel::System::User;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# bulk, list
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    foreach (qw(ConfigObject LogObject DBObject ParseObject TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{EmailObject} = Kernel::System::Email->new(%Param);
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);
    $Self->{UserObject} = Kernel::System::User->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # get config options
    my %Config = ();
    my %Match = ();
    my %Set = ();
    if ($Param{JobConfig} && ref($Param{JobConfig}) eq 'HASH') {
        %Config = %{$Param{JobConfig}};
        if ($Config{Match}) {
            %Match = %{$Config{Match}};
        }
        if ($Config{Set}) {
            %Set = %{$Config{Set}};
        }
    }
    # check bulk emails
    if ($Param{GetParam}->{'X-OTRS-Loop'}) {
        # set this message to ignore, because it's a bulk email
        if ($Self->{Debug} > 1) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Ignore Message for AgentEmailinterface because of loop header (MessageID:$Param{GetParam}->{'Message-ID'})!",
            );
        }
        $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
        return 1;
    }
    # check if it's a follow up
    if (!$Param{TicketID}) {
        if ($Self->{Debug} > 1) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "No email for AgentInterface because of missing TicketID (MessageID:$Param{GetParam}->{'Message-ID'})!",
            );
        }
        return 1;
    }
    # get ticket data
    my $TicketHook = $Self->{ConfigObject}->Get('Ticket::Hook') || '';
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});
    if (!%Ticket) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message => "No such Ticket (TicketID=$Param{TicketID})!",
        );
        return 1;
    }
    # get command
    my %Command = ();
    $Param{GetParam}->{Body} =~ s{
        <OTRS_CMD>(.+?)</OTRS_CMD>
    }
    {
        my @CMDs = split(/,/, $1);
        foreach my $CMD (@CMDs) {
            $CMD =~ s/ //g;
            $Command{lc($CMD)} = 1;
        }
        "";
    }sexm;
    # check commands
    if (!%Command) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "No commands in AgentInterface email found, send reject to agent (MessageID:$Param{GetParam}->{'Message-ID'})!",
        );
        # send reject
        $Self->{EmailObject}->Send(
            To => $Param{GetParam}->{From},
            Subject => "[$TicketHook: $Ticket{TicketNumber}] AgentEmail rejected!",
            Type => 'text/plain',
            Charset => 'us-ascii',
            Body => "Sorry, AgentEmail rejected because no <OTRS_CMD> found!",
            Loop => 1,
        );
        # set this message to ignore, becouse it's already done
        $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
        return 1;
    }

    # check To: address (return if no correct recipient)
    if ($Config{AgentInterfaceAddress}) {
        my $ForAgentInterface = 0;
        my $Recipient = '';
        foreach (qw(To Cc Resent-To)) {
            if ($Param{GetParam}->{$_}) {
                if ($Recipient) {
                    $Recipient .= ', ';
                }
                $Recipient .= $Param{GetParam}->{$_};
            }
        }
        my @EmailAddresses = $Self->{ParseObject}->SplitAddressLine(
            Line => $Recipient,
        );
        foreach (@EmailAddresses) {
            my $Address = $Self->{ParseObject}->GetEmailAddress(Email => $_);
            if ($Config{AgentInterfaceAddress} =~ /^\Q$Address\E$/i) {
                $ForAgentInterface = 1;
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Email for AgentInterface: $_ (MessageID:$Param{GetParam}->{'Message-ID'})!",
                    );
                }
            }
        }
        if (!$ForAgentInterface) {
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Email not for AgentInterface: $_ (MessageID:$Param{GetParam}->{'Message-ID'})!",
                );
            }
            return 1;
        }
    }
    # check From: Address (return if sender is no valid agent)
    my $From = $Param{GetParam}->{'From'};
    my @FromEmailAddress = $Self->{ParseObject}->SplitAddressLine(
        Line => $From,
    );
    $FromEmailAddress[0] = $Self->{ParseObject}->GetEmailAddress(Email => $FromEmailAddress[0]);
    my %User = $Self->{UserObject}->UserSearch(
        Valid => 1,
        PostMasterSearch => $FromEmailAddress[0],
    );
    my $UserID;
    foreach (keys %User) {
        $UserID = $_;
    }
    if (!$UserID) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "No valid sender for AgentInterface: $From (MessageID:$Param{GetParam}->{'Message-ID'})!",
        );
        # send reject
        $Self->{EmailObject}->Send(
            To => $Param{GetParam}->{From},
            Subject => "[$TicketHook: $Ticket{TicketNumber}] AgentEmail rejected!",
            Type => 'text/plain',
            Charset => 'us-ascii',
            Body => "Sorry, AgentEmail rejected no valid agent sender address!",
            Loop => 1,
        );
        # set this message to ignore, becouse it's already done
        $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
        return 1;
    }
    # check queue permission
    if (!$Self->{TicketObject}->Permission(Type => 'rw', TicketID => $Param{TicketID}, UserID => $UserID)) {
        # send reject
        $Self->{EmailObject}->Send(
            To => $Param{GetParam}->{From},
            Subject => "[$TicketHook: $Ticket{TicketNumber}] AgentEmail rejected!",
            Type => 'text/plain',
            Charset => 'us-ascii',
            Body => "Sorry, AgentEmail rejected because no rw permission on this ticket!",
            Loop => 1,
        );
        # set this message to ignore, becouse it's already done
        $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
        return 1;
    }
    # send orig (get)
    if ($Command{get}) {
        delete $Command{get};
        # get old article for quoteing
        my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(TicketID => $Param{TicketID});
        # set from
        my $From = $Self->{ConfigObject}->Get('NotificationSenderName').
            ' <'.$Self->{ConfigObject}->Get('NotificationSenderEmail').'>';
        my $Subject = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Ticket{TicketNumber},
            Subject => $Article{Subject} || '',
        );
        my $Body = "\n----------------->raw message send by OTRS<-------------------\n<OTRS_CMD>send,lock,unlock</OTRS_CMD>\n";
        foreach (qw(From To Cc Subject)) {
            if ($Article{$_}) {
                $Body .= "$_: $Article{$_}\n";
            }
        }
        $Body .= $Article{Body};
        # send notify
        $Self->{EmailObject}->Send(
            From => $Article{From} || $From,
            To => $Param{GetParam}->{From},
            Subject => $Subject,
            'Reply-To' => $Self->{ConfigObject}->Get('NotificationSenderEmail'),
            Type => 'text/plain',
            Charset => $Article{Charset},
            Body => $Body,
            Loop => 1,
        );
        # log reject
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Sent requested ticket ($Ticket{TicketNumber}) to $Param{GetParam}->{From}: $From (MessageID:$Param{GetParam}->{'Message-ID'})!",
        );
        # set this message to ignore, becouse it's already done
        $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
        return 1;
    }
    # check command
    # close
    # lock ticket
    if ($Command{lock}) {
        # check lock
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Param{TicketID})) {
            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID => $Param{TicketID},
                UserID => $UserID,
                NewUserID => $UserID,
            );
            # set lock
            $Self->{TicketObject}->LockSet(
                TicketID => $Param{TicketID},
                Lock => 'lock',
                UserID => $UserID,
            );
        }
        else {
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Param{TicketID},
            );
            if ($OwnerID != $UserID) {
                # log reject
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message => "Reject AgentInterface message because of other owner lock: $From (MessageID:$Param{GetParam}->{'Message-ID'})!",
                );
                # send reject
                $Self->{EmailObject}->Send(
                    To => $Param{GetParam}->{From},
                    Subject => "[$TicketHook: $Ticket{TicketNumber}] AgentEmail rejected!",
                    Type => 'text/plain',
                    Charset => 'us-ascii',
                    Body => "Sorry, AgentEmail rejected because Ticket is already locked for somebody else!",
                    Loop => 1,
                );
                # set this message to ignore, becouse it's already done
                $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
                return 1;
            }
        }
    }
    # send answer
    if ($Command{send}) {
        delete $Command{send};
        # check lock
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Param{TicketID})) {
            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID => $Param{TicketID},
                UserID => $UserID,
                NewUserID => $UserID,
            );
            # set lock
            $Self->{TicketObject}->LockSet(
                TicketID => $Param{TicketID},
                Lock => 'lock',
                UserID => $UserID,
            );
        }
        else {
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Param{TicketID},
            );
            if ($OwnerID != $UserID) {
                # log reject
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message => "Reject AgentInterface message because of other owner lock: $From (MessageID:$Param{GetParam}->{'Message-ID'})!",
                );
                # send reject
                $Self->{EmailObject}->Send(
                    To => $Param{GetParam}->{From},
                    Subject => "[$TicketHook: $Ticket{TicketNumber}] AgentEmail rejected!",
                    Type => 'text/plain',
                    Charset => 'us-ascii',
                    Body => "Sorry, AgentEmail rejected because Ticket is already locked for somebody else!",
                    Loop => 1,
                );
                # set this message to ignore, becouse it's already done
                $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
                return 1;
            }
        }
        # get old article
        my %Data = $Self->{TicketObject}->ArticleLastCustomerArticle(
            TicketID => $Param{TicketID},
        );
        # check article type and replace To with From (in case)
        if ($Data{SenderType} !~ /customer/) {
            my $To = $Data{To};
            my $From = $Data{From};
            $Data{From} = $To;
            $Data{To} = $Data{From};
            $Data{ReplyTo} = '';
        }
        # check ReplyTo
        if ($Data{ReplyTo}) {
            $Data{To} = $Data{ReplyTo};
        }
        else {
            $Data{To} = $Data{From};
        }
        # get customer data
        my %Customer = ();
        if ($Ticket{CustomerUserID}) {
            %Customer = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }
        # get to email (just "some@example.com")
        foreach my $Email (Mail::Address->parse($Data{To})) {
            $Data{ToEmail} = $Email->address();
        }
        # use database email
        if ($Customer{UserEmail} && $Data{ToEmail} !~ /^\Q$Customer{UserEmail}\E$/i) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Added customer database email to Cc: $Customer{UserEmail} (MessageID:$Param{GetParam}->{'Message-ID'})!",
            );
            if ($Data{Cc}) {
                $Data{Cc} .= ', '.$Customer{UserEmail};
            }
            else {
                $Data{Cc} = $Customer{UserEmail};
            }
        }
        # prepare subject
        my $Subject = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Ticket{TicketNumber},
            Subject => $Param{GetParam}->{'Subject'} || '',
        );
        # get queue sender
        my %Address = $Self->{QueueObject}->GetSystemAddress(%Ticket);
        $Data{From} = "$Address{RealName} <$Address{Email}>";
        my $NewRecipient = '';
        foreach (qw(To Cc Bcc)) {
            if ($Data{$_}) {
                $NewRecipient .= "$Data{$_}, ";
            }
        }
        # send email
        my $ArticleID = $Self->{TicketObject}->ArticleSend(
            ArticleType => 'email-external',
            SenderType => 'agent',
            TicketID => $Param{TicketID},
            HistoryType => 'SendAnswer',
            HistoryComment => "\%\%$NewRecipient",
            From => $Data{From},
            To => $Data{To},
            Cc => $Data{Cc} || '',
            Bcc => $Data{Bcc} || '',
            Subject => $Subject,
            UserID => $UserID,
            Body => $Param{GetParam}->{'Body'},
            InReplyTo => $Data{InReplyTo},
            Charset => $Param{GetParam}->{'Charset'},
            Type => 'text/plain',
            Attachment => [$Self->{ParseObject}->GetAttachments()],
        );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Send AgentInterface message to $NewRecipient (MessageID:$Param{GetParam}->{'Message-ID'})!",
        );
    }
    # unlock ticket
    if ($Command{unlock}) {
        delete $Command{unlock};
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Param{TicketID},
        );
        if ($OwnerID != $UserID) {
            # log reject
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Reject AgentInterface message because of other owner lock: $From (MessageID:$Param{GetParam}->{'Message-ID'})!",
            );
            # send reject
            $Self->{EmailObject}->Send(
                To => $Param{GetParam}->{From},
                Subject => "[$TicketHook: $Ticket{TicketNumber}] AgentEmail rejected!",
                Type => 'text/plain',
                Charset => 'us-ascii',
                Body => "Sorry, AgentEmail rejected because Ticket is already locked for somebody else!",
                Loop => 1,
            );
            # set this message to ignore, becouse it's already done
            $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';
            return 1;
        }
        # set unlock
        $Self->{TicketObject}->LockSet(
            TicketID => $Param{TicketID},
            Lock => 'unlock',
            UserID => $UserID,
        );
        print "Unlock Ticket\n";
    }
    if (%Command) {
        foreach (sort keys %Command) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Unknown command $_! (MessageID:$Param{GetParam}->{'Message-ID'})!",
            );
            print "Unknown Command $_\n";
        }
    }
    # set this message to ignore, becouse it's already done
    $Param{GetParam}->{'X-OTRS-Ignore'} = 'yes';

    return 1;
}

1;