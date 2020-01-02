# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Calendar::Import::ICal;

use strict;
use warnings;

use Data::ICal;
use Data::ICal::Entry::Event;
use Date::ICal;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Calendar',
    'Kernel::System::Calendar::Appointment',
    'Kernel::System::Calendar::Plugin',
    'Kernel::System::Calendar::Team',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::Calendar::Import::ICal - C<iCalendar> import lib

=head1 DESCRIPTION

Import functions for C<iCalendar> format.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ImportObject = $Kernel::OM->Get('Kernel::System::Calendar::Export::ICal');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

=head2 Import()

Import calendar in C<iCalendar> format.

    my $Success = $ImportObject->Import(
        CalendarID     => 123,
        ICal           =>                         # (required) iCal string
            '
                BEGIN:VCALENDAR
                PRODID:Zimbra-Calendar-Provider
                VERSION:2.0
                METHOD:REQUEST
                ...
            ',
        UserID         => 1,                      # (required) UserID
        UpdateExisting => 0,                      # (optional) Delete existing Appointments within same Calendar if UniqueID matches
        UntilLimit     => '2017-01-01 00:00:00',  # (optional) If provided, system will use this value for limiting recurring Appointments without defined end date
                                                  # instead of AppointmentCalendar::Import::RecurringMonthsLimit to do the calculation
                                                  # NOTE: PLEASE USE THIS PARAMETER FOR UNIT TESTS ONLY
    );

Returns number of imported appointments if successful, otherwise 0.

=cut

