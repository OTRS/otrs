# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron;

use strict;
use warnings;

use IPC::Open3;
use Symbol;

use base qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::Email',
    'Kernel::System::Log',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron - Scheduler daemon task handler module for cron like jobs

=head1 SYNOPSIS

This task handler executes scheduler tasks based in cron notation.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TaskHandlerObject = $Kernel::OM-Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

performs the selected Cron task.

    my $Success = $TaskHandlerObject->Run(
        TaskID   => 123,
        TaskName => 'some name',                                        # optional
        Data     => {
            Module   => 'Kernel::System:::Console:Command::Help',       # Module or Command is mandatory
            Function => 'Execute',                                      # required if module is used
            Command  => '',                                             # command line executable
            Params   => "--force --option 'my option'",                 # space separated parameters
        },
    );

or

    my $Success = $TaskHandlerObject->Run(
        TaskID   => 456,
        TaskName => 'some other name',
        Data => {
            Module   => '',
            Function => '',
            Command  => '/bin/df',
            Params   => '-h',
        },
    );

Returns:

    $Success => 1,  # or fail in case of an error

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed
    for my $Needed (qw(TaskID Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # check data
    if ( ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );

        return;
    }

    if ( !$Param{Data}->{Module} && !$Param{Data}->{Command} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data->{Modue} or Data->{Commad}!",
        );
        return;
    }

    if ( $Param{Data}->{Module} && $Param{Data}->{Command} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data->{Modue} or Data->{Commad} are needed but not both!",
        );
        return;
    }

    if ( $Param{Data}->{Module} && !$Param{Data}->{Function} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data->{Function} is needed!",
        );
        return;
    }

    my $StartSystemTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    my $Success = 1;

    # execute an internal OTRS module
    if ( $Param{Data}->{Module} ) {

        # get module object
        my $ModuleObject;
        eval {
            $ModuleObject = $Kernel::OM->Get( $Param{Data}->{Module} );
        };

        if ( !$ModuleObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can not create a new Object for Module: '$Param{Data}->{Module}'!",
            );

            return;
        }

        my $Function = $Param{Data}->{Function};

        # check if the module provide the required function
        return if !$ModuleObject->can($Function);

        my @Parameters = split / /, $Param{Data}->{Params} || '';

        # to capture the standard error
        my $ErrorMessage;

        my $Result;
        eval {

            # localize the standard error, everything will be restored after the eval block
            local *STDERR;

            # redirect the standard error to a variable
            open STDERR, ">>", \$ErrorMessage;

            # disable ANSI terminal colors for console commands, then in case of an error the output
            #   will be clean
            # prevent used once warning, setting the variable as local and then assign the value
            #   in the next statement
            local $Kernel::System::Console::BaseCommand::SuppressANSI;
            $Kernel::System::Console::BaseCommand::SuppressANSI = 1;

            # run function on the module with the specified parameters in Data->{Params}
            $Result = $ModuleObject->$Function(
                @Parameters,
            );
        };

        # get current system time (as soon as the method has been called)
        my $EndSystemTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

        my $IsConsoleCommand;
        if (
            substr( $Param{Data}->{Module}, 0, length 'Kernel::System::Console' ) eq 'Kernel::System::Console'
            && $Function eq 'Execute'
            )
        {
            $IsConsoleCommand = 1;
        }

        my $ConsoleCommandFailure;

        # console commands send 1 as result if fail
        if ( $IsConsoleCommand && $Result ) {
            $ConsoleCommandFailure = 1;
        }

        # check if there are errors
        if ( $ErrorMessage || $ConsoleCommandFailure ) {

            $ErrorMessage //= '';

            $Self->_HandleError(
                TaskName     => $Param{TaskName},
                TaskType     => 'Cron',
                LogMessage   => "There was an error executing $Function() in $Param{Data}->{Module}: $ErrorMessage",
                ErrorMessage => $ErrorMessage,
            );

            $Success = 0;
        }

        # update worker task
        $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->RecurrentTaskWorkerInfoSet(
            LastWorkerTaskID      => $Param{TaskID},
            LastWorkerStatus      => $Success,
            LastWorkerRunningTime => $EndSystemTime - $StartSystemTime,
        );

        return $Success;
    }

    # otherwise execute an external command
    # replace $OTRSHOME to current home directory
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    $Param{Data}->{Command} =~ s{\$OTRSHOME}{$Home}msx;

    my @Command = ( $Param{Data}->{Command} );

    my @Parameters = split / /, $Param{Data}->{Params} || '';

    @Command = ( @Command, @Parameters );

    # to capture standard in, out and error
    my ( $INFH, $OUTFH, $ERRFH );

    # create a symbol for the error file handle
    $ERRFH = gensym();

    # call the command, capturing output and error
    my $ProcessID;
    eval {
        $ProcessID = open3( $INFH, $OUTFH, $ERRFH, @Command );
    };

    my $ErrorMessage;
    my $ExitCode;

    if ($ProcessID) {

        while (<$ERRFH>) {
            $ErrorMessage .= $_;
        }
        waitpid( $ProcessID, 0 );
        $ExitCode = $? >> 8;
    }
    else {
        $ErrorMessage = $@;
    }

    # get current system time (as soon as the command has been executed)
    my $EndSystemTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    # check if there are errors
    if ( $ErrorMessage || $ExitCode ) {

        $ErrorMessage //= '';

        if ( $ExitCode && !$ErrorMessage ) {
            $ErrorMessage = "$Command[0] execution failed with exit code $ExitCode";
        }

        $Self->_HandleError(
            TaskName     => $Param{TaskName},
            TaskType     => 'Cron',
            LogMessage   => "There was an error executing $Command[0]: $ErrorMessage",
            ErrorMessage => "$ErrorMessage",
        );

        $Success = 0;
    }

    # update worker task
    $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->RecurrentTaskWorkerInfoSet(
        LastWorkerTaskID      => $Param{TaskID},
        LastWorkerStatus      => $Success,
        LastWorkerRunningTime => $EndSystemTime - $StartSystemTime,
    );

    return $Success;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
