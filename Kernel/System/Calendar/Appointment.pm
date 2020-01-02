# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Calendar::Appointment;

use strict;
use warnings;

use Digest::MD5;

use vars qw(@ISA);

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::EventHandler;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Calendar',
    'Kernel::System::DB',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::DateTime',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Scheduler',
);

=head1 NAME

Kernel::System::Calendar::Appointment - calendar appointment lib

=head1 DESCRIPTION

All appointment functions.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    @ISA = qw(
        Kernel::System::EventHandler
    );

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'AppointmentCalendar::EventModulePost',
    );

    $Self->{CacheType} = 'Appointment';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 AppointmentCreate()

creates a new appointment.

    my $AppointmentID = $AppointmentObject->AppointmentCreate(
        ParentID              => 1,                                       # (optional) valid ParentID for recurring appointments
        CalendarID            => 1,                                       # (required) valid CalendarID
        UniqueID              => 'jwioji-fwjio',                          # (optional) provide desired UniqueID; if there is already existing Appointment
                                                                          #            with same UniqueID, system will delete it
        Title                 => 'Webinar',                               # (required) Title
        Description           => 'How to use Process tickets...',         # (optional) Description
        Location              => 'Straubing',                             # (optional) Location
        StartTime             => '2016-01-01 16:00:00',                   # (required)
        EndTime               => '2016-01-01 17:00:00',                   # (required)
        AllDay                => 0,                                       # (optional) default 0
        TeamID                => [ 1 ],                                   # (optional) must be an array reference if supplied
        ResourceID            => [ 1, 3 ],                                # (optional) must be an array reference if supplied
        Recurring             => 1,                                       # (optional) flag the appointment as recurring (parent only!)
        RecurringRaw          => 1,                                       # (optional) skip loop for recurring appointments (do not create occurrences!)
        RecurrenceType        => 'Daily',                                 # (required if Recurring) Possible "Daily", "Weekly", "Monthly", "Yearly",
                                                                          #           "CustomWeekly", "CustomMonthly", "CustomYearly"

        RecurrenceFrequency   => [1, 3, 5],                               # (required if Custom Recurring) Recurrence pattern
                                                                          #           for CustomWeekly: 1-Mon, 2-Tue,..., 7-Sun
                                                                          #           for CustomMonthly: 1-1st, 2-2nd,.., 31th
                                                                          #           for CustomYearly: 1-Jan, 2-Feb,..., 12-Dec
                                                                          # ...
        RecurrenceCount       => 1,                                       # (optional) How many Appointments to create
        RecurrenceInterval    => 2,                                       # (optional) Repeating interval (default 1)
        RecurrenceUntil       => '2016-01-10 00:00:00',                   # (optional) Until date
        RecurrenceID          => '2016-01-10 00:00:00',                   # (optional) Expected start time for this occurrence
        RecurrenceExclude     => [                                        # (optional) Which specific occurrences to exclude
            '2016-01-10 00:00:00',
            '2016-01-11 00:00:00',
        ],
        NotificationTime      => '2016-01-01 17:00:00',                   # (optional) Point of time to execute the notification event
        NotificationTemplate  => 'Custom',                                # (optional) Template to be used for notification point of time
        NotificationCustom    => 'relative',                              # (optional) Type of the custom template notification point of time
                                                                          #            Possible "relative", "datetime"
        NotificationCustomRelativeUnitCount   => '12',                    # (optional) minutes, hours or days count for custom template
        NotificationCustomRelativeUnit        => 'minutes',               # (optional) minutes, hours or days unit for custom template
        NotificationCustomRelativePointOfTime => 'beforestart',           # (optional) Point of execute for custom templates
                                                                          #            Possible "beforestart", "afterstart", "beforeend", "afterend"
        NotificationCustomDateTime => '2016-01-01 17:00:00',              # (optional) Notification date time for custom template
        TicketAppointmentRuleID    => '9bb20ea035e7a9930652a9d82d00c725', # (optional) Ticket appointment rule ID (for ticket appointments only!)
        UserID                     => 1,                                  # (required) UserID
    );

returns parent AppointmentID if successful

Events:
    AppointmentCreate

=cut

sub AppointmentCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(CalendarID Title StartTime EndTime UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # prepare possible notification params
    $Self->_AppointmentNotificationPrepare(
        Data => \%Param,
    );

    # if Recurring is provided, additional parameters must be present
    if ( $Param{Recurring} ) {

        my @RecurrenceTypes = (
            "Daily",       "Weekly",       "Monthly",       "Yearly",
            "CustomDaily", "CustomWeekly", "CustomMonthly", "CustomYearly"
        );

        if (
            !$Param{RecurrenceType}
            || !grep { $_ eq $Param{RecurrenceType} } @RecurrenceTypes
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RecurrenceType invalid!",
            );
            return;
        }

        if (
            (
                $Param{RecurrenceType} eq 'CustomWeekly'
                || $Param{RecurrenceType} eq 'CustomMonthly'
                || $Param{RecurrenceType} eq 'CustomYearly'
            )
            && !$Param{RecurrenceFrequency}
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RecurrenceFrequency needed!",
            );
            return;
        }
    }

    $Param{RecurrenceInterval} ||= 1;

    if ( $Param{UniqueID} && !$Param{ParentID} ) {
        my %Appointment = $Self->AppointmentGet(
            UniqueID   => $Param{UniqueID},
            CalendarID => $Param{CalendarID},
        );

        # delete existing appointment with same UniqueID
        if ( %Appointment && $Appointment{AppointmentID} ) {
            $Self->AppointmentDelete(
                AppointmentID => $Appointment{AppointmentID},
                UserID        => $Param{UserID},
            );
        }
    }

    # check ParentID
    if ( $Param{ParentID} && !IsInteger( $Param{ParentID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ParentID must be a number!",
        );
        return;
    }

    # Check StartTime.
    my $StartTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{StartTime},
        },
    );
    if ( !$StartTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid StartTime!",
        );
        return;
    }

    # check UniqueID
    if ( !$Param{UniqueID} ) {
        $Param{UniqueID} = $Self->GetUniqueID(
            CalendarID => $Param{CalendarID},
            StartTime  => $Param{StartTime},
            UserID     => $Param{UserID},
        );
    }

    # Check EndTime.
    my $EndTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{EndTime},
        },
    );
    if ( !$EndTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid EndTime!",
        );
        return;
    }

    # check if array refs
    my %Arrays;
    for my $Parameter (
        qw(TeamID ResourceID RecurrenceFrequency RecurrenceExclude)
        )
    {
        if ( $Param{$Parameter} && @{ $Param{$Parameter} // [] } ) {
            if ( !IsArrayRefWithData( $Param{$Parameter} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$Parameter not ARRAYREF!",
                );
                return;
            }

            my @Array = @{ $Param{$Parameter} };

            # remove undefined values
            @Array = grep { defined $_ } @Array;

            $Arrays{$Parameter} = join( ',', @Array ) if @Array;
        }
    }

    # check if numbers
    for my $Parameter (
        qw(Recurring RecurrenceCount RecurrenceInterval)
        )
    {
        if ( $Param{$Parameter} && !IsInteger( $Param{$Parameter} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Parameter must be a number!",
            );
            return;
        }
    }

    # check RecurrenceUntil
    if ( $Param{RecurrenceUntil} ) {

        # Usually hour, minute and second = 0. In this case, take time from StartTime.
        $Param{RecurrenceUntil} = $Self->_TimeCheck(
            OriginalTime => $Param{StartTime},
            Time         => $Param{RecurrenceUntil},
        );

        my $RecurrenceUntilObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{RecurrenceUntil},
            },
        );

        if (
            !$RecurrenceUntilObject
            || $StartTimeObject > $RecurrenceUntilObject
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid RecurrenceUntil!",
            );
            return;
        }
    }

    # get db object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my @Bind;

    # parent ID supplied
    my $ParentIDCol = my $ParentIDVal = '';
    if ( $Param{ParentID} ) {
        $ParentIDCol = 'parent_id,';
        $ParentIDVal = '?,';
        push @Bind, \$Param{ParentID};

        # turn off all recurring fields
        delete $Param{Recurring};
        delete $Param{RecurrenceType};
        delete $Param{RecurrenceFrequency};
        delete $Param{RecurrenceCount};
        delete $Param{RecurrenceInterval};
        delete $Param{RecurrenceUntil};
    }

    push @Bind, \$Param{CalendarID}, \$Param{UniqueID}, \$Param{Title}, \$Param{Description},
        \$Param{Location}, \$Param{StartTime},   \$Param{EndTime},   \$Param{AllDay},
        \$Arrays{TeamID},  \$Arrays{ResourceID}, \$Param{Recurring}, \$Param{RecurrenceType},
        \$Arrays{RecurrenceFrequency}, \$Param{RecurrenceCount},      \$Param{RecurrenceInterval},
        \$Param{RecurrenceUntil},      \$Param{RecurrenceID},         \$Arrays{RecurrenceExclude},
        \$Param{NotificationDate},     \$Param{NotificationTemplate}, \$Param{NotificationCustom},
        \$Param{NotificationCustomRelativeUnitCount},   \$Param{NotificationCustomRelativeUnit},
        \$Param{NotificationCustomRelativePointOfTime}, \$Param{NotificationCustomDateTime},
        \$Param{TicketAppointmentRuleID},               \$Param{UserID}, \$Param{UserID};

    my $SQL = "
        INSERT INTO calendar_appointment
            ($ParentIDCol calendar_id, unique_id, title, description, location, start_time,
            end_time, all_day, team_id, resource_id, recurring, recur_type, recur_freq, recur_count,
            recur_interval, recur_until, recur_id, recur_exclude, notify_time, notify_template,
            notify_custom, notify_custom_unit_count, notify_custom_unit, notify_custom_unit_point,
            notify_custom_date, ticket_appointment_rule_id, create_time, create_by, change_time,
            change_by)
        VALUES ($ParentIDVal ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            ?, ?, current_timestamp, ?, current_timestamp, ?)
    ";

    # create db record
    return if !$DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $AppointmentID;

    # return parent id for appointment occurrences
    if ( $Param{ParentID} ) {
        $AppointmentID = $Param{ParentID};
    }

    # get appointment id for parent appointment
    else {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id FROM calendar_appointment
                WHERE unique_id=? AND parent_id IS NULL
            ',
            Bind  => [ \$Param{UniqueID} ],
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $AppointmentID = $Row[0] || '';
        }

        # return if there is not appointment created
        if ( !$AppointmentID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Can\'t get AppointmentID from INSERT!',
            );
            return;
        }
    }

    # add recurring appointments
    if ( $Param{Recurring} && !$Param{RecurringRaw} ) {
        return if !$Self->_AppointmentRecurringCreate(
            ParentID    => $AppointmentID,
            Appointment => \%Param,
        );
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # clean up list methods cache
    $CacheObject->CleanUp(
        Type => $Self->{CacheType} . 'List' . $Param{CalendarID},
    );
    $CacheObject->CleanUp(
        Type => $Self->{CacheType} . 'Days' . $Param{UserID},
    );

    # fire event
    $Self->EventHandler(
        Event => 'AppointmentCreate',
        Data  => {
            AppointmentID => $AppointmentID,
            CalendarID    => $Param{CalendarID},
        },
        UserID => $Param{UserID},
    );

    return $AppointmentID;
}

