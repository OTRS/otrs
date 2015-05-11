# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ticket::OverviewPreview;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::SystemAddress',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::User',
    'Kernel::System::Ticket',
    'Kernel::System::Main',
    'Kernel::System::Queue',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = \%Param;
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

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
            GROUP:
            for my $Group (@Groups) {
                next GROUP if !$LayoutObject->{"UserIsGroup[$Group]"};
                if ( $LayoutObject->{"UserIsGroup[$Group]"} eq 'Yes' ) {
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
                Name => 'Bulk',
            },
        );
    }

    # run ticket overview document item menu modules
    if (
        $Param{Config}->{OverviewMenuModules}
        && ref $ConfigObject->Get('Ticket::Frontend::OverviewMenuModule') eq 'HASH'
        )
    {

        my %Menus = %{ $ConfigObject->Get('Ticket::Frontend::OverviewMenuModule') };
        MENUMODULE:
        for my $Menu ( sort keys %Menus ) {

            next MENUMODULE if !IsHashRefWithData( $Menus{$Menu} );
            next MENUMODULE if ( $Menus{$Menu}->{View} && $Menus{$Menu}->{View} ne $Param{View} );

            # load module
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Menus{$Menu}->{Module} ) ) {
                return $LayoutObject->FatalError();
            }
            my $Object = $Menus{$Menu}->{Module}->new( %{$Self} );

            # run module
            my $Item = $Object->Run(
                %Param,
                Config => $Menus{$Menu},
            );
            next MENUMODULE if !IsHashRefWithData($Item);

            if ( $Item->{Block} eq 'DocumentActionRowItem' ) {

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

                my $Link = $Item->{Link};
                if ( $Item->{Target} ) {
                    $Link = '#';
                }

                my $Class = '';
                if ( $Item->{PopupType} ) {
                    $Class = 'AsPopup PopupType_' . $Item->{PopupType};
                }

                $LayoutObject->Block(
                    Name => $Item->{Block},
                    Data => {
                        ID          => $Item->{ID},
                        Name        => $LayoutObject->{LanguageObject}->Translate( $Item->{Name} ),
                        Link        => $LayoutObject->{Baselink} . $Item->{Link},
                        Description => $Item->{Description},
                        Block       => $Item->{Block},
                        Class       => $Class,
                    },
                );
            }
            elsif ( $Item->{Block} eq 'DocumentActionRowHTML' ) {

                next MENUMODULE if !$Item->{HTML};

                $LayoutObject->Block(
                    Name => $Item->{Block},
                    Data => $Item,
                );
            }
        }
    }

    # init for table control
    $LayoutObject->Block(
        Name => 'DocumentReadyStart',
        Data => \%Param,
    );

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketOverviewPreview',
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
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
            GROUP:
            for my $Group (@Groups) {
                next GROUP if !$LayoutObject->{"UserIsGroup[$Group]"};
                if ( $LayoutObject->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                    $BulkFeature = 1;
                    last GROUP;
                }
            }
        }
    }

    $LayoutObject->Block(
        Name => 'DocumentHeader',
        Data => \%Param,
    );

    my $OutputMeta = $LayoutObject->Output(
        TemplateFile => 'AgentTicketOverviewPreview',
        Data         => \%Param,
    );
    my $OutputRaw = '';
    if ( !$Param{Output} ) {
        $LayoutObject->Print( Output => \$OutputMeta );
    }
    else {
        $OutputRaw .= $OutputMeta;
    }
    my $Output        = '';
    my $Counter       = 0;
    my $CounterOnSite = 0;
    my @TicketIDsShown;

    # check if there are tickets to show
    if ( scalar @{ $Param{TicketIDs} } ) {

        for my $TicketID ( @{ $Param{TicketIDs} } ) {
            $Counter++;
            if (
                $Counter >= $Param{StartHit}
                && $Counter < ( $Param{PageShown} + $Param{StartHit} )
                )
            {
                push @TicketIDsShown, $TicketID;
                my $Output = $Self->_Show(
                    TicketID => $TicketID,
                    Counter  => $CounterOnSite,
                    Bulk     => $BulkFeature,
                    Config   => $Param{Config},
                    Output   => $Param{Output} || '',
                );
                $CounterOnSite++;
                if ( !$Param{Output} ) {
                    $LayoutObject->Print( Output => $Output );
                }
                else {
                    $OutputRaw .= ${$Output};
                }
            }
        }
    }
    else {
        $LayoutObject->Block( Name => 'NoTicketFound' );
    }

    if ($BulkFeature) {
        $LayoutObject->Block(
            Name => 'DocumentFooter',
            Data => \%Param,
        );
        for my $TicketID (@TicketIDsShown) {
            $LayoutObject->Block(
                Name => 'DocumentFooterBulkItem',
                Data => \%Param,
            );
        }
        my $OutputMeta = $LayoutObject->Output(
            TemplateFile => 'AgentTicketOverviewPreview',
            Data         => \%Param,
        );
        if ( !$Param{Output} ) {
            $LayoutObject->Print( Output => \$OutputMeta );
        }
        else {
            $OutputRaw .= $OutputMeta;
        }
    }
    return $OutputRaw;
}

