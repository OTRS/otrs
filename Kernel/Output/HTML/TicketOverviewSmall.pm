# --
# Kernel/Output/HTML/TicketOverviewSmall.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketOverviewSmall;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::CustomerUser;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::Ticket::ColumnFilter;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = \%Param;
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject LayoutObject UserID UserObject GroupObject TicketObject MainObject QueueObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    $Self->{SmallViewColumnHeader}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::OverviewSmall')->{ColumnHeader};

    # set pref for columns key
    $Self->{PrefKeyColumns} = 'UserFilterColumnsEnabled' . '-' . $Self->{Action};

    # load backend config
    my $BackendConfigKey = 'Ticket::Frontend::' . $Self->{Action};
    $Self->{Config} = $Self->{ConfigObject}->Get($BackendConfigKey);

    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Self->{UserID},
    );

    # set stored filters if present
    my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
    if ( $Preferences{$StoredFiltersKey} ) {
        my $StoredFilters = $Self->{JSONObject}->Decode(
            Data => $Preferences{$StoredFiltersKey},
        );
        $Self->{StoredFilters} = $StoredFilters;
    }

    # configure columns
    my @ColumnsEnabled;
    my @ColumnsAvailable;

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
    if ( $Preferences{ $Self->{PrefKeyColumns} } ) {

        my $ColumnsEnabled = $Self->{JSONObject}->Decode(
            Data => $Preferences{ $Self->{PrefKeyColumns} },
        );

        COLUMNENABLED:
        for my $Enabled ( @{$ColumnsEnabled} ) {
            next COLUMNENABLED if grep { $_ eq $Enabled } @ColumnsEnabled;
            push @ColumnsEnabled, $Enabled;
        }
    }

    $Self->{ColumnsEnabled}   = \@ColumnsEnabled;
    $Self->{ColumnsAvailable} = \@ColumnsAvailable;

    {
        # loop through all the dynamic fields to get the ones that should be shown
        DYNAMICFIELDNAME:
        for my $DynamicFieldName (@ColumnsEnabled) {

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

    $Self->{ColumnFilterObject} = Kernel::System::Ticket::ColumnFilter->new(%Param);

    # hash with all valid sortable columuns (taken from TicketSearch)
    # SortBy  => 'Age',   # Owner|Responsible|CustomerID|State|TicketNumber|Queue
    # |Priority|Type|Lock|Title|Service|SLA|PendingTime|EscalationTime
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
        'SLA'                    => 1,
        'PendingTime'            => 1,
        'EscalationTime'         => 1,
        'EscalationUpdateTime'   => 1,
        'EscalationResponseTime' => 1,
        'EscalationSolutionTime' => 1,
    };

    $Self->{AvailableFilterableColumns} = {
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

    # get filtrable dynamic fields
    # cycle trough the activated dynamic fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsFiltrable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsFiltrable',
        );

        # if the dynamic field is filtrable add it to the AvailableFilterableColumns hash
        if ($IsFiltrable) {
            $Self->{AvailableFilterableColumns}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                = 1;
        }
    }

    # get sortable dynamic fields
    # cycle trough the activated dynamic fields for this screen
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

    return $Self;
}

sub ActionRow {
    my ( $Self, %Param ) = @_;

    # check if bulk feature is enabled
    my $BulkFeature = 0;
    if ( $Param{Bulk} && $Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeature') ) {
        my @Groups;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeatureGroup') ) {
            @Groups = @{ $Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeatureGroup') };
        }
        if ( !@Groups ) {
            $BulkFeature = 1;
        }
        else {
            for my $Group (@Groups) {
                next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
                if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                    $BulkFeature = 1;
                    last;
                }
            }
        }
    }

    $Self->{LayoutObject}->Block(
        Name => 'DocumentActionRow',
        Data => \%Param,
    );

    if ($BulkFeature) {
        $Self->{LayoutObject}->Block(
            Name => 'DocumentActionRowBulk',
            Data => {
                %Param,
                Name => 'Bulk',
            },
        );
    }

    # check if there was a column filter and no results, and print a link to back
    if ( scalar @{ $Param{TicketIDs} } == 0 && $Param{LastColumnFilter} ) {
        $Self->{LayoutObject}->Block(
            Name => 'DocumentActionRowLastColumnFilter',
            Data => {
                %Param,
            },
        );
    }

    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewSmall',
        Data         => \%Param,
    );

    return $Output;
}

