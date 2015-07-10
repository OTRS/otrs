# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Stats::Dashboard::Generate;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::PID',
    'Kernel::System::User',
    'Kernel::System::JSON',
    'Kernel::System::Main',
    'Kernel::System::Stats',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate statistics widgets for the dashboard.');
    $Self->AddOption(
        Name        => 'number',
        Description => "Stats number (as shown on overview in AgentStats).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d+/smx,
    );
    $Self->AddOption(
        Name        => 'force-pid',
        Description => "Start even if another process is still registered in the database.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'debug',
        Description => "Output debug information while running.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ($Self) = @_;

    my $PIDCreated = $Kernel::OM->Get('Kernel::System::PID')->PIDCreate(
        Name  => $Self->Name(),
        Force => $Self->GetOption('force-pid'),
        TTL   => 60 * 60 * 24 * 3,
    );
    if ( !$PIDCreated ) {
        my $Error = "Unable to register the process in the database. Is another instance still running?\n";
        $Error .= "You can use --force-pid to override this check.\n";
        die $Error;
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Generating dashboard widgets statistics...</yellow>\n");

    my $StatNumber = $Self->GetOption('number');

    # get the list of stats that can be used in agent dashboards
    my $Stats = $Kernel::OM->Get('Kernel::System::Stats')->StatsListGet(
        UserID => 1,
    );

    STATID:
    for my $StatID ( sort keys %{ $Stats || {} } ) {

        my %Stat = %{ $Stats->{$StatID} || {} };

        next STATID if $StatNumber && $StatNumber ne $Stat{StatNumber};
        next STATID if !$Stat{ShowAsDashboardWidget};

        $Self->Print("<yellow>Stat $Stat{StatNumber}: $Stat{Title}</yellow>\n");

        # now find out all users which have this statistic enabled in their dashboard
        my $DashboardActiveSetting = 'UserDashboard' . ( 1000 + $StatID ) . "-Stats";
        my %UsersWithActivatedWidget = $Kernel::OM->Get('Kernel::System::User')->SearchPreferences(
            Key   => $DashboardActiveSetting,
            Value => 1,
        );

        my $UserWidgetConfigSetting = 'UserDashboardStatsStatsConfiguration' . ( 1000 + $StatID ) . "-Stats";

        # Calculate the cache for each user, if needed. If several users have the same settings
        #   for a stat, the cache will not be recalculated.
        USERID:
        for my $UserID ( sort keys %UsersWithActivatedWidget ) {

            # ignore invalid users
            my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID        => $UserID,
                Valid         => 1,
                NoOutOfOffice => 1,
            );

            next USERID if !%UserData;

            $Self->Print("<yellow>      User: $UserData{UserLogin} ($UserID)</yellow>\n");

            my $UserGetParam = {};
            if ( $UserData{$UserWidgetConfigSetting} ) {
                $UserGetParam = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                    Data => $UserData{$UserWidgetConfigSetting},
                );
            }

            if ( $Self->GetOption('debug') ) {
                print STDERR "DEBUG: user statistic configuration data:\n";
                print STDERR $Kernel::OM->Get('Kernel::System::Main')->Dump($UserGetParam);
            }

            # now run the stat to fill the cache with the current parameters
            my $Result = $Kernel::OM->Get('Kernel::System::Stats')->StatsResultCacheCompute(
                StatID       => $StatID,
                UserGetParam => $UserGetParam,
                UserID       => $UserID
            );

            if ( !$Result ) {
                $Self->PrintError("        Stat calculation was not successful.");
            }
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ($Self) = @_;

    return $Kernel::OM->Get('Kernel::System::PID')->PIDDelete( Name => $Self->Name() );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
