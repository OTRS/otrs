# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
    'Kernel::System::Time',
    'Kernel::System::Valid',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::CloudService::Backend::Configuration

=head1 SYNOPSIS

CloudService configuration backend.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::CloudService');

=cut

sub new {
    my ( $CloudService, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $CloudService );

    return $Self;
}

=item CloudServiceAdd()

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
                Message  => "Need $Key!"
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

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # md5 of content
    my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
        String => $Kernel::OM->Get('Kernel::System::Time')->SystemTime() . int( rand(1000000) ),
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL =>
            'INSERT INTO cloud_service_config (name, config, config_md5, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Config, \$MD5, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM cloud_service_config WHERE config_md5 = ?',
        Bind => [ \$MD5 ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'CloudService',
    );

    return $ID;
}

=item CloudServiceGet()

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
            Message  => 'Need ID or Name!'
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
        Type => 'CloudService',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    if ( $Param{ID} ) {
        return if !$DBObject->Prepare(
            SQL => 'SELECT id, name, config, valid_id, create_time, change_time '
                . 'FROM cloud_service_config WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => 'SELECT id, name, config, valid_id, create_time, change_time '
                . 'FROM cloud_service_config WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );
    }

    # get yaml object
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        my $Config = $YAMLObject->Load( Data => $Data[2] );

        %Data = (
            ID         => $Data[0],
            Name       => $Data[1],
            Config     => $Config,
            ValidID    => $Data[3],
            CreateTime => $Data[4],
            ChangeTime => $Data[5],
        );
    }

    # get the cache TTL (in seconds)
    my $CacheTTL = int(
        $Kernel::OM->Get('Kernel::Config')->Get('CloudServiceConfig::CacheTTL')
            || 3600
    );

    # set cache
    $CacheObject->Set(
        Type  => 'CloudService',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $CacheTTL,
    );

    return \%Data;
}

=item CloudServiceUpdate()

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
                Message  => "Need $Key!"
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

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # md5 of content
    my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
        String => $Kernel::OM->Get('Kernel::System::Time')->SystemTime() . int( rand(1000000) ),
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if config and valid_id is the same
    return if !$DBObject->Prepare(
        SQL   => 'SELECT config, valid_id, name FROM cloud_service_config WHERE id = ?',
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

    return 1 if $ValidIDCurrent eq $Param{ValidID}
        && $Config eq $ConfigCurrent
        && $NameCurrent eq $Param{Name};

    # sql
    return if !$DBObject->Do(
        SQL => 'UPDATE cloud_service_config SET name = ?, config = ?, '
            . ' config_md5 = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Config, \$MD5, \$Param{ValidID}, \$Param{UserID},
            \$Param{ID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'CloudService',
    );

    return 1;
}

=item CloudServiceDelete()

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
                Message  => "Need $Key!"
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
        Type => 'CloudService',
    );

    return 1;
}

=item CloudServiceList()

get CloudService list

    my $List = $CloudServiceObject->CloudServiceList();

    or

    my $List = $CloudServiceObject->CloudServiceList(
        Valid => 0, # optional, defaults to 1
    );

=cut

sub CloudServiceList {
    my ( $Self, %Param ) = @_;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $Valid = 1;
    if ( !$Param{Valid} ) {
        $Valid = '0';
    }
    my $CacheKey = 'CloudServiceList::Valid::' . $Valid;
    my $Cache    = $CacheObject->Get(
        Type => 'CloudService',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = 'SELECT id, name FROM cloud_service_config';

    if ( !defined $Param{Valid} || $Param{Valid} eq 1 ) {

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

    # get the cache TTL (in seconds)
    my $CacheTTL = int(
        $Kernel::OM->Get('Kernel::Config')->Get('CloudServiceConfig::CacheTTL')
            || 3600
    );

    # set cache
    $CacheObject->Set(
        Type  => 'CloudService',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $CacheTTL,
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
