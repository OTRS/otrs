# --
# Kernel/GenericInterface/Invoker.pm - GenericInterface Invoker interface
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData);

# prevent 'Used once' warning for Kernel::OM
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker - GenericInterface Invoker interface

=head1 SYNOPSIS

Invokers are responsible to prepare for making a remote web service
request.

For every Request, two methods are called:

=over 4

=item L</PrepareRequest()>

=item L</HandleResponse()>

=back

The first method prepares the response and can prevent it by returning
an error state. The second method must always be called if the request
was initiated to allow the Invoker to handle possible errors.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object.

    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Invoker;

    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig   => {
            DebugThreshold => 'debug',
            TestMode       => 0,           # optional, in testing mode the data will not be written to the DB
            # ...
        },
        WebserviceID      => 12,
        CommunicationType => Requester, # Requester or Provider
        RemoteIP          => 192.168.1.1, # optional
    );
    my $InvokerObject = Kernel::GenericInterface::Invoker->new(
        DebuggerObject     => $DebuggerObject,
        Invoker            => 'TicketLock',            # the name of the invoker in the web service
        InvokerType        => 'Nagios::TicketLock',    # the Invoker backend to use
        WebserviceID       => 1                        # the WebserviceID where the Invoker belongs
                                                       # normally this is passed by the requester
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw( DebuggerObject Invoker InvokerType WebserviceID )) {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    if ( !IsStringWithData( $Param{InvokerType} ) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no Invoker Type as string with value!',
        );
    }

    # load backend module
    my $GenericModule = 'Kernel::GenericInterface::Invoker::' . $Param{InvokerType};
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {

        return $Self->{DebuggerObject}->Error( Summary => "Can't load invoker backend module!" );
    }
    $Self->{BackendObject} = $GenericModule->new( %{$Self} );

    # pass back error message from backend if backend module could not be executed
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $GenericModule;

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

    $Result = {
        Success           => 1,                 # 0 or 1
        StopCommunication => 1,                 # in case of is not needed to continue with the
                                                # request (do nothing just exist gracefully)
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # check data - only accept undef or hash ref
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash ref in Invoker handler (PrepareRequest)!'
        );
    }

    # start map on backend
    return $Self->{BackendObject}->PrepareRequest(%Param);

}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # check data - only accept undef or hash ref
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash ref in Invoker handler (HandleResponse)!'
        );
    }

    # start map on backend
    return $Self->{BackendObject}->HandleResponse(%Param);

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
