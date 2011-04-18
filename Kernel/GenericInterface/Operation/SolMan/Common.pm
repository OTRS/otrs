# --
# Kernel/GenericInterface/Operation/SolMan/Common.pm - SolMan common operation functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.22 2011-04-18 14:28:23 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::SolMan::Common;

use strict;
use warnings;

use MIME::Base64();
use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);

use Kernel::System::Ticket;
use Kernel::System::CustomerUser;
use Kernel::System::User;
use Kernel::System::GenericInterface::Webservice;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::SolMan::Common - common operation functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Operation::SolMan::Common;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SolManCommonObject = Kernel::GenericInterface::Operation::SolMan::Common->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw( DebuggerObject MainObject TimeObject ConfigObject LogObject DBObject EncodeObject WebserviceID)
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

    $Self->{TicketObject}       = Kernel::System::Ticket->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );

    $Self->{WebserviceObject}
        = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    $Self->{Webservice} = $Self->{WebserviceObject}->WebserviceGet(
        ID => $Param{WebserviceID},
    );

    if ( !IsHashRefWithData( $Self->{Webservice} ) ) {
        return $Self->_ReturnError(
            ErrorCode => '09',
            ErrorMessage =>
                'Could not determine Webservice configuration in Kernel::GenericInterface::Operation::SolMan::Common::new()',
        );
    }

    return $Self;
}

=item TicketSync()