=head2 AppointmentList()

get a hash of Appointments.

    my @Appointments = $AppointmentObject->AppointmentList(
        CalendarID          => 1,                                       # (required) Valid CalendarID
        Title               => '*',                                     # (optional) Filter by title, wildcard supported
        Description         => '*',                                     # (optional) Filter by description, wildcard supported
        Location            => '*',                                     # (optional) Filter by location, wildcard supported
        StartTime           => '2016-01-01 00:00:00',                   # (optional) Filter by start date
        EndTime             => '2016-02-01 00:00:00',                   # (optional) Filter by end date
        TeamID              => 1,                                       # (optional) Filter by team
        ResourceID          => 2,                                       # (optional) Filter by resource
        Result              => 'HASH',                                  # (optional), HASH|ARRAY
    );

returns an array of hashes with select Appointment data or simple array of AppointmentIDs:

Result => 'HASH':

    @Appointments = [
        {
            AppointmentID => 1,
            CalendarID    => 1,
            UniqueID      => '20160101T160000-71E386@localhost',
            Title         => 'Webinar',
            Description   => 'How to use Process tickets...',
            Location      => 'Straubing',
            StartTime     => '2016-01-01 16:00:00',
            EndTime       => '2016-01-01 17:00:00',
            AllDay        => 0,
            Recurring     => 1,                                           # for recurring (parent) appointments only
        },
        {
            AppointmentID => 2,
            ParentID      => 1,                                           # for recurred (child) appointments only
            CalendarID    => 1,
            UniqueID      => '20160101T180000-A78B57@localhost',
            Title         => 'Webinar',
            Description   => 'How to use Process tickets...',
            Location      => 'Straubing',
            StartTime     => '2016-01-02 16:00:00',
            EndTime       => '2016-01-02 17:00:00',
            TeamID        => [ 1 ],
            ResourceID    => [ 1, 3 ],
            AllDay        => 0,
        },
        {
            AppointmentID                         => 3,
            CalendarID                            => 1,
            UniqueID                              => '20160101T180000-A78B57@localhost',
            Title                                 => 'Webinar',
            Description                           => 'How to use Process tickets...',
            Location                              => 'Straubing',
            StartTime                             => '2016-01-02 16:00:00',
            EndTime                               => '2016-01-02 17:00:00',
            TimezoneID                            => 1,
            TeamID                                => [ 1 ],
            ResourceID                            => [ 1, 3 ],
            NotificationDate                      => '2016-01-02 16:10:00',
            NotificationTemplate                  => 'Custom',
            NotificationCustom                    => 'relative',
            NotificationCustomRelativeUnitCount   => '10',
            NotificationCustomRelativeUnit        => 'minutes',
            NotificationCustomRelativePointOfTime => 'afterstart',
            NotificationCustomDateTime            => '2016-01-02 16:00:00',
            TicketAppointmentRuleID               => '9bb20ea035e7a9930652a9d82d00c725',    # for ticket appointments only!
        },
        ...
    ];

Result => 'ARRAY':

    @Appointments = [ 1, 2, ... ]

=cut

sub AppointmentList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(CalendarID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # output array of hashes by default
    $Param{Result} = $Param{Result} || 'HASH';

    # cache keys
    my $CacheType        = $Self->{CacheType} . 'List' . $Param{CalendarID};
    my $CacheKeyTitle    = $Param{Title} || 'any';
    my $CacheKeyDesc     = $Param{Description} || 'any';
    my $CacheKeyLocation = $Param{Location} || 'any';
    my $CacheKeyStart    = $Param{StartTime} || 'any';
    my $CacheKeyEnd      = $Param{EndTime} || 'any';
    my $CacheKeyTeam     = $Param{TeamID} || 'any';
    my $CacheKeyResource = $Param{ResourceID} || 'any';

    if ( defined $Param{Title} && $Param{Title} =~ /^[\*]+$/ ) {
        $CacheKeyTitle = 'any';
    }
    if ( defined $Param{Description} && $Param{Description} =~ /^[\*]+$/ ) {
        $CacheKeyDesc = 'any';
    }
    if ( defined $Param{Location} && $Param{Location} =~ /^[\*]+$/ ) {
        $CacheKeyLocation = 'any';
    }

    my $CacheKey
        = "$CacheKeyTitle-$CacheKeyDesc-$CacheKeyLocation-$CacheKeyStart-$CacheKeyEnd-$CacheKeyTeam-$CacheKeyResource-$Param{Result}";

    # check cache
    my $Data = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    if ( ref $Data eq 'ARRAY' ) {
        return @{$Data};
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check time
    if ( $Param{StartTime} ) {
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{StartTime},
            },
        );
        if ( !$StartTimeObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "StartTime invalid!",
            );
            return;
        }
    }
    if ( $Param{EndTime} ) {
        my $EndTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{EndTime},
            },
        );
        if ( !$EndTimeObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "EndTime invalid!",
            );
            return;
        }
    }

    my $SQL = '
        SELECT id, parent_id, calendar_id, unique_id, title, description, location, start_time,
            end_time, team_id, resource_id, all_day, recurring, notify_time, notify_template,
            notify_custom, notify_custom_unit_count, notify_custom_unit, notify_custom_unit_point,
            notify_custom_date, ticket_appointment_rule_id
        FROM calendar_appointment
        WHERE calendar_id=?
    ';

    my @Bind;

    push @Bind, \$Param{CalendarID};

    # Filter title, description and location fields by using QueryCondition method, which will
    #   return backend specific SQL statements in order to provide case insensitive match and
    #   wildcard support.
    FILTER:
    for my $Filter (qw(Title Description Location)) {
        next FILTER if !$Param{$Filter};
        $SQL .= ' AND ' . $DBObject->QueryCondition(
            Key          => lc $Filter,
            Value        => $Param{$Filter},
            SearchPrefix => '*',
            SearchSuffix => '*',
        );
    }

    if ( $Param{StartTime} && $Param{EndTime} ) {

        $SQL .= ' AND (
            (start_time >= ? AND start_time < ?) OR
            (end_time > ? AND end_time <= ?) OR
            (start_time <= ? AND end_time >= ?)
        ) ';
        push @Bind, \$Param{StartTime}, \$Param{EndTime}, \$Param{StartTime}, \$Param{EndTime}, \$Param{StartTime},
            \$Param{EndTime};
    }
    elsif ( $Param{StartTime} && !$Param{EndTime} ) {

        $SQL .= ' AND end_time >= ? ';
        push @Bind, \$Param{StartTime};
    }
    elsif ( !$Param{StartTime} && $Param{EndTime} ) {

        $SQL .= ' AND start_time <= ? ';
        push @Bind, \$Param{EndTime};
    }

    $SQL .= ' ORDER BY id ASC';

    # db query
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Result;

    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # team id
        my @TeamID = split( ',', $Row[9] // '' );
        if ( $Param{TeamID} ) {
            next ROW if !grep { $_ == $Param{TeamID} } @TeamID;
        }

        # resource id
        $Row[10] = $Row[10] ? $Row[10] : 0;
        my @ResourceID = $Row[10] =~ /,/ ? split( ',', $Row[10] ) : ( $Row[10] );
        if ( $Param{ResourceID} ) {
            next ROW if !grep { $_ == $Param{ResourceID} } @ResourceID;
        }

        my %Appointment = (
            AppointmentID                         => $Row[0],
            ParentID                              => $Row[1],
            CalendarID                            => $Row[2],
            UniqueID                              => $Row[3],
            Title                                 => $Row[4],
            Description                           => $Row[5],
            Location                              => $Row[6],
            StartTime                             => $Row[7],
            EndTime                               => $Row[8],
            TeamID                                => \@TeamID,
            ResourceID                            => \@ResourceID,
            AllDay                                => $Row[11],
            Recurring                             => $Row[12],
            NotificationDate                      => $Row[13] || '',
            NotificationTemplate                  => $Row[14],
            NotificationCustom                    => $Row[15],
            NotificationCustomRelativeUnitCount   => $Row[16],
            NotificationCustomRelativeUnit        => $Row[17],
            NotificationCustomRelativePointOfTime => $Row[18],
            NotificationCustomDateTime            => $Row[19] || '',
            TicketAppointmentRuleID               => $Row[20],
        );
        push @Result, \%Appointment;
    }

    # if Result was ARRAY, output only IDs
    if ( $Param{Result} eq 'ARRAY' ) {
        my @ResultList;
        for my $Appointment (@Result) {
            push @ResultList, $Appointment->{AppointmentID};
        }
        @Result = @ResultList;
    }

    # cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Result,
        TTL   => $Self->{CacheTTL},
    );

    return @Result;
}

