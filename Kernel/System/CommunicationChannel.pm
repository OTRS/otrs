# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::System::CommunicationChannel;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(DataIsDifferent IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Valid',
    'Kernel::System::XML',
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
        push @Bind, \$Param{ChannelName};
    }
    else {
        $SQL .= "id = ? ";
        push @Bind, \$Param{ChannelID};
    }

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{ChannelID}   = $Row[0];
        $Result{ChannelName} = $Row[1];
        $Result{Module}      = $Row[2];
        $Result{PackageName} = $Row[3];
        $Result{ChannelData} = $YAMLObject->Load( Data => $Row[4] );
        $Result{ValidID}     = $Row[5];
        $Result{CreateTime}  = $Row[6];
        $Result{CreateBy}    = $Row[7];
        $Result{ChangeTime}  = $Row[8];
        $Result{ChangeBy}    = $Row[9];
    }
    return if !%Result;

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
        $CacheKey .= '::ValidID::' . $Param{ValidID};
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

Synchronize communication channels in the database with channel registration in configuration.

    my $Result = $CommunicationChannelObject->ChannelSync(
        UserID => 1,
    );

Returns:

    $Result = {
        ChannelsUpdated => [ 'Email', 'Phone' ],
        ChannelsAdded   => [ 'Chat' ],
        ChannelsInvalid => [ 'Internal' ],
    };

=cut

sub ChannelSync {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return;
    }

    # Get known channels and transform the result into a hash for easier lookup.
    my %CommunicationChannels = map { $_->{ChannelName} => 1 } $Self->ChannelList();

    # Get channel registration data.
    my $ChannelRegistration = $Kernel::OM->Get('Kernel::Config')->Get('CommunicationChannel');
    my %ChannelsRegistered  = map { $_ => 1 } keys %{ $ChannelRegistration // {} };

    # Merge the already known and registered channels.
    %CommunicationChannels = (
        %CommunicationChannels,
        %ChannelsRegistered,
    );

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my %Result;

    CHANNEL:
    for my $Channel ( sort keys %CommunicationChannels ) {

        # Get channel data if it is already known.
        my %CommunicationChannel = $Self->ChannelGet(
            ChannelName => $Channel,
        );

        # Check if channel registration is not present.
        if ( !IsHashRefWithData( $ChannelRegistration->{$Channel} ) ) {

            # Drop the channel, but only if there is no article data associated to it.
            if ( $CommunicationChannel{ChannelID} ) {
                $Self->ChannelDrop( ChannelID => $CommunicationChannel{ChannelID} );

                push @{ $Result{ChannelsInvalid} }, $Channel;
            }

            next CHANNEL;
        }

        my $Module = $ChannelRegistration->{$Channel}->{Module};
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
        );

        # Update existing communication channel.
        if (%CommunicationChannel) {
            if (
                $ChannelRegistration->{$Channel}->{Module} ne $CommunicationChannel{Module}
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
                    Module      => $ChannelRegistration->{$Channel}->{Module},
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

                push @{ $Result{ChannelsUpdated} }, $Channel;
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

            push @{ $Result{ChannelsAdded} }, $Channel;
        }
    }

    return %Result;
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

Drop an invalid communication channel (that only exists in the database, but not in the configuration).
By default, this will only drop channels that have no associated article data; use C<DropArticleData> to
force article data removal as well. Channels provided by the OTRS framework can never be dropped.

    my $Success = $CommunicationChannelObject->ChannelDrop(
        ChannelID   => 1,               # (required) Delete by channel ID
                                        # or
        ChannelName => 'SomeChannel',   # (required) Delete by channel name

        DropArticleData => 1,           # (optional) Also drop article data if possible, default: 0
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

    # Avoid dropping channel if it's still registered.
    my $ChannelRegistration = $Kernel::OM->Get('Kernel::Config')->Get('CommunicationChannel');
    return if IsHashRefWithData( $ChannelRegistration->{ $Channel{ChannelName} } );

    # Prevent dropping of channels provided by the framework (fail-safe).
    return if $Channel{PackageName} eq 'Framework';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Find all existing articles that belongs to the channel.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, ticket_id
            FROM article
            WHERE communication_channel_id = ?
            ORDER BY id ASC
        ',
        Bind => [ \$Channel{ChannelID} ],
    );

    # Create article to ticket ID lookup map.
    my %TicketLookup;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $TicketLookup{ $Row[0] } = $Row[1];
    }

    # If some data was found and is not supposed to be dropped, bail out early!
    return if %TicketLookup && !$Param{DropArticleData};

    if (%TicketLookup) {

        # If specified channel backend is not in the system anymore, following method will, in fact, return invalid
        #   channel backend instead, which should still be able to delete any articles.
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(%Channel);

        # Remove articles and associated data.
        for my $ArticleID ( sort keys %TicketLookup ) {
            $ArticleBackendObject->ArticleDelete(
                TicketID  => $TicketLookup{$ArticleID},
                ArticleID => $ArticleID,
                UserID    => 1,
            );
        }
    }

    # Get a list of all tables in database.
    my @Tables = $DBObject->ListTables();

    # Check for table existence.
    my @TablesToDrop;
    for my $ArticleDataTable ( @{ $Channel{Data}->{ArticleDataTables} // [] } ) {
        if ( grep { $_ eq $ArticleDataTable } @Tables ) {
            push @TablesToDrop, $ArticleDataTable;
        }
    }

    # Drop article storage tables.
    if (@TablesToDrop) {
        my $TableList = join ', ', @TablesToDrop;
        my $DBType    = $DBObject->{'DB::Type'};

        if ( $DBType eq 'mysql' ) {

            # Drop all article tables in same statement.
            $DBObject->Do( SQL => "DROP TABLE $TableList" );
        }
        elsif ( $DBType eq 'postgresql' ) {

            # Drop all article tables in same statement.
            $DBObject->Do( SQL => "DROP TABLE $TableList" );
        }
        elsif ( $DBType eq 'oracle' ) {

            # Drop every article table in a separate statement.
            for my $Table (@TablesToDrop) {
                $DBObject->Do( SQL => "DROP TABLE $Table CASCADE CONSTRAINTS" );
            }
        }
    }

    return $Self->ChannelDelete(%Param);
}

=head2 ChannelDelete()

Delete communication channel record from the database.

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

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
