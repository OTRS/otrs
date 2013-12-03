# --
# Kernel/System/ProcessManagement/Process.pm - Process Management DB Process backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Process;

use strict;
use warnings;

use Kernel::System::YAML;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::User;

use Kernel::System::DynamicField;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::ActivityDialog;
use Kernel::System::ProcessManagement::DB::Process::State;
use Kernel::System::ProcessManagement::DB::Transition;
use Kernel::System::ProcessManagement::DB::TransitionAction;

=head1 NAME

Kernel::System::ProcessManagement::DB::Process.pm

=head1 SYNOPSIS

Process Management DB Process backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a Process object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::ProcessManagement::DB::Process;

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
    my $ProcessObject = Kernel::System::ProcessManagement::DB::Process->new(
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
    $Self->{CacheObject}        = Kernel::System::Cache->new( %{$Self} );
    $Self->{YAMLObject}         = Kernel::System::YAML->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );

    $Self->{EntityObject} = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::DB::ActivityDialog->new( %{$Self} );
    $Self->{ActivityObject} = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );
    $Self->{StateObject} = Kernel::System::ProcessManagement::DB::Process::State->new( %{$Self} );
    $Self->{TransitionObject} = Kernel::System::ProcessManagement::DB::Transition->new( %{$Self} );
    $Self->{TransitionActionObject}
        = Kernel::System::ProcessManagement::DB::TransitionAction->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('Process::CacheTTL') || 3600 );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( $Self->{DBObject}->GetDatabaseFunction('CaseSensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    return $Self;
}

=item ProcessAdd()

add new Process

returns the id of the created process if success or undef otherwise

    my $ID = $ProcessObject->ProcessAdd(
        EntityID       => 'P1'             # mandatory, exportable unique identifier
        Name           => 'NameOfProcess', # mandatory
        StateEntityID  => 'S1',
        Layout         => $LayoutHashRef,  # mandatory, diagram objects positions to be stored in
                                           #   YAML format
        Config         => $ConfigHashRef,  # mandatory, process configuration to be stored in YAML
                                           #   format
        UserID         => 123,             # mandatory
    );

Returns:

    $ID = 567;

=cut

sub ProcessAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityID Name StateEntityID Layout Config UserID)) {
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
            FROM pm_process
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
            Message  => "The EntityID:$Param{EntityID} already exists for a process!"
        );
        return;
    }

    # check config valid format (at least it must contain the description)
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }
    if ( !$Param{Config}->{Description} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Description in Config!",
        );
        return;
    }

    # dump layout and config as string
    my $Layout = $Self->{YAMLObject}->Dump( Data => $Param{Layout} );
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Layout);
    utf8::upgrade($Config);

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO pm_process ( entity_id, name, state_entity_id, layout, config, create_time,
                create_by, change_time, change_by )
            VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Param{StateEntityID}, \$Layout, \$Config,
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM pm_process WHERE entity_id = ?',
        Bind => [ \$Param{EntityID} ],
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Process',
    );

    return if !$ID;

    return $ID;
}

=item ProcessDelete()

delete a Process

returns 1 if success or undef otherwise

    my $Success = $ProcessObject->ProcessDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub ProcessDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my $Process = $Self->ProcessGet(
        ID     => $Param{ID},
        UserID => 1,
    );
    return if !IsHashRefWithData($Process);

    # delete process
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM pm_process WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Process',
    );

    return 1;
}

=item ProcessGet()

get Process attributes

    my $Process = $ProcessObject->ProcessGet(
        ID              => 123,          # ID or EntityID is needed
        EntityID        => 'P1',
        ActivityNames   => 1,            # default 0, 1 || 0, if 0 returns an Activities array
                                         #     with the activity entity IDs, if 1 returns an
                                         #     Activities hash with the activity entity IDs as
                                         #     keys and Activity Names as values
        TransitionNames => 1,            # default 0, 1 || 0, if 0 returns an Transitions array
                                         #     with the transition entity IDs, if 1 returns an
                                         #     Transitions hash with the transition entity IDs as
                                         #     keys and Transition Names as values
        TransitionActionNames => 1,      # default 0, 1 || 0, if 0 returns an TransitionActions array
                                         #     with the TransitionAction entity IDs, if 1 returns an
                                         #     TransitionAction hash with the TransitionAction entity IDs as
                                         #     keys and TransitionAction Names as values
        UserID          => 123,          # mandatory
    );

Returns:

    $Process = {
        ID            => 123,
        EntityID      => 'P1',
        Name          => 'some name',
        StateEntityID => 'S1',
        State         => 'Active',
        Layout        => $LayoutHashRef,
        Config        => $ConfigHashRef,
        Activities    => ['A1','A2','A3'],
        Activities    => ['T1','T2','T3'],
        CreateTime    => '2012-07-04 15:08:00',
        ChangeTime    => '2012-07-04 15:08:00',
    };

    $Process = {
        ID            => 123,
        EntityID      => 'P1',
        Name          => 'some name',
        StateEntityID => 'S1',
        State         => 'Active',
        Layout        => $LayoutHashRef,
        Config        => $ConfigHashRef,
        Activities    => {
            'A1' => 'Activity1',
            'A2' => 'Activity2',
            'A3' => 'Activity3',
        };
        Transitions   => {
            'T1' => 'Transition1',
            'T2' => 'Transition2',
            'T3' => 'Transition3',
        };
        TransitionActions => {
            'TA1' => 'TransitionAction1',
            'TA2' => 'TransitionAction2',
            'TA3' => 'TransitionAction3',
        };
        CreateTime => '2012-07-04 15:08:00',
        ChangeTime => '2012-07-04 15:08:00',
    };

=cut