=head2 AppointmentDays()

get a hash of days with Appointments in all user calendars.

    my %AppointmentDays = $AppointmentObject->AppointmentDays(
        StartTime           => '2016-01-01 00:00:00',                   # (optional) Filter by start date
        EndTime             => '2016-02-01 00:00:00',                   # (optional) Filter by end date
        UserID              => 1,                                       # (required) Valid UserID
    );

returns a hash with days as keys and number of Appointments as values:

    %AppointmentDays = {
        '2016-01-01' => 1,
        '2016-01-13' => 2,
        '2016-01-30' => 1,
    };

=cut

sub AppointmentDays {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # cache keys
    my $CacheType     = $Self->{CacheType} . 'Days' . $Param{UserID};
    my $CacheKeyStart = $Param{StartTime} || 'any';
    my $CacheKeyEnd   = $Param{EndTime} || 'any';

    # check time
    if ( $Param{StartTime} ) {
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{StartTime},
            },
        );
        if ( !$StartTimeObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "StartTime invalid!",
            );
            return;
        }
    }
    if ( $Param{EndTime} ) {
        my $EndTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{EndTime},
            },
        );
        if ( !$EndTimeObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "EndTime invalid!",
            );
            return;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $Data = $CacheObject->Get(
        Type => $CacheType,
        Key  => "$CacheKeyStart-$CacheKeyEnd",
    );

    if ( ref $Data eq 'HASH' ) {
        return %{$Data};
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get user groups
    my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
        UserID => $Param{UserID},
        Type   => 'ro',
    );
    my @GroupIDs = sort keys %GroupList;

    my $SQL = "
        SELECT ca.start_time, ca.end_time
        FROM calendar_appointment ca
        JOIN calendar c ON ca.calendar_id = c.id
        WHERE c.group_id IN ( ${\(join ', ', @GroupIDs)} )
    ";

    my @Bind;

    if ( $Param{StartTime} && $Param{EndTime} ) {

        $SQL .= 'AND (
            (ca.start_time >= ? AND ca.start_time < ?) OR
            (ca.end_time > ? AND ca.end_time <= ?) OR
            (ca.start_time <= ? AND ca.end_time >= ?)
        ) ';
        push @Bind, \$Param{StartTime}, \$Param{EndTime}, \$Param{StartTime}, \$Param{EndTime}, \$Param{StartTime},
            \$Param{EndTime};
    }
    elsif ( $Param{StartTime} && !$Param{EndTime} ) {

        $SQL .= 'AND ca.end_time >= ? ';
        push @Bind, \$Param{StartTime};
    }
    elsif ( !$Param{StartTime} && $Param{EndTime} ) {

        $SQL .= 'AND ca.start_time <= ? ';
        push @Bind, \$Param{EndTime};
    }

    $SQL .= 'ORDER BY ca.id ASC';

    # db query
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my %Result;

    while ( my @Row = $DBObject->FetchrowArray() ) {

        my ( $StartTime, $EndTime, $StartTimeSystem, $EndTimeSystem );

        # StartTime
        if ( $Param{StartTime} ) {
            $StartTime = $Row[0] lt $Param{StartTime} ? $Param{StartTime} : $Row[0];
        }
        else {
            $StartTime = $Row[0];
        }

        # EndTime
        if ( $Param{EndTime} ) {
            $EndTime = $Row[1] gt $Param{EndTime} ? $Param{EndTime} : $Row[1];
        }
        else {
            $EndTime = $Row[1];
        }

        # Get system times.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $StartTime,
            },
        );
        my $EndTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $EndTime,
            },
        );

        for (
            my $LoopTimeObject = $StartTimeObject->Clone();
            $LoopTimeObject < $EndTimeObject;
            $LoopTimeObject->Add( Days => 1 )
            )
        {
            my $LoopTime = $LoopTimeObject->ToString();

            $LoopTime =~ s/\s.*?$//gsm;

            if ( $Result{$LoopTime} ) {
                $Result{$LoopTime}++;
            }
            else {
                $Result{$LoopTime} = 1;
            }
        }
    }

    # cache
    $CacheObject->Set(
        Type  => $CacheType,
        Key   => "$CacheKeyStart-$CacheKeyEnd",
        Value => \%Result,
        TTL   => $Self->{CacheTTL},
    );

    return %Result;
}

=head2 AppointmentGet()

Get appointment data.

    my %Appointment = $AppointmentObject->AppointmentGet(
        AppointmentID => 1,                                  # (required)
                                                             # or
        UniqueID      => '20160101T160000-71E386@localhost', # (required) will return only parent for recurring appointments
        CalendarID    => 1,                                  # (required)
    );

Returns a hash:

    %Appointment = (
        AppointmentID       => 2,
        ParentID            => 1,                                  # only for recurred (child) appointments
        CalendarID          => 1,
        UniqueID            => '20160101T160000-71E386@localhost',
        Title               => 'Webinar',
        Description         => 'How to use Process tickets...',
        Location            => 'Straubing',
        StartTime           => '2016-01-01 16:00:00',
        EndTime             => '2016-01-01 17:00:00',
        AllDay              => 0,
        TeamID              => [ 1 ],
        ResourceID          => [ 1, 3 ],
        Recurring           => 1,
        RecurrenceType      => 'Daily',
        RecurrenceFrequency => 1,
        RecurrenceCount     => 1,
        RecurrenceInterval  => 2,
        RecurrenceUntil     => '2016-01-10 00:00:00',
        RecurrenceID        => '2016-01-10 00:00:00',
        RecurrenceExclude   => [
            '2016-01-10 00:00:00',
            '2016-01-11 00:00:00',
        ],
        NotificationTime                  => '2016-01-01 17:0:00',
        NotificationTemplate              => 'Custom',
        NotificationCustomUnitCount       => '12',
        NotificationCustomUnit            => 'minutes',
        NotificationCustomUnitPointOfTime => 'beforestart',

        TicketAppointmentRuleID => '9bb20ea035e7a9930652a9d82d00c725',  # for ticket appointments only!
        CreateTime              => '2016-01-01 00:00:00',
        CreateBy                => 2,
        ChangeTime              => '2016-01-01 00:00:00',
        ChangeBy                => 2,
    );

=cut

