# --
# Kernel/System/ProcessManagement/Entity.pm - Process Management DB Entity backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Entity;

use strict;
use warnings;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::ProcessManagement::DB::Entity.pm

=head1 SYNOPSIS

Process Management DB Entity backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an Entity object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::ProcessManagement::DB::Entity;

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
    my $EntityObject = Kernel::System::ProcessManagement::DB::Entity->new(
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

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('Process::CacheTTL') || 3600 );

    $Self->{ValidEntities} = {
        'Process'          => 1,
        'Activity'         => 1,
        'ActivityDialog'   => 1,
        'Transition'       => 1,
        'TransitionAction' => 1,
    };

    return $Self;
}

=item EntityIDGenerate()

generate unique Entity ID

    my $EntityID = $EntityObject->EntityIDGenerate(
        EntityType     => 'Process'        # mandatory, 'Process' || 'Activity' || 'ActivityDialog'
                                           #    || 'Transition' || 'TransitionAction'
        UserID         => 123,             # mandatory
    );

Returns:

    $EntityID = 'P1';

=cut

sub EntityIDGenerate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityType UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check entity type
    if ( !$Self->{ValidEntities}->{ $Param{EntityType} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityType:$Param{EntityType} is invalid!"
        );
        return;

    }

    # get last entity counter
    my $EntityCounter = $Self->EntityCounterGet(
        EntityType => $Param{EntityType},
        UserID     => $Param{UserID}
    );

    # increment entity counter
    $EntityCounter++;

    # get entity prefix
    my $EntityPrefix
        = $Self->{ConfigObject}->Get('Process::Entity::Prefix')->{ $Param{EntityType} } || 'E';

    my $EntityID = $EntityPrefix . $EntityCounter;

    # update entity id in DB
    my $Success = $Self->EntityIDUpdate(
        EntityType => $Param{EntityType},
        EntityID   => $EntityID,
        UserID     => 1,
    );

    return if !$Success;

    return $EntityID;
}

=item EntityIDUpdate()

set new Entity ID

returns 1 on sucess or otherwise udef

    my $Success = $EntityObject->EntityIDUpdate(
        EntityType     => 'Process'        # mandatory, 'Process' || 'Activity' || 'ActivityDialog'
                                           #    || 'Transition' || 'TransitionAction'
        EntityID       => 'P1',            # optional, if not defined, base value will be
                                           #    incremented by 1 (prefered usage)
        UserID         => 123,             # mandatory
    );

=cut

sub EntityIDUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityType UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check entity type
    if ( !$Self->{ValidEntities}->{ $Param{EntityType} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityType:$Param{EntityType} is invalid!"
        );
        return;
    }

    # get last entity counter
    my $EntityCounter = $Self->EntityCounterGet(
        EntityType => $Param{EntityType},
        UserID     => $Param{UserID}
    );

    # get entity prefix
    my $EntityPrefix
        = $Self->{ConfigObject}->Get('Process::Entity::Prefix')->{ $Param{EntityType} } || 'E';

    my $NewEntityCounter;
    if ( $Param{EntityID} ) {
        my $EntityID = $Param{EntityID};

        # remove prefix
        $EntityID =~ s{\A$EntityPrefix}{};

        # check if value is numeric
        if ( !IsNumber($EntityID) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The EntityID:$Param{EntityID} is invalid!"
            );
            return;
        }
        $NewEntityCounter = $EntityID;
    }
    else {
        $NewEntityCounter = $EntityCounter;
        $NewEntityCounter++;
    }

    # check that new entity counter is different than current
    if ( $NewEntityCounter == $EntityCounter ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityID:$EntityPrefix$EntityCounter is already in use!"
        );
        return;
    }

    # remove old counter
    return if !$Self->{DBObject}->Do(
        SQL => '
            DELETE
            FROM pm_entity
            WHERE entity_type = ?
                AND entity_counter = ?',
        Bind => [
            \$Param{EntityType}, \$EntityCounter,
        ],
    );

    # store new counter
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO pm_entity ( entity_type, entity_counter )
            VALUES (?, ?)',
        Bind => [ \$Param{EntityType}, \$NewEntityCounter, ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Entity',
    );

    return 1;
}

