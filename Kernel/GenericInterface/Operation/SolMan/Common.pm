# --
# Kernel/GenericInterface/Operation/SolMan/Common.pm - SolMan common operation functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.12 2011-04-14 09:05:51 mg Exp $
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

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

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
        ErrorMessage    => '',                      # in case of error
        Data            => {                        # result data payload after Operation
            PrdIctId   => '2011032400001',          # Incident number in the provider (help desk system) / type="n0:char32"
            PersonMaps => {                         # Mapping of person IDs / tns:IctPersonMaps
                Item => {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
            },
            Errors => {                         # should not return errors
                item => {
                    ErrorCode => '01'
                    Val1      =>  'Error Description',
                    Val2      =>  'Error Detail 1',
                    Val3      =>  'Error Detail 2',
                    Val4      =>  'Error Detail 3',

                },
            },
        },
    };

=cut

sub TicketSync {
    my ( $Self, %Param ) = @_;

    if ( !IsStringWithData( $Param{Operation} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no Data' );
    }

    # we need Data
    if ( !IsHashRefWithData( $Param{Data} ) ) {

        #QA: implement proper error handling with <Errors> instead

        return $Self->{DebuggerObject}->Error( Summary => 'Got no Data' );
    }

    # check needed data
    for my $Key (qw(IctHead)) {
        if ( !IsHashRefWithData( $Param{Data}->{$Key} ) ) {
            return $Self->{DebuggerObject}->Error( Summary => "Got no Data->$Key" );
        }
    }

    for my $Key (qw(IncidentGuid ProviderGuid RequesterGuid)) {
        if ( !IsStringWithData( $Param{Data}->{IctHead}->{$Key} ) ) {
            return $Self->{DebuggerObject}->Error( Summary => "Got no Data->IctHead->$Key" );
        }
    }

#QA: add check if ProviderGuid or RequesterGuid matches our SystemGuid and the other value matches the SystemGuid from the operation config
#QA: i think we should use get the remote SystemGuid dynamically at some point, but for now please use $Webservice->{Config}->{Requester}->{Operation}->{ $Param{Operation} }->{RemoteSystemGuid};

    #    for my $Key (qw(IctTimestamp)) {
    #        if ( !IsStringWithData( $Param{Data}->{$Key} ) ) {
    #            return $Self->{DebuggerObject}->Error( Summary => "Got no Data->$Key" );
    #        }
    #    }

    my $TicketID;

    my $IncidentGuidTicketFlagName = "GI_$Self->{WebserviceID}_SolMan_IncidentGuid";

    #QA: can be removed - will be done in mapping layer
    my %PrioritySolMan2OTRS = (
        1 => '5 very high',
        2 => '4 high',
        3 => '3 normal',
        4 => '2 low',
    );

    #QA: default will be supplied by mapping
    my $TargetPriority = $PrioritySolMan2OTRS{ $Param{Data}->{IctHead}->{Priority} || 3 };

    #QA: add person mapping

    if ( $Param{Operation} eq 'ProcessIncident' || $Param{Operation} eq 'ReplicateIncident' ) {

#QA: use default for queue from operation (like RemoteSystemGuid)
#QA: defaults for state will be supplied from mapping layer (AddInfoValue from $Param{Data}->{IctAdditionalInfos}->[item]->{AddInfoAttribute} = 'SAPUserStatus')
#QA: if we have an AgentId, we should use it as owner
#QA: replace values for CustomerNo and CustomerUser with values from person mapping (if ReporterId is set)
# create ticket
        $TicketID = $Self->{TicketObject}->TicketCreate(
            Title => $Param{Data}->{IctHead}->{ShortDescription} || '',
            Queue => 'Raw',
            Lock  => 'unlock',
            Priority     => $TargetPriority,
            State        => 'open',
            CustomerNo   => $Param{Data}->{IctHead}->{ReporterId},
            CustomerUser => $Param{Data}->{IctHead}->{ReporterId},
            OwnerID      => 1,
            UserID       => 1,
        );
        if ( !$TicketID ) {

#QA: please test - this does not seem to work (if TicketCreate throws an error, DebuggerObject complains about missing Summary)
            return $Self->{DebuggerObject}->Error(
                Summary => $Self->{LogObject}->GetLogEntry(
                    Type => 'error',
                    What => 'message',
                ),
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
            return $Self->{DebuggerObject}->Error(
                Summary =>
                    "Could not find ticket for IncidentGuid $Param{Data}->{IctHead}->{IncidentGuid}"
            );
        }

        $TicketID = $Tickets[0];

        #QA: title and priority will be passed on every request - compare and update if necessary
        #QA: also ReporterId and AgentId will be passed every time - compare and update as well
        # update fields if neccessary
        if ( $Param{Data}->{IctHead}->{ShortDescription} ) {
            my $Success = $Self->{TicketObject}->TicketTitleUpdate(
                Title    => $Param{Data}->{IctHead}->{ShortDescription},
                TicketID => $TicketID,
                UserID   => 1,
            );

            if ( !$Success ) {
                return $Self->{DebuggerObject}->Error(
                    Summary => "Could not update ticket title!",
                );
            }
        }

        if ( $Param{Data}->{IctHead}->{Priority} ) {
            my $Success = $Self->{TicketObject}->TicketPrioritySet(
                TicketID => $TicketID,
                Priority => $TargetPriority,
                UserID   => 1,
            );

            if ( !$Success ) {
                return $Self->{DebuggerObject}->Error(
                    Summary => "Could not update ticket priority!",
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
            next if ref $Statement->{Texts}->{item} ne 'ARRAY';

            #QA: use person mapping, if no person id is passed, use empty parentheses
            # construct the text body from multiple item nodes
            my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $Statement->{Timestamp}
                =~ m/^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/smx;
            my $Body = "($Statement->{PersonId}) $Day.$Month.$Year $Hour:$Minute:$Second\n";
            $Body .= join "\n", @{ $Statement->{Texts}->{item} };

#QA: use TextType as article type (is converted in mapping layer), use proper sender type based on person type (or 'system' if no person is passed), set From accordingly
            my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
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
                return $Self->{DebuggerObject}->Error(
                    Summary => $Self->{LogObject}->GetLogEntry(
                        Type => 'error',
                        What => 'message',
                    ),
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
                        HistoryComment => 'Update from SolMan',
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
            }

        }
    }

    if ( $Param{Operation} eq 'CloseIncident' ) {

#QA: default close state will be supplied from operation  ($Webservice->{Config}->{Requester}->{Operation}->{ $Param{Operation} }->{CloseState};)
# close ticket
        my $Success = $Self->{TicketObject}->TicketStateSet(
            State    => 'closed successful',
            TicketID => $TicketID,
            UserID   => 1,
        );

        if ( !$Success ) {
            return $Self->{DebuggerObject}->Error(
                Summary => "Could not close ticket!",
            );
        }
    }

    my $ReturnData = {
        Errors  => '',
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.12 $ $Date: 2011-04-14 09:05:51 $

=cut