sub AppointmentGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if (
        !$Param{AppointmentID}
        && !( $Param{UniqueID} && $Param{CalendarID} )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need AppointmentID or UniqueID and CalendarID!",
        );
        return;
    }

    my $Data;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    if ( $Param{AppointmentID} ) {

        # check cache
        $Data = $CacheObject->Get(
            Type => $Self->{CacheType},
            Key  => $Param{AppointmentID},
        );
    }

    if ( ref $Data eq 'HASH' ) {
        return %{$Data};
    }

    # needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @Bind;
    my $SQL = '
        SELECT id, parent_id, calendar_id, unique_id, title, description, location, start_time,
            end_time, all_day, team_id, resource_id, recurring, recur_type, recur_freq, recur_count,
            recur_interval, recur_until, recur_id, recur_exclude, notify_time, notify_template,
            notify_custom, notify_custom_unit_count, notify_custom_unit, notify_custom_unit_point,
            notify_custom_date, ticket_appointment_rule_id, create_time, create_by, change_time,
            change_by
        FROM calendar_appointment
        WHERE
    ';

    if ( $Param{AppointmentID} ) {
        $SQL .= 'id=? ';
        push @Bind, \$Param{AppointmentID};
    }
    else {
        $SQL .= 'unique_id=? AND calendar_id=? AND parent_id IS NULL ';
        push @Bind, \$Param{UniqueID}, \$Param{CalendarID};
    }

    # db query
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my %Result;

    while ( my @Row = $DBObject->FetchrowArray() ) {

        # team id
        my @TeamID = split( ',', $Row[10] // '' );

        # resource id
        my @ResourceID = split( ',', $Row[11] // '0' );

        # recurrence frequency
        my @RecurrenceFrequency = $Row[14] ? split( ',', $Row[14] ) : undef;

        # recurrence exclude
        my @RecurrenceExclude = $Row[19] ? split( ',', $Row[19] ) : undef;

        $Result{AppointmentID}                         = $Row[0];
        $Result{ParentID}                              = $Row[1];
        $Result{CalendarID}                            = $Row[2];
        $Result{UniqueID}                              = $Row[3];
        $Result{Title}                                 = $Row[4];
        $Result{Description}                           = $Row[5];
        $Result{Location}                              = $Row[6];
        $Result{StartTime}                             = $Row[7];
        $Result{EndTime}                               = $Row[8];
        $Result{AllDay}                                = $Row[9];
        $Result{TeamID}                                = \@TeamID;
        $Result{ResourceID}                            = \@ResourceID;
        $Result{Recurring}                             = $Row[12];
        $Result{RecurrenceType}                        = $Row[13];
        $Result{RecurrenceFrequency}                   = \@RecurrenceFrequency;
        $Result{RecurrenceCount}                       = $Row[15];
        $Result{RecurrenceInterval}                    = $Row[16];
        $Result{RecurrenceUntil}                       = $Row[17];
        $Result{RecurrenceID}                          = $Row[18];
        $Result{RecurrenceExclude}                     = \@RecurrenceExclude;
        $Result{NotificationDate}                      = $Row[20] || '';
        $Result{NotificationTemplate}                  = $Row[21] || '';
        $Result{NotificationCustom}                    = $Row[22] || '';
        $Result{NotificationCustomRelativeUnitCount}   = $Row[23] || 0;
        $Result{NotificationCustomRelativeUnit}        = $Row[24] || '';
        $Result{NotificationCustomRelativePointOfTime} = $Row[25] || '';
        $Result{NotificationCustomDateTime}            = $Row[26] || '';
        $Result{TicketAppointmentRuleID}               = $Row[27];
        $Result{CreateTime}                            = $Row[28];
        $Result{CreateBy}                              = $Row[29];
        $Result{ChangeTime}                            = $Row[30];
        $Result{ChangeBy}                              = $Row[31];
    }

    if ( $Param{AppointmentID} ) {

        # cache
        $CacheObject->Set(
            Type  => $Self->{CacheType},
            Key   => $Param{AppointmentID},
            Value => \%Result,
            TTL   => $Self->{CacheTTL},
        );
    }

    return %Result;
}

=head2 AppointmentUpdate()

updates an existing appointment.

    my $Success = $AppointmentObject->AppointmentUpdate(
        AppointmentID         => 2,                                       # (required)
        CalendarID            => 1,                                       # (required) Valid CalendarID
        Title                 => 'Webinar',                               # (required) Title
        Description           => 'How to use Process tickets...',         # (optional) Description
        Location              => 'Straubing',                             # (optional) Location
        StartTime             => '2016-01-01 16:00:00',                   # (required)
        EndTime               => '2016-01-01 17:00:00',                   # (required)
        AllDay                => 0,                                       # (optional) Default 0
        Team                  => 1,                                       # (optional)
        ResourceID            => [ 1, 3 ],                                # (optional) must be an array reference if supplied
        Recurring             => 1,                                       # (optional) flag the appointment as recurring (parent only!)

        RecurrenceType        => 'Daily',                                 # (required if Recurring) Possible "Daily", "Weekly", "Monthly", "Yearly",
                                                                          #           "CustomWeekly", "CustomMonthly", "CustomYearly"

        RecurrenceFrequency   => 1,                                       # (required if Custom Recurring) Recurrence pattern
                                                                          #           for CustomWeekly: 1-Mon, 2-Tue,..., 7-Sun
                                                                          #           for CustomMonthly: 1-Jan, 2-Feb,..., 12-Dec
                                                                          # ...
        RecurrenceCount       => 1,                                       # (optional) How many Appointments to create
        RecurrenceInterval    => 2,                                       # (optional) Repeating interval (default 1)
        RecurrenceUntil       => '2016-01-10 00:00:00',                   # (optional) Until date
        NotificationTime      => '2016-01-01 17:00:00',                   # (optional) Point of time to execute the notification event
        NotificationTemplate  => 'Custom',                                # (optional) Template to be used for notification point of time
        NotificationCustom    => 'relative',                              # (optional) Type of the custom template notification point of time
                                                                          #            Possible "relative", "datetime"
        NotificationCustomRelativeUnitCount   => '12',                    # (optional) minutes, hours or days count for custom template
        NotificationCustomRelativeUnit        => 'minutes',               # (optional) minutes, hours or days unit for custom template
        NotificationCustomRelativePointOfTime => 'beforestart',           # (optional) Point of execute for custom templates
                                                                          #            Possible "beforestart", "afterstart", "beforeend", "afterend"
        NotificationCustomDateTime => '2016-01-01 17:00:00',              # (optional) Notification date time for custom template
        TicketAppointmentRuleID    => '9bb20ea035e7a9930652a9d82d00c725', # (optional) Ticket appointment rule ID (for ticket appointments only!)
        UserID                     => 1,                                  # (required) UserID
    );

returns 1 if successful:
    $Success = 1;

Events:
    AppointmentUpdate

=cut

sub AppointmentUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID CalendarID Title StartTime EndTime UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # prepare possible notification params
    my $Success = $Self->_AppointmentNotificationPrepare(
        Data => \%Param,
    );

    # if Recurring is provided, additional parameters must be present
    if ( $Param{Recurring} ) {

        my @RecurrenceTypes = (
            "Daily",       "Weekly",       "Monthly",       "Yearly",
            "CustomDaily", "CustomWeekly", "CustomMonthly", "CustomYearly"
        );

        if (
            !$Param{RecurrenceType}
            || !grep { $_ eq $Param{RecurrenceType} } @RecurrenceTypes
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RecurrenceType invalid!",
            );
            return;
        }

        if (
            (
                $Param{RecurrenceType} eq 'CustomWeekly'
                || $Param{RecurrenceType} eq 'CustomMonthly'
                || $Param{RecurrenceType} eq 'CustomYearly'
            )
            && !$Param{RecurrenceFrequency}
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RecurrenceFrequency needed!",
            );
            return;
        }
    }

    $Param{RecurrenceInterval} ||= 1;

    # Check StartTime.
    my $StartTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{StartTime},
        },
    );
    if ( !$StartTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "StartTime invalid!",
        );
        return;
    }

    # Check EndTime.
    my $EndTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{EndTime},
        },
    );
    if ( !$EndTimeObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EndTime invalid!",
        );
        return;
    }

    # needed objects
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check if array refs
    my %Arrays;
    for my $Parameter (
        qw(TeamID ResourceID RecurrenceFrequency)
        )
    {
        if ( $Param{$Parameter} && @{ $Param{$Parameter} // [] } ) {
            if ( !IsArrayRefWithData( $Param{$Parameter} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$Parameter not ARRAYREF!",
                );
                return;
            }

            my @Array = @{ $Param{$Parameter} };

            # remove undefined values
            @Array = grep { defined $_ } @Array;

            $Arrays{$Parameter} = join( ',', @Array ) if @Array;
        }
    }

    # check if numbers
    for my $Parameter (
        qw(Recurring RecurrenceCount RecurrenceInterval)
        )
    {
        if ( $Param{$Parameter} && !IsInteger( $Param{$Parameter} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Parameter must be a number!",
            );
            return;
        }
    }

    # check RecurrenceUntil
    if ( $Param{RecurrenceUntil} ) {

        # Usually hour, minute and second = 0. In this case, take time from StartTime.
        $Param{RecurrenceUntil} = $Self->_TimeCheck(
            OriginalTime => $Param{StartTime},
            Time         => $Param{RecurrenceUntil},
        );

        my $RecurrenceUntilObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{RecurrenceUntil},
            },
        );

        if (
            !$RecurrenceUntilObject
            || $StartTimeObject > $RecurrenceUntilObject
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RecurrenceUntil invalid!",
            );
            return;
        }
    }

    # get previous CalendarID
    my $PreviousCalendarID = $Self->_AppointmentGetCalendarID(
        AppointmentID => $Param{AppointmentID},
    );

    # set recurrence exclude list
    my @RecurrenceExclude = @{ $Param{RecurrenceExclude} // [] };

    # get RecurrenceID
    my $RecurrenceID = $Self->_AppointmentGetRecurrenceID(
        AppointmentID => $Param{AppointmentID},
    );

    # use exclude list to flag the recurring occurrence as updated
    if ($RecurrenceID) {
        @RecurrenceExclude = ($RecurrenceID);
    }

    # reset exclude list if recurrence is turned off
    elsif ( !$Param{Recurring} ) {
        @RecurrenceExclude = ();
    }

    # remove undefined values
    @RecurrenceExclude = grep { defined $_ } @RecurrenceExclude;

    # serialize data
    my $RecurrenceExclude = join( ',', @RecurrenceExclude ) || undef;

    # delete existing recurred appointments
    my $DeleteSuccess = $Self->_AppointmentRecurringDelete(
        ParentID => $Param{AppointmentID},
    );

    if ( !$DeleteSuccess ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Unable to delete recurring Appointment!",
        );
        return;
    }

    # update appointment
    my $SQL = '
        UPDATE calendar_appointment
        SET
            calendar_id=?, title=?, description=?, location=?, start_time=?, end_time=?, all_day=?,
            team_id=?, resource_id=?, recurring=?, recur_type=?, recur_freq=?, recur_count=?,
            recur_interval=?, recur_until=?, recur_exclude=?, notify_time=?, notify_template=?,
            notify_custom=?, notify_custom_unit_count=?, notify_custom_unit=?,
            notify_custom_unit_point=?, notify_custom_date=?, ticket_appointment_rule_id=?,
            change_time=current_timestamp, change_by=?
        WHERE id=?
    ';

    # update db record
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => [
            \$Param{CalendarID}, \$Param{Title},   \$Param{Description}, \$Param{Location},
            \$Param{StartTime},  \$Param{EndTime}, \$Param{AllDay},      \$Arrays{TeamID},
            \$Arrays{ResourceID},          \$Param{Recurring},       \$Param{RecurrenceType},
            \$Arrays{RecurrenceFrequency}, \$Param{RecurrenceCount}, \$Param{RecurrenceInterval},
            \$Param{RecurrenceUntil}, \$RecurrenceExclude, \$Param{NotificationDate},
            \$Param{NotificationTemplate},                  \$Param{NotificationCustom},
            \$Param{NotificationCustomRelativeUnitCount},   \$Param{NotificationCustomRelativeUnit},
            \$Param{NotificationCustomRelativePointOfTime}, \$Param{NotificationCustomDateTime},
            \$Param{TicketAppointmentRuleID},               \$Param{UserID}, \$Param{AppointmentID},
        ],
    );

    # add recurred appointments again
    if ( $Param{Recurring} ) {
        return if !$Self->_AppointmentRecurringCreate(
            ParentID    => $Param{AppointmentID},
            Appointment => \%Param,
        );
    }

    # delete cache
    $CacheObject->Delete(
        Type => $Self->{CacheType},
        Key  => $Param{AppointmentID},
    );

    # clean up list methods cache
    my @CalendarIDs = ( $Param{CalendarID} );
    push @CalendarIDs, $PreviousCalendarID if $PreviousCalendarID ne $Param{CalendarID};
    for my $CalendarID (@CalendarIDs) {
        $CacheObject->CleanUp(
            Type => $Self->{CacheType} . 'List' . $CalendarID,
        );
    }
    $CacheObject->CleanUp(
        Type => $Self->{CacheType} . 'Days' . $Param{UserID},
    );

    # fire event
    $Self->EventHandler(
        Event => 'AppointmentUpdate',
        Data  => {
            AppointmentID => $Param{AppointmentID},
            CalendarID    => $Param{CalendarID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 AppointmentDelete()

deletes an existing appointment.

    my $Success = $AppointmentObject->AppointmentDelete(
        AppointmentID   => 1,                              # (required)
        UserID          => 1,                              # (required)
    );

returns 1 if successful:
    $Success = 1;

Events:
    AppointmentDelete

=cut

sub AppointmentDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # needed objects
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # get CalendarID
    my $CalendarID = $Self->_AppointmentGetCalendarID(
        AppointmentID => $Param{AppointmentID},
    );

    # check user's permissions for this calendar
    my $Permission = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarPermissionGet(
        CalendarID => $CalendarID,
        UserID     => $Param{UserID},
    );

    my @RequiredPermissions = ( 'create', 'rw' );

    if ( !grep { $Permission eq $_ } @RequiredPermissions ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "User($Param{UserID}) has no permission to delete Appointment($Param{AppointmentID})!",
        );
        return;
    }

    my %Appointment = $Self->AppointmentGet(
        AppointmentID => $Param{AppointmentID},
    );

    # save exclusion info to parent appointment
    if ( $Appointment{ParentID} && $Appointment{RecurrenceID} ) {
        $Self->_AppointmentRecurringExclude(
            ParentID     => $Appointment{ParentID},
            RecurrenceID => $Appointment{RecurrenceID},
        );
    }

    # delete recurring appointments
    my $DeleteRecurringSuccess = $Self->_AppointmentRecurringDelete(
        ParentID => $Param{AppointmentID},
    );

    if ( !$DeleteRecurringSuccess ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Recurring appointments couldn\'t be deleted!',
        );
        return;
    }

    # delete appointment
    my $SQL = '
        DELETE FROM calendar_appointment
        WHERE id=?
    ';

    # delete db record
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => [
            \$Param{AppointmentID},
        ],
    );

    # Fire event.
    $Self->EventHandler(
        Event => 'AppointmentDelete',
        Data  => {
            AppointmentID => $Param{AppointmentID},
            CalendarID    => $CalendarID,
        },
        UserID => $Param{UserID},
    );

    # delete cache
    $CacheObject->Delete(
        Type => $Self->{CacheType},
        Key  => $Param{AppointmentID},
    );

    # clean up list methods cache
    $CacheObject->CleanUp(
        Type => $Self->{CacheType} . 'List' . $CalendarID,
    );
    $CacheObject->CleanUp(
        Type => $Self->{CacheType} . 'Days' . $Param{UserID},
    );

    return 1;
}

