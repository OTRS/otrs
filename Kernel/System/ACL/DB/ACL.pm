# --
# Kernel/System/ACL/DB/ACL.pm - ACL DB backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ACL::DB::ACL;

use strict;
use warnings;

use Kernel::System::YAML;

use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::User;

=head1 NAME

Kernel::System::ACL::DB::ACL.pm

=head1 SYNOPSIS

ACL DB ACL backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a ACL object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::ACL::DB::ACL;

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
    my $ACLObject = Kernel::System::ACL::DB::ACL->new(
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
    $Self->{UserObject}  = Kernel::System::User->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('ACL::CacheTTL') || 3600 );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( !$Self->{DBObject}->GetDatabaseFunction('CaseInsensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    return $Self;
}

=item ACLAdd()

add new ACL

returns the id of the created ACL if success or undef otherwise

    my $ID = $ACL->ACLAdd(
        Name           => 'NameOfACL'           # mandatory
        Comment        => 'Comment',            # optional
        Description    => 'Description',        # optional
        StopAfterMatch => 1,                    # optional
        ConfigMatch    => $ConfigMatchHashRef,  # optional
        ConfigChange   => $ConfigChangeHashRef, # optional
        ValidID        => 1,                    # mandatory
        UserID         => 123,                  # mandatory
    );

Returns:

    $ID = 567;

=cut

sub ACLAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Name ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # define Description field if not present
    $Param{Description} = '' if !defined $Param{Description};

    my $ConfigMatch  = '';
    my $ConfigChange = '';

    if ( $Param{ConfigMatch} ) {

        if ( !IsHashRefWithData( $Param{ConfigMatch} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ConfigMatch needs to be a valid hash with data!",
            );
            return;
        }

        $ConfigMatch = $Self->{YAMLObject}->Dump( Data => $Param{ConfigMatch} );
        utf8::upgrade($ConfigMatch);
    }

    if ( $Param{ConfigChange} ) {

        if ( !IsHashRefWithData( $Param{ConfigChange} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ConfigChange needs to be a valid hash with data!",
            );
            return;
        }

        $ConfigChange = $Self->{YAMLObject}->Dump( Data => $Param{ConfigChange} );
        utf8::upgrade($ConfigChange);
    }

    # check if ACL with this name already exists
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT id
            FROM acl
            WHERE $Self->{Lower}(name) = $Self->{Lower}(?)",
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    my $ACLExists;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $ACLExists = 1;
    }

    if ($ACLExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The Name:$Param{Name} already exists for an ACL!"
        );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO acl ( name, comments, description, stop_after_match, config_match,
                config_change, valid_id, create_time, create_by, change_time, change_by )
            VALUES (?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{Description}, \$Param{StopAfterMatch},
            \$ConfigMatch, \$ConfigChange, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM acl WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    return if !$ID;

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ACLEditor_ACL',
    );

    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO acl_sync ( acl_id, sync_state, create_time, change_time )
            VALUES (?, ?, current_timestamp, current_timestamp)',
        Bind => [ \$ID, \'not_sync' ],
    );

    return $ID;
}

=item ACLDelete()

delete an ACL

returns 1 if success or undef otherwise

    my $Success = $ACLObject->ACLDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub ACLDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my $ACL = $Self->ACLGet(
        ID     => $Param{ID},
        UserID => 1,
    );
    return if !IsHashRefWithData($ACL);

    # delete ACL
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM acl WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ACLEditor_ACL',
    );

    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO acl_sync ( acl_id, sync_state, create_time, change_time )
            VALUES (?, ?, current_timestamp, current_timestamp)',
        Bind => [ \$Param{ID}, \'deleted' ],
    );

    return 1;
}

=item ACLGet()

get ACL attributes

    my $ACL = $ACLObject->ACLGet(
        ID              => 123,          # ID or name is needed
        Name            => 'ACL1',
        UserID          => 123,          # mandatory
    );

Returns:

    $ACL = {
        ID             => 123,
        Name           => 'some name',
        Comment        => 'Comment',
        Description    => 'Description',
        StopAfterMatch => 1,
        ConfigMatch    => $ConfigMatchHashRef,
        ConfigChange   => $ConfigChangeHashRef,
        ValidID        => 1,
        CreateTime     => '2012-07-04 15:08:00',
        ChangeTime     => '2012-07-04 15:08:00',
        CreateBy       => 'user_login',
        ChangeBy       => 'user_login',
    };

