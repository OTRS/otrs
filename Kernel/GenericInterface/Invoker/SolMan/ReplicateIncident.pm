# --
# Kernel/GenericInterface/Invoker/SolMan/ReplicateIncident.pm - GenericInterface SolMan ReplicateIncident Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.pm,v 1.5 2011-03-23 17:37:54 cg Exp $
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

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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
            ReplicateIncident => {
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
    if ( $Self->{TicketID} ne $Ticket{'TicketID'} ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Error getting Ticket Data' );
    }

    #    # check all needed stuff about ticket
    #    # ( permissions, locked, etc . . . )

    #    # request SystemGuid
    #    my $RequesterSystemGuid  = Kernel::GenericInterface::Requester->new( %{$Self} );
    #    my RequestSolManSystemGuid = $RequesterSystemGuid->Run(
    #        WebserviceID => $Self->{WebserviceID},
    #        Invoker      => 'RequestSystemGuid',
    #        Data         => {},
    #    );
    my %DataForReturn = (
        ReplicateIncident => {
            IctId              => '',    # type="n0:char32"
            IctTimestamp       => '',    # type="n0:decimal15.0"
            IctAdditionalInfos => {
                IctIncidentAdditionalInfo => {
                    Guid             => '',    # type="n0:char32"
                    ParentGuid       => '',    # type="n0:char32"
                    AddInfoAttribute => '',    # type="n0:char255"
                    AddInfoValue     => '',    # type="n0:char255"
                },
            },
            IctAttachments => {
                IctIncidentAttachment => {
                    AttachmentGuid => '',      # type="n0:char32"
                    Filename       => '',      # type="xsd:string"
                    MimeType       => '',      # type="n0:char128"
                    Data           => '',      # type="xsd:base64Binary"
                    Timestamp      => '',      # type="n0:decimal15.0"
                    PersonId       => '',      # type="n0:char32"
                    Url            => '',      # type="n0:char4096"
                    Language       => '',      # type="n0:char2"
                    Delete         => '',      # type="n0:char1"
                },
            },
            IctHead => {
                IncidentGuid     => '',        # type="n0:char32"
                RequesterGuid    => '',        # type="n0:char32"
                ProviderGuid     => '',        # type="n0:char32"
                AgentId          => '',        # type="n0:char32"
                ReporterId       => '',        # type="n0:char32"
                ShortDescription => '',        # type="n0:char40"
                Priority         => '',        # type="n0:char32"
                Language         => '',        # type="n0:char2"
                RequestedBegin   => '',        # type="n0:decimal15.0"
                RequestedEnd     => '',        # type="n0:decimal15.0"
            },
            IctPersons => {
                IctIncidentPerson => {
                    PersonId    => '',         # type="n0:char32"
                    PersonIdExt => '',         # type="n0:char32"
                    Sex         => '',         # type="n0:char1"
                    FirstName   => '',         # type="n0:char40"
                    LastName    => '',         # type="n0:char40"
                    Telephone   => '',         # type="tns:IctPhone"
                    MobilePhone => '',         # type="n0:char30"
                    Fax         => '',         # type="tns:IctFax"
                    Email       => '',         # type="n0:char240"
                },
            },
            IctSapNotes => {
                IctIncidentSapNote => {
                    NoteId          => '',     # type="n0:char30"
                    NoteDescription => '',     # type="n0:char60"
                    Timestamp       => '',     # type="n0:decimal15.0"
                    PersonId        => '',     # type="n0:char32"
                    Url             => '',     # type="n0:char4096"
                    Language        => '',     # type="n0:char2"
                    Delete          => '',     # type="n0:char1"
                },
            },
            IctSolutions => {
                IctIncidentSolution => {
                    SolutionId          => '',    # type="n0:char32"
                    SolutionDescription => '',    # type="n0:char60"
                    Timestamp           => '',    # type="n0:decimal15.0"
                    PersonId            => '',    # type="n0:char32"
                    Url                 => '',    # type="n0:char4096"
                    Language            => '',    # type="n0:char2"
                    Delete              => '',    # type="n0:char1"
                },
            },
            IctStatements => {
                IctIncidentAttachment => {
                    AttachmentGuid => '',         # type="n0:char32"
                    Filename       => '',         # type="xsd:string"
                    MimeType       => '',         # type="n0:char128"
                    Data           => '',         # type="xsd:base64Binary"
                    Timestamp      => '',         # type="n0:decimal15.0"
                    PersonId       => '',         # type="n0:char32"
                    Url            => '',         # type="n0:char4096"
                    Language       => '',         # type="n0:char2"
                    Delete         => '',         # type="n0:char1"
                },
            },
            IctUrls => {
                IctIncidentUrl => {
                    UrlGuid        => '',         # type="n0:char32"
                    Url            => '',         # type="n0:char4096"
                    UrlName        => '',         # type="n0:char40"
                    UrlDescription => '',         # type="n0:char64"
                    Timestamp      => '',         # type="n0:decimal15.0"
                    PersonId       => '',         # type="n0:char32"
                    Language       => '',         # type="n0:char2"
                    Delete         => '',         # type="n0:char1"
                },
            },
        },
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

$Revision: 1.5 $ $Date: 2011-03-23 17:37:54 $

=cut