=item EntityCounterGet()

gets current Entity Counter

    my $EntityCounter = $EntityObject->EntityCounterGet(
        EntityType     => 'Process'        # mandatory, 'Process' || 'Activity' || 'ActivityDialog'
                                           #    || 'Transition' || 'TransitionAction'
        UserID         => 123,             # mandatory
    );

Returns:

    $EntityCounter = '1';

=cut

sub EntityCounterGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityType UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check entity type
    if ( !$Self->{ValidEntities}->{ $Param{EntityType} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityType:$Param{EntityType} is invalid!"
        );
        return;

    }

    # check if result is cached
    my $CacheKey = "EntityCounterGet::EntityType::$Param{EntityType}";

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Entity',
        Key  => $CacheKey,
    );
    return ${$Cache} if ( ref $Cache eq 'SCALAR' );

    # get last registered entity id
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT entity_counter
            FROM pm_entity
            WHERE entity_type = ?",
        Bind  => [ \$Param{EntityType} ],
        Limit => 1,
    );

    # counter must be defined as 0
    my $EntityCounter = 0;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $EntityCounter = $Data[0] || 0;
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_Entity',
        Key   => $CacheKey,
        Value => \$EntityCounter,
        TTL   => $Self->{CacheTTL},
    );
    return $EntityCounter;
}

=item EntitySyncStateSet()

set sync state for an entity.

    my $Success = $EntityObject->EntitySyncStateSet(
        EntityType       => 'Process',      # 'Process' || 'Activity' || 'ActivityDialog'
                                            #   || 'Transition' || 'TransitionAction', type of the
                                            #   entity
        EntityID         => 'P1',
        SyncState        => 'not_sync',     # the sync state to set
        UserID           => 123,
    );

=cut

sub EntitySyncStateSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(EntityType EntityID SyncState UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check entity type
    if ( !$Self->{ValidEntities}->{ $Param{EntityType} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityType:$Param{EntityType} is invalid!"
        );
        return;
    }

    # create new
    if ( !%{ $Self->EntitySyncStateGet(%Param) || {} } ) {
        return if !$Self->{DBObject}->Do(
            SQL => '
                INSERT INTO pm_entity_sync
                    (entity_type, entity_id, sync_state, create_time, change_time)
                VALUES (?, ?, ?, current_timestamp, current_timestamp)',
            Bind => [
                \$Param{EntityType}, \$Param{EntityID}, \$Param{SyncState},
            ],
        );
    }
    else {    # update existing

        return if !$Self->{DBObject}->Do(
            SQL => '
                UPDATE pm_entity_sync
                SET sync_state = ?, change_time = current_timestamp
                WHERE entity_type = ?
                    AND entity_id = ?',
            Bind => [
                \$Param{SyncState}, \$Param{EntityType}, \$Param{EntityID},
            ],
        );
    }

    return 1;
}

=item EntitySyncStateGet()

gets the sync state of an entity

    my $EntitySyncState = $EntityObject->EntitySyncStateGet(
        EntityType       => 'Process',      # 'Process' || 'Activity' || 'ActivityDialog'
                                            #   || 'Transition' || 'TransitionAction', type of the
                                            #   entity
        EntityID         => 'P1',
        UserID           => 123,
    );

If sync state was found, returns:

    $ObjectLockState = {
        EntityType       => 'Process',
        EntityID         => 'P1',
        SyncState        => 'not_sync',
        CreateTime       => '2011-02-08 15:08:00',
        ChangeTime       => '2011-02-08 15:08:00',
    };

If no sync state was found, returns undef.

=cut

