# --
# Kernel/Output/HTML/DashboardTicketGeneric.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketGeneric;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::Ticket::ColumnFilter;
use Kernel::System::CustomerUser;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Item (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $Item!" if ( !$Self->{$Item} );
    }

    # create additional objects
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{ColumnFilterObject} = Kernel::System::Ticket::ColumnFilter->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    my $RemoveFilters
        = $Self->{ParamObject}->GetParam( Param => 'RemoveFilters' )
        || $Param{RemoveFilters}
        || 0;

    # get sorting params
    for my $Item (qw(SortBy OrderBy)) {
        $Self->{$Item} = $Self->{ParamObject}->GetParam( Param => $Item ) || $Param{$Item};
    }

    # set filter settings
    for my $Item (qw(ColumnFilter GetColumnFilter GetColumnFilterSelect)) {
        $Self->{$Item} = $Param{$Item};
    }

    # save column filters
    $Self->{PrefKeyColumnFilters} = 'UserDashboardTicketGenericColumnFilters' . $Self->{Name};
    $Self->{PrefKeyColumnFiltersRealKeys}
        = 'UserDashboardTicketGenericColumnFiltersRealKeys' . $Self->{Name};

    if ($RemoveFilters) {
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{PrefKeyColumnFilters},
            Value  => '',
        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{PrefKeyColumnFiltersRealKeys},
            Value  => '',
        );
    }

    # just in case new filter values arrive
    elsif (
        IsHashRefWithData( $Self->{GetColumnFilter} )       &&
        IsHashRefWithData( $Self->{GetColumnFilterSelect} ) &&
        IsHashRefWithData( $Self->{ColumnFilter} )
        )
    {

        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {

            # check if the user has filter preferences for this widget
            my %Preferences = $Self->{UserObject}->GetPreferences(
                UserID => $Self->{UserID},
            );
            my $ColumnPrefValues;
            if ( $Preferences{ $Self->{PrefKeyColumnFilters} } ) {
                $ColumnPrefValues = $Self->{JSONObject}->Decode(
                    Data => $Preferences{ $Self->{PrefKeyColumnFilters} },
                );
            }

            PREFVALUES:
            for my $Column ( sort keys %{ $Self->{GetColumnFilterSelect} } ) {
                if ( $Self->{GetColumnFilterSelect}->{$Column} eq 'DeleteFilter' ) {
                    delete $ColumnPrefValues->{$Column};
                    next PREFVALUES;
                }
                $ColumnPrefValues->{$Column} = $Self->{GetColumnFilterSelect}->{$Column};
            }

            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $Self->{PrefKeyColumnFilters},
                Value  => $Self->{JSONObject}->Encode( Data => $ColumnPrefValues ),
            );

            # save real key's name
            my $ColumnPrefRealKeysValues;
            if ( $Preferences{ $Self->{PrefKeyColumnFiltersRealKeys} } ) {
                $ColumnPrefRealKeysValues = $Self->{JSONObject}->Decode(
                    Data => $Preferences{ $Self->{PrefKeyColumnFiltersRealKeys} },
                );
            }
            REALKEYVALUES:
            for my $Column ( sort keys %{ $Self->{ColumnFilter} } ) {
                next REALKEYVALUES if !$Column;

                my $DeleteFilter = 0;
                if ( IsArrayRefWithData( $Self->{ColumnFilter}->{$Column} ) ) {
                    if ( grep { $_ eq 'DeleteFilter' } @{ $Self->{ColumnFilter}->{$Column} } ) {
                        $DeleteFilter = 1;
                    }
                }
                elsif ( IsHashRefWithData( $Self->{ColumnFilter}->{$Column} ) ) {

                    if (
                        grep { $Self->{ColumnFilter}->{$Column}->{$_} eq 'DeleteFilter' }
                        keys %{ $Self->{ColumnFilter}->{$Column} }
                        )
                    {
                        $DeleteFilter = 1;
                    }
                }

                if ($DeleteFilter) {
                    delete $ColumnPrefRealKeysValues->{$Column};
                    delete $Self->{ColumnFilter}->{$Column};
                    next REALKEYVALUES;
                }
                $ColumnPrefRealKeysValues->{$Column} = $Self->{ColumnFilter}->{$Column};
            }
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $Self->{PrefKeyColumnFiltersRealKeys},
                Value  => $Self->{JSONObject}->Encode( Data => $ColumnPrefRealKeysValues ),
            );

        }
    }

    # check if the user has filter preferences for this widget
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );

    # get column names from Preferences
    my $PreferencesColumnFilters;
    if ( $Preferences{ $Self->{PrefKeyColumnFilters} } ) {
        $PreferencesColumnFilters = $Self->{JSONObject}->Decode(
            Data => $Preferences{ $Self->{PrefKeyColumnFilters} },
        );
    }

    if ($PreferencesColumnFilters) {
        $Self->{GetColumnFilterSelect} = $PreferencesColumnFilters;
        for my $Field ( keys %{$PreferencesColumnFilters} ) {
            $Self->{GetColumnFilter}->{ $Field . $Self->{Name} }
                = $PreferencesColumnFilters->{$Field};
        }
    }

    # get column real names from Preferences
    my $PreferencesColumnFiltersRealKeys;
    if ( $Preferences{ $Self->{PrefKeyColumnFiltersRealKeys} } ) {
        $PreferencesColumnFiltersRealKeys = $Self->{JSONObject}->Decode(
            Data => $Preferences{ $Self->{PrefKeyColumnFiltersRealKeys} },
        );
    }

    if ($PreferencesColumnFiltersRealKeys) {
        for my $Field ( keys %{$PreferencesColumnFiltersRealKeys} ) {
            $Self->{ColumnFilter}->{$Field} = $PreferencesColumnFiltersRealKeys->{$Field};
        }
    }

    # get current filter
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardTicketGenericFilter' . $Self->{Name};
    if ( $Self->{Name} eq $Name ) {
        $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
    }

    # remember filter
    if ( $Self->{Filter} ) {

        # update session
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $PreferencesKey,
            Value     => $Self->{Filter},
        );

        # update preferences
        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $PreferencesKey,
                Value  => $Self->{Filter},
            );
        }
    }
    else {
        $Self->{Filter} = $Self->{$PreferencesKey} || $Self->{Config}->{Filter} || 'All';
    }

    $Self->{PrefKeyShown}   = 'UserDashboardPref' . $Self->{Name} . '-Shown';
    $Self->{PrefKeyColumns} = 'UserDashboardPref' . $Self->{Name} . '-Columns';
    $Self->{PageShown}      = $Self->{LayoutObject}->{ $Self->{PrefKeyShown} }
        || $Self->{Config}->{Limit};
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );

    # define filterable columns
    $Self->{ValidFilterableColumns} = {
        'Owner'          => 1,
        'Responsible'    => 1,
        'CustomerID'     => 1,
        'CustomerUserID' => 1,
        'State'          => 1,
        'Queue'          => 1,
        'Priority'       => 1,
        'Type'           => 1,
        'Lock'           => 1,
        'Service'        => 1,
        'SLA'            => 1,
    };

    # hash with all valid sortable columuns (taken from TicketSearch)
    # SortBy  => 'Age',   # Owner|Responsible|CustomerID|State|TicketNumber|Queue
    # |Priority|Type|Lock|Title|Service|SLA|Changed|PendingTime|EscalationTime
    # | EscalationUpdateTime|EscalationResponseTime|EscalationSolutionTime
    $Self->{ValidSortableColumns} = {
        'Age'                    => 1,
        'Owner'                  => 1,
        'Responsible'            => 1,
        'CustomerID'             => 1,
        'State'                  => 1,
        'TicketNumber'           => 1,
        'Queue'                  => 1,
        'Priority'               => 1,
        'Type'                   => 1,
        'Lock'                   => 1,
        'Title'                  => 1,
        'Service'                => 1,
        'Changed'                => 1,
        'SLA'                    => 1,
        'PendingTime'            => 1,
        'EscalationTime'         => 1,
        'EscalationUpdateTime'   => 1,
        'EscalationResponseTime' => 1,
        'EscalationSolutionTime' => 1,
    };

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    # configure columns
    my @ColumnsEnabled;
    my @ColumnsAvailable;
    my @ColumnsAvailableNotEnabled;

    # check for default settings
    if (
        $Self->{Config}->{DefaultColumns}
        && IsHashRefWithData( $Self->{Config}->{DefaultColumns} )
        )
    {
        @ColumnsAvailable = grep { $Self->{Config}->{DefaultColumns}->{$_} ne '0' }
            keys %{ $Self->{Config}->{DefaultColumns} };
        @ColumnsEnabled = grep { $Self->{Config}->{DefaultColumns}->{$_} eq '2' }
            keys %{ $Self->{Config}->{DefaultColumns} };
    }

    # get dynamic fields
    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldList(
        ObjectType => 'Ticket',
        ResultType => 'HASH',
    );

    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        push @ColumnsAvailable, 'DynamicField_' . $DynamicFieldList->{$DynamicFieldID};
    }

    # if preference settings are available, take them
    if ( $Self->{LayoutObject}->{ $Self->{PrefKeyColumns} } ) {

        my $ColumnsEnabled = $Self->{JSONObject}->Decode(
            Data => $Self->{LayoutObject}->{ $Self->{PrefKeyColumns} },
        );

        @ColumnsEnabled = grep { $ColumnsEnabled->{Columns}->{$_} == 1 }
            sort keys %{ $ColumnsEnabled->{Columns} };
    }

    my %Columns;
    for my $ColumnName ( sort { $a cmp $b } @ColumnsAvailable ) {
        $Columns{Columns}->{$ColumnName} = ( grep { $ColumnName eq $_ } @ColumnsEnabled ) ? 1 : 0;
        if ( !grep { $_ eq $ColumnName } @ColumnsEnabled ) {
            push @ColumnsAvailableNotEnabled, $ColumnName;
        }
    }

    my @Params = (
        {
            Desc  => 'Shown Tickets',
            Name  => $Self->{PrefKeyShown},
            Block => 'Option',
            Data  => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
            },
            SelectedID  => $Self->{PageShown},
            Translation => 0,
        },
        {
            Desc             => 'Shown Columns',
            Name             => $Self->{PrefKeyColumns},
            Block            => 'AllocationList',
            Columns          => $Self->{JSONObject}->Encode( Data => \%Columns ),
            ColumnsEnabled   => $Self->{JSONObject}->Encode( Data => \@ColumnsEnabled ),
            ColumnsAvailable => $Self->{JSONObject}->Encode( Data => \@ColumnsAvailableNotEnabled ),
            Translation      => 1,
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    # check if frontend module of link is used
    if ( $Self->{Config}->{Link} && $Self->{Config}->{Link} =~ /Action=(.+?)([&;].+?|)$/ ) {
        my $Action = $1;
        if ( !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action} ) {
            $Self->{Config}->{Link} = '';
        }
    }

    return (
        %{ $Self->{Config} },

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheTTL => undef,
        CacheKey => undef,
    );
}