sub SortOrderBar {
    my ( $Self, %Param ) = @_;

    return '';
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketIDs PageShown StartHit)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if bulk feature is enabled
    my $BulkFeature = 0;
    if ( $Param{Bulk} && $Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeature') ) {
        my @Groups;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeatureGroup') ) {
            @Groups = @{ $Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeatureGroup') };
        }
        if ( !@Groups ) {
            $BulkFeature = 1;
        }
        else {
            for my $Group (@Groups) {
                next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
                if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                    $BulkFeature = 1;
                    last;
                }
            }
        }
    }

    my $Counter = 0;
    my @ArticleBox;
    for my $TicketID ( @{ $Param{TicketIDs} } ) {
        $Counter++;
        if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

            # get last customer article
            my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
                TicketID      => $TicketID,
                DynamicFields => 0,
            );

            # get ticket data
            my %Ticket = $Self->{TicketObject}->TicketGet(
                TicketID      => $TicketID,
                DynamicFields => 0,
            );

            # Fallback for tickets without articles: get at least basic ticket data
            if ( !%Article ) {
                %Article = $Self->{TicketObject}->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );
                if ( !$Article{Title} ) {
                    $Article{Title} = $Self->{LayoutObject}->{LanguageObject}->Get(
                        'This ticket has no title or subject'
                    );
                }
                $Article{Subject} = $Article{Title};

                # show ticket create time in small view
                $Article{Created} = $Ticket{Created};
            }

            # prepare subject
            $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject => $Article{Subject} || '',
            );

            # create human age
            $Article{Age} = $Self->{LayoutObject}->CustomerAge(
                Age   => $Article{Age},
                Space => ' ',
            );

            # get acl actions
            $Self->{TicketObject}->TicketAcl(
                Data          => '-',
                Action        => $Self->{Action},
                TicketID      => $Article{TicketID},
                ReturnType    => 'Action',
                ReturnSubType => '-',
                UserID        => $Self->{UserID},
            );
            my %AclAction = $Self->{TicketObject}->TicketAclActionData();

            # run ticket pre menu modules
            my @ActionItems;
            if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') eq 'HASH' ) {
                my %Menus = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') };
                my @Items;
                for my $Menu ( sort keys %Menus ) {

                    # load module
                    if ( !$Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                        return $Self->{LayoutObject}->FatalError();
                    }
                    my $Object
                        = $Menus{$Menu}->{Module}->new( %{$Self}, TicketID => $Article{TicketID}, );

                    # run module
                    my $Item = $Object->Run(
                        %Param,
                        Ticket => \%Article,
                        ACL    => \%AclAction,
                        Config => $Menus{$Menu},
                    );
                    next if !$Item;
                    next if ref $Item ne 'HASH';
                    for my $Key (qw(Name Link Description)) {
                        next if !$Item->{$Key};
                        $Item->{$Key} = $Self->{LayoutObject}->Output(
                            Template => $Item->{$Key},
                            Data     => \%Article,
                        );
                    }

                    # add session id if needed
                    if ( !$Self->{LayoutObject}->{SessionIDCookie} && $Item->{Link} ) {
                        $Item->{Link}
                            .= ';'
                            . $Self->{LayoutObject}->{SessionName} . '='
                            . $Self->{LayoutObject}->{SessionID};
                    }

                    # create id
                    $Item->{ID} = $Item->{Name};
                    $Item->{ID} =~ s/(\s|&|;)//ig;

                    $Self->{LayoutObject}->Block(
                        Name => $Item->{Block} || 'DocumentMenuItem',
                        Data => $Item,
                    );
                    my $Output = $Self->{LayoutObject}->Output(
                        TemplateFile => 'AgentTicketOverviewSmall',
                        Data         => $Item,
                    );
                    $Output =~ s/\n+//g;
                    $Output =~ s/\s+/ /g;
                    $Output =~ s/<\!--.+?-->//g;

                    push @ActionItems, {
                        HTML        => $Output,
                        ID          => $Item->{ID},
                        Link        => $Self->{LayoutObject}->{Baselink} . $Item->{Link},
                        Target      => $Item->{Target},
                        PopupType   => $Item->{PopupType},
                        Description => $Item->{Description},
                    };
                    $Article{ActionItems} = \@ActionItems;
                }
            }
            push @ArticleBox, \%Article;
        }
    }

    # check if sysconfig is a hash reference
    if ( IsArrayRefWithData( $Self->{ColumnsEnabled} ) ) {

        # check if column is really filterable
        COLUMNNAME:
        for my $ColumnName ( @{ $Self->{ColumnsEnabled} } ) {
            next COLUMNNAME if !grep { $_ eq $ColumnName } @{ $Self->{ColumnsEnabled} };
            next COLUMNNAME if !$Self->{AvailableFilterableColumns}->{$ColumnName};
            $Self->{ValidFilterableColumns}->{$ColumnName} = 1;
        }
    }

    my $ColumnValues = $Self->_GetColumnValues(
        OriginalTicketIDs => $Param{OriginalTicketIDs},
    );

    $Self->{LayoutObject}->Block(
        Name => 'DocumentContent',
        Data => \%Param,
    );

    # array to save the column names to do the query
    my @Col = @{ $Self->{ColumnsEnabled} };

    # define special ticket columns
    my %SpecialColumns = (
        TicketNumber => 1,
        Owner        => 1,
        CustomerID   => 1,
        Title        => 1,
    );

    my $TicketData = scalar @ArticleBox;
    if ($TicketData) {

        $Self->{LayoutObject}->Block( Name => 'OverviewTable' );
        $Self->{LayoutObject}->Block( Name => 'TableHeader' );

        if ($BulkFeature) {
            $Self->{LayoutObject}->Block(
                Name => 'BulkNavBar',
                Data => \%Param,
            );
        }

        # meta items
        my @TicketMetaItems = $Self->{LayoutObject}->TicketMetaItemsCount();
        for my $Item (@TicketMetaItems) {

            my $CSS = '';
            my $OrderBy;
            my $Link;
            my $Title = $Item;

            if ( $Param{SortBy} && ( $Param{SortBy} eq $Item ) ) {
                if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                    $OrderBy = 'Down';
                    $CSS .= ' SortAscendingLarge';
                }
                else {
                    $OrderBy = 'Up';
                    $CSS .= ' SortDescendingLarge';
                }

                # set title description
                my $TitleDesc = $OrderBy eq 'Down' ? 'sorted descending' : 'sorted ascending';
                $TitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($TitleDesc);
                $Title .= ', ' . $TitleDesc;
            }

            $Self->{LayoutObject}->Block(
                Name => 'OverviewNavBarPageFlag',
                Data => {
                    CSS => $CSS,
                },
            );

            if ( $Item eq 'New Article' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageFlagEmpty',
                    Data => { Name => $Item, }
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageFlagLink',
                    Data => {
                        %Param,
                        Name    => $Item,
                        CSS     => $CSS,
                        OrderBy => $OrderBy,
                        Title   => $Title,
                    },
                );
            }

        }

        #        # loop through all the general ticket data to get the ones that should be shown
        #        COLUMN:
        #        for my $Priority (sort { $a <=> $b} keys %ColumnPriorities ) {
        #            $TicketData = $ColumnPriorities{$Priority};
        #
        #            next COLUMN if !$TicketData;
        #
        #            # verify if the current ticket data is defined in the preferences
        #            if ( exists $Preferences{ 'OTRS' . $TicketData } ) {
        #
        #                # if it is enabled, the column should be shown
        #                if (
        #                    defined $Preferences{ 'OTRS' . $TicketData }
        #                    && $Preferences{ 'OTRS' . $TicketData } ne ''
        #                    )
        #                {
        #                    push @Col, $TicketData;
        #                }
        #            }
        #
        #            # otherwise, read the config
        #            else {
        #                if ( $Config->{GeneralTicketData}->{$TicketData} eq '1' ) {
        #                    push @Col, $TicketData;
        #                }
        #            }
        #        }

        my $CSS = '';
        my $OrderBy;

        # show special ticket columns, if needed
        COLUMN:
        for my $Column (@Col) {

            $CSS = $Column;
            my $Title = $Column;

            # ouput overal block so TicketNumber as well as other columns can be ordered
            $Self->{LayoutObject}->Block(
                Name => 'OverviewNavBarPageTicketHeader',
                Data => {},
            );

            if ( $SpecialColumns{$Column} ) {

                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
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

                if ( $Column eq 'Title' ) {

                    $TranslatedWord
                        = $Self->{LayoutObject}->{LanguageObject}->Get('From') . ' / ';

                    if ( $Self->{SmallViewColumnHeader} eq 'LastCustomerSubject' ) {
                        $TranslatedWord .= $Self->{LayoutObject}->{LanguageObject}->Get('Subject');
                    }
                    elsif ( $Self->{SmallViewColumnHeader} eq 'TicketTitle' ) {
                        $TranslatedWord .= $Self->{LayoutObject}->{LanguageObject}->Get('Title');
                    }
                }
                else {
                    $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get($Column);
                }

                my $FilterTitle     = $Column;
                my $FilterTitleDesc = 'filter not active';
                if (
                    $Self->{StoredFilters} &&
                    (
                        $Self->{StoredFilters}->{$Column} ||
                        $Self->{StoredFilters}->{ $Column . 'IDs' }
                    )
                    )
                {
                    $CSS .= ' FilterActive';
                    $FilterTitleDesc = 'filter active';
                }
                $FilterTitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($FilterTitleDesc);
                $FilterTitle .= ', ' . $FilterTitleDesc;

                $Self->{LayoutObject}->Block(
                    Name =>
                        $Column eq 'TicketNumber'
                    ? 'OverviewNavBarPageTicketNumber'
                    : 'OverviewNavBarPageColumn',
                    Data => {
                        %Param,
                        OrderBy              => $OrderBy,
                        ColumnName           => $Column || '',
                        CSS                  => $CSS || '',
                        ColumnNameTranslated => $TranslatedWord || $Column,
                        Title                => $Title,
                    },
                );

                # verify if column is filterable and sortable
                if (
                    $Self->{ValidFilterableColumns}->{$Column}
                    && $Self->{ValidSortableColumns}->{$Column}
                    )
                {
                    my $Css;
                    if ( $Column eq 'CustomerID' || $Column eq 'Owner' ) {
                        $Css .= ' Hidden';
                    }

                    # variable to save the filter's html code
                    my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                        ColumnName    => $Column,
                        Label         => $Column,
                        ColumnValues  => $ColumnValues->{$Column},
                        SelectedValue => $Param{GetColumnFilter}->{$Column} || '',
                        Css           => $Css,
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnFilterLink',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            ColumnFilterStrg     => $ColumnFilterHTML,
                            OrderBy              => $OrderBy,
                            Title                => $Title,
                            FilterTitle          => $FilterTitle,
                        },
                    );

                    if ( $Column eq 'CustomerID' ) {

                        $Self->{LayoutObject}->Block(
                            Name =>
                                'ContentLargeTicketGenericHeaderColumnFilterLinkCustomerIDSearch',
                            Data => {
                                minQueryLength      => 2,
                                queryDelay          => 100,
                                maxResultsDisplayed => 20,
                            },
                        );
                    }
                    elsif ( $Column eq 'Owner' ) {

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

                # verify if column is filterable and sortable
                elsif ( $Self->{ValidFilterableColumns}->{$Column} ) {

                    # variable to save the filter's html code
                    my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                        ColumnName    => $Column,
                        Label         => $Column,
                        ColumnValues  => $ColumnValues->{$Column},
                        SelectedValue => $Param{GetColumnFilter}->{$Column} || '',
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnFilter',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            ColumnFilterStrg     => $ColumnFilterHTML,
                            OrderBy              => $OrderBy,
                            Title                => $Title,
                            FilterTitle          => $FilterTitle,
                        },
                    );
                }

                # verify if column is sortable
                elsif ( $Self->{ValidSortableColumns}->{$Column} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnLink',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            OrderBy              => $OrderBy,
                            Title                => $Title,
                        },
                    );
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnEmpty',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            Title                => $Title,
                        },
                    );
                }
                next COLUMN;
            }
            elsif ( $Column !~ m{\A DynamicField_}xms ) {

                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
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
                if ( $Column eq 'EscalationTime' ) {
                    $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Service Time');
                }
                elsif ( $Column eq 'EscalationResponseTime' ) {
                    $TranslatedWord
                        = $Self->{LayoutObject}->{LanguageObject}->Get('First Response Time');
                }
                elsif ( $Column eq 'EscalationSolutionTime' ) {
                    $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Solution Time');
                }
                elsif ( $Column eq 'EscalationUpdateTime' ) {
                    $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Update Time');
                }
                elsif ( $Column eq 'PendingTime' ) {
                    $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get('Pending till');
                }
                else {
                    $TranslatedWord = $Self->{LayoutObject}->{LanguageObject}->Get($Column);
                }

                my $FilterTitle     = $Column;
                my $FilterTitleDesc = 'filter not active';
                if ( $Self->{StoredFilters} && $Self->{StoredFilters}->{ $Column . 'IDs' } ) {
                    $CSS .= ' FilterActive';
                    $FilterTitleDesc = 'filter active';
                }
                $FilterTitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($FilterTitleDesc);
                $FilterTitle .= ', ' . $FilterTitleDesc;

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageColumn',
                    Data => {
                        %Param,
                        ColumnName           => $Column,
                        CSS                  => $CSS,
                        ColumnNameTranslated => $TranslatedWord || $Column,
                    },
                );

                # verify if column is filterable and sortable
                if (
                    $Self->{ValidFilterableColumns}->{$Column}
                    && $Self->{ValidSortableColumns}->{$Column}
                    )
                {
                    my $Css;
                    if ( $Column eq 'Responsible' ) {
                        $Css .= ' Hidden';
                    }

                    # variable to save the filter's html code
                    my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                        ColumnName    => $Column,
                        Label         => $Column,
                        ColumnValues  => $ColumnValues->{$Column},
                        SelectedValue => $Param{GetColumnFilter}->{$Column} || '',
                        Css           => $Css,
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnFilterLink',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            ColumnFilterStrg     => $ColumnFilterHTML,
                            OrderBy              => $OrderBy,
                            Title                => $Title,
                            FilterTitle          => $FilterTitle,
                        },
                    );

                    if ( $Column eq 'Responsible' ) {

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
                elsif ( $Self->{ValidFilterableColumns}->{$Column} ) {

                    my $Css;
                    if ( $Column eq 'CustomerUserID' ) {
                        $Css = 'Hidden';
                    }

                    # variable to save the filter's html code
                    my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                        ColumnName    => $Column,
                        Label         => $Column,
                        ColumnValues  => $ColumnValues->{$Column},
                        SelectedValue => $Param{GetColumnFilter}->{$Column} || '',
                        Css           => $Css,
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnFilter',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            ColumnFilterStrg     => $ColumnFilterHTML,
                            OrderBy              => $OrderBy,
                            Title                => $Title,
                            FilterTitle          => $FilterTitle,
                        },
                    );
                    if ( $Column eq 'CustomerUserID' ) {

                        $Self->{LayoutObject}->Block(
                            Name =>
                                'ContentLargeTicketGenericHeaderColumnFilterLinkCustomerUserSearch',
                            Data => {
                                minQueryLength      => 2,
                                queryDelay          => 100,
                                maxResultsDisplayed => 20,
                            },
                        );
                    }
                }

                # verify if column is sortable
                elsif ( $Self->{ValidSortableColumns}->{$Column} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnLink',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            OrderBy              => $OrderBy,
                            Title                => $Title,
                        },
                    );
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageColumnEmpty',
                        Data => {
                            %Param,
                            ColumnName           => $Column,
                            CSS                  => $CSS,
                            ColumnNameTranslated => $TranslatedWord || $Column,
                            Title                => $Title,
                        },
                    );
                }
            }

            # show the DFs
            else {

                my $DynamicFieldConfig;
                my $DFColumn = $Column;
                $DFColumn =~ s/DynamicField_//g;
                DYNAMICFIELD:
                for my $DFConfig ( @{ $Self->{DynamicField} } ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DFConfig);
                    next DYNAMICFIELD if $DFConfig->{Name} ne $DFColumn;

                    $DynamicFieldConfig = $DFConfig;
                    last DYNAMICFIELD;
                }
                next COLUMN if !IsHashRefWithData($DynamicFieldConfig);

                my $Label = $DynamicFieldConfig->{Label};
                $Title = $Label;
                my $FilterTitle = $Label;

                # get field sortable condition
                my $IsSortable = $Self->{BackendObject}->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsSortable',
                );

                if ($IsSortable) {
                    my $CSS = '';
                    my $OrderBy;
                    if (
                        $Param{SortBy}
                        && ( $Param{SortBy} eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                        )
                    {
                        if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                            $OrderBy = 'Down';
                            $CSS .= ' SortDescendingLarge';
                        }
                        else {
                            $OrderBy = 'Up';
                            $CSS .= ' SortAscendingLarge';
                        }

                        # add title description
                        my $TitleDesc
                            = $OrderBy eq 'Down' ? 'sorted descending' : 'sorted ascending';
                        $TitleDesc = $Self->{LayoutObject}->{LanguageObject}->Get($TitleDesc);
                        $Title .= ', ' . $TitleDesc;
                    }

                    my $FilterTitleDesc = 'filter not active';
                    if ( $Self->{StoredFilters} && $Self->{StoredFilters}->{$Column} ) {
                        $CSS .= ' FilterActive';
                        $FilterTitleDesc = 'filter active';
                    }
                    $FilterTitleDesc
                        = $Self->{LayoutObject}->{LanguageObject}->Get($FilterTitleDesc);
                    $FilterTitle .= ', ' . $FilterTitleDesc;

                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageDynamicField',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    my $DynamicFieldName = 'DynamicField_' . $DynamicFieldConfig->{Name};

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's html code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicFieldFiltrableSortable',
                            Data => {
                                %Param,
                                OrderBy          => $OrderBy,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                ColumnFilterStrg => $ColumnFilterHTML,
                                OrderBy          => $OrderBy,
                                Title            => $Title,
                                FilterTitle      => $FilterTitle,
                            },
                        );
                    }

                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicFieldSortable',
                            Data => {
                                %Param,
                                OrderBy          => $OrderBy,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                Title            => $Title,
                            },
                        );
                    }

                    # example of dynamic fields order customization
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's html code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicField'
                                . $DynamicFieldConfig->{Name}
                                . '_FiltrableSortable',
                            Data => {
                                %Param,
                                OrderBy          => $OrderBy,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                ColumnFilterStrg => $ColumnFilterHTML,
                                OrderBy          => $OrderBy,
                                Title            => $Title,
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicField_'
                                . $DynamicFieldConfig->{Name}
                                . '_Sortable',
                            Data => {
                                %Param,
                                OrderBy          => $OrderBy,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                Title            => $Title,
                            },
                        );
                    }
                }
                else {

                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageDynamicField',
                        Data => {
                            %Param,
                        },
                    );
                    my $DynamicFieldName = 'DynamicField_' . $DynamicFieldConfig->{Name};

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's html code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicFieldFiltrableNotSortable',
                            Data => {
                                %Param,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                ColumnFilterStrg => $ColumnFilterHTML,
                                Title            => $Title,
                                FilterTitle      => $FilterTitle,
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicFieldNotSortable',
                            Data => {
                                %Param,
                                Label => $Label,
                                Title => $Title,
                            },
                        );
                    }

                    # example of dynamic fields order customization
                    $Self->{LayoutObject}->Block(
                        Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                        Data => {
                            %Param,
                        },
                    );

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's html code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicField_'
                                . $DynamicFieldConfig->{Name}
                                . '_FiltrableNotSortable',
                            Data => {
                                %Param,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                ColumnFilterStrg => $ColumnFilterHTML,
                                Title            => $Title,
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'OverviewNavBarPageDynamicField_'
                                . $DynamicFieldConfig->{Name}
                                . '_NotSortable',
                            Data => {
                                %Param,
                                Label => $Label,
                                Title => $Title,
                            },
                        );
                    }
                }

            }

        }

        $Self->{LayoutObject}->Block( Name => 'TableBody' );

    }
    else {
        $Self->{LayoutObject}->Block( Name => 'NoTicketFound' );
    }

    for my $ArticleRef (@ArticleBox) {

        # get last customer article
        my %Article = %{$ArticleRef};

        # escalation human times
        if ( $Article{EscalationTime} ) {
            $Article{EscalationTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Article{EscalationTime},
                Space => ' ',
            );
            $Article{EscalationTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Article{EscalationTimeWorkingTime},
                Space => ' ',
            );
        }

        # customer info (customer name)
        if ( $Param{Config}->{CustomerInfo} ) {
            if ( $Article{CustomerUserID} ) {
                $Article{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                    UserLogin => $Article{CustomerUserID},
                );
            }
        }

        # user info
        my %UserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Article{OwnerID},
        );

        $Self->{LayoutObject}->Block(
            Name => 'Record',
            Data => { %Article, %UserInfo },
        );

        # check if bulk feature is enabled
        if ($BulkFeature) {
            $Self->{LayoutObject}->Block(
                Name => 'Bulk',
                Data => { %Article, %UserInfo },
            );
        }

        # show ticket flags
        my @TicketMetaItems = $Self->{LayoutObject}->TicketMetaItems(
            Ticket => \%Article,
        );
        for my $Item (@TicketMetaItems) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeTicketGenericRowMeta',
                Data => $Item,
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
        TICKETCOLUMN:
        for my $TicketColumn (@Col) {

            if ( $TicketColumn !~ m{\A DynamicField_}xms ) {
                $Self->{LayoutObject}->Block(
                    Name => 'RecordTicketData',
                    Data => {},
                );

                if ( $SpecialColumns{$TicketColumn} ) {
                    if ( $TicketColumn eq 'Title' ) {

                        # check if last customer subject or ticket title should be shown
                        if ( $Self->{SmallViewColumnHeader} eq 'LastCustomerSubject' ) {
                            $Self->{LayoutObject}->Block(
                                Name => 'RecordLastCustomerSubject',
                                Data => { %Article, %UserInfo },
                            );
                        }
                        elsif ( $Self->{SmallViewColumnHeader} eq 'TicketTitle' ) {
                            $Self->{LayoutObject}->Block(
                                Name => 'RecordTicketTitle',
                                Data => { %Article, %UserInfo },
                            );
                        }
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $TicketColumn,
                            Data => { %Article, %UserInfo },
                        );
                    }
                    next TICKETCOLUMN;
                }

                # escalation column
                my %EscalationData;
                if ( $TicketColumn eq 'EscalationTime' ) {
                    $EscalationData{EscalationTime} = $Article{EscalationTime};
                    $EscalationData{EscalationDestinationDate}
                        = $Article{EscalationDestinationDate};

                    $EscalationData{EscalationTimeHuman}
                        = $Self->{LayoutObject}->CustomerAgeInHours(
                        Age   => $EscalationData{EscalationTime},
                        Space => ' ',
                        );
                    $EscalationData{EscalationTimeWorkingTime}
                        = $Self->{LayoutObject}->CustomerAgeInHours(
                        Age   => $EscalationData{EscalationTimeWorkingTime},
                        Space => ' ',
                        );
                    if (
                        defined $Article{EscalationTime}
                        && $Article{EscalationTime} < 60 * 60 * 1
                        )
                    {
                        $EscalationData{EscalationClass} = 'Warning';
                    }
                    $Self->{LayoutObject}->Block(
                        Name => 'RecordEscalationTime',
                        Data => {%EscalationData},
                    );
                    next TICKETCOLUMN;
                }

                my $BlockType = '';
                my $CSSClass  = '';
                if ( $TicketColumn eq 'EscalationSolutionTime' ) {
                    $BlockType = 'Escalation';
                    $DataValue = $Self->{LayoutObject}->CustomerAgeInHours(
                        Age => $Article{SolutionTime} || 0,
                        Space => ' ',
                    );
                    if ( defined $Article{SolutionTime} && $Article{SolutionTime} < 60 * 60 * 1 ) {
                        $CSSClass = 'Warning';
                    }
                }
                elsif ( $TicketColumn eq 'EscalationResponseTime' ) {
                    $BlockType = 'Escalation';
                    $DataValue = $Self->{LayoutObject}->CustomerAgeInHours(
                        Age => $Article{FirstResponseTime} || 0,
                        Space => ' ',
                    );
                    if (
                        defined $Article{FirstResponseTime}
                        && $Article{FirstResponseTime} < 60 * 60 * 1
                        )
                    {
                        $CSSClass = 'Warning';
                    }
                }
                elsif ( $TicketColumn eq 'EscalationUpdateTime' ) {
                    $BlockType = 'Escalation';
                    $DataValue = $Self->{LayoutObject}->CustomerAgeInHours(
                        Age => $Article{UpdateTime} || 0,
                        Space => ' ',
                    );
                    if ( defined $Article{UpdateTime} && $Article{UpdateTime} < 60 * 60 * 1 ) {
                        $CSSClass = 'Warning';
                    }
                }
                elsif ( $TicketColumn eq 'PendingTime' ) {
                    $BlockType = 'Escalation';
                    $DataValue = $Self->{LayoutObject}->CustomerAge(
                        Age   => $Article{'UntilTime'},
                        Space => ' '
                    );
                    if ( defined $Article{UntilTime} && $Article{UntilTime} < -1 ) {
                        $CSSClass = 'Warning';
                    }
                }
                elsif (
                    $TicketColumn eq 'State'
                    || $TicketColumn eq 'Lock'
                    || $TicketColumn eq 'Priority'
                    )
                {
                    $BlockType = 'Translatable';
                    $DataValue = $Article{$TicketColumn} || $UserInfo{$TicketColumn};
                }
                elsif ( $TicketColumn eq 'Created' ) {
                    $BlockType = 'Time';
                    $DataValue = $Article{$TicketColumn} || $UserInfo{$TicketColumn};
                }
                elsif ( $TicketColumn eq 'Responsible' ) {

                    # get responsible info
                    my %ResponsibleInfo = $Self->{UserObject}->GetUserData(
                        UserID => $Article{ResponsibleID},
                    );
                    $DataValue = $ResponsibleInfo{'UserFirstname'} . ' '
                        . $ResponsibleInfo{'UserLastname'};
                }
                else {
                    $DataValue = $Article{$TicketColumn} || $UserInfo{$TicketColumn};
                }

                $Self->{LayoutObject}->Block(
                    Name => "RecordTicketColumn$BlockType",
                    Data => {
                        GenericValue => $DataValue || '',
                        Class        => $CSSClass  || '',
                    },
                );
            }

            # dynamic fields
            else {
                # cycle trough the activated dynamic fields for this screen

                my $DynamicFieldConfig;
                my $DFColumn = $TicketColumn;
                $DFColumn =~ s/DynamicField_//g;
                DYNAMICFIELD:
                for my $DFConfig ( @{ $Self->{DynamicField} } ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DFConfig);
                    next DYNAMICFIELD if $DFConfig->{Name} ne $DFColumn;

                    $DynamicFieldConfig = $DFConfig;
                    last DYNAMICFIELD;
                }
                next TICKETCOLUMN if !IsHashRefWithData($DynamicFieldConfig);

                # get field value
                my $Value = $Self->{BackendObject}->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $Article{TicketID},
                );

                my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Value,
                    ValueMaxChars      => 20,
                    LayoutObject       => $Self->{LayoutObject},
                );

                $Self->{LayoutObject}->Block(
                    Name => 'RecordDynamicField',
                    Data => {
                        Value => $ValueStrg->{Value},
                        Title => $ValueStrg->{Title},
                    },
                );

                if ( $ValueStrg->{Link} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicFieldLink',
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
                        Name => 'RecordDynamicFieldPlain',
                        Data => {
                            Value => $ValueStrg->{Value},
                            Title => $ValueStrg->{Title},
                        },
                    );
                }

                # example of dynamic fields order customization
                $Self->{LayoutObject}->Block(
                    Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        Value => $ValueStrg->{Value},
                        Title => $ValueStrg->{Title},
                    },
                );

                if ( $ValueStrg->{Link} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . '_Link',
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
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
                        Data => {
                            Value => $ValueStrg->{Value},
                            Title => $ValueStrg->{Title},
                        },
                    );
                }
            }
        }

        # add action items as js
        if ( $Article{ActionItems} ) {

            my $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => $Article{ActionItems},
            );

            $Self->{LayoutObject}->Block(
                Name => 'DocumentReadyActionRowAdd',
                Data => {
                    TicketID => $Article{TicketID},
                    Data     => $JSON,
                },
            );
        }
    }

    # init for table control
    $Self->{LayoutObject}->Block(
        Name => 'DocumentReadyStart',
        Data => \%Param,
    );

    # use template
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewSmall',
        Data         => {
            %Param,
            Type => $Self->{ViewType},
        },
    );

    return $Output;
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
        Name        => 'ColumnFilter' . $Param{ColumnName},
        Data        => $Data,
        Class       => $Class,
        Translation => $TranslationOption,
        SelectedID  => '',
    );
    return $ColumnFilterHTML;
}

