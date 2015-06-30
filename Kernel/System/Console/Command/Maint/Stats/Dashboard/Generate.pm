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
        Name        => 'force',
        Description => "Force execution of the script even it is already running.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
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
    my ( $Self, %Param ) = @_;

    # create pid lock
    if (
        !$Self->GetOption('force')
        && !$Kernel::OM->Get('Kernel::System::PID')->PIDCreate( Name => 'GenerateDashboardStats' )
        )
    {
        die "Script is already running (use '--force' if you want to start it forced)!\n";
    }
    elsif (
        $Self->GetOption('force')
        && !$Kernel::OM->Get('Kernel::System::PID')->PIDCreate( Name => 'GenerateDashboardStats' )
        )
    {
        $Self->Print("<yellow>Script is already running but is starting again!...</yellow>\n");
    }

    # set new PID
    $Kernel::OM->Get('Kernel::System::PID')->PIDCreate(
        Name  => 'GenerateDashboardStats',
        Force => 1,
        TTL   => 60 * 60 * 24 * 3,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Generating dashboard widgets statistics...</yellow>\n");

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Stats' => {
            UserID => 1,
        },
    );

    my $StatNumber = $Self->GetOption('number');

    # get the list of stats that can be used in agent dashboards
    my $Stats = $Kernel::OM->Get('Kernel::System::Stats')->StatsListGet();

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

            # use an own object for the user to handle permissions correctly
            my $UserStatsObject = Kernel::System::Stats->new(
                UserID => $UserID,
            );

            if ( $Self->GetOption('debug') ) {
                print STDERR "DEBUG: user statistic configuration data:\n";
                print STDERR $Kernel::OM->Get('Kernel::System::Main')->Dump($UserGetParam);
            }

            # now run the stat to fill the cache with the current parameters
            my $Result = $UserStatsObject->StatsResultCacheCompute(
                StatID       => $StatID,
                UserGetParam => $UserGetParam,
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
    my ( $Self, %Param ) = @_;

    # delete pid lock
    $Kernel::OM->Get('Kernel::System::PID')->PIDDelete( Name => 'GenerateDashboardStats' );

    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