=head2 AppointmentDeleteOccurrence()

deletes a single recurring appointment occurrence.

    my $Success = $AppointmentObject->AppointmentDeleteOccurrence(
        UniqueID     => '20160101T160000-71E386@localhost',    # (required)
        RecurrenceID => '2016-01-10 00:00:00',                 # (required)
        UserID       => 1,                                     # (required)
    );

returns 1 if successful:
    $Success = 1;

=cut

sub AppointmentDeleteOccurrence {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(UniqueID CalendarID RecurrenceID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get db object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db query
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id FROM calendar_appointment
            WHERE unique_id=? AND calendar_id=? AND recur_id=?',
        Bind  => [ \$Param{UniqueID}, \$Param{CalendarID}, \$Param{RecurrenceID} ],
        Limit => 1,
    );

    my %Appointment;

    # get additional info
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Appointment{AppointmentID} = $Row[0];
    }
    return if !%Appointment;

    # delete db record
    return if !$DBObject->Do(
        SQL   => 'DELETE FROM calendar_appointment WHERE id=?',
        Bind  => [ \$Appointment{AppointmentID} ],
        Limit => 1,
    );

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # delete cache
    $CacheObject->Delete(
        Type => $Self->{CacheType},
        Key  => $Appointment{AppointmentID},
    );

    # clean up list methods cache
    $CacheObject->CleanUp(
        Type => $Self->{CacheType} . 'List' . $Param{CalendarID},
    );
    $CacheObject->CleanUp(
        Type => $Self->{CacheType} . 'Days' . $Param{UserID},
    );

    return 1;
}

=head2 GetUniqueID()

Returns UniqueID containing appointment start time, random hash and system C<FQDN>.

    my $UniqueID = $AppointmentObject->GetUniqueID(
        CalendarID => 1,                        # (required)
        StartTime  => '2016-01-01 00:00:00',    # (required)
        UserID     => 1,                        # (required)
    );

    $UniqueID = '20160101T000000-B9909D@localhost';

=cut

sub GetUniqueID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(CalendarID StartTime UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # calculate a hash
    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString( Length => 32 );
    my $String       = "$Param{CalendarID}-$RandomString-$Param{UserID}";
    my $Digest       = unpack( 'N', Digest::MD5->new()->add($String)->digest() );
    my $DigestHex    = sprintf( '%x', $Digest );
    my $Hash         = uc( sprintf( "%.6s", $DigestHex ) );

    # Prepare start timestamp for UniqueID.
    my $StartTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{StartTime},
        },
    );
    return if !$StartTimeObject;
    my $StartTimeStrg = $StartTimeObject->ToString();
    $StartTimeStrg =~ s/[-:]//g;
    $StartTimeStrg =~ s/\s/T/;

    # get system FQDN
    my $FQDN = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    # return UniqueID
    return "$StartTimeStrg-$Hash\@$FQDN";
}

=head2 AppointmentUpcomingGet()

Get appointment data for upcoming appointment start or end.

    my @UpcomingAppointments = $AppointmentObject->AppointmentUpcomingGet(
        Timestamp => '2016-08-02 03:59:00', # get appointments for the related notification timestamp
    );

Returns appointment data of AppointmentGet().

=cut