sub FilterContent {
    my ( $Self, %Param ) = @_;

    return if !$Param{FilterColumn};

    my $TicketIDs;
    my $HeaderColumn = $Param{FilterColumn};
    my @OriginalViewableTickets;

    if (
        $Self->{ConfigObject}->Get('OnlyValuesOnTicket') ||
        $HeaderColumn eq 'CustomerID' ||
        $HeaderColumn eq 'CustomerUserID'
        )
    {
        my %SearchParams        = $Self->_SearchParamsGet(%Param);
        my %TicketSearch        = %{ $SearchParams{TicketSearch} };
        my %TicketSearchSummary = %{ $SearchParams{TicketSearchSummary} };

        @OriginalViewableTickets = $Self->{TicketObject}->TicketSearch(
            %TicketSearch,
            %{ $TicketSearchSummary{ $Self->{Filter} } },
            Result => 'ARRAY',
        );
    }

    if ( $HeaderColumn =~ m/^DynamicField_/ && !defined $Self->{DynamicField} ) {

        # get the dynamic fields for this screen
        $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
            Valid      => 0,
            ObjectType => ['Ticket'],
        );
    }

    # get column values for to build the filters later
    my $ColumnValues = $Self->_GetColumnValues(
        OriginalTicketIDs => \@OriginalViewableTickets,
        HeaderColumn      => $HeaderColumn,
    );

    # make sure that even a value of 0 is passed as a Selected value, e.g. Unchecked value of a
    # checkbox dynamic field.
    my $SelectedValue
        = defined $Self->{GetColumnFilter}->{ $HeaderColumn . $Self->{Name} }
        ? $Self->{GetColumnFilter}->{ $HeaderColumn . $Self->{Name} }
        : '';

    my $LabelColumn = $HeaderColumn;
    if ( $LabelColumn =~ m{ \A DynamicField_ }xms ) {

        my $DynamicFieldConfig;
        $LabelColumn =~ s{\A DynamicField_ }{}xms;

        DYNAMICFIELD:
        for my $DFConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DFConfig);
            next DYNAMICFIELD if $DFConfig->{Name} ne $LabelColumn;

            $DynamicFieldConfig = $DFConfig;
            last DYNAMICFIELD;
        }
        if ( IsHashRefWithData($DynamicFieldConfig) ) {
            $LabelColumn = $DynamicFieldConfig->{Label};
        }
    }

    # variable to save the filter's html code
    my $ColumnFilterJSON = $Self->_ColumnFilterJSON(
        ColumnName    => $HeaderColumn,
        Label         => $LabelColumn,
        ColumnValues  => $ColumnValues->{$HeaderColumn},
        SelectedValue => $SelectedValue,
        DashboardName => $Self->{Name},
    );

    return $ColumnFilterJSON;

}

