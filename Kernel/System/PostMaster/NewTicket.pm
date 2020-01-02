# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::NewTicket;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::DateTime',
    'Kernel::System::Type',
    'Kernel::System::User',
    'Kernel::System::Service',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get parser object
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(InmailUserID GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Need $Needed!",
            );
            return;
        }
    }
    my %GetParam         = %{ $Param{GetParam} };
    my $Comment          = $Param{Comment} || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # get queue id and name
    my $QueueID = $Param{QueueID} || die "need QueueID!";
    my $Queue   = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
        QueueID => $QueueID,
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get state
    my $State = $ConfigObject->Get('PostmasterDefaultState') || 'new';
    if ( $GetParam{'X-OTRS-State'} ) {

        my $StateID = $Kernel::OM->Get('Kernel::System::State')->StateLookup(
            State => $GetParam{'X-OTRS-State'},
        );

        if ($StateID) {
            $State = $GetParam{'X-OTRS-State'};
        }
        else {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "State $GetParam{'X-OTRS-State'} does not exist, falling back to $State!",
            );
        }
    }

    # get priority
    my $Priority = $ConfigObject->Get('PostmasterDefaultPriority') || '3 normal';

    if ( $GetParam{'X-OTRS-Priority'} ) {

        my $PriorityID = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
            Priority => $GetParam{'X-OTRS-Priority'},
        );

        if ($PriorityID) {
            $Priority = $GetParam{'X-OTRS-Priority'};
        }
        else {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Priority $GetParam{'X-OTRS-Priority'} does not exist, falling back to $Priority!",
            );
        }
    }

    my $TypeID;

    if ( $GetParam{'X-OTRS-Type'} ) {

        # Check if type exists
        $TypeID = $Kernel::OM->Get('Kernel::System::Type')->TypeLookup( Type => $GetParam{'X-OTRS-Type'} );

        if ( !$TypeID ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Type $GetParam{'X-OTRS-Type'} does not exist, falling back to default type.",
            );
        }
    }

    # get sender email
    my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
        Line => $GetParam{From},
    );
    for my $Address (@EmailAddresses) {
        $GetParam{SenderEmailAddress} = $Self->{ParserObject}->GetEmailAddress(
            Email => $Address,
        );
    }

    $GetParam{SenderEmailAddress} //= '';

    # get customer id (sender email) if there is no customer id given
    if ( !$GetParam{'X-OTRS-CustomerNo'} && $GetParam{'X-OTRS-CustomerUser'} ) {

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # get customer user data form X-OTRS-CustomerUser
        my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
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

            if ( $GetParam{EmailFrom} ) {

                # get customer user object
                my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

                my %List = $CustomerUserObject->CustomerSearch(
                    PostMasterSearch => lc( $GetParam{EmailFrom} ),
                );

                for my $UserLogin ( sort keys %List ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        User => $UserLogin,
                    );
                }
            }
        }

        # take CustomerID from customer backend lookup or from from field
        if ( $CustomerData{UserLogin} && !$GetParam{'X-OTRS-CustomerUser'} ) {
            $GetParam{'X-OTRS-CustomerUser'} = $CustomerData{UserLogin};

            # notice that UserLogin is from customer source backend
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Take UserLogin ($CustomerData{UserLogin}) from "
                    . "customer source backend based on ($GetParam{'EmailFrom'}).",
            );
        }
        if ( $CustomerData{UserCustomerID} && !$GetParam{'X-OTRS-CustomerNo'} ) {
            $GetParam{'X-OTRS-CustomerNo'} = $CustomerData{UserCustomerID};

            # notice that UserCustomerID is from customer source backend
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Take UserCustomerID ($CustomerData{UserCustomerID})"
                    . " from customer source backend based on ($GetParam{'EmailFrom'}).",
            );
        }
    }

    # if there is no customer id found!
    if (
        !$GetParam{'X-OTRS-CustomerNo'}
        && $ConfigObject->Get('PostMaster::NewTicket::AutoAssignCustomerIDForUnknownCustomers')
        )
    {
        $GetParam{'X-OTRS-CustomerNo'} = $GetParam{SenderEmailAddress};
    }

    # if there is no customer user found!
    if ( !$GetParam{'X-OTRS-CustomerUser'} ) {
        $GetParam{'X-OTRS-CustomerUser'} = $GetParam{SenderEmailAddress};
    }

    # get ticket owner
    my $OwnerID = $GetParam{'X-OTRS-OwnerID'} || $Param{InmailUserID};
    if ( $GetParam{'X-OTRS-Owner'} ) {

        my $TmpOwnerID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $GetParam{'X-OTRS-Owner'},
        );

        $OwnerID = $TmpOwnerID || $OwnerID;
    }

    my %Opts;
    if ( $GetParam{'X-OTRS-ResponsibleID'} ) {
        $Opts{ResponsibleID} = $GetParam{'X-OTRS-ResponsibleID'};
    }

    if ( $GetParam{'X-OTRS-Responsible'} ) {

        my $TmpResponsibleID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $GetParam{'X-OTRS-Responsible'},
        );

        $Opts{ResponsibleID} = $TmpResponsibleID || $Opts{ResponsibleID};
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::NewTicket',
        Value         => "Going to create new ticket.",
    );

    if ( $GetParam{'X-OTRS-Service'} ) {
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        # Check if service exists.
        my %ServiceData = $ServiceObject->ServiceGet(
            Name   => $GetParam{'X-OTRS-Service'},
            UserID => $Param{InmailUserID},
        );

        # Get all service list filtering by KeepChildren SysConfig if available.
        my %ServiceList = $ServiceObject->ServiceList(
            Valid        => 1,
            KeepChildren => $ConfigObject->Get('Ticket::Service::KeepChildren') // 0,
            UserID       => $Param{InmailUserID},
        );

        if ( $ServiceData{ServiceID} ne '' && !$ServiceList{ $ServiceData{ServiceID} } ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value =>
                    "Service $GetParam{'X-OTRS-Service'} does not exists or is invalid or is a child of invalid service.",
            );
            $GetParam{'X-OTRS-Service'} = '';
        }
    }

    # create new ticket
    my $NewTn    = $TicketObject->TicketCreateNumber();
    my $TicketID = $TicketObject->TicketCreate(
        TN           => $NewTn,
        Title        => $GetParam{'X-OTRS-Title'} || $GetParam{Subject},
        QueueID      => $QueueID,
        Lock         => $GetParam{'X-OTRS-Lock'} || 'unlock',
        Priority     => $Priority,
        State        => $State,
        TypeID       => $TypeID,
        Service      => $GetParam{'X-OTRS-Service'} || '',
        SLA          => $GetParam{'X-OTRS-SLA'} || '',
        CustomerID   => $GetParam{'X-OTRS-CustomerNo'},
        CustomerUser => $GetParam{'X-OTRS-CustomerUser'},
        OwnerID      => $OwnerID,
        UserID       => $Param{InmailUserID},
        %Opts,
    );

    if ( !$TicketID ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "Ticket could not be created!",
        );
        return;
    }

    my $TicketCreateMessage = <<"Message";