sub ProcessGet {
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

    my $ActivityNames = 0;
    if ( defined $Param{ActivityNames} && $Param{ActivityNames} == 1 ) {
        $ActivityNames = 1;
    }
    my $TransitionNames = 0;
    if ( defined $Param{TransitionNames} && $Param{TransitionNames} == 1 ) {
        $TransitionNames = 1;
    }
    my $TransitionActionNames = 0;
    if ( defined $Param{TransitionActionNames} && $Param{TransitionActionNames} == 1 ) {
        $TransitionActionNames = 1;
    }

    # check cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'ProcessGet::ID::' . $Param{ID} . '::ActivityNames::'
            . $ActivityNames
            . '::TransitionNames::'
            . $TransitionNames
            . '::TransitionActionNames::'
            . $TransitionActionNames;
    }
    else {
        $CacheKey = 'ProcessGet::EntityID::' . $Param{EntityID} . '::ActivityNames::'
            . $ActivityNames
            . '::TransitionNames::'
            . $TransitionNames
            . '::TransitionActionNames::'
            . $TransitionActionNames;
    }

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Process',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, entity_id, name, state_entity_id, layout, config, create_time,
                    change_time
                FROM pm_process
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, entity_id, name, state_entity_id, layout, config, create_time,
                    change_time
                FROM pm_process
                WHERE entity_id = ?',
            Bind  => [ \$Param{EntityID} ],
            Limit => 1,
        );
    }

    my %Data;

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        my $Layout = $Self->{YAMLObject}->Load( Data => $Data[4] );
        my $Config = $Self->{YAMLObject}->Load( Data => $Data[5] );

        %Data = (
            ID            => $Data[0],
            EntityID      => $Data[1],
            Name          => $Data[2],
            StateEntityID => $Data[3],
            Layout        => $Layout,
            Config        => $Config,
            CreateTime    => $Data[6],
            ChangeTime    => $Data[7],

        );
    }

    return if !$Data{ID};

    # create the ActivityList
    if ($ActivityNames) {
        my %Activities;

        if ( IsHashRefWithData( $Data{Config}->{Path} ) ) {

            my $ActivityList = $Self->{ActivityObject}->ActivityList(
                UseEntities => 1,
                UserID      => 1,
            );

            for my $ActivityEntityID ( sort keys %{ $Data{Config}->{Path} } ) {
                $Activities{$ActivityEntityID} = $ActivityList->{$ActivityEntityID};
            }
        }
        $Data{Activities} = \%Activities;
    }
    else {
        my @Activities;

        if ( IsHashRefWithData( $Data{Config}->{Path} ) ) {

            # get path keys (ActivityEntityIDs) and map them into an array
            @Activities = map {$_} sort keys %{ $Data{Config}->{Path} };
        }
        $Data{Activities} = \@Activities;
    }

    # create the transition list
    if ($TransitionNames) {

        my %Transitions;
        if ( IsHashRefWithData( $Data{Config}->{Path} ) ) {

            my $TransitionList = $Self->{TransitionObject}->TransitionList(
                UseEntities => 1,
                UserID      => 1,
            );

            for my $ActivityEntityID ( sort keys %{ $Data{Config}->{Path} } ) {
                for my $TransitionEntityID (
                    sort keys %{ $Data{Config}->{Path}->{$ActivityEntityID} }
                    )
                {
                    $Transitions{$TransitionEntityID} = $TransitionList->{$TransitionEntityID};
                }
            }
        }
        $Data{Transitions} = \%Transitions;
    }
    else {
        my @Transitions;

        if ( IsHashRefWithData( $Data{Config}->{Path} ) ) {

            for my $ActivityEntityID ( sort keys %{ $Data{Config}->{Path} } ) {

                for my $TransitionEntityID (
                    sort keys %{ $Data{Config}->{Path}->{$ActivityEntityID} }
                    )
                {
                    push @Transitions, $TransitionEntityID;
                }
            }
        }
        $Data{Transitions} = \@Transitions;
    }

    # create the transition action list
    if ($TransitionActionNames) {

        my %TransitionActions;
        if ( IsHashRefWithData( $Data{Config}->{Path} ) ) {

            my $TransitionActionList = $Self->{TransitionActionObject}->TransitionActionList(
                UseEntities => 1,
                UserID      => 1,
            );

            for my $ActivityEntityID ( sort keys %{ $Data{Config}->{Path} } ) {

                my $TransitionPath = $Data{Config}->{Path}->{$ActivityEntityID};
                for my $TransitionEntityID ( sort keys %{$TransitionPath} ) {

                    my $TransitionActionPath
                        = $Data{Config}->{Path}->{$ActivityEntityID}->{$TransitionEntityID}
                        ->{Action};
                    if ( $TransitionActionPath && @{$TransitionActionPath} ) {
                        for my $TransitionActionEntityID ( sort @{$TransitionActionPath} ) {
                            $TransitionActions{$TransitionActionEntityID}
                                = $TransitionActionList->{$TransitionEntityID};
                        }
                    }
                }
            }
        }
        $Data{TransitionActions} = \%TransitionActions;
    }
    else {
        my @TransitionActions;

        if ( IsHashRefWithData( $Data{Config}->{Path} ) ) {

            for my $ActivityEntityID ( sort keys %{ $Data{Config}->{Path} } ) {

                my $TransitionPath = $Data{Config}->{Path}->{$ActivityEntityID};
                for my $TransitionEntityID ( sort keys %{$TransitionPath} ) {

                    my $TransitionActionPath
                        = $TransitionPath->{$TransitionEntityID}->{TransitionAction};
                    if ( $TransitionActionPath && @{$TransitionActionPath} ) {
                        for my $TransitionActionEntityID ( sort @{$TransitionActionPath} ) {
                            push @TransitionActions, $TransitionActionEntityID;
                        }
                    }
                }
            }
        }
        $Data{TransitionActions} = \@TransitionActions;
    }

    $Data{State} = $Self->{StateObject}->StateLookup(
        EntityID => $Data{StateEntityID},
        UserID   => 1,
    );

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_Process',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ProcessUpdate()