sub Run {
    my ( $Self, %Param ) = @_;

    my $CacheKey = $Self->{Name} . '-'
        . $Self->{PageShown} . '-'
        . $Self->{StartHit} . '-'
        . $Self->{UserID};

    my %SearchParams        = $Self->_SearchParamsGet(%Param);
    my @Columns             = @{ $SearchParams{Columns} };
    my %TicketSearch        = %{ $SearchParams{TicketSearch} };
    my %TicketSearchSummary = %{ $SearchParams{TicketSearchSummary} };

    my $TicketIDs;

    # find and show ticket list
    my $CacheUsed = 1;

    if ( !$TicketIDs || $Self->{SortBy} || $Self->{GetColumnFilter} ) {

        # add sort by parameter to the search
        if (
            !defined $TicketSearch{SortBy}
            || !$Self->{ValidSortableColumns}->{ $TicketSearch{SortBy} }
            )
        {
            if ( $Self->{SortBy} && $Self->{ValidSortableColumns}->{ $Self->{SortBy} } ) {
                $TicketSearch{SortBy} = $Self->{SortBy};
            }
            else {
                $TicketSearch{SortBy} = 'Age';
            }
        }

        # add order by parameter to the search
        if ( $Self->{OrderBy} ) {
            $TicketSearch{OrderBy} = $Self->{OrderBy};
        }
        $CacheUsed = 0;

        my @TicketIDsArray = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            %TicketSearch,
            %{ $TicketSearchSummary{ $Self->{Filter} } },
            %{ $Self->{ColumnFilter} },
            Limit => $Self->{PageShown} + $Self->{StartHit} - 1,
        );
        $TicketIDs = \@TicketIDsArray;
    }

    # CustomerInformationCenter shows data per CustomerID
    if ( $Param{CustomerID} ) {
        $CacheKey .= '-' . $Param{CustomerID};
    }

    # check cache
    my $Summary = $Self->{CacheObject}->Get(
        Type => 'Dashboard',
        Key  => $CacheKey . '-Summary',
    );

    # if no cache or new list result, do count lookup
    if ( !$Summary || !$CacheUsed ) {
        for my $Type ( sort keys %TicketSearchSummary ) {
            next if !$TicketSearchSummary{$Type};

            # copy original column filter
            my %ColumnFilter = %{ $Self->{ColumnFilter} };

            # loop through all colum filter elements
            for my $Element ( keys %ColumnFilter ) {

                # verify if current column filter element is already present in the ticket search
                # summary, to delete it from the column filter hash
                if ( $TicketSearchSummary{$Type}->{$Element} ) {
                    delete $ColumnFilter{$Element};
                }
            }

            $Summary->{$Type} = $Self->{TicketObject}->TicketSearch(
                Result => 'COUNT',
                %TicketSearch,
                %{ $TicketSearchSummary{$Type} },
                %ColumnFilter,
            );
        }
    }

    # set cache
    if ( !$CacheUsed && $Self->{Config}->{CacheTTLLocal} ) {
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey . '-Summary',
            Value => $Summary,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
        $Self->{CacheObject}->Set(
            Type  => 'Dashboard',
            Key   => $CacheKey . '-' . $Self->{Filter} . '-List',
            Value => $TicketIDs,
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    # set css class
    $Summary->{ $Self->{Filter} . '::Selected' } = 'Selected';

    # get filter ticket counts
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericFilter',
        Data => {
            %Param,
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{$Summary},
        },
    );

    # show also watcher if feature is enabled
    if ( $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterWatcher',
            Data => {
                %Param,
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # show also responsible if feature is enabled
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterResponsible',
            Data => {
                %Param,
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # show only myqueues if we have the filter
    if ( $TicketSearchSummary{MyQueues} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericFilterMyQueues',
            Data => {
                %Param,
                %{ $Self->{Config} },
                Name => $Self->{Name},
                %{$Summary},
            },
        );
    }

    # add page nav bar
    my $Total = $Summary->{ $Self->{Filter} } || 0;

    my %GetColumnFilter = $Self->{GetColumnFilter} ? %{ $Self->{GetColumnFilter} } : ();

    my $ColumnFilterLink = '';
    COLUMNNAME:
    for my $ColumnName ( keys %GetColumnFilter ) {
        next COLUMNNAME if !$ColumnName;
        next COLUMNNAME if !$GetColumnFilter{$ColumnName};
        $ColumnFilterLink
            .= ';' . $Self->{LayoutObject}->Ascii2Html( Text => 'ColumnFilter' . $ColumnName )
            . '=' . $Self->{LayoutObject}->Ascii2Html( Text => $GetColumnFilter{$ColumnName} )
    }

    my $LinkPage =
        'Subaction=Element;Name=' . $Self->{Name}
        . ';Filter=' . $Self->{Filter}
        . ';SortBy=' .  ( $Self->{SortBy}  || '' )
        . ';OrderBy=' . ( $Self->{OrderBy} || '' )
        . $ColumnFilterLink
        . ';';

    if ( $Param{CustomerID} ) {
        $LinkPage .= "CustomerID=$Param{CustomerID};";
    }
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        StartHit       => $Self->{StartHit},
        PageShown      => $Self->{PageShown},
        AllHits        => $Total || 1,
        Action         => 'Action=' . $Self->{LayoutObject}->{Action},
        Link           => $LinkPage,
        AJAXReplace    => 'Dashboard' . $Self->{Name},
        IDPrefix       => 'Dashboard' . $Self->{Name},
        KeepScriptTags => $Param{AJAX},
    );
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericFilterNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    # show table header
    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeTicketGenericHeader',
        Data => {},
    );

    # define which meta items will be shown
    my @MetaItems = $Self->{LayoutObject}->TicketMetaItemsCount();

    # show non-labeled table headers
    my $CSS = '';
    my $OrderBy;
    for my $Item (@MetaItems) {
        $CSS = '';
        my $Title = $Item;
        if ( $Self->{SortBy} && ( $Self->{SortBy} eq $Item ) ) {
            if ( $Self->{OrderBy} && ( $Self->{OrderBy} eq 'Up' ) ) {
                $OrderBy = 'Down';
                $CSS .= ' SortDescendingLarge';
            }
            else {
                $OrderBy = 'Up';
                $CSS .= ' SortAscendingLarge';
            }

            # set title description
            my $TitleDesc = $OrderBy eq 'Down' ? 'sorted descending' : 'sorted ascending';
            $TitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($TitleDesc);
            $Title .= ', ' . $TitleDesc;
        }

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericHeaderMeta',
            Data => {
                CSS => $CSS,
            },
        );

        if ( $Item eq 'New Article' ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderMetaEmpty',
                Data => {
                    HeaderColumnName => $Item,
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderMetaLink',
                Data => {
                    %Param,
                    Name             => $Self->{Name},
                    OrderBy          => $OrderBy || 'Up',
                    HeaderColumnName => $Item,
                    Title            => $Title,
                },
            );
        }
    }

    # show all needed headers
    HEADERCOLUMN:
    for my $HeaderColumn (@Columns) {

        # not show headers for dymamic field, yet
        next HEADERCOLUMN if $HeaderColumn =~ m{ DynamicField_ }xms;
        $CSS = '';
        my $Title = $HeaderColumn;

        if ( $Self->{SortBy} && ( $Self->{SortBy} eq $HeaderColumn ) ) {
            if ( $Self->{OrderBy} && ( $Self->{OrderBy} eq 'Up' ) ) {
                $OrderBy = 'Down';
                $CSS .= ' SortDescendingLarge';
            }
            else {
                $OrderBy = 'Up';
                $CSS .= ' SortAscendingLarge';
            }

            # add title description
            my $TitleDesc = $OrderBy eq 'Down' ? 'sorted descending' : 'sorted ascending';
            $TitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($TitleDesc);
            $Title .= ', ' . $TitleDesc;
        }

        # translate the column name to write it in the current language
        my $TranslatedWord;
        if ( $HeaderColumn eq 'EscalationTime' ) {
            $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Service Time');
        }
        elsif ( $HeaderColumn eq 'EscalationResponseTime' ) {
            $TranslatedWord
                = $Self->{LayoutObject}->{LanguageObject}->Get('First Response Time');
        }
        elsif ( $HeaderColumn eq 'EscalationSolutionTime' ) {
            $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Solution Time');
        }
        elsif ( $HeaderColumn eq 'EscalationUpdateTime' ) {
            $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Update Time');
        }
        elsif ( $HeaderColumn eq 'PendingTime' ) {
            $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Pending till');
        }
        else {
            $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get($HeaderColumn);
        }

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericHeaderTicketHeader',
            Data => {},
        );

        if ( $HeaderColumn eq 'TicketNumber' ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderTicketNumberColumn',
                Data => {
                    %Param,
                    CSS => $CSS || '',
                    Name    => $Self->{Name},
                    OrderBy => $OrderBy || 'Up',
                    Filter  => $Self->{Filter},
                    Title   => $Title,
                },
            );
            next HEADERCOLUMN;
        }

        my $FilterTitle     = $HeaderColumn;
        my $FilterTitleDesc = 'filter not active';
        if ( $Self->{GetColumnFilterSelect} && $Self->{GetColumnFilterSelect}->{$HeaderColumn} ) {
            $CSS .= ' FilterActive';
            $FilterTitleDesc = 'filter active';
        }
        $FilterTitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($FilterTitleDesc);
        $FilterTitle .= ', ' . $FilterTitleDesc;

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericHeaderColumn',
            Data => {
                HeaderColumnName     => $HeaderColumn   || '',
                HeaderNameTranslated => $TranslatedWord || $HeaderColumn,
                CSS                  => $CSS            || '',
            },
        );

        # verify if column is filterable and sortable
        if (
            $Self->{ValidSortableColumns}->{$HeaderColumn}
            && $Self->{ValidFilterableColumns}->{$HeaderColumn}
            )
        {

            my $Css;
            if (
                $HeaderColumn eq 'CustomerID'
                || $HeaderColumn eq 'Responsible'
                || $HeaderColumn eq 'Owner'
                )
            {
                $Css = 'Hidden';
            }

            # variable to save the filter's html code
            my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                ColumnName => $HeaderColumn,
                Css        => $Css,
            );

            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumnFilterLink',
                Data => {
                    %Param,
                    HeaderColumnName     => $HeaderColumn,
                    CSS                  => $CSS,
                    HeaderNameTranslated => $TranslatedWord || $HeaderColumn,
                    ColumnFilterStrg     => $ColumnFilterHTML,
                    OrderBy              => $OrderBy || 'Up',
                    SortBy               => $Self->{SortBy} || 'Age',
                    Name                 => $Self->{Name},
                    Title                => $Title,
                    FilterTitle          => $FilterTitle,
                },
            );

            if ( $HeaderColumn eq 'CustomerID' ) {

                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericHeaderColumnFilterLinkCustomerIDSearch',
                    Data => {
                        minQueryLength      => 2,
                        queryDelay          => 100,
                        maxResultsDisplayed => 20,
                    },
                );
            }
            elsif ( $HeaderColumn eq 'Responsible' || $HeaderColumn eq 'Owner' ) {

                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericHeaderColumnFilterLinkUserSearch',
                    Data => {
                        minQueryLength      => 2,
                        queryDelay          => 100,
                        maxResultsDisplayed => 20,
                    },
                );
            }
        }

        # verify if column is just filterable
        elsif ( $Self->{ValidFilterableColumns}->{$HeaderColumn} ) {

            my $Css;
            if ( $HeaderColumn eq 'CustomerUserID' ) {
                $Css = 'Hidden';
            }

            # variable to save the filter's html code
            my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                ColumnName => $HeaderColumn,
                Css        => $Css,
            );

            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumnFilter',
                Data => {
                    %Param,
                    HeaderColumnName     => $HeaderColumn,
                    CSS                  => $CSS,
                    HeaderNameTranslated => $TranslatedWord || $HeaderColumn,
                    ColumnFilterStrg     => $ColumnFilterHTML,
                    Name                 => $Self->{Name},
                    Title                => $Title,
                    FilterTitle          => $FilterTitle,
                },
            );

            if ( $HeaderColumn eq 'CustomerUserID' ) {

                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericHeaderColumnFilterLinkCustomerUserSearch',
                    Data => {
                        minQueryLength      => 2,
                        queryDelay          => 100,
                        maxResultsDisplayed => 20,
                    },
                );
            }
        }

        # verify if column is just sortable
        elsif ( $Self->{ValidSortableColumns}->{$HeaderColumn} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumnLink',
                Data => {
                    %Param,
                    HeaderColumnName     => $HeaderColumn,
                    CSS                  => $CSS,
                    HeaderNameTranslated => $TranslatedWord || $HeaderColumn,
                    OrderBy              => $OrderBy || 'Up',
                    SortBy               => $Self->{SortBy} || $HeaderColumn,
                    Name                 => $Self->{Name},
                    Title                => $Title,
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumnEmpty',
                Data => {
                    %Param,
                    HeaderNameTranslated => $TranslatedWord || $HeaderColumn,
                    HeaderColumnName     => $HeaderColumn,
                    CSS                  => $CSS,
                    Title                => $Title,
                },
            );
        }
    }

    # Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $Label = $DynamicFieldConfig->{Label};

        my $TranslatedLabel = $Self->{LayoutObject}->{LanguageObject}->Get($Label);

        my $DynamicFieldName = 'DynamicField_' . $DynamicFieldConfig->{Name};

        my $CSS             = '';
        my $FilterTitle     = $Label;
        my $FilterTitleDesc = 'filter not active';
        if (
            $Self->{GetColumnFilterSelect}
            && defined $Self->{GetColumnFilterSelect}->{$DynamicFieldName}
            )
        {
            $CSS .= 'FilterActive ';
            $FilterTitleDesc = 'filter active';
        }
        $FilterTitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($FilterTitleDesc);
        $FilterTitle .= ', ' . $FilterTitleDesc;

        # get field sortable condition
        my $IsSortable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsSortable',
        );

        # set title
        my $Title = $Label;

        if ($IsSortable) {
            my $OrderBy;
            if (
                $Self->{SortBy}
                && ( $Self->{SortBy} eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                )
            {
                if ( $Self->{OrderBy} && ( $Self->{OrderBy} eq 'Up' ) ) {
                    $OrderBy = 'Down';
                    $CSS .= ' SortDescendingLarge';
                }
                else {
                    $OrderBy = 'Up';
                    $CSS .= ' SortAscendingLarge';
                }

                # add title description
                my $TitleDesc = $OrderBy eq 'Down' ? 'sorted descending' : 'sorted ascending';
                $TitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($TitleDesc);
                $Title .= ', ' . $TitleDesc;
            }

            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumn',
                Data => {
                    HeaderColumnName => $DynamicFieldName || '',
                    CSS => $CSS || '',
                },
            );

            # check if the dynamic field is sortable and filtrable (sortable check was made before)
            if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                # variable to save the filter's html code
                my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                    ColumnName => $DynamicFieldName,
                    Label      => $Label,
                );

                # output sortable and filtrable dynamic field
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericHeaderColumnFilterLink',
                    Data => {
                        %Param,
                        HeaderColumnName     => $DynamicFieldName,
                        CSS                  => $CSS,
                        HeaderNameTranslated => $TranslatedLabel || $DynamicFieldName,
                        ColumnFilterStrg     => $ColumnFilterHTML,
                        OrderBy              => $OrderBy || 'Up',
                        SortBy               => $Self->{SortBy} || 'Age',
                        Name                 => $Self->{Name},
                        Title                => $Title,
                        FilterTitle          => $FilterTitle,
                    },
                );
            }

            # otherwise the dynamic field is only sortable (sortable check was made before)
            else {

                # output sortable dynamic field
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericHeaderColumnLink',
                    Data => {
                        %Param,
                        HeaderColumnName     => $DynamicFieldName,
                        CSS                  => $CSS,
                        HeaderNameTranslated => $TranslatedLabel || $DynamicFieldName,
                        OrderBy              => $OrderBy || 'Up',
                        SortBy               => $Self->{SortBy} || $DynamicFieldName,
                        Name                 => $Self->{Name},
                        Title                => $Title,
                        FilterTitle          => $FilterTitle,
                    },
                );
            }
        }

        # if the dynamic field was not sortable (check was made and fail before)
        # it might be filtrable
        elsif ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumn',
                Data => {
                    HeaderColumnName => $DynamicFieldName || '',
                    CSS              => $CSS              || '',
                    Title            => $Title,
                },
            );

            # variable to save the filter's html code
            my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                ColumnName => $DynamicFieldName,
                Label      => $Label,
            );

            # output filtrable (not sortable) dynamic field
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumnFilter',
                Data => {
                    %Param,
                    HeaderColumnName     => $DynamicFieldName,
                    CSS                  => $CSS,
                    HeaderNameTranslated => $TranslatedLabel || $DynamicFieldName,
                    ColumnFilterStrg     => $ColumnFilterHTML,
                    Name                 => $Self->{Name},
                    Title                => $Title,
                    FilterTitle          => $FilterTitle,
                },
            );
        }

        # otherwise the field is not filtrable and not sortable
        else {

            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumn',
                Data => {
                    HeaderColumnName => $DynamicFieldName || '',
                    CSS => $CSS || '',
                },
            );

            # output plain dynamic field header (not filtrable, not sortable)
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericHeaderColumnEmpty',
                Data => {
                    %Param,
                    HeaderNameTranslated => $TranslatedLabel || $DynamicFieldName,
                    HeaderColumnName     => $DynamicFieldName,
                    CSS                  => $CSS,
                    Title                => $Title,
                },
            );
        }
    }

    # show tickets
    my $Count = 0;
    for my $TicketID ( @{$TicketIDs} ) {
        $Count++;
        next if $Count < $Self->{StartHit};
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            UserID        => $Self->{UserID},
            DynamicFields => 0,
        );

        # set a default title if ticket has no title
        if ( !$Ticket{Title} ) {
            $Ticket{Title} = $Self->{LayoutObject}->{LanguageObject}->Get(
                'This ticket has no title or subject'
            );
        }

        # create human age
        if ( $Self->{Config}->{Time} ne 'Age' ) {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }
        else {
            $Ticket{Time} = $Self->{LayoutObject}->CustomerAge(
                Age   => $Ticket{ $Self->{Config}->{Time} },
                Space => ' ',
            );
        }

        # show ticket
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRow',
            Data => \%Ticket,
        );

        # show ticket flags
        my @TicketMetaItems = $Self->{LayoutObject}->TicketMetaItems(
            Ticket => \%Ticket,
        );
        for my $Item (@TicketMetaItems) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericRowMeta',
                Data => {},
            );
            if ($Item) {
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericRowMetaImage',
                    Data => $Item,
                );
            }
        }

        # save column content
        my $DataValue;

        # show all needed columns
        COLUMN:
        for my $Column (@Columns) {
            next COLUMN if $Column =~ m{ DynamicField_ }xms;

            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericTicketColumn',
                Data => {},
            );

            my $BlockType = '';
            my $CSSClass  = '';

            if ( $Column eq 'TicketNumber' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericTicketNumber',
                    Data => {
                        %Ticket,
                        Title => $Ticket{Title},
                    },
                );
                next COLUMN;
            }
            elsif ( $Column eq 'EscalationTime' ) {
                my %EscalationData;
                $EscalationData{EscalationTime}            = $Ticket{EscalationTime};
                $EscalationData{EscalationDestinationDate} = $Ticket{EscalationDestinationDate};

                $EscalationData{EscalationTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $EscalationData{EscalationTime},
                    Space => ' ',
                );
                $EscalationData{EscalationTimeWorkingTime}
                    = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $EscalationData{EscalationTimeWorkingTime},
                    Space => ' ',
                    );
                if ( defined $Ticket{EscalationTime} && $Ticket{EscalationTime} < 60 * 60 * 1 ) {
                    $EscalationData{EscalationClass} = 'Warning';
                }
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericEscalationTime',
                    Data => {%EscalationData},
                );
                next COLUMN;

                $DataValue = $Self->{LayoutObject}->CustomerAge(
                    Age   => $Ticket{'EscalationTime'},
                    Space => ' '
                );
            }
            elsif ( $Column eq 'Age' ) {
                $DataValue = $Self->{LayoutObject}->CustomerAge(
                    Age   => $Ticket{Age},
                    Space => ' ',
                );
            }
            elsif ( $Column eq 'EscalationSolutionTime' ) {
                $BlockType = 'Escalation';
                $DataValue = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{SolutionTime} || 0,
                    Space => ' ',
                );
                if ( defined $Ticket{SolutionTime} && $Ticket{SolutionTime} < 60 * 60 * 1 ) {
                    $CSSClass = 'Warning';
                }
            }
            elsif ( $Column eq 'EscalationResponseTime' ) {
                $BlockType = 'Escalation';
                $DataValue = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{FirstResponseTime} || 0,
                    Space => ' ',
                );
                if (
                    defined $Ticket{FirstResponseTime}
                    && $Ticket{FirstResponseTime} < 60 * 60 * 1
                    )
                {
                    $CSSClass = 'Warning';
                }
            }
            elsif ( $Column eq 'EscalationUpdateTime' ) {
                $BlockType = 'Escalation';
                $DataValue = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{UpdateTime} || 0,
                    Space => ' ',
                );
                if ( defined $Ticket{UpdateTime} && $Ticket{UpdateTime} < 60 * 60 * 1 ) {
                    $CSSClass = 'Warning';
                }
            }
            elsif ( $Column eq 'PendingTime' ) {
                $BlockType = 'Escalation';
                $DataValue = $Self->{LayoutObject}->CustomerAge(
                    Age   => $Ticket{'UntilTime'},
                    Space => ' '
                );
                if ( defined $Ticket{UntilTime} && $Ticket{UntilTime} < -1 ) {
                    $CSSClass = 'Warning';
                }
            }
            elsif ( $Column eq 'Owner' ) {

                # get owner info
                my %OwnerInfo = $Self->{UserObject}->GetUserData(
                    UserID => $Ticket{OwnerID},
                );
                $DataValue = $OwnerInfo{'UserFirstname'} . ' ' . $OwnerInfo{'UserLastname'};
            }
            elsif ( $Column eq 'Responsible' ) {

                # get responsible info
                my %ResponsibleInfo = $Self->{UserObject}->GetUserData(
                    UserID => $Ticket{ResponsibleID},
                );
                $DataValue
                    = $ResponsibleInfo{'UserFirstname'} . ' ' . $ResponsibleInfo{'UserLastname'};
            }
            elsif (
                $Column eq 'State'
                || $Column eq 'Lock'
                || $Column eq 'Priority'
                )
            {
                $BlockType = 'Translatable';
                $DataValue = $Ticket{$Column};
            }
            elsif ( $Column eq 'Created' ) {
                $BlockType = 'Time';
                $DataValue = $Ticket{$Column};
            }
            elsif ( $Column eq 'CustomerName' ) {

                # get customer name
                my $CustomerName;
                if ( $Ticket{CustomerUserID} ) {
                    $CustomerName = $Self->{CustomerUserObject}->CustomerName(
                        UserLogin => $Ticket{CustomerUserID},
                    );
                }
                $DataValue = $CustomerName;
            }
            else {
                $DataValue = $Ticket{$Column};
            }

            $Self->{LayoutObject}->Block(
                Name => "ContentLargeTicketGenericColumn$BlockType",
                Data => {
                    GenericValue => $DataValue || '',
                    Class        => $CSSClass  || '',
                },
            );
        }

        # Dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get field value
            my $Value = $Self->{BackendObject}->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
            );

            my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                ValueMaxChars      => 20,
                LayoutObject       => $Self->{LayoutObject},
            );

            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericDynamicField',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );

            if ( $ValueStrg->{Link} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericDynamicFieldLink',
                    Data => {
                        Value                       => $ValueStrg->{Value},
                        Title                       => $ValueStrg->{Title},
                        Link                        => $ValueStrg->{Link},
                        $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeTicketGenericDynamicFieldPlain',
                    Data => {
                        Value => $ValueStrg->{Value},
                        Title => $ValueStrg->{Title},
                    },
                );
            }

        }

    }

    # show "none" if no ticket is available
    if ( !$TicketIDs || !@{$TicketIDs} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericNone',
            Data => {},
        );
    }

    # check for refresh time
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
        my $NameHTML = $Self->{Name};
        $NameHTML =~ s{-}{_}xmsg;
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRefresh',
            Data => {
                %{ $Self->{Config} },
                Name        => $Self->{Name},
                NameHTML    => $NameHTML,
                RefreshTime => $Refresh,
                CustomerID  => $Param{CustomerID},
                %{$Summary},
            },
        );
    }

    # check for active filters and add a 'remove filters' button to the widget header
    if ( $Self->{GetColumnFilterSelect} && IsHashRefWithData( $Self->{GetColumnFilterSelect} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRemoveFilters',
            Data => {
                Name       => $Self->{Name},
                CustomerID => $Param{CustomerID},
            },
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRemoveFiltersRemove',
            Data => {
                Name => $Self->{Name},
            },
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketGeneric',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{$Summary},
            FilterValue => $Self->{Filter},
            CustomerID => $Self->{CustomerID},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

sub _InitialColumnFilter {
    my ( $Self, %Param ) = @_;

    return if !$Param{ColumnName};
    return if !$Self->{ValidFilterableColumns}->{ $Param{ColumnName} };

    my $Label = $Param{Label} || $Param{ColumnName};
    $Label = $Self->{LayoutObject}->{LanguageObject}->Get($Label);

    # set fixed values
    my $Data = [
        {
            Key   => '',
            Value => uc $Label,
        },
    ];

    # define if column filter values should be translatable
    my $TranslationOption = 0;

    if (
        $Param{ColumnName} eq 'State'
        || $Param{ColumnName} eq 'Lock'
        || $Param{ColumnName} eq 'Priority'
        )
    {
        $TranslationOption = 1;
    }

    my $Class = 'ColumnFilter';
    if ( $Param{Css} ) {
        $Class .= ' ' . $Param{Css};
    }

    # build select HTML
    my $ColumnFilterHTML = $Self->{LayoutObject}->BuildSelection(
        Name        => 'ColumnFilter' . $Param{ColumnName} . $Self->{Name},
        Data        => $Data,
        Class       => $Class,
        Translation => $TranslationOption,
        SelectedID  => '',
    );
    return $ColumnFilterHTML;
}

sub _GetColumnValues {
    my ( $Self, %Param ) = @_;

    return if !IsStringWithData( $Param{HeaderColumn} );

    my $HeaderColumn = $Param{HeaderColumn};
    my %ColumnFilterValues;
    my $TicketIDs;

    if ( IsArrayRefWithData( $Param{OriginalTicketIDs} ) ) {
        $TicketIDs = $Param{OriginalTicketIDs};
    }

    if ( $HeaderColumn !~ m/^DynamicField_/ ) {
        my $FunctionName = $HeaderColumn . 'FilterValuesGet';
        if ( $HeaderColumn eq 'CustomerID' ) {
            $FunctionName = 'CustomerFilterValuesGet';
        }
        $ColumnFilterValues{$HeaderColumn} = $Self->{ColumnFilterObject}->$FunctionName(
            TicketIDs    => $TicketIDs,
            HeaderColumn => $HeaderColumn,
            UserID       => $Self->{UserID},
        );
    }
    else {
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            my $FieldName = 'DynamicField_' . $DynamicFieldConfig->{Name};
            next DYNAMICFIELD if $FieldName ne $HeaderColumn;
            my $IsFiltrable = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsFiltrable',
            );
            next DYNAMICFIELD if !$IsFiltrable;
            $Self->{ValidFilterableColumns}->{$HeaderColumn} = $IsFiltrable;
            if ( IsArrayRefWithData($TicketIDs) ) {

                # get the historical values for the field
                $ColumnFilterValues{$HeaderColumn}
                    = $Self->{BackendObject}->ColumnFilterValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    LayoutObject       => $Self->{LayoutObject},
                    TicketIDs          => $TicketIDs,
                    );
            }
            else {
                # get PossibleValues
                $ColumnFilterValues{$HeaderColumn} = $Self->{BackendObject}->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );
            }
            last;
        }
    }

    return \%ColumnFilterValues;
}