sub AppointmentUpcomingGet {
    my ( $Self, %Param ) = @_;

    # get current timestamp
    my $CurrentTimestamp;

    # create needed sql query based on the current or a given timestamp
    my $SQL = 'SELECT id, parent_id, calendar_id, unique_id FROM calendar_appointment ';

    if ( $Param{Timestamp} ) {
        $CurrentTimestamp = $Param{Timestamp};
        $SQL .= "WHERE notify_time = ? ";
    }
    else {
        $CurrentTimestamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();
        $SQL .= "WHERE notify_time >= ? ";
    }

    $SQL .= 'ORDER BY notify_time ASC';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db query
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => [ \$CurrentTimestamp ],
    );

    my @ResultRaw;

    while ( my @Row = $DBObject->FetchrowArray() ) {

        my %UpcomingAppointment;

        $UpcomingAppointment{AppointmentID} = $Row[0];
        $UpcomingAppointment{ParentID}      = $Row[1];
        $UpcomingAppointment{CalendarID}    = $Row[2];
        $UpcomingAppointment{UniqueID}      = $Row[3];

        push @ResultRaw, \%UpcomingAppointment;
    }

    my @Results;

    APPOINTMENTDATA:
    for my $AppointmentData (@ResultRaw) {

        next APPOINTMENTDATA if !IsHashRefWithData($AppointmentData);
        next APPOINTMENTDATA if !$AppointmentData->{CalendarID};
        next APPOINTMENTDATA if !$AppointmentData->{AppointmentID};

        my %Appointment = $Self->AppointmentGet( %{$AppointmentData} );

        push @Results, \%Appointment;
    }

    return @Results;
}

=head2 AppointmentFutureTasksDelete()

Delete all calendar appointment future tasks.

    my $Success = $AppointmentObject->AppointmentFutureTasksDelete();

returns:

    True if future task deletion was successful, otherwise false.

=cut

sub AppointmentFutureTasksDelete {
    my ( $Self, %Param ) = @_;

    # get a local scheduler db object
    my $SchedulerObject = $Kernel::OM->Get('Kernel::System::Scheduler');

    # get a list of already stored future tasks
    my @FutureTaskList = $SchedulerObject->FutureTaskList(
        Type => 'CalendarAppointment',
    );

    # flush obsolete future tasks
    if ( IsArrayRefWithData( \@FutureTaskList ) ) {

        FUTURETASK:
        for my $FutureTask (@FutureTaskList) {

            next FUTURETASK if !$FutureTask;
            next FUTURETASK if !IsHashRefWithData($FutureTask);

            my $Success = $SchedulerObject->FutureTaskDelete(
                TaskID => $FutureTask->{TaskID},
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not delete future task with id $FutureTask->{TaskID}!",
                );
                return;
            }
        }
    }

    return 1;
}

=head2 AppointmentFutureTasksUpdate()

Update OTRS daemon future task list for upcoming appointments.

    my $Success = $AppointmentObject->AppointmentFutureTasksUpdate();

returns:

    True if future task update was successful, otherwise false.

=cut

sub AppointmentFutureTasksUpdate {
    my ( $Self, %Param ) = @_;

    # get appointment data for upcoming appointments
    my @UpcomingAppointments = $Self->AppointmentUpcomingGet();

    # check for no upcoming appointments
    if ( !IsArrayRefWithData( \@UpcomingAppointments ) ) {

        # flush obsolete future tasks
        my $Success = $Self->AppointmentFutureTasksDelete();

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not delete appointment future tasks!',
            );
            return;
        }

        return 1;
    }

    # get a local scheduler db object
    my $SchedulerObject = $Kernel::OM->Get('Kernel::System::Scheduler');

    # get a list of already stored future tasks
    my @FutureTaskList = $SchedulerObject->FutureTaskList(
        Type => 'CalendarAppointment',
    );

    # check for invalid task count (just one task max allowed)
    if ( scalar @FutureTaskList > 1 ) {

        # flush obsolete future tasks
        my $Success = $Self->AppointmentFutureTasksDelete();

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not delete appointment future tasks!',
            );
            return;
        }
    }

    # check if it is needed to update the future task list
    if ( IsArrayRefWithData( \@FutureTaskList ) ) {
        my $UpdateNeeded = 0;

        FUTURETASK:
        for my $FutureTask (@FutureTaskList) {

            if (
                !IsHashRefWithData($FutureTask)
                || !$FutureTask->{TaskID}
                || !$FutureTask->{ExecutionTime}
                )
            {
                $UpdateNeeded = 1;
                last FUTURETASK;
            }

            # get the stored future task
            my %FutureTaskData = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->FutureTaskGet(
                TaskID => $FutureTask->{TaskID},
            );

            if ( !IsHashRefWithData( \%FutureTaskData ) ) {
                $UpdateNeeded = 1;
                last FUTURETASK;
            }

            # Get date time objects of stored and upcoming times to compare.
            my $FutureTaskTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $FutureTaskData{Data}->{NotifyTime},
                },
            );
            my $UpcomingAppointmentTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $UpcomingAppointments[0]->{NotificationDate},
                },
            );

            # Do nothing if the upcoming notification time equals the stored value.
            if ( $UpcomingAppointmentTimeObject != $FutureTaskTimeObject ) {
                $UpdateNeeded = 1;
                last FUTURETASK;
            }
        }

        if ($UpdateNeeded) {

            # flush obsolete future tasks
            my $Success = $Self->AppointmentFutureTasksDelete();

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Could not delete appointment future tasks!',
                );
                return;
            }
        }
        else {
            return 1;
        }
    }

    # schedule new future tasks for notification actions
    my $TaskID = $SchedulerObject->TaskAdd(
        ExecutionTime => $UpcomingAppointments[0]->{NotificationDate},
        Name          => 'AppointmentNotification',
        Type          => 'CalendarAppointment',
        Data          => {
            NotifyTime => $UpcomingAppointments[0]->{NotificationDate},
        },
    );

    if ( !$TaskID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Could not schedule future task for AppointmentID $UpcomingAppointments[0]->{AppointmentID}!",
        );
        return;
    }

    return 1;
}

=head2 _AppointmentNotificationPrepare()

Prepare appointment notification data.

    my $Success = $AppointmentObject->_AppointmentNotificationPrepare();

returns:

    True if preparation was successful, otherwise false.

=cut

sub _AppointmentNotificationPrepare {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # reset notification data if needed
    if ( !$Param{Data}->{NotificationTemplate} ) {

        for my $PossibleParam (
            qw(
            NotificationDate NotificationTemplate NotificationCustom NotificationCustomRelativeUnitCount
            NotificationCustomRelativeUnit NotificationCustomRelativePointOfTime NotificationCustomDateTime
            )
            )
        {
            $Param{Data}->{$PossibleParam} = undef;
        }
    }

    # prepare possible notification params
    for my $PossibleParam (
        qw(
        NotificationTemplate NotificationCustom NotificationCustomRelativeUnit
        NotificationCustomRelativePointOfTime
        )
        )
    {
        $Param{Data}->{$PossibleParam} ||= '';
    }

    # special check for relative unit count as it can be zero
    # (empty and negative values will be treated as zero to avoid errors)
    if (
        !IsNumber( $Param{Data}->{NotificationCustomRelativeUnitCount} )
        || $Param{Data}->{NotificationCustomRelativeUnitCount} <= 0
        )
    {
        $Param{Data}->{NotificationCustomRelativeUnitCount} = 0;
    }

    # set empty datetime strings to undef
    for my $PossibleParam (qw(NotificationDate NotificationCustomDateTime)) {
        $Param{Data}->{$PossibleParam} ||= undef;
    }

    return if !$Param{Data}->{NotificationTemplate};

    #
    # template Start
    #
    if ( $Param{Data}->{NotificationTemplate} eq 'Start' ) {

        # setup the appointment start date as notification date
        $Param{Data}->{NotificationDate} = $Param{Data}->{StartTime};
    }

    #
    # template time before start
    #
    elsif (
        $Param{Data}->{NotificationTemplate} ne 'Custom'
        && IsNumber( $Param{Data}->{NotificationTemplate} )
        && $Param{Data}->{NotificationTemplate} > 0
        )
    {

        return if !IsNumber( $Param{Data}->{NotificationTemplate} );

        # offset template (before start datetime) used
        my $Offset = $Param{Data}->{NotificationTemplate};

        # Get date time object of appointment start time.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Data}->{StartTime},
            },
        );

        # Subtract offset in seconds for new notification date time.
        $StartTimeObject->Subtract(
            Seconds => $Offset,
        );

        $Param{Data}->{NotificationDate} = $StartTimeObject->ToString();
    }

    #
    # template Custom
    #
    else {

        # Compute date of custom relative input.
        if ( $Param{Data}->{NotificationCustom} eq 'relative' ) {

            my $CustomUnitCount = $Param{Data}->{NotificationCustomRelativeUnitCount};
            my $CustomUnit      = $Param{Data}->{NotificationCustomRelativeUnit};
            my $CustomUnitPoint = $Param{Data}->{NotificationCustomRelativePointOfTime};

            # setup the count to compute for the offset
            my %UnitOffsetCompute = (
                minutes => 60,
                hours   => 3600,
                days    => 86400,
            );

            my $NotificationLocalTimeObject;

            # Compute from start time.
            if ( $CustomUnitPoint eq 'beforestart' || $CustomUnitPoint eq 'afterstart' ) {
                $NotificationLocalTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $Param{Data}->{StartTime},
                    },
                );
            }

            # Compute from end time.
            elsif ( $CustomUnitPoint eq 'beforeend' || $CustomUnitPoint eq 'afterend' ) {
                $NotificationLocalTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $Param{Data}->{EndTime},
                    },
                );
            }

            # Not supported point of time.
            else {
                return;
            }

            # compute the offset to be used
            my $Offset = ( $CustomUnitCount * $UnitOffsetCompute{$CustomUnit} );

            # save the newly computed notification datetime string
            if ( $CustomUnitPoint eq 'beforestart' || $CustomUnitPoint eq 'beforeend' ) {
                $NotificationLocalTimeObject->Subtract(
                    Seconds => $Offset,
                );
                $Param{Data}->{NotificationDate} = $NotificationLocalTimeObject->ToString();
            }
            else {
                $NotificationLocalTimeObject->Add(
                    Seconds => $Offset,
                );
                $Param{Data}->{NotificationDate} = $NotificationLocalTimeObject->ToString();
            }
        }

        # Compute date of custom date/time input.
        elsif ( $Param{Data}->{NotificationCustom} eq 'datetime' ) {

            $Param{Data}->{NotificationCustom} = 'datetime';

            # validation
            if ( !IsStringWithData( $Param{Data}->{NotificationCustomDateTime} ) ) {
                return;
            }

            # save the given date time values as notification datetime string (i.e. 2016-06-28 02:00:00)
            $Param{Data}->{NotificationDate} = $Param{Data}->{NotificationCustomDateTime};
        }
    }

    if ( !IsStringWithData( $Param{Data}->{NotificationDate} ) ) {
        $Param{Data}->{NotificationDate} = undef;
    }

    if ( !IsStringWithData( $Param{Data}->{NotificationCustomDateTime} ) ) {
        $Param{Data}->{NotificationCustomDateTime} = undef;
    }

    return 1;
}

