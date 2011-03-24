# --
# Kernel/GenericInterface/Invoker/SolMan/ReplicateIncident.pm - GenericInterface SolMan ReplicateIncident Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.pm,v 1.8 2011-03-24 10:35:51 mg Exp $
# $OldId: ReplicateIncident.pm,v 1.7 2011/03/24 06:06:29 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::ReplicateIncident;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Invoker::SolMan::SolManCommon;
use Kernel::System::Ticket;
use Kernel::System::CustomerUser;
use Kernel::System::User;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::ReplicateIncident - GenericInterface SolMan
ReplicateIncident Invoker backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Invoker->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (
        qw(
        DebuggerObject MainObject ConfigObject EncodeObject
        LogObject TimeObject DBObject WebserviceID
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

    # create additional objects
    $Self->{SolManCommonObject} = Kernel::GenericInterface::Invoker::SolMan::SolManCommon->new(
        %{$Self},
    );

    # create Ticket Object
    $Self->{TicketObject} = Kernel::System::Ticket->new(
        %{$Self},
    );

    # create CustomerUser Object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(
        %{$Self},
    );

    # create CustomerUser Object
    $Self->{UserObject} = Kernel::System::User->new(
        %{$Self},
    );

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        TicketID => 123 # mandatory
        Data => { }
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            IctAdditionalInfos  => {},
            IctAttachments  => {},
            IctHead  => {},
            IctId   => '',  # type="n0:char32"
            IctPersons  => {},
            IctSapNotes  => {},
            IctSolutions  => {},
            IctStatements  => {},
            IctTimestamp   => '',  # type="n0:decimal15.0"
            IctUrls  => {},
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # we need a ID
    if ( !IsStringWithData( $Param{Data}->{TicketID} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no TicketID' );
    }

    # create Ticket Object
    $Self->{TicketID} = $Param{Data}->{TicketID};

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # compare TicketNumber from Param and from DB
    if ( $Self->{TicketID} ne $Ticket{TicketID} ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Error getting Ticket Data' );
    }

    #    # check all needed stuff about ticket
    #    # ( permissions, locked, etc . . . )

    # request Systems Guids

    # remote SystemGuid
    my $RequesterSystemGuid     = Kernel::GenericInterface::Requester->new( %{$Self} );
    my $RequestSolManSystemGuid = $RequesterSystemGuid->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'RequestSystemGuid',
        Data         => {},
    );
    my $RemoteSystemGuid = $RequestSolManSystemGuid->{Data}->{SystemGuid};

    # local SystemGuid
    my $LocalSystemGuid = $Self->{SolManCommonObject}->GetSystemGuid();

    # IctIncidentAdditionalInfos
    my %IctIncidentAdditionalInfos = (
        IctIncidentAdditionalInfo => {
            Guid             => '',    # type="n0:char32"
            ParentGuid       => '',    # type="n0:char32"
            AddInfoAttribute => '',    # type="n0:char255"
            AddInfoValue     => '',    # type="n0:char255"
        },
    );

    # IctIncidentPersons

    # customer
    my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $Ticket{CustomerUserID},
    );
    my %IctCustomerUser = (
        PersonId    => $CustomerUser{CustomerUserID},    # type="n0:char32"
        PersonIdExt => $CustomerUser{CustomerID},        # type="n0:char32"
        Sex         => '',                               # type="n0:char1"
        FirstName   => $CustomerUser{UserFirstname},     # type="n0:char40"
        LastName    => $CustomerUser{UserLastname},      # type="n0:char40"
        Telephone   => $CustomerUser{UserPhone},         # type="tns:IctPhone"
        MobilePhone => $CustomerUser{UserMobile},        # type="n0:char30"
        Fax         => $CustomerUser{UserFax},           # type="tns:IctFax"
        Email       => $CustomerUser{UserEmail},         # type="n0:char240"
    );

    #    push @IctIncidentPersons,%IctCustomerUser;
    my $Language = $CustomerUser{UserLanguage};

    # agent
    my %AgentData = $Self->{UserObject}->GetUserData(
        UserID => $Ticket{OwnerID},
    );

    my %IctAgentUser = (
        PersonId    => $AgentData{UserID},               # type="n0:char32"
        PersonIdExt => $AgentData{UserID},               # type="n0:char32"
        Sex         => '',                               # type="n0:char1"
        FirstName   => $AgentData{UserFirstname},        # type="n0:char40"
        LastName    => $AgentData{UserLastname},         # type="n0:char40"
        Telephone   => '',                               # type="tns:IctPhone"
        MobilePhone => '',                               # type="n0:char30"
        Fax         => '',                               # type="tns:IctFax"
        Email       => $AgentData{UserEmail},            # type="n0:char240"
    );

    #    push @IctIncidentPersons,%IctAgentUser;
    my %IctIncidentPersons = (
        customer => \%IctCustomerUser,
        agent    => \%IctAgentUser,
    );

    # IctIncidentAttachments
    my %IctIncidentAttachments = (
        IctIncidentAttachment => {
            AttachmentGuid => '',                        # type="n0:char32"
            Filename       => '',                        # type="xsd:string"
            MimeType       => '',                        # type="n0:char128"
            Data           => '',                        # type="xsd:base64Binary"
            Timestamp      => '',                        # type="n0:decimal15.0"
            PersonId       => '',                        # type="n0:char32"
            Url            => '',                        # type="n0:char4096"
            Language       => '',                        # type="n0:char2"
            Delete         => '',                        # type="n0:char1"
        },
    );

    # IctIncidentSapNotes
    my %IctIncidentSapNotes = (
        IctIncidentSapNote => {
            NoteId          => '',                       # type="n0:char30"
            NoteDescription => '',                       # type="n0:char60"
            Timestamp       => '',                       # type="n0:decimal15.0"
            PersonId        => '',                       # type="n0:char32"
            Url             => '',                       # type="n0:char4096"
            Language        => '',                       # type="n0:char2"
            Delete          => '',                       # type="n0:char1"
        },
    );

    # IctIncidentSolutions
    my %IctIncidentSolutions = (
        IctIncidentSolution => {
            SolutionId          => '',                   # type="n0:char32"
            SolutionDescription => '',                   # type="n0:char60"
            Timestamp           => '',                   # type="n0:decimal15.0"
            PersonId            => '',                   # type="n0:char32"
            Url                 => '',                   # type="n0:char4096"
            Language            => '',                   # type="n0:char2"
            Delete              => '',                   # type="n0:char1"
        },
    );

    # IctIncidentStatements
    my %IctIncidentStatements = (
        IctIncidentStatement => {
            TextType  => '',                             # type="n0:char32"
            Texts     => '',                             # type="tns:IctIncidentTexts"
            Timestamp => '',                             # type="n0:decimal15.0"
            PersonId  => '',                             # type="n0:char32"
            Language  => '',                             # type="n0:char2"
        },
    );

    # IctIncidentUrls
    my %IctIncidentUrls = (
        IctIncidentUrl => {
            UrlGuid        => '',                        # type="n0:char32"
            Url            => '',                        # type="n0:char4096"
            UrlName        => '',                        # type="n0:char40"
            UrlDescription => '',                        # type="n0:char64"
            Timestamp      => '',                        # type="n0:decimal15.0"
            PersonId       => '',                        # type="n0:char32"
            Language       => '',                        # type="n0:char2"
            Delete         => '',                        # type="n0:char1"
        },
    );

    # IctTimestamp
    my $TimeStamp = $Self->{TimeObject}->CurrentTimestamp();
    $TimeStamp =~ s/[:|\-|\s]//g;

    my %DataForReturn = (
        IctId           => $Ticket{TicketID},        # type="n0:char32"
        IctTimestamp    => $TimeStamp,               # type="n0:decimal15.0"
        IctIncidentHead => {
            IncidentGuid     => $Ticket{TicketNumber},    # type="n0:char32"
            RequesterGuid    => $LocalSystemGuid,         # type="n0:char32"
            ProviderGuid     => $RemoteSystemGuid,        # type="n0:char32"
            AgentId          => $Ticket{OwnerID},         # type="n0:char32"
            ReporterId       => $Ticket{CustomerID},      # type="n0:char32"
            ShortDescription => $Ticket{Title},           # type="n0:char40"
            Priority         => $Ticket{PriorityID},      # type="n0:char32"
            Language         => $Language,                # type="n0:char2"
            RequestedBegin   => '',                       # type="n0:decimal15.0"
            RequestedEnd     => '',                       # type="n0:decimal15.0"
        },
        IctIncidentAdditionalInfos => \%IctIncidentAdditionalInfos,
        IctIncidentAttachments     => \%IctIncidentAttachments,
        IctIncidentPersons         => \%IctIncidentPersons,
        IctIncidentSapNotes        => \%IctIncidentSapNotes,
        IctIncidentSolutions       => \%IctIncidentSolutions,
        IctIncidentStatements      => \%IctIncidentStatements,
        IctIncidentUrls            => \%IctIncidentUrls,
    );
    return {
        Success => 1,
        Data    => \%DataForReturn,
    };
}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            PersonMaps => {
                Item => {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                }
            },
            PrdIctId => '0000000000001',
            Errors     => {
                item => {
                    ErrorCode => '01'
                    Val1      =>  'Error Description',
                    Val2      =>  'Error Detail 1',
                    Val3      =>  'Error Detail 2',
                    Val4      =>  'Error Detail 3',

                }
            }
        },
    );

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            PersonMaps => {
                Item => [
                    {
                        PersonId    => '0001',
                        PersonIdExt => '5050',
                    },
                    {
                        PersonId    => '0002',
                        PersonIdExt => '5051',
                    },
                ],
            }
            PrdIctId => '0000000000001',
            Errors     => {
                item => [
                    {
                        ErrorCode => '01'
                        Val1      =>  'Error Description',
                        Val2      =>  'Error Detail 1',
                        Val3      =>  'Error Detail 2',
                        Val4      =>  'Error Detail 3',
                    },
                    {
                        ErrorCode => '04'
                        Val1      =>  'Error Description',
                        Val2      =>  'Error Detail 1',
                        Val3      =>  'Error Detail 2',
                        Val4      =>  'Error Detail 3',
                    },
                ],
            }
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            PersonMaps => [
                {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
                {
                    PersonId    => '0002',
                    PersonIdExt => '5051',
                },
            ],
            PrdIctId   => '0000000000001',
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # break early if response was not successfull
    if ( !$Param{ResponseSuccess} ) {
        return {
            Success      => 0,
            ErrorMessage => 'Invoker ReplicateIncident: Response failure!',
        };
    }

    # to store data
    my $Data = $Param{Data};

    if ( !defined $Data->{Errors} ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Invoker ReplicateIncident: Response failure!'
                . 'An Error parameter was expected',
        );
    }

    # if there was an error in the response, forward it
    if ( IsHashRefWithData( $Data->{Errors} ) ) {

        my $HandleErrorsResult = $Self->{SolManCommonObject}->HandleErrors(
            Errors  => $Data->{Errors},
            Invoker => 'ReplicateIncident',
        );

        return {
            Success => $HandleErrorsResult->{Success},
            Data    => \$HandleErrorsResult->{ErrorMessage},
        };
    }

    # we need a Incident Identifier from the remote system
    if ( !IsStringWithData( $Param{Data}->{PrdIctId} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no PrdIctId!' );
    }

    # response should have a person maps and it sould be empty
    if ( !defined $Param{Data}->{PersonMaps} ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no PersonMaps!' );
    }

    # handle the person maps
    my $HandlePersonMaps = $Self->{SolManCommonObject}->HandlePersonMaps(
        Invoker    => 'ReplicateIncident',
        PersonMaps => $Param{Data}->{PersonMaps},
    );

    # forward error if any
    if ( !$HandlePersonMaps->{Success} ) {
        return {
            Success => 0,
            Data    => \$HandlePersonMaps->{ErrorMessage},
        };
    }

    # create return data
    my %ReturnData = (
        PrdIctId   => $Param{Data}->{PrdIctId},
        PersonMaps => $HandlePersonMaps->{PersonMaps},
    );

    # write in debug log
    $Self->{DebuggerObject}->Info(
        Summary => 'ReplicateIncident return success',
        Data    => \%ReturnData,
    );

    return {
        Success => 1,
        Data    => \%ReturnData,
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

$Revision: 1.8 $ $Date: 2011-03-24 10:35:51 $

=cut
