# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::GenericInterface::DebugLog;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::GenericInterface::DebugLog - log interface for generic interface

=head1 DESCRIPTION

All log functions.

=head1 PUBLIC INTERFACE

=head2 new()

create a debug log object. Do not use it directly, instead use:

    my $DebugLogObject = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'GenericInterfaceDebugLog';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 LogAdd()

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

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed as a string!",
        );
        return;
    }

    # param syntax check
    if ( !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }
    if ( $Param{CommunicationType} !~ m{ \A (?: Provider | Requester ) \z }xms ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
        if ( !IsIPv4Address( $Param{RemoteIP} ) && !IsIPv6Address( $Param{RemoteIP} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
    }
    if ( !IsPositiveInteger( $Param{WebserviceID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }
    KEY:
    for my $Key (qw(Data DebugLevel Summary)) {
        next KEY if !defined $Param{$Key};
        if ( !IsString( $Param{$Key} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Key does not match current value for this CommunicationID!",
            );
            return;
        }
    }

    # create entry
    if (
        !$Kernel::OM->Get('Kernel::System::DB')->Do(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not create debug entry in db!',
        );
        return;
    }

    return 1;
}

=head2 LogGet()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => 'LogGet::' . $Param{CommunicationID},
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # prepare db request
    if (
        !$DBObject->Prepare(
            SQL =>
                'SELECT communication_id, communication_type, create_time, id, remote_ip,'
                . ' webservice_id FROM gi_debugger_entry WHERE communication_id = ?',
            Bind  => [ \$Param{CommunicationID} ],
            Limit => 1,
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not prepare db query!',
        );
        return;
    }

    # read data
    my %LogData;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => 'LogGet::' . $Param{CommunicationID},
        Value => \%LogData,
    );

    return \%LogData;
}

=head2 LogGetWithData()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not get communication chain!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # prepare db request
    if (
        !$DBObject->Prepare(
            SQL =>
                'SELECT create_time, content, debug_level, subject'
                . ' FROM gi_debugger_entry_content WHERE gi_debugger_entry_id = ?'
                . ' ORDER BY create_time ASC, id ASC',
            Bind => [ \$LogData->{LogID} ],
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not prepare db query!',
        );
        return;
    }

    # read data
    my @LogDataEntries;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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

=head2 LogDelete()

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }
    my $WebserviceIDValid = IsPositiveInteger( $Param{WebserviceID} );
    if ( $Param{WebserviceID} && !$WebserviceIDValid ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Communication chain does not exist!',
            );
            return;
        }
    }
    else {
        my $LogData = $Self->LogSearch(
            Limit        => 1,
            WebserviceID => $Param{WebserviceID},
        );
        if ( !IsArrayRefWithData($LogData) ) {
            return 1 if $Param{NoErrorIfEmpty};
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if (
        !$DBObject->Do(
            SQL  => $SQLIndividual,
            Bind => \@BindIndividual,
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        !$DBObject->Do(
            SQL  => $SQLMain,
            Bind => \@BindMain,
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not remove communication chain in db!',
        );
        return;
    }

    # clean cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 LogSearch()

search for log chains based on several criteria
when the parameter 'WithData' is set, the complete communication chains will be returned

    my $LogData = $DebugLogObject->LogSearch(
        CommunicationID   => '6f1ed002ab5595859014ebf0951522d9', # optional
        CommunicationType => 'Provider',     # optional, 'Provider' or 'Requester'
        CreatedAtOrAfter  => '2011-01-01 00:00:00', # optional
        CreatedAtOrBefore => '2011-12-31 23:59:59', # optional
        Limit             => 1000, # optional, default 100
        RemoteIP          => '192.168.0.1', # optional, must be valid IPv4 or IPv6 address
        WebserviceID      => 1, # optional
        WithData          => 0, # optional
        Sort              => 'ASC', # optional. 'ASC' (default) or 'DESC'
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
        qw(CommunicationID CommunicationType CreatedAtOrAfter CreatedAtOrBefore Limit RemoteIP WebserviceID WithData)
        )
    {
        next KEY if !defined $Param{$Key};
        next KEY if IsStringWithData( $Param{$Key} );

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Key as a string!",
        );
        return;
    }

    # param syntax check
    if ( $Param{CommunicationID} && !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Key '$Param{$Key}' is not valid!",
        );
        return;
    }
    if ( $Param{Limit} && !IsPositiveInteger( $Param{Limit} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Limit is not a positive integer!',
        );
        return;
    }
    if (
        defined $Param{RemoteIP} &&
        $Param{RemoteIP} ne ''
        )
    {
        if ( !IsStringWithData( $Param{RemoteIP} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
        if ( !IsIPv4Address( $Param{RemoteIP} ) && !IsIPv6Address( $Param{RemoteIP} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
    }
    if ( $Param{WebserviceID} && !IsPositiveInteger( $Param{WebserviceID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }
    if ( $Param{WithData} && $Param{WithData} !~ m{ \A [01] \z }xms ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }
    if (
        IsStringWithData( $Param{Sort} )
        && $Param{Sort} ne 'ASC'
        && $Param{Sort} ne 'DESC'
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Sort must be 'DESC' or 'ASC'!",
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

    my $SQLSort = IsStringWithData( $Param{Sort} ) ? $Param{Sort} : 'ASC';
    $SQLExt .= ' ORDER BY create_time ' . $SQLSort;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if (
        !$DBObject->Prepare(
            SQL   => $SQL . $SQLExt,
            Bind  => \@Bind,
            Limit => $Param{Limit} || 100,
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not prepare db query!',
        );
        return;
    }

    # read data
    my @LogEntries;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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

=head2 LogCleanup()

removes all log entries (including content) from a given time and before.

returns 1 if successful or undef otherwise

    my $Success = $DebugLogObject->LogCleanup(
        CreatedAtOrBefore => '2011-12-31 23:59:59',
    );

=cut

sub LogCleanup {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CreatedAtOrBefore} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CreatedAtOrBefore",
        );

        return;
    }

    if ( $Param{CreatedAtOrBefore} !~ m{ \A \d{4} - \d{2} - \d{2} [ ] \d{2} : \d{2} : \d{2} \z }xms ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "CreatedAtOrBefore is not valid!",
        );
        return;
    }

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Success        = $DateTimeObject->Set( String => $Param{CreatedAtOrBefore} );
    if ( !$Success ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "CreatedAtOrBefore is not valid!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get main debug log entries to delete
    if (
        !$DBObject->Prepare(
            SQL  => 'SELECT id FROM gi_debugger_entry WHERE create_time <= ?',
            Bind => [ \$Param{CreatedAtOrBefore} ],
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not prepare db query!',
        );
        return;
    }
    my @LogEntryIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @LogEntryIDs, $Row[0];
    }

    return 1 if !@LogEntryIDs;

    my $LogEntryIDsStr = join ',', @LogEntryIDs;

    # Remove debug log entries contents.
    if (
        !$DBObject->Do(
            SQL => "
            DELETE FROM gi_debugger_entry_content
            WHERE gi_debugger_entry_id in( $LogEntryIDsStr )",
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not remove entries of communication chains in db!',
        );
        return;
    }

    # Remove debug log entries.
    if (
        !$DBObject->Do(
            SQL => "
            DELETE FROM gi_debugger_entry
            WHERE id in( $LogEntryIDsStr )",
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not remove communication chains in db!',
        );
        return;
    }

    return 1;
}

=begin Internal:

=cut

=head2 _LogAddChain()

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

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed as a string!",
        );
        return;
    }

    # param syntax check
    if ( !IsMD5Sum( $Param{CommunicationID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'CommunicationID is not an md5sum!',
        );
        return;
    }
    if ( $Param{CommunicationType} !~ m{ \A (?: Provider | Requester ) \z }xms ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
        if ( !IsIPv4Address( $Param{RemoteIP} ) && !IsIPv6Address( $Param{RemoteIP} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RemoteIP '$Param{RemoteIP}' is not a valid IPv4 or IPv6 address!",
            );
            return;
        }
    }
    if ( !IsPositiveInteger( $Param{WebserviceID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'WebserviceID is not a positive integer!',
        );
        return;
    }

    if (
        !$Kernel::OM->Get('Kernel::System::DB')->Do(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not create debug entry chain in db!',
        );
        return;
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