sub _Show {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID!'
        );
        return;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if bulk feature is enabled
    if ( $Param{Bulk} ) {
        $LayoutObject->Block(
            Name => 'Bulk',
            Data => \%Param,
        );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # collect params for ArticleGet
    my %ArticleGetParams = (
        TicketID      => $Param{TicketID},
        UserID        => $Self->{UserID},
        DynamicFields => 0,
        Order         => 'DESC',
        Limit         => $ConfigObject->Get('Ticket::Frontend::Overview::PreviewArticleLimit') || 5,
    );

    # check if certain article sender types should be excluded from preview
    my $PreviewArticleSenderTypes = $ConfigObject->Get('Ticket::Frontend::Overview::PreviewArticleSenderTypes');
    my @ActiveArticleSenderTypes;
    if ( ref $PreviewArticleSenderTypes eq 'HASH' ) {
        @ActiveArticleSenderTypes = grep { $PreviewArticleSenderTypes->{$_} == 1 } keys %{$PreviewArticleSenderTypes};
    }

    # if a list of active article sender types has been determined, add them to params hash
    if (@ActiveArticleSenderTypes) {
        $ArticleGetParams{ArticleSenderType} = \@ActiveArticleSenderTypes;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get last 5 articles
    my @ArticleBody = $TicketObject->ArticleGet(
        %ArticleGetParams,
    );
    my %Article = %{ $ArticleBody[0] || {} };
    my $ArticleCount = scalar @ArticleBody;

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # Fallback for tickets without articles: get at least basic ticket data
    if ( !%Article ) {
        %Article = %Ticket;
        if ( !$Article{Title} ) {
            $Article{Title} = $LayoutObject->{LanguageObject}->Translate(
                'This ticket has no title or subject'
            );
        }
        $Article{Subject} = $Article{Title};
    }

    # user info
    my %UserInfo = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Article{OwnerID},
    );
    %Article = ( %UserInfo, %Article );

    # create human age
    $Article{Age} = $LayoutObject->CustomerAge(
        Age   => $Article{Age},
        Space => ' '
    );

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # fetch all std. templates ...
    my %StandardTemplates = $QueueObject->QueueStandardTemplateMemberList(
        QueueID       => $Article{QueueID},
        TemplateTypes => 1,
    );

    $Param{StandardResponsesStrg} = $LayoutObject->BuildSelection(
        Name => 'ResponseID',
        Data => $StandardTemplates{Answer} || {},
    );

    # customer info
    if ( $Param{Config}->{CustomerInfo} ) {
        if ( $Article{CustomerUserID} ) {
            $Article{CustomerName} = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
                UserLogin => $Article{CustomerUserID},
            );
        }
    }

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

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # run ticket pre menu modules
    my @ActionItems;
    if ( ref $ConfigObject->Get('Ticket::Frontend::PreMenuModule') eq 'HASH' ) {
        my %Menus = %{ $ConfigObject->Get('Ticket::Frontend::PreMenuModule') };
        MENU:
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( !$MainObject->Require( $Menus{$Menu}->{Module} ) ) {
                return $LayoutObject->FatalError();
            }
            my $Object = $Menus{$Menu}->{Module}->new(
                %{$Self},
                TicketID => $Param{TicketID},
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
                    TemplateFile => 'AgentTicketOverviewPreview',
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
                Name        => $LayoutObject->{LanguageObject}->Translate( $Item->{Name} ),
                Link        => $LayoutObject->{Baselink} . $Item->{Link},
                Target      => $Item->{Target},
                PopupType   => $Item->{PopupType},
                Description => $Item->{Description},
                Block       => $Item->{Block},

            };
        }
    }

    my $AdditionalClasses = $Param{Config}->{TicketActionsPerTicket} ? 'ShowInlineActions' : '';

    $LayoutObject->Block(
        Name => 'DocumentContent',
        Data => {
            %Param,
            %Article,
            Class             => 'ArticleCount' . $ArticleCount,
            AdditionalClasses => $AdditionalClasses,
            Created           => $Ticket{Created},                 # use value from ticket, not article
        },
    );

    # if "Actions per Ticket" (Inline Action Row) is active
    if ( $Param{Config}->{TicketActionsPerTicket} ) {
        $LayoutObject->Block(
            Name => 'InlineActionRow',
            Data => \%Param,
        );

        # Add list entries for every action
        for my $Item (@ActionItems) {
            my $Link = $Item->{Link};
            if ( $Item->{Target} ) {
                $Link = '#';
            }

            my $Class = '';
            if ( $Item->{PopupType} ) {
                $Class = 'AsPopup PopupType_' . $Item->{PopupType};
            }

            if ( !$Item->{Block} ) {
                $LayoutObject->Block(
                    Name => 'InlineActionRowItem',
                    Data => {
                        TicketID    => $Param{TicketID},
                        QueueID     => $Article{QueueID},
                        ID          => $Item->{ID},
                        Name        => $Item->{Name},
                        Description => $Item->{Description},
                        Class       => $Class,
                        Link        => $Link,
                    },
                );
            }
            else {
                my $TicketID   = $Param{TicketID};
                my $SelectHTML = $Item->{HTML};
                $SelectHTML =~ s/id="DestQueueID"/id="DestQueueID$TicketID"/xmig;
                $SelectHTML =~ s/for="DestQueueID"/for="DestQueueID$TicketID"/xmig;
                $LayoutObject->Block(
                    Name => 'InlineActionRowItemHTML',
                    Data => {
                        HTML => $SelectHTML,
                    },
                );
            }
        }
    }

    # check if bulk feature is enabled
    if ( $Param{Bulk} ) {
        $LayoutObject->Block(
            Name => 'Bulk',
            Data => \%Param,
        );
    }

    # show ticket flags
    my @TicketMetaItems = $LayoutObject->TicketMetaItems(
        Ticket => \%Article,
    );
    for my $Item (@TicketMetaItems) {
        $LayoutObject->Block(
            Name => 'Meta',
            Data => $Item,
        );
        if ($Item) {
            $LayoutObject->Block(
                Name => 'MetaIcon',
                Data => $Item,
            );
        }
    }

    # run article modules
    if ( $Article{ArticleID} ) {
        if ( ref $ConfigObject->Get('Ticket::Frontend::ArticlePreViewModule') eq 'HASH' ) {
            my %Jobs = %{ $ConfigObject->Get('Ticket::Frontend::ArticlePreViewModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                    return $LayoutObject->FatalError();
                }
                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    ArticleID => $Article{ArticleID},
                    UserID    => $Self->{UserID},
                    Debug     => $Self->{Debug},
                );

                # run module
                my @Data = $Object->Check(
                    Article => \%Article,
                    %Param, Config => $Jobs{$Job}
                );

                for my $DataRef (@Data) {
                    if ( $DataRef->{Successful} ) {
                        $DataRef->{Result} = 'Error';
                    }
                    else {
                        $DataRef->{Result} = 'Success';
                    }

                    $LayoutObject->Block(
                        Name => 'ArticleOption',
                        Data => $DataRef,
                    );
                }

                # filter option
                $Object->Filter(
                    Article => \%Article,
                    %Param, Config => $Jobs{$Job}
                );
            }
        }
    }

    # create output
    $LayoutObject->Block(
        Name => 'AgentAnswer',
        Data => { %Param, %Article, %AclAction },
    );
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentTicketCompose}
        && ( !defined $AclAction{AgentTicketCompose} || $AclAction{AgentTicketCompose} )
        )
    {
        my $Access = 1;
        my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketCompose');
        if ( $Config->{Permission} ) {
            my $Ok = $TicketObject->Permission(
                Type     => $Config->{Permission},
                TicketID => $Param{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            if ( !$Ok ) {
                $Access = 0;
            }
            if ($Access) {
                $LayoutObject->Block(
                    Name => 'AgentAnswerCompose',
                    Data => { %Param, %Article, %AclAction },
                );
            }
        }
    }
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentTicketPhoneOutbound}
        && (
            !defined $AclAction{AgentTicketPhoneOutbound}
            || $AclAction{AgentTicketPhoneOutbound}
        )
        )
    {
        my $Access = 1;
        my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketPhoneOutbound');
        if ( $Config->{Permission} ) {
            my $OK = $TicketObject->Permission(
                Type     => $Config->{Permission},
                TicketID => $Param{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            if ( !$OK ) {
                $Access = 0;
            }
        }
        if ($Access) {
            $LayoutObject->Block(
                Name => 'AgentAnswerPhoneOutbound',
                Data => { %Param, %Article, %AclAction },
            );
        }
    }

    # ticket type
    if ( $ConfigObject->Get('Ticket::Type') ) {
        $LayoutObject->Block(
            Name => 'Type',
            Data => { %Param, %Article },
        );
    }

    # ticket service
    if ( $ConfigObject->Get('Ticket::Service') && $Article{Service} ) {
        $LayoutObject->Block(
            Name => 'Service',
            Data => { %Param, %Article },
        );
        if ( $Article{SLA} ) {
            $LayoutObject->Block(
                Name => 'SLA',
                Data => { %Param, %Article },
            );
        }
    }

    # CustomerID and CustomerName
    if ( defined $Article{CustomerID} ) {
        $LayoutObject->Block(
            Name => 'CustomerID',
            Data => { %Param, %Article },
        );

        # test access to frontend module
        my $Access = $LayoutObject->Permission(
            Action => 'AgentTicketCustomer',
            Type   => 'rw',
        );
        if ($Access) {

            # test access to ticket
            my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketCustomer');
            if ( $Config->{Permission} ) {
                my $OK = $TicketObject->Permission(
                    Type     => $Config->{Permission},
                    TicketID => $Param{TicketID},
                    UserID   => $Self->{UserID},
                    LogNo    => 1,
                );
                if ( !$OK ) {
                    $Access = 0;
                }
            }
        }

        # define proper tt block based on permissions
        my $CustomerIDBlock = $Access ? 'CustomerIDRW' : 'CustomerIDRO';

        $LayoutObject->Block(
            Name => $CustomerIDBlock,
            Data => { %Param, %Article },
        );

        if ( defined $Article{CustomerName} ) {
            $LayoutObject->Block(
                Name => 'CustomerName',
                Data => { %Param, %Article },
            );
        }
    }

    # show first response time if needed
    if ( defined $Article{FirstResponseTime} ) {
        $Article{FirstResponseTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Article{FirstResponseTime},
            Space => ' ',
        );
        $Article{FirstResponseTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Article{FirstResponseTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Article{FirstResponseTime} ) {
            $Article{FirstResponseTimeClass} = 'Warning'
        }
        $LayoutObject->Block(
            Name => 'FirstResponseTime',
            Data => { %Param, %Article },
        );
    }

    # show update time if needed
    if ( defined $Article{UpdateTime} ) {
        $Article{UpdateTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Article{UpdateTime},
            Space => ' ',
        );
        $Article{UpdateTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Article{UpdateTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Article{UpdateTime} ) {
            $Article{UpdateTimeClass} = 'Warning'
        }
        $LayoutObject->Block(
            Name => 'UpdateTime',
            Data => { %Param, %Article },
        );
    }

    # show solution time if needed
    if ( defined $Article{SolutionTime} ) {
        $Article{SolutionTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Article{SolutionTime},
            Space => ' ',
        );
        $Article{SolutionTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Article{SolutionTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Article{SolutionTime} ) {
            $Article{SolutionTimeClass} = 'Warning'
        }
        $LayoutObject->Block(
            Name => 'SolutionTime',
            Data => { %Param, %Article },
        );
    }

    # Dynamic fields
    $Counter = 0;
    my $Class = 'Middle';

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::OverviewPreview")->{DynamicField};

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get dynamic field backend object
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # get field value
        my $Value = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{TicketID},
        );

        next DYNAMICFIELD if ( !defined $Value );

        $Counter++;

        my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            ValueMaxChars      => 20,
            LayoutObject       => $LayoutObject,
        );

        my $Label = $DynamicFieldConfig->{Label};

        # create a new row if counter is starting
        if ( $Counter == 1 ) {
            $LayoutObject->Block(
                Name => 'DynamicFieldTableRow',
                Data => {
                    Class => $Class,
                },
            );
        }

        # display separation row just once
        $Class = '';

        # outout dynamic field label
        $LayoutObject->Block(
            Name => 'DynamicFieldTableRowRecord',
            Data => {
                Label => $Label,
            },
        );

        if ( $ValueStrg->{Link} ) {

            # outout dynamic field value link
            $LayoutObject->Block(
                Name => 'DynamicFieldTableRowRecordLink',
                Data => {
                    Value                       => $ValueStrg->{Value},
                    Title                       => $ValueStrg->{Title},
                    Link                        => $ValueStrg->{Link},
                    $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                },
            );
        }
        else {

            # outout dynamic field value plain
            $LayoutObject->Block(
                Name => 'DynamicFieldTableRowRecordPlain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }

        # only 2 dynamic fields by row are allowed, reset couter if needed
        if ( $Counter == 2 ) {
            $Counter = 0;
        }

        # example of dynamic fields order customization
        # outout dynamic field label
        $LayoutObject->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name} . '_TableRowRecord',
            Data => {
                Label => $Label,
            },
        );

        if ( $ValueStrg->{Link} ) {

            # outout dynamic field value link
            $LayoutObject->Block(
                Name => 'DynamicField_' . $DynamicFieldConfig->{Name} . '_TableRowRecordLink',
                Data => {
                    Value                       => $ValueStrg->{Value},
                    Title                       => $ValueStrg->{Title},
                    Link                        => $ValueStrg->{Link},
                    $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                },
            );
        }
        else {

            # outout dynamic field value plain
            $LayoutObject->Block(
                Name => 'DynamicField_' . $DynamicFieldConfig->{Name} . '_TableRowRecordPlain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }
    }

    # fill the rest of the Dynamic Fields row with empty cells, this will look better
    if ( $Counter > 0 && $Counter < 2 ) {

        for ( $Counter + 1 ... 2 ) {

            # outout dynamic field label
            $LayoutObject->Block(
                Name => 'DynamicFieldTableRowRecord',
                Data => {
                    Label => '',
                },
            );

            # outout dynamic field value plain
            $LayoutObject->Block(
                Name => 'DynamicFieldTableRowRecordPlain',
                Data => {
                    Value => '',
                    Title => '',
                },
            );
        }
    }

    if (@ArticleBody) {

        # check if a certain article type should be displayed as expanded
        my $PreviewArticleTypeExpanded = $ConfigObject->Get('Ticket::Frontend::Overview::PreviewArticleTypeExpanded')
            || '';

        # if a certain article type should be shown as expanded, set the
        # last article of this type as active
        if ($PreviewArticleTypeExpanded) {

            my $ClassCount = 0;
            ARTICLE_ITEM:
            for my $ArticleItem (@ArticleBody) {
                next ARTICLE_ITEM if !$ArticleItem;

                # check if current article type should be shown as expanded
                if ( $ArticleItem->{ArticleType} eq $PreviewArticleTypeExpanded ) {
                    $ArticleItem->{Class} = 'Active';
                    last ARTICLE_ITEM;
                }

                # otherwise display the last article in the list as expanded (default)
                elsif ( $ClassCount == $#ArticleBody ) {
                    $ArticleBody[0]->{Class} = 'Active';
                }
                $ClassCount++;
            }
        }

        # otherwise display the last article in the list as expanded (default)
        else {
            $ArticleBody[0]->{Class} = 'Active';
        }

        $LayoutObject->Block(
            Name => 'ArticlesPreviewArea',
            Data => { %Param, %Article, %AclAction },
        );
    }

    # show inline article
    for my $ArticleItem ( reverse @ArticleBody ) {

        # check if just a only html email
        my $MimeTypeText = $LayoutObject->CheckMimeType(
            %{$ArticleItem},
            Action => 'AgentTicketZoom',
        );
        if ($MimeTypeText) {
            $ArticleItem->{BodyNote} = $MimeTypeText;
            $ArticleItem->{Body}     = '';
        }
        else {

            # html quoting
            $ArticleItem->{Body} = $LayoutObject->Ascii2Html(
                NewLine => $Param{Config}->{DefaultViewNewLine}  || 90,
                Text    => $ArticleItem->{Body},
                VMax    => $Param{Config}->{DefaultPreViewLines} || 25,
                LinkFeature     => 1,
                HTMLResultMode  => 1,
                StripEmptyLines => $Param{Config}->{StripEmptyLines},
            );
        }

        $ArticleItem->{Subject} = $TicketObject->TicketSubjectClean(
            TicketNumber => $ArticleItem->{TicketNumber},
            Subject      => $ArticleItem->{Subject} || '',
        );

        $LayoutObject->Block(
            Name => 'ArticlePreview',
            Data => {
                %{$ArticleItem},
                Class => $ArticleItem->{Class},
            },
        );

        # show actions
        if ( $ArticleItem->{ArticleType} !~ /^(note|email-noti)/i ) {

            # check if compose link should be shown
            if (
                $ConfigObject->Get('Frontend::Module')->{AgentTicketCompose}
                && (
                    !defined $AclAction{AgentTicketCompose}
                    || $AclAction{AgentTicketCompose}
                )
                )
            {
                my $Access = 1;
                my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketCompose');
                if ( $Config->{Permission} ) {
                    my $Ok = $TicketObject->Permission(
                        Type     => $Config->{Permission},
                        TicketID => $Article{TicketID},
                        UserID   => $Self->{UserID},
                        LogNo    => 1,
                    );
                    if ( !$Ok ) {
                        $Access = 0;
                    }
                }
                if ( $Config->{RequiredLock} ) {
                    my $Locked = $TicketObject->LockIsTicketLocked(
                        TicketID => $Article{TicketID},
                    );
                    if ($Locked) {
                        my $AccessOk = $TicketObject->OwnerCheck(
                            TicketID => $Article{TicketID},
                            OwnerID  => $Self->{UserID},
                        );
                        if ( !$AccessOk ) {
                            $Access = 0;
                        }
                    }
                }
                if ($Access) {
                    $LayoutObject->Block(
                        Name => 'ArticlePreviewActionRow',
                        Data => {
                            %{$ArticleItem}, %AclAction,
                        },
                    );

                    # fetch all std. responses
                    my %StandardTemplates = $QueueObject->QueueStandardTemplateMemberList(
                        QueueID       => $Article{QueueID},
                        TemplateTypes => 1,
                    );

                    my %StandardResponses;
                    if ( IsHashRefWithData( $StandardTemplates{Answer} ) ) {
                        %StandardResponses = %{ $StandardTemplates{Answer} };
                    }

                    # get StandardResponsesStrg
                    # get revers StandardResponse because we need to sort by Values
                    # from %ReverseStandardResponseHash we get value of Key by %StandardResponse Value
                    # and @StandardResponseArray is created as array of hashes with elements Key and Value

                    my %ReverseStandardResponseHash = reverse %StandardResponses;
                    my @StandardResponseArray       = map {
                        {
                            Key   => $ReverseStandardResponseHash{$_},
                            Value => $_
                        }
                    } sort values %StandardResponses;

                    unshift(
                        @StandardResponseArray,
                        {
                            Key   => '0',
                            Value => '- '
                                . $LayoutObject->{LanguageObject}->Translate('Reply')
                                . ' -',
                            Selected => 1,
                        }
                    );

                    # build html string
                    my $StandardResponsesStrg = $LayoutObject->BuildSelection(
                        Name => 'ResponseID',
                        ID   => 'ResponseID' . $ArticleItem->{ArticleID},
                        Data => \@StandardResponseArray,
                    );

                    $LayoutObject->Block(
                        Name => 'ArticlePreviewActionRowItem',
                        Data => {
                            %{$ArticleItem},
                            StandardResponsesStrg => $StandardResponsesStrg,
                            Name                  => 'Reply',
                            Class                 => 'AsPopup',
                            Action                => 'AgentTicketCompose',
                            FormID                => 'Reply' . $ArticleItem->{ArticleID},
                        },
                    );

                    # check if reply all is needed
                    my $Recipients = '';
                    KEY:
                    for my $Key (qw(From To Cc)) {
                        next KEY if !$ArticleItem->{$Key};
                        if ($Recipients) {
                            $Recipients .= ', ';
                        }
                        $Recipients .= $ArticleItem->{$Key};
                    }
                    my $RecipientCount = 0;
                    if ($Recipients) {
                        my $EmailParser = Kernel::System::EmailParser->new(
                            %{$Self},
                            Mode => 'Standalone',
                        );
                        my @Addresses = $EmailParser->SplitAddressLine( Line => $Recipients );
                        ADDRESS:
                        for my $Address (@Addresses) {
                            my $Email = $EmailParser->GetEmailAddress( Email => $Address );
                            next ADDRESS if !$Email;
                            my $IsLocal
                                = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress(
                                Address => $Email,
                                );
                            next ADDRESS if $IsLocal;
                            $RecipientCount++;
                        }
                    }
                    if ( $RecipientCount > 1 ) {

                        # get StandardResponsesStrg
                        shift(@StandardResponseArray);
                        unshift(
                            @StandardResponseArray,
                            {
                                Key   => '0',
                                Value => '- '
                                    . $LayoutObject->{LanguageObject}->Translate('Reply All')
                                    . ' -',
                                Selected => 1,
                            }
                        );
                        $StandardResponsesStrg = $LayoutObject->BuildSelection(
                            Name => 'ResponseID',
                            ID   => 'ResponseIDAll' . $ArticleItem->{ArticleID},
                            Data => \@StandardResponseArray,
                        );

                        $LayoutObject->Block(
                            Name => 'ArticlePreviewActionRowItem',
                            Data => {
                                %{$ArticleItem},
                                StandardResponsesStrg => $StandardResponsesStrg,
                                Name                  => 'Reply All',
                                Class                 => 'AsPopup',
                                Action                => 'AgentTicketCompose',
                                FormID                => 'ReplyAll' . $ArticleItem->{ArticleID},
                                ReplyAll              => 1,
                            },
                        );
                    }
                }
            }
        }
    }

    # add action items as js
    if ( @ActionItems && !$Param{Config}->{TicketActionsPerTicket} ) {

        $LayoutObject->Block(
            Name => 'DocumentReadyActionRowAdd',
            Data => {
                TicketID => $Param{TicketID},
                Data     => \@ActionItems,
            },
        );
    }

    # create & return output
    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketOverviewPreview',
        Data         => {
            %Param,
            %Article,
            %AclAction,
        },
    );
    return \$Output;
}
1;
