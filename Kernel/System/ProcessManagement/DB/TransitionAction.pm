# --
# Kernel/System/ProcessManagement/TransitionAction.pm - Process Management DB TransitionAction backend
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::TransitionAction;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::ProcessManagement::DB::Transition::TransitionAction

=head1 SYNOPSIS

Process Management DB TransitionAction backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TransitionActionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');

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

=item TransitionActionAdd()

add new TransitionAction

returns the id of the created TransitionAction if success or undef otherwise

    my $ID = $TransitionActionObject->TransitionActionAdd(
        EntityID    => 'TA1'                     # mandatory, exportable unique identifier
        Name        => 'NameOfTransitionAction', # mandatory
        Config      => $ConfigHashRef,           # mandatory, transition action configuration to be
                                                 #    stored in YAML format
        UserID      => 123,                      # mandatory
    );

Returns:

    $ID = 567;

=cut

sub TransitionActionAdd {
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
            FROM pm_transition_action
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
            Message  => "The EntityID:$Param{EntityID} already exists for a transition action!"
        );
        return;
    }

    # check config valid format (at least it must contain another config hash inside)
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }
    for my $Needed (qw(Module Config)) {
        if ( !$Param{Config}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Config!",
            );
            return;
        }
    }

    # check config formats
    if ( !IsStringWithData( $Param{Config}->{Module} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config Module must be a non empty String!",
        );
        return;
    }
    if ( ref $Param{Config}->{Config} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config Config must be a Hash!",
        );
        return;
    }

    # dump layout and config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # sql
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO pm_transition_action ( entity_id, name, config, create_time,
                create_by, change_time, change_by )
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM pm_transition_action WHERE entity_id = ?',
        Bind => [ \$Param{EntityID} ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_TransitionAction',
    );

    return if !$ID;

    return $ID;
}

=item TransitionActionDelete()

delete an TransitionAction

returns 1 if success or undef otherwise

    my $Success = $TransitionActionObject->TransitionActionDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub TransitionActionDelete {
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
    my $TransitionAction = $Self->TransitionActionGet(
        ID     => $Param{ID},
        UserID => 1,
    );
    return if !IsHashRefWithData($TransitionAction);

    # delete transition action
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM pm_transition_action WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_TransitionAction',
    );

    return 1;
}

=item TransitionActionGet()

get TransitionAction attributes

    my $TransitionAction = $TransitionActionObject->TransitionActionGet(
        ID            => 123,            # ID or EntityID is needed
        EntityID      => 'P1',
        UserID        => 123,            # mandatory
    );

Returns:

    $TransitionAction = {
        ID           => 123,
        EntityID     => 'TA1',
        Name         => 'some name',
        Config       => $ConfigHashRef,
        CreateTime   => '2012-07-04 15:08:00',
        ChangeTime   => '2012-07-04 15:08:00',
    };

=cut

sub TransitionActionGet {
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

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'TransitionActionGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'TransitionActionGet::EntityID::' . $Param{EntityID};
    }

    my $Cache = $CacheObject->Get(
        Type => 'ProcessManagement_TransitionAction',
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
                FROM pm_transition_action
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_transition_action
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

    # set cache
    $CacheObject->Set(
        Type  => 'ProcessManagement_TransitionAction',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item TransitionActionUpdate()

update TransitionAction attributes

returns 1 if success or undef otherwise

    my $Success = $TransitionActionObject->TransitionActionUpdate(
        ID          => 123,                      # mandatory
        EntityID    => 'TA1'                     # mandatory, exportable unique identifier
        Name        => 'NameOfTransitionAction', # mandatory
        Config      => $ConfigHashRef,           # mandatory, actvity dialog configuration to be
                                                 #   stored in YAML format
        UserID      => 123,                      # mandatory
    );

=cut

sub TransitionActionUpdate {
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
            SELECT id FROM pm_transition_action
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
            Message  => "The EntityID:$Param{Name} already exists for a TransitionAction!",
        );
        return;
    }

    # check config valid format (at least it must contain another config hash)
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }
    for my $Needed (qw(Module Config)) {
        if ( !$Param{Config}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Config!",
            );
            return;
        }
    }

    # check config formats
    if ( !IsStringWithData( $Param{Config}->{Module} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config->Config must be a non empty string!",
        );
        return;
    }
    if ( ref $Param{Config}->{Config} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config->Config must be a Hash!",
        );
        return;
    }

    # dump layout and config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # check if need to update db
    return if !$DBObject->Prepare(
        SQL => '
            SELECT entity_id, name, config
            FROM pm_transition_action
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
            UPDATE pm_transition_action
            SET entity_id = ?, name = ?,  config = ?, change_time = current_timestamp,
                change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_TransitionAction',
    );

    return 1;
}

=item TransitionActionList()

get an TransitionAction list

    my $List = $TransitionActionObject->TransitionActionList(
        UseEntities => 0,                       # default 0, 1 || 0. if 0 the return hash keys are
                                                #    the transition action IDs otherwise keys are
                                                #    the transition action entity IDs
        UserID      => 1,
    );

    Returns:

    $List = {
        1 => 'NameOfTransitionAction',
    }

    or

    $List = {
        'AD1' => 'NameOfTransitionAction',
    }
=cut

sub TransitionActionList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = 'TransitionActionList::UseEntities::' . $UseEntities;
    my $Cache    = $CacheObject->Get(
        Type => 'ProcessManagement_TransitionAction',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
            SELECT id, entity_id, name
            FROM pm_transition_action';

    return if !$DBObject->Prepare( SQL => $SQL );

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
        Type  => 'ProcessManagement_TransitionAction',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item TransitionActionListGet()

get an Transition Action list with all Transition Action details

    my $List = $TransitionActionObject->TransitionActionListGet(
        UserID      => 1,
    );

Returns:

    $List = [
        {
            ID             => 123,
            EntityID       => 'TA1',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            CreateTime     => '2012-07-04 15:08:00',
            ChangeTime     => '2012-07-04 15:08:00',
        }
        {
            ID             => 456,
            EntityID       => 'TA2',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            CreateTime     => '2012-07-04 15:09:00',
            ChangeTime     => '2012-07-04 15:09:00',
        }
    ];

=cut

sub TransitionActionListGet {
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
    my $CacheKey = 'TransitionActionListGet';

    my $Cache = $CacheObject->Get(
        Type => 'ProcessManagement_TransitionAction',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, entity_id
            FROM pm_transition_action
            ORDER BY id',
    );

    my @TransitionActionIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @TransitionActionIDs, $Row[0];
    }

    my @Data;
    for my $ItemID (@TransitionActionIDs) {

        my $TransitionActionData = $Self->TransitionActionGet(
            ID     => $ItemID,
            UserID => 1,
        );
        push @Data, $TransitionActionData;
    }

    # set cache
    $CacheObject->Set(
        Type  => 'ProcessManagement_TransitionAction',
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
