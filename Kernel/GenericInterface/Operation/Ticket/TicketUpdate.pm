# --
# Kernel/GenericInterface/Operation/Ticket/TicketUpdate.pm - GenericInterface Ticket TicketUpdate operation backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketUpdate;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::State;
use Kernel::System::CustomerUser;
use Kernel::System::User;
use Kernel::System::Ticket;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

use Kernel::GenericInterface::Operation::Common;
use Kernel::GenericInterface::Operation::Ticket::Common;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketCreate - GenericInterface Ticket TicketCreate Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(
        DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject
        WebserviceID
        )
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{QueueObject}        = Kernel::System::Queue->new( %{$Self} );
    $Self->{StateObject}        = Kernel::System::State->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );
    $Self->{TicketObject}       = Kernel::System::Ticket->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{DFBackendObject}    = Kernel::System::DynamicField::Backend->new(%Param);
    $Self->{CommonObject}       = Kernel::GenericInterface::Operation::Common->new( %{$Self} );
    $Self->{TicketCommonObject}
        = Kernel::GenericInterface::Operation::Ticket::Common->new( %{$Self} );

    $Self->{Config} = $Self->{ConfigObject}->Get('GenericInterface::Operation::TicketUpdate');

    return $Self;
}

=item Run()

perform TicketCreate Operation. This will return the created ticket number.

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
            },
            Article {                                                          # optional
                ArticleTypeID                   => 123,                        # optional
                ArticleType                     => 'some article type name',   # optional
                SenderTypeID                    => 123,                        # optional
                SenderType                      => 'some sender type name',    # optional
                AutoResponseType                => 'some auto response type',  # optional
                From                            => 'some from string',         # optional
                Subject                         => 'some subject',
                Body                            => 'some body'

                ContentType                     => 'some content type',        # ContentType or MimeType and Charset is requieed
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
            TicketNumber => 2324454323322           # Ticket Number in OTRS (Help desk system)
            ArticleID   => 43,                      # Article ID number in OTRS (help desk system)
            Error => {                              # should not return errors
                    ErrorCode    => 'Ticket.Create.ErrorCode'
                    ErrorMessage => 'Error Description'
            },
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketUpdate.EmptyRequest',
            ErrorMessage => "TicketUpdate: The request data is invalid!",
        );
    }

    if ( !$Param{Data}->{TicketID} && !$Param{Data}->{TicketNumber} ) {
        return $Self->{TicketCommonObject}->ReturnError(
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
        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: UserLogin, CustomerUserLogin or SessionID is required!",
        );
    }

    if ( $Param{Data}->{UserLogin} || $Param{Data}->{CustomerUserLogin} ) {

        if ( !$Param{Data}->{Password} )
        {
            return $Self->{TicketCommonObject}->ReturnError(
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: Password or SessionID is required!",
            );
        }
    }

    # authenticate user
    my ( $UserID, $UserType ) = $Self->{CommonObject}->Auth(%Param);

    if ( !$UserID ) {
        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketUpdate.AuthFail',
            ErrorMessage => "TicketUpdate: User could not be authenticated!",
        );
    }

    # check TicketID
    my $TicketID;
    if ( $Param{Data}->{TicketNumber} ) {
        $TicketID = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $Param{Data}->{TicketNumber},
            UserID       => $UserID,
        );

    }
    else {
        $TicketID = $Param{Data}->{TicketID};
    }

    if ( !($TicketID) ) {
        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketUpdate.AccessDenied',
            ErrorMessage => "TicketUpdate: User does not have access to the ticket!",
        );
    }

    my %TicketData = $Self->{TicketObject}->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $UserID,
    );

    if ( !IsHashRefWithData( \%TicketData ) ) {
        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketUpdate.AccessDenied',
            ErrorMessage => "TicketUpdate: User does not have access to the ticket!",
        );
    }

    # check basic needed permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $UserID
    );

    if ( !$Access ) {
        return $Self->{TicketCommonObject}->ReturnError(
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
            return $Self->{TicketCommonObject}->ReturnError(
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
            return $Self->{TicketCommonObject}->ReturnError(
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
            return $Self->{TicketCommonObject}->ReturnError( %{$TicketCheck} );
        }
    }

    my $Article;
    if ( defined $Param{Data}->{Article} ) {

        # isolate Article parameter
        $Article = $Param{Data}->{Article};

        # add UserType to Validate ArticleType
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

        # check attributes that can be gather by sysconfig
        if ( !$Article->{AutoResponseType} ) {
            $Article->{AutoResponseType} = $Self->{Config}->{AutoResponseType} || '';
        }
        if ( !$Article->{ArticleTypeID} && !$Article->{ArticleType} ) {
            $Article->{ArticleType} = $Self->{Config}->{ArticleType} || '';
        }
        if ( !$Article->{SenderTypeID} && !$Article->{SenderType} ) {
            $Article->{SenderType} = $UserType eq 'Agent' ? 'agent' : 'customer';
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
                    }
            }
            return $Self->{TicketCommonObject}->ReturnError( %{$ArticleCheck} );
        }
    }

    my $DynamicField;
    my @DynamicFieldList;
    if ( defined $Param{Data}->{DynamicField} ) {

        # isolate DynamicField parameter
        $DynamicField = $Param{Data}->{DynamicField};

        # homologate imput to array
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
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    ErrorMessage =>
                        "TicketCreate: Ticket->DynamicField parameter is invalid!",
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
                return $Self->{TicketCommonObject}->ReturnError( %{$DynamicFieldCheck} );
            }
        }
    }

    my $Attachment;
    my @AttachmentList;
    if ( defined $Param{Data}->{Attachment} ) {

        # isolate Attachment parameter
        $Attachment = $Param{Data}->{Attachment};

        # homologate imput to array
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
                    ErrorCode => 'TicketCreate.InvalidParameter',
                    ErrorMessage =>
                        "TicketCreate: Ticket->Attachment parameter is invalid!",
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
                return $Self->{TicketCommonObject}->ReturnError( %{$AttachmentCheck} );
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

=item _CheckTicket()

checks if the given ticket parameters are valid.

    my $TicketCheck = $OperationObject->_CheckTicket(
        Ticket => $Ticket,                          # all ticket parameters
    );

    returns:

    $TicketCheck = {
        Success => 1,                               # if everething is OK
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
        && !$Self->{TicketCommonObject}->ValidateCustomer( %{$Ticket} )
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
        if ( !$Self->{TicketCommonObject}->ValidateQueue( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->QueueID or Ticket->Queue parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Lock
    if ( $Ticket->{LockID} || $Ticket->{Lock} ) {
        if ( !$Self->{TicketCommonObject}->ValidateLock( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->LockID or Ticket->Lock parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Type
    if ( $Ticket->{TypeID} || $Ticket->{Type} ) {
        if ( !$Self->{TicketCommonObject}->ValidateType( %{$Ticket} ) ) {
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
            $CustomerUser = $OldTicket->{CustomerUserID},
        }
        if (
            !$Self->{TicketCommonObject}->ValidateService(
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
            !$Self->{TicketCommonObject}->ValidateSLA(
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
        if ( !$Self->{TicketCommonObject}->ValidateState( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->StateID or Ticket->State parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Priority
    if ( $Ticket->{PriorityID} || $Ticket->{Priority} ) {
        if ( !$Self->{TicketCommonObject}->ValidatePriority( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->PriorityID or Ticket->Priority parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Owner
    if ( $Ticket->{OwnerID} || $Ticket->{Owner} ) {
        if ( !$Self->{TicketCommonObject}->ValidateOwner( %{$Ticket} ) ) {
            return {
                ErrorCode => 'TicketUpdate.InvalidParameter',
                ErrorMessage =>
                    "TicketUpdate: Ticket->OwnerID or Ticket->Owner parameter is invalid!",
            };
        }
    }

    # check Ticket->Responsible
    if ( $Ticket->{ResponsibleID} || $Ticket->{Responsible} ) {
        if ( !$Self->{TicketCommonObject}->ValidateResponsible( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->ResponsibleID or Ticket->Responsible"
                    . " parameter is invalid!",
            };
        }
    }

    # check Ticket->PendingTime
    if ( $Ticket->{PendingTime} ) {
        if ( !$Self->{TicketCommonObject}->ValidatePendingTime( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Ticket->PendingTimne parameter is invalid!",
            };
        }
    }

    # if everything is OK then return Success
    return {
        Success => 1,
    };
}

=item _CheckArticle()

checks if the given article parameter is valid.

    my $ArticleCheck = $OperationObject->_CheckArticle(
        Article => $Article,                        # all article parameters
    );

    returns:

    $ArticleCheck = {
        Success => 1,                               # if everething is OK
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
            ErrorMessage => "TicketUpdate: Article->AutoResponseType parameter is required and"
                . " Sysconfig ArticleTypeID setting could not be read!"
        };
    }
    if ( !$Self->{TicketCommonObject}->ValidateAutoResponseType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->AutoResponseType parameter is invalid!",
        };
    }

    # check Article->ArticleType
    if ( !$Article->{ArticleTypeID} && !$Article->{ArticleType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketUpdate: Article->ArticleTypeID or Article->ArticleType parameter"
                . " is required and Sysconfig ArticleTypeID setting could not be read!"
        };
    }
    if ( !$Self->{TicketCommonObject}->ValidateArticleType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->ArticleTypeID or Article->ArticleType parameter"
                . " is invalid!",
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
    if ( !$Self->{TicketCommonObject}->ValidateSenderType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: Article->SenderTypeID or Ticket->SenderType parameter"
                . " is invalid!",
        };
    }

    # check Article->From
    if ( $Article->{From} ) {
        if ( !$Self->{TicketCommonObject}->ValidateFrom( %{$Article} ) ) {
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

        if ( !$Self->{TicketCommonObject}->ValidateMimeType( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketUpdate.InvalidParameter',
                ErrorMessage => "TicketUpdate: Article->MimeType is invalid!",
            };
        }
    }

    # check Article->MimeType
    if ( $Article->{Charset} ) {

        $Article->{Charset} = lc $Article->{Charset};

        if ( !$Self->{TicketCommonObject}->ValidateCharset( %{$Article} ) ) {
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

        if ( !$Self->{TicketCommonObject}->ValidateCharset( Charset => $Charset ) ) {
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

        if ( !$Self->{TicketCommonObject}->ValidateMimeType( MimeType => $MimeType ) ) {
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
    if ( !$Self->{TicketCommonObject}->ValidateHistoryType( %{$Article} ) ) {
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

    # check Article->TimeUnit
    # TimeUnit could be required or not depending on sysconfig option
    if (
        !$Article->{TimeUnit}
        && $Self->{ConfigObject}->{'Ticket::Frontend::AccountTime'}
        && $Self->{ConfigObject}->{'Ticket::Frontend::NeedAccountedTime'}
        )
    {
        return {
            ErrorCode    => 'TicketUpdate.MissingParameter',
            ErrorMessage => "TicketUpdate: Article->TimeUnit is required by sysconfig option!",
        };
    }
    if ( $Article->{TimeUnit} ) {
        if ( !$Self->{TicketCommonObject}->ValidateTimeUnit( %{$Article} ) ) {
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
                    if ( !$Self->{TicketCommonObject}->ValidateUserID( UserID => $UserID ) ) {
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

=item _CheckDynamicField()

checks if the given dynamic field parameter is valid.

    my $DynamicFieldCheck = $OperationObject->_CheckDynamicField(
        DynamicField => $DynamicField,              # all dynamic field parameters
    );

    returns:

    $DynamicFieldCheck = {
        Success => 1,                               # if everething is OK
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
        if ( !$DynamicField->{$Needed} ) {
            return {
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: DynamicField->$Needed  parameter is missing!",
            };
        }
    }

    # check DynamicField->Name
    if ( !$Self->{TicketCommonObject}->ValidateDynamicFieldName( %{$DynamicField} ) ) {
        return {
            ErrorCode    => 'TicketUpdate.InvalidParameter',
            ErrorMessage => "TicketUpdate: DynamicField->Name parameter is invalid!",
        };
    }

    # check objectType for dynamic field
    if (
        !$Self->{TicketCommonObject}->ValidateDynamicFieldObjectType(
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
    if ( !$Self->{TicketCommonObject}->ValidateDynamicFieldValue( %{$DynamicField} ) ) {
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

=item _CheckAttachment()

checks if the given attachment parameter is valid.

    my $AttachmentCheck = $OperationObject->_CheckAttachment(
        Attachment => $Attachment,                  # all attachment parameters
    );

    returns:

    $AttachmentCheck = {
        Success => 1,                               # if everething is OK
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
        if ( !$Attachment->{$Needed} ) {
            return {
                ErrorCode    => 'TicketUpdate.MissingParameter',
                ErrorMessage => "TicketUpdate: Attachment->$Needed  parameter is missing!",
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

        if ( $Charset && !$Self->{TicketCommonObject}->ValidateCharset( Charset => $Charset ) ) {
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

        if ( !$Self->{TicketCommonObject}->ValidateMimeType( MimeType => $MimeType ) ) {
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

=item _CheckUpdatePermissions()

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
        Success => 1,                               # if everething is OK
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

    # check Article permissions
    if ( IsHashRefWithData($Article) ) {
        my $Access = $Self->{TicketObject}->TicketPermission(
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
        my $Access = $Self->{TicketObject}->TicketPermission(
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
        my $Access = $Self->{TicketObject}->TicketPermission(
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
        my $Access = $Self->{TicketObject}->TicketPermission(
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
        my $Access = $Self->{TicketObject}->TicketPermission(
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
        my $Access = $Self->{TicketObject}->TicketPermission(
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
        if ( $Ticket->{StateID} ) {
            $StateID = $Ticket->{StateID};
        }
        else {
            $StateID = $Self->{StateObject}->StateLookup(
                State => $Ticket->{State},
            );
        }

        %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $StateID,
        );

        my $Access = 1;

        if ( $StateData{TypeName} =~ /^close/i ) {
            $Access = $Self->{TicketObject}->TicketPermission(
                Type     => 'close',
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {
            $Access = $Self->{TicketObject}->TicketPermission(
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
        }
}

=item _TicketUpdate()

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
        Success => 1,                               # if everething is OK
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
        return $Self->{TicketCommonObject}->ReturnError( %{$Access} );
    }

    my %CustomerUserData;

    # get customer information
    if ( $Ticket->{CustomerUser} ) {
        %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Ticket->{CustomerUser},
        );
    }

    # get current ticket data
    my %TicketData = $Self->{TicketObject}->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $Param{UserId},
    );

    # update ticket parameters
    # update Ticket->Title
    if (
        defined $Ticket->{Title}
        && $Ticket->{Title} ne ''
        && $Ticket->{Title} ne $TicketData{Title}
        )
    {
        my $Success = $Self->{TicketObject}->TicketTitleUpdate(
            Title    => $Ticket->{Title},
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket title could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Queue
    if ( $Ticket->{Queue} || $Ticket->{QueueID} ) {
        my $Success;
        if ( defined $Ticket->{Queue} && $Ticket->{Queue} ne $TicketData{Queue} ) {
            $Success = $Self->{TicketObject}->TicketQueueSet(
                Queue    => $Ticket->{Queue},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{QueueID} && $Ticket->{QueueID} ne $TicketData{QueueID} ) {
            $Success = $Self->{TicketObject}->TicketQueueSet(
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
                }
        }
    }

    # update Ticket->Lock
    if ( $Ticket->{Lock} || $Ticket->{LockID} ) {
        my $Success;
        if ( defined $Ticket->{Lock} && $Ticket->{Lock} ne $TicketData{Lock} ) {
            $Success = $Self->{TicketObject}->TicketLockSet(
                Lock     => $Ticket->{Lock},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{LockID} && $Ticket->{LockID} ne $TicketData{LockID} ) {
            $Success = $Self->{TicketObject}->TicketLockSet(
                LockID   => $Ticket->{LockID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 0;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket lock could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Type
    if ( $Ticket->{Type} || $Ticket->{TypeID} ) {
        my $Success;
        if ( defined $Ticket->{Type} && $Ticket->{Type} ne $TicketData{Type} ) {
            $Success = $Self->{TicketObject}->TicketTypeSet(
                Type     => $Ticket->{Type},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{TypeID} && $Ticket->{TypeID} ne $TicketData{TypeID} )
        {
            $Success = $Self->{TicketObject}->TicketTypeSet(
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
                }
        }
    }

    # update Ticket>State
    # depending on the state, might require to unlock ticket or enables pending time set
    if ( $Ticket->{State} || $Ticket->{StateID} ) {

        # get State Data
        my %StateData;
        my $StateID;
        if ( $Ticket->{StateID} ) {
            $StateID = $Ticket->{StateID};
        }
        else {
            $StateID = $Self->{StateObject}->StateLookup(
                State => $Ticket->{State},
            );
        }

        %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $StateID,
        );

        # forse unlock if state type is close
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Param{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            if ( defined $Ticket->{PendingTime} ) {
                my $Success = $Self->{TicketObject}->TicketPendingTimeSet(
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
                        }
                }
            }
            else {
                return $Self->{TicketCommonObject}->ReturnError(
                    ErrorCode    => 'TicketUpdate.MissingParameter',
                    ErrorMessage => 'Can\'t set a ticket on a pending state without pendig time!'
                    )
            }
        }

        my $Success;
        if ( defined $Ticket->{State} && $Ticket->{State} ne $TicketData{State} ) {
            $Success = $Self->{TicketObject}->TicketStateSet(
                State    => $Ticket->{State},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{StateID} && $Ticket->{StateID} ne $TicketData{StateID} )
        {
            $Success = $Self->{TicketObject}->TicketStateSet(
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
                }
        }
    }

    # update Ticket->Service
    # this might reset SLA if current SLA is not available for the new service
    if ( $Ticket->{Service} || $Ticket->{ServiceID} ) {

        # check if ticket has a SLA assigned
        if ( $TicketData{SLAID} ) {

            # check if old SLA is still valid
            if (
                !$Self->{TicketCommonObject}->ValidateSLA(
                    SLAID     => $TicketData{SLAID},
                    Service   => $Ticket->{Service} || '',
                    ServiceID => $Ticket->{ServiceID} || '',
                )
                )
            {

                # remove current SLA if is not compatible with new service
                my $Success = $Self->{TicketObject}->TicketSLASet(
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
            $Success = $Self->{TicketObject}->TicketServiceSet(
                Service  => $Ticket->{Service},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{ServiceID} && $Ticket->{ServiceID} ne $TicketData{ServiceID} )
        {
            $Success = $Self->{TicketObject}->TicketServiceSet(
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
                }
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
            $Success = $Self->{TicketObject}->TicketSLASet(
                SLA      => $Ticket->{SLA},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{SLAID} && $Ticket->{SLAID} ne $TicketData{SLAID} )
        {
            $Success = $Self->{TicketObject}->TicketSLASet(
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
                }
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

            $Success = $Self->{TicketObject}->TicketCustomerSet(
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
                }
        }
    }

    # update Ticket->Priority
    if ( $Ticket->{Priority} || $Ticket->{PriorityID} ) {
        my $Success;
        if ( defined $Ticket->{Priority} && $Ticket->{Priority} ne $TicketData{Priority} ) {
            $Success = $Self->{TicketObject}->TicketPrioritySet(
                Priority => $Ticket->{Priority},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{PriorityID} && $Ticket->{PriorityID} ne $TicketData{PriorityID} )
        {
            $Success = $Self->{TicketObject}->TicketPrioritySet(
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
                }
        }
    }

    # update Ticket->Owner
    if ( $Ticket->{Owner} || $Ticket->{OwnerID} ) {
        my $Success;
        if ( defined $Ticket->{Owner} && $Ticket->{Owner} ne $TicketData{Owner} ) {
            $Success = $Self->{TicketObject}->TicketOwnerSet(
                NewUser  => $Ticket->{Owner},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{OwnerID} && $Ticket->{OwnerID} ne $TicketData{OwnerID} )
        {
            $Success = $Self->{TicketObject}->TicketOwnerSet(
                NewUserID => $Ticket->{OwnerID},
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
                    'Ticket owner could not be updated, please contact system administrator!',
                }
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
            $Success = $Self->{TicketObject}->TicketResponsibleSet(
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
            $Success = $Self->{TicketObject}->TicketResponsibleSet(
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
                }
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
                $From
                    = '"'
                    . $CustomerUserData{UserFirstname} . ' '
                    . $CustomerUserData{UserLastname} . '"'
                    . ' <' . $CustomerUserData{UserEmail} . '>';
            }

            # otherwise use customer user as sent from the request (it should be an email)
            else {
                $From = $Ticket->{CustomerUser};
            }
        }
        else {
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $Param{UserID},
            );
            $From = $UserData{UserFirstname} . ' ' . $UserData{UserLastname};
        }

        # set Article To
        my $To = '';

        # create article
        $ArticleID = $Self->{TicketObject}->ArticleCreate(
            NoAgentNotify  => $Article->{NoAgentNotify}  || 0,
            TicketID       => $TicketID,
            ArticleTypeID  => $Article->{ArticleTypeID}  || '',
            ArticleType    => $Article->{ArticleType}    || '',
            SenderTypeID   => $Article->{SenderTypeID}   || '',
            SenderType     => $Article->{SenderType}     || '',
            From           => $From,
            To             => $To,
            Subject        => $Article->{Subject},
            Body           => $Article->{Body},
            MimeType       => $Article->{MimeType}       || '',
            Charset        => $Article->{Charset}        || '',
            ContentType    => $Article->{ContentType}    || '',
            UserID         => $Param{UserID},
            HistoryType    => $Article->{HistoryType},
            HistoryComment => $Article->{HistoryComment} || '%%',
            AutoResponseType => $Article->{AutoResponseType},
            OrigHeader       => {
                From    => $From,
                To      => $To,
                Subject => $Article->{Subject},
                Body    => $Article->{Body},

            },
        );

        if ( !$ArticleID ) {
            return {
                Success => 0,
                ErrorMessage =>
                    'Article could not be created, please contact the system administrator'
                }
        }

        # time accounting
        if ( $Article->{TimeUnit} ) {
            $Self->{TicketObject}->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $Article->{TimeUnit},
                UserID    => $Param{UserID},
            );
        }
    }

    # set dynamic fields
    for my $DynamicField ( @{$DynamicFieldList} ) {
        my $Result = $Self->{TicketCommonObject}->SetDynamicFieldValue(
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
        my $Result = $Self->{TicketCommonObject}->CreateAttachment(
            Attachment => $Attachment,
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

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
