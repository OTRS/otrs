# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::AsynchronousExecutor;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Scheduler',
);

=head1 NAME

Kernel::System::AsynchronousExecutor - base class to delegate tasks to the OTRS Scheduler Daemon

=head1 DESCRIPTION

ObjectManager controlled modules can add this base class to execute some time consuming tasks in the
background using the separate process OTRS Scheduler Daemon.

=head1 PUBLIC INTERFACE

=head2 AsyncCall()

creates a scheduler daemon task to execute a function asynchronously.

    my $Success = $Object->AsyncCall(
        ObjectName               => 'Kernel::System::Ticket',   # optional, if not given the object is used from where
                                                                # this function was called
        FunctionName             => 'MyFunction',               # the name of the function to execute
        FunctionParams           => \%MyParams,                 # a ref with the required parameters for the function
        Attempts                 => 3,                          # optional, default: 1, number of tries to lock the
                                                                #   task by the scheduler
        MaximumParallelInstances => 1,                          # optional, default: 0 (unlimited), number of same
                                                                #   function calls from the same object that can be
                                                                #   executed at the the same time
    );

Returns:

    $Success = 1;  # of false in case of an error

=cut

sub AsyncCall {
    my ( $Self, %Param ) = @_;

    # Do not schedule asynchronous task if the feature has been disabled.
    return 1 if $Kernel::OM->Get('Kernel::Config')->Get('DisableAsyncCalls');

    my $FunctionName = $Param{FunctionName};

    if ( !IsStringWithData($FunctionName) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Function needs to be a non empty string!",
        );
        return;
    }

    my $ObjectName = $Param{ObjectName} || ref $Self;

    # create a new object
    my $LocalObject;
    eval {
        $LocalObject = $Kernel::OM->Get($ObjectName);
    };

    # check if is possible to create the object
    if ( !$LocalObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not create $ObjectName object!",
        );

        return;
    }

    # check if object reference is the same as expected
    if ( ref $LocalObject ne $ObjectName ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$ObjectName object is not valid!",
        );
        return;
    }

    # check if the object can execute the function
    if ( !$LocalObject->can($FunctionName) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$ObjectName can not execute $FunctionName()!",
        );
        return;
    }

    if ( $Param{FunctionParams} && !ref $Param{FunctionParams} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "FunctionParams needs to be a hash or list reference.",
        );
        return;
    }

    # define the task name with object name and concatenate the function name
    my $TaskName = substr "$ObjectName-$FunctionName()", 0, 255;

    # create a new task
    my $TaskID = $Kernel::OM->Get('Kernel::System::Scheduler')->TaskAdd(
        Type                     => 'AsynchronousExecutor',
        Name                     => $TaskName,
        Attempts                 => $Param{Attempts} || 1,
        MaximumParallelInstances => $Param{MaximumParallelInstances} || 0,
        Data                     => {
            Object   => $ObjectName,
            Function => $FunctionName,
            Params   => $Param{FunctionParams} // {},
        },
    );

    if ( !$TaskID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not create new AsynchronousExecutor: '$TaskName' task!",
        );
        return;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