=over

=item _ColumnFilterJSON()

    creates a JSON select filter for column header

    my $ColumnFilterJSON = $TicketOverviewSmallObject->_ColumnFilterJSON(
        ColumnName => 'Queue',
        Label      => 'Queue',
        ColumnValues => {
            1 => 'PostMaster',
            2 => 'Junk',
        },
        SelectedValue '1',
    );

=cut

sub _ColumnFilterJSON {
    my ( $Self, %Param ) = @_;

    return if !$Param{ColumnName};
    return if !$Self->{ValidFilterableColumns}->{ $Param{ColumnName} };

    my $Label = $Param{Label};
    $Label =~ s{ \A DynamicField_ }{}gxms;
    $Label = $Self->{LayoutObject}->{LanguageObject}->Get($Label);

    # set fixed values
    my $Data = [
        {
            Key   => 'DeleteFilter',
            Value => uc $Label,
        },
        {
            Key      => '-',
            Value    => '-',
            Disabled => 1,
        },
    ];

    if ( $Param{ColumnValues} && ref $Param{ColumnValues} eq 'HASH' ) {

        my %Values = %{ $Param{ColumnValues} };

        # set possible values
        for my $ValueKey ( sort { lc $Values{$a} cmp lc $Values{$b} } keys %Values ) {
            push @{$Data}, {
                Key   => $ValueKey,
                Value => $Values{$ValueKey}
            };
        }
    }

    # define if column filter values should be translatable
    my $TranslationOption = 0;

    if (
        $Param{ColumnName} eq 'State'
        || $Param{ColumnName} eq 'Lock'
        || $Param{ColumnName} eq 'Priority'
        )
    {
        $TranslationOption = 1;
    }

    # build select HTML
    my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
        [
            {
                Name         => 'ColumnFilter' . $Param{ColumnName} . $Param{DashboardName},
                Data         => $Data,
                Class        => 'ColumnFilter',
                Sort         => 'AlphanumericKey',
                SelectedID   => $Param{SelectedValue},
                Translation  => $TranslationOption,
                AutoComplete => 'off',
            },
        ],
    );
    return $JSON;
}

