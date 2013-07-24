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

use Kernel::System::CustomerUser;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
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

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    $Self->{SmallViewColumnHeader}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::OverviewSmall')->{ColumnHeader};

    # get dynamic field config for frontend module
    $Self->{DynamicFieldFilter}
        = $Self->{ConfigObject}->Get("Ticket::Frontend::OverviewSmall")->{DynamicField};

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

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

    $Self->{LayoutObject}->Block(
        Name => 'DocumentContent',
        Data => \%Param,
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

            if ( $Param{SortBy} && ( $Param{SortBy} eq $Item ) ) {
                if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                    $OrderBy = 'Down';
                    $CSS .= ' SortAscending';
                }
                else {
                    $OrderBy = 'Up';
                    $CSS .= ' SortDescending';
                }
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
                    },
                );
            }

        }

        my @Col = (qw(TicketNumber Age State Lock Queue Owner CustomerID));

        # show escalation
        if ( $Param{Escalation} ) {
            push @Col, 'EscalationTime';
        }

        # check if last customer subject or ticket title should be shown
        if ( $Self->{SmallViewColumnHeader} eq 'LastCustomerSubject' ) {
            push @Col, 'LastCustomerSubject';
        }
        elsif ( $Self->{SmallViewColumnHeader} eq 'TicketTitle' ) {
            push @Col, 'Title';
        }

        for my $Key (@Col) {
            my $CSS = '';
            my $OrderBy;
            if ( $Param{SortBy} && ( $Param{SortBy} eq $Key ) ) {
                if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                    $OrderBy = 'Down';
                    $CSS .= ' SortAscending';
                }
                else {
                    $OrderBy = 'Up';
                    $CSS .= ' SortDescending';
                }
            }

            $Self->{LayoutObject}->Block(
                Name => 'OverviewNavBarPage' . $Key,
                Data => {
                    %Param,
                    OrderBy => $OrderBy,
                    CSS     => $CSS,
                },
            );
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
                my $OrderBy;
                if (
                    $Param{SortBy}
                    && ( $Param{SortBy} eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                    )
                {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
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

        # show escalation
        if ( $Param{Escalation} ) {
            if ( $Article{EscalationTime} < 60 * 60 * 1 ) {
                $Article{EscalationClass} = 'Warning';
            }
            $Self->{LayoutObject}->Block(
                Name => 'RecordEscalationTime',
                Data => { %Article, %UserInfo },
            );
        }

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

        # Dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

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

1;
