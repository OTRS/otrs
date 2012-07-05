# --
# Kernel/System/ProcessManagement/Process.pm - Process Management DB Process backend
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Process.pm,v 1.3 2012-07-05 20:18:29 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Process;

use strict;
use warnings;

use YAML;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);

use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::Process::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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
        TimeObject   => $TimeObject,
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
    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );

    $Self->{ActivityObject} = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );
    $Self->{StateObject} = Kernel::System::ProcessManagement::DB::Process::State->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('Process::CacheTTL') || 3600 );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( !$Self->{DBObject}->GetDatabaseFunction('CaseInsensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    return $Self;
}

=item ProcessAdd()

add new Process

returns the id of the created process if success or undef otherwise

    my $ID = $ProcessObject->ProcessAdd(
        EntityID    => 'P1'             # mandatory, exportable unique identifier
        Name        => 'NameOfProcess', # mandatory
        StateID     => 1,
        Layout      => $LayoutHashRef,  # mandatory, diagram objects positions to be stored in
                                        #   YAML format
        Config      => $ConfigHashRef,  # mandatory, process configuration to be stored in YAML
                                        #   format
        UserID      => 123,             # mandatory
    );

Returns:

    $ID = 567;

=cut

sub ProcessAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(EntityID Name StateID Layout Config UserID)) {
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
    my $Layout = YAML::Dump( $Param{Layout} );
    my $Config = YAML::Dump( $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Layout);
    utf8::upgrade($Config);

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO pm_process ( entity_id, name, state_id, layout, config, create_time,
                create_by, change_time, change_by )
            VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Param{StateID}, \$Layout, \$Config, \$Param{UserID},
            \$Param{UserID},
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
        ID            => 123,            # ID or EntityID is needed
        EntityID      => 'P1',
        ActivityNames => 1,              # default 0, 1 || 0, if 0 returns an Activities array
                                         #     with the activity entity IDs, if 1 returns an
                                         #     Activities hash with the activity entity IDs as
                                         #     keys and Activity Names as values
        UserID        => 123,            # mandatory
    );

Returns:

    $Process = {
        ID           => 123,
        EntityID     => 'P1',
        Name         => 'some name',
        StateID      => 1,
        State        => 'Active',
        Layout       => $LayoutHashRef,
        Config       => $ConfigHashRef,
        Activities => ['A1','A2','A3'],
        CreateTime   => '2012-07-04 15:08:00',
        ChangeTime   => '2012-07-04 15:08:00',
    };

    $Process = {
        ID           => 123,
        EntityID     => 'P1',
        Name         => 'some name',
        StateID      => 1,
        State        => 'Active',
        Layout       => $LayoutHashRef,
        Config       => $ConfigHashRef,
        Activities => {
            'A1' => 'Activity1',
            'A2' => 'Activity2',
            'A3' => 'Activity3',
        };
        CreateTime   => '2012-07-04 15:08:00',
        ChangeTime   => '2012-07-04 15:08:00',
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

    # check cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'ProcessGet::ID::' . $Param{ID} . '::ActivityNames::'
            . $ActivityNames;
    }
    else {
        $CacheKey = 'ProcessGet::EntityID::' . $Param{EntityID} . '::ActivityNames::'
            . $ActivityNames;
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
                SELECT id, entity_id, name, state_id, layout, config, create_time, change_time
                FROM pm_process
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, entity_id, name, state_id, layout, config, create_time, change_time
                FROM pm_process
                WHERE entity_id = ?',
            Bind  => [ \$Param{EntityID} ],
            Limit => 1,
        );
    }

    my %Data;

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        my $Layout = YAML::Load( $Data[4] );
        my $Config = YAML::Load( $Data[5] );

        %Data = (
            ID         => $Data[0],
            EntityID   => $Data[1],
            Name       => $Data[2],
            StateID    => $Data[3],
            Layout     => $Layout,
            Config     => $Config,
            CreateTime => $Data[6],
            ChangeTime => $Data[7],

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

    $Data{State} = $Self->{StateObject}->StateLookup(
        ID     => $Data{StateID},
        UserID => 1,
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

#TODO Add tests

=item ProcessUpdate()

update Process attributes

returns 1 if success or undef otherwise

    my $Success = $ProcessObject->ProcessUpdate(
        ID          => 123,             # mandatory
        EntityID    => 'P1'             # mandatory, exportable unique identifier
        Name        => 'NameOfProcess', # mandatory
        StateID     => 1,
        Layout      => $LayoutHashRef,  # mandatory, diagram objects positions to be stored in
                                        #   YAML format
        Config      => $ConfigHashRef,  # mandatory, process configuration to be stored in YAML
                                        #   format
        UserID      => 123,             # mandatory
    );

=cut

sub ProcessUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID EntityID Name StateID Layout Config UserID)) {
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
    my $Layout = YAML::Dump( $Param{Layout} );
    my $Config = YAML::Dump( $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Layout);
    utf8::upgrade($Config);

    # check if need to update db
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT entity_id, name, state_id, layout, config
            FROM pm_process
            WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    my $CurrentEntityID;
    my $CurrentName;
    my $CurrentStateID;
    my $CurrentLayout;
    my $CurrentConfig;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $CurrentEntityID = $Data[0];
        $CurrentName     = $Data[1];
        $CurrentStateID  = $Data[2];
        $CurrentLayout   = $Data[3];
        $CurrentConfig   = $Data[4];
    }

    if ($CurrentEntityID) {

        return 1 if $CurrentEntityID eq $Param{EntityID}
                && $CurrentName    eq $Param{Name}
                && $CurrentStateID eq $Param{StateID}
                && $CurrentLayout  eq $Layout
                && $CurrentConfig  eq $Config;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            UPDATE pm_process
            SET entity_id = ?, name = ?,  state_id = ?, layout = ?, config = ?,
                change_time = current_timestamp,  change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Param{StateID}, \$Layout, \$Config, \$Param{UserID},
            \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_Process',
    );

    return 1;
}

#TODO add tests

=item ProcessList()

get a Process list

    my $List = $ProcessObject->ProcessList(
        UseEntities => 0,                       # default 0, 1 || 0. if 0 the return hash keys are
                                                #    the process IDs otherwise keys are the
                                                #    process entity IDs
        StateIDs    => [1,2],                   # optional, to filter proceses that match listed
                                                #    state IDs
        UserID      => 1,
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

    my $StateIDsStrg;
    if ( !IsArrayRefWithData( $Param{StateIDs} ) ) {
        $StateIDsStrg = 'ALL';
    }
    else {
        $StateIDsStrg = join ',', @{ $Param{StateIDs} };
    }

    # check cache
    my $UseEntities = 0;
    if ( defined $Param{UseEntities} && $Param{UseEntities} ) {
        $UseEntities = 1;
    }

    my $CacheKey = 'ActivityList::UseEntities::' . $UseEntities . '::StateIDs::' . $StateIDsStrg;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_Activity',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = '
            SELECT id, entity_id, name
            FROM pm_process ';
    if ( $StateIDsStrg ne 'ALL' ) {
        $SQL .= "WHERE state_id IN ($StateIDsStrg)";
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.3 $ $Date: 2012-07-05 20:18:29 $

=cut
