# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketOverview::Small;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerUser',
    'Kernel::System::Group',
    'Kernel::System::User',
    'Kernel::System::JSON',
    'Kernel::System::DynamicField',
    'Kernel::System::Ticket::ColumnFilter',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = \%Param;
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # set pref for columns key
    $Self->{PrefKeyColumns} = 'UserFilterColumnsEnabled' . '-' . $Self->{Action};

    # load backend config
    my $BackendConfigKey = 'Ticket::Frontend::' . $Self->{Action};
    $Self->{Config} = $ConfigObject->Get($BackendConfigKey);

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    # get JSON object
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    # set stored filters if present
    my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
    if ( $Preferences{$StoredFiltersKey} ) {
        my $StoredFilters = $JSONObject->Decode(
            Data => $Preferences{$StoredFiltersKey},
        );
        $Self->{StoredFilters} = $StoredFilters;
    }

    # get the configured dyanmic fields from the Small Overview setting as a basis
    my %DefaultDynamicFields = %{ $ConfigObject->Get("Ticket::Frontend::OverviewSmall")->{DynamicField} || {} };

    my %DefaultColumns = map { 'DynamicField_' . $_ => $DefaultDynamicFields{$_} } sort keys %DefaultDynamicFields;

    # take general settings (Frontend::Agent) if not defined for the screen
    $Self->{Config}->{DefaultColumns} //= $ConfigObject->Get('DefaultOverviewColumns');

    # check for default settings specific for this screen, should overide the dynamic fields
    %DefaultColumns = ( %DefaultColumns, %{ $Self->{Config}->{DefaultColumns} || {} } );

    # configure columns
    my @ColumnsAvailable = grep { $DefaultColumns{$_} ne '0' } sort keys %DefaultColumns;
    my @ColumnsEnabled   = grep { $DefaultColumns{$_} eq '2' } sort _DefaultColumnSort keys %DefaultColumns;

    # if preference settings are available, take them
    if ( $Preferences{ $Self->{PrefKeyColumns} } ) {

        my $ColumnsEnabled = $JSONObject->Decode(
            Data => $Preferences{ $Self->{PrefKeyColumns} },
        );

        # remove duplicate columns
        my %UniqueColumns;
        my @ColumnsEnabledAux;

        for my $Column ( @{$ColumnsEnabled} ) {
            if ( !$UniqueColumns{$Column} ) {
                push @ColumnsEnabledAux, $Column;
            }
            $UniqueColumns{$Column} = 1;
        }

        # set filtered column list
        @ColumnsEnabled = @ColumnsEnabledAux;

    }

    # always set TicketNumber
    if ( !grep { $_ eq 'TicketNumber' } @ColumnsEnabled ) {
        unshift @ColumnsEnabled, 'TicketNumber';
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
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # hash with all valid sortable columns (taken from TicketSearch)
    # SortBy  => 'Age',   # Created|Owner|Responsible|CustomerID|State|TicketNumber|Queue
    # |Priority|Type|Lock|Title|Service|Changed|SLA|PendingTime|EscalationTime
    # | EscalationUpdateTime|EscalationResponseTime|EscalationSolutionTime
    $Self->{ValidSortableColumns} = {
        'Age'                    => 1,
        'Created'                => 1,
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

    # remove queue from filters on AgentTicketQueue
    if ( $Self->{Action} eq 'AgentTicketQueue' ) {
        delete $Self->{AvailableFilterableColumns}->{Queue};
    }

    # remove service from filters on AgentTicketService
    if ( $Self->{Action} eq 'AgentTicketService' ) {
        delete $Self->{AvailableFilterableColumns}->{Service};
    }

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get filterable dynamic fields
    # cycle trough the activated dynamic fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsFiltrable = $DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsFiltrable',
        );

        # if the dynamic field is filterable add it to the AvailableFilterableColumns hash
        if ($IsFiltrable) {
            $Self->{AvailableFilterableColumns}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = 1;
        }
    }

    # get sortable dynamic fields
    # cycle trough the activated dynamic fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsSortable = $DynamicFieldBackendObject->HasBehavior(
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

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if bulk feature is enabled
    my $BulkFeature = 0;
    if ( $Param{Bulk} && $ConfigObject->Get('Ticket::Frontend::BulkFeature') ) {
        my @Groups;
        if ( $ConfigObject->Get('Ticket::Frontend::BulkFeatureGroup') ) {
            @Groups = @{ $ConfigObject->Get('Ticket::Frontend::BulkFeatureGroup') };
        }
        if ( !@Groups ) {
            $BulkFeature = 1;
        }
        else {
            my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
            GROUP:
            for my $Group (@Groups) {
                my $HasPermission = $GroupObject->PermissionCheck(
                    UserID    => $Self->{UserID},
                    GroupName => $Group,
                    Type      => 'rw',
                );
                if ($HasPermission) {
                    $BulkFeature = 1;
                    last GROUP;
                }
            }
        }
    }

    $LayoutObject->Block(
        Name => 'DocumentActionRow',
        Data => \%Param,
    );

    if ($BulkFeature) {
        $LayoutObject->Block(
            Name => 'DocumentActionRowBulk',
            Data => {
                %Param,
                Name => Translatable('Bulk'),
            },
        );
    }

    # check if there was a column filter and no results, and print a link to back
    if ( scalar @{ $Param{TicketIDs} } == 0 && $Param{LastColumnFilter} ) {
        $LayoutObject->Block(
            Name => 'DocumentActionRowLastColumnFilter',
            Data => {
                %Param,
            },
        );
    }

    my %ColumnTranslations;
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # add translations for the allocation lists for regular columns
    my $Columns = $Self->{Config}->{DefaultColumns} || $ConfigObject->Get('DefaultOverviewColumns') || {};
    if ( $Columns && IsHashRefWithData($Columns) ) {

        COLUMN:
        for my $Column ( sort keys %{$Columns} ) {

            # dynamic fields will be translated in the next block
            next COLUMN if $Column =~ m{ \A DynamicField_ }xms;

            my $TranslatedWord = $Column;
            if ( $Column eq 'EscalationTime' ) {
                $TranslatedWord = Translatable('Service Time');
            }
            elsif ( $Column eq 'EscalationResponseTime' ) {
                $TranslatedWord = Translatable('First Response Time');
            }
            elsif ( $Column eq 'EscalationSolutionTime' ) {
                $TranslatedWord = Translatable('Solution Time');
            }
            elsif ( $Column eq 'EscalationUpdateTime' ) {
                $TranslatedWord = Translatable('Update Time');
            }
            elsif ( $Column eq 'PendingTime' ) {
                $TranslatedWord = Translatable('Pending till');
            }
            elsif ( $Column eq 'CustomerCompanyName' ) {
                $TranslatedWord = Translatable('Customer Name');
            }
            elsif ( $Column eq 'CustomerID' ) {
                $TranslatedWord = Translatable('Customer ID');
            }
            elsif ( $Column eq 'CustomerName' ) {
                $TranslatedWord = Translatable('Customer User Name');
            }
            elsif ( $Column eq 'CustomerUserID' ) {
                $TranslatedWord = Translatable('Customer User ID');
            }

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'Column' . $Column,
                Value => $LanguageObject->Translate($TranslatedWord),
            );
        }
    }

    # add translations for the allocation lists for dynamic field columns
    my $ColumnsDynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => ['Ticket'],
    );

    if ( $ColumnsDynamicField && IsArrayRefWithData($ColumnsDynamicField) ) {

        my $Counter = 0;

        DYNAMICFIELD:
        for my $DynamicField ( sort @{$ColumnsDynamicField} ) {

            next DYNAMICFIELD if !$DynamicField;

            $Counter++;

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'ColumnDynamicField_' . $DynamicField->{Name},
                Value => $LanguageObject->Translate( $DynamicField->{Label} ),
            );
        }
    }

    my $Output = $LayoutObject->Output(
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

    # If $Param{EnableColumnFilters} is not sent, we want to disable all filters
    #   for the current screen. We localize the setting for this sub and change it
    #   after that, if needed. The original value will be restored after this function.
    local $Self->{AvailableFilterableColumns} = $Self->{AvailableFilterableColumns};
    if ( !$Param{EnableColumnFilters} ) {
        $Self->{AvailableFilterableColumns} = {};    # disable all column filters
    }

    for my $Item (qw(TicketIDs PageShown StartHit)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if bulk feature is enabled
    my $BulkFeature = 0;
    if ( $Param{Bulk} && $ConfigObject->Get('Ticket::Frontend::BulkFeature') ) {
        my @Groups;
        if ( $ConfigObject->Get('Ticket::Frontend::BulkFeatureGroup') ) {
            @Groups = @{ $ConfigObject->Get('Ticket::Frontend::BulkFeatureGroup') };
        }
        if ( !@Groups ) {
            $BulkFeature = 1;
        }
        else {
            my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
            GROUP:
            for my $Group (@Groups) {
                my $HasPermission = $GroupObject->PermissionCheck(
                    UserID    => $Self->{UserID},
                    GroupName => $Group,
                    Type      => 'rw',
                );
                if ($HasPermission) {
                    $BulkFeature = 1;
                    last GROUP;
                }
            }
        }
    }

    my $Counter = 0;
    my @ArticleBox;

    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Get extended ticket data if columns are used, save performance. See bug#14748.
    my %ExtendedColumnsHash = (
        FirstResponse          => 1,
        FirstResponseInMin     => 1,
        FirstResponseDiffInMin => 1,
        SolutionInMin          => 1,
        SolutionDiffInMin      => 1,
        FirstLock              => 1,
    );

    my $Extended = 0;
    if ( grep { $ExtendedColumnsHash{$_} } @{ $Self->{ColumnsEnabled} } ) {
        $Extended = 1;
    }

    for my $TicketID ( @{ $Param{TicketIDs} } ) {
        $Counter++;
        if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {

            # Get last customer article.
            my @Articles = $ArticleObject->ArticleList(
                TicketID   => $TicketID,
                SenderType => 'customer',
                OnlyLast   => 1,
            );

            # If the ticket has no customer article, get the last agent article.
            if ( !@Articles ) {
                @Articles = $ArticleObject->ArticleList(
                    TicketID   => $TicketID,
                    SenderType => 'agent',
                    OnlyLast   => 1,
                );
            }

            # Finally, if everything failed, get latest article.
            if ( !@Articles ) {
                @Articles = $ArticleObject->ArticleList(
                    TicketID => $TicketID,
                    OnlyLast => 1,
                );
            }

            my %Article;
            for my $Article (@Articles) {
                %Article = $ArticleObject->BackendForArticle( %{$Article} )->ArticleGet(
                    %{$Article},
                    DynamicFields => 0,
                );
            }

            # Get ticket data.
            my %Ticket = $TicketObject->TicketGet(
                TicketID      => $TicketID,
                Extended      => $Extended,
                DynamicFields => 0,
            );

            %Article = ( %Article, %Ticket );

            # Get channel specific fields.
            if ( $Article{ArticleID} ) {
                my %ArticleFields = $LayoutObject->ArticleFields(
                    TicketID  => $TicketID,
                    ArticleID => $Article{ArticleID},
                );
                FIELD:
                for my $FieldKey (qw(Sender Subject)) {
                    next FIELD if !defined $ArticleFields{$FieldKey}->{Value};
                    $Article{$FieldKey} = $ArticleFields{$FieldKey}->{Realname} // $ArticleFields{$FieldKey}->{Value};
                }
            }

            # Fallback for tickets without articles: get at least basic ticket data.
            if ( !%Article ) {
                %Article = %Ticket;
                if ( !$Article{Title} ) {
                    $Article{Title} = $LayoutObject->{LanguageObject}->Translate(
                        'This ticket has no title or subject'
                    );
                }
                $Article{Subject} = $Article{Title};
            }

            # show ticket create time in small view
            $Article{Created} = $Ticket{Created};

            # create human age
            $Article{Age} = $LayoutObject->CustomerAge(
                Age   => $Article{Age},
                Space => ' ',
            );

            # get ACL restrictions
            my %PossibleActions;
            my $Counter = 0;

            # get all registered Actions
            if ( ref $ConfigObject->Get('Frontend::Module') eq 'HASH' ) {

                my %Actions = %{ $ConfigObject->Get('Frontend::Module') };

                # only use those Actions that stats with AgentTicket
                %PossibleActions = map { ++$Counter => $_ }
                    grep { substr( $_, 0, length 'AgentTicket' ) eq 'AgentTicket' }
                    sort keys %Actions;
            }

            my $ACL = $TicketObject->TicketAcl(
                Data          => \%PossibleActions,
                Action        => $Self->{Action},
                TicketID      => $Article{TicketID},
                ReturnType    => 'Action',
                ReturnSubType => '-',
                UserID        => $Self->{UserID},
            );
            my %AclAction = %PossibleActions;
            if ($ACL) {
                %AclAction = $TicketObject->TicketAclActionData();
            }

            # run ticket pre menu modules
            my @ActionItems;
            if ( ref $ConfigObject->Get('Ticket::Frontend::PreMenuModule') eq 'HASH' ) {
                my %Menus = %{ $ConfigObject->Get('Ticket::Frontend::PreMenuModule') };
                my @Items;
                MENU:
                for my $Menu ( sort keys %Menus ) {

                    # load module
                    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Menus{$Menu}->{Module} ) ) {
                        return $LayoutObject->FatalError();
                    }
                    my $Object = $Menus{$Menu}->{Module}->new(
                        %{$Self},
                        TicketID => $Article{TicketID},
                    );

                    # run module
                    my $Item = $Object->Run(
                        %Param,
                        Ticket => \%Article,
                        ACL    => \%AclAction,
                        Config => $Menus{$Menu},
                    );
                    next MENU if !$Item;
                    next MENU if ref $Item ne 'HASH';

                    # add session id if needed
                    if ( !$LayoutObject->{SessionIDCookie} && $Item->{Link} ) {
                        $Item->{Link}
                            .= ';'
                            . $LayoutObject->{SessionName} . '='
                            . $LayoutObject->{SessionID};
                    }

                    # create id
                    $Item->{ID} = $Item->{Name};
                    $Item->{ID} =~ s/(\s|&|;)//ig;

                    my $Output;
                    if ( $Item->{Block} ) {
                        $LayoutObject->Block(
                            Name => $Item->{Block},
                            Data => $Item,
                        );
                        $Output = $LayoutObject->Output(
                            TemplateFile => 'AgentTicketOverviewSmall',
                            Data         => $Item,
                        );
                    }
                    else {
                        $Output = '<li id="'
                            . $Item->{ID}
                            . '"><a href="#" title="'
                            . $LayoutObject->{LanguageObject}->Translate( $Item->{Description} )
                            . '">'
                            . $LayoutObject->{LanguageObject}->Translate( $Item->{Name} )
                            . '</a></li>';
                    }

                    $Output =~ s/\n+//g;
                    $Output =~ s/\s+/ /g;
                    $Output =~ s/<\!--.+?-->//g;

                    push @ActionItems, {
                        HTML        => $Output,
                        ID          => $Item->{ID},
                        Link        => $LayoutObject->{Baselink} . $Item->{Link},
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

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'LinkPage',
        Value => $Param{LinkPage},
    );

    $LayoutObject->Block(
        Name => 'DocumentContent',
        Data => \%Param,
    );

    # array to save the column names to do the query
    my @Col = @{ $Self->{ColumnsEnabled} };

    # define special ticket columns
    my %SpecialColumns = (
        TicketNumber => 1,
        Owner        => 1,
        Responsible  => 1,
        CustomerID   => 1,
    );

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    $Param{OrderBy} = $Param{OrderBy} || 'Up';

    my $TicketData = scalar @ArticleBox;
    if ($TicketData) {

        $LayoutObject->Block( Name => 'OverviewTable' );
        $LayoutObject->Block( Name => 'TableHeader' );

        if ($BulkFeature) {
            $LayoutObject->Block(
                Name => 'GeneralOverviewHeader',
            );
            $LayoutObject->Block(
                Name => 'BulkNavBar',
                Data => \%Param,
            );
        }

        # meta items
        my @TicketMetaItems = $LayoutObject->TicketMetaItemsCount();
        for my $Item (@TicketMetaItems) {

            $LayoutObject->Block(
                Name => 'GeneralOverviewHeader',
            );

            my $CSS     = '';
            my $OrderBy = $Param{OrderBy};
            my $Link;
            my $Title = $LayoutObject->{LanguageObject}->Translate($Item);

            if ( $Param{SortBy} && ( $Param{SortBy} eq $Item ) ) {
                my $TitleDesc;

                # Change order for sorting column.
                $OrderBy = $OrderBy eq 'Up' ? 'Down' : 'Up';

                if ( $OrderBy eq 'Down' ) {
                    $CSS .= ' SortAscendingLarge';
                    $TitleDesc = Translatable('sorted ascending');
                }
                else {
                    $CSS .= ' SortDescendingLarge';
                    $TitleDesc = Translatable('sorted descending');
                }

                $TitleDesc = $LayoutObject->{LanguageObject}->Translate($TitleDesc);
                $Title .= ', ' . $TitleDesc;
            }

            $LayoutObject->Block(
                Name => 'OverviewNavBarPageFlag',
                Data => {
                    CSS   => $CSS,
                    Title => $Title,
                },
            );

            if ( $Item eq 'New Article' ) {
                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageFlagEmpty',
                    Data => {
                        Name => $Item,
                    }
                );
            }
            else {
                $LayoutObject->Block(
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

        my $CSS = '';

        # show special ticket columns, if needed
        COLUMN:
        for my $Column (@Col) {

            $LayoutObject->Block(
                Name => 'GeneralOverviewHeader',
            );

            $CSS = $Column;
            my $Title   = $LayoutObject->{LanguageObject}->Translate($Column);
            my $OrderBy = $Param{OrderBy};

            # output overall block so TicketNumber as well as other columns can be ordered
            $LayoutObject->Block(
                Name => 'OverviewNavBarPageTicketHeader',
                Data => {},
            );

            if ( $SpecialColumns{$Column} ) {

                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    my $TitleDesc;

                    # Change order for sorting column.
                    $OrderBy = $OrderBy eq 'Up' ? 'Down' : 'Up';

                    if ( $OrderBy eq 'Down' ) {
                        $CSS .= ' SortAscendingLarge';
                        $TitleDesc = Translatable('sorted ascending');
                    }
                    else {
                        $CSS .= ' SortDescendingLarge';
                        $TitleDesc = Translatable('sorted descending');
                    }

                    $TitleDesc = $LayoutObject->{LanguageObject}->Translate($TitleDesc);
                    $Title .= ', ' . $TitleDesc;
                }

                # translate the column name to write it in the current language
                my $TranslatedWord;
                if ( $Column eq 'CustomerID' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Customer ID');
                }
                else {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate($Column);
                }

                my $FilterTitle     = $TranslatedWord;
                my $FilterTitleDesc = Translatable('filter not active');
                if (
                    $Self->{StoredFilters} &&
                    (
                        $Self->{StoredFilters}->{$Column} ||
                        $Self->{StoredFilters}->{ $Column . 'IDs' }
                    )
                    )
                {
                    $CSS .= ' FilterActive';
                    $FilterTitleDesc = Translatable('filter active');
                }
                $FilterTitleDesc = $LayoutObject->{LanguageObject}->Translate($FilterTitleDesc);
                $FilterTitle .= ', ' . $FilterTitleDesc;

                $LayoutObject->Block(
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
                    if ( $Column eq 'CustomerID' || $Column eq 'Owner' || $Column eq 'Responsible' ) {
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

                    $LayoutObject->Block(
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

                        $LayoutObject->Block(
                            Name =>
                                'ContentLargeTicketGenericHeaderColumnFilterLinkCustomerIDSearch',
                            Data => {},
                        );

                        # send data to JS
                        $LayoutObject->AddJSData(
                            Key   => 'CustomerIDAutocomplete',
                            Value => {
                                'QueryDelay'          => 100,
                                'MaxResultsDisplayed' => 20,
                                'MinQueryLength'      => 2,
                            },
                        );
                    }
                    elsif ( $Column eq 'Owner' || $Column eq 'Responsible' ) {

                        $LayoutObject->Block(
                            Name => 'ContentLargeTicketGenericHeaderColumnFilterLinkUserSearch',
                            Data => {},
                        );

                        # send data to JS
                        $LayoutObject->AddJSData(
                            Key   => 'UserAutocomplete',
                            Value => {
                                'QueryDelay'          => 100,
                                'MaxResultsDisplayed' => 20,
                                'MinQueryLength'      => 2,
                            },
                        );
                    }

                }

                # verify if column is filterable
                elsif ( $Self->{ValidFilterableColumns}->{$Column} ) {

                    # variable to save the filter's HTML code
                    my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                        ColumnName    => $Column,
                        Label         => $Column,
                        ColumnValues  => $ColumnValues->{$Column},
                        SelectedValue => $Param{GetColumnFilter}->{$Column} || '',
                    );

                    $LayoutObject->Block(
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
                    $LayoutObject->Block(
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
                    $LayoutObject->Block(
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
                    my $TitleDesc;

                    # Change order for sorting column.
                    $OrderBy = $OrderBy eq 'Up' ? 'Down' : 'Up';

                    if ( $OrderBy eq 'Down' ) {
                        $CSS .= ' SortAscendingLarge';
                        $TitleDesc = Translatable('sorted ascending');
                    }
                    else {
                        $CSS .= ' SortDescendingLarge';
                        $TitleDesc = Translatable('sorted descending');
                    }

                    $TitleDesc = $LayoutObject->{LanguageObject}->Translate($TitleDesc);
                    $Title .= ', ' . $TitleDesc;
                }

                # translate the column name to write it in the current language
                my $TranslatedWord;
                if ( $Column eq 'EscalationTime' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Service Time');
                }
                elsif ( $Column eq 'EscalationResponseTime' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('First Response Time');
                }
                elsif ( $Column eq 'EscalationSolutionTime' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Solution Time');
                }
                elsif ( $Column eq 'EscalationUpdateTime' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Update Time');
                }
                elsif ( $Column eq 'PendingTime' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Pending till');
                }
                elsif ( $Column eq 'CustomerCompanyName' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Customer Name');
                }
                elsif ( $Column eq 'CustomerName' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Customer User Name');
                }
                elsif ( $Column eq 'CustomerUserID' ) {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate('Customer User ID');
                }
                else {
                    $TranslatedWord = $LayoutObject->{LanguageObject}->Translate($Column);
                }

                my $FilterTitle     = $TranslatedWord;
                my $FilterTitleDesc = Translatable('filter not active');
                if ( $Self->{StoredFilters} && $Self->{StoredFilters}->{ $Column . 'IDs' } ) {
                    $CSS .= ' FilterActive';
                    $FilterTitleDesc = Translatable('filter active');
                }
                $FilterTitleDesc = $LayoutObject->{LanguageObject}->Translate($FilterTitleDesc);
                $FilterTitle .= ', ' . $FilterTitleDesc;

                $LayoutObject->Block(
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

                    # variable to save the filter's HTML code
                    my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                        ColumnName    => $Column,
                        Label         => $Column,
                        ColumnValues  => $ColumnValues->{$Column},
                        SelectedValue => $Param{GetColumnFilter}->{$Column} || '',
                    );

                    $LayoutObject->Block(
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
                }

                # verify if column is just filterable
                elsif ( $Self->{ValidFilterableColumns}->{$Column} ) {

                    my $Css;
                    if ( $Column eq 'CustomerUserID' ) {
                        $Css = 'Hidden';
                    }

                    # variable to save the filter's HTML code
                    my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                        ColumnName    => $Column,
                        Label         => $Column,
                        ColumnValues  => $ColumnValues->{$Column},
                        SelectedValue => $Param{GetColumnFilter}->{$Column} || '',
                        Css           => $Css,
                    );
                    $LayoutObject->Block(
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

                        $LayoutObject->Block(
                            Name =>
                                'ContentLargeTicketGenericHeaderColumnFilterLinkCustomerUserSearch',
                            Data => {},
                        );

                        # send data to JS
                        $LayoutObject->AddJSData(
                            Key   => 'CustomerUserAutocomplete',
                            Value => {
                                'QueryDelay'          => 100,
                                'MaxResultsDisplayed' => 20,
                                'MinQueryLength'      => 2,
                            },
                        );
                    }
                }

                # verify if column is sortable
                elsif ( $Self->{ValidSortableColumns}->{$Column} ) {
                    $LayoutObject->Block(
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
                    $LayoutObject->Block(
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
                my $IsSortable = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsSortable',
                );

                if ($IsSortable) {
                    my $CSS = 'DynamicField_' . $DynamicFieldConfig->{Name};
                    if (
                        $Param{SortBy}
                        && ( $Param{SortBy} eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                        )
                    {
                        my $TitleDesc;

                        # Change order for sorting column.
                        $OrderBy = $OrderBy eq 'Up' ? 'Down' : 'Up';

                        if ( $OrderBy eq 'Down' ) {
                            $CSS .= ' SortAscendingLarge';
                            $TitleDesc = Translatable('sorted ascending');
                        }
                        else {
                            $CSS .= ' SortDescendingLarge';
                            $TitleDesc = Translatable('sorted descending');
                        }

                        $TitleDesc = $LayoutObject->{LanguageObject}->Translate($TitleDesc);
                        $Title .= ', ' . $TitleDesc;
                    }

                    my $FilterTitleDesc = Translatable('filter not active');
                    if ( $Self->{StoredFilters} && $Self->{StoredFilters}->{$Column} ) {
                        $CSS .= ' FilterActive';
                        $FilterTitleDesc = Translatable('filter active');
                    }
                    $FilterTitleDesc = $LayoutObject->{LanguageObject}->Translate($FilterTitleDesc);
                    $FilterTitle .= ', ' . $FilterTitleDesc;

                    $LayoutObject->Block(
                        Name => 'OverviewNavBarPageDynamicField',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    my $DynamicFieldName = 'DynamicField_' . $DynamicFieldConfig->{Name};

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's HTML code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $LayoutObject->Block(
                            Name => 'OverviewNavBarPageDynamicFieldFiltrableSortable',
                            Data => {
                                %Param,
                                OrderBy          => $OrderBy,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                ColumnFilterStrg => $ColumnFilterHTML,
                                Title            => $Title,
                                FilterTitle      => $FilterTitle,
                            },
                        );
                    }

                    else {
                        $LayoutObject->Block(
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
                    $LayoutObject->Block(
                        Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's HTML code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $LayoutObject->Block(
                            Name => 'OverviewNavBarPageDynamicField'
                                . $DynamicFieldConfig->{Name}
                                . '_FiltrableSortable',
                            Data => {
                                %Param,
                                OrderBy          => $OrderBy,
                                Label            => $Label,
                                DynamicFieldName => $DynamicFieldConfig->{Name},
                                ColumnFilterStrg => $ColumnFilterHTML,
                                Title            => $Title,
                            },
                        );
                    }
                    else {
                        $LayoutObject->Block(
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

                    my $DynamicFieldName = 'DynamicField_' . $DynamicFieldConfig->{Name};
                    my $CSS              = $DynamicFieldName;

                    $LayoutObject->Block(
                        Name => 'OverviewNavBarPageDynamicField',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's HTML code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $LayoutObject->Block(
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
                        $LayoutObject->Block(
                            Name => 'OverviewNavBarPageDynamicFieldNotSortable',
                            Data => {
                                %Param,
                                Label => $Label,
                                Title => $Title,
                            },
                        );
                    }

                    # example of dynamic fields order customization
                    $LayoutObject->Block(
                        Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                        Data => {
                            %Param,
                        },
                    );

                    if ( $Self->{ValidFilterableColumns}->{$DynamicFieldName} ) {

                        # variable to save the filter's HTML code
                        my $ColumnFilterHTML = $Self->_InitialColumnFilter(
                            ColumnName    => $DynamicFieldName,
                            Label         => $Label,
                            ColumnValues  => $ColumnValues->{$DynamicFieldName},
                            SelectedValue => $Param{GetColumnFilter}->{$DynamicFieldName} || '',
                        );

                        $LayoutObject->Block(
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
                        $LayoutObject->Block(
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

        $LayoutObject->Block( Name => 'TableBody' );

    }
    else {
        $LayoutObject->Block( Name => 'NoTicketFound' );
    }

    my %ActionRowTickets;

    for my $ArticleRef (@ArticleBox) {

        # get last customer article
        my %Article = %{$ArticleRef};

        # escalation human times
        if ( $Article{EscalationTime} ) {
            $Article{EscalationTimeHuman} = $LayoutObject->CustomerAge(
                Age                => $Article{EscalationTime},
                TimeShowAlwaysLong => 1,
                Space              => ' ',
            );
            $Article{EscalationTimeWorkingTime} = $LayoutObject->CustomerAge(
                Age                => $Article{EscalationTimeWorkingTime},
                TimeShowAlwaysLong => 1,
                Space              => ' ',
            );
        }

        # customer info
        my %CustomerInfo;
        if ( $Param{Config}->{CustomerInfo} ) {
            if ( $Article{CustomerUserID} ) {

                # get customer user object
                my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

                $Article{CustomerName} = $CustomerUserObject->CustomerName(
                    UserLogin => $Article{CustomerUserID},
                );

                %CustomerInfo = $CustomerUserObject->CustomerUserDataGet(
                    User => $Article{CustomerUserID},
                );

                INFOKEY:
                for my $InfoKey ( sort keys %CustomerInfo ) {
                    next INFOKEY if $InfoKey =~ m{\ACustomer}xms;

                    $CustomerInfo{ 'Customer' . $InfoKey } = $CustomerInfo{$InfoKey};
                }
            }
        }

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # user info
        my %UserInfo = $UserObject->GetUserData(
            UserID => $Article{OwnerID},
        );

        # Responsible info.
        my %ResponsibleInfo = $UserObject->GetUserData(
            UserID => $Article{ResponsibleID},
        );
        $UserInfo{ResponsibleInfo} = \%ResponsibleInfo;

        $LayoutObject->Block(
            Name => 'Record',
            Data => { %Article, %UserInfo },
        );

        # check if bulk feature is enabled
        if ($BulkFeature) {
            $LayoutObject->Block(
                Name => 'GeneralOverviewRow',
            );
            $LayoutObject->Block(
                Name => Translatable('Bulk'),
                Data => { %Article, %UserInfo },
            );
        }

        # show ticket flags
        my @TicketMetaItems = $LayoutObject->TicketMetaItems(
            Ticket => \%Article,
        );
        for my $Item (@TicketMetaItems) {
            $LayoutObject->Block(
                Name => 'GeneralOverviewRow',
            );
            $LayoutObject->Block(
                Name => 'ContentLargeTicketGenericRowMeta',
                Data => $Item,
            );
            if ($Item) {
                $LayoutObject->Block(
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
            $LayoutObject->Block(
                Name => 'GeneralOverviewRow',
            );
            if ( $TicketColumn !~ m{\A DynamicField_}xms ) {
                $LayoutObject->Block(
                    Name => 'RecordTicketData',
                    Data => {},
                );

                if ( $SpecialColumns{$TicketColumn} ) {
                    $LayoutObject->Block(
                        Name => 'Record' . $TicketColumn,
                        Data => { %Article, %UserInfo },
                    );

                    next TICKETCOLUMN;
                }

                if ( $TicketColumn eq 'CreatedBy' ) {

                    my %TicketCreatedByInfo = $UserObject->GetUserData(
                        UserID => $Article{CreateBy},
                    );

                    $LayoutObject->Block(
                        Name => 'RecordTicketCreatedBy',
                        Data => \%TicketCreatedByInfo,
                    );
                    next TICKETCOLUMN;
                }

                # escalation column
                my %EscalationData;
                if ( $TicketColumn eq 'EscalationTime' ) {
                    $EscalationData{EscalationTime}            = $Article{EscalationTime};
                    $EscalationData{EscalationDestinationDate} = $Article{EscalationDestinationDate};

                    $EscalationData{EscalationTimeHuman} = $LayoutObject->CustomerAge(
                        Age                => $EscalationData{EscalationTime},
                        TimeShowAlwaysLong => 1,
                        Space              => ' ',
                    ) || '-';
                    $EscalationData{EscalationTimeWorkingTime} = $LayoutObject->CustomerAge(
                        Age                => $EscalationData{EscalationTimeWorkingTime},
                        TimeShowAlwaysLong => 1,
                        Space              => ' ',
                    );
                    if (
                        defined $Article{EscalationTime}
                        && $Article{EscalationTime} < 60 * 60 * 1
                        )
                    {
                        $EscalationData{EscalationClass} = 'Warning';
                    }
                    $LayoutObject->Block(
                        Name => 'RecordEscalationTime',
                        Data => {%EscalationData},
                    );
                    next TICKETCOLUMN;
                }

                my $BlockType = '';
                my $CSSClass  = '';
                if ( $TicketColumn eq 'EscalationSolutionTime' ) {
                    $BlockType = 'Escalation';
                    $DataValue = $LayoutObject->CustomerAge(
                        Age                => $Article{SolutionTime} || 0,
                        TimeShowAlwaysLong => 1,
                        Space              => ' ',
                    );
                    if ( defined $Article{SolutionTime} && $Article{SolutionTime} < 60 * 60 * 1 ) {
                        $CSSClass = 'Warning';
                    }
                }
                elsif ( $TicketColumn eq 'EscalationResponseTime' ) {
                    $BlockType = 'Escalation';
                    $DataValue = $LayoutObject->CustomerAge(
                        Age                => $Article{FirstResponseTime} || 0,
                        TimeShowAlwaysLong => 1,
                        Space              => ' ',
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
                    $DataValue = $LayoutObject->CustomerAge(
                        Age                => $Article{UpdateTime} || 0,
                        TimeShowAlwaysLong => 1,
                        Space              => ' ',
                    );
                    if ( defined $Article{UpdateTime} && $Article{UpdateTime} < 60 * 60 * 1 ) {
                        $CSSClass = 'Warning';
                    }
                }
                elsif ( $TicketColumn eq 'PendingTime' ) {
                    $BlockType = 'Escalation';
                    $DataValue = $LayoutObject->CustomerAge(
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
                elsif ( $TicketColumn eq 'Created' || $TicketColumn eq 'Changed' ) {
                    $BlockType = 'Time';
                    $DataValue = $Article{$TicketColumn} || $UserInfo{$TicketColumn};
                }
                elsif ( $TicketColumn eq 'Responsible' ) {

                    my %ResponsibleInfo = $UserObject->GetUserData(
                        UserID => $Article{ResponsibleID},
                    );

                    $DataValue = $ResponsibleInfo{'UserFullname'};
                }
                else {
                    $DataValue = $Article{$TicketColumn}
                        || $UserInfo{$TicketColumn}
                        || $CustomerInfo{$TicketColumn};

                    # If value is in date format, change block type to 'Time' so it can be localized. See bug#14542.
                    if (
                        defined $DataValue
                        && $DataValue =~ /^\d\d\d\d-(\d|\d\d)-(\d|\d\d)\s(\d|\d\d):(\d|\d\d):(\d|\d\d)/
                        )
                    {
                        $BlockType = 'Time';
                    }
                }

                $LayoutObject->Block(
                    Name => "RecordTicketColumn$BlockType",
                    Data => {
                        GenericValue => $DataValue || '-',
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
                my $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $Article{TicketID},
                );

                my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Value,
                    ValueMaxChars      => 20,
                    LayoutObject       => $LayoutObject,
                );

                $LayoutObject->Block(
                    Name => 'RecordDynamicField',
                    Data => {
                        Value => $ValueStrg->{Value},
                        Title => $ValueStrg->{Title},
                    },
                );

                if ( $ValueStrg->{Link} ) {
                    $LayoutObject->Block(
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
                    $LayoutObject->Block(
                        Name => 'RecordDynamicFieldPlain',
                        Data => {
                            Value => $ValueStrg->{Value},
                            Title => $ValueStrg->{Title},
                        },
                    );
                }

                # example of dynamic fields order customization
                $LayoutObject->Block(
                    Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        Value => $ValueStrg->{Value},
                        Title => $ValueStrg->{Title},
                    },
                );

                if ( $ValueStrg->{Link} ) {
                    $LayoutObject->Block(
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
                    $LayoutObject->Block(
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

            # replace TT directives from string with values
            for my $ActionItem ( @{ $Article{ActionItems} } ) {
                $ActionItem->{Link} = $LayoutObject->Output(
                    Template => $ActionItem->{Link},
                    Data     => {
                        TicketID => $Article{TicketID},
                    },
                );
            }

            $ActionRowTickets{ $Article{TicketID} } = $LayoutObject->JSONEncode( Data => $Article{ActionItems} );
        }
    }

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'ActionRowTickets',
        Value => \%ActionRowTickets,
    );

    # set column filter form, to correctly fill the column filters is necessary to pass each
    #    overview some information in the AJAX call, for example the fixed Filters or NavBarFilters
    #    and also other values like the Queue in AgentTicketQueue, otherwise the filters will be
    #    filled with default restrictions, resulting in more options than the ones that the
    #    available tickets should provide, see Bug#9902
    if ( IsHashRefWithData( $Param{ColumnFilterForm} ) ) {
        $LayoutObject->Block(
            Name => 'DocumentColumnFilterForm',
            Data => {},
        );

        # Add UseSubQueues param if available.
        if ( $Param{UseSubQueues} ) {
            $Param{ColumnFilterForm}->{UseSubQueues} = $Param{UseSubQueues};
        }

        for my $Element ( sort keys %{ $Param{ColumnFilterForm} } ) {
            $LayoutObject->Block(
                Name => 'DocumentColumnFilterFormElement',
                Data => {
                    ElementName  => $Element,
                    ElementValue => $Param{ColumnFilterForm}->{$Element},
                },
            );
        }
    }

    # use template
    my $Output = $LayoutObject->Output(
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
        $ColumnFilterValues{$HeaderColumn} = $Kernel::OM->Get('Kernel::System::Ticket::ColumnFilter')->$FunctionName(
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

            # get dynamic field backend object
            my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
            my $IsFiltrable               = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsFiltrable',
            );
            next DYNAMICFIELD if !$IsFiltrable;
            $Self->{ValidFilterableColumns}->{$HeaderColumn} = $IsFiltrable;
            if ( IsArrayRefWithData($TicketIDs) ) {

                # get the historical values for the field
                $ColumnFilterValues{$HeaderColumn} = $DynamicFieldBackendObject->ColumnFilterValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    LayoutObject       => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
                    TicketIDs          => $TicketIDs,
                );
            }
            else {

                # get PossibleValues
                $ColumnFilterValues{$HeaderColumn} = $DynamicFieldBackendObject->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );
            }
            last DYNAMICFIELD;
        }
    }

    return \%ColumnFilterValues;
}

sub _InitialColumnFilter {
    my ( $Self, %Param ) = @_;

    return if !$Param{ColumnName};
    return if !$Self->{ValidFilterableColumns}->{ $Param{ColumnName} };

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Label = $Param{Label} || $Param{ColumnName};
    $Label = $LayoutObject->{LanguageObject}->Translate($Label);

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
    my $ColumnFilterHTML = $LayoutObject->BuildSelection(
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
    elsif ( $HeaderColumn eq 'CustomerID' ) {
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

    # variable to save the filter's HTML code
    my $ColumnFilterJSON = $Self->_ColumnFilterJSON(
        ColumnName    => $HeaderColumn,
        Label         => $LabelColumn,
        ColumnValues  => $ColumnValues->{$HeaderColumn},
        SelectedValue => $SelectedValue,
    );

    return $ColumnFilterJSON;
}

# =head2 _ColumnFilterJSON()

#     creates a JSON select filter for column header

#     my $ColumnFilterJSON = $TicketOverviewSmallObject->_ColumnFilterJSON(
#         ColumnName => 'Queue',
#         Label      => 'Queue',
#         ColumnValues => {
#             1 => 'PostMaster',
#             2 => 'Junk',
#         },
#         SelectedValue '1',
#     );

# =cut

sub _ColumnFilterJSON {
    my ( $Self, %Param ) = @_;

    if (
        !$Self->{AvailableFilterableColumns}->{ $Param{ColumnName} } &&
        !$Self->{AvailableFilterableColumns}->{ $Param{ColumnName} . 'IDs' }
        )
    {
        return;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Label = $Param{Label};
    $Label =~ s{ \A DynamicField_ }{}gxms;
    $Label = $LayoutObject->{LanguageObject}->Translate($Label);

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

        # Keys must be link encoded for dynamic fields because they are added to URL during filtering
        # and can contain characters like '&', ';', etc.
        # See bug#14497 - https://bugs.otrs.org/show_bug.cgi?id=14497.
        my $Encoding = ( $Param{ColumnName} =~ m/^DynamicField_/ ) ? 1 : 0;

        # Set possible values.
        for my $ValueKey ( sort { lc $Values{$a} cmp lc $Values{$b} } keys %Values ) {
            push @{$Data}, {
                Key   => $Encoding ? $LayoutObject->LinkEncode($ValueKey) : $ValueKey,
                Value => $Values{$ValueKey},
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
    my $JSON = $LayoutObject->BuildSelectionJSON(
        [
            {
                Name         => 'ColumnFilter' . $Param{ColumnName},
                Data         => $Data,
                Class        => 'ColumnFilter',
                Sort         => 'AlphanumericKey',
                TreeView     => 1,
                SelectedID   => $Param{SelectedValue},
                Translation  => $TranslationOption,
                AutoComplete => 'off',
            },
        ],
    );

    return $JSON;
}

sub _DefaultColumnSort {

    my %DefaultColumns = (
        TicketNumber           => 100,
        Age                    => 110,
        Changed                => 111,
        PendingTime            => 112,
        EscalationTime         => 113,
        EscalationSolutionTime => 114,
        EscalationResponseTime => 115,
        EscalationUpdateTime   => 116,
        Sender                 => 120,
        Title                  => 122,
        Subject                => 124,
        State                  => 130,
        Lock                   => 140,
        Queue                  => 150,
        Owner                  => 160,
        Responsible            => 161,
        CustomerID             => 170,
        CustomerName           => 171,
        CustomerUserID         => 172,
        Type                   => 180,
        Service                => 191,
        SLA                    => 192,
        Priority               => 193,
    );

    # dynamic fields can not be on the DefaultColumns sorting hash
    # when comparing 2 dynamic fields sorting must be alphabetical
    if ( !$DefaultColumns{$a} && !$DefaultColumns{$b} ) {
        return $a cmp $b;
    }

    # when a dynamic field is compared to a ticket attribute it must be higher
    elsif ( !$DefaultColumns{$a} ) {
        return 1;
    }

    # when a ticket attribute is compared to a dynamic field it must be lower
    elsif ( !$DefaultColumns{$b} ) {
        return -1;
    }

    # otherwise do a numerical comparison with the ticket attributes
    return $DefaultColumns{$a} <=> $DefaultColumns{$b};
}

1;
