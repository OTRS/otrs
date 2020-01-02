# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentAppointmentEdit;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{EmptyString} = '-';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get names of all parameters
    my @ParamNames = $ParamObject->GetParamNames();

    # get params
    my %GetParam;
    PARAMNAME:
    for my $Key (@ParamNames) {

        # skip the Action parameter, it's giving BuildDateSelection problems for some reason
        next PARAMNAME if $Key eq 'Action';

        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    my $PluginObject      = $Kernel::OM->Get('Kernel::System::Calendar::Plugin');

    my $JSON = $LayoutObject->JSONEncode( Data => [] );

    my %PermissionLevel = (
        'ro'        => 1,
        'move_into' => 2,
        'create'    => 3,
        'note'      => 4,
        'owner'     => 5,
        'priority'  => 6,
        'rw'        => 7,
    );

    my $Permissions = 'rw';

    # challenge token check
    $LayoutObject->ChallengeTokenCheck();

    # ------------------------------------------------------------ #
    # edit mask
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'EditMask' ) {

        # get all user's valid calendars
        my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
            Valid => 'valid',
        );
        my @Calendars = $CalendarObject->CalendarList(
            UserID  => $Self->{UserID},
            ValidID => $ValidID,
        );

        # transform data for select box
        my @CalendarData = map {
            {
                Key   => $_->{CalendarID},
                Value => $_->{CalendarName},
            }
        } @Calendars;

        # transform data for ID lookup
        my %CalendarLookup = map {
            $_->{CalendarID} => $_->{CalendarName}
        } @Calendars;

        for my $Calendar (@CalendarData) {

            # check permissions
            my $CalendarPermission = $CalendarObject->CalendarPermissionGet(
                CalendarID => $Calendar->{Key},
                UserID     => $Self->{UserID},
            );

            if ( $PermissionLevel{$CalendarPermission} < 3 ) {

                # permissions < create
                $Calendar->{Disabled} = 1;
            }
        }

        # define year boundaries
        my ( %YearPeriodPast, %YearPeriodFuture );
        for my $Field (qw (Start End RecurrenceUntil)) {
            $YearPeriodPast{$Field} = $YearPeriodFuture{$Field} = 5;
        }

        # do not use date selection time zone calculation by default
        my $OverrideTimeZone = 1;

        my %Appointment;
        if ( $GetParam{AppointmentID} ) {
            %Appointment = $AppointmentObject->AppointmentGet(
                AppointmentID => $GetParam{AppointmentID},
            );

            # non-existent appointment
            if ( !$Appointment{AppointmentID} ) {
                my $Output = $LayoutObject->Error(
                    Message => Translatable('Appointment not found!'),
                );
                return $LayoutObject->Attachment(
                    NoCache     => 1,
                    ContentType => 'text/html',
                    Charset     => $LayoutObject->{UserCharset},
                    Content     => $Output,
                    Type        => 'inline',
                );
            }

            # use time zone calculation if editing existing appointments
            # but only if not dealing with an all day appointment
            else {
                $OverrideTimeZone = $Appointment{AllDay} || 0;
            }

            # check permissions
            $Permissions = $CalendarObject->CalendarPermissionGet(
                CalendarID => $Appointment{CalendarID},
                UserID     => $Self->{UserID},
            );

            # Get start time components.
            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Appointment{StartTime},
                },
            );
            my $StartTimeSettings = $StartTimeObject->Get();
            my $StartTimeComponents;
            for my $Key ( sort keys %{$StartTimeSettings} ) {
                $StartTimeComponents->{"Start$Key"} = $StartTimeSettings->{$Key};
            }

            # Get end time components.
            my $EndTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Appointment{EndTime},
                },
            );

            # End times for all day appointments are inclusive, subtract whole day.
            if ( $Appointment{AllDay} ) {
                $EndTimeObject->Subtract(
                    Days => 1,
                );
                if ( $EndTimeObject < $StartTimeObject ) {
                    $EndTimeObject = $StartTimeObject->Clone();
                }
            }

            my $EndTimeSettings = $EndTimeObject->Get();
            my $EndTimeComponents;
            for my $Key ( sort keys %{$EndTimeSettings} ) {
                $EndTimeComponents->{"End$Key"} = $EndTimeSettings->{$Key};
            }

            %Appointment = ( %Appointment, %{$StartTimeComponents}, %{$EndTimeComponents} );

            # Get recurrence until components.
            if ( $Appointment{RecurrenceUntil} ) {
                my $RecurrenceUntilTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $Appointment{RecurrenceUntil},
                    },
                );
                my $RecurrenceUntilSettings = $RecurrenceUntilTimeObject->Get();
                my $RecurrenceUntilComponents;
                for my $Key ( sort keys %{$EndTimeSettings} ) {
                    $RecurrenceUntilComponents->{"RecurrenceUntil$Key"} = $RecurrenceUntilSettings->{$Key};
                }

                %Appointment = ( %Appointment, %{$RecurrenceUntilComponents} );
            }

            # Recalculate year boundaries for build selection method.
            my $DateTimeObject   = $Kernel::OM->Create('Kernel::System::DateTime');
            my $DateTimeSettings = $DateTimeObject->Get();

            for my $Field (qw(Start End RecurrenceUntil)) {
                if ( $Appointment{"${Field}Year"} ) {
                    my $Diff = $Appointment{"${Field}Year"} - $DateTimeSettings->{Year};
                    if ( $Diff > 0 && abs $Diff > $YearPeriodFuture{$Field} ) {
                        $YearPeriodFuture{$Field} = abs $Diff;
                    }
                    elsif ( $Diff < 0 && abs $Diff > $YearPeriodPast{$Field} ) {
                        $YearPeriodPast{$Field} = abs $Diff;
                    }
                }
            }

            if ( $Appointment{Recurring} ) {
                my $RecurrenceType = $GetParam{RecurrenceType} || $Appointment{RecurrenceType};

                if ( $RecurrenceType eq 'CustomWeekly' ) {

                    my $DayOffset = $Self->_DayOffsetGet(
                        Time => $Appointment{StartTime},
                    );

                    if ( defined $GetParam{Days} ) {

                        # check parameters
                        $Appointment{Days} = $GetParam{Days};
                    }
                    else {
                        my @Days = @{ $Appointment{RecurrenceFrequency} };

                        # display selected days according to user timezone
                        if ($DayOffset) {
                            for my $Day (@Days) {
                                $Day += $DayOffset;

                                if ( $Day == 8 ) {
                                    $Day = 1;
                                }
                            }
                        }

                        $Appointment{Days} = join( ",", @Days );
                    }
                }
                elsif ( $RecurrenceType eq 'CustomMonthly' ) {

                    my $DayOffset = $Self->_DayOffsetGet(
                        Time => $Appointment{StartTime},
                    );

                    if ( defined $GetParam{MonthDays} ) {

                        # check parameters
                        $Appointment{MonthDays} = $GetParam{MonthDays};
                    }
                    else {
                        my @MonthDays = @{ $Appointment{RecurrenceFrequency} };

                        # display selected days according to user timezone
                        if ($DayOffset) {
                            for my $MonthDay (@MonthDays) {
                                $MonthDay += $DayOffset;
                                if ( $DateTimeSettings->{Day} == 32 ) {
                                    $MonthDay = 1;
                                }
                            }
                        }
                        $Appointment{MonthDays} = join( ",", @MonthDays );
                    }
                }
                elsif ( $RecurrenceType eq 'CustomYearly' ) {

                    my $DayOffset = $Self->_DayOffsetGet(
                        Time => $Appointment{StartTime},
                    );

                    if ( defined $GetParam{Months} ) {

                        # check parameters
                        $Appointment{Months} = $GetParam{Months};
                    }
                    else {
                        my @Months = @{ $Appointment{RecurrenceFrequency} };
                        $Appointment{Months} = join( ",", @Months );
                    }
                }
            }

            # Check if dealing with ticket appointment.
            if ( $Appointment{TicketAppointmentRuleID} ) {
                $GetParam{TicketID} = $CalendarObject->TicketAppointmentTicketID(
                    AppointmentID => $Appointment{AppointmentID},
                );

                my $Rule = $CalendarObject->TicketAppointmentRuleGet(
                    CalendarID => $Appointment{CalendarID},
                    RuleID     => $Appointment{TicketAppointmentRuleID},
                );

                # Get date types from the ticket appointment rule.
                if ( IsHashRefWithData($Rule) ) {
                    for my $Type (qw(StartDate EndDate)) {
                        if (
                            $Rule->{$Type} eq 'FirstResponseTime'
                            || $Rule->{$Type} eq 'UpdateTime'
                            || $Rule->{$Type} eq 'SolutionTime'
                            || $Rule->{$Type} eq 'PendingTime'
                            )
                        {
                            $GetParam{ReadOnlyStart}    = 1 if $Type eq 'StartDate';
                            $GetParam{ReadOnlyDuration} = 1 if $Type eq 'EndDate';
                        }
                        elsif ( $Rule->{$Type} =~ /^Plus_[0-9]+$/ ) {
                            $GetParam{ReadOnlyDuration} = 1;
                        }
                    }
                }
            }
        }

        # get selected timestamp
        my $SelectedTimestamp = sprintf(
            "%04d-%02d-%02d 00:00:00",
            $Appointment{StartYear}  // $GetParam{StartYear},
            $Appointment{StartMonth} // $GetParam{StartMonth},
            $Appointment{StartDay}   // $GetParam{StartDay}
        );

        # Get current date components.
        my $SelectedSystemTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $SelectedTimestamp,
            },
        );
        my $SelectedSystemTimeSettings = $SelectedSystemTimeObject->Get();

        # Set current date components if not defined.
        $Appointment{Days}      //= $SelectedSystemTimeSettings->{DayOfWeek};
        $Appointment{MonthDays} //= $SelectedSystemTimeSettings->{Day};
        $Appointment{Months}    //= $SelectedSystemTimeSettings->{Month};

        # calendar ID selection
        my $CalendarID = $Appointment{CalendarID} // $GetParam{CalendarID};

        # calendar name
        if ($CalendarID) {
            $Param{CalendarName} = $CalendarLookup{$CalendarID};
        }

        # calendar selection
        $Param{CalendarIDStrg} = $LayoutObject->BuildSelection(
            Data         => \@CalendarData,
            SelectedID   => $CalendarID,
            Name         => 'CalendarID',
            Multiple     => 0,
            Class        => 'Modernize Validate_Required',
            PossibleNone => 1,
        );

        # all day
        if (
            $GetParam{AllDay} ||
            ( $GetParam{AppointmentID} && $Appointment{AllDay} )
            )
        {
            $Param{AllDayString}  = Translatable('Yes');
            $Param{AllDayChecked} = 'checked="checked"';

            # start date
            $Param{StartDate} = sprintf(
                "%04d-%02d-%02d",
                $Appointment{StartYear}  // $GetParam{StartYear},
                $Appointment{StartMonth} // $GetParam{StartMonth},
                $Appointment{StartDay}   // $GetParam{StartDay},
            );

            # end date
            $Param{EndDate} = sprintf(
                "%04d-%02d-%02d",
                $Appointment{EndYear}  // $GetParam{EndYear},
                $Appointment{EndMonth} // $GetParam{EndMonth},
                $Appointment{EndDay}   // $GetParam{EndDay},
            );
        }
        else {
            $Param{AllDayString}  = Translatable('No');
            $Param{AllDayChecked} = '';

            # start date
            $Param{StartDate} = sprintf(
                "%04d-%02d-%02d %02d:%02d:00",
                $Appointment{StartYear}   // $GetParam{StartYear},
                $Appointment{StartMonth}  // $GetParam{StartMonth},
                $Appointment{StartDay}    // $GetParam{StartDay},
                $Appointment{StartHour}   // $GetParam{StartHour},
                $Appointment{StartMinute} // $GetParam{StartMinute},
            );

            # end date
            $Param{EndDate} = sprintf(
                "%04d-%02d-%02d %02d:%02d:00",
                $Appointment{EndYear}   // $GetParam{EndYear},
                $Appointment{EndMonth}  // $GetParam{EndMonth},
                $Appointment{EndDay}    // $GetParam{EndDay},
                $Appointment{EndHour}   // $GetParam{EndHour},
                $Appointment{EndMinute} // $GetParam{EndMinute},
            );
        }

        # start date string
        $Param{StartDateString} = $LayoutObject->BuildDateSelection(
            %GetParam,
            %Appointment,
            Prefix                   => 'Start',
            StartHour                => $Appointment{StartHour} // $GetParam{StartHour},
            StartMinute              => $Appointment{StartMinute} // $GetParam{StartMinute},
            Format                   => 'DateInputFormatLong',
            ValidateDateBeforePrefix => 'End',
            Validate                 => $Appointment{TicketAppointmentRuleID} && $GetParam{ReadOnlyStart} ? 0 : 1,
            YearPeriodPast           => $YearPeriodPast{Start},
            YearPeriodFuture         => $YearPeriodFuture{Start},
            OverrideTimeZone         => $OverrideTimeZone,
        );

        # end date string
        $Param{EndDateString} = $LayoutObject->BuildDateSelection(
            %GetParam,
            %Appointment,
            Prefix                  => 'End',
            EndHour                 => $Appointment{EndHour} // $GetParam{EndHour},
            EndMinute               => $Appointment{EndMinute} // $GetParam{EndMinute},
            Format                  => 'DateInputFormatLong',
            ValidateDateAfterPrefix => 'Start',
            Validate                => $Appointment{TicketAppointmentRuleID} && $GetParam{ReadOnlyDuration} ? 0 : 1,
            YearPeriodPast          => $YearPeriodPast{End},
            YearPeriodFuture        => $YearPeriodFuture{End},
            OverrideTimeZone        => $OverrideTimeZone,
        );

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        # check if team object is registered
        if ( $MainObject->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {

            my $TeamIDs = $Appointment{TeamID};
            if ( !$TeamIDs ) {
                my @TeamIDs = $ParamObject->GetArray( Param => 'TeamID[]' );
                $TeamIDs = \@TeamIDs;
            }

            my $ResourceIDs = $Appointment{ResourceID};
            if ( !$ResourceIDs ) {
                my @ResourceIDs = $ParamObject->GetArray( Param => 'ResourceID[]' );
                $ResourceIDs = \@ResourceIDs;
            }

            # get needed objects
            my $TeamObject = $Kernel::OM->Get('Kernel::System::Calendar::Team');
            my $UserObject = $Kernel::OM->Get('Kernel::System::User');

            # get allowed team list for current user
            my %TeamList = $TeamObject->AllowedTeamList(
                PreventEmpty => 1,
                UserID       => $Self->{UserID},
            );

            # team names
            my @TeamNames;
            for my $TeamID ( @{$TeamIDs} ) {
                push @TeamNames, $TeamList{$TeamID} if $TeamList{$TeamID};
            }
            if ( scalar @TeamNames ) {
                $Param{TeamNames} = join( '<br>', @TeamNames );
            }
            else {
                $Param{TeamNames} = $Self->{EmptyString};
            }

            # team list string
            $Param{TeamIDStrg} = $LayoutObject->BuildSelection(
                Data         => \%TeamList,
                SelectedID   => $TeamIDs,
                Name         => 'TeamID',
                Multiple     => 1,
                Class        => 'Modernize',
                PossibleNone => 1,
            );

            # iterate through selected teams
            my %TeamUserListAll;
            TEAMID:
            for my $TeamID ( @{$TeamIDs} ) {
                next TEAMID if !$TeamID;

                # get list of team members
                my %TeamUserList = $TeamObject->TeamUserList(
                    TeamID => $TeamID,
                    UserID => $Self->{UserID},
                );

                # get user data
                for my $UserID ( sort keys %TeamUserList ) {
                    my %User = $UserObject->GetUserData(
                        UserID => $UserID,
                    );
                    $TeamUserList{$UserID} = $User{UserFullname};
                }

                %TeamUserListAll = ( %TeamUserListAll, %TeamUserList );
            }

            # resource names
            my @ResourceNames;
            for my $ResourceID ( @{$ResourceIDs} ) {
                push @ResourceNames, $TeamUserListAll{$ResourceID} if $TeamUserListAll{$ResourceID};
            }
            if ( scalar @ResourceNames ) {
                $Param{ResourceNames} = join( '<br>', @ResourceNames );
            }
            else {
                $Param{ResourceNames} = $Self->{EmptyString};
            }

            # team user list string
            $Param{ResourceIDStrg} = $LayoutObject->BuildSelection(
                Data         => \%TeamUserListAll,
                SelectedID   => $ResourceIDs,
                Name         => 'ResourceID',
                Multiple     => 1,
                Class        => 'Modernize',
                PossibleNone => 1,
            );
        }

        my $SelectedRecurrenceType       = 0;
        my $SelectedRecurrenceCustomType = 'CustomDaily';    # default

        if ( $Appointment{Recurring} ) {

            # from appointment
            $SelectedRecurrenceType = $GetParam{RecurrenceType} || $Appointment{RecurrenceType};
            if ( $SelectedRecurrenceType =~ /Custom/ ) {
                $SelectedRecurrenceCustomType = $SelectedRecurrenceType;
                $SelectedRecurrenceType       = 'Custom';
            }
        }

        # recurrence type
        my @RecurrenceTypes = (
            {
                Key   => '0',
                Value => Translatable('Never'),
            },
            {
                Key   => 'Daily',
                Value => Translatable('Every Day'),
            },
            {
                Key   => 'Weekly',
                Value => Translatable('Every Week'),
            },
            {
                Key   => 'Monthly',
                Value => Translatable('Every Month'),
            },
            {
                Key   => 'Yearly',
                Value => Translatable('Every Year'),
            },
            {
                Key   => 'Custom',
                Value => Translatable('Custom'),
            },
        );
        my %RecurrenceTypeLookup = map {
            $_->{Key} => $_->{Value}
        } @RecurrenceTypes;
        $Param{RecurrenceValue} = $LayoutObject->{LanguageObject}->Translate(
            $RecurrenceTypeLookup{$SelectedRecurrenceType},
        );

        # recurrence type selection
        $Param{RecurrenceTypeString} = $LayoutObject->BuildSelection(
            Data         => \@RecurrenceTypes,
            SelectedID   => $SelectedRecurrenceType,
            Name         => 'RecurrenceType',
            Multiple     => 0,
            Class        => 'Modernize',
            PossibleNone => 0,
        );

        # recurrence custom type
        my @RecurrenceCustomTypes = (
            {
                Key   => 'CustomDaily',
                Value => Translatable('Daily'),
            },
            {
                Key   => 'CustomWeekly',
                Value => Translatable('Weekly'),
            },
            {
                Key   => 'CustomMonthly',
                Value => Translatable('Monthly'),
            },
            {
                Key   => 'CustomYearly',
                Value => Translatable('Yearly'),
            },
        );
        my %RecurrenceCustomTypeLookup = map {
            $_->{Key} => $_->{Value}
        } @RecurrenceCustomTypes;
        my $RecurrenceCustomType = $RecurrenceCustomTypeLookup{$SelectedRecurrenceCustomType};
        $Param{RecurrenceValue} .= ', ' . $LayoutObject->{LanguageObject}->Translate(
            lc $RecurrenceCustomType,
        ) if $RecurrenceCustomType && $SelectedRecurrenceType eq 'Custom';

        # recurrence custom type selection
        $Param{RecurrenceCustomTypeString} = $LayoutObject->BuildSelection(
            Data       => \@RecurrenceCustomTypes,
            SelectedID => $SelectedRecurrenceCustomType,
            Name       => 'RecurrenceCustomType',
            Class      => 'Modernize',
        );

        # recurrence interval
        my $SelectedInterval = $GetParam{RecurrenceInterval} || $Appointment{RecurrenceInterval} || 1;
        if ( $Appointment{RecurrenceInterval} ) {
            my %RecurrenceIntervalLookup = (
                'CustomDaily' => $LayoutObject->{LanguageObject}->Translate(
                    'day(s)',
                ),
                'CustomWeekly' => $LayoutObject->{LanguageObject}->Translate(
                    'week(s)',
                ),
                'CustomMonthly' => $LayoutObject->{LanguageObject}->Translate(
                    'month(s)',
                ),
                'CustomYearly' => $LayoutObject->{LanguageObject}->Translate(
                    'year(s)',
                ),
            );

            if ( $RecurrenceCustomType && $SelectedRecurrenceType eq 'Custom' ) {
                $Param{RecurrenceValue} .= ', '
                    . $LayoutObject->{LanguageObject}->Translate('every')
                    . ' ' . $Appointment{RecurrenceInterval} . ' '
                    . $RecurrenceIntervalLookup{$SelectedRecurrenceCustomType};
            }
        }

        # add interval selection (1-31)
        my @RecurrenceCustomInterval;
        for ( my $DayNumber = 1; $DayNumber < 32; $DayNumber++ ) {
            push @RecurrenceCustomInterval, {
                Key   => $DayNumber,
                Value => $DayNumber,
            };
        }
        $Param{RecurrenceIntervalString} = $LayoutObject->BuildSelection(
            Data       => \@RecurrenceCustomInterval,
            SelectedID => $SelectedInterval,
            Name       => 'RecurrenceInterval',
        );

        # recurrence limit
        my $RecurrenceLimit = 1;
        if ( $Appointment{RecurrenceCount} ) {
            $RecurrenceLimit = 2;

            if ($SelectedRecurrenceType) {
                $Param{RecurrenceValue} .= ', ' . $LayoutObject->{LanguageObject}->Translate(
                    'for %s time(s)', $Appointment{RecurrenceCount},
                );
            }
        }

        # recurrence limit string
        $Param{RecurrenceLimitString} = $LayoutObject->BuildSelection(
            Data => [
                {
                    Key   => 1,
                    Value => Translatable('until ...'),
                },
                {
                    Key   => 2,
                    Value => Translatable('for ... time(s)'),
                },
            ],
            SelectedID   => $RecurrenceLimit,
            Name         => 'RecurrenceLimit',
            Multiple     => 0,
            Class        => 'Modernize',
            PossibleNone => 0,
        );

        my $RecurrenceUntilDiffTime = 0;
        if ( !$Appointment{RecurrenceUntil} ) {

            # Get current and start time for difference.
            my $SystemTime      = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Year   => $Appointment{StartYear}   // $GetParam{StartYear},
                    Month  => $Appointment{StartMonth}  // $GetParam{StartMonth},
                    Day    => $Appointment{StartDay}    // $GetParam{StartDay},
                    Hour   => $Appointment{StartHour}   // $GetParam{StartHour},
                    Minute => $Appointment{StartMinute} // $GetParam{StartMinute},
                    Second => 0,
                },
            );
            my $StartTime = $StartTimeObject->ToEpoch();

            $RecurrenceUntilDiffTime = $StartTime - $SystemTime + 60 * 60 * 24 * 3;    # start +3 days
        }
        else {
            $Param{RecurrenceUntil} = sprintf(
                "%04d-%02d-%02d",
                $Appointment{RecurrenceUntilYear},
                $Appointment{RecurrenceUntilMonth},
                $Appointment{RecurrenceUntilDay},
            );

            if ($SelectedRecurrenceType) {
                $Param{RecurrenceValue} .= ', ' . $LayoutObject->{LanguageObject}->Translate(
                    'until %s', $Param{RecurrenceUntil},
                );
            }
        }

        # recurrence until date string
        $Param{RecurrenceUntilString} = $LayoutObject->BuildDateSelection(
            %Appointment,
            %GetParam,
            Prefix                  => 'RecurrenceUntil',
            Format                  => 'DateInputFormat',
            DiffTime                => $RecurrenceUntilDiffTime,
            ValidateDateAfterPrefix => 'Start',
            Validate                => 1,
            YearPeriodPast          => $YearPeriodPast{RecurrenceUntil},
            YearPeriodFuture        => $YearPeriodFuture{RecurrenceUntil},
            OverrideTimeZone        => $OverrideTimeZone,
        );

        # notification template
        my @NotificationTemplates = (
            {
                Key   => '0',
                Value => $LayoutObject->{LanguageObject}->Translate('No notification'),
            },
            {
                Key   => 'Start',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s minute(s) before', 0 ),
            },
            {
                Key   => '300',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s minute(s) before', 5 ),
            },
            {
                Key   => '900',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s minute(s) before', 15 ),
            },
            {
                Key   => '1800',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s minute(s) before', 30 ),
            },
            {
                Key   => '3600',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s hour(s) before', 1 ),
            },
            {
                Key   => '7200',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s hour(s) before', 2 ),
            },
            {
                Key   => '43200',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s hour(s) before', 12 ),
            },
            {
                Key   => '86400',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s day(s) before', 1 ),
            },
            {
                Key   => '172800',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s day(s) before', 2 ),
            },
            {
                Key   => '604800',
                Value => $LayoutObject->{LanguageObject}->Translate( '%s week before', 1 ),
            },
            {
                Key   => 'Custom',
                Value => $LayoutObject->{LanguageObject}->Translate('Custom'),
            },
        );
        my %NotificationTemplateLookup = map {
            $_->{Key} => $_->{Value}
        } @NotificationTemplates;
        my $SelectedNotificationTemplate = $Appointment{NotificationTemplate} || '0';
        $Param{NotificationValue} = $NotificationTemplateLookup{$SelectedNotificationTemplate};

        # notification selection
        $Param{NotificationStrg} = $LayoutObject->BuildSelection(
            Data         => \@NotificationTemplates,
            SelectedID   => $SelectedNotificationTemplate,
            Name         => 'NotificationTemplate',
            Multiple     => 0,
            Class        => 'Modernize',
            PossibleNone => 0,
        );

        # notification custom units
        my @NotificationCustomUnits = (
            {
                Key   => 'minutes',
                Value => $LayoutObject->{LanguageObject}->Translate('minute(s)'),
            },
            {
                Key   => 'hours',
                Value => $LayoutObject->{LanguageObject}->Translate('hour(s)'),
            },
            {
                Key   => 'days',
                Value => $LayoutObject->{LanguageObject}->Translate('day(s)'),
            },
        );
        my %NotificationCustomUnitLookup = map {
            $_->{Key} => $_->{Value}
        } @NotificationCustomUnits;
        my $SelectedNotificationCustomUnit = $Appointment{NotificationCustomRelativeUnit} || 'minutes';

        # notification custom units selection
        $Param{NotificationCustomUnitsStrg} = $LayoutObject->BuildSelection(
            Data         => \@NotificationCustomUnits,
            SelectedID   => $SelectedNotificationCustomUnit,
            Name         => 'NotificationCustomRelativeUnit',
            Multiple     => 0,
            Class        => 'Modernize',
            PossibleNone => 0,
        );

        # notification custom units point of time
        my @NotificationCustomUnitsPointOfTime = (
            {
                Key   => 'beforestart',
                Value => $LayoutObject->{LanguageObject}->Translate('before the appointment starts'),
            },
            {
                Key   => 'afterstart',
                Value => $LayoutObject->{LanguageObject}->Translate('after the appointment has been started'),
            },
            {
                Key   => 'beforeend',
                Value => $LayoutObject->{LanguageObject}->Translate('before the appointment ends'),
            },
            {
                Key   => 'afterend',
                Value => $LayoutObject->{LanguageObject}->Translate('after the appointment has been ended'),
            },
        );
        my %NotificationCustomUnitPointOfTimeLookup = map {
            $_->{Key} => $_->{Value}
        } @NotificationCustomUnitsPointOfTime;
        my $SelectedNotificationCustomUnitPointOfTime = $Appointment{NotificationCustomRelativePointOfTime}
            || 'beforestart';

        # notification custom units point of time selection
        $Param{NotificationCustomUnitsPointOfTimeStrg} = $LayoutObject->BuildSelection(
            Data         => \@NotificationCustomUnitsPointOfTime,
            SelectedID   => $SelectedNotificationCustomUnitPointOfTime,
            Name         => 'NotificationCustomRelativePointOfTime',
            Multiple     => 0,
            Class        => 'Modernize',
            PossibleNone => 0,
        );

        # Extract the date units for the custom date selection.
        my $NotificationCustomDateTimeSettings = {};
        if ( $Appointment{NotificationCustomDateTime} ) {
            my $NotificationCustomDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Appointment{NotificationCustomDateTime},
                },
            );
            $NotificationCustomDateTimeSettings = $NotificationCustomDateTimeObject->Get();
        }

        # notification custom date selection
        $Param{NotificationCustomDateTimeStrg} = $LayoutObject->BuildDateSelection(
            Prefix                           => 'NotificationCustomDateTime',
            NotificationCustomDateTimeYear   => $NotificationCustomDateTimeSettings->{Year},
            NotificationCustomDateTimeMonth  => $NotificationCustomDateTimeSettings->{Month},
            NotificationCustomDateTimeDay    => $NotificationCustomDateTimeSettings->{Day},
            NotificationCustomDateTimeHour   => $NotificationCustomDateTimeSettings->{Hour},
            NotificationCustomDateTimeMinute => $NotificationCustomDateTimeSettings->{Minute},
            Format                           => 'DateInputFormatLong',
            YearPeriodPast                   => $YearPeriodPast{Start},
            YearPeriodFuture                 => $YearPeriodFuture{Start},
        );

        # prepare radio button for custom date time and relative input
        $Appointment{NotificationCustom} ||= '';

        if ( $Appointment{NotificationCustom} eq 'datetime' ) {
            $Param{NotificationCustomDateTimeInputRadio} = 'checked="checked"';
        }
        elsif ( $Appointment{NotificationCustom} eq 'relative' ) {
            $Param{NotificationCustomRelativeInputRadio} = 'checked="checked"';
        }
        else {
            $Param{NotificationCustomRelativeInputRadio} = 'checked="checked"';
        }

        # notification custom string value
        if ( $Appointment{NotificationCustom} eq 'datetime' ) {
            $Param{NotificationValue} .= ', ' . $LayoutObject->{LanguageObject}->FormatTimeString(
                $Appointment{NotificationCustomDateTime},
                'DateFormat'
            );
        }
        elsif ( $Appointment{NotificationCustom} eq 'relative' ) {
            if (
                $Appointment{NotificationCustomRelativeUnit}
                && $Appointment{NotificationCustomRelativePointOfTime}
                )
            {
                $Appointment{NotificationCustomRelativeUnitCount} ||= 0;
                $Param{NotificationValue} .= ', '
                    . $Appointment{NotificationCustomRelativeUnitCount}
                    . ' '
                    . $NotificationCustomUnitLookup{$SelectedNotificationCustomUnit}
                    . ' '
                    . $NotificationCustomUnitPointOfTimeLookup{$SelectedNotificationCustomUnitPointOfTime};
            }
        }

        # get plugin list
        $Param{PluginList} = $PluginObject->PluginList();

        # new appointment plugin search
        if ( $GetParam{PluginKey} && ( $GetParam{Search} || $GetParam{ObjectID} ) ) {

            if ( grep { $_ eq $GetParam{PluginKey} } keys %{ $Param{PluginList} } ) {

                # search using plugin
                my $ResultList = $PluginObject->PluginSearch(
                    %GetParam,
                    UserID => $Self->{UserID},
                );

                $Param{PluginData}->{ $GetParam{PluginKey} } = [];
                my @LinkArray = sort keys %{$ResultList};

                # add possible links
                for my $LinkID (@LinkArray) {
                    push @{ $Param{PluginData}->{ $GetParam{PluginKey} } }, {
                        LinkID   => $LinkID,
                        LinkName => $ResultList->{$LinkID},
                        LinkURL  => sprintf(
                            $Param{PluginList}->{ $GetParam{PluginKey} }->{PluginURL},
                            $LinkID
                        ),
                    };
                }

                $Param{PluginList}->{ $GetParam{PluginKey} }->{LinkList} = $LayoutObject->JSONEncode(
                    Data => \@LinkArray,
                );
            }
        }

        # edit appointment plugin links
        elsif ( $GetParam{AppointmentID} ) {

            for my $PluginKey ( sort keys %{ $Param{PluginList} } ) {
                my $LinkList = $PluginObject->PluginLinkList(
                    AppointmentID => $GetParam{AppointmentID},
                    PluginKey     => $PluginKey,
                    UserID        => $Self->{UserID},
                );
                my @LinkArray;

                $Param{PluginData}->{$PluginKey} = [];
                for my $LinkID ( sort keys %{$LinkList} ) {
                    push @{ $Param{PluginData}->{$PluginKey} }, $LinkList->{$LinkID};
                    push @LinkArray, $LinkList->{$LinkID}->{LinkID};
                }

                $Param{PluginList}->{$PluginKey}->{LinkList} = $LayoutObject->JSONEncode(
                    Data => \@LinkArray,
                );
            }
        }

        # html mask output
        $LayoutObject->Block(
            Name => 'EditMask',
            Data => {
                %Param,
                %GetParam,
                %Appointment,
                PermissionLevel => $PermissionLevel{$Permissions},
            },
        );

        $LayoutObject->AddJSData(
            Key   => 'CalendarPermissionLevel',
            Value => $PermissionLevel{$Permissions},
        );
        $LayoutObject->AddJSData(
            Key   => 'EditAppointmentID',
            Value => $Appointment{AppointmentID} // '',
        );
        $LayoutObject->AddJSData(
            Key   => 'EditParentID',
            Value => $Appointment{ParentID} // '',
        );

        # get registered location links
        my $LocationLinkConfig = $ConfigObject->Get('AgentAppointmentEdit::Location::Link') // {};
        for my $ConfigKey ( sort keys %{$LocationLinkConfig} ) {

            # show link icon
            $LayoutObject->Block(
                Name => 'LocationLink',
                Data => {
                    Location => $Appointment{Location} // '',
                    %{ $LocationLinkConfig->{$ConfigKey} },
                },
            );
        }

        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentAppointmentEdit',
            Data         => {
                %Param,
                %GetParam,
                %Appointment,
            },
            AJAX => 1,
        );
        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # ------------------------------------------------------------ #
    # add/edit appointment
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EditAppointment' ) {
        my %Appointment;
        if ( $GetParam{AppointmentID} ) {
            %Appointment = $AppointmentObject->AppointmentGet(
                AppointmentID => $GetParam{AppointmentID},
            );

            # check permissions
            $Permissions = $CalendarObject->CalendarPermissionGet(
                CalendarID => $Appointment{CalendarID},
                UserID     => $Self->{UserID},
            );

            my $RequiredPermission = 2;
            if ( $GetParam{CalendarID} && $GetParam{CalendarID} != $Appointment{CalendarID} ) {

                # in order to move appointment to another calendar, user needs "create" permission
                $RequiredPermission = 3;
            }

            if ( $PermissionLevel{$Permissions} < $RequiredPermission ) {

                # no permission

                # build JSON output
                $JSON = $LayoutObject->JSONEncode(
                    Data => {
                        Success => 0,
                        Error   => Translatable('No permission!'),
                    },
                );

                # send JSON response
                return $LayoutObject->Attachment(
                    ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
                    Content     => $JSON,
                    Type        => 'inline',
                    NoCache     => 1,
                );
            }
        }

        if ( $GetParam{AllDay} ) {
            $GetParam{StartTime} = sprintf(
                "%04d-%02d-%02d 00:00:00",
                $GetParam{StartYear}, $GetParam{StartMonth}, $GetParam{StartDay}
            );
            $GetParam{EndTime} = sprintf(
                "%04d-%02d-%02d 00:00:00",
                $GetParam{EndYear}, $GetParam{EndMonth}, $GetParam{EndDay}
            );

            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $GetParam{StartTime},
                },
            );
            my $EndTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $GetParam{EndTime},
                },
            );

            # Prevent storing end time before start time.
            if ( $EndTimeObject < $StartTimeObject ) {
                $EndTimeObject = $StartTimeObject->Clone();
            }

            # Make end time inclusive, add whole day.
            $EndTimeObject->Add(
                Days => 1,
            );
            $GetParam{EndTime} = $EndTimeObject->ToString();
        }
        elsif ( $GetParam{Recurring} && $GetParam{UpdateType} && $GetParam{UpdateDelta} ) {

            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Appointment{StartTime},
                },
            );
            my $EndTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Appointment{EndTime},
                },
            );

            # Calculate new start/end times.
            if ( $GetParam{UpdateType} eq 'StartTime' ) {
                $StartTimeObject->Add(
                    Seconds => $GetParam{UpdateDelta},
                );
                $GetParam{StartTime} = $StartTimeObject->ToString();
            }
            elsif ( $GetParam{UpdateType} eq 'EndTime' ) {
                $EndTimeObject->Add(
                    Seconds => $GetParam{UpdateDelta},
                );
                $GetParam{EndTime} = $EndTimeObject->ToString();
            }
            else {
                $StartTimeObject->Add(
                    Seconds => $GetParam{UpdateDelta},
                );
                $EndTimeObject->Add(
                    Seconds => $GetParam{UpdateDelta},
                );
                $GetParam{StartTime} = $StartTimeObject->ToString();
                $GetParam{EndTime}   = $EndTimeObject->ToString();
            }
        }
        else {
            if (
                defined $GetParam{StartYear}
                && defined $GetParam{StartMonth}
                && defined $GetParam{StartDay}
                && defined $GetParam{StartHour}
                && defined $GetParam{StartMinute}
                )
            {
                $GetParam{StartTime} = sprintf(
                    "%04d-%02d-%02d %02d:%02d:00",
                    $GetParam{StartYear}, $GetParam{StartMonth}, $GetParam{StartDay},
                    $GetParam{StartHour}, $GetParam{StartMinute}
                );

                # Convert start time to local time.
                my $StartTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String   => $GetParam{StartTime},
                        TimeZone => $Self->{UserTimeZone},
                    },
                );
                if ( $Self->{UserTimeZone} ) {
                    $StartTimeObject->ToOTRSTimeZone();
                }
                $GetParam{StartTime} = $StartTimeObject->ToString();
            }
            else {
                $GetParam{StartTime} = $Appointment{StartTime};
            }

            if (
                defined $GetParam{EndYear}
                && defined $GetParam{EndMonth}
                && defined $GetParam{EndDay}
                && defined $GetParam{EndHour}
                && defined $GetParam{EndMinute}
                )
            {
                $GetParam{EndTime} = sprintf(
                    "%04d-%02d-%02d %02d:%02d:00",
                    $GetParam{EndYear}, $GetParam{EndMonth}, $GetParam{EndDay},
                    $GetParam{EndHour}, $GetParam{EndMinute}
                );

                # Convert end time to local time.
                my $EndTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String   => $GetParam{EndTime},
                        TimeZone => $Self->{UserTimeZone},
                    },
                );
                if ( $Self->{UserTimeZone} ) {
                    $EndTimeObject->ToOTRSTimeZone();
                }

                # Get already calculated local start time.
                my $StartTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $GetParam{StartTime},
                    },
                );

                # Prevent storing end time before start time.
                if ( $EndTimeObject < $StartTimeObject ) {
                    $EndTimeObject = $StartTimeObject->Clone();
                }

                $GetParam{EndTime} = $EndTimeObject->ToString();
            }
            else {
                $GetParam{EndTime} = $Appointment{EndTime};
            }
        }

        # Prevent recurrence until dates before start time.
        if ( $Appointment{Recurring} && $Appointment{RecurrenceUntil} ) {
            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $GetParam{StartTime},
                },
            );
            my $RecurrenceUntilObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Appointment{RecurrenceUntil},
                },
            );
            if ( $RecurrenceUntilObject < $StartTimeObject ) {
                $Appointment{RecurrenceUntil} = $GetParam{StartTime};
            }
        }

        # recurring appointment
        if ( $GetParam{Recurring} && $GetParam{RecurrenceType} ) {

            if (
                $GetParam{RecurrenceType} eq 'Daily'
                || $GetParam{RecurrenceType} eq 'Weekly'
                || $GetParam{RecurrenceType} eq 'Monthly'
                || $GetParam{RecurrenceType} eq 'Yearly'
                )
            {
                $GetParam{RecurrenceInterval} = 1;
            }
            elsif ( $GetParam{RecurrenceType} eq 'Custom' ) {

                if ( $GetParam{RecurrenceCustomType} eq 'CustomWeekly' ) {
                    if ( $GetParam{Days} ) {
                        my @Days = split( ",", $GetParam{Days} );
                        $GetParam{RecurrenceFrequency} = \@Days;
                    }
                    else {
                        my $StartTimeObject = $Kernel::OM->Create(
                            'Kernel::System::DateTime',
                            ObjectParams => {
                                String => $GetParam{StartTime},
                            },
                        );
                        my $StartTimeSettings = $StartTimeObject->Get();
                        $GetParam{RecurrenceFrequency} = [ $StartTimeSettings->{DayOfWeek} ];
                    }
                }
                elsif ( $GetParam{RecurrenceCustomType} eq 'CustomMonthly' ) {
                    if ( $GetParam{MonthDays} ) {
                        my @MonthDays = split( ",", $GetParam{MonthDays} );
                        $GetParam{RecurrenceFrequency} = \@MonthDays;
                    }
                    else {
                        my $StartTimeObject = $Kernel::OM->Create(
                            'Kernel::System::DateTime',
                            ObjectParams => {
                                String => $GetParam{StartTime},
                            },
                        );
                        my $StartTimeSettings = $StartTimeObject->Get();
                        $GetParam{RecurrenceFrequency} = [ $StartTimeSettings->{Day} ];
                    }
                }
                elsif ( $GetParam{RecurrenceCustomType} eq 'CustomYearly' ) {
                    if ( $GetParam{Months} ) {
                        my @Months = split( ",", $GetParam{Months} );
                        $GetParam{RecurrenceFrequency} = \@Months;
                    }
                    else {
                        my $StartTimeObject = $Kernel::OM->Create(
                            'Kernel::System::DateTime',
                            ObjectParams => {
                                String => $GetParam{StartTime},
                            },
                        );
                        my $StartTimeSettings = $StartTimeObject->Get();
                        $GetParam{RecurrenceFrequency} = [ $StartTimeSettings->{Month} ];
                    }
                }

                $GetParam{RecurrenceType} = $GetParam{RecurrenceCustomType};
            }

            # until ...
            if (
                $GetParam{RecurrenceLimit} eq '1'
                && $GetParam{RecurrenceUntilYear}
                && $GetParam{RecurrenceUntilMonth}
                && $GetParam{RecurrenceUntilDay}
                )
            {
                $GetParam{RecurrenceUntil} = sprintf(
                    "%04d-%02d-%02d 00:00:00",
                    $GetParam{RecurrenceUntilYear}, $GetParam{RecurrenceUntilMonth},
                    $GetParam{RecurrenceUntilDay}
                );

                # Prevent recurrence until dates before start time.
                my $StartTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $GetParam{StartTime},
                    },
                );
                my $RecurrenceUntilObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $GetParam{RecurrenceUntil},
                    },
                );
                if ( $RecurrenceUntilObject < $StartTimeObject ) {
                    $GetParam{RecurrenceUntil} = $GetParam{StartTime};
                }

                $GetParam{RecurrenceCount} = undef;
            }

            # for ... time(s)
            elsif ( $GetParam{RecurrenceLimit} eq '2' ) {
                $GetParam{RecurrenceUntil} = undef;
            }
        }

        # Determine notification custom type, if supplied.
        if ( defined $GetParam{NotificationTemplate} ) {
            if ( $GetParam{NotificationTemplate} ne 'Custom' ) {
                $GetParam{NotificationCustom} = '';
            }
            elsif ( $GetParam{NotificationCustomRelativeInput} ) {
                $GetParam{NotificationCustom} = 'relative';
            }
            elsif ( $GetParam{NotificationCustomDateTimeInput} ) {
                $GetParam{NotificationCustom} = 'datetime';

                $GetParam{NotificationCustomDateTime} = sprintf(
                    "%04d-%02d-%02d %02d:%02d:00",
                    $GetParam{NotificationCustomDateTimeYear},
                    $GetParam{NotificationCustomDateTimeMonth},
                    $GetParam{NotificationCustomDateTimeDay},
                    $GetParam{NotificationCustomDateTimeHour},
                    $GetParam{NotificationCustomDateTimeMinute}
                );

                my $NotificationCustomDateTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String   => $GetParam{NotificationCustomDateTime},
                        TimeZone => $Self->{UserTimeZone},
                    },
                );

                if ( $Self->{UserTimeZone} ) {
                    $NotificationCustomDateTimeObject->ToOTRSTimeZone();
                }

                $GetParam{NotificationCustomDateTime} = $NotificationCustomDateTimeObject->ToString();
            }
        }

        # team
        if ( $GetParam{'TeamID[]'} ) {
            my @TeamIDs = $ParamObject->GetArray( Param => 'TeamID[]' );
            $GetParam{TeamID} = \@TeamIDs;
        }
        else {
            $GetParam{TeamID} = undef;
        }

        # resources
        if ( $GetParam{'ResourceID[]'} ) {
            my @ResourceID = $ParamObject->GetArray( Param => 'ResourceID[]' );
            $GetParam{ResourceID} = \@ResourceID;
        }
        else {
            $GetParam{ResourceID} = undef;
        }

        # Check if dealing with ticket appointment.
        if ( $Appointment{TicketAppointmentRuleID} ) {

            # Make sure readonly values stay unchanged.
            $GetParam{Title}      = $Appointment{Title};
            $GetParam{CalendarID} = $Appointment{CalendarID};
            $GetParam{AllDay}     = undef;
            $GetParam{Recurring}  = undef;

            my $Rule = $CalendarObject->TicketAppointmentRuleGet(
                CalendarID => $Appointment{CalendarID},
                RuleID     => $Appointment{TicketAppointmentRuleID},
            );

            # Recalculate end time based on time preset.
            if ( IsHashRefWithData($Rule) ) {
                if ( $Rule->{EndDate} =~ /^Plus_([0-9]+)$/ && $GetParam{StartTime} ) {
                    my $Preset = int $1;

                    my $EndTimeObject = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $GetParam{StartTime},    # base on start time
                        },
                    );

                    # Calculate end time using preset value.
                    $EndTimeObject->Add(
                        Minutes => $Preset,
                    );
                    $GetParam{EndTime} = $EndTimeObject->ToString();
                }
            }
        }

        my $Success;

        # reset empty parameters
        for my $Param ( sort keys %GetParam ) {
            if ( !$GetParam{$Param} ) {
                $GetParam{$Param} = undef;
            }
        }

        # pass current user ID
        $GetParam{UserID} = $Self->{UserID};

        # Get passed plugin parameters.
        my @PluginParams = grep { $_ =~ /^Plugin_/ } keys %GetParam;

        if (%Appointment) {

            # Continue only if coming from edit screen
            #   (there is at least one passed plugin parameter).
            if (@PluginParams) {

                # Get all related appointments before the update.
                my @RelatedAppointments  = ( $Appointment{AppointmentID} );
                my @CalendarAppointments = $AppointmentObject->AppointmentList(
                    CalendarID => $Appointment{CalendarID},
                );

                # If we are dealing with a parent, include any child appointments.
                push @RelatedAppointments,
                    map {
                    $_->{AppointmentID}
                    }
                    grep {
                    defined $_->{ParentID}
                        && $_->{ParentID} eq $Appointment{AppointmentID}
                    } @CalendarAppointments;

                # Remove all existing links.
                for my $CurrentAppointmentID (@RelatedAppointments) {
                    my $Success = $PluginObject->PluginLinkDelete(
                        AppointmentID => $CurrentAppointmentID,
                        UserID        => $Self->{UserID},
                    );

                    if ( !$Success ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "Links could not be deleted for appointment $CurrentAppointmentID!",
                        );
                    }
                }
            }

            $Success = $AppointmentObject->AppointmentUpdate(
                %Appointment,
                %GetParam,
            );
        }
        else {
            $Success = $AppointmentObject->AppointmentCreate(
                %GetParam,
            );
        }

        my $AppointmentID = $GetParam{AppointmentID} ? $GetParam{AppointmentID} : $Success;

        if ($AppointmentID) {

            # Continue only if coming from edit screen
            #   (there is at least one passed plugin parameter).
            if (@PluginParams) {

                # Get fresh appointment data.
                %Appointment = $AppointmentObject->AppointmentGet(
                    AppointmentID => $AppointmentID,
                );

                # Process all related appointments.
                my @RelatedAppointments  = ($AppointmentID);
                my @CalendarAppointments = $AppointmentObject->AppointmentList(
                    CalendarID => $Appointment{CalendarID},
                );

                # If we are dealing with a parent, include any child appointments as well.
                push @RelatedAppointments,
                    map {
                    $_->{AppointmentID}
                    }
                    grep {
                    defined $_->{ParentID}
                        && $_->{ParentID} eq $AppointmentID
                    } @CalendarAppointments;

                # Process passed plugin parameters.
                for my $PluginParam (@PluginParams) {
                    my $PluginData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                        Data => $GetParam{$PluginParam},
                    );
                    my $PluginKey = $PluginParam;
                    $PluginKey =~ s/^Plugin_//;

                    # Execute link add method of the plugin.
                    if ( IsArrayRefWithData($PluginData) ) {
                        for my $LinkID ( @{$PluginData} ) {
                            for my $CurrentAppointmentID (@RelatedAppointments) {
                                my $Link = $PluginObject->PluginLinkAdd(
                                    AppointmentID => $CurrentAppointmentID,
                                    PluginKey     => $PluginKey,
                                    PluginData    => $LinkID,
                                    UserID        => $Self->{UserID},
                                );

                                if ( !$Link ) {
                                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                                        Priority => 'error',
                                        Message  => "Link could not be created for appointment $CurrentAppointmentID!",
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => {
                Success       => $Success ? 1 : 0,
                AppointmentID => $AppointmentID,
            },
        );
    }

    # ------------------------------------------------------------ #
    # delete mask
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeleteAppointment' ) {

        if ( $GetParam{AppointmentID} ) {
            my %Appointment = $AppointmentObject->AppointmentGet(
                AppointmentID => $GetParam{AppointmentID},
            );

            my $Success = 0;
            my $Error   = '';

            # Prevent deleting ticket appointment.
            if ( $Appointment{TicketAppointmentRuleID} ) {
                $Error = Translatable('Cannot delete ticket appointment!');
            }
            else {

                # Get all related appointments before the deletion.
                my @RelatedAppointments  = ( $Appointment{AppointmentID} );
                my @CalendarAppointments = $AppointmentObject->AppointmentList(
                    CalendarID => $Appointment{CalendarID},
                );

                # If we are dealing with a parent, include any child appointments.
                push @RelatedAppointments,
                    map {
                    $_->{AppointmentID}
                    }
                    grep {
                    defined $_->{ParentID}
                        && $_->{ParentID} eq $Appointment{AppointmentID}
                    } @CalendarAppointments;

                # Remove all existing links.
                for my $CurrentAppointmentID (@RelatedAppointments) {
                    my $Success = $PluginObject->PluginLinkDelete(
                        AppointmentID => $CurrentAppointmentID,
                        UserID        => $Self->{UserID},
                    );

                    if ( !$Success ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "Links could not be deleted for appointment $CurrentAppointmentID!",
                        );
                    }
                }

                $Success = $AppointmentObject->AppointmentDelete(
                    %GetParam,
                    UserID => $Self->{UserID},
                );

                if ( !$Success ) {
                    $Error = Translatable('No permissions!');
                }
            }

            # build JSON output
            $JSON = $LayoutObject->JSONEncode(
                Data => {
                    Success       => $Success,
                    Error         => $Error,
                    AppointmentID => $GetParam{AppointmentID},
                },
            );
        }
    }

    # ------------------------------------------------------------ #
    # update preferences
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdatePreferences' ) {

        my $Success = 0;

        if (
            $GetParam{OverviewScreen} && (
                $GetParam{DefaultView} || $GetParam{CalendarSelection}
                || ( $GetParam{ShownResources} && $GetParam{TeamID} )
                || $GetParam{ShownAppointments}
            )
            )
        {
            my $PreferenceKey;
            my $PreferenceKeySuffix = '';

            if ( $GetParam{DefaultView} ) {
                $PreferenceKey = 'DefaultView';
            }
            elsif ( $GetParam{CalendarSelection} ) {
                $PreferenceKey = 'CalendarSelection';
            }
            elsif ( $GetParam{ShownResources} && $GetParam{TeamID} ) {
                $PreferenceKey       = 'ShownResources';
                $PreferenceKeySuffix = "-$GetParam{TeamID}";
            }
            elsif ( $GetParam{ShownAppointments} ) {
                $PreferenceKey = 'ShownAppointments';
            }

            # set user preferences
            $Success = $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                Key    => 'User' . $GetParam{OverviewScreen} . $PreferenceKey . $PreferenceKeySuffix,
                Value  => $GetParam{$PreferenceKey},
                UserID => $Self->{UserID},
            );
        }

        elsif ( $GetParam{OverviewScreen} && $GetParam{RestoreDefaultSettings} ) {
            my $PreferenceKey;
            my $PreferenceKeySuffix = '';

            if ( $GetParam{RestoreDefaultSettings} eq 'ShownResources' && $GetParam{TeamID} ) {
                $PreferenceKey       = 'ShownResources';
                $PreferenceKeySuffix = "-$GetParam{TeamID}";
            }

            # blank user preferences
            $Success = $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                Key    => 'User' . $GetParam{OverviewScreen} . $PreferenceKey . $PreferenceKeySuffix,
                Value  => '',
                UserID => $Self->{UserID},
            );
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => {
                Success => $Success,
            },
        );
    }

    # ------------------------------------------------------------ #
    # team list selection update
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TeamUserList' ) {
        my @TeamIDs = $ParamObject->GetArray( Param => 'TeamID[]' );
        my %TeamUserListAll;

        # Check if team object is registered.
        if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {
            my $TeamObject = $Kernel::OM->Get('Kernel::System::Calendar::Team');
            my $UserObject = $Kernel::OM->Get('Kernel::System::User');

            TEAMID:
            for my $TeamID (@TeamIDs) {
                next TEAMID if !$TeamID;

                # get list of team members
                my %TeamUserList = $TeamObject->TeamUserList(
                    TeamID => $TeamID,
                    UserID => $Self->{UserID},
                );

                # get user data
                for my $UserID ( sort keys %TeamUserList ) {
                    my %User = $UserObject->GetUserData(
                        UserID => $UserID,
                    );
                    $TeamUserList{$UserID} = $User{UserFullname};
                }

                %TeamUserListAll = ( %TeamUserListAll, %TeamUserList );
            }
        }

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => {
                TeamUserList => \%TeamUserListAll,
            },
        );

    }

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _DayOffsetGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Time)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Get original date components.
    my $OriginalTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{Time},
        },
    );
    my $OriginalTimeSettings = $OriginalTimeObject->Get();

    # Get destination time according to user timezone.
    my $DestinationTimeObject = $OriginalTimeObject->Clone();
    $DestinationTimeObject->ToTimeZone( TimeZone => $Self->{UserTimeZone} );
    my $DestinationTimeSettings = $DestinationTimeObject->Get();

    # Compare days of two times.
    if ( $OriginalTimeSettings->{Day} == $DestinationTimeSettings->{Day} ) {
        return 0;    # same day
    }
    elsif ( $OriginalTimeObject > $DestinationTimeObject ) {
        return -1;
    }

    return 1;
}

1;
