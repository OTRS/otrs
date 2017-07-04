# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::System::CommunicationChannel;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(DataIsDifferent);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::CommunicationChannel - Functions to manage communication channels.

=head1 DESCRIPTION

All functions to manage communication channels.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheTTL} = 24 * 3600 * 30;    # 1 month

    return $Self;
}

=head2 ChannelAdd()

Add new communication channel.

    my $ChannelID = $CommunicationChannelObject->ChannelAdd(
        ChannelName => 'Email',                                          # (required) Communication channel name
        Module      => 'Kernel::System::CommunicationChannel::Internal', # (required) Module
        PackageName => 'Framework',                                      # (required) Package name
        ChannelData => {...},                                            # (optional) Additional channel data (can be array, hash, scalar).
        ValidID     => 1,                                                # (optional) Default 1.
        UserID      => 1,                                                # (required) UserID
    );

Returns:

    $ChannelID = 1;

=cut

sub ChannelAdd {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ChannelName UserID Module PackageName)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{ValidID} //= $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );
    $Param{ChannelData} //= '';

    my $ChannelDataYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Param{ChannelData},
    );

    my $SQL = '
        INSERT INTO communication_channel
            (name, module, package_name, channel_data, valid_id, create_time, create_by, change_time, change_by)
        VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)
    ';

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => [
            \$Param{ChannelName},
            \$Param{Module},
            \$Param{PackageName},
            \$ChannelDataYAML,
            \$Param{ValidID},
            \$Param{UserID},
            \$Param{UserID},
        ],
    );

    my %Channel = $Self->ChannelGet(
        ChannelName => $Param{ChannelName},
    );

    $Self->_ChannelListCacheCleanup();

    return $Channel{ChannelID};
}

=head2 ChannelGet()

Get a communication channel.

    my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
        ChannelID   => '1',      # (optional) Communication channel id
                                 # or
        ChannelName => 'Email',  # (optional) Communication channel name
    );

Returns:

    %CommunicationChannel = (
        ChannelID   => 1,
        ChannelName => 'Email',
        Module      => 'Kernel::System::CommunicationChannel::Email',
        PackageName => 'Framework',
        ChannelData => {...},                                               # Additional channel data (can be array, hash, scalar).
        DisplayName => 'Email',                                             # Configurable
        DisplayIcon => 'fa-envelope',                                       # Configurable
        ValidID     => 1,
        CreateTime  => '2017-01-01 00:00:00',
        CreateBy    => 1,
        ChangeTime  => '2017-01-01 00:00:00',
        ChangeBy    => 1,
    );

=cut

sub ChannelGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{ChannelName} && !$Param{ChannelID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ChannelID or ChannelName!',
        );
        return;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $CacheObject  = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = 'CommunicationChannel';
    my $CacheKey  = 'ChannelGet::';

    if ( $Param{ChannelName} ) {
        $CacheKey .= "ChannelName::$Param{ChannelName}";
    }
    else {
        $CacheKey .= "ChannelID::$Param{ChannelID}";
    }

    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    if ( ref $Cache eq 'HASH' ) {
        my $Config = $ConfigObject->Get('CommunicationChannel')->{ $Cache->{ChannelName} } || {};

        # Add some runtime values from config.
        $Cache->{DisplayName} = $Config->{Name} || $Cache->{ChannelName};
        $Cache->{DisplayIcon} = $Config->{Icon} || 'fa-exchange';

        return %{$Cache};
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        SELECT id, name, module, package_name, channel_data, valid_id, create_time, create_by, change_time, change_by
        FROM communication_channel
        WHERE
    ';

    my @Bind;

    if ( $Param{ChannelName} ) {
        $SQL .= "name = ? ";
        push @Bind, \$Param{ChannelName},
    }
    else {
        $SQL .= "id = ? ";
        push @Bind, \$Param{ChannelID},
    }

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my %Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{ChannelID}   = $Row[0];
        $Result{ChannelName} = $Row[1];
        $Result{Module}      = $Row[2];
        $Result{PackageName} = $Row[3];
        $Result{ChannelData} = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $Row[4] );
        $Result{ValidID}     = $Row[5];
        $Result{CreateTime}  = $Row[6];
        $Result{CreateBy}    = $Row[7];
        $Result{ChangeTime}  = $Row[8];
        $Result{ChangeBy}    = $Row[9];
    }

    if ( !%Result ) {
        my $Parameter = $Param{ChannelName} || $Param{ChannelID};
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Communication channel $Parameter not found!",
        );
        return;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => $Self->{CacheTTL},
    );

    my $Config = $ConfigObject->Get('CommunicationChannel')->{ $Result{ChannelName} } || {};

    # Add some runtime values from config (do not cache).
    $Result{DisplayName} = $Config->{Name} || $Result{ChannelName};
    $Result{DisplayIcon} = $Config->{Icon} || 'fa-exchange';

    return %Result;
}

