# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    # get StatID
    my $StatID = $Self->{Config}->{StatID};

    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet( StatID => $StatID );

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
        $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsGet(
            Stat         => $Stat,
            UserGetParam => $StatsSettings,
            UserID       => $Self->{UserID},
        );
    };

    if ( $@ || ref $@ eq 'ARRAY' ) {
        @Errors = @{$@};
    }

    # Fetch the stat again as StatsParamGet might have modified it in between.
    $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
        StatID => $StatID,
        UserID => $Self->{UserID},
    );
    my $StatsParamsWidget = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsWidget(
        Stat         => $Stat,
        UserGetParam => $StatsSettings,
        Formats      => \%FilteredFormats,
        UserID       => $Self->{UserID},
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

    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet( StatID => $StatID );

    my $StatConfigurationValid = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsConfigurationValidate(
        Stat   => $Stat,
        Errors => {},
        UserID => $Self->{UserID},
    );

    my $StatParametersValid;
    eval {
        $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsGet(
            Stat         => $Stat,
            UserGetParam => $StatsSettings,
            UserID       => $Self->{UserID},
        );
        $StatParametersValid = 1;
    };

    my $CachedData;

    if ( $StatConfigurationValid && $StatParametersValid ) {
        $CachedData = $Kernel::OM->Get('Kernel::System::Stats')->StatsResultCacheGet(
            StatID       => $StatID,
            UserGetParam => $StatsSettings,
            UserID       => $Self->{UserID},
        );
    }

    my $Format = $StatsSettings->{Format};
    if ( !$Format ) {
        my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
            StatID => $StatID,
            UserID => $Self->{UserID},
        );
        STATFORMAT:
        for my $StatFormat ( @{ $Stat->{Format} || [] } ) {
            if ( $StatFormat =~ m{^D3}smx ) {
                $Format = $StatFormat;
                last STATFORMAT;
            }
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check permission for AgentStatistics
    my $StatsReg = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{'AgentStatistics'};
    my $AgentStatisticsFrontendPermission = 0;
    if ( !$StatsReg->{GroupRo} && !$StatsReg->{Group} ) {
        $AgentStatisticsFrontendPermission = 1;
    }
    else {
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        TYPE:
        for my $Type (qw(GroupRo Group)) {
            my $StatsGroups = ref $StatsReg->{$Type} eq 'ARRAY' ? $StatsReg->{$Type} : [ $StatsReg->{$Type} ];
            GROUP:
            for my $StatsGroup ( @{$StatsGroups} ) {
                next GROUP if !$StatsGroup;
                next GROUP if !$GroupObject->PermissionCheck(
                    UserID    => $Self->{UserID},
                    GroupName => $StatsGroup,
                    Type      => 'ro',
                );

                $AgentStatisticsFrontendPermission = 1;
                last TYPE;
            }
        }
    }

    my $StatsResultDataJSON = $LayoutObject->JSONEncode(
        Data     => $CachedData,
        NoQuotes => 1,
    );

    my $StatsFormatJSON = $LayoutObject->JSONEncode(
        Data     => $Format,
        NoQuotes => 1,
    );

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'StatsData' . $StatID,
        Value => {
            Name               => $Self->{Name},
            Format             => $StatsFormatJSON,
            StatResultData     => $StatsResultDataJSON,
            Preferences        => $Preferences{ 'GraphWidget' . $Self->{Name} } || '{}',
            MaxXaxisAttributes => $Kernel::OM->Get('Kernel::Config')->Get('Stats::MaxXaxisAttributes'),
        },
    );

    if ( $Self->{UserRefreshTime} ) {
        my $Refresh = 60 * $Self->{UserRefreshTime};

        $LayoutObject->AddJSData(
            Key   => 'WidgetRefreshStat' . $StatID,
            Value => {
                Name        => $Self->{Name},
                NameHTML    => $Self->{Name},
                RefreshTime => $Refresh,
            },
        );
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
            Preferences                       => $Preferences{ 'GraphWidget' . $Self->{Name} } || '{}',
        },
        AJAX => $Param{AJAX},
    );

    return $Content;
}

1;
