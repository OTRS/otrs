# --
# Kernel/System/GenericInterface/DebugLog.pm - log interface for generic interface
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericInterface::DebugLog;

use strict;
use warnings;

use Kernel::System::CacheInternal;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);

=head1 NAME

Kernel::System::GenericInterface::DebugLog - log interface for generic interface

=head1 SYNOPSIS

All log functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a debug log object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::GenericInterface::DebugLog;

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
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DebugLogObject = Kernel::System::GenericInterface::DebugLog->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        CacheInternalObject => $CacheInternalObject,
        DBObject            => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject MainObject DBObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %Param,
        Type => 'GenericInterfaceDebugLog',
        TTL  => 60 * 60,
    );

    return $Self;
}

=item LogAdd()

add a communication bit to database
if we don't already have a communication chain, create it

returns 1 on success or undef on error

    my $Success = $DebugLogObject->LogAdd(
        CommunicationID   => '6f1ed002ab5595859014ebf0951522d9',
        CommunicationType => 'Provider',        # 'Provider' or 'Requester'
        Data              => 'additional data' # optional
        DebugLevel        => 'info',           # 'debug', 'info', 'notice', 'error'
        RemoteIP          => '192.168.0.1',    # optional, must be valid IPv4 or IPv6 address
        Summary           => 'description of log entry',
        WebserviceID      => 1,
    );

=cut

sub LogAdd {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(CommunicationID CommunicationType DebugLevel Summary WebserviceID))
    {
        next NEEDED if IsStringWithData( $Param{$Needed} );

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Needed as a string!",
        );
        return;
    }

    # param syntax check
    if ( !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }
    if ( $Param{CommunicationType} !~ m{ \A (?: Provider | Requester ) \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "CommunicationType '$Param{CommunicationType}' is not valid!",
        );
        return;
    }
    if (
        defined $Param{RemoteIP} &&
        $Param{RemoteIP} ne ''
        )
    {
        if ( !IsStringWithData( $Param{RemoteIP} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
        if ( !IsIPv4Address( $Param{RemoteIP} ) && !IsIPv6Address( $Param{RemoteIP} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
    }
    if ( !IsPositiveInteger( $Param{WebserviceID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }
    KEY:
    for my $Key (qw(Data DebugLevel Summary)) {
        next KEY if !defined $Param{$Key};
        if ( !IsString( $Param{$Key} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Key is not a string!",
            );
            return;
        }
    }

    # check if we have a communication chain already
    my $LogData = $Self->LogGet(
        CommunicationID => $Param{CommunicationID},
    );
    if ( !IsHashRefWithData($LogData) ) {

        # no entry yet, create one
        return if !$Self->_LogAddChain(
            CommunicationID   => $Param{CommunicationID},
            CommunicationType => $Param{CommunicationType},
            RemoteIP          => $Param{RemoteIP},
            WebserviceID      => $Param{WebserviceID},
        );
        $LogData = $Self->LogGet(
            CommunicationID => $Param{CommunicationID},
        );
    }
    else {

        # match param against existing chain
        KEY:
        for my $Key (qw(CommunicationType RemoteIP WebserviceID)) {
            next KEY if !defined $Param{$Key};
            next KEY if $Param{$Key} eq $LogData->{$Key};

            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Key does not match current value for this CommunicationID!",
            );
            return;
        }
    }

    # create entry
    if (
        !$Self->{DBObject}->Do(
            SQL =>
                'INSERT INTO gi_debugger_entry_content'
                . ' (content, create_time, debug_level, gi_debugger_entry_id, subject)'
                . ' VALUES (?, current_timestamp, ?, ?, ?)',
            Bind => [
                \$Param{Data}, \$Param{DebugLevel}, \$LogData->{LogID}, \$Param{Summary},
            ],
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not create debug entry in db!',
        );
        return;
    }

    return 1;
}

=item LogGet()

get communication chain data

    my $LogData = $DebugLogObject->LogGet(
        CommunicationID => '6f1ed002ab5595859014ebf0951522d9',
    );

    $LogData = {
        CommunicationID   => '6f1ed002ab5595859014ebf0951522d9',
        CommunicationType => 'Provider',
        Created           => '2011-02-15 16:47:28',
        LogID             => 1,
        RemoteIP          => '192.168.0.1', # optional
        WebserviceID      => 1,
    };

=cut

sub LogGet {
    my ( $Self, %Param ) = @_;

    # check needed param
    if ( !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }

    # check cache
    my $Cache = $Self->{CacheInternalObject}->Get(
        Key => 'LogGet::' . $Param{CommunicationID},
    );
    return $Cache if $Cache;

    # prepare db request
    if (
        !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT communication_id, communication_type, create_time, id, remote_ip,'
                . ' webservice_id FROM gi_debugger_entry WHERE communication_id = ?',
            Bind  => [ \$Param{CommunicationID} ],
            Limit => 1,
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not prepare db query!',
        );
        return;
    }

    # read data
    my %LogData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %LogData = (
            CommunicationID   => $Row[0],
            CommunicationType => $Row[1],
            Created           => $Row[2],
            LogID             => $Row[3],
            RemoteIP          => $Row[4] || '',
            WebserviceID      => $Row[5],
        );
    }

    return if !%LogData;

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => 'LogGet::' . $Param{CommunicationID},
        Value => \%LogData,
    );

    return \%LogData;
}

=item LogGetWithData()

get all individual entries for a communication chain

    my $LogData = $DebugLogObject->LogGetWithData(
        CommunicationID => '6f1ed002ab5595859014ebf0951522d9',
    );

    $LogData = {
        CommunicationID   => '6f1ed002ab5595859014ebf0951522d9',
        CommunicationType => 'Provider',
        Created           => '2011-02-15 16:47:28',
        LogID             => 1,
        RemoteIP          => '192.168.0.1', # optional
        WebserviceID      => 1,
        Data              => [
            {
                Created    => '2011-02-15 17:00:06',
                Data       => 'some logging specific data or structure', # optional
                DebugLevel => 'info',
                Summary    => 'a log bit',
            },
            ...
        ],
    };

=cut

sub LogGetWithData {
    my ( $Self, %Param ) = @_;

    # check needed param
    if ( !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }

    # check if we have data for this communication id
    my $LogData = $Self->LogGet(
        CommunicationID => $Param{CommunicationID},
    );
    if ( !IsHashRefWithData($LogData) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not get communication chain!',
        );
        return;
    }

    # prepare db request
    if (
        !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT create_time, content, debug_level, subject'
                . ' FROM gi_debugger_entry_content WHERE gi_debugger_entry_id = ?'
                . ' ORDER BY create_time ASC',
            Bind => [ \$LogData->{LogID} ],
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not prepare db query!',
        );
        return;
    }

    # read data
    my @LogDataEntries;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %SingleEntry = (
            Created    => $Row[0],
            Data       => $Row[1] || '',
            DebugLevel => $Row[2],
            Summary    => $Row[3],
        );
        push @LogDataEntries, \%SingleEntry;
    }

    $LogData->{Data} = \@LogDataEntries;
    return $LogData;
}

