# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ProcessManagement::DB::Activity;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::ProcessManagement::DB::ActivityDialog',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::ProcessManagement::DB::Activity

=head1 DESCRIPTION

Process Management DB Activity backend

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ActivityObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL} = int( $Kernel::OM->Get('Kernel::Config')->Get('Process::CacheTTL') || 3600 );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('CaseSensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    return $Self;
}

=head2 ActivityAdd()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if EntityID already exists
    return if !$DBObject->Prepare(
        SQL => "
            SELECT id
            FROM pm_activity
            WHERE $Self->{Lower}(entity_id) = $Self->{Lower}(?)",
        Bind  => [ \$Param{EntityID} ],
        Limit => 1,
    );

    my $EntityExists;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $EntityExists = 1;
    }

    if ($EntityExists) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The EntityID:$Param{EntityID} already exists for an activity!"
        );
        return;
    }

    # check config valid format
    if ( ref $Param{Config} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # sql
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO pm_activity (entity_id, name, config, create_time, create_by, change_time,
                change_by)
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM pm_activity WHERE entity_id = ?',
        Bind => [ \$Param{EntityID} ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return if !$ID;

    return $ID;
}

=head2 ActivityDelete()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM pm_activity WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return 1;
}

=head2 ActivityGet()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID or EntityID!'
        );
        return;
    }

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $Cache = $CacheObject->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    if ( $Param{ID} ) {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_activity
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_activity
                WHERE entity_id = ?',
            Bind  => [ \$Param{EntityID} ],
            Limit => 1,
        );
    }

    # get yaml object
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        my $Config = $YAMLObject->Load( Data => $Data[3] );

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

            # get activity dialog object
            my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

            my $ActivityDialogList = $ActivityDialogObject->ActivityDialogList(
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
    $CacheObject->Set(
        Type  => 'ProcessManagement_Activity',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=head2 ActivityUpdate()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if EntityID already exists
    return if !$DBObject->Prepare(
        SQL => "
            SELECT id FROM pm_activity
            WHERE $Self->{Lower}(entity_id) = $Self->{Lower}(?)
            AND id != ?",
        Bind  => [ \$Param{EntityID}, \$Param{ID} ],
        LIMIT => 1,
    );

    my $EntityExists;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $EntityExists = 1;
    }

    if ($EntityExists) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The EntityID:$Param{Name} already exists for a activity!",
        );
        return;
    }

    # check config valid format
    if ( ref $Param{Config} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # check if need to update db
    return if !$DBObject->Prepare(
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
    while ( my @Data = $DBObject->FetchrowArray() ) {
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
    return if !$DBObject->Do(
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
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_Activity',
    );

    return 1;
}

=head2 ActivityList()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $UseEntities = 0;
    if ( defined $Param{UseEntities} && $Param{UseEntities} ) {
        $UseEntities = 1;
    }
    my $CacheKey = 'ActivityList::UseEntities::' . $UseEntities;
    my $Cache    = $CacheObject->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, entity_id, name
            FROM pm_activity',
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( !$UseEntities ) {
            $Data{ $Row[0] } = $Row[2];
        }
        else {
            $Data{ $Row[1] } = $Row[2];
        }
    }

    # set cache
    $CacheObject->Set(
        Type  => 'ProcessManagement_Activity',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=head2 ActivityListGet()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey = 'ActivityListGet';

    my $Cache = $CacheObject->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, entity_id
            FROM pm_activity
            ORDER BY id',
    );

    my @ActivityIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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
    $CacheObject->Set(
        Type  => 'ProcessManagement_Activity',
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return \@Data;
}

=head2 ActivitySearch()

search activities by process name

    my $ActivityEntityIDs = $ActivityObject->ActivitySearch(
        ActivityName => 'SomeText',       # e. g. "SomeText*", "Some*ext" or ['*SomeTest1*', '*SomeTest2*']
    );

    Returns:

    $ActivityEntityIDs = [ 'Activity-e11e2e9aa83344a235279d4f6babc6ec', 'Activity-f8194a25ab0ccddefeb4240c281c1f56' ];

=cut

sub ActivitySearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ActivityName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ActivityName!',
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = 'SELECT DISTINCT entity_id
               FROM pm_activity ';

    # if it's no ref, put it to array ref
    if ( ref $Param{ActivityName} eq '' ) {
        $Param{ActivityName} = [ $Param{ActivityName} ];
    }

    if ( IsArrayRefWithData( $Param{ActivityName} ) ) {
        $SQL .= ' WHERE' if IsArrayRefWithData( $Param{ActivityName} );
    }

    my @QuotedSearch;
    my $SQLOR = 0;

    VALUE:
    for my $Value ( @{ $Param{ActivityName} } ) {

        next VALUE if !defined $Value || !length $Value;

        $Value = '%' . $DBObject->Quote( $Value, 'Like' ) . '%';
        $Value =~ s/\*/%/g;
        $Value =~ s/%%/%/gi;

        if ($SQLOR) {
            $SQL .= ' OR';
        }

        $SQL .= ' name LIKE ? ';

        push @QuotedSearch, $Value;
        $SQLOR = 1;

    }

    if ( IsArrayRefWithData( $Param{ActivityName} ) ) {
        $SQL .= $DBObject->GetDatabaseFunction('LikeEscapeString');
    }
    $SQL .= ' ORDER BY entity_id';

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => [ \(@QuotedSearch) ]
    );

    my @Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Data, $Row[0];
    }

    return \@Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
