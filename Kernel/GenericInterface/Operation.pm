# --
# Kernel/GenericInterface/Operation.pm - GenericInterface operation interface
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

=head1 SYNOPSIS

Operations are called by web service requests from remote
systems.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

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
        OperationType  => 'Ticket::TicketCreate',    # the local operation backend to use
        WebserviceID   => $WebserviceID,             # ID of the currently used web service
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DebuggerObject OperationType WebserviceID)) {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # check operation
    if ( !IsStringWithData( $Param{OperationType} ) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no Operation with content!',
        );
    }

    # load backend module
    my $GenericModule = 'Kernel::GenericInterface::Operation::' . $Param{OperationType};
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => "Can't load operation backend module $GenericModule!"
        );
    }
    $Self->{BackendObject} = $GenericModule->new(
        %{$Self},
    );

    # pass back error message from backend if backend module could not be executed
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $GenericModule;

    return $Self;
}

=item Run()

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

    # start map on backend
    return $Self->{BackendObject}->Run(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
