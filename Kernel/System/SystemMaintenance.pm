# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    'Kernel::System::DateTime',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::SystemMaintenance

=head1 DESCRIPTION

SystemMaintenance backend

=head1 PUBLIC INTERFACE

=head2 new()

create a SystemMaintenance object. Do not use it directly, instead use:

    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 SystemMaintenanceAdd()

add new SystemMaintenance

returns the id of the created SystemMaintenance if success or undef otherwise

    my $ID = $SystemMaintenance->SystemMaintenanceAdd(
        StartDate        => 1485346000               # mandatory
        StopDate         => 1485349600               # mandatory
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

    # Database columns for LoginMessage and NotifyMessage in system_maintenance are limited to 250 characters.
    return if $Param{LoginMessage}  && length $Param{LoginMessage} > 250;
    return if $Param{NotifyMessage} && length $Param{NotifyMessage} > 250;

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

=head2 SystemMaintenanceDelete()

delete a SystemMaintenance

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

=head2 SystemMaintenanceGet()

get SystemMaintenance attributes

    my $SystemMaintenance = $SystemMaintenanceObject->SystemMaintenanceGet(
        ID     => 123,          # mandatory
        UserID => 123,          # mandatory
    );

Returns:

    $SystemMaintenance = {
        ID             => 123,
        StartDate        => 1485346000,
        StopDate         => 1485349600,
        Comment          => 'Comment',
        LoginMessage     => 'A login message.',
        ShowLoginMessage => 1,
        NotifyMessage    => 'Notification message.',
        ValidID          => 1,
        CreateTime       => 1485346000,
        ChangeTime       => 1485347300,
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

=head2 SystemMaintenanceUpdate()

update SystemMaintenance attributes

returns 1 if success or undef otherwise

    my $Success = $SystemMaintenanceObject->SystemMaintenanceUpdate(
        ID               => 123,                        # mandatory
        StartDate        => 1485346000,                 # mandatory
        StopDate         => 1485349600,                 # mandatory
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

    # Database columns for LoginMessage and NotifyMessage in system_maintenance table are limited to 250 characters.
    return if $Param{LoginMessage}  && length $Param{LoginMessage} > 250;
    return if $Param{NotifyMessage} && length $Param{NotifyMessage} > 250;

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

=head2 SystemMaintenanceList()

get an SystemMaintenance list

    my $List = $SystemMaintenanceObject->SystemMaintenanceList(
        ValidIDs => ['1','2'],           # optional, to filter SystemMaintenances that match listed valid IDs
        UserID   => 1,
    );

Returns a hash with the SystemMaintenance IDs as keys:

    $List = {
        42 => 1,
        24 => 1,
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

=head2 SystemMaintenanceListGet()

get an SystemMaintenance list with all SystemMaintenance details

    my $List = $SystemMaintenanceObject->SystemMaintenanceListGet(
        UserID   => 1,
        ValidIDs => ['1','2'], # optional, to filter SystemMaintenances that match listed valid IDs
    );

Returns:

    $List = [
        {
            ID               => 123,
            StartDate        => 1485346000,
            StopDate         => 1485349600,
            Comment          => 'Comment',
            LoginMessage     => 'The message',
            ShowLoginMessage => 1,
            NotifyMessage    => 'The notification',
            ValidID          => 1,
            CreateTime       => 1485342400,
            ChangeTime       => 1485343700,
        },
        {
            ID               => 123,
            StartDate        => 1485346000,
            StopDate         => 1485349600,
            Comment          => 'Other Comment',
            LoginMessage     => 'To be shown on the login screen.',
            ShowLoginMessage => 0,
            NotifyMessage    => 'A different notification',
            ValidID          => 1,
            CreateTime       => 1485342400,
            ChangeTime       => 1485343700,
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

    # sort list by start date
    @Data = sort { $a->{StartDate} <=> $b->{StartDate} } @Data;

    return \@Data;
}

=head2 SystemMaintenanceIsActive()

get a SystemMaintenance active flag

    my $ActiveMaintenance = $SystemMaintenanceObject->SystemMaintenanceIsActive();

Returns:

    $ActiveMaintenance = 7 # a System Maintenance ID

=cut

sub SystemMaintenanceIsActive {
    my ( $Self, %Param ) = @_;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTime     = $DateTimeObject->ToEpoch();

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

=head2 SystemMaintenanceIsComing()

Get a upcoming SystemMaintenance start and stop date.

    my %SystemMaintenanceIsComing = $SystemMaintenanceObject->SystemMaintenanceIsComing();

Returns:

    %SystemMaintenanceIsComing = {
        StartDate => 1515614400,
        StopDate  => 1515607200
    };

=cut

sub SystemMaintenanceIsComing {
    my ( $Self, %Param ) = @_;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTime     = $DateTimeObject->ToEpoch();

    my $NotifiBeforeTime =
        $Kernel::OM->Get('Kernel::Config')->Get('SystemMaintenance::TimeNotifyUpcomingMaintenance')
        || 30;
    $DateTimeObject->Add( Minutes => $NotifiBeforeTime );
    my $TargetTime = $DateTimeObject->ToEpoch();

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = "
            SELECT start_date, stop_date
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

    my %Result;
    RESULT:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{StartDate} = $Row[0];
        $Result{StopDate}  = $Row[1];
        last RESULT;
    }

    return if !%Result;

    return %Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