update Process attributes

returns 1 if success or undef otherwise

    my $Success = $ProcessObject->ProcessUpdate(
        ID            => 123,             # mandatory
        EntityID      => 'P1'             # mandatory, exportable unique identifier
        Name          => 'NameOfProcess', # mandatory
        StateentityID => 'S1',
        Layout        => $LayoutHashRef,  # mandatory, diagram objects positions to be stored in
                                          #   YAML format
        Config        => $ConfigHashRef,  # mandatory, process configuration to be stored in YAML
                                          #   format
        UserID        => 123,             # mandatory
    );

=cut

sub ProcessUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID EntityID Name StateEntityID Layout Config UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if EntityID already exists
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT id FROM pm_process
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
            Message  => "The EntityID:$Param{Name} already exists for a process!",
        );
        return;
    }

    # check config valid format (at least it must contain the description)
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }
    if ( !$Param{Config}->{Description} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Description in Config!",
        );
        return;
    }

    # dump layout and config as string
    my $Layout = $Self->{YAMLObject}->Dump( Data => $Param{Layout} );
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Layout);
    utf8::upgrade($Config);

    # check if need to update db
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT entity_id, name, state_entity_id, layout, config
            FROM pm_process
            WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    my $CurrentEntityID;
    my $CurrentName;
    my $CurrentStateEntityID;
    my $CurrentLayout;
    my $CurrentConfig;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $CurrentEntityID      = $Data[0];
        $CurrentName          = $Data[1];
        $CurrentStateEntityID = $Data[2];
        $CurrentLayout        = $Data[3];
        $CurrentConfig        = $Data[4];
    }

    if ($CurrentEntityID) {

        return 1 if $CurrentEntityID eq $Param{EntityID}
            && $CurrentName eq $Param{Name}
            && $CurrentStateEntityID eq $Param{StateEntityID}
            && $CurrentLayout eq $Layout
            && $CurrentConfig eq $Config;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            UPDATE pm_process
            SET entity_id = ?, name = ?,  state_entity_id = ?, layout = ?, config = ?,
                change_time = current_timestamp,  change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Param{StateEntityID}, \$Layout, \$Config,
            \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Process',
    );

    return 1;
}

=item ProcessList()

get a Process list

    my $List = $ProcessObject->ProcessList(
        UseEntities     => 0,                   # default 0, 1 || 0. if 0 the return hash keys are
                                                #    the process IDs otherwise keys are the
                                                #    process entity IDs
        StateEntityIDs  => ['S1','S2'],         # optional, to filter proceses that match listed
                                                #    state entity IDs
        UserID          => 1,
    );

    Returns:

    $List = {
        1 => 'NameOfProcess',
    }

    or

    $List = {
        'P1' => 'NameOfProcess',
    }
=cut

sub ProcessList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    my $StateEntityIDsStrg;
    if ( !IsArrayRefWithData( $Param{StateEntityIDs} ) ) {
        $StateEntityIDsStrg = 'ALL';
    }
    else {
        $StateEntityIDsStrg = join ',', @{ $Param{StateEntityIDs} };
    }

    # check cache
    my $UseEntities = 0;
    if ( defined $Param{UseEntities} && $Param{UseEntities} ) {
        $UseEntities = 1;
    }

    my $CacheKey = 'ProcessList::UseEntities::' . $UseEntities . '::StateEntityIDs::'
        . $StateEntityIDsStrg;
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Process',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = '
            SELECT id, entity_id, name
            FROM pm_process ';
    if ( $StateEntityIDsStrg ne 'ALL' ) {

        my $StateEntityIDsStrgDB =
            join ',', map "'" . $Self->{DBObject}->Quote($_) . "'", @{ $Param{StateEntityIDs} };

        $SQL .= "WHERE state_entity_id IN ($StateEntityIDsStrgDB)";
    }

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

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
        Type  => 'ProcessManagement_Process',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ProcessListGet()

get a Process list with all process details

    my $List = $ProcessObject->ProcessListGet(
        UserID      => 1,
    );

Returns:

    $List = [
        {
            ID            => 123,
            EntityID      => 'P1',
            Name          => 'some name',
            StateEntityID => 'S1',
            State         => 'Active',
            Layout        => $LayoutHashRef,
            Config        => $ConfigHashRef,
            Activities    => ['A1','A2','A3'],
            CreateTime    => '2012-07-04 15:08:00',
            ChangeTime    => '2012-07-04 15:08:00',
        },
        {
            ID            => 456,
            EntityID      => 'P2',
            Name          => 'some name',
            StateEntityID => 'S1',
            State         => 'Active',
            Layout        => $LayoutHashRef,
            Config        => $ConfigHashRef,
            Activities    => ['A3','A4','A5'],
            CreateTime    => '2012-07-04 15:10:00',
            ChangeTime    => '2012-07-04 15:10:00',
        },
    ];

=cut

sub ProcessListGet {
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
    my $CacheKey = 'ProcessListGet';

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Process',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT id, entity_id
            FROM pm_process
            ORDER BY id',
    );

    my @ProcessIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ProcessIDs, $Row[0];
    }

    my @Data;
    for my $ItemID (@ProcessIDs) {

        my $ProcessData = $Self->ProcessGet(
            ID     => $ItemID,
            UserID => 1,
        );
        push @Data, $ProcessData;
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_Process',
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return \@Data;
}

