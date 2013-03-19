# --
# Kernel/System/ProcessManagement/Activity/ActivityDialog.pm - Process Management DB ActivityDialog backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::ActivityDialog;

use strict;
use warnings;

use Kernel::System::YAML;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::ProcessManagement::DB::ActivityDialog.pm

=head1 SYNOPSIS

Process Management DB ActivityDialog backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an ActivityDialog object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::ProcessManagement::DB::ActivityDialog;

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
    my $ActivityDialogObject = Kernel::System::ProcessManagement::DB::ActivityDialog->new(
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

    return $Self;
}

=item ActivityDialogAdd()

add new ActivityDialog

returns the id of the created activity dialog if success or undef otherwise

    my $ID = $ActivityDialogObject->ActivityDialogAdd(
        EntityID    => 'AD1'                   # mandatory, exportable unique identifier
        Name        => 'NameOfActivityDialog', # mandatory
        Config      => $ConfigHashRef,         # mandatory, activity dialog configuration to be
                                               #    stored in YAML format
        UserID      => 123,                    # mandatory
    );

Returns:

    $ID = 567;

=cut

sub ActivityDialogAdd {
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
            FROM pm_activity_dialog
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
            Message  => "The EntityID:$Param{EntityID} already exists for an activity dialog!"
        );
        return;
    }

    # check config valid format (at least it must contain the description short, fields and field
    # order)
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config needs to be a valid Hash reference!",
        );
        return;
    }
    for my $Needed (qw(DescriptionShort Fields FieldOrder)) {
        if ( !$Param{Config}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in Config!",
            );
            return;
        }
    }

    # check config formats
    if ( ref $Param{Config}->{Fields} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config Fields must be a Hash!",
        );
        return;
    }
    if ( ref $Param{Config}->{FieldOrder} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config Fields must be an Array!",
        );
        return;
    }

    # dump layout and config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO pm_activity_dialog ( entity_id, name, config, create_time,
                create_by, change_time, change_by )
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM pm_activity_dialog WHERE entity_id = ?',
        Bind => [ \$Param{EntityID} ],
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_ActivityDialog',
    );

    return if !$ID;

    return $ID;
}

=item ActivityDialogDelete()

delete an ActivityDialog

returns 1 if success or undef otherwise

    my $Success = $ActivityDialogObject->ActivityDialogDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub ActivityDialogDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my $ActivityDialog = $Self->ActivityDialogGet(
        ID     => $Param{ID},
        UserID => 1,
    );
    return if !IsHashRefWithData($ActivityDialog);

    # delete activity dialog
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM pm_activity_dialog WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_ActivityDialog',
    );

    return 1;
}

=item ActivityDialogGet()

get Activity Dialog attributes

    my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
        ID            => 123,            # ID or EntityID is needed
        EntityID      => 'P1',
        UserID        => 123,            # mandatory
    );

Returns:

    $ActivityDialog = {
        ID           => 123,
        EntityID     => 'AD1',
        Name         => 'some name',
        Config       => $ConfigHashRef,
        CreateTime   => '2012-07-04 15:08:00',
        ChangeTime   => '2012-07-04 15:08:00',
    };

=cut

sub ActivityDialogGet {
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

    # check cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'ActivityDialogGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'ActivityDialogGet::EntityID::' . $Param{EntityID};
    }

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_ActivityDialog',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_activity_dialog
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, entity_id, name, config, create_time, change_time
                FROM pm_activity_dialog
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

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_ActivityDialog',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ActivityDialogUpdate()

update ActivityDialog attributes

returns 1 if success or undef otherwise

    my $Success = $ActivityDialogObject->ActivityDialogUpdate(
        ID          => 123,                    # mandatory
        EntityID    => 'AD1'                   # mandatory, exportable unique identifier
        Name        => 'NameOfActivityDialog', # mandatory
        Config      => $ConfigHashRef,         # mandatory, actvity dialog configuration to be
                                               #   stored in YAML format
        UserID      => 123,                    # mandatory
    );

=cut

sub ActivityDialogUpdate {
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
            SELECT id FROM pm_activity_dialog
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
            Message  => "The EntityID:$Param{Name} already exists for an ActivityDialog!",
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
    for my $Needed (qw(DescriptionShort Fields FieldOrder)) {
        if ( !$Param{Config}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in Config!",
            );
            return;
        }
    }

    # check config formats
    if ( ref $Param{Config}->{Fields} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config Fields must be a Hash!",
        );
        return;
    }
    if ( ref $Param{Config}->{FieldOrder} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config Fields must be an Array!",
        );
        return;
    }

    # dump layout and config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    # check if need to update db
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT entity_id, name, config
            FROM pm_activity_dialog
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
            UPDATE pm_activity_dialog
            SET entity_id = ?, name = ?,  config = ?, change_time = current_timestamp,
                change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{EntityID}, \$Param{Name}, \$Config, \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ProcessManagement_ActivityDialog',
    );

    return 1;
}

=item ActivityDialogList()

get an ActivityDialog list

    my $List = $ActivityDialogObject->ActivityDialogList(
        UseEntities => 0,                       # default 0, 1 || 0. if 0 the return hash keys are
                                                #    the activity dialog IDs otherwise keys are the
                                                #    activity dialog entity IDs
        UserID      => 1,
    );

    Returns:

    $List = {
        1 => 'NameOfActivityDialog',
    }

    or

    $List = {
        'AD1' => 'NameOfActivityDialog',
    }
=cut

sub ActivityDialogList {
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

    my $CacheKey = 'ActivityDialogList::UseEntities::' . $UseEntities;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_ActivityDialog',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = '
            SELECT id, entity_id, name
            FROM pm_activity_dialog';

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
        Type  => 'ProcessManagement_ActivityDialog',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ActivityDialogListGet()

get an Activity Dialog list with all activity dialog details

    my $List = $ActivityDialogObject->ActivityDialogListGet(
        UserID      => 1,
    );

Returns:

    $List = [
        {
            ID             => 123,
            EntityID       => 'AD1',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            CreateTime     => '2012-07-04 15:08:00',
            ChangeTime     => '2012-07-04 15:08:00',
        }
        {
            ID             => 456,
            EntityID       => 'AD2',
            Name           => 'some name',
            Config         => $ConfigHashRef,
            CreateTime     => '2012-07-04 15:09:00',
            ChangeTime     => '2012-07-04 15:09:00',
        }
    ];

=cut

sub ActivityDialogListGet {
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
    my $CacheKey = 'ActivityDialogListGet';

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ProcessManagement_ActivityDialog',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT id, entity_id
            FROM pm_activity_dialog
            ORDER BY id',
    );

    my @ActivityDialogIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ActivityDialogIDs, $Row[0];
    }

    my @Data;
    for my $ItemID (@ActivityDialogIDs) {

        my $ActivityDialogData = $Self->ActivityDialogGet(
            ID     => $ItemID,
            UserID => 1,
        );
        push @Data, $ActivityDialogData;
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ProcessManagement_ActivityDialog',
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

=cut
