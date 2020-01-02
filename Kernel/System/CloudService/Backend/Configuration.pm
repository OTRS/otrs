# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CloudService::Backend::Configuration;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::CloudService::Backend::Configuration

=head1 DESCRIPTION

CloudService configuration backend.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Configuration');

=cut

sub new {
    my ( $CloudService, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $CloudService );

    $Self->{CacheType} = 'CloudService';
    $Self->{CacheTTL}  = 60 * 60;          # 1 hour

    return $Self;
}

=head2 CloudServiceAdd()

add new CloudServices

returns id of new CloudService if successful or undef otherwise

    my $ID = $CloudServiceObject->CloudServiceAdd(
        Name    => 'some name',
        Config  => $ConfigHashRef,
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub CloudServiceAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Name Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check config
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "CloudService Config should be a non empty hash reference!",
        );
        return;
    }

    my %ExistingCloudServices = reverse %{ $Self->CloudServiceList( Valid => 0 ) };
    if ( $ExistingCloudServices{ $Param{Name} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A CloudService with the name $Param{Name} already exists.",
        );
        return;
    }

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO cloud_service_config
            (name, config, valid_id, create_time, create_by, change_time, change_by)
            VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Config, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM cloud_service_config WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return $ID;
}

=head2 CloudServiceGet()

get CloudServices attributes

    my $CloudService = $CloudServiceObject->CloudServiceGet(
        ID   => 123,            # ID or Name must be provided
        Name => 'MyCloudService',
    );

Returns:

    $CloudService = {
        ID         => 123,
        Name       => 'some name',
        Config     => $ConfigHashRef,
        ValidID    => 123,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-02-08 15:08:00',
    };

=cut

sub CloudServiceGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID or Name!',
        );
        return;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'CloudServiceGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'CloudServiceGet::Name::' . $Param{Name};

    }
    my $Cache = $CacheObject->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    if ( $Param{ID} ) {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, name, config, valid_id, create_time, change_time
                FROM cloud_service_config
                WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, name, config, valid_id, create_time, change_time
                FROM cloud_service_config
                WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );
    }

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        %Data = (
            ID         => $Data[0],
            Name       => $Data[1],
            Config     => $Data[2],
            ValidID    => $Data[3],
            CreateTime => $Data[4],
            ChangeTime => $Data[5],
        );
    }

    # Convert YAML string back to Perl data structure.
    if ( $Data{Config} ) {
        $Data{Config} = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $Data{Config} );
    }

    # set cache
    $CacheObject->Set(
        Type  => $Self->{CacheType},
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=head2 CloudServiceUpdate()

update CloudService attributes

returns 1 if successful or undef otherwise

    my $Success = $CloudServiceObject->CloudServiceUpdate(
        ID      => 123,
        Name    => 'some name',
        Config  => $ConfigHashRef,
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub CloudServiceUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID Name Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check config
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "CloudService Config should be a non empty hash reference!",
        );
        return;
    }

    my %ExistingCloudServices = reverse %{ $Self->CloudServiceList( Valid => 0 ) };
    if ( $ExistingCloudServices{ $Param{Name} } != $Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A CloudService with the name $Param{Name} already exists.",
        );
        return;
    }

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if config and valid_id is the same
    return if !$DBObject->Prepare(
        SQL => '
            SELECT config, valid_id, name
            FROM cloud_service_config
            WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    my $ConfigCurrent;
    my $ValidIDCurrent;
    my $NameCurrent;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $ConfigCurrent  = $Data[0];
        $ValidIDCurrent = $Data[1];
        $NameCurrent    = $Data[2];
    }
    if (
        $ValidIDCurrent eq $Param{ValidID}
        && $Config eq $ConfigCurrent
        && $NameCurrent eq $Param{Name}
        )
    {
        return 1;
    }

    # sql
    return if !$DBObject->Do(
        SQL => '
            UPDATE cloud_service_config
            SET name = ?, config = ?, valid_id = ?, change_time = current_timestamp, change_by = ?
            WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Config, \$Param{ValidID}, \$Param{UserID},
            \$Param{ID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 CloudServiceDelete()

delete a CloudService

returns 1 if successful or undef otherwise

    my $Success = $CloudServiceObject->CloudServiceDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub CloudServiceDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # check if exists
    my $CloudService = $Self->CloudServiceGet(
        ID => $Param{ID},
    );
    return if !IsHashRefWithData($CloudService);

    # delete web service
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM cloud_service_config WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 CloudServiceList()

get CloudService list

    my $List = $CloudServiceObject->CloudServiceList();

    or

    my $List = $CloudServiceObject->CloudServiceList(
        Valid => 0,     # 0 | 1 (optional) (default 1)
    );

=cut

sub CloudServiceList {
    my ( $Self, %Param ) = @_;

    # set default
    $Param{Valid} //= 1;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = 'CloudServiceList::Valid::' . $Param{Valid};
    my $Cache    = $CacheObject->Get(
        Type => 'CloudService',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = 'SELECT id, name FROM cloud_service_config';

    if ( $Param{Valid} ) {

        # get valid object
        my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

        $SQL .= ' WHERE valid_id IN (' . join ', ', $ValidObject->ValidIDsGet() . ')';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare( SQL => $SQL );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $CacheObject->Set(
        Type  => 'CloudService',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