=head2 ChannelUpdate()

Update communication channel.

    my $Success = $CommunicationChannelObject->ChannelUpdate(
        ChannelID   => '1',                                              # (required) ChannelID that will be updated
        ChannelName => 'Email',                                          # (required) New channel name
        Module      => 'Kernel::System::CommunicationChannel::Internal', # (optional) Module
        PackageName => 'Framework',                                      # (optional) Package name
        ChannelData => {...},                                            # (optional) Additional channel data (can be array, hash, scalar)
        ValidID     => 1,                                                # (optional) ValidID
        UserID      => 1,                                                # (required) UserID
    );

Returns:

    $Success = 1;

=cut

sub ChannelUpdate {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(ChannelID ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Channel = $Self->ChannelGet(
        ChannelID => $Param{ChannelID},
    );

    return if !%Channel;

    # Update ValidID only if it's needed.
    if ( defined $Param{ValidID} ) {
        $Channel{ValidID} = $Param{ValidID};
    }
    if ( defined $Param{ChannelData} ) {
        $Channel{ChannelData} = $Param{ChannelData};
    }

    if ( defined $Param{Module} ) {
        $Channel{Module} = $Param{Module};
    }

    if ( defined $Param{PackageName} ) {
        $Channel{PackageName} = $Param{PackageName};
    }

    my $ChannelDataYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Channel{ChannelData},
    );

    my $SQL = '
        UPDATE communication_channel
        SET
            name = ?,
            module = ?,
            package_name = ?,
            channel_data = ?,
            valid_id = ?,
            change_time = current_timestamp,
            change_by = ?
        WHERE id = ?
    ';

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => [
            \$Param{ChannelName},
            \$Channel{Module},
            \$Channel{PackageName},
            \$ChannelDataYAML,
            \$Channel{ValidID},
            \$Param{UserID},
            \$Param{ChannelID},
        ],
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Delete cache.
    $CacheObject->Delete(
        Type => 'CommunicationChannel',
        Key  => "ChannelGet::ChannelName::$Channel{ChannelName}",
    );
    $CacheObject->Delete(
        Type => 'CommunicationChannel',
        Key  => "ChannelGet::ChannelID::$Param{ChannelID}",
    );

    $Self->_ChannelListCacheCleanup();

    return 1;
}

=head2 ChannelList()

Get a list of all available communication channels.

    my @CommunicationChannels = $CommunicationChannelObject->ChannelList(
        ValidID => 1,           # (optional) filter by ValidID
    );

Returns:

    @CommunicationChannels = (
        {
            ChannelID   => 1,
            ChannelName => 'Email',
            Module      => 'Kernel::System::CommunicationChannel::Email',
            PackageName => 'Framework',
            ChannelData => {...},
            DisplayName => 'Email',
            DisplayIcon => 'fa-envelope',
            ValidID     => 1,
            CreateTime  => '2017-01-01 00:00:00',
            CreateBy    => 1,
            ChangeTime  => '2017-01-01 00:00:00',
            ChangeBy    => 1,
        },
        {
            ChannelID   => 2,
            ChannelName => 'Phone',
            Module      => 'Kernel::System::CommunicationChannel::Phone',
            PackageName => 'Framework',
            ChannelData => {...},
            DisplayName => 'Phone',
            DisplayIcon => 'fa-phone',
            ValidID     => 1,
            CreateTime  => '2017-01-01 00:00:00',
            CreateBy    => 1,
            ChangeTime  => '2017-01-01 00:00:00',
            ChangeBy    => 1,
        },
        ...
    );

=cut

