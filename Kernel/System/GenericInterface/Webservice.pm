# --
# Kernel/System/GenericInterface/Webservice.pm - GenericInterface webservice config backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericInterface::Webservice;

use strict;
use warnings;

use Kernel::System::YAML;
use Kernel::System::Valid;
use Kernel::System::GenericInterface::DebugLog;
use Kernel::System::GenericInterface::WebserviceHistory;
use Kernel::System::GenericInterface::ObjectLockState;
use Kernel::System::Cache;

use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.40 $) [1];

=head1 NAME

Kernel::System::Webservice

=head1 SYNOPSIS

Webservice configuration backend.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::GenericInterface::Webservice;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new(
        ConfigObject   => $ConfigObject,
        LogObject      => $LogObject,
        DBObject       => $DBObject,
        MainObject     => $MainObject,
        TimeObject     => $TimeObject,
        EncodeObject   => $EncodeObject,
    );

=cut

sub new {
    my ( $Webservice, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Webservice );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject EncodeObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{CacheObject}    = Kernel::System::Cache->new( %{$Self} );
    $Self->{ValidObject}    = Kernel::System::Valid->new( %{$Self} );
    $Self->{DebugLogObject} = Kernel::System::GenericInterface::DebugLog->new( %{$Self} );
    $Self->{WebserviceHistoryObject}
        = Kernel::System::GenericInterface::WebserviceHistory->new( %{$Self} );
    $Self->{ObjectLockStateObject}
        = Kernel::System::GenericInterface::ObjectLockState->new( %{$Self} );
    $Self->{YAMLObject} = Kernel::System::YAML->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('GenericInterface::WebserviceConfig::CacheTTL') || 3600 );

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check config
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config should be a non empty hash reference!",
        );
        return;
    }

    # check config internals
    if ( !IsHashRefWithData( $Param{Config}->{Debugger} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger should be a non empty hash reference!",
        );
        return;
    }
    if ( !IsStringWithData( $Param{Config}->{Debugger}->{DebugThreshold} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger DebugThreshold should be a non empty string!",
        );
        return;
    }
    if ( !defined $Param{Config}->{Provider} && !defined $Param{Config}->{Requester} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config Provider or Requester should be defined!",
        );
        return;
    }
    for my $CommunicationType (qw(Provider Requester) ) {
        if ( defined $Param{Config}->{$CommunicationType} ) {
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType} ) ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType should be a non empty hash"
                        . " reference!",
                );
                return;
            }
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType}->{Transport} ) ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType Transport should be a"
                        . " non empty hash reference!",
                );
                return;
            }
        }
    }

    # dump config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # md5 of content
    my $MD5 = $Self->{MainObject}->MD5sum(
        String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO gi_webservice_config (name, config, config_md5, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Config, \$MD5, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM gi_webservice_config WHERE config_md5 = ?',
        Bind => [ \$MD5 ],
    );

    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'Webservice',
    );

    # add history
    return if !$Self->{WebserviceHistoryObject}->WebserviceHistoryAdd(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or Name!' );
        return;
    }

    # check cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'WebserviceGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'WebserviceGet::Name::' . $Param{Name};

    }
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'Webservice',
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id, name, config, valid_id, create_time, change_time '
                . 'FROM gi_webservice_config WHERE id = ?',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id, name, config, valid_id, create_time, change_time '
                . 'FROM gi_webservice_config WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );
    }

    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        my $Config = $Self->{YAMLObject}->Load( Data => $Data[2] );

        %Data = (
            ID         => $Data[0],
            Name       => $Data[1],
            Config     => $Config,
            ValidID    => $Data[3],
            CreateTime => $Data[4],
            ChangeTime => $Data[5],
        );
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'Webservice',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check config
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config should be a non empty hash reference!",
        );
        return;
    }

    # check config internals
    if ( !IsHashRefWithData( $Param{Config}->{Debugger} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger should be a non empty hash reference!",
        );
        return;
    }
    if ( !IsStringWithData( $Param{Config}->{Debugger}->{DebugThreshold} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config Debugger DebugThreshold should be a non empty string!",
        );
        return;
    }
    if ( !defined $Param{Config}->{Provider} && !defined $Param{Config}->{Requester} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Webservice Config Provider or Requester should be defined!",
        );
        return;
    }
    for my $CommunicationType (qw(Provider Requester) ) {
        if ( defined $Param{Config}->{$CommunicationType} ) {
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType} ) ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType should be a non empty hash"
                        . " reference!",
                );
                return;
            }
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType}->{Transport} ) ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Webservice Config $CommunicationType Transport should be a"
                        . " non empty hash reference!",
                );
                return;
            }
        }
    }

    # dump config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # md5 of content
    my $MD5 = $Self->{MainObject}->MD5sum(
        String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
    );

    # check if config and valid_id is the same
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT config, valid_id, name FROM gi_webservice_config WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    my $ConfigCurrent;
    my $ValidIDCurrent;
    my $NameCurrent;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $ConfigCurrent  = $Data[0];
        $ValidIDCurrent = $Data[1];
        $NameCurrent    = $Data[2];
    }

    return 1 if $ValidIDCurrent eq $Param{ValidID}
        && $Config eq $ConfigCurrent
        && $NameCurrent eq $Param{Name};

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE gi_webservice_config SET name = ?, config = ?, '
            . ' config_md5 = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Config, \$MD5, \$Param{ValidID}, \$Param{UserID},
            \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'Webservice',
    );

    # add history
    return if !$Self->{WebserviceHistoryObject}->WebserviceHistoryAdd(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my $Webservice = $Self->WebserviceGet(
        ID => $Param{ID},
    );
    return if !IsHashRefWithData($Webservice);

    # delete history
    return if !$Self->{WebserviceHistoryObject}->WebserviceHistoryDelete(
        WebserviceID => $Param{ID},
        UserID       => $Param{UserID},
    );

    # delete remaining entries in ObjectLockState
    return if !$Self->{ObjectLockStateObject}->ObjectLockStatePurge(
        WebserviceID => $Param{ID},
    );

    # delete debugging data for webservice
    return if !$Self->{DebugLogObject}->LogDelete(
        WebserviceID   => $Param{ID},
        NoErrorIfEmpty => 1,
    );

    # delete web service
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM gi_webservice_config WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
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

    # check cache
    my $Valid = 1;
    if ( !$Param{Valid} ) {
        $Valid = '0';
    }
    my $CacheKey = 'WebserviceList::Valid::' . $Valid;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'Webservice',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = 'SELECT id, name FROM gi_webservice_config';

    if ( !defined $Param{Valid} || $Param{Valid} eq 1 ) {
        $SQL .= ' WHERE valid_id IN (' . join ', ', $Self->{ValidObject}->ValidIDsGet() . ')';
    }

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'Webservice',
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

$Revision: 1.40 $ $Date: 2013-01-17 03:39:21 $

=cut
