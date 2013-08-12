# --
# Kernel/Modules/CustomerTicketOverview.pm - status for all open tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketOverview;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::User;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{AgentUserObject}    = Kernel::System::User->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # all static variables
    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('Ticket::ViewableSenderTypes')
        || $Self->{LayoutObject}->FatalError(
        Message => 'No Config entry "Ticket::ViewableSenderTypes"!'
        );

    $Self->{SmallViewColumnHeader}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketOverview')->{ColumnHeader};

    $Self->{Owner}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketOverview')->{Owner};

    $Self->{Queue}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketOverview')->{Queue};

    # get dynamic field config for frontend module
    $Self->{DynamicFieldFilter}
        = $Self->{ConfigObject}->Get("Ticket::Frontend::CustomerTicketOverview")->{DynamicField};

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $Self->{DynamicField} = \@CustomerDynamicFields;

    # get params
    $Self->{Filter}  = $Self->{ParamObject}->GetParam( Param => 'Filter' )  || 'Open';
    $Self->{SortBy}  = $Self->{ParamObject}->GetParam( Param => 'SortBy' )  || 'Age';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' ) || 'Down';
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{PageShown} = $Self->{UserShowTickets} || 1;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check subaction
    if ( !$Self->{Subaction} ) {
        return $Self->{LayoutObject}->Redirect(
            OP => 'Action=CustomerTicketOverview;Subaction=MyTickets',
        );
    }

    # check needed CustomerID
    if ( !$Self->{UserCustomerID} ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError( Message => 'Need CustomerID!!!' );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # filter definition
    my %Filters = (
        MyTickets => {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    CustomerUserLogin => $Self->{UserID},
                    OrderBy           => $Self->{OrderBy},
                    SortBy            => $Self->{SortBy},
                    CustomerUserID    => $Self->{UserID},
                    Permission        => 'ro',
                },
            },
            Open => {
                Name   => 'Open',
                Prio   => 1100,
                Search => {
                    CustomerUserLogin => $Self->{UserID},
                    StateType         => 'Open',
                    OrderBy           => $Self->{OrderBy},
                    SortBy            => $Self->{SortBy},
                    CustomerUserID    => $Self->{UserID},
                    Permission        => 'ro',
                },
            },
            Closed => {
                Name   => 'Closed',
                Prio   => 1200,
                Search => {
                    CustomerUserLogin => $Self->{UserID},
                    StateType         => 'Closed',
                    OrderBy           => $Self->{OrderBy},
                    SortBy            => $Self->{SortBy},
                    CustomerUserID    => $Self->{UserID},
                    Permission        => 'ro',
                },
            },
        },
        CompanyTickets => {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    CustomerID =>
                        [ $Self->{UserObject}->CustomerIDs( User => $Self->{UserLogin} ) ],
                    OrderBy        => $Self->{OrderBy},
                    SortBy         => $Self->{SortBy},
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
            Open => {
                Name   => 'Open',
                Prio   => 1100,
                Search => {
                    CustomerID =>
                        [ $Self->{UserObject}->CustomerIDs( User => $Self->{UserLogin} ) ],
                    StateType      => 'Open',
                    OrderBy        => $Self->{OrderBy},
                    SortBy         => $Self->{SortBy},
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
            Closed => {
                Name   => 'Closed',
                Prio   => 1200,
                Search => {
                    CustomerID =>
                        [ $Self->{UserObject}->CustomerIDs( User => $Self->{UserLogin} ) ],
                    StateType      => 'Closed',
                    OrderBy        => $Self->{OrderBy},
                    SortBy         => $Self->{SortBy},
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Subaction} }->{ $Self->{Filter} } ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => "Invalid Filter: $Self->{Filter}!",
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check if archive search is allowed, otherwise search for all tickets
    my %SearchInArchive;
    if (
        $Self->{ConfigObject}->Get('Ticket::ArchiveSystem')
        && !$Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem')
        )
    {
        $SearchInArchive{ArchiveFlags} = [ 'y', 'n' ];
    }

    my %NavBarFilter;
    my $Counter         = 0;
    my $AllTickets      = 0;
    my $AllTicketsTotal = 0;
    for my $Filter ( sort keys %{ $Filters{ $Self->{Subaction} } } ) {
        $Counter++;
        my $Count = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{$Filter}->{Search} },
            %SearchInArchive,
            Result => 'COUNT',
        );

        my $ClassLI = '';
        my $ClassA  = '';
        if ( $Filter eq $Self->{Filter} ) {
            $ClassA     = 'Selected';
            $AllTickets = $Count;
        }
        my $CounterTotal = keys %{ $Filters{ $Self->{Subaction} } };
        if ( $CounterTotal eq $Counter ) {
            $ClassLI = 'Last';
        }
        if ( $Filter eq 'All' ) {
            $AllTicketsTotal = $Count;
        }
        $NavBarFilter{ $Filters{ $Self->{Subaction} }->{$Filter}->{Prio} } = {
            %{ $Filters{ $Self->{Subaction} }->{$Filter} },
            Count   => $Count,
            Filter  => $Filter,
            ClassA  => $ClassA,
            ClassLI => $ClassLI,
        };
    }

    if ( !$AllTicketsTotal ) {
        $Self->{LayoutObject}->Block(
            Name => 'Empty',
        );

        my $CustomTexts
            = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketOverviewCustomEmptyText');

        if ( ref $CustomTexts eq 'HASH' ) {
            $Self->{LayoutObject}->Block(
                Name => 'EmptyCustom',
                Data => $CustomTexts,
            );

            # only show button, if frontend module for NewTicket is registered
            # and button text is configured
            if (
                ref $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{CustomerTicketMessage}
                eq 'HASH'
                && defined $Self->{ConfigObject}
                ->Get('Ticket::Frontend::CustomerTicketOverviewCustomEmptyText')->{Button}
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'EmptyCustomButton',
                    Data => $CustomTexts,
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'EmptyDefault',
            );

            # only show button, if frontend module for NewTicket is registered
            if (
                ref $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{CustomerTicketMessage}
                eq 'HASH'
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'EmptyDefaultButton',
                );
            }
        }
    }
    else {

        # create & return output
        my $Link = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
            . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
            . ';Filter=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
            . ';Subaction=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Subaction} )
            . ';';
        my %PageNav = $Self->{LayoutObject}->PageNavBar(
            Limit     => 10000,
            StartHit  => $Self->{StartHit},
            PageShown => $Self->{PageShown},
            AllHits   => $AllTickets,
            Action    => 'Action=CustomerTicketOverview',
            Link      => $Link,
            IDPrefix  => 'CustomerTicketOverview',
        );

        my $OrderBy = 'Down';
        if ( $Self->{OrderBy} eq 'Down' ) {
            $OrderBy = 'Up';
        }
        my $Sort       = '';
        my $StateSort  = '';
        my $TicketSort = '';
        my $TitleSort  = '';
        my $AgeSort    = '';
        my $QueueSort  = '';

        # this sets the opposit to the $OrderBy
        if ( $OrderBy eq 'Down' ) {
            $Sort = 'SortAscending';
        }
        if ( $OrderBy eq 'Up' ) {
            $Sort = 'SortDescending';
        }

        if ( $Self->{SortBy} eq 'State' ) {
            $StateSort = $Sort;
        }
        elsif ( $Self->{SortBy} eq 'Ticket' ) {
            $TicketSort = $Sort;
        }
        elsif ( $Self->{SortBy} eq 'Title' ) {
            $TitleSort = $Sort;
        }
        elsif ( $Self->{SortBy} eq 'Age' ) {
            $AgeSort = $Sort;
        }
        elsif ( $Self->{SortBy} eq 'Queue' ) {
            $QueueSort = $Sort;
        }
        $Self->{LayoutObject}->Block(
            Name => 'Filled',
            Data => {
                %Param,
                %PageNav,
                OrderBy    => $OrderBy,
                StateSort  => $StateSort,
                TicketSort => $TicketSort,
                TitleSort  => $TitleSort,
                AgeSort    => $AgeSort,
                Filter     => $Self->{Filter},
            },
        );

        if ( $Self->{Owner} ) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewNavBarPageOwner',
            );
        }

        if ( $Self->{Queue} ) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewNavBarPageQueue',
                Data => {
                    OrderBy   => $OrderBy,
                    QueueSort => $QueueSort,
                },
            );
        }

        # show header filter
        for my $Key ( sort keys %NavBarFilter ) {
            $Self->{LayoutObject}->Block(
                Name => 'FilterHeader',
                Data => {
                    %{ $NavBarFilter{$Key} },
                },
            );
        }

        # show footer filter - show only if more the one page is available
        if ( $AllTickets > $Self->{PageShown} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FilterFooter',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
        }
        for my $Key ( sort keys %NavBarFilter ) {
            if ( $AllTickets > $Self->{PageShown} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'FilterFooterItem',
                    Data => {
                        %{ $NavBarFilter{$Key} },
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

            # get field sortable condition
            my $IsSortable = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsSortable',
            );

            if ($IsSortable) {
                my $CSS = '';
                if (
                    $Self->{SortBy}
                    && ( $Self->{SortBy} eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                    )
                {
                    if ( $Self->{OrderBy} && ( $Self->{OrderBy} eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescending';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscending';
                    }
                }

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicField',
                    Data => {
                        %Param,
                        CSS => $CSS,
                    },
                );

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicFieldSortable',
                    Data => {
                        %Param,
                        OrderBy          => $OrderBy,
                        Label            => $Label,
                        DynamicFieldName => $DynamicFieldConfig->{Name},
                        Filter           => $Self->{Filter},
                    },
                );

                # example of dynamic fields order customization
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        %Param,
                        CSS => $CSS,
                    },
                );

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . '_Sortable',
                    Data => {
                        %Param,
                        OrderBy          => $OrderBy,
                        Label            => $Label,
                        DynamicFieldName => $DynamicFieldConfig->{Name},
                        Filter           => $Self->{Filter},
                    },
                );
            }
            else {

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicField',
                    Data => {
                        %Param,
                    },
                );

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicFieldNotSortable',
                    Data => {
                        %Param,
                        Label => $Label,
                    },
                );

                # example of dynamic fields order customization
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        %Param,
                    },
                );

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewNavBarPageDynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . '_NotSortable',
                    Data => {
                        %Param,
                        Label => $Label,
                    },
                );
            }
        }

        my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{ $Self->{Filter} }->{Search} },
            %SearchInArchive,
            Result => 'ARRAY',
            Limit  => 1_000,
        );

        # show tickets
        $Counter = 0;
        for my $TicketID (@ViewableTickets) {
            $Counter++;
            if (
                $Counter >= $Self->{StartHit}
                && $Counter < ( $Self->{PageShown} + $Self->{StartHit} )
                )
            {
                $Self->ShowTicketStatus( TicketID => $TicketID );
            }
        }
    }

    # create & return output
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Title   => $Self->{Subaction},
        Refresh => $Refresh,
    );

    # build NavigationBar
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketOverview',
        Data         => \%Param,
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    # return page
    return $Output;
}

