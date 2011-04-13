# --
# Kernel/GenericInterface/Invoker/SolMan/CloseIncident.pm - GenericInterface SolMan CloseIncident Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: CloseIncident.pm,v 1.2 2011-04-13 22:58:42 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::CloseIncident;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Invoker::SolMan::Common;
use Kernel::System::Ticket;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::CloseIncident - GenericInterface SolMan
CloseIncident Invoker backend

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
    $Self->{SolManCommonObject} = Kernel::GenericInterface::Invoker::SolMan::Common->new(
        %{$Self}
    );

    # create Ticket Object
    $Self->{TicketObject} = Kernel::System::Ticket->new(
        %{$Self},
    );

    #    # create CustomerUser Object
    #    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(
    #        %{$Self},
    #    );

    #    # create CustomerUser Object
    #    $Self->{UserObject} = Kernel::System::User->new(
    #        %{$Self},
    #    );

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        TicketID      => 123,              # mandatory
        OldTicketData => \%TicketData,
        Data     => {},
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '...',               # in case of error or undef
        Data            => {                    # data payload after Invoker or undef
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
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    my $ErrorMessage;

    # we need a ticket ID
    if ( !IsStringWithData( $Param{Data}->{TicketID} ) ) {
        $ErrorMessage = 'Got no TicketID';
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # we need the old ticket info
    if ( !IsHashRefWithData( $Param{Data}->{OldTicketID} ) ) {
        $ErrorMessage = 'Invalid old ticket data';
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # set TicketID as global
    $Self->{TicketID} = $Param{Data}->{TicketID};

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # compare TicketNumber from Param and DB
    if ( $Self->{TicketID} ne $Ticket{TicketID} ) {
        $ErrorMessage = 'Error getting Ticket Data';
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }
    my $OldTicketData = $Param{OldTicketData};

    # return if this is not ticket close
    if ( $Ticket{StateType} ne 'closed' ) {
        $ErrorMessage = "this is ticket is not on a closed state but $Ticket{StateType} state, " .
            "CloseIncident Invoker Cancelled";
        $Self->{DebuggerObject}->Debug( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # return if ticket was already closed
    elsif ( $OldTicketData->{StateType} eq 'closed' ) {
        $ErrorMessage = "this is ticket was already in closed state, " .
            "CloseIncident Invoker Cancelled";
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # get closing sync information
    my $ClosedSyncInfo = $Self->{SolManCommonObject}->GetSyncInfo(
        WebserviceID => $Self->{WebserviceID},
        ObjectType   => 'Ticket',
        ObjectID     => $Self->{TicketID},
        Key          => "GI_$Self->{WebserviceID}_SolMan_CloseIncident",
    );

    # check for errors
    if ( !$ClosedSyncInfo->{Success} ) {
        return {
            Success      => 0,
            ErrorMessage => "There was an error processing ticket $Self->{TicketID}"
                . "sync information, can't continue!",
        };
    }

    # check if ticket is already closed on the remote system
    elsif ( $ClosedSyncInfo->{Value} ) {
        $ErrorMessage = "The ticket $Self->{TicketID} is already closed on the remote system!";
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # add closing sync attempt
    my $CloseTicketStatus = $Self->{SolManCommonObject}->GetTicketLockStatus(
        WebserviceID => $Self->{WebserviceID},
        TicketID     => $Self->{TicketID},
        LockState    => 'CloseIncident',
        UserID       => $Ticket{OwnerID},
        SyncKey      => "GI_$Self->{WebserviceID}_SolMan_CloseIncident",
    );
    if ( !$CloseTicketStatus ) {
        $ErrorMessage = "Was not possible to close the ticket: $Self->{TicketID} "
            . "on the remote system";

        # write on debug log
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # get ticket synchronization information to verify that the ticket is already sync to SolMan
    my $TicketSyncInfo = $Self->{SolManCommonObject}->GetSyncInfo(
        WebserviceID => $Self->{WebserviceID},
        ObjectType   => 'Ticket',
        ObjectID     => $Self->{TicketID},
        Key          => "GI_$Self->{WebserviceID}_SolMan_IncidentGuid",
    );

    # check for errors
    if ( !$TicketSyncInfo->{Success} ) {
        return {
            Success      => 0,
            ErrorMessage => "There was an error processing ticket $Self->{TicketID}"
                . "sync information, can't continue!",
        };
    }

    # check if ticket is synced
    elsif ( !$TicketSyncInfo->{Value} ) {
        $ErrorMessage = "The ticket $Self->{TicketID} is not syncronized can't continue!";
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };

        # TODO Should we reschedule here?
    }

    # remote SystemGuid
    # get it from invoker config
    my $RemoteSystemGuid = $Self->{SolManCommonObject}->GetRemoteSystemGuid(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'CloseIncident',
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
                Success      => 0,
                ErrorMessage => $RequestSolManSystemGuid->{ErrorMessage},
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

    # get ticket articles
    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
        TicketID => $Self->{TicketID},
    );

    # if there are no articles quit
    if ( !scalar @ArticleIDs ) {
        $ErrorMessage = "Can't close a ticket without articles";
        $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # check if articles has been synchronized
    ARTICLE:
    for my $ArticleID (@ArticleIDs) {

        my $ArticleSyncInfo = $Self->{SolManCommonObject}->GetSyncInfo(
            WebserviceID => $Self->{WebserviceID},
            ObjectType   => 'Article',
            ObjectID     => $ArticleID,
            Key          => "GI_$Self->{WebserviceID}_SolMan_IncidentGuid"
        );

        next ARTICLE if ( $ArticleSyncInfo->{RemoteTicketID} );

        # check for errors
        if ( !$ArticleSyncInfo->{Success} ) {
            return {
                Success      => 0,
                ErrorMessage => "There was an error processing article $ArticleID"
                    . "sync information, can't continue!",
            };
        }

        # check if article is synced
        elsif ( !$ArticleSyncInfo->{Value} ) {

            # check current sync article status
            my $PossibleToSyncArticle = $Self->{SolManCommonObject}->GetArticleLockStatus(
                WebserviceID => $Self->{WebserviceID},
                TicketID     => $Self->{TicketID},
                ArticleID    => $ArticleID,
                UserID       => $Ticket{OwnerID},
            );
            if ( !$PossibleToSyncArticle ) {
                $ErrorMessage = "Was not possible to sync the article: $Self->{ArticleID}";
                $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
                return {
                    Success      => 0,
                    ErrorMessage => $ErrorMessage,
                };
            }

            # try to sync the article
            my $RequesterAddInfo = Kernel::GenericInterface::Requester->new( %{$Self} );
            $RequesterAddInfo->Run(
                WebserviceID => $Self->{WebserviceID},
                Invoker      => 'AddInfo',
                TicketID     => $Self->{TicketID},
                ArticleID    => $ArticleID,
                Data         => {},
            );

            # not matter if the article try was successful or not is necessary to check again
            # could be that there was a task already (or in process to be ) executed
            my $ArticleSyncInfo = $Self->{SolManCommonObject}->GetSyncInfo(
                WebserviceID => $Self->{WebserviceID},
                ObjectType   => 'Article',
                ObjectID     => $ArticleID,
                Key          => "GI_$Self->{WebserviceID}_SolMan_IncidentGuid",
            );

            if ( !$ArticleSyncInfo->{Value} ) {
                $ErrorMessage = "CloseIncident tries to sync article $ArticleID from ticket"
                    . "$Self->{TicketID} but no article sync info found. CloseIncident can't continue";

                # write in log and exit
                $Self->{DebuggerObject}->Error( Summary => $ErrorMessage );
                return {
                    Success      => 0,
                    ErrorMessage => $ErrorMessage,
                };
            }
        }
    }

    # IctAttachments
    # No statements should be provided since they should be sent on add info
    my $IctAttachments = '';

    # IctStatements
    # No statements should be provided since they should be sent on AddInfo
    my $IctStatements = '';

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

    my $ReturnData = $Self->{SolManCommonObject}->HandleResponse(
        %Param,
    );

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

$Revision: 1.2 $ $Date: 2011-04-13 22:58:42 $

=cut
