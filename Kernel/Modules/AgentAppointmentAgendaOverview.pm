# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentAppointmentAgendaOverview;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    $Self->{View} = 'AgentAppointmentAgendaOverview';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get filters stored in the user preferences
    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $LastFilterKey = 'UserLastFilter-' . $Self->{View};
    my $LastFilter    = $Preferences{$LastFilterKey} || 'Week';

    my %Filters = (
        Month => {
            Name => Translatable('Month'),
            Prio => 100,
        },
        Week => {
            Name => Translatable('Week'),
            Prio => 200,
        },
        Day => {
            Name => Translatable('Day'),
            Prio => 300,
        },
    );

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # current filter
    $Param{Filter} = $ParamObject->GetParam( Param => 'Filter' ) || $LastFilter;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if filter is valid
    if ( !$Filters{ $Param{Filter} } ) {
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Invalid Filter: %s!', $Param{Filter} ),
        );
    }

    # prepare filters
    my %NavBarFilter;
    for my $FilterColumn ( sort keys %Filters ) {
        $NavBarFilter{ $Filters{$FilterColumn}->{Prio} } = {
            Filter => $FilterColumn,
            %{ $Filters{$FilterColumn} },
        };
    }

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # Get user's permissions to associated modules which are displayed as links.
    for my $Module (qw(AdminAppointmentCalendarManage)) {
        my $ModuleGroups = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')
            ->{$Module}->{Group} // [];

        if ( IsArrayRefWithData($ModuleGroups) ) {
            MODULE_GROUP:
            for my $ModuleGroup ( @{$ModuleGroups} ) {
                my $HasPermission = $GroupObject->PermissionCheck(
                    UserID    => $Self->{UserID},
                    GroupName => $ModuleGroup,
                    Type      => 'rw',
                );
                if ($HasPermission) {
                    $Param{ModulePermissions}->{$Module} = 1;
                    last MODULE_GROUP;
                }
            }
        }

        # Always allow links if no groups are specified.
        else {
            $Param{ModulePermissions}->{$Module} = 1;
        }
    }

    # Current time in the view.
    $Param{Start} = $ParamObject->GetParam( Param => 'Start' )
        || $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

    # handle jump
    $Param{Jump} = $ParamObject->GetParam( Param => 'Jump' ) || '';
    if ( $Param{Jump} ) {
        my $JumpOffset = 0;    # days
        if ( $Param{Filter} eq 'Week' ) {
            $JumpOffset = 7;
        }
        elsif ( $Param{Filter} eq 'Day' ) {
            $JumpOffset = 1;
        }

        # Calculate destination time.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Start},
            },
        );

        if ( $Param{Filter} eq 'Month' ) {
            my $StartTimeSettings = $StartTimeObject->Get();
            if ( $Param{Jump} eq 'Prev' ) {
                $StartTimeSettings->{Month} -= 1;
            }
            elsif ( $Param{Jump} eq 'Next' ) {
                $StartTimeSettings->{Month} += 1;
            }
            if ( $StartTimeSettings->{Month} < 1 ) {
                $StartTimeSettings->{Month} = 12;
                $StartTimeSettings->{Year} -= 1;
            }
            elsif ( $StartTimeSettings->{Month} > 12 ) {
                $StartTimeSettings->{Month} = 1;
                $StartTimeSettings->{Year} += 1;
            }
            $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Year  => $StartTimeSettings->{Year},
                    Month => $StartTimeSettings->{Month},
                    Day   => 1,
                },
            );
        }
        else {
            if ( $Param{Jump} eq 'Prev' ) {
                $StartTimeObject->Subtract(
                    Days => $JumpOffset,
                );
            }
            elsif ( $Param{Jump} eq 'Next' ) {
                $StartTimeObject->Add(
                    Days => $JumpOffset,
                );
            }
        }

        $Param{Start} = $StartTimeObject->ToString();
    }

    # calculate date boundaries
    if ( $Param{Filter} eq 'Month' ) {

        # Get first day of the month.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Start},
            },
        );
        $StartTimeObject->Set(
            Day    => 1,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        my $StartTimeSettings = $StartTimeObject->Get();
        $Param{StartTime} = $StartTimeObject->ToString();

        # Get last day of the month.
        my $EndTimeObject = $StartTimeObject->Clone();
        $EndTimeObject->Add(
            Months => 1,
        );
        $EndTimeObject->Set(
            Day => 1,
        );
        $EndTimeObject->Subtract(
            Seconds => 1,
        );
        $EndTimeObject->Set(
            Hour   => 23,
            Minute => 59,
            Second => 59,
        );
        $Param{EndTime} = $EndTimeObject->ToString();

        # get translated name of the month
        my @MonthArray = (
            '',
            'January',
            'February',
            'March',
            'April',
            'May_long',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
        );
        my $TranslateMonth = $LayoutObject->{LanguageObject}->Translate( $MonthArray[ $StartTimeSettings->{Month} ] );

        $Param{HeaderTitle} = "$TranslateMonth $StartTimeSettings->{Year}";
    }
    elsif ( $Param{Filter} eq 'Week' ) {
        my $CalendarWeekDayStart = $Kernel::OM->Get('Kernel::Config')->Get('CalendarWeekDayStart') || 7;
        my $CalendarWeekDayEnd   = ( $CalendarWeekDayStart - 1 )                                   || 7;

        # Get start of the week.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Start},
            },
        );
        while ( $StartTimeObject->Get()->{DayOfWeek} != $CalendarWeekDayStart ) {
            $StartTimeObject->Subtract(
                Days => 1,
            );
        }
        $StartTimeObject->Set(
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        $Param{StartTime} = $StartTimeObject->ToString();

        # Get end of the week.
        my $EndTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Start},
            },
        );
        while ( $EndTimeObject->Get()->{DayOfWeek} != $CalendarWeekDayEnd ) {
            $EndTimeObject->Add(
                Days => 1,
            );
        }
        $EndTimeObject->Set(
            Hour   => 23,
            Minute => 59,
            Second => 59,
        );
        $Param{EndTime} = $EndTimeObject->ToString();

        $Param{HeaderTitle} =
            $LayoutObject->{LanguageObject}->FormatTimeString( $Param{StartTime}, 'DateFormatShort' )
            . ' '
            . chr(8211)
            . ' '
            . $LayoutObject->{LanguageObject}->FormatTimeString( $Param{EndTime}, 'DateFormatShort' );
        $Param{HeaderTitleCW} = '#' . $StartTimeObject->{CPANDateTimeObject}->week_number();
    }
    elsif ( $Param{Filter} eq 'Day' ) {

        # Get start of the day.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Start},
            },
        );
        $StartTimeObject->Set(
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        $Param{StartTime} = $StartTimeObject->ToString();

        # Get end of the day.
        my $EndTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Start},
            },
        );
        $EndTimeObject->Set(
            Hour   => 23,
            Minute => 59,
            Second => 59,
        );
        $Param{EndTime} = $EndTimeObject->ToString();

        $Param{HeaderTitle} = $LayoutObject->{LanguageObject}->FormatTimeString( $Param{StartTime}, 'DateFormatShort' );
        $Param{HeaderTitleCW} = '#' . $StartTimeObject->{CPANDateTimeObject}->week_number();
    }

    # display filter buttons
    my @NavBarFilters;
    for my $Prio ( sort keys %NavBarFilter ) {
        push @NavBarFilters, $NavBarFilter{$Prio};
    }
    $LayoutObject->Block(
        Name => 'OverviewNavBarFilter',
        Data => {
            %Filters,
        },
    );
    my $Count = 0;
    for my $Filter (@NavBarFilters) {
        $Count++;
        if ( $Count == scalar @NavBarFilters ) {
            $Filter->{CSS} = 'Last';
        }
        $LayoutObject->Block(
            Name => 'OverviewNavBarFilterItem',
            Data => {
                %Param,
                %{$Filter},
            },
        );
        if ( $Filter->{Filter} eq $Param{Filter} ) {
            $LayoutObject->Block(
                Name => 'OverviewNavBarFilterItemSelected',
                Data => {
                    %Param,
                    %{$Filter},
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'OverviewNavBarFilterItemSelectedNot',
                Data => {
                    %Param,
                    %{$Filter},
                },
            );
        }
    }

    # get calendar object
    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

    # get all user's valid calendars
    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );
    my @Calendars = $CalendarObject->CalendarList(
        UserID  => $Self->{UserID},
        ValidID => $ValidID,
    );

    # check if we found some
    if (@Calendars) {

        for my $Calendar (@Calendars) {
            $Param{CalendarData}->{ $Calendar->{CalendarID} } = {
                CalendarName => $Calendar->{CalendarName},
                Color        => $Calendar->{Color},
            };
        }

        $LayoutObject->Block(
            Name => 'AppointmentCreateButton',
        );

        # get appointment object
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

        my @ViewableAppointments;
        for my $Calendar (@Calendars) {
            my @Appointments = $AppointmentObject->AppointmentList(
                CalendarID => $Calendar->{CalendarID},
                Result     => 'HASH',
                %Param,
            );

            push @ViewableAppointments, @Appointments;
        }

        if (@ViewableAppointments) {

            # sort by start date
            @ViewableAppointments = sort { $a->{StartTime} cmp $b->{StartTime} } @ViewableAppointments;

            my $LastDay = '';
            for my $Appointment (@ViewableAppointments) {

                # save time stamps for display before calculation
                $Appointment->{StartDate} = $Appointment->{StartTime};
                $Appointment->{EndDate}   = $Appointment->{EndTime};

                # End times for all day appointments are inclusive, subtract whole day.
                if ( $Appointment->{AllDay} ) {
                    my $StartTimeObject = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $Appointment->{StartTime},
                        },
                    );
                    my $EndTimeObject = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $Appointment->{EndTime},
                        },
                    );
                    $EndTimeObject->Subtract(
                        Days => 1,
                    );
                    if ( $EndTimeObject < $StartTimeObject ) {
                        $EndTimeObject = $StartTimeObject->Clone();
                    }
                    $Appointment->{EndDate} = $EndTimeObject->ToString();
                }

                # formatted date/time strings used in display
                $Appointment->{StartDate} = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $Appointment->{StartDate},
                    'DateFormat' . ( $Appointment->{AllDay} ? 'Short' : '' )
                );
                $Appointment->{EndDate} = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $Appointment->{EndDate},
                    'DateFormat' . ( $Appointment->{AllDay} ? 'Short' : '' )
                );

                # formatted notification date used in display
                $Appointment->{NotificationDate} = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $Appointment->{NotificationDate},
                    'DateFormat'
                );

                # cut the time portion
                $Param{StartDay} = substr( $Appointment->{StartTime}, 0, 10 );

                if ( $LastDay ne $Param{StartDay} ) {
                    $LayoutObject->Block(
                        Name => 'AppointmentGroup',
                        Data => {
                            CurrentDay => $LayoutObject->{LanguageObject}->FormatTimeString(
                                $Appointment->{StartTime},
                                'DateFormatShort'
                            ),
                            Class => $LastDay ? '' : 'First',
                        },
                    );

                    $LastDay = $Param{StartDay};
                }

                if ( $Appointment->{AllDay} ) {
                    $Appointment->{StartTime} = $Param{StartDate};
                    $Appointment->{EndTime}   = $Param{EndDate};
                }

                $LayoutObject->Block(
                    Name => 'AppointmentActionRow',
                    Data => {
                        %Param,
                        %{$Appointment},
                    },
                );
            }
        }
        else {
            $LayoutObject->Block(
                Name => 'AppointmentNoDataRow',
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'CalendarsNotFound',
        );
    }

    # start output
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # Trigger regular date picker initialization, used by AgentAppointmentEdit screen. This
    #   screen is initialized via AJAX, and then it's too late to output this configuration.
    $LayoutObject->{HasDatepicker} = 1;

    # Send data to JS.
    my %JSData = (
        EditAction        => $Param{EditAction}        || '',
        EditMaskSubaction => $Param{EditMaskSubaction} || '',
        Start             => $Param{Start},
    );
    $LayoutObject->AddJSData(
        Key   => 'AppointmentAgendaOverview',
        Value => {%JSData},
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentAppointmentAgendaOverview',
        Data         => \%Param,
    );

    # get page footer
    $Output .= $LayoutObject->Footer() if $Self->{Subaction} ne 'AJAXFilterUpdate';
    return $Output;
}

1;