sub ChannelList {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $CacheObject  = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = 'CommunicationChannel';
    my $CacheKey  = 'ChannelList';

    my @Bind;
    if ( defined $Param{ValidID} ) {
        $CacheKey .= '::ValidID::' . ( $Param{ValidID} ? 1 : 0 );
        push @Bind, \$Param{ValidID};
    }

    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    if ( ref $Cache eq 'ARRAY' ) {
        for my $Channel ( @{$Cache} ) {
            my $Config = $ConfigObject->Get('CommunicationChannel')->{ $Channel->{ChannelName} } || {};

            # Add some runtime values from config.
            $Channel->{DisplayName} = $Config->{Name} || $Channel->{ChannelName};
            $Channel->{DisplayIcon} = $Config->{Icon} || 'fa-exchange';
        }

        return @{$Cache};
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        SELECT id, name, module, package_name, channel_data, valid_id, create_time, create_by, change_time, change_by
        FROM communication_channel
    ';

    if ( defined $Param{ValidID} ) {
        $SQL .= " WHERE valid_id = ? ";
    }

    $SQL .= ' ORDER BY name ASC ';

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Result;

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Result, {
            ChannelID   => $Row[0],
            ChannelName => $Row[1],
            Module      => $Row[2],
            PackageName => $Row[3],
            ChannelData => $YAMLObject->Load( Data => $Row[4] ),
            ValidID     => $Row[5],
            CreateTime  => $Row[6],
            CreateBy    => $Row[7],
            ChangeTime  => $Row[8],
            ChangeBy    => $Row[9],
        };
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Result,
        TTL   => $Self->{CacheTTL},
    );

    for my $Channel (@Result) {
        my $Config = $ConfigObject->Get('CommunicationChannel')->{ $Channel->{ChannelName} } || {};

        # Add some runtime values from config (do not cache).
        $Channel->{DisplayName} = $Config->{Name} || $Channel->{ChannelName};
        $Channel->{DisplayIcon} = $Config->{Icon} || 'fa-exchange';
    }

    return @Result;
}

=head2 ChannelSync()

Synchronize communication channels in database with registered channels.

    my @ChannelsAdded = $CommunicationChannelObject->ChannelSync(
        UserID => 1,
    );

Returns:
    @ChannelsAdded = [ 'Email', 'Phone', ...];    # Normally, this array should be empty.

=cut

sub ChannelSync {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return [];
    }

    my @Result;

    my $ChannelsRegistered = $Kernel::OM->Get('Kernel::Config')->Get('CommunicationChannel');

    return @Result if !$ChannelsRegistered;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    CHANNEL:
    for my $Channel ( sort keys %{$ChannelsRegistered} ) {

        my $Module = $ChannelsRegistered->{$Channel}->{Module};
        if ( !$Module ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Missing Module in registration (CommunicationChannel###$Channel)!",
            );
            next CHANNEL;
        }

        my $Loaded = $MainObject->Require(
            $Module,
            Silent => 1,
        );

        if ( !$Loaded ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "System was unable to require module '$Module'!",
            );
            next CHANNEL;
        }

        my $Object = $Module->new();

        my $PackageName = $Object->PackageNameGet();

        if ( !$PackageName ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "System was unable to retrieve package name ($Module)!",
            );
            next CHANNEL;
        }

        my %ChannelData = (
            ArticleDataTables         => [ $Object->ArticleDataTables() ],
            ArticleDataArticleIDField => $Object->ArticleDataArticleIDField(),
            ArticleDataIsDroppable    => $Object->ArticleDataIsDroppable(),
        );

        my %CommunicationChannel = $Self->ChannelGet(
            ChannelName => $Channel,
        );

        # Update existing communication channel.
        if (%CommunicationChannel) {
            if (
                $ChannelsRegistered->{$Channel}->{Module} ne $CommunicationChannel{Module}
                || $PackageName ne $CommunicationChannel{PackageName}
                || DataIsDifferent(
                    Data1 => \%ChannelData,
                    Data2 => $CommunicationChannel{ChannelData}
                )
                )
            {
                my $Success = $Self->ChannelUpdate(
                    ChannelID   => $CommunicationChannel{ChannelID},
                    ChannelName => $Channel,
                    Module      => $ChannelsRegistered->{$Channel}->{Module},
                    PackageName => $PackageName,
                    ChannelData => \%ChannelData,
                    ValidID     => 1,
                    UserID      => $Param{UserID},
                );

                if ( !$Success ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "System was not able to update communication channel ($Channel)!",
                    );

                    next CHANNEL;
                }

                push @Result, $Channel;
            }
        }

        # Create communication channel if it's missing.
        else {
            my $ChannelID = $Self->ChannelAdd(
                ChannelName => $Channel,
                ChannelData => \%ChannelData,
                Module      => $Module,
                PackageName => $PackageName,
                UserID      => $Param{UserID},
            );

            if ( !$ChannelID ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "System was not able to add communication channel ($Channel)!",
                );

                next CHANNEL;
            }

            push @Result, $Channel;
        }
    }

    return @Result;
}

