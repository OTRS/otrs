# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## nofilter(TidyAll::Plugin::OTRS::Perl::NoExitInConsoleCommands)

package Kernel::System::Console::Command::Maint::PostMaster::MailAccountFetch;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

use POSIX ":sys_wait_h";
use Time::HiRes qw(sleep);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::MailAccount',
    'Kernel::System::PID',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Fetch incoming emails from configured mail accounts.');
    $Self->AddOption(
        Name        => 'mail-account-id',
        Description => "Fetch mail only from this account (default: fetch from all).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr{^\d+$}smx,
    );
    $Self->AddOption(
        Name        => 'force-pid',
        Description => "Start even if another process is still registered in the database.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'debug',
        Description => "Print debug info to the OTRS log.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name => 'timeout',
        Description =>
            "Timeout in seconds to kill the child process, that does the mail fetching (default: 600).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr{^\d+$}smx,
    );

    return;
}

sub PreRun {
    my ($Self) = @_;

    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

    my $PIDCreated = $PIDObject->PIDCreate(
        Name  => 'MailAccountFetch',
        Force => $Self->GetOption('force-pid'),
        TTL   => 600,                             # 10 minutes
    );
    if ( !$PIDCreated ) {
        my $Error = "Unable to register the process in the database. Is another instance still running?\n";
        $Error .= "You can use --force-pid to override this check.\n";
        die $Error;
    }

    my $Debug = $Self->GetOption('debug');
    my $Name  = $Self->Name();

    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "OTRS email handle ($Name) started.",
        );
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $MailAccountObject = $Kernel::OM->Get('Kernel::System::MailAccount');
    my %List              = $MailAccountObject->MailAccountList( Valid => 1 );

    my $Debug         = $Self->GetOption('debug');
    my $Timeout       = $Self->GetOption('timeout') || 600;
    my $MailAccountID = $Self->GetOption('mail-account-id');

    if ( !%List ) {
        if ($MailAccountID) {
            $Self->PrintError("Could not find mail account $MailAccountID.");
            return $Self->ExitCodeError();
        }

        $Self->Print("\n<yellow>No configured mail accounts found!</yellow>\n\n");
        return $Self->ExitCodeOk();
    }

    # Setup alarm signal handler to kill the running child process if we reach the given timeout.
    local $SIG{ALRM} = sub {
        $Self->PrintError("Timeout of $Timeout seconds reached, killing child process!\n");
        kill 9, $Self->{ChildPID};
    };

    # Set the timeout to kill the child.
    alarm $Timeout;

    # Destroy objects for the child processes.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
        ],
        ForcePackageReload => 0,
    );

    $Self->Print("\n<yellow>Spawning child process to fetch incoming messages from mail accounts...</yellow>\n\n");

    # Create a child process.
    my $PID = fork;

    # Could not create child.
    if ( $PID < 0 ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Unable to fork to a child process for mail account fetching!"
        );
        $Self->PrintError("Unable to fork to a child process for mail account fetching!");

        return $Self->ExitCodeError();
    }

    # We're in the child process.
    if ( !$PID ) {

        my $ErrorCount;
        my $FetchedCount;

        KEY:
        for my $Key ( sort keys %List ) {

            next KEY if ( $MailAccountID && $Key != $MailAccountID );

            my %Data = $MailAccountObject->MailAccountGet( ID => $Key );

            $Self->Print("<yellow>$Data{Host} ($Data{Type})...</yellow>\n");

            # It is needed for capture the standard error.
            my $Status;
            my $ErrorMessage;

            eval {

                # Localize the standard error, everything will be restored after the eval block.
                local *STDERR;

                # Redirect the standard error to a variable.
                open STDERR, ">>", \$ErrorMessage;

                $Status = $MailAccountObject->MailAccountFetch(
                    %Data,
                    Debug  => $Self->GetOption('debug'),
                    CMD    => 1,
                    UserID => 1,
                );
            };

            # Hide password contained in error message and print message back to standard error.
            # Please see bug#12829 for more information.
            if ($ErrorMessage) {
                $ErrorMessage =~ s/\Q$Data{Password}\E/********/g;
                print STDERR $ErrorMessage;
            }

            if ($Status) {
                $FetchedCount++;
            }
            else {
                $ErrorCount++;
            }
        }

        my $ExitCode = $Self->ExitCodeOk();

        if ($ErrorCount) {

            # Error messages printed by backend.
            $ExitCode = $Self->ExitCodeError();
        }

        if ( !$FetchedCount && $MailAccountID ) {
            $Self->PrintError("Could not find mail account $MailAccountID.");
            $ExitCode = $Self->ExitCodeError();
        }

        # Close child process at the end.
        exit $ExitCode;
    }

    # Remember the child process ID.
    $Self->{ChildPID} = $PID;

    # Check the status of the child process every 0.1 seconds.
    #   Wait for the child process to be finished.
    WAIT:
    while (1) {

        last WAIT if !$Self->{ChildPID};

        sleep 0.1;

        my $WaitResult = waitpid( $PID, WNOHANG );

        if ( $WaitResult == -1 ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Child process exited with errors: $?",
            );

            $Self->{ChildPID} = undef;
        }

        $Self->{ChildPID} = undef if $WaitResult;
    }

    alarm 0;

    $Self->Print("<green>Done.</green>\n\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ($Self) = @_;

    # Destroy objects for the child processes.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
        ],
        ForcePackageReload => 0,
    );

    my $Debug = $Self->GetOption('debug');
    my $Name  = $Self->Name();

    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "OTRS email handle ($Name) stopped.",
        );
    }

    return $Kernel::OM->Get('Kernel::System::PID')->PIDDelete( Name => 'MailAccountFetch' );
}

1;
