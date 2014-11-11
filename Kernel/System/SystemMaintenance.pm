# --
# Kernel/System/SystemMaintenance/DB/SystemMaintenance.pm - SystemMaintenance backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SystemMaintenance;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::SystemMaintenance.pm

=head1 SYNOPSIS

SystemMaintenance backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a SystemMaintenance object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item SystemMaintenanceAdd()

add new SystemMaintenance

returns the id of the created SystemMaintenance if success or undef otherwise

    my $ID = $SystemMaintenance->SystemMaintenanceAdd(
        StartDate        => '2014-05-02 14:55:00'    # mandatory
        StopDate         => '2014-05-02 16:01:00'    # mandatory
        Comment          => 'Comment',               # mandatory
        LoginMessage     => 'A login message.',      # optional
        ShowLoginMessage => 1,                       # optional
        NotifyMessage    => 'Notification message.', # optional
        ValidID          => 1,                       # mandatory
        UserID           => 123,                     # mandatory
    );

Returns:

    $ID = 567;

=cut

sub SystemMaintenanceAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(StartDate StopDate Comment ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # date start shouldn't be higher than stop date
    return if ( $Param{StartDate} > $Param{StopDate} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO system_maintenance ( start_date, stop_date, comments, login_message,
                show_login_message, notify_message, valid_id, create_time, create_by, change_time, change_by )
            VALUES (?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{StartDate}, \$Param{StopDate}, \$Param{Comment}, \$Param{LoginMessage},
            \$Param{ShowLoginMessage}, \$Param{NotifyMessage}, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL => '
            SELECT id FROM system_maintenance
            WHERE start_date = ? and stop_date = ? and comments = ?
        ',
        Bind => [
            \$Param{StartDate}, \$Param{StopDate}, \$Param{Comment},
        ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # return undef if not correct result
    return if !$ID;

    return $ID;
}

=item SystemMaintenanceDelete()

delete an SystemMaintenance

returns 1 if success or undef otherwise

    my $Success = $SystemMaintenanceObject->SystemMaintenanceDelete(
        ID     => 123,
        UserID => 123,
    );

=cut

sub SystemMaintenanceDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check if exists
    my $SystemMaintenance = $Self->SystemMaintenanceGet(
        ID     => $Param{ID},
        UserID => 1,
    );

    return if !IsHashRefWithData($SystemMaintenance);

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete SystemMaintenance
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM system_maintenance WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    return 1;
}

=item SystemMaintenanceGet()

get SystemMaintenance attributes

    my $SystemMaintenance = $SystemMaintenanceObject->SystemMaintenanceGet(
        ID     => 123,          # ID or name is needed
        UserID => 123,          # mandatory
    );

Returns:

    $SystemMaintenance = {
        ID             => 123,
        StartDate        => '2014-05-02 14:55:00',
        StopDate         => '2014-05-02 16:01:00',
        Comment          => 'Comment',
        LoginMessage     => 'A login message.',
        ShowLoginMessage => 1,
        NotifyMessage    => 'Notification message.',
        ValidID          => 1,
        CreateTime       => '2012-07-04 15:08:00',
        ChangeTime       => '2012-07-04 15:08:00',
        CreateBy         => 'user_login',
        ChangeBy         => 'user_login',
    };

=cut

sub SystemMaintenanceGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, start_date, stop_date, comments, login_message,
                show_login_message, notify_message, valid_id, create_time,
                change_time, create_by, change_by
            FROM system_maintenance
            WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        %Data = (
            ID               => $Row[0],
            StartDate        => $Row[1],
            StopDate         => $Row[2],
            Comment          => $Row[3],
            LoginMessage     => $Row[4],
            ShowLoginMessage => $Row[5],
            NotifyMessage    => $Row[6],
            ValidID          => $Row[7],
            CreateTime       => $Row[8],
            ChangeTime       => $Row[9],
            CreateBy         => $Row[10],
            ChangeBy         => $Row[11],
        );
    }

    return if !$Data{ID};

    return \%Data;
}

=item SystemMaintenanceUpdate()

update SystemMaintenance attributes

returns 1 if success or undef otherwise

    my $Success = $SystemMaintenanceObject->SystemMaintenanceUpdate(
        ID               => 123,                        # mandatory
        StartData        => 'NameOfSystemMaintenance',  # mandatory
        StopDate         => 'NameOfSystemMaintenance',  # mandatory
        Comment          => 'Comment',                  # mandatory
        LoginMessage     => 'Description',              # optional
        ShowLoginMessage => 1,                          # optional
        NotifyMessage    => 'Notification for showing', # optional
        ValidID          => 'ValidID',                  # mandatory
        UserID           => 123,                        # mandatory
    );

=cut

