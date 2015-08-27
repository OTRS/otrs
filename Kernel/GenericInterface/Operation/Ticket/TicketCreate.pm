# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketCreate;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use base qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::Ticket::Common
);

our $ObjectManagerDisabled = 1;

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
    for my $Needed (qw( DebuggerObject WebserviceID )) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::TicketCreate');

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

            Password  => 'some password',                                       # if UserLogin or CustomerUserLogin is sent then
                                                                                #   Password is required

            Ticket => {
                Title      => 'some ticket title',

                QueueID       => 123,                                           # QueueID or Queue is required
                Queue         => 'some queue name',

                LockID        => 123,                                           # optional
                Lock          => 'some lock name',                              # optional
                TypeID        => 123,                                           # optional
                Type          => 'some type name',                              # optional
                ServiceID     => 123,                                           # optional
                Service       => 'some service name',                           # optional
                SLAID         => 123,                                           # optional
                SLA           => 'some SLA name',                               # optional

                StateID       => 123,                                           # StateID or State is required
                State         => 'some state name',

                PriorityID    => 123,                                           # PriorityID or Priority is required
                Priority      => 'some priority name',

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
            Article => {
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
            # DynamicField => {
            #    Name   => 'some name',
            #    Value  => $Value,
            #},

            Attachment => [
                {
                    Content     => 'content'                                 # base64 encoded
                    ContentType => 'some content type'
                    Filename    => 'some fine name'
                },
                # ...
            ],
            #or
            #Attachment => {
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
    if (
        !$Param{Data}->{UserLogin}
        && !$Param{Data}->{CustomerUserLogin}
        && !$Param{Data}->{SessionID}
        )
    {
        return $Self->ReturnError(
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: UserLogin, CustomerUserLogin or SessionID is required!",
        );
    }

    if ( $Param{Data}->{UserLogin} || $Param{Data}->{CustomerUserLogin} ) {

        if ( !$Param{Data}->{Password} )
        {
            return $Self->ReturnError(
                ErrorCode    => 'TicketCreate.MissingParameter',
                ErrorMessage => "TicketCreate: Password or SessionID is required!",
            );
        }
    }

    # authenticate user
    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    if ( !$UserID ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketCreate.AuthFail',
            ErrorMessage => "TicketCreate: User could not be authenticated!",
        );
    }

    my $PermissionUserID = $UserID;
    if ( $UserType eq 'Customer' ) {
        $UserID = $Kernel::OM->Get('Kernel::Config')->Get('CustomerPanelUserID')
    }

    # check needed hashes
    for my $Needed (qw(Ticket Article)) {
        if ( !IsHashRefWithData( $Param{Data}->{$Needed} ) ) {
            return $Self->ReturnError(
                ErrorCode    => 'TicketCreate.MissingParameter',
                ErrorMessage => "TicketCreate: $Needed parameter is missing or not valid!",
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
                ErrorCode    => 'TicketCreate.MissingParameter',
                ErrorMessage => "TicketCreate: $Optional parameter is missing or not valid!",
            );
        }
    }

    # isolate ticket parameter
    my $Ticket = $Param{Data}->{Ticket};

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
    my $TicketCheck = $Self->_CheckTicket( Ticket => $Ticket );

    if ( !$TicketCheck->{Success} ) {
        return $Self->ReturnError( %{$TicketCheck} );
    }

    # check create permissions
    my $Permission = $Self->CheckCreatePermissions(
        Ticket   => $Ticket,
        UserID   => $PermissionUserID,
        UserType => $UserType,
    );

    if ( !$Permission ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketCreate.AccessDenied',
            ErrorMessage => "TicketCreate: Can not create tickets in given Queue or QueueID!",
        );
    }

    # isolate Article parameter
    my $Article = $Param{Data}->{Article};

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

        # $Article->{SenderType} = $Self->{Config}->{SenderType} || '';
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
                }
        }
        return $Self->ReturnError( %{$ArticleCheck} );
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
            my $DynamicFieldCheck = $Self->_CheckDynamicField( DynamicField => $DynamicFieldItem );

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
            my $AttachmentCheck = $Self->_CheckAttachment( Attachment => $AttachmentItem );

            if ( !$AttachmentCheck->{Success} ) {
                return $Self->ReturnError( %{$AttachmentCheck} );
            }
        }
    }

    return $Self->_TicketCreate(
        Ticket           => $Ticket,
        Article          => $Article,
        DynamicFieldList => \@DynamicFieldList,
        AttachmentList   => \@AttachmentList,
        UserID           => $UserID,
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
        Success => 1,                               # if everything is OK
    }

    $TicketCheck = {
        ErrorCode    => 'Function.Error',           # if error
        ErrorMessage => 'Error description',
    }

