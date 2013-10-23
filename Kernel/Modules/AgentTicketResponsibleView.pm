# --
# Kernel/Modules/AgentTicketResponsibleView.pm - to view all locked tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketResponsibleView;

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

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # create additional objects
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{Filter}             = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'All';
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

    # get filters stored in the user preferences
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
    my $StoredFilters    = $Self->{JSONObject}->Decode(
        Data => $Preferences{$StoredFiltersKey},
    );

    # get the column filters from the web request or user preferences
    my %ColumnFilter;
    my %GetColumnFilter;
    COLUMNNAME:
    for my $ColumnName (
        qw(Owner Responsible State Queue Priority Type Lock Service SLA CustomerID CustomerUserID)
        )
    {
        # get column filter from web request
        my $FilterValue = $Self->{ParamObject}->GetParam( Param => 'ColumnFilter' . $ColumnName )
            || '';

        # if filter is not present in the web request, try with the user preferences
        if ( $FilterValue eq '' ) {
            if ( $ColumnName eq 'CustomerID' ) {
                $FilterValue = $StoredFilters->{$ColumnName}->[0] || '';
            }
            elsif ( $ColumnName eq 'CustomerUserID' ) {
                $FilterValue = $StoredFilters->{CustomerUserLogin}->[0] || '';
            }
            else {
                $FilterValue = $StoredFilters->{ $ColumnName . 'IDs' }->[0] || '';
            }
        }
        next COLUMNNAME if $FilterValue eq '';
        next COLUMNNAME if $FilterValue eq 'DeleteFilter';

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

        # get filter from web request
        my $FilterValue = $Self->{ParamObject}->GetParam(
            Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name}
        );

        # if no filter from web request, try from user preferences
        if ( !defined $FilterValue || $FilterValue eq '' ) {
            $FilterValue
                = $StoredFilters->{ 'DynamicField_' . $DynamicFieldConfig->{Name} }->{Equals};
        }

        next DYNAMICFIELD if !defined $FilterValue;
        next DYNAMICFIELD if $FilterValue eq '';
        next DYNAMICFIELD if $FilterValue eq 'DeleteFilter';

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

    # get locked  viewable tickets...
    my $SortByS = $SortBy;
    if ( $SortByS eq 'CreateTime' ) {
        $SortByS = 'Age';
    }

    # define filter
    my %Filters = (
        All => {
            Name   => 'All',
            Prio   => 1000,
            Search => {
                StateType      => 'Open',
                ResponsibleIDs => [ $Self->{UserID} ],
                OrderBy        => $OrderBy,
                SortBy         => $SortByS,
                UserID         => 1,
                Permission     => 'ro',
            },
        },
        New => {
            Name   => 'New Article',
            Prio   => 1001,
            Search => {
                StateType      => 'Open',
                ResponsibleIDs => [ $Self->{UserID} ],
                TicketFlag     => {
                    Seen => 1,
                },
                TicketFlagUserID => $Self->{UserID},
                OrderBy          => $OrderBy,
                SortBy           => $SortByS,
                UserID           => 1,
                Permission       => 'ro',
            },
        },
        Reminder => {
            Name   => 'Pending',
            Prio   => 1002,
            Search => {
                StateType => [ 'pending reminder', 'pending auto' ],
                ResponsibleIDs => [ $Self->{UserID} ],
                OrderBy        => $OrderBy,
                SortBy         => $SortByS,
                UserID         => 1,
                Permission     => 'ro',
            },
        },
        ReminderReached => {
            Name   => 'Reminder Reached',
            Prio   => 1003,
            Search => {
                StateType                     => ['pending reminder'],
                TicketPendingTimeOlderMinutes => 1,
                ResponsibleIDs                => [ $Self->{UserID} ],
                OrderBy                       => $OrderBy,
                SortBy                        => $SortByS,
                UserID                        => 1,
                Permission                    => 'ro',
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
            Result => 'ARRAY',
            Limit  => 1_000,
        );
    }

    # prepare shown tickets for new article tickets
    if ( $Self->{Filter} eq 'New' ) {

        my @ViewableTicketsAll = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{'All'}->{Search} },
            %ColumnFilter,
            Result => 'ARRAY',
            Limit  => 1_000,
        );

        my %ViewableTicketsNotNew;
        for my $TicketID (@ViewableTickets) {
            $ViewableTicketsNotNew{$TicketID} = 1;
        }

        my @ViewableTicketsTmp;
        for my $TicketIDAll (@ViewableTicketsAll) {
            next if $ViewableTicketsNotNew{$TicketIDAll};
            push @ViewableTicketsTmp, $TicketIDAll;
        }
        @ViewableTickets = @ViewableTicketsTmp;
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

    my %NavBarFilter;
    for my $Filter ( sort keys %Filters ) {
        my $Count = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{$Filter}->{Search} },
            %ColumnFilter,
            Result => 'COUNT',
        );

        # prepare count for new article tickets
        if ( $Filter eq 'New' ) {
            my $CountAll = $Self->{TicketObject}->TicketSearch(
                %{ $Filters{All}->{Search} },
                %ColumnFilter,
                Result => 'COUNT',
            );
            $Count = $CountAll - $Count;
        }

        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => $Count,
            Filter => $Filter,
            %{ $Filters{$Filter} },
            %ColumnFilter,
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

    # show tickets
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
    my $LinkFilter = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
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
        Action            => 'AgentTicketResponsibleView',
        Total             => scalar @ViewableTickets,
        RequestedURL      => $Self->{RequestedURL},

        View => $Self->{View},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'My Responsible Tickets',
        TitleValue => $Filters{ $Self->{Filter} }->{Name},
        Bulk       => 1,

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,

        OrderBy             => $OrderBy,
        SortBy              => $SortBy,
        EnableColumnFilters => 1,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