sub Import {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(CalendarID ICal UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $UntilLimitedTimestamp = $Param{UntilLimit} || '';

    # Prevent line ending type errors (see bug#14791).
    $Param{ICal} =~ s/\r/\n/g;

    if ( !$UntilLimitedTimestamp ) {

        # Calculate until time which will be used if there is any recurring Appointment without end
        #   time defined.
        my $UntilTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        my $RecurringMonthsLimit
            = $Kernel::OM->Get('Kernel::Config')->Get("AppointmentCalendar::Import::RecurringMonthsLimit")
            || '12';    # default 12 months

        $UntilTimeObject->Add(
            Months => $RecurringMonthsLimit,
        );
        $UntilLimitedTimestamp = $UntilTimeObject->ToString();
    }

    # Turn on UTF8 flag on supplied string for correct encoding in PostgreSQL backend.
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Param{ICal} );

    my $Calendar = Data::ICal->new( data => $Param{ICal} );

    # If external library encountered an error while parsing the ICS file, log the received message
    #   at this time and return.
    if ( $Calendar->{errno} ) {
        my $ErrorMessage = $Calendar->{error_message} // '';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "[Data::ICal] $ErrorMessage",
        );
        return;
    }

    my @Entries              = @{ $Calendar->entries() };
    my $AppointmentsImported = 0;

    my $PluginObject      = $Kernel::OM->Get('Kernel::System::Calendar::Plugin');
    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

    ENTRY:
    for my $Entry (@Entries) {
        my $Properties = $Entry->properties();

        my %Parameters;
        my %LinkedObjects;

        # get uid
        if (
            IsArrayRefWithData( $Properties->{'uid'} )
            && ref $Properties->{'uid'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'uid'}->[0]->{'value'}
            )
        {
            $Parameters{UniqueID} = $Properties->{'uid'}->[0]->{'value'};
        }

        # get title
        if (
            IsArrayRefWithData( $Properties->{'summary'} )
            && ref $Properties->{'summary'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'summary'}->[0]->{'value'}
            )
        {
            $Parameters{Title} = $Properties->{'summary'}->[0]->{'value'};
        }

        # get description
        if (
            IsArrayRefWithData( $Properties->{'description'} )
            && ref $Properties->{'description'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'description'}->[0]->{'value'}
            )
        {
            $Parameters{Description} = $Properties->{'description'}->[0]->{'value'};
        }

        # get start time
        if (
            IsArrayRefWithData( $Properties->{'dtstart'} )
            && ref $Properties->{'dtstart'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'dtstart'}->[0]->{'value'}
            )
        {

            my $TimezoneID;

            if ( ref $Properties->{'dtstart'}->[0]->{'_parameters'} eq 'HASH' ) {

                # check if it's an all day event
                # 1) there is no time component for the date value
                # 2) there is an explicit value parameter set to DATE
                if (
                    length $Properties->{'dtstart'}->[0]->{'value'} == 8
                    ||
                    (
                        $Properties->{'dtstart'}->[0]->{'_parameters'}->{'VALUE'}
                        && $Properties->{'dtstart'}->[0]->{'_parameters'}->{'VALUE'} eq 'DATE'
                    )
                    )
                {
                    $Parameters{AllDay} = 1;
                }

                # check timezone
                if ( $Properties->{'dtstart'}->[0]->{'_parameters'}->{'TZID'} ) {
                    $TimezoneID = $Properties->{'dtstart'}->[0]->{'_parameters'}->{'TZID'};
                }
            }

            my $StartTimeICal = $Self->_FormatTime(
                Time => $Properties->{'dtstart'}->[0]->{'value'},
            );
            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String   => $StartTimeICal,
                    TimeZone => $TimezoneID,
                },
            );

            if ( !$Parameters{AllDay} ) {
                $StartTimeObject->ToOTRSTimeZone();
            }

            $Parameters{StartTime} = $StartTimeObject->ToString();
        }

        # get end time
        if (
            IsArrayRefWithData( $Properties->{'dtend'} )
            && ref $Properties->{'dtend'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'dtend'}->[0]->{'value'}
            )
        {
            my $TimezoneID;

            if ( ref $Properties->{'dtend'}->[0]->{'_parameters'} eq 'HASH' ) {

                # check timezone
                if ( $Properties->{'dtend'}->[0]->{'_parameters'}->{'TZID'} ) {
                    $TimezoneID = $Properties->{'dtend'}->[0]->{'_parameters'}->{'TZID'};
                }
            }

            my $EndTimeICal = $Self->_FormatTime(
                Time => $Properties->{'dtend'}->[0]->{'value'},
            );
            my $EndTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String   => $EndTimeICal,
                    TimeZone => $TimezoneID,
                },
            );

            if ( !$Parameters{AllDay} ) {
                $EndTimeObject->ToOTRSTimeZone();
            }

            $Parameters{EndTime} = $EndTimeObject->ToString();
        }

        # Some iCalendar implementations (looking at you icalendar-ruby) do not require nor include
        #   end time for appointments. In this case, prevent failing and use start time instead.
        else {
            $Parameters{EndTime} = $Parameters{StartTime};
        }

        # get location
        if (
            IsArrayRefWithData( $Properties->{'location'} )
            && ref $Properties->{'location'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'location'}->[0]->{'value'}
            )
        {
            $Parameters{Location} = $Properties->{'location'}->[0]->{'value'};
        }

        # get rrule
        if (
            IsArrayRefWithData( $Properties->{'rrule'} )
            && ref $Properties->{'rrule'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'rrule'}->[0]->{'value'}
            )
        {
            my ( $Frequency, $Until, $Interval, $Count, $DayNames, $MonthDay, $Months );

            my @Rules = split ';', $Properties->{'rrule'}->[0]->{'value'};

            RULE:
            for my $Rule (@Rules) {

                if ( $Rule =~ /FREQ=(.*?)$/i ) {
                    $Frequency = $1;
                }
                elsif ( $Rule =~ /UNTIL=(.*?)$/i ) {
                    $Until = $1;
                }
                elsif ( $Rule =~ /INTERVAL=(\d+?)$/i ) {
                    $Interval = $1;
                }
                elsif ( $Rule =~ /COUNT=(\d+?)$/i ) {
                    $Count = $1;
                }
                elsif ( $Rule =~ /BYDAY=(.*?)$/i ) {
                    $DayNames = $1;
                }
                elsif ( $Rule =~ /BYMONTHDAY=(.*?)$/i ) {
                    $MonthDay = $1;
                }
                elsif ( $Rule =~ /BYMONTH=(.*?)$/i ) {
                    $Months = $1;
                }
            }

            $Interval ||= 1;    # default value

            # this appointment is repeating
            if ( $Frequency eq "DAILY" ) {
                $Parameters{Recurring}          = 1;
                $Parameters{RecurrenceType}     = $Interval == 1 ? "Daily" : "CustomDaily";
                $Parameters{RecurrenceInterval} = $Interval;

            }
            elsif ( $Frequency eq "WEEKLY" ) {
                if ($DayNames) {

                    # custom

                    my @Days;

                    # SU,MO,TU,WE,TH,FR,SA
                    for my $DayName ( split( ',', $DayNames ) ) {

                        if ( uc $DayName eq 'MO' ) {
                            push @Days, 1;
                        }
                        elsif ( uc $DayName eq 'TU' ) {
                            push @Days, 2;
                        }
                        elsif ( uc $DayName eq 'WE' ) {
                            push @Days, 3;
                        }
                        elsif ( uc $DayName eq 'TH' ) {
                            push @Days, 4;
                        }
                        elsif ( uc $DayName eq 'FR' ) {
                            push @Days, 5;
                        }
                        elsif ( uc $DayName eq 'SA' ) {
                            push @Days, 6;
                        }
                        elsif ( uc $DayName eq 'SU' ) {
                            push @Days, 7;
                        }
                    }

                    if ( scalar @Days > 0 ) {

                        $Parameters{Recurring}           = 1;
                        $Parameters{RecurrenceType}      = "CustomWeekly";
                        $Parameters{RecurrenceInterval}  = $Interval;
                        $Parameters{RecurrenceFrequency} = \@Days;
                    }
                }
                else {
                    # each n days
                    $Parameters{Recurring}          = 1;
                    $Parameters{RecurrenceType}     = "Weekly";
                    $Parameters{RecurrenceInterval} = $Interval;
                }
            }
            elsif ( $Frequency eq "MONTHLY" ) {

                # Skip unsupported custom monthly recurring rules:
                #   - FREQ=MONTHLY;BYDAY=2SA
                if ($DayNames) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Skip import of unsupported recurring rule: "
                            . $Properties->{'rrule'}->[0]->{'value'},
                    );
                    next ENTRY;
                }

                if ($MonthDay) {

                    # Custom
                    # FREQ=MONTHLY;UNTIL=20170101T080000Z;BYMONTHDAY=16,31'
                    my @Days = split( ',', $MonthDay );

                    $Parameters{Recurring}           = 1;
                    $Parameters{RecurrenceType}      = "CustomMonthly";
                    $Parameters{RecurrenceFrequency} = \@Days;
                    $Parameters{RecurrenceInterval}  = $Interval;
                }
                else {
                    $Parameters{Recurring}          = 1;
                    $Parameters{RecurrenceType}     = "Monthly";
                    $Parameters{RecurrenceInterval} = $Interval;
                }
            }
            elsif ( $Frequency eq "YEARLY" ) {

                # Skip unsupported custom yearly recurring rules:
                #   - FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU
                #   - FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
                if ($DayNames) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Skip import of unsupported recurring rule: "
                            . $Properties->{'rrule'}->[0]->{'value'},
                    );
                    next ENTRY;
                }

                my @Months = split( ',', $Months || '' );

                my $StartTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $Parameters{StartTime},
                    },
                );

                if (
                    scalar @Months > 1
                    || (
                        scalar @Months == 1
                        && $StartTimeObject->Get()->{Day} != $Months[0]
                    )
                    )
                {
                    $Parameters{Recurring}           = 1;
                    $Parameters{RecurrenceType}      = "CustomYearly";
                    $Parameters{RecurrenceFrequency} = \@Months;
                    $Parameters{RecurrenceInterval}  = $Interval;
                }
                else {
                    $Parameters{Recurring}          = 1;
                    $Parameters{RecurrenceType}     = "Yearly";
                    $Parameters{RecurrenceInterval} = $Interval;
                }
            }

            # FREQ=YEARLY;INTERVAL=2;BYMONTH=1,2,12
            # FREQ=MONTHLY;UNTIL=20170302T121500Z'
            # FREQ=MONTHLY;UNTIL=20170202T090000Z;INTERVAL=2;BYMONTHDAY=31',
            # FREQ=WEEKLY;INTERVAL=2;BYDAY=TU
            # FREQ=YEARLY;UNTIL=20200602T080000Z;INTERVAL=2;BYMONTHDAY=1;BYMONTH=4';

            # FREQ=DAILY;COUNT=3

            if ($Until) {
                $Parameters{RecurrenceUntil} = $Self->_FormatTime(
                    Time => $Until,
                );
            }
            elsif ($Count) {
                $Parameters{RecurrenceCount} = $Count;
            }
            else {
                # default value
                $Parameters{RecurrenceUntil} = $UntilLimitedTimestamp;
            }

            # excluded dates
            if ( IsArrayRefWithData( $Properties->{'exdate'} ) ) {
                my @RecurrenceExclude;
                for my $Exclude ( @{ $Properties->{'exdate'} } ) {
                    if (
                        ref $Exclude eq 'Data::ICal::Property'
                        && $Exclude->{'value'}
                        )
                    {
                        my $TimezoneID;
                        if ( ref $Exclude->{'_parameters'} eq 'HASH' ) {

                            # check timezone
                            if ( $Exclude->{'_parameters'}->{'TZID'} ) {
                                $TimezoneID = $Exclude->{'_parameters'}->{'TZID'};
                            }
                        }

                        my $ExcludeTimeICal = $Self->_FormatTime(
                            Time => $Exclude->{'value'},
                        );
                        my $ExcludeTimeObject = $Kernel::OM->Create(
                            'Kernel::System::DateTime',
                            ObjectParams => {
                                String   => $ExcludeTimeICal,
                                TimeZone => $TimezoneID,
                            },
                        );

                        if ( !$Parameters{AllDay} ) {
                            $ExcludeTimeObject->ToOTRSTimeZone();
                        }

                        push @RecurrenceExclude, $ExcludeTimeObject->ToString();
                    }
                }
                $Parameters{RecurrenceExclude} = \@RecurrenceExclude;
            }
        }

        # check if team object is registered
        if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {

            # get team
            if (
                IsArrayRefWithData( $Properties->{'x-otrs-team'} )
                && ref $Properties->{'x-otrs-team'}->[0] eq 'Data::ICal::Property'
                && $Properties->{'x-otrs-team'}->[0]->{'value'}
                )
            {
                my @Teams = split( ",", $Properties->{'x-otrs-team'}->[0]->{'value'} );

                if (@Teams) {
                    my @TeamIDs;

                    # get team ids
                    for my $TeamName (@Teams) {
                        my %Team = $Kernel::OM->Get('Kernel::System::Calendar::Team')->TeamGet(
                            Name   => $TeamName,
                            UserID => $Param{UserID},
                        );
                        push @TeamIDs, $Team{ID} if $Team{ID};
                    }
                    $Parameters{TeamID} = \@TeamIDs if @TeamIDs;
                }
            }

            # get resource
            if (
                IsArrayRefWithData( $Properties->{'x-otrs-resource'} )
                && ref $Properties->{'x-otrs-resource'}->[0] eq 'Data::ICal::Property'
                && $Properties->{'x-otrs-resource'}->[0]->{'value'}
                )
            {
                my @Resources = split( ",", $Properties->{'x-otrs-resource'}->[0]->{'value'} );

                if (@Resources) {
                    my @Users;

                    # get user ids
                    for my $UserLogin (@Resources) {
                        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                            UserLogin => $UserLogin,
                        );
                        push @Users, $UserID if $UserID;
                    }
                    $Parameters{ResourceID} = \@Users if @Users;
                }
            }
        }

        # get available plugin keys suitable for lowercase search
        my $PluginKeys = $PluginObject->PluginKeys();

        # plugin fields (start with 'x-otrs-plugin-')
        my @PluginFields = grep { $_ =~ /x-otrs-plugin-/i } keys %{$Properties};

        PLUGINFIELD:
        for my $PluginField (@PluginFields) {
            if (
                IsArrayRefWithData( $Properties->{$PluginField} )
                && ref $Properties->{$PluginField}->[0] eq 'Data::ICal::Property'
                && $Properties->{$PluginField}->[0]->{'value'}
                )
            {
                # extract lowercase plugin key
                $PluginField =~ /x-otrs-plugin-(.*)$/;
                my $PluginKeyLC = $1;

                # get proper plugin key
                my $PluginKey = $PluginKeys->{$PluginKeyLC};
                next PLUGINFIELD if !$PluginKey;

                my @PluginData = split( ",", $Properties->{$PluginField}->[0]->{'value'} );
                $LinkedObjects{$PluginKey} = \@PluginData;
            }
        }

        next ENTRY if !$Parameters{Title};

        my %Appointment;

        # get recurrence id
        if (
            IsArrayRefWithData( $Properties->{'recurrence-id'} )
            && ref $Properties->{'recurrence-id'}->[0] eq 'Data::ICal::Property'
            && $Properties->{'recurrence-id'}->[0]->{'value'}
            )
        {
            # get parent id
            my %ParentAppointment = $AppointmentObject->AppointmentGet(
                UniqueID   => $Parameters{UniqueID},
                CalendarID => $Param{CalendarID},
            );
            next ENTRY if !%ParentAppointment;

            $Parameters{ParentID} = $ParentAppointment{AppointmentID};

            my $TimezoneID;
            if ( ref $Properties->{'recurrence-id'}->[0]->{'_parameters'} eq 'HASH' ) {

                # check timezone
                if ( $Properties->{'recurrence-id'}->[0]->{'_parameters'}->{'TZID'} ) {
                    $TimezoneID = $Properties->{'recurrence-id'}->[0]->{'_parameters'}->{'TZID'};
                }
            }

            my $RecurrenceIDICal = $Self->_FormatTime(
                Time => $Properties->{'recurrence-id'}->[0]->{'value'},
            );
            my $RecurrenceIDObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String   => $RecurrenceIDICal,
                    TimeZone => $TimezoneID,
                },
            );

            if ( !$Parameters{AllDay} ) {
                $RecurrenceIDObject->ToOTRSTimeZone();
            }

            $Param{RecurrenceID} = $RecurrenceIDObject->ToString();

            # delete existing overridden occurrence
            $AppointmentObject->AppointmentDeleteOccurrence(
                UniqueID     => $Parameters{UniqueID},
                CalendarID   => $Param{CalendarID},
                RecurrenceID => $Param{RecurrenceID},
                UserID       => $Param{UserID},
            );
        }

        # Check if appointment with same UniqueID in the same calendar already exists.
        else {
            %Appointment = $AppointmentObject->AppointmentGet(
                UniqueID   => $Parameters{UniqueID},
                CalendarID => $Param{CalendarID},
            );

            if (
                $Appointment{CalendarID}
                && ( !$Param{UpdateExisting} || $Appointment{CalendarID} != $Param{CalendarID} )
                )
            {
                # If overwrite option isn't activated, create new appointment by clearing the
                #   UniqueID.
                if (%Appointment) {
                    delete $Parameters{UniqueID};
                }
                %Appointment = ();
            }
        }

        my $Success;

        # appointment exists in same Calendar, update it
        if (
            %Appointment
            && $Appointment{AppointmentID}
            && $Param{CalendarID} == $Appointment{CalendarID}
            )
        {
            $Success = $AppointmentObject->AppointmentUpdate(
                CalendarID    => $Param{CalendarID},
                AppointmentID => $Appointment{AppointmentID},
                UserID        => $Param{UserID},
                %Parameters,
            );
        }

        # there is no appointment, create new one
        else {
            $Success = $AppointmentObject->AppointmentCreate(
                CalendarID => $Param{CalendarID},
                UserID     => $Param{UserID},
                %Parameters,
            );
        }

        if ($Success) {

            PLUGINKEY:
            for my $PluginKey ( sort keys %LinkedObjects ) {
                next PLUGINKEY if !IsArrayRefWithData( $LinkedObjects{$PluginKey} );

                # add links
                for my $PluginData ( @{ $LinkedObjects{$PluginKey} } ) {
                    my $LinkSuccess = $PluginObject->PluginLinkAdd(
                        AppointmentID => $Success,
                        PluginKey     => $PluginKey,
                        PluginData    => $PluginData,
                        UserID        => $Param{UserID},
                    );

                    if ( !$LinkSuccess ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message =>
                                "Unable to create object link (AppointmentID=$Success - $PluginKey=$PluginData) during calendar import!"
                        );
                    }
                }
            }

            $AppointmentsImported++;
        }
    }

    return $AppointmentsImported;
}