=head2 AppointmentNotification()

Will be triggered by the OTRS daemon to fire events for appointments,
that reaches it's reminder (notification) time.

    my $Success = $AppointmentObject->AppointmentNotification();

returns:

    True if notify action was successful, otherwise false.

=cut

sub AppointmentNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(NotifyTime)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get appointments for the related notification timestamp
    my @UpcomingAppointments = $Self->AppointmentUpcomingGet(
        Timestamp => $Param{NotifyTime},
    );

    return if !IsArrayRefWithData( \@UpcomingAppointments );

    # sleep at least 1 second to make sure the timestamp doesn't
    # equals the last one for update upcoming future tasks
    sleep 1;

    UPCOMINGAPPOINTMENT:
    for my $UpcomingAppointment (@UpcomingAppointments) {

        next UPCOMINGAPPOINTMENT if !$UpcomingAppointment;
        next UPCOMINGAPPOINTMENT if !IsHashRefWithData($UpcomingAppointment);
        next UPCOMINGAPPOINTMENT if !$UpcomingAppointment->{AppointmentID};

        # fire event
        $Self->EventHandler(
            Event => 'AppointmentNotification',
            Data  => {
                AppointmentID => $UpcomingAppointment->{AppointmentID},
                CalendarID    => $UpcomingAppointment->{CaledarID},
            },
            UserID => 1,
        );
    }

    return 1;
}

=begin Internal:

=cut

sub _AppointmentRecurringCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ParentID Appointment)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $StartTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{Appointment}->{StartTime},
        },
    );
    my $EndTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{Appointment}->{EndTime},
        },
    );

    my @RecurrenceExclude = @{ $Param{Appointment}->{RecurrenceExclude} // [] };

    # remove undefined values
    @RecurrenceExclude = grep { defined $_ } @RecurrenceExclude;

    # reset the parameter for occurrences
    $Param{Appointment}->{RecurrenceExclude} = undef;

    my $OriginalStartTimeObject = $StartTimeObject->Clone();
    my $OriginalEndTimeObject   = $EndTimeObject->Clone();
    my $Step                    = 0;

    # until ...
    if ( $Param{Appointment}->{RecurrenceUntil} ) {
        my $RecurrenceUntilObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Appointment}->{RecurrenceUntil},
            },
        );

        UNTIL_TIME:
        while ( $StartTimeObject <= $RecurrenceUntilObject ) {
            $Step += $Param{Appointment}->{RecurrenceInterval};

            # calculate recurring times
            $StartTimeObject = $Self->_CalculateRecurrenceTime(
                Appointment  => $Param{Appointment},
                Step         => $Step,
                OriginalTime => $OriginalStartTimeObject,
                CurrentTime  => $StartTimeObject,
            );

            last UNTIL_TIME if !$StartTimeObject;
            last UNTIL_TIME if $StartTimeObject > $RecurrenceUntilObject;

            $EndTimeObject = $StartTimeObject->Clone();
            $EndTimeObject->Add(
                Seconds =>
                    $OriginalEndTimeObject->Delta( DateTimeObject => $OriginalStartTimeObject )->{AbsoluteSeconds},
            );

            my $StartTime = $StartTimeObject->ToString();
            my $EndTime   = $EndTimeObject->ToString();

            # Bugfix: on some systems with older perl version system might calculate timezone difference.
            $StartTime = $Self->_TimeCheck(
                OriginalTime => $Param{Appointment}->{StartTime},
                Time         => $StartTime,
            );
            $EndTime = $Self->_TimeCheck(
                OriginalTime => $Param{Appointment}->{EndTime},
                Time         => $EndTime,
            );

            # skip excluded appointments
            next UNTIL_TIME if grep { $StartTime eq $_ } @RecurrenceExclude;

            $Self->AppointmentCreate(
                %{ $Param{Appointment} },
                ParentID     => $Param{ParentID},
                StartTime    => $StartTime,
                EndTime      => $EndTime,
                RecurrenceID => $StartTime,
            );
        }
    }

    # for ... time(s)
    elsif ( $Param{Appointment}->{RecurrenceCount} ) {

        COUNT:
        for ( 1 .. $Param{Appointment}->{RecurrenceCount} - 1 ) {
            $Step += $Param{Appointment}->{RecurrenceInterval};

            # calculate recurring times
            $StartTimeObject = $Self->_CalculateRecurrenceTime(
                Appointment  => $Param{Appointment},
                Step         => $Step,
                OriginalTime => $OriginalStartTimeObject,
                CurrentTime  => $StartTimeObject,
            );

            last COUNT if !$StartTimeObject;

            $EndTimeObject = $StartTimeObject->Clone();
            $EndTimeObject->Add(
                Seconds =>
                    $OriginalEndTimeObject->Delta( DateTimeObject => $OriginalStartTimeObject )->{AbsoluteSeconds},
            );

            my $StartTime = $StartTimeObject->ToString();
            my $EndTime   = $EndTimeObject->ToString();

            # Bugfix: on some systems with older perl version system might calculate timezone difference.
            $StartTime = $Self->_TimeCheck(
                OriginalTime => $Param{Appointment}->{StartTime},
                Time         => $StartTime,
            );
            $EndTime = $Self->_TimeCheck(
                OriginalTime => $Param{Appointment}->{EndTime},
                Time         => $EndTime,
            );

            # skip excluded appointments
            next COUNT if grep { $StartTime eq $_ } @RecurrenceExclude;

            $Self->AppointmentCreate(
                %{ $Param{Appointment} },
                ParentID     => $Param{ParentID},
                StartTime    => $StartTime,
                EndTime      => $EndTime,
                RecurrenceID => $StartTime,
            );
        }
    }

    return 1;
}

sub _AppointmentRecurringDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ParentID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # delete recurring appointments
    my $SQL = '
        DELETE FROM calendar_appointment
        WHERE parent_id=?
    ';

    # delete db record
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => [
            \$Param{ParentID},
        ],
    );

    return 1;
}

sub _AppointmentRecurringExclude {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ParentID RecurrenceID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');

    # db query
    return if !$DBObject->Prepare(
        SQL  => 'SELECT recur_exclude FROM calendar_appointment WHERE id=?',
        Bind => [ \$Param{ParentID} ],
    );

    # get existing exclusions
    my @RecurrenceExclude;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        @RecurrenceExclude = split( ',', $Row[0] ) if $Row[0];
    }
    push @RecurrenceExclude, $Param{RecurrenceID};
    @RecurrenceExclude = sort @RecurrenceExclude;

    # join into string
    my $RecurrenceExclude;
    if (@RecurrenceExclude) {
        $RecurrenceExclude = join( ',', @RecurrenceExclude );
    }

    # update db record
    return if !$DBObject->Do(
        SQL  => 'UPDATE calendar_appointment SET recur_exclude=? WHERE id=?',
        Bind => [ \$RecurrenceExclude, \$Param{ParentID} ],
    );

    # delete cache
    $CacheObject->Delete(
        Type => $Self->{CacheType},
        Key  => $Param{ParentID},
    );

    return 1;
}

sub _AppointmentGetCalendarID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # sql query
    my $SQL  = 'SELECT calendar_id FROM calendar_appointment WHERE id=?';
    my @Bind = ( \$Param{AppointmentID} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # start query
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my $CalendarID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CalendarID = $Row[0];
    }

    return $CalendarID;
}

