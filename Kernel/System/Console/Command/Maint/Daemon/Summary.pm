# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Daemon::Summary;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData);

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Show a summary of one or all daemon modules.');

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
        $Self->Print("\n<yellow>Gathering summary for '$DaemonName'...</yellow>\n\n");
    }
    else {
        $Self->Print("\n<yellow>Gathering summary for all daemons...</yellow>\n\n");
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
        $Output .= '  <yellow>' . $Summary->{Header} . "</yellow>\n";

        # if there is no data to display, show empty message
        if ( !IsArrayRefWithData( $Summary->{Data} ) ) {
            $Output .= '    ' . ( $Summary->{NoDataMessage} || '' ) . "\n\n";

            next SUMMARY;
        }

        my @TableHeader;
        my @TableBody;

        # generate table header
        for my $Column ( @{ $Summary->{Column} } ) {
            push @TableHeader, $Column->{DisplayName};
        }

        # generate table body
        for my $DataRow ( @{ $Summary->{Data} } ) {

            my @BodyRow;

            for my $Column ( @{ $Summary->{Column} } ) {

                my $Value = $DataRow->{ $Column->{Name} } // '';

                if ( $Value eq 'Success' ) {
                    $Value = "<green>$Value</green>";
                }
                elsif ( $Value eq 'N/A' ) {
                    $Value = "<yellow>$Value</yellow>";
                }
                elsif ( $Value eq 'Fail' ) {
                    $Value = "<red>$Value</red>";
                }

                push @BodyRow, $Value;
            }

            push @TableBody, \@BodyRow;
        }

        my $TableOutput = $Self->TableOutput(
            TableData => {
                Header => \@TableHeader,
                Body   => \@TableBody,
            },
            Indention => 2,
        );

        $Output .= "$TableOutput\n";
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
