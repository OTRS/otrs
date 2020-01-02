# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminCommunicationLog;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %GetParam;
    for my $Param (
        qw(
        CommunicationID ObjectLogID StartTime Filter SortBy
        OrderBy StartHit Expand AccountID Direct PriorityFilter
        )
        )
    {
        $GetParam{$Param} = $ParamObject->GetParam( Param => $Param );
    }

    my $Communication;
    if ( $GetParam{CommunicationID} ) {
        my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
        $Communication = $CommunicationLogDBObj->CommunicationGet(
            CommunicationID => $GetParam{CommunicationID},
        );

        if ( !IsHashRefWithData($Communication) ) {
            return $LayoutObject->FatalError(
                Message => Translatable('Invalid CommunicationID!'),
            );
        }
    }

    my %TimeRanges = (
        0       => Translatable('All communications'),
        3600    => Translatable('Last 1 hour'),
        10800   => Translatable('Last 3 hours'),
        21600   => Translatable('Last 6 hours'),
        43200   => Translatable('Last 12 hours'),
        86400   => Translatable('Last 24 hours'),
        604800  => Translatable('Last week'),
        2593000 => Translatable('Last month'),
    );

    $GetParam{TimeRanges} = \%TimeRanges;

    $GetParam{StartHit}  //= int( $Param{StartHit} || 1 );
    $GetParam{SortBy}    //= 'StartTime';
    $GetParam{OrderBy}   //= 'Down';
    $GetParam{Filter}    //= 'All';
    $GetParam{StartTime} //= 86400;

    if ( $GetParam{StartTime} && $GetParam{StartTime} !~ m{^\d+$} ) {
        return $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Invalid StartTime: %s!', $GetParam{StartTime} ),
        );
    }
    elsif ( $GetParam{StartTime} == 0 ) {
        $GetParam{DateTime} = $GetParam{StartTime};
    }
    else {
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        my $ValidDate      = $DateTimeObject->Subtract(
            Seconds => $GetParam{StartTime},
        );

        if ( !$ValidDate ) {
            return $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Invalid StartTime: %s!', $GetParam{StartTime} ),
            );
        }
        $GetParam{DateTime} = $DateTimeObject->ToString();
    }

    my %SubactionHandlerMap = (
        Overview            => '_ShowOverview',
        Zoom                => '_ZoomView',
        Accounts            => '_AccountsView',
        GetObjectLog        => '_GetObjectLog',
        GetCommunicationLog => '_GetCommunicationLog',
    );

    my $Subaction = $Self->{Subaction};
    if ( !( exists $SubactionHandlerMap{$Subaction} ) ) {
        $Subaction = 'Overview';
    }

    my $SubactionHandler = $SubactionHandlerMap{$Subaction};

    return $Self->$SubactionHandler(
        %GetParam,
        Action        => $Subaction,
        Communication => $Communication,
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    my $TimeRangeStrg = $LayoutObject->BuildSelection(
        Data         => $Param{TimeRanges},
        Name         => 'TimeRange',
        ID           => 'TimeRange',
        SelectedID   => $Param{StartTime} // 86400,
        PossibleNone => 0,
        Translation  => 1,
        Sort         => 'NumericKey',
        Class        => 'Modernize W75pc',
    );

    $LayoutObject->Block(
        Name => 'TimeRange',
        Data => {
            TimeRange => $TimeRangeStrg,
        },
    );

    # Get personal page shown count.
    my $PageShownPreferencesKey = 'AdminCommunicationLogPageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 25;
    my $Group                   = 'CommunicationLogPageShown';

    # Prepare filters.
    my %Filters = (
        All => {
            Name   => Translatable('All'),
            Prio   => 1000,
            Filter => 'All',
            Search => {
                OrderBy => $Param{OrderBy},
                SortBy  => $Param{SortBy},
            },
        },
        Successful => {
            Name   => Translatable('Successful'),
            Prio   => 1001,
            Filter => 'Successful',
            Search => {
                OrderBy => $Param{OrderBy},
                SortBy  => $Param{SortBy},
                Status  => 'Successful',
            },
        },
        Processing => {
            Name   => Translatable('Processing'),
            Prio   => 1002,
            Filter => 'Processing',
            Search => {
                OrderBy => $Param{OrderBy},
                SortBy  => $Param{SortBy},
                Status  => 'Processing',
            },
        },
        Failed => {
            Name   => Translatable('Failed'),
            Prio   => 1004,
            Filter => 'Failed',
            Search => {
                OrderBy => $Param{OrderBy},
                SortBy  => $Param{SortBy},
                Status  => 'Failed',
            },
        },
    );

    if ( !$Filters{ $Param{Filter} } ) {
        return $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Invalid Filter: %s!', $Param{Filter} ),
        );
    }

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    my @CommunicationData;
    for my $Filter ( values %Filters ) {
        my @Communications = @{
            $CommunicationLogDBObj->CommunicationList(
                StartDate => $Param{DateTime},
                %{ $Filter->{Search} },
                )
                || []
        };

        $Filter->{Count} = scalar @Communications;

        if ( $Filter->{Filter} eq $Param{Filter} ) {
            @CommunicationData = @Communications;
        }
    }

    $LayoutObject->Block(
        Name => 'CommunicationNavBarFilter',
        Data => {
            %Param,
        },
    );

    # Generate human readable average processing time.
    my $AverageSeconds = $CommunicationLogDBObj->CommunicationList(
        StartDate => $Param{DateTime},
        Result    => 'AVERAGE',
    );

    my $AverageString = $AverageSeconds >= 1
        ? $Self->_HumanReadableAverage( Seconds => $AverageSeconds )
        : $LayoutObject->{LanguageObject}->Translate('Less than a second');

    my %Accounts = $Self->_AccountStatus(
        StartDate => $Param{DateTime},
        %Param,
    );

    my %AccountsOverview = (
        Failed     => 0,
        Warning    => 0,
        Successful => 0,
    );

    my $Status = '';

    # Assume all accounts are working.
    if (%Accounts) {
        $Status = 'Successful';
    }

    ACCOUNTS:
    for my $AccountKey ( sort keys %Accounts ) {

        my ( $Failed, $Successful );
        if ( $Accounts{$AccountKey}->{Failed} ) {
            $Failed = 1;
        }
        if ( $Accounts{$AccountKey}->{Successful} ) {
            $Successful = 1;
        }

        # Set global account status.
        if ($Failed) {
            $Status = 'Failed';
            if ($Successful) {
                $Status = 'Warning';
            }
        }

        $AccountsOverview{$Status}++;
    }

    my $StatusFilter = 'Successful';
    if ( $Filters{Failed}->{Count} ) {
        $StatusFilter = 'Failed';
    }

    $LayoutObject->Block(
        Name => 'StatusOverview',
        Data => {
            Successful       => $Filters{Successful}->{Count},
            Processing       => $Filters{Processing}->{Count},
            Failed           => $Filters{Failed}->{Count},
            StatusFilter     => $StatusFilter,
            StartTime        => $Param{StartTime} || 0,
            TimeRange        => $LayoutObject->{LanguageObject}->Translate( $Param{TimeRanges}->{ $Param{StartTime} } ),
            AverageString    => $AverageString,
            AccountsStatus   => $Status,
            AccountsOverview => \%AccountsOverview,
        },
    );

    my $Total = scalar @CommunicationData;

    # Get data selection.
    my %Data;
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # Calculate max. shown per page.
    if ( $Param{StartHit} > $Total ) {
        my $Pages = int( ( $Total / $PageShown ) + 0.99999 );
        $Param{StartHit} = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    my $URLExtension = 'Expand=1;';

    for my $URLPart (qw(Filter SortBy OrderBy StartTime)) {
        $URLExtension .= "$URLPart=$Param{$URLPart};";
    }

    # Build nav bar.
    my $Limit   = $Param{Limit} || 20_000;
    my %PageNav = $LayoutObject->PageNavBar(
        Limit     => $Limit,
        StartHit  => $Param{StartHit},
        PageShown => $PageShown,
        AllHits   => $Total || 0,
        Action    => 'Action=' . $LayoutObject->{Action},
        Link      => $URLExtension,
        IDPrefix  => $LayoutObject->{Action},
    );

    # Build shown dynamic fields per page.
    $Param{RequestedURL} = "Action=$Self->{Action};$URLExtension";

    for my $URLPart (qw(Filter SortBy OrderBy StartTime)) {
        $Param{RequestedURL} .= ";$URLPart=$Param{$URLPart}";
    }

    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $LayoutObject->BuildSelection(
        Name        => $PageShownPreferencesKey,
        SelectedID  => $PageShown,
        Translation => 0,
        Data        => \%Data,
        Sort        => 'NumericValue',
        Class       => 'Modernize',
    );

    if (%PageNav) {
        $LayoutObject->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        $LayoutObject->Block(
            Name => 'ContextSettings',
            Data => { %PageNav, %Param, },
        );
    }

    for my $FilterItem ( sort { $a->{Prio} <=> $b->{Prio} } values %Filters ) {
        $LayoutObject->Block(
            Name => 'CommunicationNavBarFilterItem',
            Data => {
                %Param,
                %{$FilterItem},
                Selected => ( $FilterItem->{Filter} eq $Param{Filter} ) ? 1 : 0,
            },
        );
    }

    my @TableHeaders = (
        {
            HeaderName => Translatable('Status'),
            SortByName => 'Status',
            Class      => 'Status Center',
        },
        {
            HeaderName => Translatable('Transport'),
            SortByName => 'Transport',
            Class      => 'Transport',
        },
        {
            HeaderName => Translatable('Direction'),
            SortByName => 'Direction',
            Class      => 'Direction Center',
        },
        {
            HeaderName => Translatable('Account'),
            SortByName => 'Account',
            Class      => 'Account',
        },
        {
            HeaderName => Translatable('Start Time'),
            SortByName => 'StartTime',
            Class      => 'StartTime',
        },
        {
            HeaderName => Translatable('End Time'),
            SortByName => 'EndTime',
            Class      => 'EndTime',
        },
        {
            HeaderName => Translatable('Duration'),
            SortByName => 'Duration',
            Class      => 'Duration',
        },
    );

    my $HeaderURL = 'Expand=1;';

    for my $URLPart (qw(Filter StartTime)) {
        $HeaderURL .= "$URLPart=$Param{$URLPart};";
    }

    for my $TableHeader (@TableHeaders) {

        my $CSS             = $TableHeader->{Class};
        my $TranslatedTitle = $LayoutObject->{LanguageObject}->Translate( $TableHeader->{HeaderName} );
        my $OrderBy;

        if ( $Param{SortBy} eq $TableHeader->{SortByName} ) {
            if ( $Param{OrderBy} eq 'Up' ) {
                $OrderBy = 'Down';
                $CSS .= ' SortAscendingLarge';
            }
            else {
                $OrderBy = 'Up';
                $CSS .= ' SortDescendingLarge';
            }

            # Set title description.
            my $TitleDesc = $OrderBy eq 'Up'
                ? $LayoutObject->{LanguageObject}->Translate('sorted descending')
                : $LayoutObject->{LanguageObject}->Translate('sorted ascending');
            $TranslatedTitle .= ', ' . $TitleDesc;
        }

        $LayoutObject->Block(
            Name => 'TableHeader',
            Data => {
                HeaderName => $TableHeader->{HeaderName},
                SortByName => $TableHeader->{SortByName},
                OrderBy    => $OrderBy,
                CSS        => $CSS,
                Title      => $TranslatedTitle,
                HeaderLink => $HeaderURL,
            },
        );
    }

    # Prepare communication data.
    if (@CommunicationData) {
        my $Counter = 0;

        for my $Communication (@CommunicationData) {
            $Counter++;

            if ( $Counter >= $Param{StartHit} && $Counter < ( $PageShown + $Param{StartHit} ) ) {
                my $Account = '-';
                if ( $Communication->{AccountID} ) {
                    $Account = $CommunicationLogDBObj->CommunicationAccountLabelGet(
                        AccountType => $Communication->{AccountType},
                        AccountID   => $Communication->{AccountID},
                        Transport   => $Communication->{Transport},
                    );
                }
                elsif ( $Communication->{AccountType} ) {
                    $Account = $Communication->{AccountType};
                }

                $LayoutObject->Block(
                    Name => 'CommunicationRow',
                    Data => {
                        %{$Communication},
                        DisplayAccount => $Account,
                    },
                );
            }
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'NoCommunicationsFound',
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminCommunicationLog',
        Data         => {
            %Param,
            CommunicationCount => $Filters{All}->{Count},
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _ZoomView {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # Call all needed template blocks.
    $LayoutObject->Block(
        Name => 'Main',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'Hint',
        Data => \%Param,
    );

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $Communication         = $Param{Communication};
    my $CommunicationObjects  = $CommunicationLogDBObj->ObjectLogList(
        CommunicationID => $Communication->{CommunicationID},
    );

    if ( !IsArrayRefWithData($CommunicationObjects) ) {
        $LayoutObject->Block(
            Name => 'NoCommunicationObjectsFound',
        );
    }

    my $Direction = $Communication->{Direction};

    for my $CommunicationObject ( @{$CommunicationObjects} ) {
        $CommunicationObject->{Direction} = $Direction;

        # Get account specific information.
        if ( $Communication->{AccountType} && $Communication->{AccountID} ) {

            $CommunicationObject->{AccountLabel} = $CommunicationLogDBObj->CommunicationAccountLabelGet(
                AccountType => $Communication->{AccountType},
                AccountID   => $Communication->{AccountID},
                Transport   => $Communication->{Transport},
            );
            $CommunicationObject->{AccountLink} = $CommunicationLogDBObj->CommunicationAccountLinkGet(
                AccountType => $Communication->{AccountType},
                AccountID   => $Communication->{AccountID},
                Transport   => $Communication->{Transport},
            );
            $CommunicationObject->{AccountType} = $Communication->{AccountType};
        }
        else {
            $CommunicationObject->{AccountLabel} = $Communication->{AccountType};
            $CommunicationObject->{AccountType}  = $Communication->{AccountType};
        }

        $LayoutObject->Block(
            Name => 'CommunicationObjectRow',
            Data => $CommunicationObject,
        );
    }

    my $PriorityFilterStrg = $LayoutObject->BuildSelection(
        Data => [
            Translatable('Trace'),
            Translatable('Debug'),
            Translatable('Info'),
            Translatable('Notice'),
            Translatable('Warn'),
            Translatable('Error'),
        ],
        Name         => 'PriorityFilter',
        ID           => 'PriorityFilter',
        SelectedID   => $Param{PriorityFilter} // 'Trace',
        PossibleNone => 0,
        Translation  => 1,
        Class        => 'Modernize W75pc',
    );

    # Send CommunicationID to JS.
    $LayoutObject->AddJSData(
        Key   => 'CommunicationID',
        Value => $Param{CommunicationID},
    );

    # Send ObjectLogID to JS.
    $LayoutObject->AddJSData(
        Key   => 'ObjectLogID',
        Value => $Param{ObjectLogID},
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminCommunicationLogZoom',
        Data         => {
            %Param,
            ObjectCount      => scalar @{$CommunicationObjects},
            PriorityFilter   => $PriorityFilterStrg,
            CommunicationLog => $Communication,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _AccountsView {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( $Param{Direct} && $Param{AccountID} ) {
        $LayoutObject->AddJSData(
            Key   => 'AccountID',
            Value => $Param{AccountID},
        );
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    my $TimeRangeStrg = $LayoutObject->BuildSelection(
        Data         => $Param{TimeRanges},
        Name         => 'TimeRangeAccounts',
        ID           => 'TimeRangeAccounts',
        SelectedID   => $Param{StartTime},
        PossibleNone => 0,
        Translation  => 1,
        Sort         => 'NumericKey',
        Class        => 'Modernize W75pc',
    );

    $LayoutObject->Block(
        Name => 'TimeRange',
        Data => {
            TimeRange => $TimeRangeStrg,
        },
    );

    my %Accounts = $Self->_AccountStatus(
        StartDate => $Param{DateTime},
        %Param,
    );

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    if ( !scalar keys %Accounts ) {
        $LayoutObject->Block(
            Name => 'NoAccountsFound',
        );
    }
    else {
        for my $AccountKey ( sort keys %Accounts ) {

            my $Account = $Accounts{$AccountKey};

            my $AccountLabel = $Account->{AccountType} // '-';
            my ( $AccountLink, $AverageSeconds );

            if ( $Account->{AccountID} ) {
                $AccountLabel = $CommunicationLogDBObj->CommunicationAccountLabelGet(
                    AccountType => $Account->{AccountType},
                    AccountID   => $Account->{AccountID},
                    Transport   => $Account->{Transport},
                );
                $AccountLink = $CommunicationLogDBObj->CommunicationAccountLinkGet(
                    AccountType => $Account->{AccountType},
                    AccountID   => $Account->{AccountID},
                    Transport   => $Account->{Transport},
                );
                $AverageSeconds = $CommunicationLogDBObj->CommunicationList(
                    StartDate => $Param{DateTime},
                    AccountID => $Account->{AccountID},
                    Result    => 'AVERAGE',
                );
            }
            else {
                $AverageSeconds = $CommunicationLogDBObj->CommunicationList(
                    StartDate   => $Param{DateTime},
                    AccountType => $Account->{AccountType},
                    Result      => 'AVERAGE',
                );
            }

            # Generate human readable average processing time.
            my $AverageString = $AverageSeconds >= 1
                ? $Self->_HumanReadableAverage( Seconds => $AverageSeconds )
                : $LayoutObject->{LanguageObject}->Translate('Less than a second');

            my $HealthStatus = $Self->_CheckHealth($Account);

            my $AccountErrorLink;
            if ( $HealthStatus ne 'Successful' ) {
                my $CommunicationID = $Account->{Failed}[0];
                if ($CommunicationID) {
                    $AccountErrorLink = "Subaction=Zoom;CommunicationID=$CommunicationID";
                }
            }

            $LayoutObject->Block(
                Name => 'AccountRow',
                Data => {
                    AccountLabel     => $AccountLabel,
                    AccountLink      => $AccountLink,
                    AccountStatus    => $HealthStatus,
                    AccountErrorLink => $AccountErrorLink,
                    AccountKey       => $AccountKey,
                    AverageSeconds   => $AverageSeconds,
                    AverageString    => $AverageString,
                },
            );

        }
    }

    my $CommunicationLogCount = 0;

    if ( $Param{Direct} ) {
        $CommunicationLogCount = $Self->_GetCommunicationLog(%Param);
    }
    else {
        $LayoutObject->Block(
            Name => 'NoCommunicationLogsFound',
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminCommunicationLogAccounts',
        Data         => {
            %Param,
            CommunicationLogCount => $CommunicationLogCount,
            TimeRange => $LayoutObject->{LanguageObject}->Translate( $Param{TimeRanges}->{ $Param{StartTime} } ),
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetObjectLog {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $CommunicationLogDBObj   = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationObjectLogs = $CommunicationLogDBObj->ObjectLogEntryList(
        ObjectLogID => $Param{ObjectLogID},
        OrderBy     => 'up',
    );

    if ( !IsArrayRefWithData($CommunicationObjectLogs) ) {
        $LayoutObject->Block(
            Name => 'NoObjectLogsFound',
        );
    }

    for my $CommunicationObjectLog ( @{$CommunicationObjectLogs} ) {
        $LayoutObject->Block(
            Name => 'ObjectLogEntry',
            Data => $CommunicationObjectLog,
        );
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AdminCommunicationLogObjectLog',
        Data         => {
            %Param,
            ObjectLogCount => scalar @{$CommunicationObjectLogs},
        },
    );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $Output,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _GetCommunicationLog {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # $Param{AccountID} can be like 'DoNotSendEmail' or 'IMAPS::1', for example.
    my ( $AccountType, $AccountID ) = split '::', $Param{AccountID};

    my $CommunicationLogDBObj   = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationLogObjects = $CommunicationLogDBObj->ObjectLogList(
        AccountID => $AccountID || $Param{AccountID},
        StartDate => $Param{DateTime},
    );

    # Get personal page shown count.
    my $PageShownPreferencesKey = 'AdminCommunicationLogPageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 25;
    my $Group                   = 'CommunicationLogPageShown';

    my %CommunicationIDs;
    my $Counter = 0;

    COMMUNICATIONLOGOBJECT:
    for my $LogObject ( @{$CommunicationLogObjects} ) {

        next COMMUNICATIONLOGOBJECT if $CommunicationIDs{ $LogObject->{CommunicationID} };

        $Counter++;

        if ( $Counter >= $Param{StartHit} && $Counter < ( $PageShown + $Param{StartHit} ) ) {

            my %CommunicationLog = %{
                $CommunicationLogDBObj->CommunicationGet(
                    CommunicationID => $LogObject->{CommunicationID},
                    )
                    || {}
            };

            next COMMUNICATIONLOGOBJECT if $CommunicationLog{AccountType} ne $AccountType;

            next COMMUNICATIONLOGOBJECT if $AccountID && $CommunicationLog{AccountID} ne $AccountID;

            $CommunicationIDs{ $LogObject->{CommunicationID} } = 1;

            $LayoutObject->Block(
                Name => 'CommunicationLogRow',
                Data => \%CommunicationLog,
            );
        }
    }

    if ( !%CommunicationIDs ) {
        $LayoutObject->Block(
            Name => 'NoCommunicationLogsFound',
        );
    }

    return scalar keys %CommunicationIDs if $Param{Direct};

    my $Total = scalar keys %CommunicationIDs;

    # Get data selection.
    my %Data;
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # Calculate max. shown per page.
    if ( $Param{StartHit} > $Total ) {
        my $Pages = int( ( $Total / $PageShown ) + 0.99999 );
        $Param{StartHit} = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    my $URLExtension = 'Direct=1;';

    for my $URLPart (qw(SortBy OrderBy StartTime AccountID)) {
        $URLExtension .= "$URLPart=$Param{$URLPart};";
    }

    # Build nav bar.
    my $Limit   = $Param{Limit} || 20_000;
    my %PageNav = $LayoutObject->PageNavBar(
        Limit     => $Limit,
        StartHit  => $Param{StartHit},
        PageShown => $PageShown,
        AllHits   => $Total || 0,
        Action    => 'Action=' . $LayoutObject->{Action} . ';Subaction=Accounts',
        Link      => $URLExtension,
    );

    # Build shown dynamic fields per page.
    $Param{RequestedURL} = "Action=$Self->{Action};$URLExtension";

    for my $URLPart (qw(SortBy OrderBy StartTime)) {
        $Param{RequestedURL} .= ";$URLPart=$Param{$URLPart}";
    }

    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $LayoutObject->BuildSelection(
        Name        => $PageShownPreferencesKey,
        SelectedID  => $PageShown,
        Translation => 0,
        Data        => \%Data,
    );

    if (%PageNav) {
        $LayoutObject->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AdminCommunicationLogCommunications',
        Data         => {
            %Param,
            CommunicationLogCount => scalar keys %CommunicationIDs,
        },
    );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $Output,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _HumanReadableAverage {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $DateTimeAverageStart = $Kernel::OM->Create('Kernel::System::DateTime');
    my $DateTimeAverageStop  = $Kernel::OM->Create('Kernel::System::DateTime');

    $DateTimeAverageStop->Add( Seconds => $Param{Seconds} );

    my $AverageDelta = $DateTimeAverageStart->Delta( DateTimeObject => $DateTimeAverageStop );

    my @HumanReadableUnits;

    if ( $AverageDelta->{Days} ) {
        push @HumanReadableUnits,
            "$AverageDelta->{Days} " .
            (
            $AverageDelta->{Days} > 1
            ? $LayoutObject->{LanguageObject}->Translate('days')
            : $LayoutObject->{LanguageObject}->Translate('day')
            );
    }

    if ( $AverageDelta->{Hours} ) {
        push @HumanReadableUnits,
            "$AverageDelta->{Hours} " .
            (
            $AverageDelta->{Hours} > 1
            ? $LayoutObject->{LanguageObject}->Translate('hours')
            : $LayoutObject->{LanguageObject}->Translate('hour')
            );
    }

    if ( $AverageDelta->{Minutes} ) {
        push @HumanReadableUnits,
            "$AverageDelta->{Minutes} " .
            (
            $AverageDelta->{Minutes} > 1
            ? $LayoutObject->{LanguageObject}->Translate('minutes')
            : $LayoutObject->{LanguageObject}->Translate('minute')
            );
    }

    if ( $AverageDelta->{Seconds} ) {
        push @HumanReadableUnits,
            "$AverageDelta->{Seconds} " .
            (
            $AverageDelta->{Seconds} > 1
            ? $LayoutObject->{LanguageObject}->Translate('seconds')
            : $LayoutObject->{LanguageObject}->Translate('second')
            );
    }

    return if !@HumanReadableUnits;

    return join ', ', @HumanReadableUnits;
}

sub _AccountStatus {
    my ( $Self, %Param ) = @_;

    my %Filter = (
        ObjectLogStartDate => $Param{StartDate},
    );

    if ( $Param{Status} ) {
        $Filter{ObjectLogStatus} = $Param{Status};
    }

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $Connections           = $CommunicationLogDBObj->GetConnectionsObjectsAndCommunications(%Filter);
    if ( !$Connections || !@{$Connections} ) {
        return;
    }

    my %Account;
    for my $Connection (@$Connections) {

        my $AccountKey = $Connection->{AccountType};
        if ( $Connection->{AccountID} ) {
            $AccountKey .= "::$Connection->{AccountID}";
        }

        if ( !$Account{$AccountKey} ) {
            $Account{$AccountKey} = {
                AccountID   => $Connection->{AccountID},
                AccountType => $Connection->{AccountType},
                Transport   => $Connection->{Transport},
            };
        }

        $Account{$AccountKey}->{ $Connection->{ObjectLogStatus} } ||= [];

        push @{ $Account{$AccountKey}->{ $Connection->{ObjectLogStatus} } },
            $Connection->{CommunicationID};
    }

    for my $AccountKey ( sort keys %Account ) {
        $Account{$AccountKey}->{Status} =
            $Self->_CheckHealth( $Account{$AccountKey} );
    }

    return %Account;

}

sub _CheckHealth {
    my ( $Self, $Connections ) = @_;

    # Success if all is Successful;
    # Failed if all is Failed;
    # Warning if has both Successful and Failed Connections;

    my $Health = 'Success';

    if ( scalar $Connections->{Failed} ) {
        $Health = 'Failed';
        if ( scalar $Connections->{Successful} ) {
            $Health = 'Warning';
        }
    }

    return $Health;

}

1;