sub FilterContent {
    my ( $Self, %Param ) = @_;

    return if !$Param{HeaderColumn};

    my $HeaderColumn = $Param{HeaderColumn};

    # get column values for to build the filters later
    my $ColumnValues = $Self->_GetColumnValues(
        OriginalTicketIDs => $Param{OriginalTicketIDs},
        HeaderColumn      => $HeaderColumn,
    );

    my $SelectedValue  = '';
    my $SelectedColumn = $HeaderColumn;
    if ( $HeaderColumn eq 'CustomerUserID' ) {
        $SelectedColumn = 'CustomerUserLogin';
    }
    if ( $HeaderColumn eq 'CustomerID' ) {
        $SelectedColumn = 'CustomerID';
    }
    elsif ( $HeaderColumn !~ m{ \A DynamicField_ }xms ) {
        $SelectedColumn .= 'IDs';
    }

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

    if ( $SelectedColumn && $Self->{StoredFilters}->{$SelectedColumn} ) {

        if ( IsArrayRefWithData( $Self->{StoredFilters}->{$SelectedColumn} ) ) {
            $SelectedValue = $Self->{StoredFilters}->{$SelectedColumn}->[0];
        }
        elsif ( IsHashRefWithData( $Self->{StoredFilters}->{$SelectedColumn} ) ) {
            $SelectedValue = $Self->{StoredFilters}->{$SelectedColumn}->{Equals};
        }
    }

    # variable to save the filter's html code
    my $ColumnFilterJSON = $Self->_ColumnFilterJSON(
        ColumnName    => $HeaderColumn,
        Label         => $LabelColumn,
        ColumnValues  => $ColumnValues->{$HeaderColumn},
        SelectedValue => $SelectedValue,
    );

    return $ColumnFilterJSON;
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

    if (
        !$Self->{AvailableFilterableColumns}->{ $Param{ColumnName} } &&
        !$Self->{AvailableFilterableColumns}->{ $Param{ColumnName} . 'IDs' }
        )
    {
        return;
    }

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
                Name         => 'ColumnFilter' . $Param{ColumnName},
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

1;