=item ProcessDump()

gets a complete procesess information dump from the DB including: Process State, Activities,
ActivityDialogs, Transitions and TransitionActions

    my $ProcessDump = $ProcessObject->ProcessDump(
        ResultType  => 'SCALAR'                     # 'SCALAR' || 'HASH' || 'FILE'
        Location    => '/opt/otrs/var/myfile.txt'   # mandatry for ResultType = 'FILE'
        UserID      => 1,
    );

Returns:

    $ProcessDump = '
        $Self->{'Process'} = {
          'P1' => {
            'Name' => 'Process 1',
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'Path' => {
              'A1' => {
                'T1' => {
                  'Action' => [
                    'TA1',
                  ],
              }
            },
            'StartActivity' => 'A1',
            'StartActivityDialog' => 'AD1',
            'State' => 'S1'
          },
          # ...
        };

        $Self->{'Process::State'} = {
          'S1' => 'Active',
          'S2' => 'Inactive',
          'S3' => 'FadeAway'
        };

        $Self->{'Process::Activity'} = {
          'A1' => {
            'Name' => 'Activity 1'
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'ActivityDialog' => {
              '1' => 'AD1',
              }
            },
          },
          # ...
        };

        $Self->{'Process::ActivityDialog'} = {
          'AD1' => {
            'Name' => 'Activity Dialog 1',
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'DescriptionLong' => 'Longer description',
            'DescriptionShort' => 'Short description',
            'FieldOrder' => [
              'StateID',
              'DynamicField_Marke',
            ],
            'Fields' => {
              'StateID' => {
                'DefaultValue' => '1',
                'DescriptionLong' => 'Longer description',
                'DescriptionShort' => 'Short description',
                'Display' => '0'
              },
              'DynamicField_Marke' => {
                'DescriptionLong' => 'Longer description',
                'DescriptionShort' => 'Short description',
                'Display' => '2'
              },
            },
            #...
        };

        $Self->{'Process::Transition'} = {
          'T1' => {
            'Name' => 'Transition 1'
            'ChangeTime' => '2012-07-21 08:11:33',
            'CreateTime' => '2012-07-21 08:11:33',
            'Condition' => {
              'Type' => 'and',
              'Cond1' => {
                'Fields' => {
                  'DynamicField_Marke' => {
                    'Match' => 'Teststring',
                    'Type' => 'String',
                  },
                },
                'Type' => 'and',
              },
            },
          },
          # ...
        };

        $Self->{'Process::Action'} = {
          'TA1' => {
            'Name' => 'Queue Move',
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'Module' => 'Kernel::System::Process::Transition::Action::QueueMove',
            'Config' => {
              'NewOwner' => 'root@localhost',
              'TargetQueue' => 'Raw',
            },
          },
          # ...
        };
     ';

    my $ProcessDump = $ProcessObject->ProcessDump(
        ResultType  => 'HASH'                       # 'SCALAR' || 'HASH' || 'FILE'
        Location    => '/opt/otrs/var/myfile.txt'   # mandatry for ResultType = 'FILE'
        UserID      => 1,
    );

Returns:

    $ProcessDump = {
        Process => {
          'P1' => {
            'Name' => 'Process 1',
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'Path' => {
              'A1' => {
                'T1' => {
                  'Action' => [
                    'TA1',
                  ],
              }
            },
            'StartActivity' => 'A1',
            'StartActivityDialog' => 'AD1',
            'State' => 'S1'
          },
          # ...
        };

        State => {
          'S1' => 'Active',
          'S2' => 'Inactive',
          'S3' => 'FadeAway'
        };

        Activity => {
          'A1' => {
            'Name' => 'Activity 1'
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'ActivityDialog' => {
              '1' => 'AD1',
              }
            },
          },
          # ...
        };

        ActivityDialog => {
          'AD1' => {
            'Name' => 'Activity Dialog 1',
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'DescriptionLong' => 'Longer description',
            'DescriptionShort' => 'Short description',
            'FieldOrder' => [
              'StateID',
              'DynamicField_Marke',
            ],
            'Fields' => {
              'StateID' => {
                'DefaultValue' => '1',
                'DescriptionLong' => 'Longer description',
                'DescriptionShort' => 'Short description',
                'Display' => '0'
              },
              'DynamicField_Marke' => {
                'DescriptionLong' => 'Longer description',
                'DescriptionShort' => 'Short description',
                'Display' => '2'
              },
            },
            #...
        };

        Transition => {
          'T1' => {
            'Name' => 'Transition 1'
            'ChangeTime' => '2012-07-21 08:11:33',
            'CreateTime' => '2012-07-21 08:11:33',
            'Condition' => {
              'Type' => 'and',
              'Cond1' => {
                'Fields' => {
                  'DynamicField_Marke' => {
                    'Match' => 'Teststring',
                    'Type' => 'String',
                  },
                },
                'Type' => 'and',
              },
            },
          },
          # ...
        };

        TransitionAction => {
          'TA1' => {
            'Name' => 'Queue Move',
            'CreateTime' => '2012-07-21 08:11:33',
            'ChangeTime' => '2012-07-21 08:11:33',
            'Module' => 'Kernel::System::Process::Transition::Action::QueueMove',
            'Config' => {
              'NewOwner' => 'root@localhost',
              'TargetQueue' => 'Raw',
            },
          },
          # ...
        };
    }

    my $ProcessDump = $ProcessObject->ProcessDump(
        ResultType  => 'Location'                     # 'SCALAR' || 'HASH' || 'FILE'
        Location    => '/opt/otrs/var/myfile.txt'     # mandatry for ResultType = 'FILE'
        UserID      => 1,
    );

Returns:
    $ProcessDump = '/opt/otrs/var/myfile.txt';      # or undef if can't write the file

=cut

# TODO Add full tests
sub ProcessDump {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    if ( !defined $Param{ResultType} )
    {
        $Param{ResultType} = 'SCALAR';
    }

    if ( $Param{ResultType} eq 'FILE' ) {
        if ( !$Param{Location} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Location for ResultType \'FILE\'!',
            );

        }
    }

    # get States
    my %StateDump = %{ $Self->{StateObject}->StateList( UserID => 1 ) };

    # get Processes
    my $ProcessList = $Self->ProcessListGet( UserID => 1 );

    my %ProcessDump;

    PROCESS:
    for my $ProcessData ( @{$ProcessList} ) {

        next PROCESS if !IsHashRefWithData($ProcessData);

        $ProcessDump{ $ProcessData->{EntityID} } = {
            Name                => $ProcessData->{Name},
            CreateTime          => $ProcessData->{CreateTime},
            ChangeTime          => $ProcessData->{ChangeTime},
            StateEntityID       => $ProcessData->{StateEntityID},
            State               => $ProcessData->{State},
            StartActivity       => $ProcessData->{Config}->{StartActivity} || '',
            StartActivityDialog => $ProcessData->{Config}->{StartActivityDialog} || '',
            Path                => $ProcessData->{Config}->{Path} || {},
        };
    }

    # get Activities
    my $ActivitiesList = $Self->{ActivityObject}->ActivityListGet( UserID => 1 );

    my %ActivityDump;

    ACTIVITY:
    for my $ActivityData ( @{$ActivitiesList} ) {

        next ACTIVITY if !IsHashRefWithData($ActivityData);

        $ActivityDump{ $ActivityData->{EntityID} } = {
            ID             => $ActivityData->{ID},
            Name           => $ActivityData->{Name},
            CreateTime     => $ActivityData->{CreateTime},
            ChangeTime     => $ActivityData->{ChangeTime},
            ActivityDialog => $ActivityData->{Config}->{ActivityDialog} || '',
        };
    }

    # get ActivityDialogs
    my $ActivityDialogsList = $Self->{ActivityDialogObject}->ActivityDialogListGet( UserID => 1 );

    my %ActivityDialogDump;

    ACTIVITYDIALOG:
    for my $ActivityDialogData ( @{$ActivityDialogsList} ) {

        next ACTIVITY if !IsHashRefWithData($ActivityDialogData);

        $ActivityDialogDump{ $ActivityDialogData->{EntityID} } = {
            Name             => $ActivityDialogData->{Name},
            CreateTime       => $ActivityDialogData->{CreateTime},
            ChangeTime       => $ActivityDialogData->{ChangeTime},
            Interface        => $ActivityDialogData->{Config}->{Interface} || '',
            DescriptionShort => $ActivityDialogData->{Config}->{DescripionShort} || '',
            DescriptionLong  => $ActivityDialogData->{Config}->{DescripionLong} || '',
            Fields           => $ActivityDialogData->{Config}->{Fields} || {},
            FieldOrder       => $ActivityDialogData->{Config}->{FieldOrder} || [],
            Permission       => $ActivityDialogData->{Config}->{Permission} || '',
            RequiredLock     => $ActivityDialogData->{Config}->{RequiredLock} || '',
            SubmitAdviceText => $ActivityDialogData->{Config}->{SubmitAdviceText} || '',
            SubmitButtonText => $ActivityDialogData->{Config}->{SubmitButtonText} || '',
        };
    }

    # get Transitions
    my $TransitionsList = $Self->{TransitionObject}->TransitionListGet( UserID => 1 );

    my %TransitionDump;

    TRANSITION:
    for my $TransitionData ( @{$TransitionsList} ) {

        next TRANSITION if !IsHashRefWithData($TransitionData);

        $TransitionDump{ $TransitionData->{EntityID} } = {
            Name       => $TransitionData->{Name},
            CreateTime => $TransitionData->{CreateTime},
            ChangeTime => $TransitionData->{ChangeTime},
            Condition  => $TransitionData->{Config}->{Condition} || {},
        };
    }

    # get TransitionActions
    my $TransitionActionsList
        = $Self->{TransitionActionObject}->TransitionActionListGet( UserID => 1 );

    my %TransitionActionDump;

    TRANSITIONACTION:
    for my $TransitionActionData ( @{$TransitionActionsList} ) {

        next TRANSITIONACTION if !IsHashRefWithData($TransitionActionData);

        $TransitionActionDump{ $TransitionActionData->{EntityID} } = {
            Name       => $TransitionActionData->{Name},
            CreateTime => $TransitionActionData->{CreateTime},
            ChangeTime => $TransitionActionData->{ChangeTime},
            Module     => $TransitionActionData->{Config}->{Module} || '',
            Config     => $TransitionActionData->{Config}->{Config} || {},
        };
    }

    # delete cache (this will also delete the cache for display or hide AgentTicketProcess menu
    # item)
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Process',
    );

    # return Hash useful for JSON
    if ( $Param{ResultType} eq 'HASH' ) {

        return {
            'Process'          => \%ProcessDump,
            'State'            => \%StateDump,
            'Activity'         => \%ActivityDump,
            'ActivityDialog'   => \%ActivityDialogDump,
            'Transition'       => \%TransitionDump,
            'TransitionAction' => \%TransitionActionDump,
        };

    }
    else {

        # create output

        my $Output .= $Self->_ProcessItemOutput(
            Key   => "Process",
            Value => \%ProcessDump,
        );

        $Output .= $Self->_ProcessItemOutput(
            Key   => 'Process::State',
            Value => \%StateDump,
        );

        $Output .= $Self->_ProcessItemOutput(
            Key   => 'Process::Activity',
            Value => \%ActivityDump,
        );

        $Output .= $Self->_ProcessItemOutput(
            Key   => 'Process::ActivityDialog',
            Value => \%ActivityDialogDump,
        );

        $Output .= $Self->_ProcessItemOutput(
            Key   => 'Process::Transition',
            Value => \%TransitionDump,
        );

        $Output .= $Self->_ProcessItemOutput(
            Key   => 'Process::TransitionAction',
            Value => \%TransitionActionDump,
        );

        # return a scalar variable with all config as test
        if ( $Param{ResultType} ne 'FILE' ) {

            return $Output;
        }

        # return a file location
        else {

            # get current time for the file comment
            my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();

            # get user data of the current user to use for the file comment
            $Self->{UserObject} = Kernel::System::User->new( %{$Self} );
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Param{UserID},
            );

            # remove home from location path to show in file comment
            my $Home     = $Self->{ConfigObject}->Get('Home');
            my $Location = $Param{Location};
            $Location =~ s{$Home\/}{}xmsg;

            # build comment (therefore we need to trick out the filter)
            my $FileStart = <<'EOF';
# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZProcessManagement;
use strict;
use warnings;
use utf8;
sub Load {
    my ($File, $Self) = @_;
EOF

            my $FileEnd = <<'EOF';
}
1;
EOF

            $Output = $FileStart . $Output . $FileEnd;

            my $FileLocation = $Self->{MainObject}->FileWrite(
                Location => $Param{Location},
                Content  => \$Output,
                Mode     => 'utf8',
                Type     => 'Local',
            );

            return $FileLocation
        }
    }
}