=cut

sub ACLGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or Name!' );
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
        $CacheKey = 'ACLGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'ACLGet::Name::' . $Param{Name};
    }

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ACLEditor_ACL',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, name, comments, description, stop_after_match, valid_id, config_match,
                    config_change, create_time, change_time, create_by, change_by
                FROM acl
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => '
                SELECT id, name, comments, description, stop_after_match, valid_id, config_match,
                    config_change, create_time, change_time, create_by, change_by
                FROM acl
                WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );
    }

    my %Data;

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        my $ConfigMatch = '';
        if ( $Data[6] ) {
            $ConfigMatch = $Self->{YAMLObject}->Load( Data => $Data[6] );
        }

        my $ConfigChange = '';
        if ( $Data[7] ) {
            $ConfigChange = $Self->{YAMLObject}->Load( Data => $Data[7] );
        }

        my $CreateUser = $Self->{UserObject}->UserLookup( UserID => $Data[10] );
        my $ChangeUser = $Self->{UserObject}->UserLookup( UserID => $Data[11] );

        %Data = (
            ID             => $Data[0],
            Name           => $Data[1],
            Comment        => $Data[2],
            Description    => $Data[3] || '',
            StopAfterMatch => $Data[4] || 0,
            ValidID        => $Data[5],
            ConfigMatch    => $ConfigMatch,
            ConfigChange   => $ConfigChange,
            CreateTime     => $Data[8],
            ChangeTime     => $Data[9],
            CreateBy       => $CreateUser,
            ChangeBy       => $ChangeUser,
        );

    }

    return if !$Data{ID};

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ACLEditor_ACL',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ACLUpdate()

update ACL attributes

returns 1 if success or undef otherwise

    my $Success = $ACLObject->ACLUpdate(
        ID             => 123,                  # mandatory
        Name           => 'NameOfACL',          # mandatory
        Comment        => 'Comment',            # optional
        Description    => 'Description',        # optional
        StopAfterMatch => 1,                    # optional
        ValidID        => 'ValidID',            # mandatory
        ConfigMatch    => $ConfigMatchHashRef,  # optional
        ConfigChange   => $ConfigChangeHashRef, # optional
        UserID         => 123,                  # mandatory
    );

=cut

sub ACLUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID Name ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # define Description field if not present
    $Param{Description} = '' if !defined $Param{Description};

    my $ConfigMatch  = '';
    my $ConfigChange = '';

    for my $Key (qw(ConfigMatch ConfigChange)) {

        if ( $Param{$Key} && !IsHashRefWithData( $Param{$Key} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Key needs to be a valid hash with data!",
            );
            return;
        }
    }

    if ( $Param{ConfigMatch} && IsHashRefWithData( $Param{ConfigMatch} ) ) {
        $ConfigMatch = $Self->{YAMLObject}->Dump( Data => $Param{ConfigMatch} );
        utf8::upgrade($ConfigMatch);
    }

    if ( $Param{ConfigChange} && IsHashRefWithData( $Param{ConfigChange} ) ) {
        $ConfigChange = $Self->{YAMLObject}->Dump( Data => $Param{ConfigChange} );
        utf8::upgrade($ConfigChange);
    }

    # check if Name already exists
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT id FROM acl
            WHERE $Self->{Lower}(name) = $Self->{Lower}(?)
            AND id != ?",
        Bind => [ \$Param{Name}, \$Param{ID} ],
        LIMIT => 1,
    );

    my $ACLExists;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $ACLExists = 1;
    }

    if ($ACLExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The Name:$Param{Name} already exists for a different ACL!",
        );
        return;
    }

    # check if need to update db
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT name, comments, description, stop_after_match, valid_id, config_match,
                config_change
            FROM acl
            WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    my $CurrentName;
    my $CurrentComment;
    my $CurrentDescription;
    my $CurrentStopAfterMatch;
    my $CurrentValidID;
    my $CurrentConfigMatch;
    my $CurrentConfigChange;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $CurrentName           = $Data[0];
        $CurrentComment        = $Data[1];
        $CurrentDescription    = $Data[2] || '';
        $CurrentStopAfterMatch = $Data[3] || 0;
        $CurrentValidID        = $Data[4];
        $CurrentConfigMatch    = $Data[5];
        $CurrentConfigChange   = $Data[6];
    }

    if (
        $CurrentName
        && $CurrentName eq $Param{Name}
        && $CurrentComment eq $Param{Comment}
        && $CurrentDescription eq $Param{Description}
        && $CurrentStopAfterMatch eq $Param{StopAfterMatch}
        && $CurrentValidID eq $Param{ValidID}
        && $CurrentConfigMatch eq $Param{ConfigMatch}
        && $CurrentConfigChange eq $Param{ConfigChange}
        )
    {
        return 1;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            UPDATE acl
            SET name = ?, comments = ?, description = ?, stop_after_match = ?, valid_id = ?,
                config_match = ?, config_change = ?, change_time = current_timestamp,  change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{Description}, \$Param{StopAfterMatch},
            \$Param{ValidID}, \$ConfigMatch, \$ConfigChange,
            \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ACLEditor_ACL',
    );

    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO acl_sync ( acl_id, sync_state, create_time, change_time )
            VALUES (?, ?, current_timestamp, current_timestamp)',
        Bind => [ \$Param{ID}, \'not_sync' ],
    );

    return 1;
}

