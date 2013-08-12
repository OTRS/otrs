# --
# Kernel/System/PostMaster/NewTicket.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::NewTicket;

use strict;
use warnings;

use Kernel::System::AutoResponse;
use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;
use Kernel::System::User;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get all objects
    for my $Object (
        qw(DBObject ConfigObject TicketObject LogObject ParserObject TimeObject QueueObject StateObject MainObject EncodeObject PriorityObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die 'Got no $Object';
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{LinkObject}         = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(InmailUserID GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }
    my %GetParam         = %{ $Param{GetParam} };
    my $Comment          = $Param{Comment} || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # get queue id and name
    my $QueueID = $Param{QueueID} || die "need QueueID!";
    my $Queue = $Self->{QueueObject}->QueueLookup( QueueID => $QueueID );

    # get state
    my $State = $Self->{ConfigObject}->Get('PostmasterDefaultState') || 'new';
    if ( $GetParam{'X-OTRS-State'} ) {
        my $StateID = $Self->{StateObject}->StateLookup( State => $GetParam{'X-OTRS-State'} );
        if ($StateID) {
            $State = $GetParam{'X-OTRS-State'};
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "State $GetParam{'X-OTRS-State'} does not exist, falling back to $State!"
            );
        }
    }

    # get priority
    my $Priority = $Self->{ConfigObject}->Get('PostmasterDefaultPriority') || '3 normal';
    if ( $GetParam{'X-OTRS-Priority'} ) {
        my $PriorityID
            = $Self->{PriorityObject}->PriorityLookup( Priority => $GetParam{'X-OTRS-Priority'} );
        if ($PriorityID) {
            $Priority = $GetParam{'X-OTRS-Priority'};
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Priority $GetParam{'X-OTRS-Priority'} does not exist, falling back to $Priority!"
            );
        }
    }

    # get sender email
    my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine( Line => $GetParam{From}, );
    for my $Address (@EmailAddresses) {
        $GetParam{SenderEmailAddress} = $Self->{ParserObject}->GetEmailAddress(
            Email => $Address,
        );
    }

    # get customer id (sender email) if there is no customer id given
    if ( !$GetParam{'X-OTRS-CustomerNo'} && $GetParam{'X-OTRS-CustomerUser'} ) {

        # get customer user data form X-OTRS-CustomerUser
        my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $GetParam{'X-OTRS-CustomerUser'},
        );
        if (%CustomerData) {
            $GetParam{'X-OTRS-CustomerNo'} = $CustomerData{UserCustomerID};
        }
    }

    # get customer user data form From: (sender address)
    if ( !$GetParam{'X-OTRS-CustomerUser'} ) {
        my %CustomerData;
        if ( $GetParam{From} ) {
            my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
                Line => $GetParam{From},
            );
            for my $Address (@EmailAddresses) {
                $GetParam{EmailFrom} = $Self->{ParserObject}->GetEmailAddress(
                    Email => $Address,
                );
            }
            my %List = $Self->{CustomerUserObject}->CustomerSearch(
                PostMasterSearch => lc( $GetParam{EmailFrom} ),
            );
            for my $UserLogin ( sort keys %List ) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $UserLogin,
                );
            }
        }

        # take CustomerID from customer backend lookup or from from field
        if ( $CustomerData{UserLogin} && !$GetParam{'X-OTRS-CustomerUser'} ) {
            $GetParam{'X-OTRS-CustomerUser'} = $CustomerData{UserLogin};

            # notice that UserLogin is from customer source backend
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Take UserLogin ($CustomerData{UserLogin}) from "
                    . "customer source backend based on ($GetParam{'EmailFrom'}).",
            );
        }
        if ( $CustomerData{UserCustomerID} && !$GetParam{'X-OTRS-CustomerNo'} ) {
            $GetParam{'X-OTRS-CustomerNo'} = $CustomerData{UserCustomerID};

            # notice that UserCustomerID is from customer source backend
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Take UserCustomerID ($CustomerData{UserCustomerID})"
                    . " from customer source backend based on ($GetParam{'EmailFrom'}).",
            );
        }
    }

    # if there is no customer id found!
    if ( !$GetParam{'X-OTRS-CustomerNo'} ) {
        $GetParam{'X-OTRS-CustomerNo'} = $GetParam{SenderEmailAddress};
    }

    # if there is no customer user found!
    if ( !$GetParam{'X-OTRS-CustomerUser'} ) {
        $GetParam{'X-OTRS-CustomerUser'} = $GetParam{SenderEmailAddress};
    }

    # get ticket owner
    my $OwnerID = $GetParam{'X-OTRS-OwnerID'} || $Param{InmailUserID};
    if ( $GetParam{'X-OTRS-Owner'} ) {
        my $TmpOwnerID = $Self->{UserObject}->UserLookup( UserLogin => $GetParam{'X-OTRS-Owner'} );
        $OwnerID = $TmpOwnerID if $TmpOwnerID;
    }

    my %Opts;
    if ( $GetParam{'X-OTRS-ResponsibleID'} ) {
        $Opts{ResponsibleID} = $GetParam{'X-OTRS-ResponsibleID'};
    }

    if ( $GetParam{'X-OTRS-Responsible'} ) {
        my $TmpResponsibleID
            = $Self->{UserObject}->UserLookup( UserLogin => $GetParam{'X-OTRS-Responsible'} );
        $Opts{ResponsibleID} = $TmpResponsibleID if $TmpResponsibleID;
    }

    # create new ticket
    my $NewTn    = $Self->{TicketObject}->TicketCreateNumber();
    my $TicketID = $Self->{TicketObject}->TicketCreate(
        TN           => $NewTn,
        Title        => $GetParam{Subject},
        QueueID      => $QueueID,
        Lock         => $GetParam{'X-OTRS-Lock'} || 'unlock',
        Priority     => $Priority,
        State        => $State,
        Type         => $GetParam{'X-OTRS-Type'} || '',
        Service      => $GetParam{'X-OTRS-Service'} || '',
        SLA          => $GetParam{'X-OTRS-SLA'} || '',
        CustomerID   => $GetParam{'X-OTRS-CustomerNo'},
        CustomerUser => $GetParam{'X-OTRS-CustomerUser'},
        OwnerID      => $OwnerID,
        UserID       => $Param{InmailUserID},
        %Opts,
    );

    if ( !$TicketID ) {
        return;
    }

    # debug
    if ( $Self->{Debug} > 0 ) {
        print "New Ticket created!\n";
        print "TicketNumber: $NewTn\n";
        print "TicketID: $TicketID\n";
        print "Priority: $Priority\n";
        print "State: $State\n";
        print "CustomerID: $GetParam{'X-OTRS-CustomerNo'}\n";
        print "CustomerUser: $GetParam{'X-OTRS-CustomerUser'}\n";
        for my $Value (qw(Type Service SLA Lock)) {

            if ( $GetParam{ 'X-OTRS-' . $Value } ) {
                print "Type: " . $GetParam{ 'X-OTRS-' . $Value } . "\n";
            }
        }
    }

    # set pending time
    if ( $GetParam{'X-OTRS-State-PendingTime'} ) {

# You can specify absolute dates like "2010-11-20 00:00:00" or relative dates, based on the arrival time of the email.
# Use the form "+ $Number $Unit", where $Unit can be 's' (seconds), 'm' (minutes), 'h' (hours) or 'd' (days).
# Only one unit can be specified. Examples of valid settings: "+50s" (pending in 50 seconds), "+30m" (30 minutes),
# "+12d" (12 days). Note that settings like "+1d 12h" are not possible. You can specify "+36h" instead.

        my $TargetTimeStamp = $GetParam{'X-OTRS-State-PendingTime'};

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

        my $Set = $Self->{TicketObject}->TicketPendingTimeSet(
            String   => $TargetTimeStamp,
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );

        # debug
        if ( $Set && $Self->{Debug} > 0 ) {
            print "State-PendingTime: $GetParam{'X-OTRS-State-PendingTime'}\n";
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
        my $Key = 'X-OTRS-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};

        if ( $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet
                = $Self->{TicketObject}->{DynamicFieldObject}->DynamicFieldGet(
                ID => $DynamicFieldID,
                );

            $Self->{TicketObject}->{DynamicFieldBackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $TicketID,
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
    # for backward compatibility (should be removed in a future version)
    my %Values =
        (
        'X-OTRS-TicketKey'   => 'TicketFreeKey',
        'X-OTRS-TicketValue' => 'TicketFreeText',
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
                        ObjectID           => $TicketID,
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
    # for backward compatibility (should be removed in a future version)
    for my $Count ( 1 .. 6 ) {
        my $Key = 'X-OTRS-TicketTime' . $Count;
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
                        ObjectID           => $TicketID,
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

    # do article db insert
    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID         => $TicketID,
        ArticleType      => $GetParam{'X-OTRS-ArticleType'},
        SenderType       => $GetParam{'X-OTRS-SenderType'},
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
        HistoryType      => 'EmailCustomer',
        HistoryComment   => "\%\%$Comment",
        OrigHeader       => \%GetParam,
        AutoResponseType => $AutoResponseType,
        Queue            => $Queue,
    );

    # close ticket if article create failed!
    if ( !$ArticleID ) {
        $Self->{TicketObject}->TicketDelete(
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't process email with MessageID <$GetParam{'Message-ID'}>! "
                . "Please create a bug report with this email (From: $GetParam{From}, Located "
                . "under var/spool/problem-email*) on http://bugs.otrs.org/!",
        );
        return;
    }

    if ( $Param{LinkToTicketID} ) {
        my $SourceKey = $Param{LinkToTicketID};
        my $TargetKey = $TicketID;

        $Self->{LinkObject}->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $SourceKey,
            TargetObject => 'Ticket',
            TargetKey    => $TargetKey,
            Type         => 'Normal',
            State        => 'Valid',
            UserID       => $Param{InmailUserID},
        );
    }

    # debug
    if ( $Self->{Debug} > 0 ) {
        print "From: $GetParam{From}\n";
        print "ReplyTo: $GetParam{ReplyTo}\n" if ( $GetParam{ReplyTo} );
        print "To: $GetParam{To}\n";
        print "Cc: $GetParam{Cc}\n" if ( $GetParam{Cc} );
        print "Subject: $GetParam{Subject}\n";
        print "MessageID: $GetParam{'Message-ID'}\n";
        print "Queue: $Queue\n";
        print "SenderType: $GetParam{'X-OTRS-SenderType'}\n";
        print "ArticleType: $GetParam{'X-OTRS-ArticleType'}\n";
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
        my $Key = 'X-OTRS-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};
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
    # for backward compatibility (should be removed in a future version)
    %Values =
        (
        'X-OTRS-ArticleKey'   => 'ArticleFreeKey',
        'X-OTRS-ArticleValue' => 'ArticleFreeText',
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

    return $TicketID;
}

1;