sub _SearchParamsGet {
    my ( $Self, %Param ) = @_;

    # get all search base attributes
    my %TicketSearch;
    my %DynamicFieldsParameters;
    my @Params = split /;/, $Self->{Config}->{Attributes};

    # read user preferences and config to get columns that
    # should be shown in the dashboard widget (the prefereces
    # have precedence)
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );

    # get column names from Preferences
    my $PreferencesColumn = $Self->{JSONObject}->Decode(
        Data => $Preferences{ $Self->{PrefKeyColumns} },
    );

    # check for default settings
    my @Columns;
    if (
        $Self->{Config}->{DefaultColumns}
        && IsHashRefWithData( $Self->{Config}->{DefaultColumns} )
        )
    {
        @Columns = grep { $Self->{Config}->{DefaultColumns}->{$_} eq '2' }
            sort keys %{ $Self->{Config}->{DefaultColumns} };
    }
    if ($PreferencesColumn) {
        @Columns = grep { $PreferencesColumn->{Columns}->{$_} == 1 }
            sort keys %{ $PreferencesColumn->{Columns} };

        if ( $PreferencesColumn->{Order} && @{ $PreferencesColumn->{Order} } ) {
            @Columns = @{ $PreferencesColumn->{Order} };
        }
    }

    # always set TicketNumber
    if ( !grep { $_ eq 'TicketNumber' } @Columns ) {
        unshift @Columns, 'TicketNumber';
    }

    {
        # loop through all the dynamic fields to get the ones that should be shown
        DYNAMICFIELDNAME:
        for my $DynamicFieldName (@Columns) {

            next DYNAMICFIELDNAME if $DynamicFieldName !~ m{ DynamicField_ }xms;

            # remove dynamic field prefix
            my $FieldName = $DynamicFieldName;
            $FieldName =~ s/DynamicField_//gi;
            $Self->{DynamicFieldFilter}->{$FieldName} = 1;
        }
    }

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # get filtrable Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsFiltrable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsFiltrable',
        );

        # if the dynamic field is filtrable add it to the ValidFilterableColumns hash
        if ($IsFiltrable) {
            $Self->{ValidFilterableColumns}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = 1;
        }
    }

    # get sortable Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsSortable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsSortable',
        );

        # if the dynamic field is sortable add it to the ValidSortableColumns hash
        if ($IsSortable) {
            $Self->{ValidSortableColumns}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = 1;
        }
    }

    for my $String (@Params) {
        next if !$String;
        my ( $Key, $Value ) = split /=/, $String;

        # push ARRAYREF attributes directly in an ARRAYREF
        if (
            $Key
            =~ /^(StateType|StateTypeIDs|Queues|QueueIDs|Types|TypeIDs|States|StateIDs|Priorities|PriorityIDs|Services|ServiceIDs|SLAs|SLAIDs|Locks|LockIDs|OwnerIDs|ResponsibleIDs|WatchUserIDs|ArchiveFlags)$/
            )
        {
            push @{ $TicketSearch{$Key} }, $Value;
        }

        # check if parameter is a dynamic field and capture dynamic field name (with DynamicField_)
        # in $1 and the Operator in $2
        # possible Dynamic Fields options include:
        #   DynamicField_NameX_Equals=123;
        #   DynamicField_NameX_Like=value*;
        #   DynamicField_NameX_GreaterThan=2001-01-01 01:01:01;
        #   DynamicField_NameX_GreaterThanEquals=2001-01-01 01:01:01;
        #   DynamicField_NameX_SmallerThan=2002-02-02 02:02:02;
        #   DynamicField_NameX_SmallerThanEquals=2002-02-02 02:02:02;
        elsif ( $Key =~ m{\A (DynamicField_.+?) _ (.+?) \z}sxm ) {
            $DynamicFieldsParameters{$1}->{$2} = $Value;
        }

        elsif ( !defined $TicketSearch{$Key} ) {

            # change sort by, if needed
            if (
                $Key eq 'SortBy'
                && $Self->{SortBy}
                && $Self->{ValidSortableColumns}->{ $Self->{SortBy} }
                )
            {
                $Value = $Self->{SortBy};
            }
            elsif ( $Key eq 'SortBy' && !$Self->{ValidSortableColumns}->{$Value} ) {
                $Value = 'Age';
            }
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            $TicketSearch{$Key} = [$ValueTmp];
            push @{ $TicketSearch{$Key} }, $Value;
        }
        else {
            push @{ $TicketSearch{$Key} }, $Value;
        }
    }
    %TicketSearch = (
        %TicketSearch,
        %DynamicFieldsParameters,
        Permission => $Self->{Config}->{Permission} || 'ro',
        UserID => $Self->{UserID},
    );

    # CustomerInformationCenter shows data per CustomerID
    if ( $Param{CustomerID} ) {
        $TicketSearch{CustomerID} = $Param{CustomerID};
    }

    # define filter attributes
    my @MyQueues = $Self->{QueueObject}->GetAllCustomQueues(
        UserID => $Self->{UserID},
    );
    if ( !@MyQueues ) {
        @MyQueues = (999_999);
    }
    my %TicketSearchSummary = (
        Locked => {
            OwnerIDs => [ $Self->{UserID}, ],
            Locks => [ 'lock', 'tmp_lock' ],
        },
        Watcher => {
            WatchUserIDs => [ $Self->{UserID}, ],
            Locks        => undef,
        },
        Responsible => {
            ResponsibleIDs => [ $Self->{UserID}, ],
            Locks          => undef,
        },
        MyQueues => {
            QueueIDs => \@MyQueues,
            Locks    => undef,
        },
        All => {
            OwnerIDs => undef,
            Locks    => undef,
        },
    );

    if ( defined $TicketSearch{QueueIDs} || defined $TicketSearch{Queues} ) {
        delete $TicketSearchSummary{MyQueues};
    }

    return (
        Columns             => \@Columns,
        TicketSearch        => \%TicketSearch,
        TicketSearchSummary => \%TicketSearchSummary,
    );

}

1;
