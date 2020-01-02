# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    'Kernel::System::GenericInterface::WebserviceHistory',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::GenericInterface::Webservice

=head1 DESCRIPTION

Web service configuration backend.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

=cut

sub new {
    my ( $Webservice, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Webservice );

    return $Self;
}

=head2 WebserviceAdd()

add new Webservices

returns id of new web service if successful or undef otherwise

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
            Message  => "Web service Config should be a non empty hash reference!",
        );
        return;
    }

    # check config internals
    if ( !IsHashRefWithData( $Param{Config}->{Debugger} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Web service Config Debugger should be a non empty hash reference!",
        );
        return;
    }
    if ( !IsStringWithData( $Param{Config}->{Debugger}->{DebugThreshold} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Web service Config Debugger DebugThreshold should be a non empty string!",
        );
        return;
    }
    if ( !defined $Param{Config}->{Provider} && !defined $Param{Config}->{Requester} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Web service Config Provider or Requester should be defined!",
        );
        return;
    }
    for my $CommunicationType (qw(Provider Requester)) {
        if ( defined $Param{Config}->{$CommunicationType} ) {
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Web service Config $CommunicationType should be a non empty hash"
                        . " reference!",
                );
                return;
            }
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType}->{Transport} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Web service Config $CommunicationType Transport should be a"
                        . " non empty hash reference!",
                );
                return;
            }
        }
    }

    # Check if web service is using an old configuration type and upgrade if necessary.
    $Self->_WebserviceConfigUpgrade(%Param);

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL =>
            'INSERT INTO gi_webservice_config (name, config, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Config, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM gi_webservice_config WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Webservice',
    );

    # get web service history object
    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

    # add history
    return if !$WebserviceHistoryObject->WebserviceHistoryAdd(
        WebserviceID => $ID,
        Config       => $Param{Config},
        UserID       => $Param{UserID},
    );

    return $ID;
}

=head2 WebserviceGet()

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

=head2 WebserviceUpdate()

update web service attributes

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
            Message  => "Web service Config should be a non empty hash reference!",
        );
        return;
    }

    # check config internals
    if ( !IsHashRefWithData( $Param{Config}->{Debugger} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Web service Config Debugger should be a non empty hash reference!",
        );
        return;
    }
    if ( !IsStringWithData( $Param{Config}->{Debugger}->{DebugThreshold} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Web service Config Debugger DebugThreshold should be a non empty string!",
        );
        return;
    }
    if ( !defined $Param{Config}->{Provider} && !defined $Param{Config}->{Requester} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Web service Config Provider or Requester should be defined!",
        );
        return;
    }
    for my $CommunicationType (qw(Provider Requester)) {
        if ( defined $Param{Config}->{$CommunicationType} ) {
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Web service Config $CommunicationType should be a non empty hash"
                        . " reference!",
                );
                return;
            }
            if ( !IsHashRefWithData( $Param{Config}->{$CommunicationType}->{Transport} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Web service Config $CommunicationType Transport should be a"
                        . " non empty hash reference!",
                );
                return;
            }
        }
    }

    # Check if web service is using an old configuration type and upgrade if necessary.
    $Self->_WebserviceConfigUpgrade(%Param);

    # dump config as string
    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );

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
            . ' valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Config, \$Param{ValidID}, \$Param{UserID},
            \$Param{ID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Webservice',
    );

    # get web service history object
    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

    # add history
    return if !$WebserviceHistoryObject->WebserviceHistoryAdd(
        WebserviceID => $Param{ID},
        Config       => $Param{Config},
        UserID       => $Param{UserID},
    );

    return 1;
}

=head2 WebserviceDelete()

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

    # get web service history object
    my $WebserviceHistoryObject = $Kernel::OM->Get('Kernel::System::GenericInterface::WebserviceHistory');

    # delete history
    return if !$WebserviceHistoryObject->WebserviceHistoryDelete(
        WebserviceID => $Param{ID},
        UserID       => $Param{UserID},
    );

    # get debug log object
    my $DebugLogObject = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog');

    # delete debugging data for web service
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

=head2 WebserviceList()

