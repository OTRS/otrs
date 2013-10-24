# --
# Kernel/Output/HTML/DashboardStats.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardStats;

use strict;
use warnings;

use Kernel::System::Stats;
use Kernel::System::JSON;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject
        LayoutObject ParamObject TicketObject TimeObject
        UserID UserObject GroupObject)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    $Self->{StatsObject} = Kernel::System::Stats->new( %{$Self} );
    $Self->{JSONObject}  = Kernel::System::JSON->new( %{$Self} );

    # Settings
    $Self->{PrefKeyStatsConfiguration} = 'UserDashboardStatsStatsConfiguration' . $Self->{Name};

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

    $Stat->{Description} = $Self->{LayoutObject}->Ascii2Html(
        Text           => $Stat->{Description},
        HTMLResultMode => 1,
        NewLine        => 72,
    );

    # check if the user has preferences for this widget
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StatsSettings;
    if ( $Preferences{ $Self->{PrefKeyStatsConfiguration} } ) {
        $StatsSettings = $Self->{JSONObject}->Decode(
            Data => $Preferences{ $Self->{PrefKeyStatsConfiguration} },
        );
    }

    my $OutputPresent = 0;
    $Self->{LayoutObject}->Block(
        Name => 'WidgetSettingsStart',
        Data => {
            JSONFieldName => $Self->{PrefKeyStatsConfiguration},
            NamePref      => $Self->{Name},
        },
    );

    # get static attributes
    if ( $Stat->{StatType} eq 'static' ) {

        # load static module
        my $Params = $Self->{StatsObject}->GetParams( StatID => $StatID );
        $Self->{LayoutObject}->Block( Name => 'Static', );
        for my $ParamItem ( @{$Params} ) {

            next if $ParamItem->{Name} eq 'GraphSize';
            next if $ParamItem->{Name} eq 'Year';
            next if $ParamItem->{Name} eq 'Month';

            if ( $StatsSettings && $StatsSettings->{ $ParamItem->{Name} } ) {
                $ParamItem->{SelectedID} = $StatsSettings->{ $ParamItem->{Name} };
            }

            $Self->{LayoutObject}->Block(
                Name => 'ItemParam',
                Data => {
                    Param => $ParamItem->{Frontend},
                    Name  => $ParamItem->{Name},
                    Field => $Self->{LayoutObject}->BuildSelection(
                        Data       => $ParamItem->{Data},
                        Name       => $ParamItem->{Name},
                        SelectedID => $ParamItem->{SelectedID} || '',
                        Multiple   => $ParamItem->{Multiple} || 0,
                        Size       => $ParamItem->{Size} || '',
                    ),
                },
            );

            $OutputPresent = 1;
        }
    }

    # get dynamic attributes
    elsif ( $Stat->{StatType} eq 'dynamic' ) {
        my %Name = (
            UseAsXvalue      => 'X-axis',
            UseAsValueSeries => 'Value Series',
            UseAsRestriction => 'Restrictions',
        );

        for my $Use (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {
            my $Flag = 0;
            $Self->{LayoutObject}->Block(
                Name => 'Dynamic',
                Data => { Name => $Name{$Use} },
            );
            OBJECTATTRIBUTE:
            for my $ObjectAttribute ( @{ $Stat->{$Use} } ) {
                next if !$ObjectAttribute->{Selected};

                my %ValueHash;
                $Flag = 1;

                # Select All function
                if ( !$ObjectAttribute->{SelectedValues}[0] ) {
                    if (
                        $ObjectAttribute->{Values} && ref $ObjectAttribute->{Values} ne 'HASH'
                        )
                    {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => 'Values needs to be a hash reference!'
                        );
                        next OBJECTATTRIBUTE;
                    }
                    my @Values = keys( %{ $ObjectAttribute->{Values} } );
                    $ObjectAttribute->{SelectedValues} = \@Values;
                }
                for ( @{ $ObjectAttribute->{SelectedValues} } ) {
                    if ( $ObjectAttribute->{Values} ) {
                        $ValueHash{$_} = $ObjectAttribute->{Values}{$_};
                    }
                    else {
                        $ValueHash{Value} = $_;
                    }
                }

                $Self->{LayoutObject}->Block(
                    Name => 'Element',
                    Data => { Name => $ObjectAttribute->{Name} },
                );

                # show fixed elements
                if ( $ObjectAttribute->{Fixed} ) {
                    if ( $ObjectAttribute->{Block} eq 'Time' ) {
                        if ( $Use eq 'UseAsRestriction' ) {
                            delete $ObjectAttribute->{SelectedValues};
                        }
                        my $TimeScale = _TimeScale();
                        if ( $ObjectAttribute->{TimeStart} ) {
                            $Self->{LayoutObject}->Block(
                                Name => 'TimePeriodFixed',
                                Data => {
                                    TimeStart => $ObjectAttribute->{TimeStart},
                                    TimeStop  => $ObjectAttribute->{TimeStop},
                                },
                            );
                        }
                        elsif ( $ObjectAttribute->{TimeRelativeUnit} ) {
                            $Self->{LayoutObject}->Block(
                                Name => 'TimeRelativeFixed',
                                Data => {
                                    TimeRelativeUnit =>
                                        $TimeScale->{ $ObjectAttribute->{TimeRelativeUnit} }
                                        {Value},
                                    TimeRelativeCount => $ObjectAttribute->{TimeRelativeCount},
                                },
                            );
                        }
                        if ( $ObjectAttribute->{SelectedValues}[0] ) {
                            $Self->{LayoutObject}->Block(
                                Name => 'TimeScaleFixed',
                                Data => {
                                    Scale =>
                                        $TimeScale->{ $ObjectAttribute->{SelectedValues}[0] }
                                        {Value},
                                    Count => $ObjectAttribute->{TimeScaleCount},
                                },
                            );
                        }

                        $OutputPresent = 1;
                    }
                    else {

                        # find out which sort mechanism is used
                        my @Sorted;
                        if ( $ObjectAttribute->{SortIndividual} ) {
                            @Sorted = grep { $ValueHash{$_} }
                                @{ $ObjectAttribute->{SortIndividual} };
                        }
                        else {
                            @Sorted
                                = sort { $ValueHash{$a} cmp $ValueHash{$b} } keys %ValueHash;
                        }

                        for (@Sorted) {
                            my $Value = $ValueHash{$_};
                            if ( $ObjectAttribute->{Translation} ) {
                                $Value = "\$Text{\"$ValueHash{$_}\"}";
                            }
                            $Self->{LayoutObject}->Block(
                                Name => 'Fixed',
                                Data => {
                                    Value   => $Value,
                                    Key     => $_,
                                    Use     => $Use,
                                    Element => $ObjectAttribute->{Element},
                                },
                            );

                            $OutputPresent = 1;
                        }
                    }
                }

                # show  unfixed elements
                else {

                    # always set $OutputPresent if there is a unfixed element otherwise the settings
                    #    will not be visible e.g. statistic with no Value Series, no Restrictions
                    #    and dynamic create time for X Axis. If not set users can't define the
                    #    X Axis and the chart will be broken.
                    $OutputPresent = 1;

                    my %BlockData;
                    $BlockData{Name}    = $ObjectAttribute->{Name};
                    $BlockData{Element} = $ObjectAttribute->{Element};
                    $BlockData{Value}   = $ObjectAttribute->{SelectedValues}->[0];

                    if ( $ObjectAttribute->{Block} eq 'MultiSelectField' ) {

                        if (
                            $StatsSettings
                            && $StatsSettings->{ $Use . $ObjectAttribute->{Element} }
                            )
                        {
                            $ObjectAttribute->{SelectedValues}
                                = $StatsSettings->{ $Use . $ObjectAttribute->{Element} };
                        }

                        $BlockData{SelectField} = $Self->{LayoutObject}->BuildSelection(
                            Data           => \%ValueHash,
                            Name           => $Use . $ObjectAttribute->{Element},
                            Multiple       => 1,
                            Size           => 5,
                            SelectedID     => $ObjectAttribute->{SelectedValues},
                            Translation    => $ObjectAttribute->{Translation},
                            TreeView       => $ObjectAttribute->{TreeView} || 0,
                            Sort           => $ObjectAttribute->{Sort} || undef,
                            SortIndividual => $ObjectAttribute->{SortIndividual} || undef,
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'MultiSelectField',
                            Data => \%BlockData,
                        );
                    }
                    elsif ( $ObjectAttribute->{Block} eq 'SelectField' ) {

                        if (
                            $StatsSettings
                            && $StatsSettings->{ $Use . $ObjectAttribute->{Element} }
                            )
                        {
                            $ObjectAttribute->{SelectedValues}
                                = $StatsSettings->{ $Use . $ObjectAttribute->{Element} };
                        }

                        $BlockData{SelectField} = $Self->{LayoutObject}->BuildSelection(
                            Data           => \%ValueHash,
                            Name           => $Use . $ObjectAttribute->{Element},
                            SelectedID     => $ObjectAttribute->{SelectedValues},
                            Translation    => $ObjectAttribute->{Translation},
                            TreeView       => $ObjectAttribute->{TreeView} || 0,
                            Sort           => $ObjectAttribute->{Sort} || undef,
                            SortIndividual => $ObjectAttribute->{SortIndividual} || undef,
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'SelectField',
                            Data => \%BlockData,
                        );
                    }

                    elsif ( $ObjectAttribute->{Block} eq 'InputField' ) {

                        if (
                            $StatsSettings
                            && $StatsSettings->{ $Use . $ObjectAttribute->{Element} }
                            )
                        {
                            $ObjectAttribute->{SelectedValues}
                                = [ $StatsSettings->{ $Use . $ObjectAttribute->{Element} } ];
                        }

                        $Self->{LayoutObject}->Block(
                            Name => 'InputField',
                            Data => {
                                Key   => $Use . $ObjectAttribute->{Element},
                                Value => $ObjectAttribute->{SelectedValues}[0],
                            },
                        );
                    }
                    elsif ( $ObjectAttribute->{Block} eq 'Time' ) {

                        $ObjectAttribute->{Element} = $Use . $ObjectAttribute->{Element};

                        my $TimeType = $Self->{ConfigObject}->Get('Stats::TimeType')
                            || 'Normal';

                        my $RelativeSelectedID = $ObjectAttribute->{TimeRelativeCount};
                        if (
                            $StatsSettings
                            && $StatsSettings->{ $ObjectAttribute->{Element} . 'TimeRelativeCount' }
                            )
                        {
                            $RelativeSelectedID = $StatsSettings->{
                                $ObjectAttribute->{Element}
                                    . 'TimeRelativeCount'
                            };
                        }

                        my $ScaleSelectedID = $ObjectAttribute->{TimeScaleCount};
                        if (
                            $StatsSettings
                            && $StatsSettings->{ $ObjectAttribute->{Element} . 'TimeScaleCount' }
                            )
                        {
                            $ScaleSelectedID = $StatsSettings->{
                                $ObjectAttribute->{Element}
                                    . 'TimeScaleCount'
                            };
                        }

                        my %TimeData = _Timeoutput(
                            $Self, %{$ObjectAttribute},
                            OnlySelectedAttributes => 1,
                            TimeRelativeCount      => $RelativeSelectedID || '',
                            TimeScaleCount         => $ScaleSelectedID || '',
                        );
                        %BlockData = ( %BlockData, %TimeData );
                        if ( $ObjectAttribute->{TimeStart} ) {
                            $BlockData{TimeStartMax} = $ObjectAttribute->{TimeStart};
                            $BlockData{TimeStopMax}  = $ObjectAttribute->{TimeStop};
                            $Self->{LayoutObject}->Block(
                                Name => 'TimePeriodNotChangable',
                                Data => \%BlockData,
                            );
                        }

                        elsif ( $ObjectAttribute->{TimeRelativeUnit} ) {
                            my $TimeScale = _TimeScale();

                            if ( $TimeType eq 'Extended' ) {
                                my $SelectedID = $ObjectAttribute->{TimeRelativeUnit};
                                if (
                                    $StatsSettings
                                    && $StatsSettings->{
                                        $ObjectAttribute->{Element}
                                            . 'TimeRelativeUnit'
                                    }
                                    )
                                {
                                    $SelectedID = $StatsSettings->{
                                        $ObjectAttribute->{Element}
                                            . 'TimeRelativeUnit'
                                    };
                                }

                                my %TimeScaleOption;
                                for (
                                    sort {
                                        $TimeScale->{$a}->{Position}
                                            <=> $TimeScale->{$b}->{Position}
                                    } keys %{$TimeScale}
                                    )
                                {
                                    $TimeScaleOption{$_} = $TimeScale->{$_}{Value};
                                    last if $SelectedID eq $_;
                                }

                                $BlockData{TimeRelativeUnit}
                                    = $Self->{LayoutObject}->BuildSelection(
                                    Name       => $ObjectAttribute->{Element} . 'TimeRelativeUnit',
                                    Data       => \%TimeScaleOption,
                                    Class      => 'TimeRelativeUnitGeneric',
                                    Sort       => 'IndividualKey',
                                    SelectedID => $SelectedID || '',
                                    SortIndividual => [
                                        'Second', 'Minute', 'Hour', 'Day',
                                        'Week',   'Month',  'Year'
                                    ],
                                    );
                            }
                            $BlockData{TimeRelativeCountMax}
                                = $ObjectAttribute->{TimeRelativeCount};
                            $BlockData{TimeRelativeUnitMax}
                                = $TimeScale->{ $ObjectAttribute->{TimeRelativeUnit} }{Value};
                            $BlockData{TimeRelativeMaxSeconds}
                                = $ObjectAttribute->{TimeRelativeCount}
                                * $Self->_TimeInSeconds(
                                TimeUnit => $ObjectAttribute->{TimeRelativeUnit} );

                            $Self->{LayoutObject}->Block(
                                Name => 'TimePeriodRelative',
                                Data => \%BlockData,
                            );
                        }

                        # build the Timescale output
                        if ( $Use ne 'UseAsRestriction' ) {
                            if ( $TimeType eq 'Normal' ) {
                                $BlockData{TimeScaleCount} = 1;
                                $BlockData{TimeScaleUnit}  = $BlockData{TimeSelectField};
                            }
                            elsif ( $TimeType eq 'Extended' ) {
                                my $TimeScale = _TimeScale();
                                my %TimeScaleOption;
                                for (
                                    sort {
                                        $TimeScale->{$b}->{Position}
                                            <=> $TimeScale->{$a}->{Position}
                                    } keys %{$TimeScale}
                                    )
                                {
                                    $TimeScaleOption{$_} = $TimeScale->{$_}->{Value};
                                    last if $ObjectAttribute->{SelectedValues}[0] eq $_;
                                }

                                $BlockData{TimeScaleUnitMax}
                                    = $TimeScale->{ $ObjectAttribute->{SelectedValues}[0] }{Value};
                                $BlockData{TimeScaleCountMax} = $ObjectAttribute->{TimeScaleCount};

                                $BlockData{TimeScaleUnit} = $Self->{LayoutObject}->BuildSelection(
                                    Name           => $ObjectAttribute->{Element},
                                    Data           => \%TimeScaleOption,
                                    Class          => 'TimeScaleUnitGeneric',
                                    SelectedID     => $ObjectAttribute->{SelectedValues}[0],
                                    Sort           => 'IndividualKey',
                                    SortIndividual => [
                                        'Second', 'Minute', 'Hour', 'Day',
                                        'Week',   'Month',  'Year'
                                    ],
                                );

                                $BlockData{TimeScaleMinSeconds} = $ObjectAttribute->{TimeScaleCount}
                                    * $Self->_TimeInSeconds(
                                    TimeUnit => $ObjectAttribute->{SelectedValues}[0] );

                                $Self->{LayoutObject}->Block(
                                    Name => 'TimeScaleInfo',
                                    Data => \%BlockData,
                                );
                            }
                            if ( $ObjectAttribute->{SelectedValues} ) {
                                $Self->{LayoutObject}->Block(
                                    Name => 'TimeScale',
                                    Data => \%BlockData,
                                );
                                if ( $BlockData{TimeScaleUnitMax} ) {
                                    $Self->{LayoutObject}->Block(
                                        Name => 'TimeScaleInfo',
                                        Data => \%BlockData,
                                    );
                                }
                            }
                        }

                        # end of build timescale output
                    }
                }
            }

            # Show this Block if no value series or restrictions are selected
            if ( !$Flag ) {
                $Self->{LayoutObject}->Block( Name => 'NoElement', );
            }
        }
    }
    my %YesNo        = ( 0 => 'No',      1 => 'Yes' );
    my %ValidInvalid = ( 0 => 'invalid', 1 => 'valid' );
    $Stat->{SumRowValue}                = $YesNo{ $Stat->{SumRow} };
    $Stat->{SumColValue}                = $YesNo{ $Stat->{SumCol} };
    $Stat->{CacheValue}                 = $YesNo{ $Stat->{Cache} };
    $Stat->{ShowAsDashboardWidgetValue} = $YesNo{ $Stat->{ShowAsDashboardWidget} // 0 };
    $Stat->{ValidValue}                 = $ValidInvalid{ $Stat->{Valid} };

    for (qw(CreatedBy ChangedBy)) {
        $Stat->{$_} = $Self->{UserObject}->UserName( UserID => $Stat->{$_} );
    }

    if ( !$OutputPresent ) {
        return;
    }

    $Self->{LayoutObject}->Block(
        Name => 'WidgetSettingsEnd',
        Data => {
            NamePref      => $Self->{Name},
        },
    );

    my $SettingsHTML = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentStatsViewSettings',
        Data         => $Stat,
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

    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StatsSettings = {};
    if ( $Preferences{ $Self->{PrefKeyStatsConfiguration} } ) {
        $StatsSettings = $Self->{JSONObject}->Decode(
            Data => $Preferences{ $Self->{PrefKeyStatsConfiguration} },
        );
    }

    my $CachedData = $Self->{StatsObject}->StatsResultCacheGet(
        StatID       => $StatID,
        UserGetParam => $StatsSettings,
    );

    if ( defined $CachedData ) {
        my $JSON = $Self->{JSONObject}->Encode(
            Data => $CachedData,
        );

        $Self->{LayoutObject}->Block(
            Name => 'StatsData',
            Data => {
                Name      => $Self->{Name},
                StatsData => $JSON,
            },
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoData',
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardStats',
        Data         => {
            Name => $Self->{Name},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

sub _Timeoutput {
    my ( $Self, %Param ) = @_;

    my %Timeoutput;

    # check if need params are available
    if ( !$Param{TimePeriodFormat} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => '_Timeoutput: Need TimePeriodFormat!'
        );
    }

    # get time
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
        = $Self->{TimeObject}->SystemTime2Date( SystemTime => $Self->{TimeObject}->SystemTime(), );
    my $Element = $Param{Element};
    my %TimeConfig;

    # default time configuration
    $TimeConfig{Format}                     = $Param{TimePeriodFormat};
    $TimeConfig{ $Element . 'StartYear' }   = $Year - 1;
    $TimeConfig{ $Element . 'StartMonth' }  = 1;
    $TimeConfig{ $Element . 'StartDay' }    = 1;
    $TimeConfig{ $Element . 'StartHour' }   = 0;
    $TimeConfig{ $Element . 'StartMinute' } = 0;
    $TimeConfig{ $Element . 'StartSecond' } = 1;
    $TimeConfig{ $Element . 'StopYear' }    = $Year;
    $TimeConfig{ $Element . 'StopMonth' }   = 12;
    $TimeConfig{ $Element . 'StopDay' }     = 31;
    $TimeConfig{ $Element . 'StopHour' }    = 23;
    $TimeConfig{ $Element . 'StopMinute' }  = 59;
    $TimeConfig{ $Element . 'StopSecond' }  = 59;
    for (qw(Start Stop)) {
        $TimeConfig{Prefix} = $Element . $_;

        # time setting if available
        if (
            $Param{ 'Time' . $_ }
            && $Param{ 'Time' . $_ } =~ m{^(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)$}xi
            )
        {
            $TimeConfig{ $Element . $_ . 'Year' }   = $1;
            $TimeConfig{ $Element . $_ . 'Month' }  = $2;
            $TimeConfig{ $Element . $_ . 'Day' }    = $3;
            $TimeConfig{ $Element . $_ . 'Hour' }   = $4;
            $TimeConfig{ $Element . $_ . 'Minute' } = $5;
            $TimeConfig{ $Element . $_ . 'Second' } = $6;
        }
        $Timeoutput{ 'Time' . $_ } = $Self->{LayoutObject}->BuildDateSelection(%TimeConfig);
    }

    # Solution I (TimeExtended)
    my %TimeLists;
    for ( 1 .. 60 ) {
        $TimeLists{TimeRelativeCount}{$_} = sprintf( "%02d", $_ );
        $TimeLists{TimeScaleCount}{$_}    = sprintf( "%02d", $_ );
    }
    for (qw(TimeRelativeCount TimeScaleCount)) {
        $Timeoutput{$_} = $Self->{LayoutObject}->BuildSelection(
            Data       => $TimeLists{$_},
            Name       => $Element . $_,
            SelectedID => $Param{$_},
        );
    }

    if ( $Param{TimeRelativeCount} && $Param{TimeRelativeUnit} ) {
        $Timeoutput{CheckedRelative} = 'checked="checked"';
    }
    else {
        $Timeoutput{CheckedAbsolut} = 'checked="checked"';
    }

    my %TimeScale = _TimeScaleBuildSelection();

    $Timeoutput{TimeScaleUnit} = $Self->{LayoutObject}->BuildSelection(
        %TimeScale,
        Name       => $Element,
        SelectedID => $Param{SelectedValues}[0],
    );

    $Timeoutput{TimeRelativeUnit} = $Self->{LayoutObject}->BuildSelection(
        %TimeScale,
        Name       => $Element . 'TimeRelativeUnit',
        SelectedID => $Param{TimeRelativeUnit},
        OnChange   => "Core.Agent.Stats.SelectRadiobutton('Relativ', '$Element" . "TimeSelect')",
    );

    # to show only the selected Attributes in the view mask
    my $Multiple = 1;
    my $Size     = 5;

    if ( $Param{OnlySelectedAttributes} ) {

        $TimeScale{Data} = $Param{SelectedValues};

        $Multiple = 0;
        $Size     = 1;
    }

    $Timeoutput{TimeSelectField} = $Self->{LayoutObject}->BuildSelection(
        %TimeScale,
        Name       => $Element,
        SelectedID => $Param{SelectedValues},
        Multiple   => $Multiple,
        Size       => $Size,
    );

    return %Timeoutput;
}

sub _TimeScaleBuildSelection {

    my %TimeScaleBuildSelection = (
        Data => {
            Second => 'second(s)',
            Minute => 'minute(s)',
            Hour   => 'hour(s)',
            Day    => 'day(s)',
            Week   => 'week(s)',
            Month  => 'month(s)',
            Year   => 'year(s)',
        },
        Sort => 'IndividualKey',
        SortIndividual => [ 'Second', 'Minute', 'Hour', 'Day', 'Week', 'Month', 'Year' ]
    );

    return %TimeScaleBuildSelection;
}

sub _TimeScale {
    my %TimeScale = (
        'Second' => {
            Position => 1,
            Value    => 'second(s)',
        },
        'Minute' => {
            Position => 2,
            Value    => 'minute(s)',
        },
        'Hour' => {
            Position => 3,
            Value    => 'hour(s)',
        },
        'Day' => {
            Position => 4,
            Value    => 'day(s)',
        },
        'Week' => {
            Position => 5,
            Value    => 'week(s)',
        },
        'Month' => {
            Position => 6,
            Value    => 'month(s)',
        },
        'Year' => {
            Position => 7,
            Value    => 'year(s)',
        },
    );

    return \%TimeScale;
}

sub _TimeInSeconds {
    my ( $Self, %Param ) = @_;

    # check if need params are available
    if ( !$Param{TimeUnit} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => '_TimeInSeconds: Need TimeUnit!'
        );
        return;
    }

    my %TimeInSeconds = (
        Year   => 31536000,    # 60 * 60 * 60 * 365
        Month  => 2592000,     # 60 * 60 * 24 * 30
        Week   => 604800,      # 60 * 60 * 24 * 7
        Day    => 86400,       # 60 * 60 * 24
        Hour   => 3600,        # 60 * 60
        Minute => 60,
        Second => 1,
    );

    return $TimeInSeconds{ $Param{TimeUnit} };
}

1;