sub _AppointmentGetRecurrenceID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # sql query
    my $SQL  = 'SELECT recur_id FROM calendar_appointment WHERE id=?';
    my @Bind = ( \$Param{AppointmentID} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # start query
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my $RecurrenceID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $RecurrenceID = $Row[0];
    }

    return $RecurrenceID;
}

sub _CalculateRecurrenceTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Appointment Step OriginalTime CurrentTime)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $OriginalTimeObject = $Param{OriginalTime};

    # We will modify this object throughout the function.
    my $CurrentTimeObject = $Param{CurrentTime};

    if ( $Param{Appointment}->{RecurrenceType} eq 'Daily' ) {

        # Add one day.
        $CurrentTimeObject->Add(
            Days => 1,
        );
    }
    elsif ( $Param{Appointment}->{RecurrenceType} eq 'Weekly' ) {

        # Add 7 days.
        $CurrentTimeObject->Add(
            Days => 7,
        );
    }
    elsif ( $Param{Appointment}->{RecurrenceType} eq 'Monthly' ) {
        my $TempTimeObject = $OriginalTimeObject->Clone();

        # Remember start day.
        my $StartDay = $TempTimeObject->Get()->{Day};

        # Add months based on current step.
        $TempTimeObject->Add(
            Months => $Param{Step},
        );

        # Get end day.
        my $EndDay = $TempTimeObject->Get()->{Day};

        # Check if month doesn't have enough days (for example: January 31 + 1 month = March 1).
        if ( $StartDay != $EndDay ) {
            $TempTimeObject->Subtract(
                Days => $EndDay,
            );
        }

        $CurrentTimeObject = $TempTimeObject->Clone();
    }
    elsif ( $Param{Appointment}->{RecurrenceType} eq 'Yearly' ) {
        my $TempTimeObject = $OriginalTimeObject->Clone();

        # Remember start day.
        my $StartDay = $TempTimeObject->Get()->{Day};

        # Add years based on current step.
        $TempTimeObject->Add(
            Years => $Param{Step},
        );

        # Get end day.
        my $EndDay = $TempTimeObject->Get()->{Day};

        # Check if month doesn't have enough days (for example: January 31 + 1 month = March 1).
        if ( $StartDay != $EndDay ) {
            $TempTimeObject->Subtract(
                Days => $EndDay,
            );
        }

        $CurrentTimeObject = $TempTimeObject->Clone();
    }
    elsif ( $Param{Appointment}->{RecurrenceType} eq 'CustomDaily' ) {

        # Add number of days.
        $CurrentTimeObject->Add(
            Days => $Param{Appointment}->{RecurrenceInterval},
        );
    }
    elsif ( $Param{Appointment}->{RecurrenceType} eq 'CustomWeekly' ) {

        # this block covers following use case:
        # each n-th Monday and Friday

        my $Found;

        # loop up to 7*n times (7 days in week * frequency)
        LOOP:
        for ( my $Counter = 0; $Counter < 7 * $Param{Appointment}->{RecurrenceInterval}; $Counter++ ) {

            # Add one day.
            $CurrentTimeObject->Add(
                Days => 1,
            );

            my $CWDiff = $Self->_CWDiff(
                CurrentTime  => $CurrentTimeObject,
                OriginalTime => $OriginalTimeObject,
            );

            next LOOP if $CWDiff % $Param{Appointment}->{RecurrenceInterval};

            my $WeekDay = $CurrentTimeObject->Get()->{DayOfWeek};

            # check if SystemTime match requirements
            if ( grep { $WeekDay == $_ } @{ $Param{Appointment}->{RecurrenceFrequency} } ) {
                $Found = 1;
                last LOOP;
            }
        }

        return if !$Found;
    }

    elsif ( $Param{Appointment}->{RecurrenceType} eq 'CustomMonthly' ) {

        # Occurs every 2nd month on 5th, 10th and 15th day
        my $Found;

        # loop through each day (max one year), and check if day matches.
        DAY:
        for ( my $Counter = 0; $Counter < 31 * 366; $Counter++ ) {

            # Add one day.
            $CurrentTimeObject->Add(
                Days => 1,
            );

            # Skip month if needed
            next DAY
                if ( $CurrentTimeObject->Get()->{Month} - $OriginalTimeObject->Get()->{Month} )
                % $Param{Appointment}->{RecurrenceInterval};

            # next day if this day should be skipped
            next DAY
                if !grep { $CurrentTimeObject->Get()->{Day} == $_ } @{ $Param{Appointment}->{RecurrenceFrequency} };

            $Found = 1;
            last DAY;
        }
        return if !$Found;
    }
    elsif ( $Param{Appointment}->{RecurrenceType} eq 'CustomYearly' ) {

        # this block covers following use case:
        # Occurs each 3th year, January 18th and March 18th
        my $Found;

        my $RecurrenceUntilObject;
        if ( $Param{Appointment}->{RecurrenceUntil} ) {
            $RecurrenceUntilObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Param{Appointment}->{RecurrenceUntil},
                },
            );
        }

        my $NextDayObject = $CurrentTimeObject->Clone();
        $NextDayObject->Add(
            Days => 1,
        );

        MONTH:
        for ( my $Counter = 1;; $Counter++ ) {
            my $TempTimeObject = $OriginalTimeObject->Clone();

            # remember start day
            my $StartDay = $TempTimeObject->Get()->{Day};

            $TempTimeObject->Add(
                Months => $Counter,
            );

            # get end day
            my $EndDay = $TempTimeObject->Get()->{Day};

            # check if month doesn't have enough days (for example: january 31 + 1 month = march 01)
            if ( $StartDay != $EndDay ) {
                $TempTimeObject->Subtract(
                    Days => $EndDay,
                );
            }

            $CurrentTimeObject = $TempTimeObject->Clone();

            # skip this time, since it was already checked
            next MONTH if $CurrentTimeObject < $NextDayObject;

            # check loop conditions (according to Until / )
            if ($RecurrenceUntilObject) {
                last MONTH if $CurrentTimeObject > $RecurrenceUntilObject;
            }
            else {
                last MONTH
                    if $Counter
                    > 12 * $Param{Appointment}->{RecurrenceInterval} * $Param{Appointment}->{RecurrenceCount};
            }

            # check if year is OK
            next MONTH
                if ( $CurrentTimeObject->Get()->{Year} - $OriginalTimeObject->Get()->{Year} )
                % $Param{Appointment}->{RecurrenceInterval};

            # next month if this month should be skipped
            next MONTH
                if !grep { $CurrentTimeObject->Get()->{Month} == $_ } @{ $Param{Appointment}->{RecurrenceFrequency} };

            $Found = 1;
            last MONTH;
        }
        return if !$Found;
    }
    else {
        return;
    }

    return $CurrentTimeObject;
}

=head2 _TimeCheck()

Check if Time and OriginalTime have same hour, minute and second value, and return timestamp with
values (hour, minute and second) as in Time.

    my $Result = $Self->_TimeCheck(
        OriginalTime => '2016-01-01 00:01:00',     # (required)
        Time         => '2016-02-01 00:02:00',     # (required)
    );

Returns:
    $Result = '2016-02-01 00:01:00';

=cut

sub _TimeCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(OriginalTime Time)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Result = '';

    $Param{OriginalTime} =~ /(.*?)\s(.*?)$/;
    my $OriginalDate = $1;
    my $OriginalTime = $2;

    $Param{Time} =~ /(.*?)\s(.*?)$/;
    my $Date = $1;

    $Result = "$Date $OriginalTime";
    return $Result;
}

=head2 _CWDiff()

Returns how many calendar weeks has passed between two unix times.

    my $CWDiff = $Self->_CWDiff(
        CurrentTime  => $CurrentTimeObject,     (required) Date time object with current time
        OriginalTime => $OriginalTimeObject,    (required) Date time object with original time
    );

returns:
    $CWDiff = 5;

=cut

sub _CWDiff {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(CurrentTime OriginalTime)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $OriginalTimeObject = $Param{OriginalTime};
    my $CurrentTimeObject  = $Param{CurrentTime};

    my $StartYear = $OriginalTimeObject->Get()->{Year};
    my $EndYear   = $CurrentTimeObject->Get()->{Year};

    my $Result = $CurrentTimeObject->{CPANDateTimeObject}->week_number()
        - $OriginalTimeObject->{CPANDateTimeObject}->week_number();

    # If date is end of the year and date CW starts with 1, we need to include additional year.
    if ( $Result < 0 && $CurrentTimeObject->Get()->{Day} == 31 && $CurrentTimeObject->Get()->{Month} == 12 ) {
        $EndYear++;
    }

    for my $Year ( $StartYear .. $EndYear - 1 ) {
        my $CW  = 0;
        my $Day = 31;

        while ( $CW < 50 ) {

            # To get how many CW's are in this year, we set temporary date to 31-dec.
            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => "$Year-12-$Day 23:59:00",
                },
            );

            $CW = $DateTimeObject->{CPANDateTimeObject}->week_number();
            $Day--;
        }

        $Result += $CW;
    }

    return $Result;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