get web service list

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

    # check Valid param
    my $Valid = ( IsStringWithData( $Param{Valid} ) && $Param{Valid} eq 0 ) ? 0 : 1;

    # check cache
    my $CacheKey = 'WebserviceList::Valid::' . $Valid;
    my $Cache    = $CacheObject->Get(
        Type => 'Webservice',
        Key  => $CacheKey,
    );
    return $Cache if ref $Cache;

    my $SQL = 'SELECT id, name FROM gi_webservice_config';

    if ($Valid) {

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

=begin Internal:

=head2 _WebserviceConfigUpgrade()

Update version if webservice config (e.g. for API changes).

    my $Config = $WebserviceObject->_WebserviceConfigUpgrade( Config => $Config );

=cut

sub _WebserviceConfigUpgrade {
    my ( $Self, %Param ) = @_;

    return if !IsHashRefWithData( $Param{Config} );

    # Updates of SOAP and REST transport in OTRS 6:
    #   Authentication, SSL and Proxy option changes, introduction of timeout param.
    # Upgrade is considered necessary if the new (and now mandatory) parameter 'Timeout' isn't set.
    if (
        IsHashRefWithData( $Param{Config}->{Requester} )    # prevent creation of dummy elements
        && IsStringWithData( $Param{Config}->{Requester}->{Transport}->{Type} )
        && (
            $Param{Config}->{Requester}->{Transport}->{Type} eq 'HTTP::REST'
            || $Param{Config}->{Requester}->{Transport}->{Type} eq 'HTTP::SOAP'
        )
        && IsHashRefWithData( $Param{Config}->{Requester}->{Transport}->{Config} )
        && !IsStringWithData( $Param{Config}->{Requester}->{Transport}->{Config}->{Timeout} )
        )
    {
        my $RequesterTransportConfig = $Param{Config}->{Requester}->{Transport}->{Config};
        my $RequesterTransportType   = $Param{Config}->{Requester}->{Transport}->{Type};

        # set default timeout
        if ( $RequesterTransportType eq 'HTTP::SOAP' ) {
            $RequesterTransportConfig->{Timeout} = 60;
        }
        else {
            $RequesterTransportConfig->{Timeout} = 300;
        }

        # set default SOAPAction scheme for SOAP
        if (
            $RequesterTransportType eq 'HTTP::SOAP'
            && IsStringWithData( $RequesterTransportConfig->{SOAPAction} )
            && $RequesterTransportConfig->{SOAPAction} eq 'Yes'
            )
        {
            $RequesterTransportConfig->{SOAPActionScheme} = 'NameSpaceSeparatorOperation';
        }

        # convert auth settings
        my $Authentication = delete $RequesterTransportConfig->{Authentication};
        if (
            IsHashRefWithData($Authentication)
            && $Authentication->{Type}
            && $Authentication->{Type} eq 'BasicAuth'
            )
        {
            $RequesterTransportConfig->{Authentication} = {
                AuthType          => $Authentication->{Type},
                BasicAuthUser     => $Authentication->{User},
                BasicAuthPassword => $Authentication->{Password},
            };
        }

        # convert ssl settings
        my $SSL  = delete $RequesterTransportConfig->{SSL};
        my $X509 = delete $RequesterTransportConfig->{X509};
        if (
            $RequesterTransportType eq 'HTTP::SOAP'
            && IsHashRefWithData($SSL)
            && $SSL->{UseSSL}
            && $SSL->{UseSSL} eq 'Yes'
            )
        {
            $RequesterTransportConfig->{SSL} = {
                UseSSL         => 'Yes',
                SSLPassword    => $SSL->{SSLP12Password},
                SSLCertificate => $SSL->{SSLP12Certificate},
                SSLCADir       => $SSL->{SSLCADir},
                SSLCAFile      => $SSL->{SSLCAFile},
            };
        }
        elsif (
            IsHashRefWithData($X509)
            && $X509->{UseX509}
            && $X509->{UseX509} eq 'Yes'
            )
        {
            $RequesterTransportConfig->{SSL} = {
                UseSSL         => 'Yes',
                SSLKey         => $X509->{X509KeyFile},
                SSLCertificate => $X509->{X509CertFile},
                SSLCAFile      => $X509->{X509CAFile},
            };
        }
        else {
            $RequesterTransportConfig->{SSL}->{UseSSL} = 'No';
        }

        # convert proxy settings
        if (
            IsHashRefWithData($SSL)
            && $SSL->{SSLProxy}
            )
        {
            $RequesterTransportConfig->{Proxy} = {
                UseProxy      => 'Yes',
                ProxyHost     => $SSL->{SSLProxy},
                ProxyUser     => $SSL->{SSLProxyUser},
                ProxyPassword => $SSL->{SSLProxyPassword},
                ProxyExclude  => 'No',
            };
        }
        else {
            $RequesterTransportConfig->{Proxy}->{UseProxy} = 'No';
        }

        # set updated config
        $Param{Config}->{Requester}->{Transport}->{Config} = $RequesterTransportConfig;
    }

    return 1;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
