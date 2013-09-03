# --
# Kernel/Modules/AgentTicketStatusView.pm - status for all open tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketStatusView;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::DynamicField;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create additional objects
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{Config}             = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");
    $Self->{Filter}             = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'Open';
    $Self->{View}               = $Self->{ParamObject}->GetParam( Param => 'View' ) || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # get the column filters from the web request
    my %ColumnFilter;
    my %GetColumnFilter;
    COLUMNNAME:
    for my $ColumnName (
        qw(Owner Responsible State Queue Priority Type Lock Service SLA CustomerID CustomerUserID)
        )
    {
        my $FilterValue = $Self->{ParamObject}->GetParam( Param => 'ColumnFilter' . $ColumnName )
            || '';
        next COLUMNNAME if $FilterValue eq '';

        if (
            $FilterValue eq 'DeleteFilter'
            && (
                $ColumnName eq 'CustomerID'
                || $ColumnName eq 'CustomerUserID'
                || $ColumnName eq 'Owner'
                || $ColumnName eq 'Responsible'
            )
            )
        {
            next COLUMNNAME;
        }

        if (
            $FilterValue eq 'DeleteFilter'
            && (
                $ColumnName eq 'CustomerID'
                || $ColumnName eq 'CustomerUserID'
                || $ColumnName eq 'Owner'
                || $ColumnName eq 'Responsible'
            )
            )
        {
            next COLUMNNAME;
        }

        if ( $ColumnName eq 'CustomerID' ) {
            push @{ $ColumnFilter{$ColumnName} }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        elsif ( $ColumnName eq 'CustomerUserID' ) {
            push @{ $ColumnFilter{CustomerUserLogin} }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        else {
            push @{ $ColumnFilter{ $ColumnName . 'IDs' } }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
    }

    # get all dynamic fields
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        my $FilterValue = $Self->{ParamObject}->GetParam(
            Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name}
        );

        next DYNAMICFIELD if !defined $FilterValue;
        next DYNAMICFIELD if $FilterValue eq '';

        $ColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = {
            Equals => $FilterValue,
        };
        $GetColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $FilterValue;
    }

    # starting with page ...
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output;
    if ( $Self->{Subaction} ne 'AJAXFilterUpdate' ) {
        $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->{LayoutObject}->Print( Output => \$Output );
        $Output = '';
    }

    # define filter
    my %Filters = (
        Open => {
            Name   => 'Open tickets',
            Prio   => 1000,
            Search => {
                StateType  => 'Open',
                OrderBy    => $OrderBy,
                SortBy     => $SortBy,
                UserID     => $Self->{UserID},
                Permission => 'ro',
            },
        },
        Closed => {
            Name   => 'Closed tickets',
            Prio   => 1001,
            Search => {
                StateType  => 'Closed',
                OrderBy    => $OrderBy,
                SortBy     => $SortBy,
                UserID     => $Self->{UserID},
                Permission => 'ro',
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # do shown tickets lookup
    my $Limit = 10_000;

    my $ElementChanged = $Self->{ParamObject}->GetParam( Param => 'ElementChanged' ) || '';
    my $HeaderColumn = $ElementChanged;
    $HeaderColumn =~ s{\A ColumnFilter }{}msxg;
    my @OriginalViewableTickets;
    my @ViewableTickets;
    my $ViewableTicketCount = 0;

    # get ticket values
    if (
        !IsStringWithData($HeaderColumn) ||
        (
            IsStringWithData($HeaderColumn) &&
            (
                $Self->{ConfigObject}->Get('OnlyValuesOnTicket') ||
                $HeaderColumn eq 'CustomerID' ||
                $HeaderColumn eq 'CustomerUserID'
            )
        )
        )
    {
        @OriginalViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Filter} }->{Search} },
            Limit  => $Limit,
            Result => 'ARRAY',
        );

        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Filter} }->{Search} },
            %ColumnFilter,
            Limit  => $Limit,
            Result => 'ARRAY',
        );

        $ViewableTicketCount = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Filter} }->{Search} },
            %ColumnFilter,
            Result => 'COUNT',
        );
    }

    if ( $Self->{Subaction} eq 'AJAXFilterUpdate' ) {

        my $FilterContent = $Self->{LayoutObject}->TicketListShow(
            FilterContentOnly   => 1,
            HeaderColumn        => $HeaderColumn,
            ElementChanged      => $ElementChanged,
            OriginalTicketIDs   => \@OriginalViewableTickets,
            Action              => 'AgentTicketStatusView',
            Env                 => $Self,
            View                => $Self->{View},
            EnableColumnFilters => 1,
        );

        if ( !$FilterContent ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't get filter content data of $HeaderColumn!",
            );
        }

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $FilterContent,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {

        my $DeleteFilters = $Self->{ParamObject}->GetParam( Param => 'DeleteFilters' ) || '';

        # store column filters
        my $StoredFilters = \%ColumnFilter;
        if ( !IsArrayRefWithData( \@ViewableTickets ) || $DeleteFilters ) {
            $StoredFilters = {};
        }
        my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $StoredFiltersKey,
            Value  => $Self->{JSONObject}->Encode( Data => $StoredFilters ),
        );
    }

    if ( $ViewableTicketCount > $Limit ) {
        $ViewableTicketCount = $Limit;
    }

    # do nav bar lookup
    my %NavBarFilter;
    for my $Filter ( sort keys %Filters ) {
        my $Count = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{$Filter}->{Search} },
            %ColumnFilter,
            Result => 'COUNT',
        );
        if ( $Count > $Limit ) {
            $Count = $Limit;
        }

        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => $Count,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    my $ColumnFilterLink = '';
    COLUMNNAME:
    for my $ColumnName ( sort keys %GetColumnFilter ) {
        next COLUMNNAME if !$ColumnName;
        next COLUMNNAME if !$GetColumnFilter{$ColumnName};
        $ColumnFilterLink
            .= ';' . $Self->{LayoutObject}->Ascii2Html( Text => 'ColumnFilter' . $ColumnName )
            . '=' . $Self->{LayoutObject}->Ascii2Html( Text => $GetColumnFilter{$ColumnName} )
    }

    # show ticket's
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . $ColumnFilterLink
        . ';';

    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . $ColumnFilterLink

        . ';';
    my $FilterLink = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';

    my $LastColumnFilter = $Self->{ParamObject}->GetParam( Param => 'LastColumnFilter' ) || '';

    if ( !$LastColumnFilter && $ColumnFilterLink ) {

        # is planned to have a link to go back here
        $LastColumnFilter = 1;
    }

    $Output .= $Self->{LayoutObject}->TicketListShow(
        TicketIDs         => \@ViewableTickets,
        OriginalTicketIDs => \@OriginalViewableTickets,
        GetColumnFilter   => \%GetColumnFilter,
        LastColumnFilter  => $LastColumnFilter,
        Action            => 'AgentTicketStatusView',
        RequestedURL      => $Self->{RequestedURL},

        Total      => $ViewableTicketCount,
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        View       => $Self->{View},
        Bulk       => 1,
        Limit      => $Limit,
        TitleName  => 'Status View',
        TitleValue => $Filters{ $Self->{Filter} }->{Name},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $FilterLink,

        OrderBy             => $OrderBy,
        SortBy              => $SortBy,
        EnableColumnFilters => 1,
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return page
    return $Output;
}

1;
