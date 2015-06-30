# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Daemon::DaemonModules::Summary;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData);

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Shows a summary of one or all daemon modules.');

    $Self->AddArgument(
        Name        => 'daemon-name',
        Description => "The name of a registered daemon.",
        Required    => 0,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AdditionalHelp(<<"EOF");
If no daemon-name is specified as:

 <green>otrs.console.pl $Self->{Name}</green>

The command will get the summary of all daemon modules available.
EOF

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $DaemonName = $Self->GetArgument('daemon-name');

    # do checks only if a particular daemon module is specified
    if ($DaemonName) {

        my $DaemonModuleConfig = $Kernel::OM->Get('Kernel::Config')->Get('DaemonModules') || {};

        # check if configuration of the daemon is valid
        if (
            !$DaemonModuleConfig->{$DaemonName}
            || ref $DaemonModuleConfig->{$DaemonName} ne 'HASH'
            || !$DaemonModuleConfig->{$DaemonName}->{Module}
            )
        {
            die "Daemon $DaemonName configuration is invalid";
        }

        my $DaemonObject;

        # create daemon object
        eval {
            $DaemonObject = $Kernel::OM->Get( $DaemonModuleConfig->{$DaemonName}->{Module} );
        };

        # check if daemon object is valid
        if ( !$DaemonObject || !$DaemonObject->can("Summary") ) {
            die "Daemon $DaemonName is invalid";
        }
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DaemonName = $Self->GetArgument('daemon-name');

    if ($DaemonName) {
        $Self->Print("<yellow>Gathering '$DaemonName' daemon summary...</yellow>\n\n");
    }
    else {
        $Self->Print("<yellow>Gathering all daemons summary...</yellow>\n\n");
    }

    # get daemon modules from SysConfig
    my $DaemonModuleConfig = $Kernel::OM->Get('Kernel::Config')->Get('DaemonModules') || {};

    my @DaemonSummary;

    MODULE:
    for my $Module ( sort _DaemonSort keys %{$DaemonModuleConfig} ) {

        # skip not well configured modules
        next MODULE if !$Module;
        next MODULE if !$DaemonModuleConfig->{$Module};
        next MODULE if ref $DaemonModuleConfig->{$Module} ne 'HASH';
        next MODULE if !$DaemonModuleConfig->{$Module}->{Module};

        # if a module is specified skip all others
        if ($DaemonName) {
            next MODULE if $Module ne $DaemonName;
        }

        my $DaemonObject;

        # create daemon object
        eval {
            $DaemonObject = $Kernel::OM->Get( $DaemonModuleConfig->{$Module}->{Module} );
        };

        # skip module if object could not be created or does not provide Summary()
        next MODULE if !$DaemonObject;
        next MODULE if !$DaemonObject->can("Summary");

        # execute Summary
        my @Summary;
        eval {
            @Summary = $DaemonObject->Summary();
        };

        # skip if the result is empty or in a wrong format;
        next MODULE if !@Summary;
        next MODULE if ref $Summary[0] ne 'HASH';

        for my $SummaryItem (@Summary) {
            push @DaemonSummary, $SummaryItem;
        }

        # if a module was specified skip all the rest
        if ($DaemonName) {
            last MODULE;
        }
    }

    my $Output = $Self->_FormatOutput(
        DaemonSummary => \@DaemonSummary,
    );

    $Self->Print("$Output");

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub _FormatOutput {
    my ( $Self, %Param ) = @_;

    my @DaemonSummary = @{ $Param{DaemonSummary} };

    my $Output;

    SUMMARY:
    for my $Summary (@DaemonSummary) {

        # set header message
        $Output .= '  ' . $Summary->{Header} . "\n";

        # if there is no data to display, show empty message
        if ( !IsArrayRefWithData( $Summary->{Data} ) ) {
            $Output .= '    ' . ( $Summary->{NoDataMesssage} || '' ) . "\n\n";

            next SUMMARY;
        }

        # output the table header
        $Output .= '    ';
        for my $Column ( @{ $Summary->{Column} } ) {

            my $Size  = $Column->{Size};
            my $Value = $Column->{DisplayName};

            $Output .= ' ' . sprintf '%-*s', $Size, uc $Value;
        }
        $Output .= "\n";

        # output the table body
        for my $DataRow ( @{ $Summary->{Data} } ) {
            $Output .= '    ';
            for my $Column ( @{ $Summary->{Column} } ) {

                my $Size  = $Column->{Size};
                my $Value = $DataRow->{ $Column->{Name} };

                if ( length $Value >= $Size ) {
                    $Value = substr( $Value, 0, $Size - 4 ) . '...';
                }
                $Output .= ' ' . sprintf '%-*s', $Size, $Value;
            }
            $Output .= "\n";
        }
        $Output .= "\n";
    }

    return $Output // '';
}

sub _DaemonSort {

    my %DefaultDaemons = (
        SchedulerFutureTaskManager       => 100,
        SchedulerCronTaskManager         => 110,
        SchedulerGenericAgentTaskManager => 111,
        SchedulerTaskWorker              => 112,
    );

    # other daemons could not be in the  DefaultDaemons sorting hash
    # when comparing 2 external daemons sorting must be alphabetical
    if ( !$DefaultDaemons{$a} && !$DefaultDaemons{$b} ) {
        return $a cmp $b;
    }

    # when another daemon is compares to a framework one it must be lower
    elsif ( !$DefaultDaemons{$a} ) {
        return -1;
    }

    # when a framework daemon is compared to another one it must be higher
    elsif ( !$DefaultDaemons{$b} ) {
        return 1;
    }

    # otherwise do a numerical comparison with the framework daemons
    return $DefaultDaemons{$a} <=> $DefaultDaemons{$b};
}
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