=head2 ChannelObjectGet()

Returns instance of the Channel object.

    my $Object = $CommunicationChannelObject->ChannelObjectGet(
        ChannelName => 'Email',     # ChannelName or ChannelID required
    );

    my $Object = $CommunicationChannelObject->ChannelObjectGet(
        ChannelID => 2,             # ChannelName or ChannelID required
    );

B<Warning>: this function returns no object in case a channel is no longer available in the system,
so make sure to check its return value.

=cut

sub ChannelObjectGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ChannelName} && !$Param{ChannelID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ChannelName or ChannelID!'
        );
        return;
    }

    my %Channel = $Self->ChannelGet(%Param);
    return if !%Channel;

    # Return nothing if channel is missing.
    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        $Channel{Module},
        Silent => 1,
    );
    return if !$Loaded;

    return $Kernel::OM->Get( $Channel{Module} );
}

=head2 ChannelDrop()

Drop communication channel.

    my $Success = $CommunicationChannelObject->ChannelDrop(
        ChannelID   => 1,       # (optional) ChannelID
                                # or
        ChannelName => 'Email', # (optional) Delete by Channel name
    );

Returns:

    $Success = 1;

=cut

sub ChannelDrop {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ChannelID} && !$Param{ChannelName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ChannelID or ChannelName!',
        );
        return;
    }

    my %Channel = $Self->ChannelGet(%Param);
    return if !%Channel;

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        $Channel{Module},
        Silent => 1,
    );

    my %ChannelData;

    if ($Loaded) {
        my $Object = $Channel{Module}->new();

        %ChannelData = (
            ArticleDataTables         => [ $Object->ArticleDataTables() ],
            ArticleDataArticleIDField => $Object->ArticleDataArticleIDField(),
            ArticleDataIsDroppable    => $Object->ArticleDataIsDroppable(),
        );
    }

    # If, for some reason, module can't be found, get last known data from channel object.
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "System was not able to require module '$Channel{Module}'!",
        );

        if ( ref $Channel{ChannelData} eq 'HASH' ) {
            %ChannelData = %{ $Channel{ChannelData} };
        }
    }

    if ( $ChannelData{ArticleDataIsDroppable} ) {

        # TODO: Delete article data.

        $Self->ChannelDelete(%Param);
    }
}

=head2 ChannelDelete()

Delete communication channel.

    my $Success = $CommunicationChannelObject->ChannelDelete(
        ChannelID   => 1,       # (optional) Delete by ChannelID
                                # or
        ChannelName => 'Email', # (optional) Delete by Channel name
    );

Returns:

    $Success = 1;

=cut

sub ChannelDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ChannelID} && !$Param{ChannelName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ChannelID or ChannelName!',
        );
        return;
    }

    my %Channel = $Self->ChannelGet(%Param);

    if ( !%Channel ) {
        my $Parameter = $Param{ChannelID} || $Param{ChannelName};
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Communication channel not found ($Parameter)!"
        );
        return;
    }

    my $SQL = '
        DELETE FROM communication_channel
        WHERE
    ';

    my @Bind;

    if ( $Param{ChannelID} ) {
        $SQL .= "id = ?";
        push @Bind, \$Param{ChannelID};
    }
    else {
        $SQL .= "name = ?";
        push @Bind, \$Param{ChannelName};
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Delete cache.
    $CacheObject->Delete(
        Type => 'CommunicationChannel',
        Key  => "ChannelGet::ChannelName::$Channel{ChannelName}",
    );
    $CacheObject->Delete(
        Type => 'CommunicationChannel',
        Key  => "ChannelGet::ChannelID::$Channel{ChannelID}",
    );

    $Self->_ChannelListCacheCleanup();

    return 1;
}

=head1 PRIVATE FUNCTIONS

=head2 _ChannelListCacheCleanup()

Delete communication channel cache.

    my $Success = $CommunicationChannelObject->_ChannelListCacheCleanup();

Returns:

    $Success = 1;

=cut

sub _ChannelListCacheCleanup {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Delete cache.
    $CacheObject->Delete(
        Type => 'CommunicationChannel',
        Key  => 'ChannelList',
    );
    $CacheObject->Delete(
        Type => 'CommunicationChannel',
        Key  => 'ChannelList::ValidID::0',
    );
    $CacheObject->Delete(
        Type => 'CommunicationChannel',
        Key  => 'ChannelList::ValidID::1',
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
