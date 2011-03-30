# --
# Kernel/GenericInterface/Invoker/SolMan/AddInfo.pm - GenericInterface SolMan AddInfo Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AddInfo.pm,v 1.2 2011-03-30 23:46:17 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::AddInfo;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Invoker::SolMan::SolManCommon;
use Kernel::System::Ticket;
use Kernel::System::CustomerUser;
use Kernel::System::User;
use MIME::Base64;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::AddInfo - GenericInterface SolMan
AddInfo Invoker backend

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
        %{$Self}
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

    # check needed params
    for my $Needed (qw( ArticleID TicketID )) {
        if ( !IsStringWithData( $Param{Data}->{$Needed} ) ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{Data}->{$Needed};
    }

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
    # get it from invoker config
    my $RemoteSystemGuid = $Self->{SolManCommonObject}->GetRemoteSystemGuid(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'AddInfo',
    );

    # otherwise trigger a request to get it from the remote system
    if ( !$RemoteSystemGuid ) {
        my $RequesterSystemGuid     = Kernel::GenericInterface::Requester->new( %{$Self} );
        my $RequestSolManSystemGuid = $RequesterSystemGuid->Run(
            WebserviceID => $Self->{WebserviceID},
            Invoker      => 'RequestSystemGuid',
            Data         => {},
        );

        # forward error message from Requestsystemguid if any and exit
        if ( !$RequestSolManSystemGuid->{Success} || $RequestSolManSystemGuid->{ErrorMessage} ) {
            return {
                Success => 0,
                Data    => $RequestSolManSystemGuid->{ErrorMessage},
            };
        }

        # check SystemGuid data otherwise exit
        if ( !$RequestSolManSystemGuid->{Data}->{SystemGuid} ) {
            return {
                Success => 0,
                Data    => 'Can\'t get SystemGuid',
            };
        }

        $RemoteSystemGuid = $RequestSolManSystemGuid->{Data}->{SystemGuid};
    }

    # local SystemGuid
    my $LocalSystemGuid = $Self->{SolManCommonObject}->GetSystemGuid();

    # IctAdditionalInfos
    my $IctAdditionalInfos = $Self->{SolManCommonObject}->GetAditionalInfo();

    # IctPersons
    my $PersonsInfo = $Self->{SolManCommonObject}->GetPersonsInfo(
        UserID         => $Ticket{OwnerID},
        CustomerUserID => $Ticket{CustomerUserID},
    );
    my $IctPersons;
    if ( IsArrayRefWithData( $PersonsInfo->{IctPersons} ) ) {
        $IctPersons = $PersonsInfo->{IctPersons};
    }

    # set Language from customer
    my $Language = $PersonsInfo->{Language} || 'en';

    # check if ticket has articles
    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
        TicketID => $Self->{TicketID},
    );

    # check if ticket has articles otherwise needs to reschedule
    if ( !scalar @ArticleIDs ) {

        my $DueSystemTime = $Self->{TimeObject}->SystemTime() + 3;
        my $DueTimeStamp  = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $DueSystemTime,
        );

        my $SchedulerObject = Kernel::Scheduler->new( %{$Self} );
        $SchedulerObject->TaskRegister(
            Type => 'GenericInterface',
            Data => {                     # data for task register
                WebserviceID => $Self->{WebserviceID},
                Invoker      => 'ReplicateIncident',

                Data => {                 # data for invoker
                    WebserviceID => $Self->{WebserviceID},
                    TicketID     => $Self->{TicketID},
                },
            },
            DueTime => $DueTimeStamp,
        );

        return {
            Success      => 0,
            ErrorMessage => 'ReplicateIncident task reschedule, no articles found yet',
        };
    }

    my $ArticleInfo = $Self->{SolManCommonObject}->GetArticlesInfo(
        ArticleID => $Self->{ArticleID},
        TicketID  => $Self->{TicketID},
        UserID    => $Ticket{OwnerID},
        Language  => $Language,
    );

    # IctAttachments
    my $IctAttachments;
    if ( IsArrayRefWithData( $ArticleInfo->{IctAttachments} ) ) {
        $IctAttachments = $ArticleInfo->{IctAttachments};
    }

    # IctStatements
    # TODO: $ArticleInfo->{IctStatements} should contains info
    my $IctStatements;
    if ( IsArrayRefWithData( $ArticleInfo->{IctStatements} ) ) {
        $IctStatements = $ArticleInfo->{IctStatements};
    }

    # IctSapNotes
    my $IctSapNotes = $Self->{SolManCommonObject}->GetSapNotesInfo();

    # IctSolutions
    my $IctSolutions = $Self->{SolManCommonObject}->GetSolutionsInfo();

    # IctUrls
    my $IctUrls = $Self->{SolManCommonObject}->GetUrlsInfo();

    # IctTimestamp
    my $IctTimestamp = $Self->{TimeObject}->CurrentTimestamp();
    $IctTimestamp =~ s{[:|\-|\s]}{}g;

    my $IctTimestampEnd = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime() + 1,
    );
    $IctTimestampEnd =~ s{[:|\-|\s]}{}g;

    my %RequestData = (
        IctAdditionalInfos => IsHashRefWithData($IctAdditionalInfos)
        ?
            $IctAdditionalInfos
        : '',
        IctAttachments => IsArrayRefWithData($IctAttachments)
        ?
            { item => $IctAttachments }
        : '',
        IctHead => {
            IncidentGuid     => $Ticket{TicketNumber},              # type="n0:char32"
            RequesterGuid    => $LocalSystemGuid,                   # type="n0:char32"
            ProviderGuid     => $RemoteSystemGuid,                  # type="n0:char32"
            AgentId          => $Ticket{OwnerID},                   # type="n0:char32"
            ReporterId       => $Ticket{CustomerUserID},            # type="n0:char32"
            ShortDescription => substr( $Ticket{Title}, 0, 40 ),    # type="n0:char40"
            Priority         => $Ticket{PriorityID},                # type="n0:char32"
            Language         => $Language,                          # type="n0:char2"
            RequestedBegin   => $IctTimestamp,                      # type="n0:decimal15.0"
            RequestedEnd     => $IctTimestampEnd,                   # type="n0:decimal15.0"
            IctId            => $Ticket{TicketNumber},              # type="n0:char32"
        },
        IctId      => $Ticket{TicketNumber},                        # type="n0:char32"
        IctPersons => IsArrayRefWithData($IctPersons)
        ?
            { item => $IctPersons }
        : '',
        IctSapNotes => IsHashRefWithData($IctSapNotes)
        ?
            $IctSapNotes
        : '',
        IctSolutions => IsHashRefWithData($IctSolutions)
        ?
            $IctSolutions
        : '',
        IctStatements => IsArrayRefWithData($IctStatements)
        ?
            { item => $IctStatements }
        : '',
        IctTimestamp => $IctTimestamp,                # type="n0:decimal15.0"
        IctUrls      => IsHashRefWithData($IctUrls)
        ?
            $IctUrls
        : '',
    );

    return {
        Success => 1,
        Data    => \%RequestData,
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
            ErrorMessage => 'Invoker AddInfo: Response failure!',
        };
    }

    # to store data
    my $Data = $Param{Data};

    if ( !defined $Data->{Errors} ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Invoker AddInfo: Response failure!'
                . 'An Error parameter was expected',
        );
    }

    # if there was an error in the response, forward it
    if ( IsHashRefWithData( $Data->{Errors} ) ) {

        my $HandleErrorsResult = $Self->{SolManCommonObject}->HandleErrors(
            Errors  => $Data->{Errors},
            Invoker => 'AddInfo',
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
        Invoker    => 'AddInfo',
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
        Summary => 'AddInfo return success',
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

$Revision: 1.2 $ $Date: 2011-03-30 23:46:17 $

=cut
