# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::PostMaster::Read;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::PostMaster',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Read incoming email from STDIN.');
    $Self->AddOption(
        Name        => 'target-queue',
        Description => "Preselect a target queue by name.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'untrusted',
        Description => "This will cause X-OTRS email headers to be ignored.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'debug',
        Description => "Print debug info to the OTRS log.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Name = $Self->Name();

    if ( $Self->GetOption('debug') ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "OTRS email handle ($Name) started.",
        );
    }
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Debug = $Self->GetOption('debug');

    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Trying to read email from STDIN...",
        );
    }

    # get email from SDTIN
    my @Email = <STDIN>;
    if ( !@Email ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no email on STDIN!',
        );
        return $Self->ExitCodeError(1);
    }

    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Email with " . ( scalar @Email ) . " lines successfully read from STDIN.",
        );
    }

    # Wrap the main part of the script in an "eval" block so that any
    # unexpected (but probably transient) fatal errors (such as the
    # database being unavailable) can be trapped without causing a
    # bounce
    eval {
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::PostMaster' => {
                Email   => \@Email,
                Trusted => $Self->GetOption('untrusted') ? 0 : 1,
                Debug   => $Debug,
            },
        );

        if ($Debug) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Processing email...",
            );
        }

        my @Return = $Kernel::OM->Get('Kernel::System::PostMaster')->Run(
            Queue => $Self->GetOption('target-queue'),
        );

        if ($Debug) {
            my $Dump = $Kernel::OM->Get('Kernel::System::Main')->Dump( \@Return );
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Email processing completed, return data: $Dump",
            );
        }

        if ( !$Return[0] ) {
            die "Can't process mail, see log!\n";
        }
    };

    if ($@) {

        # An unexpected problem occurred (for example, the database was
        # unavailable). Return an EX_TEMPFAIL error to cause the mail
        # program to requeue the message instead of immediately bouncing
        # it; see sysexits.h. Most mail programs will retry an
        # EX_TEMPFAIL delivery for about four days, then bounce the
        # message.)
        my $Message = $@;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );
        return $Self->ExitCodeError(75);
    }

    return $Self->ExitCodeOk();
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    my $Name = $Self->Name();

    if ( $Self->GetOption('debug') ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "OTRS email handle ($Name) stopped.",
        );
    }
}

1;
