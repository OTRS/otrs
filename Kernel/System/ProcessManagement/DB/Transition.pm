# --
# Kernel/System/ProcessManagement/Transition.pm - Process Management DB Transition backend
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Transition;

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

Kernel::System::ProcessManagement::DB::Transition

=head1 SYNOPSIS

Process Management DB Transition backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');

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

=item TransitionAdd()

add new Trnsition

returns the id of the created Transition if success or undef otherwise

    my $ID = $TransitionObject->TransitionAdd(
        EntityID    => 'T1'                   # mandatory, exportable unique identifier
        Name        => 'NameOfTransition',     # mandatory
        Config      => $ConfigHashRef,         # mandatory, transition configuration to be stored in
                                               #   YAML format
        UserID      => 123,                    # mandatory
    );

Returns:

    $ID = 567;

=cut

sub TransitionAdd {
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
            FROM pm_transition
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
            Message  => "The EntityID:$Param{EntityID} already exists for a transition!"
        );
        return;
    }

    # check config valid format (at least it must contain the description short, fields and field
    # order)
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }
    for my $Needed (qw(Condition)) {
        if ( !$Param{Config}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Config!",
            );
            return;
        }
    }

    # check config formats
    if ( ref $Param{Config}->{Condition} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config Fields must be a Hash!",
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
            INSERT INTO pm_transition ( entity_id, name, config, create_time,
                create_by, change_time, change_by )
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM pm_transition WHERE entity_id = ?',
        Bind => [ \$Param{EntityID} ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_Transition',
    );

    return if !$ID;

    return $ID;
}

=item TransitionDelete()

delete an Transition

returns 1 if success or undef otherwise

    my $Success = $TransitionObject->TransitionDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub TransitionDelete {
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
    my $Transition = $Self->TransitionGet(
        ID     => $Param{ID},
        UserID => 1,
    );
    return if !IsHashRefWithData($Transition);

    # delete transition
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM pm_transition WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_Transition',
    );

    return 1;
}

=item TransitionGet()

get Transition attributes

    my $Transition = $TransitionObject->TransitionGet(
        ID            => 123,            # ID or EntityID is needed
        EntityID      => 'T1',
        UserID        => 123,            # mandatory
    );

Returns:

    $Transition = {
        ID           => 123,
        EntityID     => 'T1',
        Name         => 'some name',
        Config       => $ConfigHashRef,
        CreateTime   => '2012-07-04 15:08:00',
        ChangeTime   => '2012-07-04 15:08:00',
    };

=cut

sub TransitionGet {
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
        $CacheKey = 'TransitionGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'TransitionGet::EntityID::' . $Param{EntityID};
    }

    my $Cache = $CacheObject->Get(
        Type => 'ProcessManagement_Transition',
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
                FROM pm_transition
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_transition
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
        Type  => 'ProcessManagement_Transition',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item TransitionUpdate()

update Transition attributes

returns 1 if success or undef otherwise

    my $Success = $TransitionObject->TransitionUpdate(
        ID          => 123,                # mandatory
        EntityID    => 'T1'                # mandatory, exportable unique identifier
        Name        => 'NameOfTransition', # mandatory
        Config      => $ConfigHashRef,     # mandatory, transition configuration to be stored in
                                           #   YAML format
        UserID      => 123,                # mandatory
    );

=cut

sub TransitionUpdate {
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
            SELECT id FROM pm_transition
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
            Message  => "The EntityID:$Param{Name} already exists for a Transition!",
        );
        return;
    }

    # check config valid format (at least it must contain the condition
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }
    for my $Needed (qw(Condition)) {
        if ( !$Param{Config}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Config!",
            );
            return;
        }
    }

    # check config formats
    if ( ref $Param{Config}->{Condition} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Config Fields must be a Hash!",
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
            FROM pm_transition
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
            UPDATE pm_transition
            SET entity_id = ?, name = ?,  config = ?, change_time = current_timestamp,
                change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_Transition',
    );

    return 1;
}

=item TransitionList()

get an Transition list

    my $List = $TransitionObject->TransitionList(
        UseEntities => 0,                       # default 0, 1 || 0. if 0 the return hash keys are
                                                #    the transition IDs otherwise keys are the
                                                #    transition entity IDs
        UserID      => 1,
    );

    Returns:

    $List = {
        1 => 'NameOfTransition',
    }

    or

    $List = {
        'T1' => 'NameOfTransition',
    }
=cut

sub TransitionList {
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

    my $CacheKey = 'TransitionList::UseEntities::' . $UseEntities;
    my $Cache    = $CacheObject->Get(
        Type => 'ProcessManagement_Transition',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
            SELECT id, entity_id, name
            FROM pm_transition';

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
        Type  => 'ProcessManagement_Transition',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item TransitionListGet()

get a Transition list with all Transition details

    my $List = $TransitionObject->TransitionListGet(
        UserID      => 1,
    );

Returns:

    $List = [
        {
            ID             => 123,
            EntityID       => 'T1',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            CreateTime     => '2012-07-04 15:08:00',
            ChangeTime     => '2012-07-04 15:08:00',
        }
        {
            ID             => 456,
            EntityID       => 'T2',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            CreateTime     => '2012-07-04 15:09:00',
            ChangeTime     => '2012-07-04 15:09:00',
        }
    ];

=cut

sub TransitionListGet {
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
    my $CacheKey = 'TransitionListGet';

    my $Cache = $CacheObject->Get(
        Type => 'ProcessManagement_Transition',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, entity_id
            FROM pm_transition
            ORDER BY id',
    );

    my @TransitionIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @TransitionIDs, $Row[0];
    }

    my @Data;
    for my $ItemID (@TransitionIDs) {

        my $TransitionData = $Self->TransitionGet(
            ID     => $ItemID,
            UserID => 1,
        );
        push @Data, $TransitionData;
    }

    # set cache
    $CacheObject->Set(
        Type  => 'ProcessManagement_Transition',
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