sub SystemMaintenanceUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID StartDate StopDate Comment ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # date start shouldn't be higher than stop date
    return if ( $Param{StartDate} > $Param{StopDate} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Do(
        SQL => '
            UPDATE system_maintenance
            SET start_date = ?, stop_date = ?, comments = ?, login_message = ?, show_login_message = ?,
                notify_message = ?, valid_id = ?, change_time = current_timestamp,  change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{StartDate}, \$Param{StopDate}, \$Param{Comment}, \$Param{LoginMessage},
            \$Param{ShowLoginMessage}, \$Param{NotifyMessage},
            \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    return 1;
}

=item SystemMaintenanceList()

get an SystemMaintenance list

    my $List = $SystemMaintenanceObject->SystemMaintenanceList(
        ValidIDs => ['1','2'],           # optional, to filter SystemMaintenances that match listed valid IDs
        UserID   => 1,
    );

    Returns:

    $List = {
        1 => 'NameOfSystemMaintenance',
    }

=cut

sub SystemMaintenanceList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    my $ValidIDsStrg;
    if ( !IsArrayRefWithData( $Param{ValidIDs} ) ) {
        $ValidIDsStrg = 'ALL';
    }
    else {
        $ValidIDsStrg = join ',', @{ $Param{ValidIDs} };
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
            SELECT id
            FROM system_maintenance ';

    if ( $ValidIDsStrg ne 'ALL' ) {

        my $ValidIDsStrgDB = join ',', map { $DBObject->Quote( $_, 'Integer' ) }
            @{ $Param{ValidIDs} };

        $SQL .= "WHERE valid_id IN ($ValidIDsStrgDB)";
    }

    return if !$DBObject->Prepare( SQL => $SQL );
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = '1';
    }

    return \%Data;
}

=item SystemMaintenanceListGet()

get an SystemMaintenance list with all SystemMaintenance details

    my $List = $SystemMaintenanceObject->SystemMaintenanceListGet(
        UserID   => 1,
        ValidIDs => ['1','2'], # optional, to filter SystemMaintenances that match listed valid IDs
    );

Returns:

    $List = [
        {
            ID               => 123,
            StartDate        => '2013-07-04 15:08:00',
            StopDate         => '2013-07-06 16:08:00',
            Comment          => 'Comment',
            LoginMessage     => 'The message',
            ShowLoginMessage => 1,
            NotifyMessage    => 'The notification',
            ValidID          => 1,
            CreateTime       => '2012-07-04 15:08:00',
            ChangeTime       => '2012-07-04 15:08:00',
        },
        {
            ID               => 123,
            StartDate        => '2013-07-04 15:08:00',
            StopDate         => '2013-07-06 16:08:00',
            Comment          => 'Other Comment',
            LoginMessage     => 'To be shown on the login screen.',
            ShowLoginMessage => 0,
            NotifyMessage    => 'A different notification',
            ValidID          => 1,
            CreateTime       => '2012-07-04 15:08:00',
            ChangeTime       => '2012-07-04 15:08:00',
        },
    ];

=cut

sub SystemMaintenanceListGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    my $SystemMaintenanceData = $Self->SystemMaintenanceList(
        %Param,
    );

    my @SystemMaintenanceIDs = sort keys %{$SystemMaintenanceData};

    my @Data;
    for my $ItemID (@SystemMaintenanceIDs) {

        my $SystemMaintenanceData = $Self->SystemMaintenanceGet(
            ID     => $ItemID,
            UserID => 1,
        );
        push @Data, $SystemMaintenanceData;
    }

    return \@Data;
}

=item SystemMaintenanceIsActive()

get a SystemMaintenance active flag

    my $ActiveMaintenance = $SystemMaintenanceObject->SystemMaintenanceIsActive();

    Returns:

    $ActiveMaintenance = 7 # a System Maintenance ID

=cut

sub SystemMaintenanceIsActive {
    my ( $Self, %Param ) = @_;

    my $SystemTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = "
            SELECT id
            FROM system_maintenance
            WHERE start_date <= $SystemTime and stop_date >= $SystemTime
    ";

    my @ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
    if ( scalar @ValidList ) {

        my $ValidIDsStrgDB = join ',', map { $DBObject->Quote( $_, 'Integer' ) } @ValidList;

        $SQL .= " AND valid_id IN ($ValidIDsStrgDB)";
    }
    $SQL .= ' ORDER BY id';

    return if !$DBObject->Prepare( SQL => $SQL );

    my $Result;
    RESULT:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = $Row[0];
        last RESULT;
    }

    return if !$Result;

    return $Result;
}

=item SystemMaintenanceIsComming()

get a SystemMaintenance flag

    my $SystemMaintenanceIsComming = $SystemMaintenanceObject->SystemMaintenanceIsComming();

    Returns:

    $SystemMaintenanceIsComming = 1 # 1 or 0

=cut

sub SystemMaintenanceIsComming {
    my ( $Self, %Param ) = @_;

    my $SystemTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
    my $NotifiBeforeTime =
        $Kernel::OM->Get('Kernel::Config')->Get('SystemMaintenance::TimeNotifyUpcomingMaintenance')
        || 30;
    my $TargetTime = $SystemTime + ( $NotifiBeforeTime * 60 );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = "
            SELECT start_date
            FROM system_maintenance
            WHERE start_date > $SystemTime and start_date <= $TargetTime
    ";

    my @ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
    if ( scalar @ValidList ) {

        my $ValidIDsStrgDB = join ',', map { $DBObject->Quote( $_, 'Integer' ) } @ValidList;

        $SQL .= " AND valid_id IN ($ValidIDsStrgDB)";
    }
    $SQL .= ' ORDER BY id';

    return if !$DBObject->Prepare( SQL => $SQL );

    my $Result;
    RESULT:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = $Row[0];
        last RESULT;
    }

    return if !$Result;

    return $Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
