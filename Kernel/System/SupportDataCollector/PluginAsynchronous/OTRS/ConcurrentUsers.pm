# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::PluginAsynchronous::OTRS::ConcurrentUsers;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginAsynchronous);

use Date::Pcalc qw(Add_Delta_YMD Add_Delta_DHMS);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::SystemData',
    'Kernel::System::Time',
);

sub GetDisplayPath {
    return
        'OTRS@Table:TimeStamp,UserSessionUnique|Unique agents,UserSession|Agent sessions,CustomerSessionUnique|Unique customers,CustomerSession|Customer sessions';
}

sub Run {
    my $Self = shift;

    my $ConcurrentUsers = $Self->_GetAsynchronousData();

    # the table details data
    $Self->AddResultInformation(
        Label => 'Concurrent Users Details',
        Value => $ConcurrentUsers || [],
    );

    # get the full display path
    my $DisplayPathFull = $Self->GetDisplayPath();

    # get the display path, display type and additional information for the output
    my ( $DisplayPath, $DisplayType, $DisplayAdditional ) = split( m{[\@\:]}, $DisplayPathFull // '' );

    # get the table columns (possible with label)
    my @TableColumns = split( m{,}, $DisplayAdditional // '' );

    COLUMN:
    for my $Column (@TableColumns) {

        next COLUMN if !$Column;

        # get the identifier and label
        my ( $Identifier, $Label ) = split( m{\|}, $Column );

        # set the identifier as default label
        $Label ||= $Identifier;

        next COLUMN if $Identifier eq 'TimeStamp';

        my $MaxValue = 0;

        ENTRY:
        for my $Entry ( @{$ConcurrentUsers} ) {

            next ENTRY if $Entry->{$Identifier} && $Entry->{$Identifier} <= $MaxValue;

            $MaxValue = $Entry->{$Identifier} || 0;
        }

        $Self->AddResultInformation(
            DisplayPath => 'OTRS/Concurrent Users',
            Identifier  => $Identifier,
            Label       => "Max. $Label",
            Value       => $MaxValue,
        );
    }

    return $Self->GetResults();
}

sub RunAsynchronous {
    my $Self = shift;

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # get system time
    my $SystemTimeNow = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
        SystemTime => $SystemTimeNow + 3600,
    );

    my $SystemTime = $TimeObject->Date2SystemTime(
        Year   => $Year,
        Month  => $Month,
        Day    => $Day,
        Hour   => $Hour,
        Minute => 0,
        Second => 0,
    );

    my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
    );

    my $AsynchronousData = $Self->_GetAsynchronousData();

    my $CurrentHourPosition;

    if ( IsArrayRefWithData($AsynchronousData) ) {

        # already existing entry counter
        my $AsynchronousDataCounter = scalar @{$AsynchronousData} - 1;

        # check if for the current hour already a value exists
        COUNTER:
        for my $Counter ( 0 .. $AsynchronousDataCounter ) {

            next COUNTER
                if $AsynchronousData->[$Counter]->{TimeStamp}
                && $AsynchronousData->[$Counter]->{TimeStamp} ne $TimeStamp;

            $CurrentHourPosition = $Counter;

            last COUNTER;
        }

        # set the check timestamp to one week ago
        my ( $CheckYear, $CheckMonth, $CheckDay ) = Date::Pcalc::Add_Delta_YMD( $Year, $Month, $Day, 0, 0, -7 );

        my $CheckSystemTime = $TimeObject->Date2SystemTime(
            Year   => $CheckYear,
            Month  => $CheckMonth,
            Day    => $CheckDay,
            Hour   => $Hour,
            Minute => 0,
            Second => 0,
        );

        my $CheckTimeStamp = $TimeObject->SystemTime2TimeStamp(
            SystemTime => $CheckSystemTime,
        );

        # remove all entries older than one week
        @{$AsynchronousData} = grep { $_->{TimeStamp} && $_->{TimeStamp} ge $CheckTimeStamp } @{$AsynchronousData};
    }

    # get AuthSession object
    my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # delete the old session ids
    my @Expired = $AuthSessionObject->GetExpiredSessionIDs();
    for ( 0 .. 1 ) {
        for my $SessionID ( @{ $Expired[$_] } ) {
            $AuthSessionObject->RemoveSessionID( SessionID => $SessionID );
        }
    }

    # get the session active time
    my $SessionActiveTime = $Kernel::OM->Get('Kernel::Config')->Get('SessionActiveTime') || 60 * 10;

    # get all sessions
    my @Sessions = $AuthSessionObject->GetAllSessionIDs();

    # to count the agents and customer user sessions
    my %CountConcurrentUser = (
        TimeStamp             => $TimeStamp,
        UserSessionUnique     => 0,
        UserSession           => 0,
        CustomerSession       => 0,
        CustomerSessionUnique => 0,
    );

    # to save the unique agents and customer users
    my %LookupUsers;
    my %LookupCustomers;

    # collect the existing sessions of each user (not customer user)
    SESSION:
    for my $SessionID (@Sessions) {

        # get session data
        my %SessionData = $AuthSessionObject->GetSessionIDData( SessionID => $SessionID );

        next SESSION if !%SessionData;

        # get needed data
        my $UserType        = $SessionData{UserType}        || '';
        my $UserLastRequest = $SessionData{UserLastRequest} || $SystemTimeNow;
        my $UserLogin       = $SessionData{UserLogin};

        next SESSION if $UserType ne 'User' && $UserType ne 'Customer';
        next SESSION if ( $UserLastRequest + $SessionActiveTime ) < $SystemTimeNow;

        $CountConcurrentUser{ $UserType . 'Session' }++;

        if ( $UserType eq 'User' ) {

            if ( !$LookupUsers{$UserLogin} ) {
                $CountConcurrentUser{UserSessionUnique}++;
                $LookupUsers{$UserLogin} = 1;
            }
        }
        elsif ( $UserType eq 'Customer' ) {

            if ( !$LookupCustomers{$UserLogin} ) {
                $CountConcurrentUser{CustomerSessionUnique}++;
                $LookupCustomers{$UserLogin} = 1;
            }
        }
    }

    # update the concurrent user counter, if a higher value for the current hour exists
    if ($CurrentHourPosition) {

        my $ChangedConcurrentUserCounter;

        IDENTIFIER:
        for my $Identifier (qw(UserSessionUnique UserSession CustomerSession CustomerSessionUnique)) {

            next IDENTIFIER
                if $AsynchronousData->[$CurrentHourPosition]->{$Identifier} >= $CountConcurrentUser{$Identifier};

            $AsynchronousData->[$CurrentHourPosition]->{$Identifier} = $CountConcurrentUser{$Identifier};

            $ChangedConcurrentUserCounter = 1;
        }

        return 1 if !$ChangedConcurrentUserCounter;
    }
    else {
        push @{$AsynchronousData}, \%CountConcurrentUser;
    }

    $Self->_StoreAsynchronousData(
        Data => $AsynchronousData,
    );

    return 1;
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
