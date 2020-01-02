# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketUpdate;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

use parent qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::Ticket::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketUpdate - GenericInterface Ticket TicketUpdate Operation backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw( DebuggerObject WebserviceID )) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{Config}    = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::TicketUpdate');
    $Self->{Operation} = $Param{Operation};

    return $Self;
}

=head2 Run()

perform TicketUpdate Operation. This will return the updated TicketID and
if applicable the created ArticleID.

    my $Result = $OperationObject->Run(
        Data => {
            UserLogin         => 'some agent login',                            # UserLogin or CustomerUserLogin or SessionID is
                                                                                #   required
            CustomerUserLogin => 'some customer login',
            SessionID         => 123,

            Password  => 'some password',                                       # if UserLogin or customerUserLogin is sent then
                                                                                #   Password is required

            TicketID     => 123,                                                # TicketID or TicketNumber is required
            TicketNumber => '2004040510440485',

            Ticket {                                                            # optional
                Title      => 'some ticket title',

                QueueID       => 123,                                           # Optional
                Queue         => 'some queue name',                             # Optional
                LockID        => 123,                                           # optional
                Lock          => 'some lock name',                              # optional
                TypeID        => 123,                                           # optional
                Type          => 'some type name',                              # optional
                ServiceID     => 123,                                           # optional
                Service       => 'some service name',                           # optional
                SLAID         => 123,                                           # optional
                SLA           => 'some SLA name',                               # optional
                StateID       => 123,                                           # optional
                State         => 'some state name',                             # optional
                PriorityID    => 123,                                           # optional
                Priority      => 'some priority name',                          # optional
                OwnerID       => 123,                                           # optional
                Owner         => 'some user login',                             # optional
                ResponsibleID => 123,                                           # optional
                Responsible   => 'some user login',                             # optional
                CustomerUser  => 'some customer user login',

                PendingTime {       # optional
                    Year   => 2011,
                    Month  => 12
                    Day    => 03,
                    Hour   => 23,
                    Minute => 05,
                },
                # or
                # PendingTime {
                #     Diff => 10080, # Pending time in minutes
                #},
            },
            Article => {                                                          # optional
                CommunicationChannel            => 'Email',                    # CommunicationChannel or CommunicationChannelID must be provided.
                CommunicationChannelID          => 1,
                IsVisibleForCustomer            => 1,                          # optional
                SenderTypeID                    => 123,                        # optional
                SenderType                      => 'some sender type name',    # optional
                AutoResponseType                => 'some auto response type',  # optional
                From                            => 'some from string',         # optional
                Subject                         => 'some subject',
                Body                            => 'some body',

                ContentType                     => 'some content type',        # ContentType or MimeType and Charset is required
                MimeType                        => 'some mime type',
                Charset                         => 'some charset',

                HistoryType                     => 'some history type',        # optional
                HistoryComment                  => 'Some  history comment',    # optional
                TimeUnit                        => 123,                        # optional
                NoAgentNotify                   => 1,                          # optional
                ForceNotificationToUserID       => [1, 2, 3]                   # optional
                ExcludeNotificationToUserID     => [1, 2, 3]                   # optional
                ExcludeMuteNotificationToUserID => [1, 2, 3]                   # optional
            },

            DynamicField => [                                                  # optional
                {
                    Name   => 'some name',
                    Value  => $Value,                                          # value type depends on the dynamic field
                },
                # ...
            ],
            # or
            # DynamicField {
            #    Name   => 'some name',
            #    Value  => $Value,
            #},

            Attachment [
                {
                    Content     => 'content'                                 # base64 encoded
                    ContentType => 'some content type'
                    Filename    => 'some fine name'
                },
                # ...
            ],
            #or
            #Attachment {
            #    Content     => 'content'
            #    ContentType => 'some content type'
            #    Filename    => 'some fine name'
            #},
        },
    );

    $Result = {
        Success         => 1,                       # 0 or 1
        ErrorMessage    => '',                      # in case of error
        Data            => {                        # result data payload after Operation
            TicketID    => 123,                     # Ticket  ID number in OTRS (help desk system)
            ArticleID   => 43,                      # Article ID number in OTRS (help desk system)
            Error => {                              # should not return errors
                    ErrorCode    => 'TicketUpdate.ErrorCode'
                    ErrorMessage => 'Error Description'
            },

            # If IncludeTicketData is enabled
            Ticket => [
                {
                    TicketNumber       => '20101027000001',
                    Title              => 'some title',
                    TicketID           => 123,
                    State              => 'some state',
                    StateID            => 123,
                    StateType          => 'some state type',
                    Priority           => 'some priority',
                    PriorityID         => 123,
                    Lock               => 'lock',
                    LockID             => 123,
                    Queue              => 'some queue',
                    QueueID            => 123,
                    CustomerID         => 'customer_id_123',
                    CustomerUserID     => 'customer_user_id_123',
                    Owner              => 'some_owner_login',
                    OwnerID            => 123,
                    Type               => 'some ticket type',
                    TypeID             => 123,
                    SLA                => 'some sla',
                    SLAID              => 123,
                    Service            => 'some service',
                    ServiceID          => 123,
                    Responsible        => 'some_responsible_login',
                    ResponsibleID      => 123,
                    Age                => 3456,
                    Created            => '2010-10-27 20:15:00'
                    CreateBy           => 123,
                    Changed            => '2010-10-27 20:15:15',
                    ChangeBy           => 123,
                    ArchiveFlag        => 'y',

                    DynamicField => [
                        {
                            Name  => 'some name',
                            Value => 'some value',
                        },
                    ],

                    # (time stamps of expected escalations)
                    EscalationResponseTime           (unix time stamp of response time escalation)
                    EscalationUpdateTime             (unix time stamp of update time escalation)
                    EscalationSolutionTime           (unix time stamp of solution time escalation)

                    # (general escalation info of nearest escalation type)
                    EscalationDestinationIn          (escalation in e. g. 1h 4m)
                    EscalationDestinationTime        (date of escalation in unix time, e. g. 72193292)
                    EscalationDestinationDate        (date of escalation, e. g. "2009-02-14 18:00:00")
                    EscalationTimeWorkingTime        (seconds of working/service time till escalation, e. g. "1800")
                    EscalationTime                   (seconds total till escalation of nearest escalation time type - response, update or solution time, e. g. "3600")

                    # (detailed escalation info about first response, update and solution time)
                    FirstResponseTimeEscalation      (if true, ticket is escalated)
                    FirstResponseTimeNotification    (if true, notify - x% of escalation has reached)
                    FirstResponseTimeDestinationTime (date of escalation in unix time, e. g. 72193292)
                    FirstResponseTimeDestinationDate (date of escalation, e. g. "2009-02-14 18:00:00")
                    FirstResponseTimeWorkingTime     (seconds of working/service time till escalation, e. g. "1800")
                    FirstResponseTime                (seconds total till escalation, e. g. "3600")

                    UpdateTimeEscalation             (if true, ticket is escalated)
                    UpdateTimeNotification           (if true, notify - x% of escalation has reached)
                    UpdateTimeDestinationTime        (date of escalation in unix time, e. g. 72193292)
                    UpdateTimeDestinationDate        (date of escalation, e. g. "2009-02-14 18:00:00")
                    UpdateTimeWorkingTime            (seconds of working/service time till escalation, e. g. "1800")
                    UpdateTime                       (seconds total till escalation, e. g. "3600")

                    SolutionTimeEscalation           (if true, ticket is escalated)
                    SolutionTimeNotification         (if true, notify - x% of escalation has reached)
                    SolutionTimeDestinationTime      (date of escalation in unix time, e. g. 72193292)
                    SolutionTimeDestinationDate      (date of escalation, e. g. "2009-02-14 18:00:00")
                    SolutionTimeWorkingTime          (seconds of working/service time till escalation, e. g. "1800")
                    SolutionTime                     (seconds total till escalation, e. g. "3600")

                    Article => [
                        {
                            ArticleID
                            From
                            To
                            Cc
                            Subject
                            Body
                            ReplyTo
                            MessageID
                            InReplyTo
                            References
                            SenderType
                            SenderTypeID
                            CommunicationChannelID
                            IsVisibleForCustomer
                            ContentType
                            Charset
                            MimeType
                            IncomingTime

                            DynamicField => [
                                {
                                    Name  => 'some name',
                                    Value => 'some value',
                                },
                            ],

                            Attachment => [
                                {
                                    Content            => "xxxx",     # actual attachment contents, base64 enconded
                                    ContentAlternative => "",
                                    ContentID          => "",
                                    ContentType        => "application/pdf",
                                    Filename           => "StdAttachment-Test1.pdf",
                                    Filesize           => "4.6 KBytes",
                                    FilesizeRaw        => 4722,
                                },
                            ],
                        },
                    ],
                },
            ],
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Result = $Self->Init(
        WebserviceID => $Self->{WebserviceID},
    );

    if ( !$Result->{Success} ) {
        $Self->ReturnError(
            ErrorCode    => 'Webservice.InvalidConfiguration',
            ErrorMessage => $Result->{ErrorMessage},
        );
    }

    # check needed stuff
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketUpdate.EmptyRequest',
            ErrorMessage => "TicketUpdate: The request data is invalid!",
        );
    }

    if ( !$Param{Data}->{TicketID} && !$Param{Data}->{TicketNumber} ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: TicketID or TicketNumber is required!",
        );
    }

    if (
        !$Param{Data}->{UserLogin}
        && !$Param{Data}->{CustomerUserLogin}
        && !$Param{Data}->{SessionID}
        )
    {
        return $Self->ReturnError(
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: UserLogin, CustomerUserLogin or SessionID is required!",
        );
    }

    if ( $Param{Data}->{UserLogin} || $Param{Data}->{CustomerUserLogin} ) {

        if ( !$Param{Data}->{Password} )
        {
            return $Self->ReturnError(
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: Password or SessionID is required!",
            );
        }
    }

    # authenticate user
    my ( $UserID, $UserType ) = $Self->Auth(%Param);

    if ( !$UserID ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketUpdate.AuthFail',
            ErrorMessage => "TicketUpdate: User could not be authenticated!",
        );
    }

    my $PermissionUserID = $UserID;

    if ( $UserType eq 'Customer' ) {
        $UserID = $Kernel::OM->Get('Kernel::Config')->Get('CustomerPanelUserID');
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check TicketID
    my $TicketID;
    if ( $Param{Data}->{TicketNumber} ) {
        $TicketID = $TicketObject->TicketIDLookup(
            TicketNumber => $Param{Data}->{TicketNumber},
            UserID       => $UserID,
        );

    }
    else {
        $TicketID = $Param{Data}->{TicketID};
    }

    if ( !($TicketID) ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketUpdate.AccessDenied',
            ErrorMessage => "TicketUpdate: User does not have access to the ticket!",
        );
    }

    my %TicketData = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $UserID,
    );

    if ( !IsHashRefWithData( \%TicketData ) ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketUpdate.AccessDenied',
            ErrorMessage => "TicketUpdate: User does not have access to the ticket!",
        );
    }

    # check basic needed permissions
    my $Access = $Self->CheckAccessPermissions(
        TicketID => $TicketID,
        UserID   => $PermissionUserID,
        UserType => $UserType,
    );

    if ( !$Access ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketUpdate.AccessDenied',
            ErrorMessage => "TicketUpdate: User does not have access to the ticket!",
        );
    }

    # check optional hashes
    for my $Optional (qw(Ticket Article)) {
        if (
            defined $Param{Data}->{$Optional}
            && !IsHashRefWithData( $Param{Data}->{$Optional} )
            )
        {
            return $Self->ReturnError(
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: $Optional parameter is not valid!",
            );
        }
    }

    # check optional array/hashes
    for my $Optional (qw(DynamicField Attachment)) {
        if (
            defined $Param{Data}->{$Optional}
            && !IsHashRefWithData( $Param{Data}->{$Optional} )
            && !IsArrayRefWithData( $Param{Data}->{$Optional} )
            )
        {
            return $Self->ReturnError(
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: $Optional parameter is missing or not valid!",
            );
        }
    }

    my $Ticket;
    if ( defined $Param{Data}->{Ticket} ) {

        # isolate ticket parameter
        $Ticket = $Param{Data}->{Ticket};

        $Ticket->{UserID} = $UserID;

        # remove leading and trailing spaces
        for my $Attribute ( sort keys %{$Ticket} ) {
            if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                #remove leading spaces
                $Ticket->{$Attribute} =~ s{\A\s+}{};

                #remove trailing spaces
                $Ticket->{$Attribute} =~ s{\s+\z}{};
            }
        }
        if ( IsHashRefWithData( $Ticket->{PendingTime} ) ) {
            for my $Attribute ( sort keys %{ $Ticket->{PendingTime} } ) {
                if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                    #remove leading spaces
                    $Ticket->{PendingTime}->{$Attribute} =~ s{\A\s+}{};

                    #remove trailing spaces
                    $Ticket->{PendingTime}->{$Attribute} =~ s{\s+\z}{};
                }
            }
        }

        # check Ticket attribute values
        my $TicketCheck = $Self->_CheckTicket(
            Ticket    => $Ticket,
            OldTicket => \%TicketData,
        );

        if ( !$TicketCheck->{Success} ) {
            return $Self->ReturnError( %{$TicketCheck} );
        }
    }

    my $Article;
    if ( defined $Param{Data}->{Article} ) {

        $Article = $Param{Data}->{Article};
        $Article->{UserType} = $UserType;

        # remove leading and trailing spaces
        for my $Attribute ( sort keys %{$Article} ) {
            if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                #remove leading spaces
                $Article->{$Attribute} =~ s{\A\s+}{};

                #remove trailing spaces
                $Article->{$Attribute} =~ s{\s+\z}{};
            }
        }
        if ( IsHashRefWithData( $Article->{OrigHeader} ) ) {
            for my $Attribute ( sort keys %{ $Article->{OrigHeader} } ) {
                if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                    #remove leading spaces
                    $Article->{OrigHeader}->{$Attribute} =~ s{\A\s+}{};

                    #remove trailing spaces
                    $Article->{OrigHeader}->{$Attribute} =~ s{\s+\z}{};
                }
            }
        }

        # Check attributes that can be set by sysconfig.
        if ( !$Article->{AutoResponseType} ) {
            $Article->{AutoResponseType} = $Self->{Config}->{AutoResponseType} || '';
        }

        # TODO: GenericInterface::Operation::TicketUpdate###CommunicationChannel
        if ( !$Article->{CommunicationChannelID} && !$Article->{CommunicationChannel} ) {
            $Article->{CommunicationChannel} = 'Internal';
        }
        if ( !defined $Article->{IsVisibleForCustomer} ) {
            $Article->{IsVisibleForCustomer} = $Self->{Config}->{IsVisibleForCustomer} // 1;
        }
        if ( !$Article->{SenderTypeID} && !$Article->{SenderType} ) {
            $Article->{SenderType} = $UserType eq 'User' ? 'agent' : 'customer';
        }
        if ( !$Article->{HistoryType} ) {
            $Article->{HistoryType} = $Self->{Config}->{HistoryType} || '';
        }
        if ( !$Article->{HistoryComment} ) {
            $Article->{HistoryComment} = $Self->{Config}->{HistoryComment} || '';
        }

        # check Article attribute values
        my $ArticleCheck = $Self->_CheckArticle( Article => $Article );

        if ( !$ArticleCheck->{Success} ) {
            if ( !$ArticleCheck->{ErrorCode} ) {
                return {
                    Success => 0,
                    %{$ArticleCheck},
                };
            }
            return $Self->ReturnError( %{$ArticleCheck} );
        }
    }

    my $DynamicField;
    my @DynamicFieldList;
    if ( defined $Param{Data}->{DynamicField} ) {

        # isolate DynamicField parameter
        $DynamicField = $Param{Data}->{DynamicField};

        # homogenate input to array
        if ( ref $DynamicField eq 'HASH' ) {
            push @DynamicFieldList, $DynamicField;
        }
        else {
            @DynamicFieldList = @{$DynamicField};
        }

        # check DynamicField internal structure
        for my $DynamicFieldItem (@DynamicFieldList) {
            if ( !IsHashRefWithData($DynamicFieldItem) ) {
                return {
                    ErrorCode => 'TicketUpdate.InvalidParameter',
                    ErrorMessage =>
                        "TicketUpdate: Ticket->DynamicField parameter is invalid!",
                };
            }

            # remove leading and trailing spaces
            for my $Attribute ( sort keys %{$DynamicFieldItem} ) {
                if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                    #remove leading spaces
                    $DynamicFieldItem->{$Attribute} =~ s{\A\s+}{};

                    #remove trailing spaces
                    $DynamicFieldItem->{$Attribute} =~ s{\s+\z}{};
                }
            }

            # check DynamicField attribute values
            my $DynamicFieldCheck = $Self->_CheckDynamicField(
                DynamicField => $DynamicFieldItem,
                Article      => $Article,
            );

            if ( !$DynamicFieldCheck->{Success} ) {
                return $Self->ReturnError( %{$DynamicFieldCheck} );
            }
        }
    }

    my $Attachment;
    my @AttachmentList;
    if ( defined $Param{Data}->{Attachment} ) {

        # isolate Attachment parameter
        $Attachment = $Param{Data}->{Attachment};

        # homogenate input to array
        if ( ref $Attachment eq 'HASH' ) {
            push @AttachmentList, $Attachment;
        }
        else {
            @AttachmentList = @{$Attachment};
        }

        # check Attachment internal structure
        for my $AttachmentItem (@AttachmentList) {
            if ( !IsHashRefWithData($AttachmentItem) ) {
                return {
                    ErrorCode => 'TicketUpdate.InvalidParameter',
                    ErrorMessage =>
                        "TicketUpdate: Ticket->Attachment parameter is invalid!",
                };
            }

            # remove leading and trailing spaces
            for my $Attribute ( sort keys %{$AttachmentItem} ) {
                if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                    #remove leading spaces
                    $AttachmentItem->{$Attribute} =~ s{\A\s+}{};

                    #remove trailing spaces
                    $AttachmentItem->{$Attribute} =~ s{\s+\z}{};
                }
            }

            # check Attachment attribute values
            my $AttachmentCheck = $Self->_CheckAttachment(
                Attachment => $AttachmentItem,
                Article    => $Article,
            );

            if ( !$AttachmentCheck->{Success} ) {
                return $Self->ReturnError( %{$AttachmentCheck} );
            }
        }
    }

    return $Self->_TicketUpdate(
        TicketID         => $TicketID,
        Ticket           => $Ticket,
        Article          => $Article,
        DynamicFieldList => \@DynamicFieldList,
        AttachmentList   => \@AttachmentList,
        UserID           => $UserID,
        UserType         => $UserType,
    );
}