=item LogDelete()

delete a complete communication chain

returns 1 if successful or undef otherwise

    my $Success = $DebugLogObject->LogDelete(
        NoErrorIfEmpty  => 1,                                  # optional
        CommunicationID => '6f1ed002ab5595859014ebf0951522d9', # optional
        WebserviceID    => 1,                                  # optional
                                                               # exactly one id parameter required
    );

=cut

sub LogDelete {
    my ( $Self, %Param ) = @_;

    # check needed params
    my $CommunicationIDValid = IsMD5Sum( $Param{CommunicationID} );
    if ( $Param{CommunicationID} && !$CommunicationIDValid ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }
    my $WebserviceIDValid = IsPositiveInteger( $Param{WebserviceID} );
    if ( $Param{WebserviceID} && !$WebserviceIDValid ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }
    if (
        ( !$CommunicationIDValid && !$WebserviceIDValid )
        ||
        ( $CommunicationIDValid && $WebserviceIDValid )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need exactly one of CommunicationID or WebserviceID!',
        );
        return;
    }

    # check if we have data for this param
    if ($CommunicationIDValid) {
        my $LogData = $Self->LogGet(
            CommunicationID => $Param{CommunicationID},
        );
        if ( !IsHashRefWithData($LogData) ) {
            return 1 if $Param{NoErrorIfEmpty};
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Communication chain does not exist!',
            );
            return;
        }
    }
    else {
        my $LogData = $Self->LogSearch(
            WebserviceID => $Param{WebserviceID},
        );
        if ( !IsArrayRefWithData($LogData) ) {
            return 1 if $Param{NoErrorIfEmpty};
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Communication chain does not exist!',
            );
            return;
        }
    }

    # delete individual entries first
    my $SQLIndividual =
        'DELETE FROM gi_debugger_entry_content
        WHERE gi_debugger_entry_id in( SELECT id FROM gi_debugger_entry ';
    my @BindIndividual;
    if ($CommunicationIDValid) {
        $SQLIndividual .= 'WHERE communication_id = ?';
        push @BindIndividual, \$Param{CommunicationID};
    }
    else {
        $SQLIndividual .= 'WHERE  webservice_id = ?';
        push @BindIndividual, \$Param{WebserviceID};
    }
    $SQLIndividual .= ' )';

    if (
        !$Self->{DBObject}->Do(
            SQL  => $SQLIndividual,
            Bind => \@BindIndividual,
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not remove entries of communication chain in db!',
        );
        return;
    }

    # delete main entry
    my $SQLMain = 'DELETE FROM gi_debugger_entry WHERE';
    my @BindMain;
    if ($CommunicationIDValid) {
        $SQLMain .= ' communication_id = ?';
        push @BindMain, \$Param{CommunicationID};
    }
    else {
        $SQLMain .= ' webservice_id = ?';
        push @BindMain, \$Param{WebserviceID};
    }
    if (
        !$Self->{DBObject}->Do(
            SQL  => $SQLMain,
            Bind => \@BindMain,
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not remove communication chain in db!',
        );
        return;
    }

    # clean cache
    $Self->{CacheInternalObject}->CleanUp();

    return 1;
}