Create/Update a local ticket.

    my $Result = $OperationObject->TicketSync(
        Operation => 'ReplicateIncident', # ProcessIncident, ReplicateIncident, AddInfo or CloseIncident
        Data => {
            IctAdditionalInfos  => {},
            IctAttachments      => {},
            IctHead             => {},
            IctId               => '',  # type="n0:char32"
            IctPersons          => {},
            IctSapNotes         => {},
            IctSolutions        => {},
            IctStatements       => {},
            IctTimestamp        => '',  # type="n0:decimal15.0"
            IctUrls             => {},
        },
    );

    $Result = {
        Success         => 1,                       # 0 or 1
        ErrorMessage    => '',                      # In case of an error
        Data            => {                        # result data payload after Operation
            PrdIctId   => '2011032400001',          # Incident number in the provider (help desk system) / type="n0:char32"
            PersonMaps => {                         # Mapping of person IDs / tns:IctPersonMaps
                Item => {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
            },
            Errors => {                             # In case of an error
                item => [
                    {
                        ErrorCode => '01'
                        Val1      =>  'Error Description',
                        Val2      =>  'Error Detail 1',
                        Val3      =>  'Error Detail 2',
                        Val4      =>  'Error Detail 3',

                    },
                ],
            },
        },
    };

=cut

sub TicketSync {
    my ( $Self, %Param ) = @_;

    if ( !IsStringWithData( $Param{Operation} ) ) {
        return $Self->_ReturnError(
            ErrorCode => '09',
            ErrorMessage =>
                'Got no Data in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()',
        );
    }

    # we need Data
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->_ReturnError(
            ErrorCode => '09',
            ErrorMessage =>
                'Got no Data in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()',
        );
    }

    # check needed data
    for my $Key (qw(IctHead)) {
        if ( !IsHashRefWithData( $Param{Data}->{$Key} ) ) {
            return $Self->_ReturnError(
                ErrorCode => '09',
                ErrorMessage =>
                    "Got no Data->$Key in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
            );
        }
    }

    for my $Key (qw(IncidentGuid ProviderGuid RequesterGuid)) {
        if ( !IsStringWithData( $Param{Data}->{IctHead}->{$Key} ) ) {
            return $Self->_ReturnError(
                ErrorCode => '09',
                ErrorMessage =>
                    "Got no Data->IctHead->$Key in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
            );
        }
    }

    # Check if RequesterGuid and ProviderGuid match remote system guid and local system guid
    my $RemoteSystemGuid
        = $Self->{Webservice}->{Config}->{Provider}->{Operation}->{ $Param{Operation} }
        ->{RemoteSystemGuid};
    my $LocalSystemGuid = $Self->LocalSystemGuid();
    my $ProviderGuid    = $Param{Data}->{IctHead}->{ProviderGuid};
    my $RequesterGuid   = $Param{Data}->{IctHead}->{RequesterGuid};
    if (
        (
            $RemoteSystemGuid ne $ProviderGuid
            && $RemoteSystemGuid ne $RequesterGuid
        )
        ||
        (
            $RemoteSystemGuid eq $ProviderGuid
            && $LocalSystemGuid ne $RequesterGuid
        )
        ||
        (
            $RemoteSystemGuid eq $RequesterGuid
            && $LocalSystemGuid ne $ProviderGuid
        )
        )
    {
        return $Self->_ReturnError(
            ErrorCode => 9,
            ErrorMessage =>
                "Invalid RequesterGuid $RequesterGuid or ProviderGuid $ProviderGuid in"
                . " Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
        );
    }

    my $TicketID;

    my $IncidentGuidTicketFlagName = "GI_$Self->{WebserviceID}_SolMan_IncidentGuid";

    #QA: add person mapping

    # get state
    my $State;
    if ( IsHashRefWithData( $Param{Data}->{IctAdditionalInfos} ) ) {
        if (
            IsHashRefWithData( $Param{Data}->{IctAdditionalInfos}->{item} )
            && $Param{Data}->{IctAdditionalInfos}->{item}->{AddInfoAttribute} eq 'SAPUserStatus'
            )
        {
            $State = $Param{Data}->{IctAdditionalInfos}->{item}->{AddInfoValue};
        }
        elsif ( IsArrayRefWithData( $Param{Data}->{IctAdditionalInfos}->{item} ) ) {
            ADDINFO:
            for my $AddInfo ( @{ $Param{Data}->{IctAdditionalInfos}->{item} } ) {
                next ADDINFO if $AddInfo->{AddInfoAttribute} ne 'SAPUserStatus';
                $State = $AddInfo->{AddInfoValue};
                last ADDINFO;
            }
        }
    }
    $State ||= 'open';

    if ( $Param{Operation} eq 'ProcessIncident' || $Param{Operation} eq 'ReplicateIncident' ) {

#QA: if we have an AgentId, we should use it as owner
#QA: replace values for CustomerNo and CustomerUser with values from person mapping (if ReporterId is set)

        # create ticket
        my $Queue =
            $Self->{Webservice}->{Config}->{Provider}->{Operation}->{ $Param{Operation} }->{Queue}
            || 'Raw';
        $TicketID = $Self->{TicketObject}->TicketCreate(
            Title => $Param{Data}->{IctHead}->{ShortDescription} || '',
            Queue => $Queue,
            Lock  => 'unlock',
            Priority     => $Param{Data}->{IctHead}->{Priority},     # will be converted by mapping
            State        => $State,
            CustomerNo   => $Param{Data}->{IctHead}->{ReporterId},
            CustomerUser => $Param{Data}->{IctHead}->{ReporterId},
            OwnerID      => 1,
            UserID       => 1,
        );
        if ( !$TicketID ) {

            my $ErrorMessage = $Self->{LogObject}->GetLogEntry(
                Type => 'error',
                What => 'Message',
            );

            return $Self->_ReturnError(
                ErrorCode    => '09',
                ErrorMessage => $ErrorMessage,
            );
        }

        my $Success = $Self->{TicketObject}->TicketFlagSet(
            TicketID => $TicketID,
            Key      => $IncidentGuidTicketFlagName,
            Value    => $Param{Data}->{IctHead}->{IncidentGuid},
            UserID   => 1,
        );
    }
    else {

        # find ticket based on IncidentGuid
        my @Tickets = $Self->{TicketObject}->TicketSearch(
            Result     => 'ARRAY',
            Limit      => 2,
            TicketFlag => {
                $IncidentGuidTicketFlagName => $Param{Data}->{IctHead}->{IncidentGuid},
            },
            UserID     => 1,
            Permission => 'rw',
        );

        # only if exactly one ticket can be found
        if ( scalar @Tickets != 1 ) {

            return $Self->_ReturnError(
                ErrorCode => '09',
                ErrorMessage =>
                    "Could not find ticket for IncidentGuid $Param{Data}->{IctHead}->{IncidentGuid} in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
            );
        }

        $TicketID = $Tickets[0];

        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Now check for the synchronization timestamp. This value indicates when the last
        #   synchronization of the ticket was made. If the ticket was changed in the meantime,
        #   this operation must be rejected.

        my %TicketFlags = $Self->{TicketObject}->TicketFlagGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # get last sync timestamp
        my $LastSync = $TicketFlags{"GI_$Self->{WebserviceID}_SolMan_SyncTimestamp"} || 0;

        my $TicketChanged = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Ticket{Changed},
        );

        my $LastArticleCreated;

        my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
            TicketID => $TicketID,
        );

        if (@ArticleIDs) {

            my %Article = $Self->{TicketObject}->ArticleGet(
                ArticleID => $ArticleIDs[-1],
                UserID    => 1,
            );

            $LastArticleCreated = $Article{IncomingTime};
        }

        if ( $LastSync < $TicketChanged || $LastSync < $LastArticleCreated ) {
            return $Self->_ReturnError(
                ErrorCode => '11',
                ErrorMessage =>
                    "Ticket is not completely synchronized, cannot update at Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
            );
        }

        #QA: ReporterId and AgentId will be passed every time - compare and update as well
        # update fields if neccessary
        if ( $Param{Data}->{IctHead}->{ShortDescription} ne $Ticket{Title} ) {
            my $Success = $Self->{TicketObject}->TicketTitleUpdate(
                Title    => $Param{Data}->{IctHead}->{ShortDescription},
                TicketID => $TicketID,
                UserID   => 1,
            );

            if ( !$Success ) {
                return $Self->_ReturnError(
                    ErrorCode => '09',
                    ErrorMessage =>
                        "Could not update ticket title in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
                );
            }
        }

        if ( $Param{Data}->{IctHead}->{Priority} ne $Ticket{Priority} ) {
            my $Success = $Self->{TicketObject}->TicketPrioritySet(
                TicketID => $TicketID,
                Priority => $Param{Data}->{IctHead}->{Priority},    # will be converted by mapping
                UserID   => 1,
            );

            if ( !$Success ) {
                return $Self->_ReturnError(
                    ErrorCode => '09',
                    ErrorMessage =>
                        "Could not update ticket priority in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
                );
            }
        }

    }

    my $LastArticleID;

    # create articles from IctStatements
    if ( $Param{Data}->{IctStatements} && $Param{Data}->{IctStatements}->{item} ) {

        my @Statements;

        if ( ref $Param{Data}->{IctStatements}->{item} eq 'ARRAY' ) {
            @Statements = @{ $Param{Data}->{IctStatements}->{item} };
        }
        else {
            @Statements = ( $Param{Data}->{IctStatements}->{item} );
        }

        for my $Statement (@Statements) {
            next if !$Statement;
            next if ref $Statement ne 'HASH';
            next if !$Statement->{Texts};
            next if ref $Statement->{Texts} ne 'HASH';
            next if !$Statement->{Texts}->{item};

            my @Items;

            if ( ref $Statement->{Texts}->{item} eq 'ARRAY' ) {
                @Items = @{ $Statement->{Texts}->{item} };
            }
            else {
                @Items = ( $Statement->{Texts}->{item} );
            }

            #QA: use person mapping, if no person id is passed, use empty parentheses
            # construct the text body from multiple item nodes
            my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $Statement->{Timestamp}
                =~ m/^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/smx;
            my $Body = "($Statement->{PersonId}) $Day.$Month.$Year $Hour:$Minute:$Second\n";
            $Body .= join "\n", @Items;

#QA: use proper sender type based on person type (or 'system' if no person is passed), set From accordingly
            my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID    => $TicketID,
                ArticleType => $Statement->{TextType}, # this will be converted in the mapping layer
                SenderType  => 'agent',
                From           => 'Some Agent <email@example.com>',
                Subject        => "IctStatement from SolMan",
                Body           => $Body,
                Charset        => 'utf-8',
                MimeType       => 'text/plain',
                HistoryType    => 'AddNote',
                HistoryComment => 'Update from SolMan',
                UserID         => 1,
            );
            if ( !$ArticleID ) {
                my $ErrorMessage = $Self->{LogObject}->GetLogEntry(
                    Type => 'error',
                    What => 'Message',
                );

                return $Self->_ReturnError(
                    ErrorCode    => '09',
                    ErrorMessage => $ErrorMessage,
                );
            }
            $LastArticleID = $ArticleID;
        }
    }

    # create attachments
    if ( $Param{Data}->{IctAttachments} && $Param{Data}->{IctAttachments}->{item} ) {

        my @Attachments;

        if ( ref $Param{Data}->{IctAttachments}->{item} eq 'ARRAY' ) {
            @Attachments = @{ $Param{Data}->{IctAttachments}->{item} };
        }
        else {
            @Attachments = ( $Param{Data}->{IctAttachments}->{item} );
        }

        for my $Attachment (@Attachments) {

            # should the attachment be created or deleted?
            my $DeleteFlag
                = ( $Attachment->{Delete} ne '' && $Attachment->{Delete} ne ' ' ) ? 1 : 0;

            if ( !$DeleteFlag ) {

                # if no article was created yet, create one to attach attachments to
                if ( !$LastArticleID ) {
                    $LastArticleID = $Self->{TicketObject}->ArticleCreate(
                        TicketID       => $TicketID,
                        ArticleType    => 'note-internal',
                        SenderType     => 'system',
                        From           => '',
                        Subject        => "Attachments from SolMan",
                        Body           => '',
                        Charset        => 'utf-8',
                        MimeType       => 'text/plain',
                        HistoryType    => 'AddNote',
                        HistoryComment => 'Attachments from SolMan',
                        UserID         => 1,
                    );
                }

                my $Success = $Self->{TicketObject}->ArticleWriteAttachment(
                    Content     => MIME::Base64::decode_base64( $Attachment->{Data} ),
                    Filename    => $Attachment->{Filename},
                    ContentType => $Attachment->{MimeType},
                    ArticleID   => $LastArticleID,
                    UserID      => 1,
                );

                if ( !$Success ) {
                    my $ErrorMessage = $Self->{LogObject}->GetLogEntry(
                        Type => 'error',
                        What => 'Message',
                    );

                    return $Self->_ReturnError(
                        ErrorCode    => '09',
                        ErrorMessage => $ErrorMessage,
                    );
                }
            }

        }
    }

    if ( $Param{Operation} eq 'CloseIncident' ) {

        # close ticket, default close state comes from webservice configuration

        my $CloseState
            = $Self->{Webservice}->{Config}->{Provider}->{Operation}->{ $Param{Operation} }
            ->{CloseState};

        my $Success = $Self->{TicketObject}->TicketStateSet(
            State    => $CloseState,
            TicketID => $TicketID,
            UserID   => 1,
        );

        if ( !$Success ) {
            return $Self->_ReturnError(
                ErrorCode => '09',
                ErrorMessage =>
                    "Could not close ticket in Kernel::GenericInterface::Operation::SolMan::Common::TicketSync()",
            );
        }
    }

    # Set synchronization timestamp
    my $SuccessTicketFlagSet = $Self->{TicketObject}->TicketFlagSet(
        TicketID => $TicketID,
        Key      => "GI_$Self->{WebserviceID}_SolMan_SyncTimestamp",
        Value    => $Self->{TimeObject}->SystemTime(),
        UserID   => 1,
    );

    my $ReturnData = {
        Data => {
            Errors     => '',
            PersonMaps => '',
            PrdIctId   => '',
        },
        Success => 1,
    };

    if ( $Param{Operation} eq 'ProcessIncident' || $Param{Operation} eq 'ReplicateIncident' ) {

        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        $ReturnData->{Data}->{PrdIctId} = $Ticket{TicketNumber};
    }

    # return result
    return $ReturnData;
}

