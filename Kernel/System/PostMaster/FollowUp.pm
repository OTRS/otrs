# --
# Kernel/System/PostMaster/FollowUp.pm - the sub part of PostMaster.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::FollowUp;

use strict;
use warnings;

use Kernel::System::User;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(DBObject ConfigObject TicketObject LogObject TimeObject ParserObject MainObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{UserObject} = Kernel::System::User->new( %{$Self} );

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
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    my $Comment          = $Param{Comment}          || '';
    my $Lock             = $Param{Lock}             || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # Check if owner of ticket is still valid
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $Ticket{OwnerID},
    );

    # 1) check user, out of office, unlock ticket
    if ( $UserInfo{OutOfOfficeMessage} ) {
        $Self->{TicketObject}->TicketLockSet(
            TicketID => $Param{TicketID},
            Lock     => 'unlock',
            UserID   => $Param{InmailUserID},
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
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Param{TicketID},
                Lock     => 'lock',
                UserID   => $Param{InmailUserID},
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
        $Self->{TicketObject}->TicketLockSet(
            TicketID => $Param{TicketID},
            Lock     => 'unlock',
            UserID   => $Param{InmailUserID},
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
        $Self->{TicketObject}->TicketStateSet(
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

# You can specify absolute dates like "2010-11-20 00:00:00" or relative dates, based on the arrival time of the email.
# Use the form "+ $Number $Unit", where $Unit can be 's' (seconds), 'm' (minutes), 'h' (hours) or 'd' (days).
# Only one unit can be specified. Examples of valid settings: "+50s" (pending in 50 seconds), "+30m" (30 minutes),
# "+12d" (12 days). Note that settings like "+1d 12h" are not possible. You can specify "+36h" instead.

        my $TargetTimeStamp = $GetParam{'X-OTRS-FollowUp-State-PendingTime'};

        my ( $Sign, $Number, $Unit )
            = $TargetTimeStamp =~ m{^\s*([+-]?)\s*(\d+)\s*([smhd]?)\s*$}smx;

        if ($Number) {
            $Sign ||= '+';
            $Unit ||= 's';

            my $Seconds = $Sign eq '-' ? ( $Number * -1 ) : $Number;

            my %UnitMultiplier = (
                s => 1,
                m => 60,
                h => 60 * 60,
                d => 60 * 60 * 24,
            );

            $Seconds = $Seconds * $UnitMultiplier{$Unit};

            $TargetTimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $Self->{TimeObject}->SystemTime() + $Seconds,
            );
        }

        my $Updated = $Self->{TicketObject}->TicketPendingTimeSet(
            String   => $TargetTimeStamp,
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        # debug
        if ($Updated) {
            if ( $Self->{Debug} > 0 ) {
                print "State-PendingTime: $GetParam{'X-OTRS-FollowUp-State-PendingTime'}\n";
            }
        }
    }

    # set priority
    if ( $GetParam{'X-OTRS-FollowUp-Priority'} ) {
        $Self->{TicketObject}->TicketPrioritySet(
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
        $Self->{TicketObject}->TicketQueueSet(
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
        $Self->{TicketObject}->TicketLockSet(
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

    # dynamic fields
    my $DynamicFieldList =
        $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldList(
        Valid      => 1,
        ResultType => 'HASH',
        ObjectType => 'Ticket'
        );

    # set dynamic fields for Ticket object type
    DYNAMICFIELDID:
    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        next DYNAMICFIELDID if !$DynamicFieldID;
        next DYNAMICFIELDID if !$DynamicFieldList->{$DynamicFieldID};
        my $Key = 'X-OTRS-FollowUp-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};
        if ( $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet
                = $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldGet(
                ID => $DynamicFieldID,
                );

            $Self->{TicketObject}->{DynamicFieldBackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $Param{TicketID},
                Value              => $GetParam{$Key},
                UserID             => $Param{InmailUserID},
            );

            if ( $Self->{Debug} > 0 ) {
                print "$Key: " . $GetParam{$Key} . "\n";
            }
        }
    }

    # reverse dynamic field list
    my %DynamicFieldListReversed = reverse %{$DynamicFieldList};

    # set ticket free text
    my %Values =
        (
        'X-OTRS-FollowUp-TicketKey'   => 'TicketFreeKey',
        'X-OTRS-FollowUp-TicketValue' => 'TicketFreeText',
        );
    for my $Item ( sort keys %Values ) {
        for my $Count ( 1 .. 16 ) {
            my $Key = $Item . $Count;
            if ( $GetParam{$Key} && $DynamicFieldListReversed{ $Values{$Item} . $Count } ) {

                # get dynamic field config
                my $DynamicFieldGet = $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ $Values{$Item} . $Count },
                );
                if ($DynamicFieldGet) {
                    my $Success = $Self->{TicketObject}->{DynamicFieldBackendObject}->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $Param{TicketID},
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                if ( $Self->{Debug} > 0 ) {
                    print "TicketKey$Count: " . $GetParam{$Key} . "\n";
                }
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
            if ( $SystemTime && $DynamicFieldListReversed{ 'TicketFreeTime' . $Count } ) {

                # get dynamic field config
                my $DynamicFieldGet = $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ 'TicketFreeTime' . $Count },
                );
                if ($DynamicFieldGet) {
                    my $Success = $Self->{TicketObject}->{DynamicFieldBackendObject}->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $Param{TicketID},
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

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
    return if !$ArticleID;

    # debug
    if ( $Self->{Debug} > 0 ) {
        print "Follow up Ticket\n";
        for my $Attribute ( sort keys %GetParam ) {
            next if !$GetParam{$Attribute};
            print "$Attribute: $GetParam{$Attribute}\n";
        }
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
            Filename           => $Attachment->{Filename},
            Content            => $Attachment->{Content},
            ContentType        => $Attachment->{ContentType},
            ContentID          => $Attachment->{ContentID},
            ContentAlternative => $Attachment->{ContentAlternative},
            ArticleID          => $ArticleID,
            UserID             => $Param{InmailUserID},
        );
    }

    # dynamic fields
    $DynamicFieldList =
        $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldList(
        Valid      => 1,
        ResultType => 'HASH',
        ObjectType => 'Article'
        );

    # set dynamic fields for Article object type
    DYNAMICFIELDID:
    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        next DYNAMICFIELDID if !$DynamicFieldID;
        next DYNAMICFIELDID if !$DynamicFieldList->{$DynamicFieldID};
        my $Key = 'X-OTRS-FollowUp-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};
        if ( $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet
                = $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldGet(
                ID => $DynamicFieldID,
                );

            $Self->{TicketObject}->{DynamicFieldBackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $ArticleID,
                Value              => $GetParam{$Key},
                UserID             => $Param{InmailUserID},
            );

            if ( $Self->{Debug} > 0 ) {
                print "$Key: " . $GetParam{$Key} . "\n";
            }
        }
    }

    # reverse dynamic field list
    %DynamicFieldListReversed = reverse %{$DynamicFieldList};

    # set free article text
    %Values =
        (
        'X-OTRS-FollowUp-ArticleKey'   => 'ArticleFreeKey',
        'X-OTRS-FollowUp-ArticleValue' => 'ArticleFreeText',
        );
    for my $Item ( sort keys %Values ) {
        for my $Count ( 1 .. 16 ) {
            my $Key = $Item . $Count;
            if ( $GetParam{$Key} && $DynamicFieldListReversed{ $Values{$Item} . $Count } ) {

                # get dynamic field config
                my $DynamicFieldGet = $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ $Values{$Item} . $Count },
                );
                if ($DynamicFieldGet) {
                    my $Success = $Self->{TicketObject}->{DynamicFieldBackendObject}->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $ArticleID,
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                if ( $Self->{Debug} > 0 ) {
                    print "TicketKey$Count: " . $GetParam{$Key} . "\n";
                }
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