=item LogSearch()

search for log chains based on several criteria
when the parameter 'WithData' is set, the complete communication chains will be returned

    my $LogData = $DebugLogObject->LogSearch(
        CommunicationID   => '6f1ed002ab5595859014ebf0951522d9', # optional
        CommunicationType => 'Provider',     # optional, 'Provider' or 'Requester'
        CreatedAtOrAfter  => '2011-01-01 00:00:00', # optional
        CreatedAtOrBefore => '2011-12-31 23:59:59', # optional
        RemoteIP          => '192.168.0.1', # optional, must be valid IPv4 or IPv6 address
        WebserviceID      => 1, # optional
        WithData          => 0, # optional
    );

    $LogData = [
        {
            CommunicationID   => '6f1ed002ab5595859014ebf0951522d9',
            CommunicationType => 'Provider',
            Created           => '2011-02-15 16:47:28',
            LogID             => 1,
            RemoteIP          => '192.168.0.1', # optional
            WebserviceID      => 1,
            Data              => [ # only when 'WithData' is set
                {
                    Created    => '2011-02-15 17:00:06',
                    Data       => 'some logging specific data or structure', # optional
                    DebugLevel => 'info',
                    Summary    => 'a log bit',
                },
                ...
            ],
        },
        ...
    ];

=cut