# ShowTicket
sub ShowTicketStatus {
    my ( $Self, %Param ) = @_;

    my $TicketID = $Param{TicketID} || return;

    # contains last article (non-internal)
    my %Article;

    # get whole article index
    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex( TicketID => $Param{TicketID} );

    # get article data
    if (@ArticleIDs) {
        my %LastNonInternalArticle;

        ARTICLEID:
        for my $ArticleID ( reverse @ArticleIDs ) {
            my %CurrentArticle = $Self->{TicketObject}->ArticleGet( ArticleID => $ArticleID );

            # check for non-internal article
            next ARTICLEID if $CurrentArticle{ArticleType} =~ m{internal}smx;

            # check for customer article
            if ( $CurrentArticle{SenderType} eq 'customer' ) {
                %Article = %CurrentArticle;
                last ARTICLEID;
            }

            # check for last non-internal article (sender type does not matter)
            if ( !%LastNonInternalArticle ) {
                %LastNonInternalArticle = %CurrentArticle;
            }
        }

        if ( !%Article && %LastNonInternalArticle ) {
            %Article = %LastNonInternalArticle;
        }
    }

    my $NoArticle;
    if ( !%Article ) {
        $NoArticle = 1;
    }

    # get ticket info
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
    );

    my $Subject;

    # check if last customer subject or ticket title should be shown
    if ( $Self->{SmallViewColumnHeader} eq 'LastCustomerSubject' ) {
        $Subject = $Article{Subject} || '';
    }
    elsif ( $Self->{SmallViewColumnHeader} eq 'TicketTitle' ) {
        $Subject = $Ticket{Title};
    }

    # return ticket information if there is no article
    if ($NoArticle) {
        $Article{State}        = $Ticket{State};
        $Article{TicketNumber} = $Ticket{TicketNumber};
        $Article{CustomerAge}
            = $Self->{LayoutObject}->CustomerAge( Age => $Ticket{Age}, Space => ' ' ) || 0;
        $Article{Body}
            = $Self->{LayoutObject}->{LanguageObject}->Get('This item has no articles yet.');
    }

    # otherwise return article information
    else {
        $Article{CustomerAge}
            = $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' ) || 0;
    }

    # customer info (customer name)
    if ( $Article{CustomerUserID} ) {
        $Param{CustomerName}
            = $Self->{UserObject}->CustomerName( UserLogin => $Article{CustomerUserID}, );
        $Param{CustomerName} = '(' . $Param{CustomerName} . ')' if ( $Param{CustomerName} );
    }

    # if there is no subject try with Ticket title or set to Untitled
    if ( !$Subject ) {
        $Subject = $Ticket{Title} || 'Untitled!';
    }

    # condense down the subject
    $Subject = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject      => $Subject,
    );

    # add block
    $Self->{LayoutObject}->Block(
        Name => 'Record',
        Data => {
            %Article,
            %Ticket,
            Subject => $Subject,
            %Param,
        },
    );

    if ( $Self->{Owner} ) {
        my $OwnerName = $Self->{AgentUserObject}->UserName( UserID => $Ticket{OwnerID} );
        $Self->{LayoutObject}->Block(
            Name => 'RecordOwner',
            Data => {
                OwnerName => $OwnerName,
            },
        );
    }
    if ( $Self->{Queue} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RecordQueue',
            Data => {
                %Ticket,
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
            ObjectID           => $Ticket{TicketID},
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
            Name => 'RecordDynamicField' . $DynamicFieldConfig->{Name},
            Data => {
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );

        if ( $ValueStrg->{Link} ) {
            $Self->{LayoutObject}->Block(
                Name => 'RecordDynamicField' . $DynamicFieldConfig->{Name} . 'Link',
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
                Name => 'RecordDynamicField' . $DynamicFieldConfig->{Name} . 'Plain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }
    }
}

1;