=begin Internal:

=head2 _CheckTicket()

checks if the given ticket parameters are valid.

    my $TicketCheck = $OperationObject->_CheckTicket(
        Ticket => $Ticket,                          # all ticket parameters
    );

    returns:

    $TicketCheck = {
        Success => 1,                               # if everything is OK
    }

    $TicketCheck = {
        ErrorCode    => 'Function.Error',           # if error
        ErrorMessage => 'Error description',
    }

=cut

sub _CheckTicket {
    my ( $Self, %Param ) = @_;

    my $Ticket    = $Param{Ticket};
    my $OldTicket = $Param{OldTicket};

    # check Ticket->CustomerUser
    if (
        $Ticket->{CustomerUser}
        && !$Self->ValidateCustomer( %{$Ticket} )
        )
    {
        return {
            ErrorCode => 'TicketUpdate.InvalidParameter',
            ErrorMessage =>
                "TicketUpdate: Ticket->CustomerUser parameter is invalid!",
        };
    }

    # check Ticket->Queue
    if ( $Ticket->{QueueID} || $Ticket->{Queue} ) {
        if ( !$Self->ValidateQueue( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->QueueID or Ticket->Queue parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Lock
    if ( $Ticket->{LockID} || $Ticket->{Lock} ) {
        if ( !$Self->ValidateLock( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->LockID or Ticket->Lock parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Type
    if ( $Ticket->{TypeID} || $Ticket->{Type} ) {
        if ( !$Self->ValidateType( %{$Ticket} ) ) {
            return {
                ErrorCode => 'TicketUpdate.InvalidParameter',
                ErrorMessage =>
                    "TicketUpdate: Ticket->TypeID or Ticket->Type parameter is invalid!",
            };
        }
    }

    # check Ticket->Service
    if ( $Ticket->{ServiceID} || $Ticket->{Service} ) {

        # set customer user from old ticket if no new customer user is to be set
        my $CustomerUser = $Ticket->{CustomerUser} || '';
        if ( !$CustomerUser ) {
            $CustomerUser = $OldTicket->{CustomerUserID};
        }
        if (
            !$Self->ValidateService(
                %{$Ticket},
                CustomerUser => $CustomerUser,
            )
            )
        {
            return {
                ErrorCode => 'TicketUpdate.InvalidParameter',
                ErrorMessage =>
                    "TicketUpdate: Ticket->ServiceID or Ticket->Service parameter is invalid!",
            };
        }
    }

    # check Ticket->SLA
    if ( $Ticket->{SLAID} || $Ticket->{SLA} ) {

        # set ServiceID from old ticket if no new ServiceID or Service is to be set
        my $Service   = $Ticket->{Service}   || '';
        my $ServiceID = $Ticket->{ServiceID} || '';
        if ( !$ServiceID && !$Service ) {
            $ServiceID = $OldTicket->{ServiceID};
        }

        if (
            !$Self->ValidateSLA(
                %{$Ticket},
                Service   => $Service,
                ServiceID => $ServiceID,
            )
            )
        {
            return {
                ErrorCode => 'TicketUpdate.InvalidParameter',
                ErrorMessage =>
                    "TicketUpdate: Ticket->SLAID or Ticket->SLA parameter is invalid!",
            };
        }
    }

    # check Ticket->State
    if ( $Ticket->{StateID} || $Ticket->{State} ) {
        if ( !$Self->ValidateState( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->StateID or Ticket->State parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Priority
    if ( $Ticket->{PriorityID} || $Ticket->{Priority} ) {
        if ( !$Self->ValidatePriority( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->PriorityID or Ticket->Priority parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Owner
    if ( $Ticket->{OwnerID} || $Ticket->{Owner} ) {
        if ( !$Self->ValidateOwner( %{$Ticket} ) ) {
            return {
                ErrorCode => 'TicketUpdate.InvalidParameter',
                ErrorMessage =>
                    "TicketUpdate: Ticket->OwnerID or Ticket->Owner parameter is invalid!",
            };
        }
    }

    # check Ticket->Responsible
    if ( $Ticket->{ResponsibleID} || $Ticket->{Responsible} ) {
        if ( !$Self->ValidateResponsible( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->ResponsibleID or Ticket->Responsible"
                    . " parameter is invalid!",
            };
        }
    }

    # check Ticket->PendingTime
    if ( $Ticket->{PendingTime} ) {
        if ( !$Self->ValidatePendingTime( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->PendingTime parameter is invalid!",
            };
        }
    }

    # if everything is OK then return Success
    return {
        Success => 1,
    };
}

=head2 _CheckArticle()

checks if the given article parameter is valid.

    my $ArticleCheck = $OperationObject->_CheckArticle(
        Article => $Article,                        # all article parameters
    );

    returns:

    $ArticleCheck = {
        Success => 1,                               # if everything is OK
    }

    $ArticleCheck = {
        ErrorCode    => 'Function.Error',           # if error
        ErrorMessage => 'Error description',
    }

=cut

sub _CheckArticle {
    my ( $Self, %Param ) = @_;

    my $Article = $Param{Article};

    # check ticket internally
    for my $Needed (qw(Subject Body AutoResponseType)) {
        if ( !$Article->{$Needed} ) {
            return {
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: Article->$Needed parameter is missing!",
            };
        }
    }

    # check Article->AutoResponseType
    if ( !$Article->{AutoResponseType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketUpdate: Article->AutoResponseType parameter is required and",
        };
    }

    if ( !$Self->ValidateAutoResponseType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->AutoResponseType parameter is invalid!",
        };
    }

    # check Article->CommunicationChannel
    if ( !$Article->{CommunicationChannel} && !$Article->{CommunicationChannelID} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketUpdate: Article->CommunicationChannelID or Article->CommunicationChannel parameter"
                . " is required and Sysconfig CommunicationChannelID setting could not be read!"
        };
    }
    if ( !$Self->ValidateArticleCommunicationChannel( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->CommunicationChannel or Article->CommunicationChannelID parameter"
                . " is invalid or not supported!",
        };
    }

    # check Article->SenderType
    if ( !$Article->{SenderTypeID} && !$Article->{SenderType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketUpdate: Article->SenderTypeID or Article->SenderType parameter"
                . " is required and Sysconfig SenderTypeID setting could not be read!"
        };
    }
    if ( !$Self->ValidateSenderType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->SenderTypeID or Ticket->SenderType parameter"
                . " is invalid!",
        };
    }

    # check Article->From
    if ( $Article->{From} ) {
        if ( !$Self->ValidateFrom( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Article->From parameter is invalid!",
            };
        }
    }

    # check Article->ContentType vs Article->MimeType and Article->Charset
    if ( !$Article->{ContentType} && !$Article->{MimeType} && !$Article->{Charset} ) {
        return {
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: Article->ContentType or Ticket->MimeType and"
                . " Article->Charset parameters are required!",
        };
    }

    if ( $Article->{MimeType} && !$Article->{Charset} ) {
        return {
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: Article->Charset is required!",
        };
    }

    if ( $Article->{Charset} && !$Article->{MimeType} ) {
        return {
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: Article->MimeType is required!",
        };
    }

    # check Article->MimeType
    if ( $Article->{MimeType} ) {

        $Article->{MimeType} = lc $Article->{MimeType};

        if ( !$Self->ValidateMimeType( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Article->MimeType is invalid!",
            };
        }
    }

    # check Article->MimeType
    if ( $Article->{Charset} ) {

        $Article->{Charset} = lc $Article->{Charset};

        if ( !$Self->ValidateCharset( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Article->Charset is invalid!",
            };
        }
    }

    # check Article->ContentType
    if ( $Article->{ContentType} ) {

        $Article->{ContentType} = lc $Article->{ContentType};

        # check Charset part
        my $Charset = '';
        if ( $Article->{ContentType} =~ /charset=/i ) {
            $Charset = $Article->{ContentType};
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;
        }

        if ( !$Self->ValidateCharset( Charset => $Charset ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Article->ContentType is invalid!",
            };
        }

        # check MimeType part
        my $MimeType = '';
        if ( $Article->{ContentType} =~ /^(\w+\/\w+)/i ) {
            $MimeType = $1;
            $MimeType =~ s/"|'//g;
        }

        if ( !$Self->ValidateMimeType( MimeType => $MimeType ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Article->ContentType is invalid!",
            };
        }
    }

    # check Article->HistoryType
    if ( !$Article->{HistoryType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketUpdate: Article-> HistoryType is required and Sysconfig"
                . " HistoryType setting could not be read!"
        };
    }
    if ( !$Self->ValidateHistoryType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->HistoryType parameter is invalid!",
        };
    }

    # check Article->HistoryComment
    if ( !$Article->{HistoryComment} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketUpdate: Article->HistoryComment is required and Sysconfig"
                . " HistoryComment setting could not be read!"
        };
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check Article->TimeUnit
    # TimeUnit could be required or not depending on sysconfig option
    if (
        ( !defined $Article->{TimeUnit} || !IsStringWithData( $Article->{TimeUnit} ) )
        && $ConfigObject->{'Ticket::Frontend::AccountTime'}
        && $ConfigObject->{'Ticket::Frontend::NeedAccountedTime'}
        )
    {
        return {
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: Article->TimeUnit is required by sysconfig option!",
        };
    }
    if ( $Article->{TimeUnit} ) {
        if ( !$Self->ValidateTimeUnit( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Article->TimeUnit parameter is invalid!",
            };
        }
    }

    # check Article->NoAgentNotify
    if ( $Article->{NoAgentNotify} && $Article->{NoAgentNotify} ne '1' ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->NoAgent parameter is invalid!",
        };
    }

    # check Article array parameters
    for my $Attribute (
        qw( ForceNotificationToUserID ExcludeNotificationToUserID ExcludeMuteNotificationToUserID )
        )
    {
        if ( defined $Article->{$Attribute} ) {

            # check structure
            if ( IsHashRefWithData( $Article->{$Attribute} ) ) {
                return {
                    ErrorCode    => 'TicketUpdate.InvalidParameter',
                    ErrorMessage => "TicketUpdate: Article->$Attribute parameter is invalid!",
                };
            }
            else {
                if ( !IsArrayRefWithData( $Article->{$Attribute} ) ) {
                    $Article->{$Attribute} = [ $Article->{$Attribute} ];
                }
                for my $UserID ( @{ $Article->{$Attribute} } ) {
                    if ( !$Self->ValidateUserID( UserID => $UserID ) ) {
                        return {
                            ErrorCode    => 'TicketUpdate.InvalidParameter',
                            ErrorMessage => "TicketUpdate: Article->$Attribute UserID=$UserID"
                                . " parameter is invalid!",
                        };
                    }
                }
            }
        }
    }

    # if everything is OK then return Success
    return {
        Success => 1,
    };
}

=head2 _CheckDynamicField()

checks if the given dynamic field parameter is valid.

    my $DynamicFieldCheck = $OperationObject->_CheckDynamicField(
        DynamicField => $DynamicField,              # all dynamic field parameters
    );

    returns:

    $DynamicFieldCheck = {
        Success => 1,                               # if everything is OK
    }

    $DynamicFieldCheck = {
        ErrorCode    => 'Function.Error',           # if error
        ErrorMessage => 'Error description',
    }

=cut

sub _CheckDynamicField {
    my ( $Self, %Param ) = @_;

    my $DynamicField = $Param{DynamicField};
    my $ArticleData  = $Param{Article};

    my $Article;
    if ( IsHashRefWithData($ArticleData) ) {
        $Article = 1;
    }

    # check DynamicField item internally
    for my $Needed (qw(Name Value)) {
        if (
            !defined $DynamicField->{$Needed}
            || ( !IsString( $DynamicField->{$Needed} ) && ref $DynamicField->{$Needed} ne 'ARRAY' )
            )
        {
            return {
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: DynamicField->$Needed parameter is missing!",
            };
        }
    }

    # check DynamicField->Name
    if ( !$Self->ValidateDynamicFieldName( %{$DynamicField} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: DynamicField->Name parameter is invalid!",
        };
    }

    # check objectType for dynamic field
    if (
        !$Self->ValidateDynamicFieldObjectType(
            %{$DynamicField},
            Article => $Article,
        )
        )
    {
        return {
            ErrorCode => 'TicketUpdate.MissingParameter',
            ErrorMessage =>
                "TicketUpdate: To create an article DynamicField an article is required!",
        };
    }

    # check DynamicField->Value
    if ( !$Self->ValidateDynamicFieldValue( %{$DynamicField} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: DynamicField->Value parameter is invalid!",
        };
    }

    # if everything is OK then return Success
    return {
        Success => 1,
    };
}

=head2 _CheckAttachment()

checks if the given attachment parameter is valid.

    my $AttachmentCheck = $OperationObject->_CheckAttachment(
        Attachment => $Attachment,                  # all attachment parameters
    );

    returns:

    $AttachmentCheck = {
        Success => 1,                               # if everything is OK
    }

    $AttachmentCheck = {
        ErrorCode    => 'Function.Error',           # if error
        ErrorMessage => 'Error description',
    }

=cut

sub _CheckAttachment {
    my ( $Self, %Param ) = @_;

    my $Attachment = $Param{Attachment};
    my $Article    = $Param{Article};

    # check if article is going to be created
    if ( !IsHashRefWithData($Article) ) {
        return {
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: To create an attachment an article is needed!",
        };
    }

    # check attachment item internally
    for my $Needed (qw(Content ContentType Filename)) {
        if ( !IsStringWithData( $Attachment->{$Needed} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: Attachment->$Needed parameter is missing!",
            };
        }
    }

    # check Article->ContentType
    if ( $Attachment->{ContentType} ) {

        $Attachment->{ContentType} = lc $Attachment->{ContentType};

        # check Charset part
        my $Charset = '';
        if ( $Attachment->{ContentType} =~ /charset=/i ) {
            $Charset = $Attachment->{ContentType};
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;
        }

        if ( $Charset && !$Self->ValidateCharset( Charset => $Charset ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Attachment->ContentType is invalid!",
            };
        }

        # check MimeType part
        my $MimeType = '';
        if ( $Attachment->{ContentType} =~ /^(\w+\/\w+)/i ) {
            $MimeType = $1;
            $MimeType =~ s/"|'//g;
        }

        if ( !$Self->ValidateMimeType( MimeType => $MimeType ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Attachment->ContentType is invalid!",
            };
        }
    }

    # if everything is OK then return Success
    return {
        Success => 1,
    };
}

=head2 _CheckUpdatePermissions()

check if user has permissions to update ticket attributes.

    my $Response = $OperationObject->_CheckUpdatePermissions(
        TicketID     => 123
        Ticket       => $Ticket,                  # all ticket parameters
        Article      => $Ticket,                  # all attachment parameters
        DynamicField => $Ticket,                  # all dynamic field parameters
        Attachment   => $Ticket,                  # all attachment parameters
        UserID       => 123,
    );

    returns:

    $Response = {
        Success => 1,                               # if everything is OK
    }

    $Response = {
        Success      => 0,
        ErrorCode    => "function.error",           # if error
        ErrorMessage => "Error description"
    }

=cut

sub _CheckUpdatePermissions {
    my ( $Self, %Param ) = @_;

    my $TicketID         = $Param{TicketID};
    my $Ticket           = $Param{Ticket};
    my $Article          = $Param{Article};
    my $DynamicFieldList = $Param{DynamicFieldList};
    my $AttachmentList   = $Param{AttachmentList};

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check Article permissions
    if ( IsHashRefWithData($Article) ) {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'note',
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Access ) {
            return {
                ErrorCode    => 'TicketUpdate.AccessDenied',
                ErrorMessage => "TicketUpdate: Does not have permissions to create new articles!",
            };
        }
    }

    # check dynamic field permissions
    if ( IsArrayRefWithData($DynamicFieldList) ) {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'rw',
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Access ) {
            return {
                ErrorCode    => 'TicketUpdate.AccessDenied',
                ErrorMessage => "TicketUpdate: Does not have permissions to update dynamic fields!",
            };
        }
    }

    # check queue permissions
    if ( $Ticket->{Queue} || $Ticket->{QueueID} ) {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'move',
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Access ) {
            return {
                ErrorCode    => 'TicketUpdate.AccessDenied',
                ErrorMessage => "TicketUpdate: Does not have permissions to update queue!",
            };
        }
    }

    # check owner permissions
    if ( $Ticket->{Owner} || $Ticket->{OwnerID} ) {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'owner',
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Access ) {
            return {
                ErrorCode    => 'TicketUpdate.AccessDenied',
                ErrorMessage => "TicketUpdate: Does not have permissions to update owner!",
            };
        }
    }

    # check responsible permissions
    if ( $Ticket->{Responsible} || $Ticket->{ResponsibleID} ) {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'responsible',
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Access ) {
            return {
                ErrorCode    => 'TicketUpdate.AccessDenied',
                ErrorMessage => "TicketUpdate: Does not have permissions to update responsibe!",
            };
        }
    }

    # check priority permissions
    if ( $Ticket->{Priority} || $Ticket->{PriorityID} ) {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'priority',
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Access ) {
            return {
                ErrorCode    => 'TicketUpdate.AccessDenied',
                ErrorMessage => "TicketUpdate: Does not have permissions to update priority!",
            };
        }
    }

    # check state permissions
    if ( $Ticket->{State} || $Ticket->{StateID} ) {

        # get State Data
        my %StateData;
        my $StateID;

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        if ( $Ticket->{StateID} ) {
            $StateID = $Ticket->{StateID};
        }
        else {
            $StateID = $StateObject->StateLookup(
                State => $Ticket->{State},
            );
        }

        %StateData = $StateObject->StateGet(
            ID => $StateID,
        );

        my $Access = 1;

        if ( $StateData{TypeName} =~ /^close/i ) {
            $Access = $TicketObject->TicketPermission(
                Type     => 'close',
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {
            $Access = $TicketObject->TicketPermission(
                Type     => 'close',
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        if ( !$Access ) {
            return {
                ErrorCode    => 'TicketUpdate.AccessDenied',
                ErrorMessage => "TicketUpdate: Does not have permissions to update state!",
            };
        }
    }

    return {
        Success => 1,
    };
}

=head2 _TicketUpdate()

updates a ticket and creates an article and sets dynamic fields and attachments if specified.

    my $Response = $OperationObject->_TicketUpdate(
        TicketID     => 123
        Ticket       => $Ticket,                  # all ticket parameters
        Article      => $Article,                 # all attachment parameters
        DynamicField => $DynamicField,            # all dynamic field parameters
        Attachment   => $Attachment,              # all attachment parameters
        UserID       => 123,
        UserType     => 'Agent'                   # || 'Customer
    );

    returns:

    $Response = {
        Success => 1,                               # if everything is OK
        Data => {
            TicketID     => 123,
            TicketNumber => 'TN3422332',
            ArticleID    => 123,                    # if new article was created
        }
    }

    $Response = {
        Success      => 0,                         # if unexpected error
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
    }

=cut

sub _TicketUpdate {
    my ( $Self, %Param ) = @_;

    my $TicketID         = $Param{TicketID};
    my $Ticket           = $Param{Ticket};
    my $Article          = $Param{Article};
    my $DynamicFieldList = $Param{DynamicFieldList};
    my $AttachmentList   = $Param{AttachmentList};

    my $Access = $Self->_CheckUpdatePermissions(%Param);

    # if no permissions return error
    if ( !$Access->{Success} ) {
        return $Self->ReturnError( %{$Access} );
    }

    my %CustomerUserData;

    # get customer information
    if ( $Ticket->{CustomerUser} ) {
        %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Ticket->{CustomerUser},
        );
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get current ticket data
    my %TicketData = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $Param{UserID},
    );

    # update ticket parameters
    # update Ticket->Title
    if (
        defined $Ticket->{Title}
        && $Ticket->{Title} ne ''
        && $Ticket->{Title} ne $TicketData{Title}
        )
    {
        my $Success = $TicketObject->TicketTitleUpdate(
            Title    => $Ticket->{Title},
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket title could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->Queue
    if ( $Ticket->{Queue} || $Ticket->{QueueID} ) {
        my $Success;
        if ( defined $Ticket->{Queue} && $Ticket->{Queue} ne $TicketData{Queue} ) {
            $Success = $TicketObject->TicketQueueSet(
                Queue    => $Ticket->{Queue},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{QueueID} && $Ticket->{QueueID} ne $TicketData{QueueID} ) {
            $Success = $TicketObject->TicketQueueSet(
                QueueID  => $Ticket->{QueueID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                ErrorMessage =>
                    'Ticket queue could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->Lock
    if ( $Ticket->{Lock} || $Ticket->{LockID} ) {
        my $Success;
        if ( defined $Ticket->{Lock} && $Ticket->{Lock} ne $TicketData{Lock} ) {
            $Success = $TicketObject->TicketLockSet(
                Lock     => $Ticket->{Lock},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{LockID} && $Ticket->{LockID} ne $TicketData{LockID} ) {
            $Success = $TicketObject->TicketLockSet(
                LockID   => $Ticket->{LockID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket lock could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->Type
    if ( $Ticket->{Type} || $Ticket->{TypeID} ) {
        my $Success;
        if ( defined $Ticket->{Type} && $Ticket->{Type} ne $TicketData{Type} ) {
            $Success = $TicketObject->TicketTypeSet(
                Type     => $Ticket->{Type},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{TypeID} && $Ticket->{TypeID} ne $TicketData{TypeID} )
        {
            $Success = $TicketObject->TicketTypeSet(
                TypeID   => $Ticket->{TypeID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket type could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket>State
    # depending on the state, might require to unlock ticket or enables pending time set
    if ( $Ticket->{State} || $Ticket->{StateID} ) {

        # get State Data
        my %StateData;
        my $StateID;

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        if ( $Ticket->{StateID} ) {
            $StateID = $Ticket->{StateID};
        }
        else {
            $StateID = $StateObject->StateLookup(
                State => $Ticket->{State},
            );
        }

        %StateData = $StateObject->StateGet(
            ID => $StateID,
        );

        # force unlock if state type is close
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Param{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            if ( defined $Ticket->{PendingTime} ) {
                my $Success = $TicketObject->TicketPendingTimeSet(
                    UserID   => $Param{UserID},
                    TicketID => $TicketID,
                    %{ $Ticket->{PendingTime} },
                );

                if ( !$Success ) {
                    return {
                        Success => 0,
                        Errormessage =>
                            'Ticket pendig time could not be updated, please contact system'
                            . ' administrator!',
                    };
                }
            }
            else {
                return $Self->ReturnError(
                    ErrorCode    => 'TicketUpdate.MissingParameter',
                    ErrorMessage => 'Can\'t set a ticket on a pending state without pendig time!'
                );
            }
        }

        my $Success;
        if ( defined $Ticket->{State} && $Ticket->{State} ne $TicketData{State} ) {
            $Success = $TicketObject->TicketStateSet(
                State    => $Ticket->{State},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{StateID} && $Ticket->{StateID} ne $TicketData{StateID} )
        {
            $Success = $TicketObject->TicketStateSet(
                StateID  => $Ticket->{StateID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket state could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->Service
    # this might reset SLA if current SLA is not available for the new service
    if ( $Ticket->{Service} || $Ticket->{ServiceID} ) {

        # check if ticket has a SLA assigned
        if ( $TicketData{SLAID} ) {

            # check if old SLA is still valid
            if (
                !$Self->ValidateSLA(
                    SLAID     => $TicketData{SLAID},
                    Service   => $Ticket->{Service} || '',
                    ServiceID => $Ticket->{ServiceID} || '',
                )
                )
            {

                # remove current SLA if is not compatible with new service
                my $Success = $TicketObject->TicketSLASet(
                    SLAID    => '',
                    TicketID => $TicketID,
                    UserID   => $Param{UserID},
                );
            }
        }

        my $Success;

        # prevent comparison errors on undefined values
        if ( !defined $TicketData{Service} ) {
            $TicketData{Service} = '';
        }
        if ( !defined $TicketData{ServiceID} ) {
            $TicketData{ServiceID} = '';
        }

        if ( defined $Ticket->{Service} && $Ticket->{Service} ne $TicketData{Service} ) {
            $Success = $TicketObject->TicketServiceSet(
                Service  => $Ticket->{Service},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{ServiceID} && $Ticket->{ServiceID} ne $TicketData{ServiceID} )
        {
            $Success = $TicketObject->TicketServiceSet(
                ServiceID => $Ticket->{ServiceID},
                TicketID  => $TicketID,
                UserID    => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket service could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->SLA
    if ( $Ticket->{SLA} || $Ticket->{SLAID} ) {
        my $Success;

        # prevent comparison errors on undefined values
        if ( !defined $TicketData{SLA} ) {
            $TicketData{SLA} = '';
        }
        if ( !defined $TicketData{SLAID} ) {
            $TicketData{SLAID} = '';
        }

        if ( defined $Ticket->{SLA} && $Ticket->{SLA} ne $TicketData{SLA} ) {
            $Success = $TicketObject->TicketSLASet(
                SLA      => $Ticket->{SLA},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{SLAID} && $Ticket->{SLAID} ne $TicketData{SLAID} )
        {
            $Success = $TicketObject->TicketSLASet(
                SLAID    => $Ticket->{SLAID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket SLA could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->CustomerUser && Ticket->CustomerID
    if ( $Ticket->{CustomerUser} || $Ticket->{CustomerID} ) {

        # set values to empty if they are not defined
        $TicketData{CustomerUserID} = $TicketData{CustomerUserID} || '';
        $TicketData{CustomerID}     = $TicketData{CustomerID}     || '';
        $Ticket->{CustomerUser}     = $Ticket->{CustomerUser}     || '';
        $Ticket->{CustomerID}       = $Ticket->{CustomerID}       || '';

        my $Success;
        if (
            $Ticket->{CustomerUser} ne $TicketData{CustomerUserID}
            || $Ticket->{CustomerID} ne $TicketData{CustomerID}
            )
        {
            my $CustomerID = $CustomerUserData{UserCustomerID} || '';

            # use user defined CustomerID if defined
            if ( defined $Ticket->{CustomerID} && $Ticket->{CustomerID} ne '' ) {
                $CustomerID = $Ticket->{CustomerID};
            }

            $Success = $TicketObject->TicketCustomerSet(
                No       => $CustomerID,
                User     => $Ticket->{CustomerUser},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket customer user could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->Priority
    if ( $Ticket->{Priority} || $Ticket->{PriorityID} ) {
        my $Success;
        if ( defined $Ticket->{Priority} && $Ticket->{Priority} ne $TicketData{Priority} ) {
            $Success = $TicketObject->TicketPrioritySet(
                Priority => $Ticket->{Priority},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{PriorityID} && $Ticket->{PriorityID} ne $TicketData{PriorityID} )
        {
            $Success = $TicketObject->TicketPrioritySet(
                PriorityID => $Ticket->{PriorityID},
                TicketID   => $TicketID,
                UserID     => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket priority could not be updated, please contact system administrator!',
            };
        }
    }

    my $UnlockOnAway = 1;

    # update Ticket->Owner
    if ( $Ticket->{Owner} || $Ticket->{OwnerID} ) {
        my $Success;
        if ( defined $Ticket->{Owner} && $Ticket->{Owner} ne $TicketData{Owner} ) {
            $Success = $TicketObject->TicketOwnerSet(
                NewUser  => $Ticket->{Owner},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
            $UnlockOnAway = 0;
        }
        elsif ( defined $Ticket->{OwnerID} && $Ticket->{OwnerID} ne $TicketData{OwnerID} )
        {
            $Success = $TicketObject->TicketOwnerSet(
                NewUserID => $Ticket->{OwnerID},
                TicketID  => $TicketID,
                UserID    => $Param{UserID},
            );
            $UnlockOnAway = 0;
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket owner could not be updated, please contact system administrator!',
            };
        }
    }

    # update Ticket->Responsible
    if ( $Ticket->{Responsible} || $Ticket->{ResponsibleID} ) {
        my $Success;
        if (
            defined $Ticket->{Responsible}
            && $Ticket->{Responsible} ne $TicketData{Responsible}
            )
        {
            $Success = $TicketObject->TicketResponsibleSet(
                NewUser  => $Ticket->{Responsible},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif (
            defined $Ticket->{ResponsibleID}
            && $Ticket->{ResponsibleID} ne $TicketData{ResponsibleID}
            )
        {
            $Success = $TicketObject->TicketResponsibleSet(
                NewUserID => $Ticket->{ResponsibleID},
                TicketID  => $TicketID,
                UserID    => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket responsible could not be updated, please contact system administrator!',
            };
        }
    }

    my $ArticleID;
    if ( IsHashRefWithData($Article) ) {

        # set Article From
        my $From;
        if ( $Article->{From} ) {
            $From = $Article->{From};
        }
        elsif ( $Param{UserType} eq 'Customer' ) {

            # use data from customer user (if customer user is in database)
            if ( IsHashRefWithData( \%CustomerUserData ) ) {
                $From = '"'
                    . $CustomerUserData{UserFullname} . '"'
                    . ' <' . $CustomerUserData{UserEmail} . '>';
            }

            # otherwise use customer user as sent from the request (it should be an email)
            else {
                $From = $Ticket->{CustomerUser};
            }
        }
        else {
            my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $Param{UserID},
            );
            $From = $UserData{UserFullname};
        }

        # Set Article To, Cc, Bcc.
        my ( $To, $Cc, $Bcc );
        if ( $Article->{To} ) {
            $To = $Article->{To};
        }
        if ( $Article->{Cc} ) {
            $Cc = $Article->{Cc};
        }
        if ( $Article->{Bcc} ) {
            $Bcc = $Article->{Bcc};
        }

        # Fallback for To
        if ( !$To && $Article->{CommunicationChannel} eq 'Email' ) {

            # Use data from customer user (if customer user is in database).
            if ( IsHashRefWithData( \%CustomerUserData ) ) {
                $To = '"' . $CustomerUserData{UserFullname} . '"'
                    . ' <' . $CustomerUserData{UserEmail} . '>';
            }

            # Otherwise use customer user as sent from the request (it should be an email).
            else {
                $To = $Ticket->{CustomerUser} // $TicketData{CustomerUserID};
            }
        }

        if ( !$Article->{CommunicationChannel} ) {

            my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
                ChannelID => $Article->{CommunicationChannelID},
            );
            $Article->{CommunicationChannel} = $CommunicationChannel{ChannelName};
        }

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => $Article->{CommunicationChannel},
        );

        my $PlainBody = $Article->{Body};

        # Convert article body to plain text, if HTML content was supplied. This is necessary since auto response code
        #   expects plain text content. Please see bug#13397 for more information.
        if ( $Article->{ContentType} =~ /text\/html/i || $Article->{MimeType} =~ /text\/html/i ) {
            $PlainBody = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
                String => $Article->{Body},
            );
        }

        # Create article.
        $ArticleID = $ArticleBackendObject->ArticleCreate(
            NoAgentNotify        => $Article->{NoAgentNotify} || 0,
            TicketID             => $TicketID,
            SenderTypeID         => $Article->{SenderTypeID} || '',
            SenderType           => $Article->{SenderType} || '',
            IsVisibleForCustomer => $Article->{IsVisibleForCustomer},
            From                 => $From,
            To                   => $To,
            Cc                   => $Cc,
            Bcc                  => $Bcc,
            Subject              => $Article->{Subject},
            Body                 => $Article->{Body},
            MimeType             => $Article->{MimeType} || '',
            Charset              => $Article->{Charset} || '',
            ContentType          => $Article->{ContentType} || '',
            UserID               => $Param{UserID},
            HistoryType          => $Article->{HistoryType},
            HistoryComment       => $Article->{HistoryComment} || '%%',
            AutoResponseType     => $Article->{AutoResponseType},
            UnlockOnAway         => $UnlockOnAway,
            OrigHeader           => {
                From    => $From,
                To      => $To,
                Subject => $Article->{Subject},
                Body    => $PlainBody,
            },
        );

        if ( !$ArticleID ) {
            return {
                Success => 0,
                ErrorMessage =>
                    'Article could not be created, please contact the system administrator'
            };
        }

        # time accounting
        if ( $Article->{TimeUnit} ) {
            $TicketObject->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $Article->{TimeUnit},
                UserID    => $Param{UserID},
            );
        }
    }

    # set dynamic fields
    for my $DynamicField ( @{$DynamicFieldList} ) {
        my $Result = $Self->SetDynamicFieldValue(
            %{$DynamicField},
            TicketID  => $TicketID,
            ArticleID => $ArticleID || '',
            UserID    => $Param{UserID},
        );

        if ( !$Result->{Success} ) {
            my $ErrorMessage =
                $Result->{ErrorMessage} || "Dynamic Field $DynamicField->{Name} could not be set,"
                . " please contact the system administrator";

            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
    }

    # set attachments

    for my $Attachment ( @{$AttachmentList} ) {
        my $Result = $Self->CreateAttachment(
            Attachment => $Attachment,
            TicketID   => $TicketID,
            ArticleID  => $ArticleID || '',
            UserID     => $Param{UserID}
        );

        if ( !$Result->{Success} ) {
            my $ErrorMessage =
                $Result->{ErrorMessage} || "Attachment could not be created, please contact the "
                . " system administrator";

            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
    }

    # get web service configuration
    my $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $Self->{WebserviceID},
    );

    my $IncludeTicketData;

    # Get operation config, if operation name was supplied.
    if ( $Self->{Operation} ) {
        my $OperationConfig = $Webservice->{Config}->{Provider}->{Operation}->{ $Self->{Operation} };
        $IncludeTicketData = $OperationConfig->{IncludeTicketData};
    }

    if ( !$IncludeTicketData ) {
        if ($ArticleID) {
            return {
                Success => 1,
                Data    => {
                    TicketID     => $TicketID,
                    TicketNumber => $TicketData{TicketNumber},
                    ArticleID    => $ArticleID,
                },
            };
        }
        return {
            Success => 1,
            Data    => {
                TicketID     => $TicketID,
                TicketNumber => $TicketData{TicketNumber},
            },
        };
    }

    # get updated TicketData
    %TicketData = ();
    %TicketData = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 1,
        UserID        => $Param{UserID},
    );

    # extract all dynamic fields from main ticket hash.
    my %TicketDynamicFields;
    TICKETATTRIBUTE:
    for my $TicketAttribute ( sort keys %TicketData ) {
        if ( $TicketAttribute =~ m{\A DynamicField_(.*) \z}msx ) {
            $TicketDynamicFields{$1} = {
                Name  => $1,
                Value => $TicketData{$TicketAttribute},
            };
            delete $TicketData{$TicketAttribute};
        }
    }

    # add dynamic fields as array into 'DynamicField' hash key if any
    if (%TicketDynamicFields) {
        $TicketData{DynamicField} = [ sort { $a->{Name} cmp $b->{Name} } values %TicketDynamicFields ];
    }

    # get last ArticleID
    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        ArticleID => $ArticleID,
        TicketID  => $TicketID
    );

    my @Articles = $ArticleObject->ArticleList(
        TicketID => $TicketID,
        OnlyLast => 1,
    );

    my $LastArticleID = $Articles[0]->{ArticleID};

    # return ticket data if we have no article data
    if ( !$ArticleID && !$LastArticleID ) {
        return {
            Success => 1,
            Data    => {
                TicketID     => $TicketID,
                TicketNumber => $TicketData{TicketNumber},
                Ticket       => \%TicketData,
            },
        };
    }

    # get Article and ArticleAttachement
    my %ArticleData = $ArticleBackendObject->ArticleGet(
        ArticleID     => $ArticleID || $LastArticleID,
        DynamicFields => 1,
        TicketID      => $TicketID,
    );

    # prepare Article DynamicFields
    my @ArticleDynamicFields;

    # remove all dynamic fields from main ticket hash and set them into an array.
    ARTICLEATTRIBUTE:
    for my $ArticleAttribute ( sort keys %ArticleData ) {
        if ( $ArticleAttribute =~ m{\A DynamicField_(.*) \z}msx ) {
            if ( !exists $TicketDynamicFields{$1} ) {
                push @ArticleDynamicFields, {
                    Name  => $1,
                    Value => $ArticleData{$ArticleAttribute},
                };
            }

            delete $ArticleData{$ArticleAttribute};
        }
    }

    # add dynamic fields array into 'DynamicField' hash key if any
    if (@ArticleDynamicFields) {
        $ArticleData{DynamicField} = \@ArticleDynamicFields;
    }

    # add attachment if the request includes attachments
    if ( IsArrayRefWithData($AttachmentList) ) {
        my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID => $ArticleData{ArticleID},
        );

        my @Attachments;
        $Kernel::OM->Get('Kernel::System::Main')->Require('MIME::Base64');
        ATTACHMENT:
        for my $FileID ( sort keys %AttachmentIndex ) {
            next ATTACHMENT if !$FileID;
            my %Attachment = $ArticleBackendObject->ArticleAttachment(
                ArticleID => $ArticleData{ArticleID},
                FileID    => $FileID,
            );

            next ATTACHMENT if !IsHashRefWithData( \%Attachment );

            # convert content to base64, but prevent 76 chars brake, see bug#14500.
            $Attachment{Content} = MIME::Base64::encode_base64( $Attachment{Content}, '' );
            push @Attachments, {%Attachment};
        }

        # set Attachments data
        if (@Attachments) {
            $ArticleData{Attachment} = \@Attachments;
        }
    }

    $TicketData{Article} = \%ArticleData;

    # return ticket data and article data
    return {
        Success => 1,
        Data    => {
            TicketID     => $TicketID,
            TicketNumber => $TicketData{TicketNumber},
            ArticleID    => $ArticleData{ArticleID},
            Ticket       => \%TicketData,
        },
    };
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