sub LogSearch {
    my ( $Self, %Param ) = @_;

    # param check
    KEY:
    for my $Key (
        qw(CommunicationID CommunicationType CreatedAtOrAfter CreatedAtOrBefore RemoteIP WebserviceID WithData)
        )
    {
        next KEY if !defined $Param{$Key};
        next KEY if IsStringWithData( $Param{$Key} );

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Key as a string!",
        );
        return;
    }

    # param syntax check
    if ( $Param{CommunicationID} && !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }
    if (
        $Param{CommunicationType}
        && $Param{CommunicationType} !~ m{ \A (?: Provider | Requester ) \z }xms
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "CommunicationType '$Param{CommunicationType}' is not valid!",
        );
        return;
    }
    KEY:
    for my $Key (qw(CreatedAtOrAfter CreatedAtOrBefore)) {
        next KEY if !$Param{$Key};
        next KEY if $Param{$Key} =~ m{
                \A \d{4} - \d{2} - \d{2} [ ] \d{2} : \d{2} : \d{2} \z
            }xms;

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Key '$Param{$Key}' is not valid!",
        );
        return;
    }
    if (
        defined $Param{RemoteIP} &&
        $Param{RemoteIP} ne ''
        )
    {
        if ( !IsStringWithData( $Param{RemoteIP} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
        if ( !IsIPv4Address( $Param{RemoteIP} ) && !IsIPv6Address( $Param{RemoteIP} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
    }
    if ( $Param{WebserviceID} && !IsPositiveInteger( $Param{WebserviceID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }
    if ( $Param{WithData} && $Param{WithData} !~ m{ \A [01] \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }

    # prepare db request
    my $SQL =
        'SELECT communication_id, communication_type, id, remote_ip, webservice_id, create_time'
        . ' FROM gi_debugger_entry';
    my @Bind     = ();
    my $SQLExt   = '';
    my %NameToDB = (
        CommunicationID   => 'communication_id',
        CommunicationType => 'communication_type',
        RemoteIP          => 'remote_ip',
        WebserviceID      => 'webservice_id',
    );

    OPTION:
    for my $Option (qw(CommunicationID CommunicationType RemoteIP WebserviceID)) {
        next OPTION if !$Param{$Option};
        my $Type = $SQLExt ? 'AND' : 'WHERE';
        $SQLExt .= " $Type $NameToDB{$Option} = ?";
        push @Bind, \$Param{$Option};
    }

    if ( $Param{CreatedAtOrAfter} ) {
        my $Type = $SQLExt ? 'AND' : 'WHERE';
        $SQLExt .= " $Type create_time >= ?";
        push @Bind, \$Param{CreatedAtOrAfter};
    }

    if ( $Param{CreatedAtOrBefore} ) {
        my $Type = $SQLExt ? 'AND' : 'WHERE';
        $SQLExt .= " $Type create_time <= ?";
        push @Bind, \$Param{CreatedAtOrBefore};
    }

    $SQLExt .= ' ORDER BY create_time ASC';

    if (
        !$Self->{DBObject}->Prepare(
            SQL  => $SQL . $SQLExt,
            Bind => \@Bind,
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not prepare db query!',
        );
        return;
    }

    # read data
    my @LogEntries;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %SingleEntry = (
            CommunicationID   => $Row[0],
            CommunicationType => $Row[1],
            LogID             => $Row[2],
            RemoteIP          => $Row[3] || '',
            WebserviceID      => $Row[4],
            Created           => $Row[5],
        );
        push @LogEntries, \%SingleEntry;
    }

    # done if we only need main entries
    return \@LogEntries if !$Param{WithData};

    # we need individual entries
    my @LogEntriesWithData;
    for my $Entry (@LogEntries) {
        my $LogData = $Self->LogGetWithData(
            CommunicationID => $Entry->{CommunicationID},
        );
        return if !$LogData;
        push @LogEntriesWithData, $LogData;
    }

    return \@LogEntriesWithData;
}

=begin Internal:

=cut

=item _LogAddChain()

establish communication chain in database

returns 1 on success or undef on error

    my $Success = $DebugLogObject->_LogAddChain(
        CommunicationID   => '6f1ed002ab5595859014ebf0951522d9',
        CommunicationType => 'Provider',     # 'Provider' or 'Requester'
        RemoteIP          => '192.168.0.1', # optional, must be valid IPv4 or IPv6 address
        WebserviceID      => 1,
    );

=cut

sub _LogAddChain {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(CommunicationID CommunicationType WebserviceID)) {
        next NEEDED if IsStringWithData( $Param{$Needed} );

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need $Needed as a string!",
        );
        return;
    }

    # param syntax check
    if ( !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }
    if ( $Param{CommunicationType} !~ m{ \A (?: Provider | Requester ) \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "CommunicationType '$Param{CommunicationType}' is not valid!",
        );
        return;
    }
    if (
        defined $Param{RemoteIP} &&
        $Param{RemoteIP} ne ''
        )
    {
        if ( !IsStringWithData( $Param{RemoteIP} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
        if ( !IsIPv4Address( $Param{RemoteIP} ) && !IsIPv6Address( $Param{RemoteIP} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
    }
    if ( !IsPositiveInteger( $Param{WebserviceID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }

    if (
        !$Self->{DBObject}->Do(
            SQL =>
                'INSERT INTO gi_debugger_entry'
                . ' (communication_id, communication_type, create_time, remote_ip,'
                . '  webservice_id)'
                . ' VALUES (?, ?, current_timestamp, ?, ?)',
            Bind => [
                \$Param{CommunicationID}, \$Param{CommunicationType},
                \$Param{RemoteIP},        \$Param{WebserviceID},
            ],
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not create debug entry chain in db!',
        );
        return;
    }

    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