=item LocalSystemGuid()

generates a SystemGuid for this system. This will return the SystemID as a MD5 sum in upper case
to match SolMan style.

    my $LocalSystemGuid = $CommonObject->LocalSystemGuid();

=cut

sub LocalSystemGuid {
    my ( $Self, %Param ) = @_;

    # get SystemID
    my $SystemID = $Self->{ConfigObject}->Get('SystemID') || 10;

    # convert SystemID to MD5 string
    my $SystemIDMD5 = $Self->{MainObject}->MD5sum(
        String => $SystemID,
    );

    # conver to upper case to match SolMan style
    return uc $SystemIDMD5;
}

=item _ReturnError()

helper function to return an error message from within TicketSync() in the way
SolMan expects it. See TicketSync() for how the error structure looks like.

    return $CommonObject->_ReturnError(
        ErrorCode => '09',
        ErrorMessage => 'Der Aufruf ist unvollst�ndig oder unerlaubt',
    );

=cut

sub _ReturnError {
    my ( $Self, %Param ) = @_;

    $Self->{DebuggerObject}->Error( Summary => "$Param{ErrorCode}: $Param{ErrorMessage}" );

    return {
        Success      => 0,
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
        Data         => {
            Errors => {
                item => [
                    {
                        ErrorCode => $Param{ErrorCode},
                        Val1      => $Param{ErrorMessage},
                        Val2      => undef,
                        Val3      => undef,
                        Val4      => undef,
                    }
                ],
            },
        },
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.22 $ $Date: 2011-04-18 14:28:23 $

=cut