sub EntitySyncStateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(EntityType EntityID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check entity type
    if ( !$Self->{ValidEntities}->{ $Param{EntityType} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityType:$Param{EntityType} is invalid!"
        );
        return;
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT entity_type, entity_id, sync_state, create_time, change_time
            FROM pm_entity_sync
            WHERE entity_type =?
                AND entity_id = ?',
        Bind => [
            \$Param{EntityType}, \$Param{EntityID},
        ],
    );

    my %Result;

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        %Result = (
            EntityType => $Data[0],
            EntityID   => $Data[1],
            SyncState  => $Data[2],
            CreateTime => $Data[3],
            ChangeTime => $Data[4],
        );
    }

    return if !IsHashRefWithData( \%Result );

    return \%Result;
}

=item EntitySyncStateDelete()

deletes sync state of an entity.

    my $Success = $EntityObject->EntitySyncStateDelete(
        EntityType       => 'Process',      # 'Process' || 'Activity' || 'ActivityDialog'
                                            #   || 'Transition' || 'TransitionAction', type of the
                                            #   entity
        EntityID         => 'P1',
        UserID           => 123,
    );

=cut

sub EntitySyncStateDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityType EntityID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check entity type
    if ( !$Self->{ValidEntities}->{ $Param{EntityType} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The EntityType:$Param{EntityType} is invalid!"
        );
        return;
    }

    return if ( !%{ $Self->EntitySyncStateGet(%Param) || {} } );

    return if !$Self->{DBObject}->Do(
        SQL => '
            DELETE FROM pm_entity_sync
            WHERE entity_type = ?
                AND entity_id = ?',
        Bind => [
            \$Param{EntityType}, \$Param{EntityID},
        ],
    );

    return 1;
}

=item EntitySyncStatePurge()

deletes all entries .

    my $Success = $EntityObject->EntitySyncStatePurge(
        UserID           => 123,
    );

=cut

sub EntitySyncStatePurge {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => '
            DELETE FROM pm_entity_sync',
        Bind => [],
    );

    return 1;
}

=item EntitySyncStateList()

gets a list of sync states.

    my $EntitySyncStateList = $EntityObject->EntitySyncStateList(
        EntityType       => 'Process',      # optional, 'Process' || 'Activity' || 'ActivityDialog'
                                            #   || 'Transition' || 'TransitionAction', type of the
                                            #   entity
        SyncState        => 'not_sync',     # optional, only entries with this sync state
        UserID           => 123,
    );

Returns:

    $EntitySyncStateList = [
        {
            EntityType       => 'Process',
            EntityID         => 'P1',
            SyncState        => 'sync_started',
            CreateTime       => '2011-02-08 15:08:00',
            ChangeTime       => '2011-02-08 15:08:00',
        },
        ...
    ];

=cut

sub EntitySyncStateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    if ( $Param{EntityType} ) {

        # check entity type
        if ( !$Self->{ValidEntities}->{ $Param{EntityType} } ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The EntityType:$Param{EntityType} is invalid!"
            );
            return;
        }
    }

    my $SQL = '
        SELECT entity_type, entity_id, sync_state, create_time, change_time
        FROM pm_entity_sync';

    my @Bind;

    if ( $Param{EntityType} ) {
        $SQL .= ' WHERE entity_type = ?';
        push @Bind, \$Param{EntityType};

        if ( $Param{SyncState} ) {
            $SQL .= ' AND sync_state = ?';
            push @Bind, \$Param{SyncState};
        }
    }
    elsif ( $Param{SyncState} ) {
        $SQL .= ' WHERE sync_state = ?';
        push @Bind, \$Param{SyncState};
    }

    $SQL .= ' ORDER BY entity_id ASC';

    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Result;

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        push @Result, {
            EntityType => $Data[0],
            EntityID   => $Data[1],
            SyncState  => $Data[2],
            CreateTime => $Data[3],
            ChangeTime => $Data[4],
        };
    }

    return \@Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
