# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AsynchronousExecutor;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Scheduler',
);

=head1 NAME

Kernel::System::AsynchronousExecutor - base class to delegate tasks to the OTRS Scheduler Daemon

=head1 SYNOPSIS

ObjectManager controlled modules can add this base class to execute some time consuming tasks in the
background using the separate process OTRS Scheduler Daemon.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item AsyncCall()

creates a scheduler daemon task to execute a function asynchronously.

    my $Success = $Object->AsyncCall(
        FunctionName             => 'MyFunction',       # the name of the function to execute
        FunctionParams           => \%MyParams,         # a ref with the required parameters for the function
        Attempts                 => 3,                  # optional, default: 1, number of tries to lock the
                                                        #   task by the scheduler
        MaximumParallelInstances => 1,                  # optional, default: 0 (unlimited), number of same
                                                        #   function calls form the same object that can be
                                                        #   executed at the the same time
    );

Returns:

    $Success = 1;  # of false in case of an error

=cut

sub AsyncCall {
    my ( $Self, %Param ) = @_;

    my $FunctionName = $Param{FunctionName};

    if ( !IsStringWithData($FunctionName) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Function needs to be a non empty string!",
        );
        return;
    }

    my $ObjectName = ref $Self;

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
            Params   => $Param{FunctionParams},
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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