sub _FormatTime {
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

    my $TimeStamp;

    if ( $Param{Time} =~ /(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})/i ) {

        # format string
        $TimeStamp = "$1-$2-$3 $4:$5:$6";
    }
    elsif ( $Param{Time} =~ /(\d{4})(\d{2})(\d{2})/ ) {

        # only date is given (without time)
        $TimeStamp = "$1-$2-$3 00:00:00";
    }

    return $TimeStamp;
}

{
    no warnings 'redefine';    ## no critic

    # Include additional optional repeatable properties used by some iCalendar implementations, in
    #   order to prevent Perl warnings.
    sub Data::ICal::Entry::Alarm::optional_repeatable_properties {    ## no critic
        qw(
            uid acknowledged related-to description
        );
    }

    sub Data::ICal::Entry::Event::optional_repeatable_properties {    ## no critic
        my $Self = shift;

        my @Properties;

        if ( not $Self->vcal10 ) {                                    ## no critic
            @Properties = qw(
                attach  attendee  categories  comment
                contact  exdate  exrule  request-status  related-to
                resources  rdate  rrule
            );
        }
        else {
            @Properties = qw(
                aalarm  attach  attendee  categories
                dalarm  exdate  exrule  malarm  palarm  related-to
                resources  rdate  rrule
            );
        }

        push @Properties, '';

        return @Properties;
    }
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
