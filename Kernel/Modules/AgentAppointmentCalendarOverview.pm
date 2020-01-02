# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentAppointmentCalendarOverview;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{OverviewScreen} = 'CalendarOverview';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get all user's valid calendars
    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );

    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

    my @Calendars = $CalendarObject->CalendarList(
        UserID  => $Self->{UserID},
        ValidID => $ValidID,
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

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

    # check if we found some
    if (@Calendars) {

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

        # new appointment dialog
        if ( $Self->{Subaction} eq 'AppointmentCreate' ) {
            $LayoutObject->AddJSData(
                Key   => 'AppointmentCreate',
                Value => {
                    Start     => $ParamObject->GetParam( Param => 'Start' )     // undef,
                    End       => $ParamObject->GetParam( Param => 'End' )       // undef,
                    PluginKey => $ParamObject->GetParam( Param => 'PluginKey' ) // undef,
                    Search    => $ParamObject->GetParam( Param => 'Search' )    // undef,
                    ObjectID  => $ParamObject->GetParam( Param => 'ObjectID' )  // undef,
                },
            );
        }

        # show settings dialog
        elsif ( $Self->{Subaction} eq 'CalendarSettingsShow' ) {
            $LayoutObject->AddJSData(
                Key   => 'CalendarSettingsShow',
                Value => 1,
            );
        }

        # edit appointment dialog
        else {
            $LayoutObject->AddJSData(
                Key   => 'AppointmentID',
                Value => $ParamObject->GetParam( Param => 'AppointmentID' ) // undef,
            );
        }

        # Trigger regular date picker initialization, used by AgentAppointmentEdit screen. This
        #   screen is initialized via AJAX, and then it's too late to output this configuration.
        $LayoutObject->{HasDatepicker} = 1;

        $LayoutObject->Block(
            Name => 'AppointmentCreateButton',
        );

        $LayoutObject->Block(
            Name => 'CalendarDiv',
            Data => {
                %Param,
                CalendarWidth => 100,
            },
        );

        $LayoutObject->Block(
            Name => 'CalendarWidget',
        );

        # get user preferences
        my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
            UserID => $Self->{UserID},
        );

        # user preference key
        my $ShownAppointmentsPrefKey = 'User' . $Self->{OverviewScreen} . 'ShownAppointments';
        my $ShownAppointmentsPrefVal = $Preferences{$ShownAppointmentsPrefKey} || 1;

        # Shown appointments selection box.
        $LayoutObject->AddJSData(
            Key   => 'ShownAppointmentsStrg',
            Value => $LayoutObject->BuildSelection(
                Data => {
                    1 => $LayoutObject->{LanguageObject}->Translate('All appointments'),
                    2 => $LayoutObject->{LanguageObject}->Translate('Appointments assigned to me'),
                },
                Name         => 'ShownAppointments',
                ID           => 'ShownAppointments',
                Class        => 'Modernize',
                SelectedID   => $ShownAppointmentsPrefVal,
                PossibleNone => 0,
            ),
        );

        # show only assigned appointments to current user
        if ( $ShownAppointmentsPrefVal == 2 ) {
            $LayoutObject->AddJSData(
                Key   => 'ResourceID',
                Value => $Self->{UserID},
            );

            # display notify line
            $Param{NotifyLine} = {
                Priority => 'Warning',
                Data     => $LayoutObject->{LanguageObject}
                    ->Translate('Showing only appointments assigned to you! Change settings'),
                Link =>
                    $LayoutObject->{Baselink}
                    . 'Action=AgentAppointmentCalendarOverview;Subaction=CalendarSettingsShow',
            };
        }

        my $CalendarLimit = int $ConfigObject->Get('AppointmentCalendar::CalendarLimitOverview') || 10;
        $LayoutObject->AddJSData(
            Key   => 'CalendarLimit',
            Value => $CalendarLimit,
        );

        my $CalendarSelection = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
            Data => $Preferences{ 'User' . $Self->{OverviewScreen} . 'CalendarSelection' } || '[]',
        );

        my $CurrentCalendar = 1;
        my @CalendarConfig;
        for my $Calendar (@Calendars) {

            # check the calendar if stored in preferences
            if ( scalar @{$CalendarSelection} ) {
                if ( grep { $_ == $Calendar->{CalendarID} } @{$CalendarSelection} ) {
                    $Calendar->{Checked} = 'checked="checked" ' if $CurrentCalendar <= $CalendarLimit;
                    $CurrentCalendar++;
                }
            }

            # check calendar by default if limit is not yet reached
            else {
                $Calendar->{Checked} = 'checked="checked" ' if $CurrentCalendar <= $CalendarLimit;
                $CurrentCalendar++;
            }

            # get access tokens
            $Calendar->{AccessToken} = $CalendarObject->GetAccessToken(
                CalendarID => $Calendar->{CalendarID},
                UserLogin  => $Self->{UserLogin},
            );

            # calendar checkbox in the widget
            $LayoutObject->Block(
                Name => 'CalendarSwitch',
                Data => {
                    %{$Calendar},
                    %Param,
                },
            );

            # Calculate best text color.
            $Calendar->{TextColor} = $CalendarObject->GetTextColor(
                Background => $Calendar->{Color},
            ) || '#FFFFFF';

            # Define calendar configuration.
            push @CalendarConfig, $Calendar;
        }
        $LayoutObject->AddJSData(
            Key   => 'CalendarConfig',
            Value => \@CalendarConfig,
        );

        # Set initial view.
        $LayoutObject->AddJSData(
            Key   => 'DefaultView',
            Value => $Preferences{ 'User' . $Self->{OverviewScreen} . 'DefaultView' } || 'timelineWeek',
        );

        # check if team object is registered
        if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {

            # show resource block in tooltips
            $LayoutObject->AddJSData(
                Key   => 'TooltipTemplateResource',
                Value => 1,
            );
        }

        # get plugin list
        $Param{PluginList} = $Kernel::OM->Get('Kernel::System::Calendar::Plugin')->PluginList();

        $LayoutObject->AddJSData(
            Key   => 'PluginList',
            Value => $Param{PluginList},
        );

        # get registered ticket appointment types
        my %TicketAppointmentTypes = $CalendarObject->TicketAppointmentTypesGet();

        # Output configured ticket appointment type mark and draggability.
        my %TicketAppointmentConfig;
        for my $Type ( sort keys %TicketAppointmentTypes ) {
            my $NoDrag = 0;

            # prevent dragging of ticket escalation appointments
            if (
                $Type eq 'FirstResponseTime'
                || $Type eq 'UpdateTime'
                || $Type eq 'SolutionTime'
                )
            {
                $NoDrag = 1;
            }

            $TicketAppointmentConfig{$Type} = {
                Mark   => lc substr( $TicketAppointmentTypes{$Type}->{Mark}, 0, 1 ),
                NoDrag => $NoDrag,
            };
        }

        $LayoutObject->AddJSData(
            Key   => 'TicketAppointmentConfig',
            Value => \%TicketAppointmentConfig,
        );

        # Get working hour appointments.
        my @WorkingHours = $Self->_GetWorkingHours();
        my @WorkingHoursConfig;
        for my $Appointment (@WorkingHours) {

            # Sort days of the week.
            my @DoW = sort @{ $Appointment->{DoW} };

            push @WorkingHoursConfig, {
                id        => 'workingHours',
                start     => $Appointment->{StartTime},
                end       => $Appointment->{EndTime},
                color     => '#D7D7D7',
                rendering => 'inverse-background',
                editable  => '',
                dow       => \@DoW,
            };
        }
        $LayoutObject->AddJSData(
            Key   => 'WorkingHoursConfig',
            Value => \@WorkingHoursConfig,
        );
    }

    # show no calendar found message
    else {
        $LayoutObject->Block(
            Name => 'NoCalendar',
        );
    }

    $LayoutObject->AddJSData(
        Key   => 'OverviewScreen',
        Value => $Self->{OverviewScreen},
    );

    # Get text direction from language object.
    my $TextDirection = $LayoutObject->{LanguageObject}->{TextDirection} || '';
    $LayoutObject->AddJSData(
        Key   => 'IsRTLLanguage',
        Value => ( $TextDirection eq 'rtl' ) ? '1' : '',
    );

    $LayoutObject->AddJSData(
        Key   => 'CalendarWeekDayStart',
        Value => $Kernel::OM->Get('Kernel::Config')->Get('CalendarWeekDayStart') || 0,
    );

    # output page
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    if ( $Param{NotifyLine} ) {
        $Output .= $LayoutObject->Notify(
            %{ $Param{NotifyLine} },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentAppointmentCalendarOverview',
        Data         => {
            %Param,
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetWorkingHours {
    my ( $Self, %Param ) = @_;

    # get working hours from sysconfig
    my $WorkingHoursConfig = $Kernel::OM->Get('Kernel::Config')->Get('TimeWorkingHours');

    # create working hour appointments for each day
    my @WorkingHours;
    for my $DayName ( sort keys %{$WorkingHoursConfig} ) {

        # day of the week
        my $DoW = 0;    # Sun
        if ( $DayName eq 'Mon' ) {
            $DoW = 1;
        }
        elsif ( $DayName eq 'Tue' ) {
            $DoW = 2;
        }
        elsif ( $DayName eq 'Wed' ) {
            $DoW = 3;
        }
        elsif ( $DayName eq 'Thu' ) {
            $DoW = 4;
        }
        elsif ( $DayName eq 'Fri' ) {
            $DoW = 5;
        }
        elsif ( $DayName eq 'Sat' ) {
            $DoW = 6;
        }

        my $StartTime = 0;
        my $EndTime   = 0;

        START_TIME:
        for ( $StartTime = 0; $StartTime < 24; $StartTime++ ) {

            # is this working hour?
            if ( grep { $_ eq $StartTime } @{ $WorkingHoursConfig->{$DayName} } ) {

                # go to the end of the working hours
                for ( my $EndHour = $StartTime; $EndHour < 24; $EndHour++ ) {
                    if ( !grep { $_ eq $EndHour } @{ $WorkingHoursConfig->{$DayName} } ) {
                        $EndTime = $EndHour;

                        # add appointment
                        if ( $EndTime > $StartTime ) {
                            push @WorkingHours, {
                                StartTime => sprintf( '%02d:00:00', $StartTime ),
                                EndTime   => sprintf( '%02d:00:00', $EndTime ),
                                DoW       => [$DoW],
                            };
                        }

                        # skip some hours
                        $StartTime = $EndHour;

                        next START_TIME;
                    }
                }
            }
        }
    }

    # collapse appointments with same start and end times
    for my $AppointmentA (@WorkingHours) {
        for my $AppointmentB (@WorkingHours) {
            if (
                $AppointmentA->{StartTime} && $AppointmentB->{StartTime}
                && $AppointmentA->{StartTime} eq $AppointmentB->{StartTime}
                && $AppointmentA->{EndTime} eq $AppointmentB->{EndTime}
                && $AppointmentA->{DoW} ne $AppointmentB->{DoW}
                )
            {
                push @{ $AppointmentA->{DoW} }, @{ $AppointmentB->{DoW} };
                $AppointmentB = undef;
            }
        }
    }

    # return only non-empty appointments
    return grep { scalar keys %{$_} } @WorkingHours;
}

1;
