# --
# Kernel/GenericInterface/Transport.pm - GenericInterface network transport interface
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport;

use strict;
use warnings;

# prevent 'Used once' warning for Kernel::OM
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Transport - GenericInterface network transport interface

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object.

    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Transport;

    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig   => {
            DebugThreshold  => 'debug',
            TestMode        => 0,           # optional, in testing mode the data will not be written to the DB
            # ...
        },
        WebserviceID      => 12,
        CommunicationType => Requester, # Requester or Provider
        RemoteIP          => 192.168.1.1, # optional
    );
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        DebuggerObject => $DebuggerObject,
        TransportConfig => {
            Type => 'HTTP::SOAP',
            Config => {
                ...
            },
        },
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (qw( DebuggerObject TransportConfig)) {
        $Self->{$Needed} = $Param{$Needed} || return {
            Success => 0,
            Summary => "Got no $Needed!",
        };
    }

    # select and instantiate the backend
    my $Backend = 'Kernel::GenericInterface::Transport::' . $Self->{TransportConfig}->{Type};

    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Backend) ) {
        return $Self->{DebuggerObject}->Error( Summary => "Backend $Backend not found." );
    }
    $Self->{BackendObject} = $Backend->new( %{$Self} );

    # if the backend constructor failed, it returns an error hash, pass it on in this case
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $Backend;

    return $Self;
}

=item ProviderProcessRequest()

process an incoming web service request. This function has to read the request data
from from the web server process.

    my $Result = $TransportObject->ProviderProcessRequest();

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Operation       => 'DesiredOperation',  # name of the operation to perform
        Data            => {                    # data payload of request
            ...
        },
    };

=cut

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    my $Result = $Self->{BackendObject}->ProviderProcessRequest(%Param);

    # make sure an operation is provided in success case
    if ( $Result->{Success} && !$Result->{Operation} ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'TransportObject backend did not return an operation',
        );
    }

    return $Result;
}

=item ProviderGenerateResponse()

generate response for an incoming web service request.

    my $Result = $TransportObject->ProviderGenerateResponse(
        Success         => 1,       # 1 or 0
        ErrorMessage    => '',      # in case of an error, optional
        Data            => {        # data payload for response, optional
            ...
        },

    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
    };

=cut

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Success} ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Missing parameter Success.',
        );
    }

    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Data is not a hash reference.',
        );
    }

    return $Self->{BackendObject}->ProviderGenerateResponse(%Param);
}

=item RequesterPerformRequest()

generate an outgoing web service request, receive the response and return its data..

    my $Result = $TransportObject->RequesterPerformRequest(
        Operation       => 'remote_op', # name of remote operation to perform
        Data            => {            # data payload for request
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {
            ...
        },
    };

=cut

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Operation} ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Missing parameter Operation.',
        );
    }

    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Data is not a hash reference.',
        );
    }

    return $Self->{BackendObject}->RequesterPerformRequest(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
