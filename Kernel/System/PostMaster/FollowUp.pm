# --
# Kernel/System/PostMaster/FollowUp.pm - the sub part of PostMaster.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FollowUp.pm,v 1.63 2008-12-22 01:14:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PostMaster::FollowUp;

use strict;
use warnings;

use Kernel::System::User;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.63 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check needed Objects
    for (qw(DBObject ConfigObject TicketObject LogObject TimeObject ParserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{UserObject} = Kernel::System::User->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID InmailUserID GetParam Tn AutoResponseType)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %GetParam = %{ $Param{GetParam} };

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    my $Comment          = $Param{Comment}          || '';
    my $Lock             = $Param{Lock}             || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # Check if owner of ticket is still valid
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $Ticket{OwnerID},
    );

    # 1) check user, out of office, unlock ticket
    if ( $UserInfo{OutOfOfficeMessage} ) {
        $Self->{TicketObject}->LockSet(
            TicketID => $Param{TicketID},
            Lock     => 'unlock',
            UserID   => => $Param{InmailUserID},
        );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Ticket [$Param{Tn}] unlocked, current owner is out of office!",
        );
    }

    # 2) check user, just lock it if user is valid and ticket was closed
    elsif ( $UserInfo{ValidID} eq 1 ) {

        # set lock (if ticket should be locked on follow up)
        if ( $Lock && $Ticket{StateType} =~ /^close/i ) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Param{TicketID},
                Lock     => 'lock',
                UserID   => => $Param{InmailUserID},
            );
            if ( $Self->{Debug} > 0 ) {
                print "Lock: lock\n";
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Ticket [$Param{Tn}] still locked",
                );
            }
        }
    }

    # 3) Unlock ticket, because current user is set to invalid
    else {
        $Self->{TicketObject}->LockSet(
            TicketID => $Param{TicketID},
            Lock     => 'unlock',
            UserID   => => $Param{InmailUserID},
        );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Ticket [$Param{Tn}] unlocked, current owner is invalid!",
        );
    }

    # set state
    my $State = $Self->{ConfigObject}->Get('PostmasterFollowUpState') || 'open';
    if (
        $Ticket{StateType} =~ /^close/
        && $Self->{ConfigObject}->Get('PostmasterFollowUpStateClosed')
        )
    {
        $State = $Self->{ConfigObject}->Get('PostmasterFollowUpStateClosed');
    }
    if ( $GetParam{'X-OTRS-FollowUp-State'} ) {
        $State = $GetParam{'X-OTRS-FollowUp-State'};
    }

    if ( $Ticket{StateType} !~ /^new/ || $GetParam{'X-OTRS-FollowUp-State'} ) {
        $Self->{TicketObject}->StateSet(
            State => $GetParam{'X-OTRS-FollowUp-State'} || $State,
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );
        if ( $Self->{Debug} > 0 ) {
            print "State: $State\n";
        }
    }

    # set pending time
    if ( $GetParam{'X-OTRS-FollowUp-State-PendingTime'} ) {
        if (
            $Self->{TicketObject}->TicketPendingTimeSet(
                String   => $GetParam{'X-OTRS-FollowUp-State-PendingTime'},
                TicketID => $Param{TicketID},
                UserID   => $Param{InmailUserID},
            )
            )
        {

            # debug
            if ( $Self->{Debug} > 0 ) {
                print "State-PendingTime: $GetParam{'X-OTRS-FollowUp-State-PendingTime'}\n";
            }
        }
    }

    # set priority
    if ( $GetParam{'X-OTRS-FollowUp-Priority'} ) {
        $Self->{TicketObject}->PrioritySet(
            TicketID => $Param{TicketID},
            Priority => $GetParam{'X-OTRS-FollowUp-Priority'},
            UserID   => $Param{InmailUserID},
        );
        if ( $Self->{Debug} > 0 ) {
            print "PriorityUpdate: $GetParam{'X-OTRS-FollowUp-Priority'}\n";
        }
    }

    # set queue
    if ( $GetParam{'X-OTRS-FollowUp-Queue'} ) {
        $Self->{TicketObject}->MoveTicket(
            Queue    => $GetParam{'X-OTRS-FollowUp-Queue'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );
        if ( $Self->{Debug} > 0 ) {
            print "QueueUpdate: $GetParam{'X-OTRS-FollowUp-Queue'}\n";
        }
    }

    # set lock
    if ( $GetParam{'X-OTRS-FollowUp-Lock'} ) {
        $Self->{TicketObject}->LockSet(
            Lock     => $GetParam{'X-OTRS-FollowUp-Lock'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );
        if ( $Self->{Debug} > 0 ) {
            print "Lock: $GetParam{'X-OTRS-FollowUp-Lock'}\n";
        }
    }

    # set ticket type
    if ( $GetParam{'X-OTRS-FollowUp-Type'} ) {
        $Self->{TicketObject}->TicketTypeSet(
            Type     => $GetParam{'X-OTRS-FollowUp-Type'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );
        if ( $Self->{Debug} > 0 ) {
            print "Type: $GetParam{'X-OTRS-FollowUp-Type'}\n";
        }
    }

    # set ticket service
    if ( $GetParam{'X-OTRS-FollowUp-Service'} ) {
        $Self->{TicketObject}->TicketServiceSet(
            Service  => $GetParam{'X-OTRS-FollowUp-Service'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );
        if ( $Self->{Debug} > 0 ) {
            print "Service: $GetParam{'X-OTRS-FollowUp-Service'}\n";
        }
    }

    # set ticket sla
    if ( $GetParam{'X-OTRS-FollowUp-SLA'} ) {
        $Self->{TicketObject}->TicketSLASet(
            SLA      => $GetParam{'X-OTRS-FollowUp-SLA'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );
        if ( $Self->{Debug} > 0 ) {
            print "SLA: $GetParam{'X-OTRS-FollowUp-SLA'}\n";
        }
    }

    # set free ticket text
    my @Values = ( 'X-OTRS-FollowUp-TicketKey', 'X-OTRS-FollowUp-TicketValue' );
    for my $Count ( 1 .. 16 ) {
        if ( $GetParam{ $Values[0] . $Count } ) {
            $Self->{TicketObject}->TicketFreeTextSet(
                TicketID => $Param{TicketID},
                Key      => $GetParam{ $Values[0] . $Count },
                Value    => $GetParam{ $Values[1] . $Count },
                Counter  => $Count,
                UserID   => $Param{InmailUserID},
            );
            if ( $Self->{Debug} > 0 ) {
                print "TicketKey$Count: " . $GetParam{ $Values[0] . $Count } . "\n";
                print "TicketValue$Count: " . $GetParam{ $Values[1] . $Count } . "\n";
            }
        }
    }

    # set ticket free time
    for my $Count ( 1 .. 6 ) {
        my $Key = 'X-OTRS-FollowUp-TicketTime' . $Count;
        if ( $GetParam{$Key} ) {
            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $GetParam{$Key},
            );
            my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $SystemTime,
            );
            if ( $Year && $Month && $Day && $Hour && $Min ) {
                $Self->{TicketObject}->TicketFreeTimeSet(
                    'TicketFreeTime' . $Count . 'Year'   => $Year,
                    'TicketFreeTime' . $Count . 'Month'  => $Month,
                    'TicketFreeTime' . $Count . 'Day'    => $Day,
                    'TicketFreeTime' . $Count . 'Hour'   => $Hour,
                    'TicketFreeTime' . $Count . 'Minute' => $Min,
                    Prefix                               => 'TicketFreeTime',
                    TicketID                             => $Param{TicketID},
                    Counter                              => $Count,
                    UserID                               => $Param{InmailUserID},
                );
                if ( $Self->{Debug} > 0 ) {
                    print "TicketTime$Count: " . $GetParam{$Key} . "\n";
                }
            }
        }
    }

    # do db insert
    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID         => $Param{TicketID},
        ArticleType      => $GetParam{'X-OTRS-FollowUp-ArticleType'},
        SenderType       => $GetParam{'X-OTRS-FollowUp-SenderType'},
        From             => $GetParam{From},
        ReplyTo          => $GetParam{ReplyTo},
        To               => $GetParam{To},
        Cc               => $GetParam{Cc},
        Subject          => $GetParam{Subject},
        MessageID        => $GetParam{'Message-ID'},
        InReplyTo        => $GetParam{'In-Reply-To'},
        References       => $GetParam{'References'},
        ContentType      => $GetParam{'Content-Type'},
        Body             => $GetParam{Body},
        UserID           => $Param{InmailUserID},
        HistoryType      => 'FollowUp',
        HistoryComment   => "\%\%$Param{Tn}\%\%$Comment",
        AutoResponseType => $AutoResponseType,
        OrigHeader       => \%GetParam,
    );
    if ( !$ArticleID ) {
        return;
    }

    # debug
    if ( $Self->{Debug} > 0 ) {
        print "Follow up Ticket\n";
        print "TicketNumber: $Param{Tn}\n";
        print "From: $GetParam{From}\n"       if ( $GetParam{From} );
        print "ReplyTo: $GetParam{ReplyTo}\n" if ( $GetParam{ReplyTo} );
        print "To: $GetParam{To}\n"           if ( $GetParam{To} );
        print "Cc: $GetParam{Cc}\n"           if ( $GetParam{Cc} );
        print "Subject: $GetParam{Subject}\n";
        print "MessageID: $GetParam{'Message-ID'}\n";
        print "ArticleType: $GetParam{'X-OTRS-FollowUp-ArticleType'}\n";
        print "SenderType: $GetParam{'X-OTRS-FollowUp-SenderType'}\n";
    }

    # write plain email to the storage
    $Self->{TicketObject}->ArticleWritePlain(
        ArticleID => $ArticleID,
        Email     => $Self->{ParserObject}->GetPlainEmail(),
        UserID    => $Param{InmailUserID},
    );

    # write attachments to the storage
    for my $Attachment ( $Self->{ParserObject}->GetAttachments() ) {
        $Self->{TicketObject}->ArticleWriteAttachment(
            Content     => $Attachment->{Content},
            Filename    => $Attachment->{Filename},
            ContentType => $Attachment->{ContentType},
            ArticleID   => $ArticleID,
            UserID      => $Param{InmailUserID},
        );
    }

    # set free article text
    @Values = ( 'X-OTRS-FollowUp-ArticleKey', 'X-OTRS-FollowUp-ArticleValue' );
    for my $Count ( 1 .. 3 ) {
        if ( $GetParam{ $Values[0] . $Count } ) {
            $Self->{TicketObject}->ArticleFreeTextSet(
                TicketID  => $Param{TicketID},
                ArticleID => $ArticleID,
                Key       => $GetParam{ $Values[0] . $Count },
                Value     => $GetParam{ $Values[1] . $Count },
                Counter   => $Count,
                UserID    => $Param{InmailUserID},
            );
            if ( $Self->{Debug} > 0 ) {
                print "ArticleKey$Count: " . $GetParam{ $Values[0] . $Count } . "\n";
                print "ArticleValue$Count: " . $GetParam{ $Values[1] . $Count } . "\n";
            }

        }
    }

    # write log
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "FollowUp Article to Ticket [$Param{Tn}] created "
            . "(TicketID=$Param{TicketID}, ArticleID=$ArticleID). $Comment,"
    );

    return 1;
}

1;
