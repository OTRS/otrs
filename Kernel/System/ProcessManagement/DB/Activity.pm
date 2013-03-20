# --
# Kernel/System/ProcessManagement/Activity.pm - Process Management DB Activity backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Activity;

use strict;
use warnings;

use Kernel::System::YAML;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);

use Kernel::System::ProcessManagement::DB::ActivityDialog;

=head1 NAME

Kernel::System::ProcessManagement::DB::Activity.pm

=head1 SYNOPSIS

Process Management DB Activity backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an Activity object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::ProcessManagement::DB::Activity;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ActivityObject = Kernel::System::ProcessManagement::DB::Activity->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        DBObject            => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject TimeObject MainObject DBObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );
    $Self->{YAMLObject}  = Kernel::System::YAML->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('Process::CacheTTL') || 3600 );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( !$Self->{DBObject}->GetDatabaseFunction('CaseInsensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::DB::ActivityDialog->new( %{$Self} );

    return $Self;
}

=item ActivityAdd()

add new Activity

returns the id of the created activity if success or undef otherwise

    my $ID = $ActivityObject->ActivityAdd(
        EntityID    => 'A1'              # mandatory, exportable unique identifier
        Name        => 'NameOfActivity', # mandatory
        Config      => $ConfigHashRef,   # mandatory, activity configuration to be stored in YAML
                                         #   format
        UserID      => 123,              # mandatory
    );

Returns:

    $ID = 567;

=cut

sub ActivityAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityID Name Config UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check if EntityID already exists
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT id
            FROM pm_activity
            WHERE $Self->{Lower}(entity_id) = $Self->{Lower}(?)",
        Bind  => [ \$Param{EntityID} ],
        Limit => 1,
    );

    my $EntityExists;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $EntityExists = 1;
    }

    if ($EntityExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityID:$Param{EntityID} already exists for an activity!"
        );
        return;
    }

    # check config valid format
    if ( ref $Param{Config} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }

    # dump config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO pm_activity (entity_id, name, config, create_time, create_by, change_time,
                change_by)
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM pm_activity WHERE entity_id = ?',
        Bind => [ \$Param{EntityID} ],
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return if !$ID;

    return $ID;
}

=item ActivityDelete()

delete an Activity

returns 1 if success or undef otherwise

    my $Success = $ActivityObject->ActivityDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub ActivityDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # check if exists
    my $Activity = $Self->ActivityGet(
        ID     => $Param{ID},
        UserID => 1,
    );
    return if !IsHashRefWithData($Activity);

    # delete activity
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM pm_activity WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return 1;
}

=item ActivityGet()

get Activity attributes

    my $Activity = $ActivityObject->ActivityGet(
        ID                  => 123,      # ID or EntityID is needed
        EntityID            => 'A1',
        ActivityDialogNames => 1,        # default 0, 1 || 0, if 0 returns an ActivityDialogs array
                                         #     with the activity dialog entity IDs, if 1 returns an
                                         #     ActivitiDialogs hash with the activity entity IDs as
                                         #     keys and ActivityDialog Names as values
        UserID        => 123,            # mandatory
    );

Returns:

    $Activity = {
        ID             => 123,
        EntityID       => 'A1',
        Name           => 'some name',
        Config         => $ConfigHashRef,
        ActiviyDialogs => ['AD1','AD2','AD3'],
        CreateTime     => '2012-07-04 15:08:00',
        ChangeTime     => '2012-07-04 15:08:00',
    };

    $Activity = {
        ID           => 123,
        EntityID     => 'P1',
        Name         => 'some name',
        Config       => $ConfigHashRef,
        ActivityDialogs => {
            'AD1' => 'ActivityDialog1',
            'AD2' => 'ActivityDialog2',
            'AD3' => 'ActivityDialog3',
        };
        CreateTime   => '2012-07-04 15:08:00',
        ChangeTime   => '2012-07-04 15:08:00',
    };

=cut