=item ACLList()

get an ACL list

    my $List = $ACLObject->ACLList(
        ValidIDs        => ['1','2'],           # optional, to filter ACLs that match listed valid IDs
        UserID          => 1,
    );

    Returns:

    $List = {
        1 => 'NameOfACL',
    }
=cut

sub ACLList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
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

    # check cache
    my $CacheKey = 'ACLList::ValidIDs::' . $ValidIDsStrg;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ACLEditor_ACL',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = '
            SELECT id, name
            FROM acl ';

    if ( $ValidIDsStrg ne 'ALL' ) {

        my $ValidIDsStrgDB = join ',', map $Self->{DBObject}->Quote( $_, 'Integer' ),
            @{ $Param{ValidIDs} };

        $SQL .= "WHERE valid_id IN ($ValidIDsStrgDB)";
    }

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ACLEditor_ACL',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item ACLListGet()

get an ACL list with all ACL details

    my $List = $ACLObject->ACLListGet(
        UserID   => 1,
        ValidIDs => ['1','2'], # optional, to filter ACLs that match listed valid IDs
    );

Returns:

    $List = [
        {
            ID            => 123,
            Name          => 'some name',
            Comment       => 'Comment',
            Description   => 'Description',
            ValidID       => 1,
            ConfigMatch   => $ConfigMatchHashRef,
            ConfigChange  => $ConfigChangeHashRef,
            CreateTime    => '2012-07-04 15:08:00',
            ChangeTime    => '2012-07-04 15:08:00',
        },
        {
            ID            => 123,
            Name          => 'some name',
            Comment       => 'Comment',
            Description   => 'Description',
            ValidID       => 1,
            ConfigMatch   => $ConfigMatchHashRef,
            ConfigChange  => $ConfigChangeHashRef,
            CreateTime    => '2012-07-04 15:08:00',
            ChangeTime    => '2012-07-04 15:08:00',
        },
    ];

=cut

sub ACLListGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
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

    # check cache
    my $CacheKey = 'ACLListGet::ValidIDs::' . $ValidIDsStrg;

    my $Cache = $Self->{CacheObject}->Get(
        Type => 'ACLEditor_ACL',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    my $SQL = '
            SELECT id
            FROM acl ';
    if ( $ValidIDsStrg ne 'ALL' ) {

        my $ValidIDsStrgDB
            = join ',', map $Self->{DBObject}->Quote( $_, 'Integer' ), @{ $Param{ValidIDs} };

        $SQL .= "WHERE valid_id IN ($ValidIDsStrgDB)";
    }
    $SQL .= 'ORDER BY id';

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    my @ACLIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ACLIDs, $Row[0];
    }

    my @Data;
    for my $ItemID (@ACLIDs) {

        my $ACLData = $Self->ACLGet(
            ID     => $ItemID,
            UserID => 1,
        );
        push @Data, $ACLData;
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'ACLEditor_ACL',
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    return \@Data;
}

=item ACLsNeedSync()

Check if there are unsynchronized ACLs

    my $SyncCount = $ACLObject->ACLsNeedSync();

    Returns:

    $SyncCount = 0 || Number of ALCs that need to be synched
=cut

