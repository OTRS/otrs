# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData);

# prevent 'Used once' warning for Kernel::OM
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation - GenericInterface Operation interface

=head1 DESCRIPTION

Operations are called by web service requests from remote
systems.

=head1 PUBLIC INTERFACE

=head2 new()

create an object.

    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Operation;

    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig   => {
            DebugThreshold => 'debug',
            TestMode       => 0,           # optional, in testing mode the data will not be written to the DB
            # ...
        },
        WebserviceID      => 12,
        CommunicationType => Provider, # Requester or Provider
        RemoteIP          => 192.168.1.1, # optional
    );

    my $OperationObject = Kernel::GenericInterface::Operation->new(
        DebuggerObject => $DebuggerObject,
        Operation      => 'TicketCreate',            # the name of the operation in the web service
        OperationType  => 'Ticket::TicketCreate',    # the local operation backend to use
        WebserviceID   => $WebserviceID,             # ID of the currently used web service
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # Check needed objects.
    for my $Needed (qw(DebuggerObject Operation OperationType WebserviceID)) {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # Check operation.
    if ( !IsStringWithData( $Param{OperationType} ) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no Operation with content!',
        );
    }

    # Load backend module.
    my $GenericModule = 'Kernel::GenericInterface::Operation::' . $Param{OperationType};
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => "Can't load operation backend module $GenericModule!"
        );
    }
    $Self->{BackendObject} = $GenericModule->new(
        %{$Self},
    );

    # Pass back error message from backend if backend module could not be executed.
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $GenericModule;

    return $Self;
}

=head2 Run()

perform the selected Operation.

    my $Result = $OperationObject->Run(
        Data => {                               # data payload before Operation
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # result data payload after Operation
            ...
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Start map on backend,
    return $Self->{BackendObject}->Run(%Param);
}

=head2 HandleError()

handle error data of the configured remote web service.

    my $Result = $OperationObject->HandleError(
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

sub HandleError {
    my ( $Self, %Param ) = @_;

    # Check data - only accept undef or hash ref
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash ref in Operation handler (HandleResponse)!'
        );
    }

    return $Self->{BackendObject}->HandleError(%Param);

}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
