# --
# Kernel/System/GenericInterface/Webservice.pm - GenericInterface webservice config backend
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericInterface::Webservice;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::GenericInterface::DebugLog',
    'Kernel::System::GenericInterface::ObjectLockState',
    'Kernel::System::GenericInterface::WebserviceHistory',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::Valid',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::Webservice

=head1 SYNOPSIS

Webservice configuration backend.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

=cut

sub new {
    my ( $Webservice, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Webservice );

    return $Self;
}

=item WebserviceAdd()

add new Webservices

returns id of new webservice if successful or undef otherwise

    my $ID = $WebserviceObject->WebserviceAdd(
        Name    => 'some name',
        Config  => $ConfigHashRef,
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub WebserviceAdd {
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
            Message  => "Webservice Config should be a non empty hash reference!",
        );
        return;
    }

    # check config internals
    if ( !IsHashRefWithData( $Param{Config}->{Debugger} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger should be a non empty hash reference!",
        );
        return;
    }
    if ( !IsStringWithData( $Param{Config}->{Debugger}->{DebugThreshold} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger DebugThreshold should be a non empty string!",
        );
        return;
    }
    if ( !defined $Param{Config}->{Provider} && !defined $Param{Config}->{Requester} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Webservice Config Provider or Requester should be defined!",
        );
        return;
    }
    for my $CommunicationType (qw(Provider Requester)) {
        if ( defined $Param{Config}->{$CommunicationType} ) {
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType should be a non empty hash"
                        . " reference!",
                );
                return;
            }
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType}->{Transport} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType Transport should be a"
                        . " non empty hash reference!",
                );
                return;
            }
        }
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
            'INSERT INTO gi_webservice_config (name, config, config_md5, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Config, \$MD5, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM gi_webservice_config WHERE config_md5 = ?',
        Bind => [ \$MD5 ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Webservice',
    );

    # get webservice history object
    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

    # add history
    return if !$WebserviceHistoryObject->WebserviceHistoryAdd(
        WebserviceID => $ID,
        Config       => $Param{Config},
        UserID       => $Param{UserID},
    );

    return $ID;
}

=item WebserviceGet()

get Webservices attributes

    my $Webservice = $WebserviceObject->WebserviceGet(
        ID   => 123,            # ID or Name must be provided
        Name => 'MyWebservice',
    );

Returns:

    $Webservice = {
        ID         => 123,
        Name       => 'some name',
        Config     => $ConfigHashRef,
        ValidID    => 123,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-02-08 15:08:00',
    };

=cut

sub WebserviceGet {
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
        $CacheKey = 'WebserviceGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'WebserviceGet::Name::' . $Param{Name};

    }
    my $Cache = $CacheObject->Get(
        Type => 'Webservice',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    if ( $Param{ID} ) {
        return if !$DBObject->Prepare(
            SQL => 'SELECT id, name, config, valid_id, create_time, change_time '
                . 'FROM gi_webservice_config WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => 'SELECT id, name, config, valid_id, create_time, change_time '
                . 'FROM gi_webservice_config WHERE name = ?',
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
        $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::WebserviceConfig::CacheTTL')
            || 3600
    );

    # set cache
    $CacheObject->Set(
        Type  => 'Webservice',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $CacheTTL,
    );

    return \%Data;
}

=item WebserviceUpdate()

update Webservice attributes

returns 1 if successful or undef otherwise

    my $Success = $WebserviceObject->WebserviceUpdate(
        ID      => 123,
        Name    => 'some name',
        Config  => $ConfigHashRef,
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub WebserviceUpdate {
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
            Message  => "Webservice Config should be a non empty hash reference!",
        );
        return;
    }

    # check config internals
    if ( !IsHashRefWithData( $Param{Config}->{Debugger} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger should be a non empty hash reference!",
        );
        return;
    }
    if ( !IsStringWithData( $Param{Config}->{Debugger}->{DebugThreshold} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger DebugThreshold should be a non empty string!",
        );
        return;
    }
    if ( !defined $Param{Config}->{Provider} && !defined $Param{Config}->{Requester} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Webservice Config Provider or Requester should be defined!",
        );
        return;
    }
    for my $CommunicationType (qw(Provider Requester)) {
        if ( defined $Param{Config}->{$CommunicationType} ) {
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType should be a non empty hash"
                        . " reference!",
                );
                return;
            }
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType}->{Transport} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType Transport should be a"
                        . " non empty hash reference!",
                );
                return;
            }
        }
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
        SQL   => 'SELECT config, valid_id, name FROM gi_webservice_config WHERE id = ?',
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
        SQL => 'UPDATE gi_webservice_config SET name = ?, config = ?, '
            . ' config_md5 = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Config, \$MD5, \$Param{ValidID}, \$Param{UserID},
            \$Param{ID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Webservice',
    );

    # get webservice history object
    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

    # add history
    return if !$WebserviceHistoryObject->WebserviceHistoryAdd(
        WebserviceID => $Param{ID},
        Config       => $Param{Config},
        UserID       => $Param{UserID},
    );

    return 1;
}

=item WebserviceDelete()

delete a Webservice

returns 1 if successful or undef otherwise

    my $Success = $WebserviceObject->WebserviceDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub WebserviceDelete {
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
    my $Webservice = $Self->WebserviceGet(
        ID => $Param{ID},
    );
    return if !IsHashRefWithData($Webservice);

    # get webservice history object
    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

    # delete history
    return if !$WebserviceHistoryObject->WebserviceHistoryDelete(
        WebserviceID => $Param{ID},
        UserID       => $Param{UserID},
    );

    # get object lock state object
    my $ObjectLockStateObject = $Kernel::OM->Get('Kernel::System::GenericInterface::ObjectLockState');

    # delete remaining entries in ObjectLockState
    return if !$ObjectLockStateObject->ObjectLockStatePurge(
        WebserviceID => $Param{ID},
    );

    # get debug log object
    my $DebugLogObject = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog');

    # delete debugging data for webservice
    return if !$DebugLogObject->LogDelete(
        WebserviceID   => $Param{ID},
        NoErrorIfEmpty => 1,
    );

    # delete web service
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM gi_webservice_config WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Webservice',
    );

    return 1;
}

=item WebserviceList()

get Webservice list

    my $List = $WebserviceObject->WebserviceList();

    or

    my $List = $WebserviceObject->WebserviceList(
        Valid => 0, # optional, defaults to 1
    );

=cut

sub WebserviceList {
    my ( $Self, %Param ) = @_;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $Valid = 1;
    if ( !$Param{Valid} ) {
        $Valid = '0';
    }
    my $CacheKey = 'WebserviceList::Valid::' . $Valid;
    my $Cache    = $CacheObject->Get(
        Type => 'Webservice',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = 'SELECT id, name FROM gi_webservice_config';

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
        $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::WebserviceConfig::CacheTTL')
            || 3600
    );

    # set cache
    $CacheObject->Set(
        Type  => 'Webservice',
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
