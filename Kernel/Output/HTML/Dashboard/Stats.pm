# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Dashboard::Stats;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use Kernel::System::Stats;
use Kernel::Output::HTML::Statistics::View;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    # Settings
    $Self->{PrefKeyStatsConfiguration} = 'UserDashboardStatsStatsConfiguration' . $Self->{Name};

    $Self->{StatsObject} = Kernel::System::Stats->new(
        UserID => $Self->{UserID},
    );
    $Self->{StatsViewObject} = Kernel::Output::HTML::Statistics::View->new(
        StatsObject => $Self->{StatsObject},
    );

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    # get StatID
    my $StatID = $Self->{Config}->{StatID};

    my $Stat = $Self->{StatsObject}->StatsGet( StatID => $StatID );

    # get the object name
    if ( $Stat->{StatType} eq 'static' ) {
        $Stat->{ObjectName} = $Stat->{File};
    }

    # if no object name is defined use an empty string
    $Stat->{ObjectName} ||= '';

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    # check if the user has preferences for this widget
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StatsSettings;
    if ( $Preferences{ $Self->{PrefKeyStatsConfiguration} } ) {
        $StatsSettings = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
            Data => $Preferences{ $Self->{PrefKeyStatsConfiguration} },
        );
    }

    my %Format = %{ $Kernel::OM->Get('Kernel::Config')->Get('Stats::Format') || {} };

    my %FilteredFormats;
    for my $Key ( sort keys %Format ) {
        $FilteredFormats{$Key} = $Format{$Key} if $Key =~ m{^D3}smx;
    }

    my @Errors;

    my %GetParam = eval {
        $Self->{StatsViewObject}->StatsParamsGet(
            Stat         => $Stat,
            UserGetParam => $StatsSettings,
        );
    };

    if ( $@ || ref $@ eq 'ARRAY' ) {
        @Errors = @{$@};
    }

    # Fetch the stat again as StatsParamGet might have modified it in between.
    $Stat = $Self->{StatsObject}->StatsGet( StatID => $StatID );
    my $StatsParamsWidget = $Self->{StatsViewObject}->StatsParamsWidget(
        Stat         => $Stat,
        UserGetParam => $StatsSettings,
        Formats      => \%FilteredFormats,
    );

    # This indicates that there are configuration errors in the statistic.
    # In that case we show a warning in Run() and no configuration here.
    if ( !$StatsParamsWidget ) {
        return;
    }

    my $SettingsHTML = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardStatsSettings',
        Data         => {
            %{$Stat},
            Errors            => \@Errors,
            JSONFieldName     => $Self->{PrefKeyStatsConfiguration},
            NamePref          => $Self->{Name},
            StatsParamsWidget => $StatsParamsWidget,
        },
    );

    my @Params = (
        {
            Desc  => 'Stats Configuration',
            Name  => $Self->{PrefKeyStatsConfiguration},
            Block => 'RawHTML',
            HTML  => $SettingsHTML,
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} }
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $StatID = $Self->{Config}->{StatID};

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StatsSettings = {};

    # get JSON object
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    if ( $Preferences{ $Self->{PrefKeyStatsConfiguration} } ) {
        $StatsSettings = $JSONObject->Decode(
            Data => $Preferences{ $Self->{PrefKeyStatsConfiguration} },
        );
    }

    my $Stat = $Self->{StatsObject}->StatsGet( StatID => $StatID );

    my $StatConfigurationValid = $Self->{StatsViewObject}->StatsConfigurationValidate(
        Stat   => $Stat,
        Errors => {},
    );

    my $StatParametersValid;
    eval {
        $Self->{StatsViewObject}->StatsParamsGet(
            Stat         => $Stat,
            UserGetParam => $StatsSettings,
        );
        $StatParametersValid = 1;
    };

    my $CachedData;

    if ( $StatConfigurationValid && $StatParametersValid ) {
        $CachedData = $Self->{StatsObject}->StatsResultCacheGet(
            StatID       => $StatID,
            UserGetParam => $StatsSettings,
        );
    }

    my $Format = $StatsSettings->{Format};
    if ( !$Format ) {
        my $Stat = $Self->{StatsObject}->StatsGet( StatID => $StatID );
        STATFORMAT:
        for my $StatFormat ( @{ $Stat->{Format} || [] } ) {
            if ( $StatFormat =~ m{^D3}smx ) {
                $Format = $StatFormat;
                last STATFORMAT;
            }
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check permission for AgentStats
    my $StatsReg = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{'AgentStatistics'};
    my $AgentStatisticsFrontendPermission = 0;
    if ( !$StatsReg->{GroupRo} && !$StatsReg->{Group} ) {
        $AgentStatisticsFrontendPermission = 1;
    }
    else {
        TYPE:
        for my $Type (qw(GroupRo Group)) {
            my $StatsGroups = ref $StatsReg->{$Type} eq 'ARRAY' ? $StatsReg->{$Type} : [ $StatsReg->{$Type} ];
            GROUP:
            for my $StatsGroup ( @{$StatsGroups} ) {
                next GROUP if !$StatsGroup;
                next GROUP if !$LayoutObject->{"UserIsGroupRo[$StatsGroup]"};
                next GROUP if $LayoutObject->{"UserIsGroupRo[$StatsGroup]"} ne 'Yes';
                $AgentStatisticsFrontendPermission = 1;
                last TYPE;
            }
        }
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardStats',
        Data         => {
            Name                              => $Self->{Name},
            StatConfigurationValid            => $StatConfigurationValid,
            StatParametersValid               => $StatParametersValid,
            StatResultData                    => $CachedData,
            Stat                              => $Stat,
            Format                            => $Format,
            AgentStatisticsFrontendPermission => $AgentStatisticsFrontendPermission,
            Preferences => $Preferences{ 'GraphWidget' . $Self->{Name} } || '{}',
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