New Ticket created:

TicketNumber: $NewTn
TicketID: $TicketID
Priority: $Priority
State: $State
CustomerID: $GetParam{'X-OTRS-CustomerNo'}
CustomerUser: $GetParam{'X-OTRS-CustomerUser'}

Message

    for my $Value (qw(Type Service SLA Lock)) {

        if ( $GetParam{ 'X-OTRS-' . $Value } ) {
            $TicketCreateMessage .= "$Value: " . $GetParam{ 'X-OTRS-' . $Value } . "\n";
        }
    }

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::NewTicket',
        Value         => $TicketCreateMessage,
    );

    # set pending time
    if ( $GetParam{'X-OTRS-State-PendingTime'} ) {

  # You can specify absolute dates like "2010-11-20 00:00:00" or relative dates, based on the arrival time of the email.
  # Use the form "+ $Number $Unit", where $Unit can be 's' (seconds), 'm' (minutes), 'h' (hours) or 'd' (days).
  # Only one unit can be specified. Examples of valid settings: "+50s" (pending in 50 seconds), "+30m" (30 minutes),
  # "+12d" (12 days). Note that settings like "+1d 12h" are not possible. You can specify "+36h" instead.

        my $TargetTimeStamp = $GetParam{'X-OTRS-State-PendingTime'};

        my ( $Sign, $Number, $Unit ) = $TargetTimeStamp =~ m{^\s*([+-]?)\s*(\d+)\s*([smhd]?)\s*$}smx;

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

            # get datetime object
            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            $DateTimeObject->Add( Seconds => $Seconds );
            $TargetTimeStamp = $DateTimeObject->ToString();
        }

        my $Set = $TicketObject->TicketPendingTimeSet(
            String   => $TargetTimeStamp,
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value =>
                "Pending time update via 'X-OTRS-State-PendingTime'! State-PendingTime: $GetParam{'X-OTRS-State-PendingTime'}.",
        );
    }

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # dynamic fields
    my $DynamicFieldList =
        $DynamicFieldObject->DynamicFieldList(
        Valid      => 1,
        ResultType => 'HASH',
        ObjectType => 'Ticket',
        );

    # set dynamic fields for Ticket object type
    DYNAMICFIELDID:
    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        next DYNAMICFIELDID if !$DynamicFieldID;
        next DYNAMICFIELDID if !$DynamicFieldList->{$DynamicFieldID};
        my $Key = 'X-OTRS-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};

        if ( defined $GetParam{$Key} && length $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFieldID,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $TicketID,
                Value              => $GetParam{$Key},
                UserID             => $Param{InmailUserID},
            );

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "DynamicField update via '$Key'! Value: $GetParam{$Key}.",
            );
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
            if (
                defined $GetParam{$Key}
                && length $GetParam{$Key}
                && $DynamicFieldListReversed{ $Values{$Item} . $Count }
                )
            {
                # get dynamic field config
                my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ $Values{$Item} . $Count },
                );
                if ($DynamicFieldGet) {
                    my $Success = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $TicketID,
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::NewTicket',
                    Value         => "DynamicField (TicketKey$Count) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    # set ticket free time
    # for backward compatibility (should be removed in a future version)
    for my $Count ( 1 .. 6 ) {

        my $Key = 'X-OTRS-TicketTime' . $Count;

        if ( defined $GetParam{$Key} && length $GetParam{$Key} ) {

            # get datetime object
            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $GetParam{$Key}
                }
            );

            if ( $DateTimeObject && $DynamicFieldListReversed{ 'TicketFreeTime' . $Count } ) {

                # get dynamic field config
                my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ 'TicketFreeTime' . $Count },
                );

                if ($DynamicFieldGet) {
                    my $Success = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $TicketID,
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::NewTicket',
                    Value         => "DynamicField (TicketTime$Count) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel(
        ChannelName => 'Email',
    );

    my $IsVisibleForCustomer = 1;
    if ( length $GetParam{'X-OTRS-IsVisibleForCustomer'} ) {
        $IsVisibleForCustomer = $GetParam{'X-OTRS-IsVisibleForCustomer'};
    }

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::NewTicket',
        Value         => "Going to create new article for TicketID '$TicketID'.",
    );

    # Check if X-OTRS-SenderType exists, if not set default 'customer'.
    if ( !$ArticleObject->ArticleSenderTypeLookup( SenderType => $GetParam{'X-OTRS-SenderType'} ) )
    {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "Can't find valid SenderType '$GetParam{'X-OTRS-SenderType'}' in DB, take 'customer'",
        );
        $GetParam{'X-OTRS-SenderType'} = 'customer';
    }

    # Create email article.
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => $GetParam{'X-OTRS-SenderType'},
        IsVisibleForCustomer => $IsVisibleForCustomer,
        From                 => $GetParam{From},
        ReplyTo              => $GetParam{ReplyTo},
        To                   => $GetParam{To},
        Cc                   => $GetParam{Cc},
        Subject              => $GetParam{Subject},
        MessageID            => $GetParam{'Message-ID'},
        InReplyTo            => $GetParam{'In-Reply-To'},
        References           => $GetParam{'References'},
        ContentType          => $GetParam{'Content-Type'},
        ContentDisposition   => $GetParam{'Content-Disposition'},
        Body                 => $GetParam{Body},
        UserID               => $Param{InmailUserID},
        HistoryType          => 'EmailCustomer',
        HistoryComment       => "\%\%$Comment",
        OrigHeader           => \%GetParam,
        AutoResponseType     => $AutoResponseType,
        Queue                => $Queue,
    );

    # close ticket if article create failed!
    if ( !$ArticleID ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "Can't process email with MessageID <$GetParam{'Message-ID'}>! "
                . "Please create a bug report with this email (From: $GetParam{From}, Located "
                . "under var/spool/problem-email*) on http://bugs.otrs.org/!",
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "TicketID '$TicketID' will be deleted again!",
        );

        $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );
        return;
    }

    $Self->{CommunicationLogObject}->ObjectLookupSet(
        ObjectLogType    => 'Message',
        TargetObjectType => 'Article',
        TargetObjectID   => $ArticleID,
    );

    if ( $Param{LinkToTicketID} ) {

        my $SourceKey = $Param{LinkToTicketID};
        my $TargetKey = $TicketID;

        $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $SourceKey,
            TargetObject => 'Ticket',
            TargetKey    => $TargetKey,
            Type         => 'Normal',
            State        => 'Valid',
            UserID       => $Param{InmailUserID},
        );
    }

    my %CommunicationLogSkipAttributes = (
        Body       => 1,
        Attachment => 1,
    );

    ATTRIBUTE:
    for my $Attribute ( sort keys %GetParam ) {
        next ATTRIBUTE if $CommunicationLogSkipAttributes{$Attribute};

        my $Value = $GetParam{$Attribute};
        next ATTRIBUTE if !( defined $Value ) || !( length $Value );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "$Attribute: $Value",
        );
    }

    # dynamic fields
    $DynamicFieldList =
        $DynamicFieldObject->DynamicFieldList(
        Valid      => 1,
        ResultType => 'HASH',
        ObjectType => 'Article',
        );

    # set dynamic fields for Article object type
    DYNAMICFIELDID:
    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        next DYNAMICFIELDID if !$DynamicFieldID;
        next DYNAMICFIELDID if !$DynamicFieldList->{$DynamicFieldID};
        my $Key = 'X-OTRS-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};
        if ( defined $GetParam{$Key} && length $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFieldID,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $ArticleID,
                Value              => $GetParam{$Key},
                UserID             => $Param{InmailUserID},
            );

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Article DynamicField update via '$Key'! Value: $GetParam{$Key}.",
            );
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
            if (
                defined $GetParam{$Key}
                && length $GetParam{$Key}
                && $DynamicFieldListReversed{ $Values{$Item} . $Count }
                )
            {
                # get dynamic field config
                my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ $Values{$Item} . $Count },
                );
                if ($DynamicFieldGet) {
                    my $Success = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $ArticleID,
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::NewTicket',
                    Value         => "Article DynamicField (ArticleKey) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    # write plain email to the storage
    $ArticleBackendObject->ArticleWritePlain(
        ArticleID => $ArticleID,
        Email     => $Self->{ParserObject}->GetPlainEmail(),
        UserID    => $Param{InmailUserID},
    );

    # write attachments to the storage
    for my $Attachment ( $Self->{ParserObject}->GetAttachments() ) {
        $ArticleBackendObject->ArticleWriteAttachment(
            Filename           => $Attachment->{Filename},
            Content            => $Attachment->{Content},
            ContentType        => $Attachment->{ContentType},
            ContentID          => $Attachment->{ContentID},
            ContentAlternative => $Attachment->{ContentAlternative},
            Disposition        => $Attachment->{Disposition},
            ArticleID          => $ArticleID,
            UserID             => $Param{InmailUserID},
        );
    }

    return $TicketID;
}

1;