sub ACLsNeedSync {
    my ( $Self, %Param ) = @_;

    my $SQL = '
        SELECT COUNT(*)
        FROM acl_sync';

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    my $NeedSync = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $NeedSync = $Row[0];
    }

    return $NeedSync;
}

=item ACLsNeedSyncReset()

Reset synchronization information for ACLs.

=cut

sub ACLsNeedSyncReset {
    my ( $Self, %Param ) = @_;

    return if !$Self->{DBObject}->Do( SQL => 'DELETE FROM acl_sync' );

    return 1;
}

=item ACLDump()

gets a complete ACL information dump from the DB

    my $ACLDump = $ACLObject->ACLDump(
        ResultType  => 'SCALAR'                     # 'SCALAR' || 'HASH' || 'FILE'
        Location    => '/opt/otrs/var/myfile.txt'   # mandatory for ResultType = 'FILE'
        UserID      => 1,
    );

Returns:
    $ACLDump = '/opt/otrs/var/myfile.txt';          # or undef if can't write the file

=cut

sub ACLDump {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    if ( !defined $Param{ResultType} ) {
        $Param{ResultType} = 'FILE';
    }

    if ( $Param{ResultType} eq 'FILE' ) {
        if ( !$Param{Location} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Location for ResultType \'FILE\'!',
            );

        }
    }

    # get valid ACLs
    my $ACLList = $Self->ACLListGet(
        UserID   => 1,
        ValidIDs => [1],
    );

    my %ACLDump;

    ACL:
    for my $ACLData ( @{$ACLList} ) {

        next ACL if !IsHashRefWithData($ACLData);

        my $Properties;
        my $PropertiesDatabase;
        if ( IsHashRefWithData( $ACLData->{ConfigMatch} ) ) {
            $Properties             = $ACLData->{ConfigMatch}->{Properties},
                $PropertiesDatabase = $ACLData->{ConfigMatch}->{PropertiesDatabase},
        }

        my $Possible;
        my $PossibleNot;
        if ( IsHashRefWithData( $ACLData->{ConfigChange} ) ) {
            $Possible        = $ACLData->{ConfigChange}->{Possible},
                $PossibleNot = $ACLData->{ConfigChange}->{PossibleNot},
        }

        $ACLDump{ $ACLData->{Name} } = {
            CreateTime => $ACLData->{CreateTime},
            ChangeTime => $ACLData->{ChangeTime},
            CreateBy   => $ACLData->{CreateBy},
            ChangeBy   => $ACLData->{ChangeBy},
            Comment    => $ACLData->{Comment},
            Values     => {
                StopAfterMatch     => $ACLData->{StopAfterMatch} || 0,
                Properties         => $Properties                || {},
                PropertiesDatabase => $PropertiesDatabase        || {},
                Possible           => $Possible                  || {},
                PossibleNot        => $PossibleNot               || {},
            },
        };
    }

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'ACLEditor_ACL',
    );

    my $Output = '';
    for my $ACLName ( keys %ACLDump ) {

        # create output
        $Output .= $Self->_ACLItemOutput(
            Key        => $ACLName,
            Value      => $ACLDump{$ACLName}{Values},
            Comment    => $ACLDump{$ACLName}{Comment},
            CreateTime => $ACLDump{$ACLName}{CreateTime},
            ChangeTime => $ACLDump{$ACLName}{ChangeTime},
            CreateBy   => $ACLDump{$ACLName}{CreateBy},
            ChangeBy   => $ACLDump{$ACLName}{ChangeBy},
        );
    }

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
package Kernel::Config::Files::ZZZACL;
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

    return $FileLocation;
}

sub _ACLItemOutput {
    my ( $Self, %Param ) = @_;

    my $Output = "# Created: $Param{CreateTime} ($Param{CreateBy})\n";
    $Output .= "# Changed: $Param{ChangeTime} ($Param{ChangeBy})\n";

    if ( $Param{Comment} ) {
        $Output .= "# Comment: $Param{Comment}\n";
    }

    $Output .= $Self->{MainObject}->Dump(
        $Param{Value},
    );

    # replace "[empty]" by ''
    $Output =~ s{\[empty\]}{}xmsg;

    my $Name = $Param{Key};
    $Name =~ s{\"}{\\"}xmsg;
    my $Key = '$Self->{TicketAcl}->{"' . $Name . '"}';

    $Output =~ s{\$VAR1}{$Key}mxs;

    return $Output . "\n";
}

=cut

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

=cut

1;