=item ProcessImport()

import a process YAML file/content

    my %ProcessImport = $ProcessObject->ProcessImport(
        Content                   => $YAMLContent, # mandatory, YAML format
        OverwriteExistingEntities => 0,            # 0 || 1
        UserID                    => 1,            # mandatory
    );

Returns:

    %ProcessImport = (
        Message => 'The Mesage to show.', # error or success message
        Success => 1,                     # 1 if success or undef otherwise
    );

=cut

# TODO Add full tests
sub ProcessImport {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Content UserID)) {

        # check needed stuff
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ProcessData = $Self->{YAMLObject}->Load( Data => $Param{Content} );
    if ( ref $ProcessData ne 'HASH' ) {
        return (
            Message =>
                "Couldn't read process configuration file. Please make sure you file is valid.",
        );
    }

    # collect all used fields and make sure they're present
    my @UsedDynamicFields;
    for my $ActivityDialog ( sort keys %{ $ProcessData->{ActivityDialogs} } ) {
        for my $FieldName (
            sort
            keys %{ $ProcessData->{ActivityDialogs}->{$ActivityDialog}->{Config}->{Fields} }
            )
        {
            if ( $FieldName =~ s{DynamicField_(\w+)}{$1}xms ) {
                push @UsedDynamicFields, $FieldName;
            }
        }
    }

    # get all present dynamic fields and check if the fields used in the config are beyond them
    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldList(
        ResultType => 'HASH',
    );
    my @PresentDynamicFieldNames = values %{$DynamicFieldList};

    my @MissingDynamicFieldNames;
    for my $UsedDynamicFieldName (@UsedDynamicFields) {
        if ( !grep { $_ eq $UsedDynamicFieldName } @PresentDynamicFieldNames ) {
            push @MissingDynamicFieldNames, $UsedDynamicFieldName;
        }
    }

    if ( $#MissingDynamicFieldNames > -1 ) {
        my $MissingDynamicFields = join( ', ', @MissingDynamicFieldNames );
        return (
            Message =>
                "The following dynamic fields are missing: $MissingDynamicFields. Import has been stopped.",
        );
    }

    # make sure all activities and dialogs are present
    my @UsedActivityDialogs;
    for my $ActivityEntityID ( @{ $ProcessData->{Process}->{Activities} } ) {
        if ( ref $ProcessData->{Activities}->{$ActivityEntityID} ne 'HASH' ) {
            return (
                Message => "Missing data for Activity $ActivityEntityID.",
            );
        }
        else {
            for my $UsedActivityDialog (
                @{ $ProcessData->{Activities}->{$ActivityEntityID}->{ActivityDialogs} }
                )
            {
                push @UsedActivityDialogs, $UsedActivityDialog;
            }
        }
    }

    for my $ActivityDialogEntityID (@UsedActivityDialogs) {
        if ( ref $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID} ne 'HASH' ) {
            return (
                Message => "Missing data for ActivityDialog $ActivityDialogEntityID.",
            );
        }
    }

    # make sure all transitions are present
    for my $TransitionEntityID ( @{ $ProcessData->{Process}->{Transitions} } ) {
        if ( ref $ProcessData->{Transitions}->{$TransitionEntityID} ne 'HASH' ) {
            return (
                Message => "Missing data for Transition $TransitionEntityID.",
            );
        }
    }

    # make sure all transition actions are present
    for my $TransitionActionEntityID ( @{ $ProcessData->{Process}->{TransitionActions} } ) {
        if ( ref $ProcessData->{TransitionActions}->{$TransitionActionEntityID} ne 'HASH' ) {
            return (
                Message => "Missing data for TransitionAction $TransitionActionEntityID.",
            );
        }
    }

    # add activity dialogs
    my %ActivityDialogMapping;
    for my $ActivityDialogEntityID ( sort keys %{ $ProcessData->{ActivityDialogs} } ) {

        my @ExistingADs = @{
            $Self->{ActivityDialogObject}
                ->ActivityDialogListGet( UserID => $Param{UserID} ) || []
        };
        @ExistingADs = grep {
            $_->{EntityID} eq
                $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{EntityID}
        } @ExistingADs;
        if ( $Param{OverwriteExistingEntities} && $ExistingADs[0] ) {
            my $Success = $Self->{ActivityDialogObject}->ActivityDialogUpdate(
                %{ $ExistingADs[0] },
                Name   => $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Name},
                Config => $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Config},
                UserID => $Param{UserID},
            );

            if ( !$Success ) {
                return (
                    Message =>
                        "ActivityDialog '$ActivityDialogEntityID' could not be updated. Stopping import.",
                );
            }
        }
        else {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'ActivityDialog',
                UserID     => $Param{UserID},
            );

            my $ID = $Self->{ActivityDialogObject}->ActivityDialogAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Name},
                Config   => $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Config},
                UserID   => $Param{UserID},
            );

            if ( !$ID ) {
                return (
                    Message => "ActivityDialog '"
                        . $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $ActivityDialogMapping{$ActivityDialogEntityID} = $EntityID;
        }
    }

    # add transition actions
    my %TransitionActionMapping;
    for my $TransitionActionEntityID ( sort keys %{ $ProcessData->{TransitionActions} } ) {

        my @ExistingTAs = @{
            $Self->{TransitionActionObject}
                ->TransitionActionListGet( UserID => $Param{UserID} ) || []
        };
        @ExistingTAs = grep {
            $_->{EntityID} eq
                $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{EntityID}
        } @ExistingTAs;
        if ( $Param{OverwriteExistingEntities} && $ExistingTAs[0] ) {
            my $Success = $Self->{TransitionActionObject}->TransitionActionUpdate(
                %{ $ExistingTAs[0] },
                Name => $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Name},
                Config =>
                    $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Config},
                UserID => $Param{UserID},
            );

            if ( !$Success ) {
                return (
                    Message =>
                        "TransitionAction '$TransitionActionEntityID' could not be updated. Stopping import.",
                );
            }

        }
        else {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'TransitionAction',
                UserID     => $Param{UserID},
            );

            my $ID = $Self->{TransitionActionObject}->TransitionActionAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Name},
                Config =>
                    $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Config},
                UserID => $Param{UserID},
            );

            if ( !$ID ) {
                return (
                    Message => "TransitionAction '"
                        . $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $TransitionActionMapping{$TransitionActionEntityID} = $EntityID;
        }
    }

    # add transitions
    my %TransitionMapping;
    for my $TransitionEntityID ( sort keys %{ $ProcessData->{Transitions} } ) {

        my @ExistingTs
            = @{
            $Self->{TransitionObject}->TransitionListGet( UserID => $Param{UserID} )
                || []
            };
        @ExistingTs = grep {
            $_->{EntityID} eq $ProcessData->{Transitions}->{$TransitionEntityID}->{EntityID}
        } @ExistingTs;
        if ( $Param{OverwriteExistingEntities} && $ExistingTs[0] ) {
            my $Success = $Self->{TransitionObject}->TransitionUpdate(
                %{ $ExistingTs[0] },
                Name   => $ProcessData->{Transitions}->{$TransitionEntityID}->{Name},
                Config => $ProcessData->{Transitions}->{$TransitionEntityID}->{Config},
                UserID => $Param{UserID},
            );

            if ( !$Success ) {
                return (
                    Message =>
                        "Transition '$TransitionEntityID' could not be updated. Stopping import.",
                );
            }
        }
        else {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'Transition',
                UserID     => $Param{UserID},
            );

            my $ID = $Self->{TransitionObject}->TransitionAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{Transitions}->{$TransitionEntityID}->{Name},
                Config   => $ProcessData->{Transitions}->{$TransitionEntityID}->{Config},
                UserID   => $Param{UserID},
            );

            if ( !$ID ) {
                return (
                    Message => "Transition '"
                        . $ProcessData->{Transitions}->{$TransitionEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $TransitionMapping{$TransitionEntityID} = $EntityID;
        }
    }

    # add activities
    my %ActivityMapping;
    for my $ActivityEntityID ( sort keys %{ $ProcessData->{Activities} } ) {

        # search and replace ocurrences of old ActivityDialog ids by the new ones
        my $Config = $Self->{YAMLObject}->Dump(
            Data => $ProcessData->{Activities}->{$ActivityEntityID}->{Config}
        );
        for my $OldEntityID ( sort keys %ActivityDialogMapping ) {
            $Config =~ s{\Q$OldEntityID\E}{$ActivityDialogMapping{$OldEntityID}}xmsg;
        }
        $Config = $Self->{YAMLObject}->Load( Data => $Config );

        my @ExistingAs
            = @{ $Self->{ActivityObject}->ActivityListGet( UserID => $Param{UserID} ) || [] };
        @ExistingAs = grep {
            $_->{EntityID} eq $ProcessData->{Activities}->{$ActivityEntityID}->{EntityID}
        } @ExistingAs;
        if ( $Param{OverwriteExistingEntities} && $ExistingAs[0] ) {
            my $Success = $Self->{ActivityObject}->ActivityUpdate(
                %{ $ExistingAs[0] },
                Name   => $ProcessData->{Activities}->{$ActivityEntityID}->{Name},
                Config => $Config,
                UserID => $Param{UserID},
            );

            if ( !$Success ) {
                return (
                    Message =>
                        "Activity '$ActivityEntityID' could not be updated. Stopping import.",
                );
            }
        }
        else {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'Activity',
                UserID     => $Param{UserID},
            );

            my $ID = $Self->{ActivityObject}->ActivityAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{Activities}->{$ActivityEntityID}->{Name},
                Config   => $Config,
                UserID   => $Param{UserID},
            );

            if ( !$ID ) {
                return (
                    Message => "Activity '"
                        . $ProcessData->{Activities}->{$ActivityEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $ActivityMapping{$ActivityEntityID} = $EntityID;
        }
    }

    # Try to find Entities correctly in YAML
    my $DelimiterBefore = '(^|\s|\'|"|:)';
    my $DelimiterAfter  = '($|\s|\'|"|:)';

    # layout: search and replace ocurrences of old Activity ids by the new ones
    my $Layout = $Self->{YAMLObject}->Dump( Data => $ProcessData->{Process}->{Layout} );

    # Process all mapping entries at once with one big regex. Otherwise there might be errors
    #   with duplicated keys like ( A4 => A6, A6 => A11). In this case, A4 would also incorrectly
    #   be converted to A11.
    if (%ActivityMapping) {
        my $OldEntityIDs
            = '(' . join( '|', map { quotemeta($_) } sort keys %ActivityMapping ) . ')';
        $Layout =~ s{
            $DelimiterBefore
            $OldEntityIDs
            $DelimiterAfter
        }{$1$ActivityMapping{$2}$3}xmsg;
    }
    $Layout = $Self->{YAMLObject}->Load( Data => $Layout );

    # config: search and replace ocurrences of old object ids by the new ones
    my $Config = $Self->{YAMLObject}->Dump( Data => $ProcessData->{Process}->{Config} );

    # Process all mappings at once: see comment above.
    my %Mapping = (
        %ActivityMapping,   %ActivityDialogMapping,
        %TransitionMapping, %TransitionActionMapping
    );
    if (%Mapping) {
        my $OldEntityIDs = '(' . join( '|', map { quotemeta($_) } sort keys %Mapping ) . ')';
        $Config =~ s{
            $DelimiterBefore
            $OldEntityIDs
            $DelimiterAfter
        }{$1$Mapping{$2}$3}xmsg;
    }
    $Config = $Self->{YAMLObject}->Load( Data => $Config );

    my $ID;
    my @ExistingProcesses
        = @{ $Self->ProcessListGet( UserID => $Param{UserID} ) || [] };
    @ExistingProcesses
        = grep { $_->{EntityID} eq $ProcessData->{Process}->{EntityID} } @ExistingProcesses;

    if ( $Param{OverwriteExistingEntities} && $ExistingProcesses[0] ) {
        $Self->ProcessUpdate(
            %{ $ExistingProcesses[0] },
            Layout => $Layout,
            Config => $Config,
            UserID => $Param{UserID},
        );

        $ID = $ExistingProcesses[0]->{ID};
    }
    else {

        # generate EntityID for the process itself
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'Process',
            UserID     => $Param{UserID},
        );

        # now add the process
        $ID = $Self->ProcessAdd(
            EntityID      => $EntityID,
            Name          => $ProcessData->{Process}->{Name},
            StateEntityID => $ProcessData->{Process}->{StateEntityID},
            Layout        => $Layout,
            Config        => $Config,
            UserID        => $Param{UserID},
        );
    }

    if ( !$ID ) {

        # roll back all changes
        for my $ActivityDialogEntityID ( values %ActivityDialogMapping ) {

            my $ActivityDialogData = $Self->{ActivityDialogObject}->ActivityDialogGet(
                EntityID => $ActivityDialogEntityID,
                UserID   => $Param{UserID},
            );
            my $Success = $Self->{ActivityDialogObject}->ActivityDialogDelete(
                ID     => $ActivityDialogData->{ID},
                UserID => $Param{UserID},
            );
            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "ActivityDialog '"
                        . $ActivityDialogData->{Name}
                        . "' could not be deleted.",
                );
            }
        }
        for my $TransitionActionEntityID ( values %TransitionActionMapping ) {

            my $TransitionActionData = $Self->{TransitionActionObject}->TransitionActionGet(
                EntityID => $TransitionActionEntityID,
                UserID   => $Param{UserID},
            );
            my $Success = $Self->{TransitionActionObject}->TransitionActionDelete(
                ID     => $TransitionActionData->{ID},
                UserID => $Param{UserID},
            );
            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "TransitionAction '"
                        . $TransitionActionData->{Name}
                        . "' could not be deleted.",
                );
            }
        }
        for my $TransitionEntityID ( values %TransitionMapping ) {

            my $TransitionData = $Self->{TransitionObject}->TransitionGet(
                EntityID => $TransitionEntityID,
                UserID   => $Param{UserID},
            );
            my $Success = $Self->{TransitionObject}->TransitionDelete(
                ID     => $TransitionData->{ID},
                UserID => $Param{UserID},
            );
            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Transition '"
                        . $TransitionData->{Name}
                        . "' could not be deleted.",
                );
            }
        }
        for my $ActivityEntityID ( values %ActivityMapping ) {

            my $ActivityData = $Self->{ActivityObject}->ActivityGet(
                EntityID => $ActivityEntityID,
                UserID   => $Param{UserID},
            );
            my $Success = $Self->{ActivityObject}->ActivityDelete(
                ID     => $ActivityData->{ID},
                UserID => $Param{UserID},
            );
            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Activity '" . $ActivityData->{Name} . "' could not be deleted.",
                );
            }
        }

        return (
            Message => "Process could not be imported. All changes have been rolled back.",
        );
    }
    else {

        return (
            Message => 'Process '
                . $ProcessData->{Process}->{Name}
                . ' and all its data has been imported sucessfully.',
            Success => 1,
        );
    }
}

# TODO Add POD
sub _ProcessItemOutput {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{MainObject}->Dump(
        $Param{Value},
    );

    my $Key = "\$Self->{'$Param{Key}'}";
    $Output =~ s{\A \$VAR1}{$Key}mxs;

    return $Output . "\n";
}
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