sub ActivityGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{EntityID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or EntityID!' );
        return;
    }

    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    my $ActivityDialogNames = 0;
    if ( defined $Param{ActivityDialogNames} && $Param{ActivityDialogNames} == 1 ) {
        $ActivityDialogNames = 1;
    }

    # check cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'ActivityGet::ID::' . $Param{ID} . '::ActivityDialogNames::'
            . $ActivityDialogNames;
    }
    else {
        $CacheKey = 'ActivityGet::EntityID::' . $Param{EntityID} . '::ActivityDialogNames::'
            . $ActivityDialogNames;
    }

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_activity
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_activity
                WHERE entity_id = ?',
            Bind  => [ \$Param{EntityID} ],
            Limit => 1,
        );
    }

    my %Data;

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        my $Config = $Self->{YAMLObject}->Load( Data => $Data[3] );

        %Data = (
            ID         => $Data[0],
            EntityID   => $Data[1],
            Name       => $Data[2],
            Config     => $Config,
            CreateTime => $Data[4],
            ChangeTime => $Data[5],
        );
    }

    return if !$Data{ID};

    # create the ActivityDialogsList
    if ($ActivityDialogNames) {
        my %ActivityDialogs;

        if ( IsHashRefWithData( $Data{Config}->{ActivityDialog} ) ) {

            my $ActivityDialogList = $Self->{ActivityDialogObject}->ActivityDialogList(
                UseEntities => 1,
                UserID      => 1,
            );

            for my $ActivityOrder ( sort { $a <=> $b } keys %{ $Data{Config}->{ActivityDialog} } ) {
                $ActivityDialogs{ $Data{Config}->{ActivityDialog}->{$ActivityOrder} }
                    = $ActivityDialogList->{ $Data{Config}->{ActivityDialog}->{$ActivityOrder} };
            }
        }
        $Data{ActivityDialogs} = \%ActivityDialogs;
    }
    else {
        my @ActivityDialogList;

        if ( IsHashRefWithData( $Data{Config}->{ActivityDialog} ) ) {
            @ActivityDialogList = map { $Data{Config}->{ActivityDialog}->{$_} }
                sort { $a <=> $b } keys %{ $Data{Config}->{ActivityDialog} };
        }
        $Data{ActivityDialogs} = \@ActivityDialogList;
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_Activity',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ActivityUpdate()

update Activity attributes

returns 1 if success or undef otherwise

    my $Success = $ActivityObject->ActivityUpdate(
        ID          => 123,             # mandatory
        EntityID    => 'A1'             # mandatory, exportable unique identifier
        Name        => 'NameOfProcess', # mandatory
        Config      => $ConfigHashRef,  # mandatory, process configuration to be stored in YAML
                                        #   format
        UserID      => 123,             # mandatory
    );

=cut

sub ActivityUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID EntityID Name Config UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if EntityID already exists
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT id FROM pm_activity
            WHERE $Self->{Lower}(entity_id) = $Self->{Lower}(?)
            AND id != ?",
        Bind => [ \$Param{EntityID}, \$Param{ID} ],
        LIMIT => 1,
    );

    my $EntityExists;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $EntityExists = 1;
    }

    if ($EntityExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityID:$Param{Name} already exists for a activity!",
        );
        return;
    }

    # check config valid format
    if ( ref $Param{Config} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }

    # dump config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # check if need to update db
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT entity_id, name, config
            FROM pm_activity
            WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    my $CurrentEntityID;
    my $CurrentName;
    my $CurrentConfig;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $CurrentEntityID = $Data[0];
        $CurrentName     = $Data[1];
        $CurrentConfig   = $Data[2];
    }

    if ($CurrentEntityID) {

        return 1 if $CurrentEntityID eq $Param{EntityID}
            && $CurrentName eq $Param{Name}
            && $CurrentConfig eq $Config;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            UPDATE pm_activity
            SET entity_id = ?, name = ?,  config = ?, change_time = current_timestamp, change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID},
            \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return 1;
}

=item ActivityList()

get an Activity list

    my $List = $ActivityObject->ActivityList(
        UseEntities => 0,                       # default 0, 1 || 0. if 0 the return hash keys are
                                                #    the activity IDs otherwise keys are the
                                                #    activity entity IDs
        UserID      => 1,
    );

    Returns:

    $List = {
        1 => 'Activity1',
    }

    or

    $List = {
        'A1' => 'Activity1',
    }
=cut

sub ActivityList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    # check cache
    my $UseEntities = 0;
    if ( defined $Param{UseEntities} && $Param{UseEntities} ) {
        $UseEntities = 1;
    }
    my $CacheKey = 'ActivityList::UseEntities::' . $UseEntities;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT id, entity_id, name
            FROM pm_activity',
    );

    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( !$UseEntities ) {
            $Data{ $Row[0] } = $Row[2];
        }
        else {
            $Data{ $Row[1] } = $Row[2];
        }
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_Activity',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ActivityListGet()

get an Activity list with all activity details

    my $List = $ActivityObject->ActivityListGet(
        UserID      => 1,
    );

Returns:

    $List = [
        {
            ID             => 123,
            EntityID       => 'A1',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            ActiviyDialogs => ['AD1','AD2','AD3'],
            CreateTime     => '2012-07-04 15:08:00',
            ChangeTime     => '2012-07-04 15:08:00',
        }
        {
            ID             => 456,
            EntityID       => 'A2',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            ActiviyDialogs => ['AD3','AD4','AD5'],
            CreateTime     => '2012-07-04 15:09:00',
            ChangeTime     => '2012-07-04 15:09:00',
        }
    ];

=cut

sub ActivityListGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # check cache
    my $CacheKey = 'ActivityListGet';

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT id, entity_id
            FROM pm_activity
            ORDER BY id',
    );

    my @ActivityIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ActivityIDs, $Row[0];
    }

    my @Data;
    for my $ItemID (@ActivityIDs) {

        my $ActivityData = $Self->ActivityGet(
            ID     => $ItemID,
            UserID => 1,
        );
        push @Data, $ActivityData;
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_Activity',
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return \@Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
