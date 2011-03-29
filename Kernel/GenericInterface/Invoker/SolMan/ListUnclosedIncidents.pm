# --
# Kernel/GenericInterface/Invoker/SolMan/ListUnclosedIncidents.pm - GenericInterface SolMan ListUnclosedIncidents Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ListUnclosedIncidents.pm,v 1.1 2011-03-29 23:22:31 cg Exp $
# $OldId: ListUnclosedIncidents.pm,v 1.7 2011/03/24 06:06:29 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::SolMan::ListUnclosedIncidents;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Invoker::SolMan::SolManCommon;
use Kernel::System::Ticket;
use Kernel::System::CustomerUser;
use Kernel::System::User;
use MIME::Base64;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::SolMan::ListUnclosedIncidents - GenericInterface SolMan
ListUnclosedIncidents Invoker backend

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
        Data => {},
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            SystemGuid  => 'DE86768CD3D015F181D0001438BF50C6',
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # request Systems Guids

    # remote SystemGuid
    my $RequesterSystemGuid     = Kernel::GenericInterface::Requester->new( %{$Self} );
    my $RequestSolManSystemGuid = $RequesterSystemGuid->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'RequestSystemGuid',
        Data         => {},
    );

    # forward error message from Requestsystemguid if any
    if ( !$RequestSolManSystemGuid->{Success} || $RequestSolManSystemGuid->{ErrorMessage} ) {
        return {
            Success => 0,
            Data    => $RequestSolManSystemGuid->{ErrorMessage},
        };
    }

    if ( !$RequestSolManSystemGuid->{Data}->{SystemGuid} ) {
        return {
            Success => 0,
            Data    => 'Can\'t get SystemGuid',
        };
    }

    my $RemoteSystemGuid = $RequestSolManSystemGuid->{Data}->{SystemGuid};

    my %DataForReturn = (
        SystemGuid     => $RemoteSystemGuid,               # type="n0:char32"
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
            Incidents =>  {
                item => {
                  IncidentGuid => '2011032210000012',
                  ProviderGuid => 'D3D9446802A44259755D38E6D163E820',
                  RequesterGuid => 'D3D9446802A44259755D38E6D163E820',
                  Status => 'RP'
                },
                ...
            },
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

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            Incidents => [
                {
                  IncidentGuid => '2011032210000012',
                  ProviderGuid => 'D3D9446802A44259755D38E6D163E820',
                  RequesterGuid => 'D3D9446802A44259755D38E6D163E820',
                  Status => 'RP'
                },
                ...
            ],
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # break early if response was not successfull
    if ( !$Param{ResponseSuccess} ) {
        return {
            Success      => 0,
            ErrorMessage => 'Invoker ListUnclosedIncidents: Response failure!',
        };
    }

    # to store data
    my $Data = $Param{Data};

    if ( !defined $Data->{Errors} ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Invoker ListUnclosedIncidents: Response failure!'
                . 'An Error parameter was expected',
        );
    }

    # if there was an error in the response, forward it
    if ( IsHashRefWithData( $Data->{Errors} ) ) {

        my $HandleErrorsResult = $Self->{SolManCommonObject}->HandleErrors(
            Errors  => $Data->{Errors},
            Invoker => 'ListUnclosedIncidents',
        );

        return {
            Success => $HandleErrorsResult->{Success},
            Data    => \$HandleErrorsResult->{ErrorMessage},
        };
    }

    # response should have incidents items
    if ( !defined $Param{Data}->{Incidents} ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no Incidents!' );
    }

    # we need a Incident hash from the remote system
    if ( IsString( $Param{Incidents} ) ) {
        return $Self->{DebuggerObject}->Debug(
            Summary => 'Got no Incidents!',
        );
    }

    # local SystemGuid
    my $LocalSystemGuid = $Self->{SolManCommonObject}->GetSystemGuid();

    # to store each incident item
    my @Incidents;

    # to store possible errors
    my $ErrorMessage;

    # check for multimple incidents
    if ( IsArrayRefWithData( $Param{Data}->{Incidents}->{item} ) ) {

        # get all incidents
        for my $Item ( @{ $Param{Data}->{Incidents}->{item} } ) {
            if ( IsHashRefWithData($Item) ) {

                # check for valid data
                if (
                    !IsStringWithData( $Item->{IncidentGuid} )
                    || !IsStringWithData( $Item->{ProviderGuid} )
                    || !IsStringWithData( $Item->{RequesterGuid} )
                    || !IsStringWithData( $Item->{Status} )
                    )
                {

                    $ErrorMessage = 'A needed value is empty';

                    # write in debug log
                    $Self->{DebuggerObject}->Error(
                        Summary => "ListUnclosedIncidents return error",
                        Data    => $ErrorMessage,
                    );

                    return {
                        Success      => 0,
                        ErrorMessage => $ErrorMessage,
                    };
                }
                push @Incidents, $Item
                    if ( $Item->{ProviderGuid} eq $LocalSystemGuid );
            }
        }
    }

    # only one incident
    elsif ( IsHashRefWithData( $Param{Data}->{Incidents}->{item} ) ) {

        # check for valid data
        if (
                !IsStringWithData( $Param{Data}->{Incidents}->{item}->{IncidentGuid} )
                || !IsStringWithData( $Param{Data}->{Incidents}->{item}->{ProviderGuid} )
                || !IsStringWithData( $Param{Data}->{Incidents}->{item}->{RequesterGuid} )
                || !IsStringWithData( $Param{Data}->{Incidents}->{item}->{Status} )
            )
        {

            $ErrorMessage = 'A needed value is empty';

            # write in debug log
            $Self->{DebuggerObject}->Error(
                Summary => "ListUnclosedIncidents return error",
                Data    => $ErrorMessage,
            );

            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
        push @Incidents, $Param{Data}->{Incidents}->{item}
                    if ( $Param{Data}->{Incidents}->{item}->{ProviderGuid} eq $LocalSystemGuid );
    }

    # create return data
    my %ReturnData = (
        Incidents   => \@Incidents,
    );

    # write in debug log
    $Self->{DebuggerObject}->Info(
        Summary => 'ListUnclosedIncidents return success',
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

$Revision: 1.1 $ $Date: 2011-03-29 23:22:31 $

=cut