=cut

sub _CheckTicket {
    my ( $Self, %Param ) = @_;

    my $Ticket = $Param{Ticket};

    # check ticket internally
    for my $Needed (qw(Title CustomerUser)) {
        if ( !$Ticket->{$Needed} ) {
            return {
                ErrorCode    => 'TicketCreate.MissingParameter',
                ErrorMessage => "TicketCreate: Ticket->$Needed parameter is missing!",
            };
        }
    }

    # check Ticket->CustomerUser
    if ( !$Self->ValidateCustomer( %{$Ticket} ) ) {
        return {
            ErrorCode => 'TicketCreate.InvalidParameter',
            ErrorMessage =>
                "TicketCreate: Ticket->CustomerUser parameter is invalid!",
        };
    }

    # check Ticket->Queue
    if ( !$Ticket->{QueueID} && !$Ticket->{Queue} ) {
        return {
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Ticket->QueueID or Ticket->Queue parameter is required!",
        };
    }
    if ( !$Self->ValidateQueue( %{$Ticket} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Ticket->QueueID or Ticket->Queue parameter is invalid!",
        };
    }

    # check Ticket->Lock
    if ( $Ticket->{LockID} || $Ticket->{Lock} ) {
        if ( !$Self->ValidateLock( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Ticket->LockID or Ticket->Lock parameter is"
                    . " invalid!",
            };
        }
    }

    # check Ticket->Type
    # Ticket type could be required or not depending on sysconfig option
    if (
        !$Ticket->{TypeID}
        && !$Ticket->{Type}
        && $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type')
        )
    {
        return {
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Ticket->TypeID or Ticket->Type parameter is required"
                . " by sysconfig option!",
        };
    }
    if ( $Ticket->{TypeID} || $Ticket->{Type} ) {
        if ( !$Self->ValidateType( %{$Ticket} ) ) {
            return {
                ErrorCode => 'TicketCreate.InvalidParameter',
                ErrorMessage =>
                    "TicketCreate: Ticket->TypeID or Ticket->Type parameter is invalid!",
            };
        }
    }

    # check Ticket->Service
    if ( $Ticket->{ServiceID} || $Ticket->{Service} ) {
        if ( !$Self->ValidateService( %{$Ticket} ) ) {
            return {
                ErrorCode => 'TicketCreate.InvalidParameter',
                ErrorMessage =>
                    "TicketCreate: Ticket->ServiceID or Ticket->Service parameter is invalid!",
            };
        }
    }

    # check Ticket->SLA
    if ( $Ticket->{SLAID} || $Ticket->{SLA} ) {
        if ( !$Self->ValidateSLA( %{$Ticket} ) ) {
            return {
                ErrorCode => 'TicketCreate.InvalidParameter',
                ErrorMessage =>
                    "TicketCreate: Ticket->SLAID or Ticket->SLA parameter is invalid!",
            };
        }
    }

    # check Ticket->State
    if ( !$Ticket->{StateID} && !$Ticket->{State} ) {
        return {
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Ticket->StateID or Ticket->State parameter is required!",
        };
    }
    if ( !$Self->ValidateState( %{$Ticket} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Ticket->StateID or Ticket->State parameter is invalid!",
        };
    }

    # check Ticket->Priority
    if ( !$Ticket->{PriorityID} && !$Ticket->{Priority} ) {
        return {
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Ticket->PriorityID or Ticket->Priority parameter is"
                . " required!",
        };
    }
    if ( !$Self->ValidatePriority( %{$Ticket} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Ticket->PriorityID or Ticket->Priority parameter is"
                . " invalid!",
        };
    }

    # check Ticket->Owner
    if ( $Ticket->{OwnerID} || $Ticket->{Owner} ) {
        if ( !$Self->ValidateOwner( %{$Ticket} ) ) {
            return {
                ErrorCode => 'TicketCreate.InvalidParameter',
                ErrorMessage =>
                    "TicketCreate: Ticket->OwnerID or Ticket->Owner parameter is invalid!",
            };
        }
    }

    # check Ticket->Responsible
    if ( $Ticket->{ResponsibleID} || $Ticket->{Responsible} ) {
        if ( !$Self->ValidateResponsible( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Ticket->ResponsibleID or Ticket->Responsible"
                    . " parameter is invalid!",
            };
        }
    }

    # check Ticket->PendingTime
    if ( $Ticket->{PendingTime} ) {
        if ( !$Self->ValidatePendingTime( %{$Ticket} ) ) {
            return {
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Ticket->PendingTime parameter is invalid!",
            };
        }
    }

    # if everything is OK then return Success
    return {
        Success => 1,
        }
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
                ErrorCode    => 'TicketCreate.MissingParameter',
                ErrorMessage => "TicketCreate: Article->$Needed parameter is missing!",
            };
        }
    }

    # check Article->AutoResponseType
    if ( !$Article->{AutoResponseType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketCreate: Article->AutoResponseType parameter is required and"
                . " Sysconfig ArticleTypeID setting could not be read!"
        };
    }

    if ( !$Self->ValidateAutoResponseType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Article->AutoResponseType parameter is invalid!",
        };
    }

    # check Article->ArticleType
    if ( !$Article->{ArticleTypeID} && !$Article->{ArticleType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketCreate: Article->ArticleTypeID or Article->ArticleType parameter"
                . " is required and Sysconfig ArticleTypeID setting could not be read!"
        };
    }
    if ( !$Self->ValidateArticleType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Article->ArticleTypeID or Article->ArticleType parameter"
                . " is invalid!",
        };
    }

    # check Article->SenderType
    if ( !$Article->{SenderTypeID} && !$Article->{SenderType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketCreate: Article->SenderTypeID or Article->SenderType parameter"
                . " is required and Sysconfig SenderTypeID setting could not be read!"
        };
    }
    if ( !$Self->ValidateSenderType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Article->SenderTypeID or Ticket->SenderType parameter"
                . " is invalid!",
        };
    }

    # check Article->From
    if ( $Article->{From} ) {
        if ( !$Self->ValidateFrom( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Article->From parameter is invalid!",
            };
        }
    }

    # check Article->ContentType vs Article->MimeType and Article->Charset
    if ( !$Article->{ContentType} && !$Article->{MimeType} && !$Article->{Charset} ) {
        return {
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Article->ContentType or Ticket->MimeType and"
                . " Article->Charset parameters are required!",
        };
    }

    if ( $Article->{MimeType} && !$Article->{Charset} ) {
        return {
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Article->Charset is required!",
        };
    }

    if ( $Article->{Charset} && !$Article->{MimeType} ) {
        return {
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Article->MimeType is required!",
        };
    }

    # check Article->MimeType
    if ( $Article->{MimeType} ) {

        $Article->{MimeType} = lc $Article->{MimeType};

        if ( !$Self->ValidateMimeType( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Article->MimeType is invalid!",
            };
        }
    }

    # check Article->MimeType
    if ( $Article->{Charset} ) {

        $Article->{Charset} = lc $Article->{Charset};

        if ( !$Self->ValidateCharset( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Article->Charset is invalid!",
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
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Article->ContentType is invalid!",
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
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Article->ContentType is invalid!",
            };
        }
    }

    # check Article->HistoryType
    if ( !$Article->{HistoryType} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketCreate: Article-> HistoryType is required and Sysconfig"
                . " HistoryType setting could not be read!"
        };
    }
    if ( !$Self->ValidateHistoryType( %{$Article} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Article->HistoryType parameter is invalid!",
        };
    }

    # check Article->HistoryComment
    if ( !$Article->{HistoryComment} ) {

        # return internal server error
        return {
            ErrorMessage => "TicketCreate: Article->HistoryComment is required and Sysconfig"
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
            ErrorCode    => 'TicketCreate.MissingParameter',
            ErrorMessage => "TicketCreate: Article->TimeUnit is required by sysconfig option!",
        };
    }
    if ( $Article->{TimeUnit} ) {
        if ( !$Self->ValidateTimeUnit( %{$Article} ) ) {
            return {
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Article->TimeUnit parameter is invalid!",
            };
        }
    }

    # check Article->NoAgentNotify
    if ( $Article->{NoAgentNotify} && $Article->{NoAgentNotify} ne '1' ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: Article->NoAgent parameter is invalid!",
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
                    ErrorCode    => 'TicketCreate.InvalidParameter',
                    ErrorMessage => "TicketCreate: Article->$Attribute parameter is invalid!",
                };
            }
            else {
                if ( !IsArrayRefWithData( $Article->{$Attribute} ) ) {
                    $Article->{$Attribute} = [ $Article->{$Attribute} ];
                }
                for my $UserID ( @{ $Article->{$Attribute} } ) {
                    if ( !$Self->ValidateUserID( UserID => $UserID ) ) {
                        return {
                            ErrorCode    => 'TicketCreate.InvalidParameter',
                            ErrorMessage => "TicketCreate: Article->$Attribute UserID=$UserID"
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

    # check DynamicField item internally
    for my $Needed (qw(Name Value)) {
        if ( !defined $DynamicField->{$Needed} || !IsStringWithData( $DynamicField->{$Needed} ) ) {
            return {
                ErrorCode    => 'TicketCreate.MissingParameter',
                ErrorMessage => "TicketCreate: DynamicField->$Needed  parameter is missing!",
            };
        }
    }

    # check DynamicField->Name
    if ( !$Self->ValidateDynamicFieldName( %{$DynamicField} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: DynamicField->Name parameter is invalid!",
        };
    }

    # check DynamicField->Value
    if ( !$Self->ValidateDynamicFieldValue( %{$DynamicField} ) ) {
        return {
            ErrorCode    => 'TicketCreate.InvalidParameter',
            ErrorMessage => "TicketCreate: DynamicField->Value parameter is invalid!",
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

    # check attachment item internally
    for my $Needed (qw(Content ContentType Filename)) {
        if ( !$Attachment->{$Needed} ) {
            return {
                ErrorCode    => 'TicketCreate.MissingParameter',
                ErrorMessage => "TicketCreate: Attachment->$Needed  parameter is missing!",
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
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Attachment->ContentType is invalid!",
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
                ErrorCode    => 'TicketCreate.InvalidParameter',
                ErrorMessage => "TicketCreate: Attachment->ContentType is invalid!",
            };
        }
    }

    # if everything is OK then return Success
    return {
        Success => 1,
    };
}

=item _TicketCreate()

creates a ticket with its article and sets dynamic fields and attachments if specified.

    my $Response = $OperationObject->_TicketCreate(
        Ticket       => $Ticket,                  # all ticket parameters
        Article      => $Article,                 # all attachment parameters
        DynamicField => $DynamicField,            # all dynamic field parameters
        Attachment   => $Attachment,             # all attachment parameters
        UserID       => 123,
    );

    returns:

    $Response = {
        Success => 1,                               # if everething is OK
        Data => {
            TicketID     => 123,
            TicketNumber => 'TN3422332',
            ArticleID    => 123,
        }
    }

    $Response = {
        Success      => 0,                         # if unexpected error
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
    }

=cut

sub _TicketCreate {
    my ( $Self, %Param ) = @_;

    my $Ticket           = $Param{Ticket};
    my $Article          = $Param{Article};
    my $DynamicFieldList = $Param{DynamicFieldList};
    my $AttachmentList   = $Param{AttachmentList};

    # get customer information
    # with information will be used to create the ticket if customer is not defined in the
    # database, customer ticket information need to be empty strings
    my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Ticket->{CustomerUser},
    );

    my $CustomerID = $CustomerUserData{UserCustomerID} || '';

    # use user defined CustomerID if defined
    if ( defined $Ticket->{CustomerID} && $Ticket->{CustomerID} ne '' ) {
        $CustomerID = $Ticket->{CustomerID};
    }

    # get database object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my $OwnerID;
    if ( $Ticket->{Owner} && !$Ticket->{OwnerID} ) {
        my %OwnerData = $UserObject->GetUserData(
            User => $Ticket->{Owner},
        );
        $OwnerID = $OwnerData{UserID};
    }
    elsif ( defined $Ticket->{OwnerID} ) {
        $OwnerID = $Ticket->{OwnerID};
    }

    my $ResponsibleID;
    if ( $Ticket->{Responsible} && !$Ticket->{ResponsibleID} ) {
        my %ResponsibleData = $UserObject->GetUserData(
            User => $Ticket->{Responsible},
        );
        $ResponsibleID = $ResponsibleData{UserID};
    }
    elsif ( defined $Ticket->{ResponsibleID} ) {
        $ResponsibleID = $Ticket->{ResponsibleID};
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # create new ticket
    my $TicketID = $TicketObject->TicketCreate(
        Title        => $Ticket->{Title},
        QueueID      => $Ticket->{QueueID} || '',
        Queue        => $Ticket->{Queue} || '',
        Lock         => 'unlock',
        TypeID       => $Ticket->{TypeID} || '',
        Type         => $Ticket->{Type} || '',
        ServiceID    => $Ticket->{ServiceID} || '',
        Service      => $Ticket->{Service} || '',
        SLAID        => $Ticket->{SLAID} || '',
        SLA          => $Ticket->{SLA} || '',
        StateID      => $Ticket->{StateID} || '',
        State        => $Ticket->{State} || '',
        PriorityID   => $Ticket->{PriorityID} || '',
        Priority     => $Ticket->{Priority} || '',
        OwnerID      => 1,
        CustomerNo   => $CustomerID,
        CustomerUser => $CustomerUserData{UserLogin} || '',
        UserID       => $Param{UserID},
    );

    if ( !$TicketID ) {
        return {
            Success      => 0,
            ErrorMessage => 'Ticket could not be created, please contact the system administrator',
        };
    }

    # set lock if specified
    if ( $Ticket->{Lock} || $Ticket->{LockID} ) {
        $TicketObject->TicketLockSet(
            TicketID => $TicketID,
            LockID   => $Ticket->{LockID} || '',
            Lock     => $Ticket->{Lock} || '',
            UserID   => $Param{UserID},
        );
    }

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
            $TicketObject->TicketPendingTimeSet(
                UserID   => $Param{UserID},
                TicketID => $TicketID,
                %{ $Ticket->{PendingTime} },
            );
        }
    }

    # set dynamic fields (only for object type 'ticket')
    if ( IsArrayRefWithData($DynamicFieldList) ) {

        DYNAMICFIELD:
        for my $DynamicField ( @{$DynamicFieldList} ) {
            next DYNAMICFIELD if !$Self->ValidateDynamicFieldObjectType( %{$DynamicField} );

            my $Result = $Self->SetDynamicFieldValue(
                %{$DynamicField},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );

            if ( !$Result->{Success} ) {
                my $ErrorMessage =
                    $Result->{ErrorMessage} || "Dynamic Field $DynamicField->{Name} could not be"
                    . " set, please contact the system administrator";

                return {
                    Success      => 0,
                    ErrorMessage => $ErrorMessage,
                };
            }
        }
    }

    if ( !defined $Article->{NoAgentNotify} ) {

        # check if new owner is given (then send no agent notify)
        $Article->{NoAgentNotify} = 0;
        if ($OwnerID) {
            $Article->{NoAgentNotify} = 1;
        }
    }

    # set Article From
    my $From;
    if ( $Article->{From} ) {
        $From = $Article->{From};
    }

    # use data from customer user (if customer user is in database)
    elsif ( IsHashRefWithData( \%CustomerUserData ) ) {
        $From = '"' . $CustomerUserData{UserFirstname} . ' ' . $CustomerUserData{UserLastname} . '"'
            . ' <' . $CustomerUserData{UserEmail} . '>';
    }

    # otherwise use customer user as sent from the request (it should be an email)
    else {
        $From = $Ticket->{CustomerUser};
    }

    # set Article To
    my $To;
    if ( $Ticket->{Queue} ) {
        $To = $Ticket->{Queue};
    }
    else {
        $To = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
            QueueID => $Ticket->{QueueID},
        );
    }

    # create article
    my $ArticleID = $TicketObject->ArticleCreate(
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
            Success      => 0,
            ErrorMessage => 'Article could not be created, please contact the system administrator'
            }
    }

    # set owner (if owner or owner id is given)
    if ($OwnerID) {
        $TicketObject->TicketOwnerSet(
            TicketID  => $TicketID,
            NewUserID => $OwnerID,
            UserID    => $Param{UserID},
        );

        # set lock if no lock was defined
        if ( !$Ticket->{Lock} && !$Ticket->{LockID} ) {
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Param{UserID},
            );
        }
    }

    # else set owner to current agent but do not lock it
    else {
        $TicketObject->TicketOwnerSet(
            TicketID           => $TicketID,
            NewUserID          => $Param{UserID},
            SendNoNotification => 1,
            UserID             => $Param{UserID},
        );
    }

    # set responsible
    if ($ResponsibleID) {
        $TicketObject->TicketResponsibleSet(
            TicketID  => $TicketID,
            NewUserID => $ResponsibleID,
            UserID    => $Param{UserID},
        );
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

    # set dynamic fields (only for object type 'article')
    if ( IsArrayRefWithData($DynamicFieldList) ) {

        DYNAMICFIELD:
        for my $DynamicField ( @{$DynamicFieldList} ) {

            my $IsArticleDynamicField = $Self->ValidateDynamicFieldObjectType(
                %{$DynamicField},
                Article => 1,
            );
            next DYNAMICFIELD if !$IsArticleDynamicField;

            my $Result = $Self->SetDynamicFieldValue(
                %{$DynamicField},
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                UserID    => $Param{UserID},
            );

            if ( !$Result->{Success} ) {
                my $ErrorMessage =
                    $Result->{ErrorMessage} || "Dynamic Field $DynamicField->{Name} could not be"
                    . " set, please contact the system administrator";

                return {
                    Success      => 0,
                    ErrorMessage => $ErrorMessage,
                };
            }
        }
    }

    # set attachments
    if ( IsArrayRefWithData($AttachmentList) ) {

        for my $Attachment ( @{$AttachmentList} ) {
            my $Result = $Self->CreateAttachment(
                Attachment => $Attachment,
                ArticleID  => $ArticleID,
                UserID     => $Param{UserID}
            );

            if ( !$Result->{Success} ) {
                my $ErrorMessage =
                    $Result->{ErrorMessage} || "Attachment could not be created, please contact"
                    . " the system administrator";

                return {
                    Success      => 0,
                    ErrorMessage => $ErrorMessage,
                };
            }
        }
    }

    # get ticket data
    my %TicketData = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $Param{UserId},
    );

    if ( !IsHashRefWithData( \%TicketData ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Could not get new ticket information, please contact the system'
                . ' administrator',
            }
    }

    return {
        Success => 1,
        Data    => {
            TicketID     => $TicketID,
            TicketNumber => $TicketData{TicketNumber},
            ArticleID    => $ArticleID,
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
