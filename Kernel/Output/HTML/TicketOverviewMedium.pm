# --
# Kernel/Output/HTML/TicketOverviewMedium.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: TicketOverviewMedium.pm,v 1.40.2.1 2011-03-01 18:17:20 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketOverviewMedium;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.40.2.1 $) [1];

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

    # init for table control
    $Self->{LayoutObject}->Block(
        Name => 'DocumentReadyStart',
        Data => \%Param,
    );

    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewMedium',
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

    $Self->{LayoutObject}->Block(
        Name => 'DocumentHeader',
        Data => \%Param,
    );

    my $OutputMeta = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewMedium',
        Data         => \%Param,
    );
    my $OutputRaw = '';
    if ( !$Param{Output} ) {
        $Self->{LayoutObject}->Print( Output => \$OutputMeta );
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
                );
                $CounterOnSite++;
                if ( !$Param{Output} ) {
                    $Self->{LayoutObject}->Print( Output => $Output );
                }
                else {
                    $OutputRaw .= ${$Output};
                }
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'NoTicketFound' );
    }

    # check if bulk feature is enabled
    if ($BulkFeature) {
        $Self->{LayoutObject}->Block(
            Name => 'DocumentFooter',
            Data => \%Param,
        );
        for my $TicketID (@TicketIDsShown) {
            $Self->{LayoutObject}->Block(
                Name => 'DocumentFooterBulkItem',
                Data => \%Param,
            );
        }
        my $OutputMeta = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketOverviewMedium',
            Data         => \%Param,
        );
        if ( !$Param{Output} ) {
            $Self->{LayoutObject}->Print( Output => \$OutputMeta );
        }
        else {
            $OutputRaw .= $OutputMeta;
        }
    }

    # add action row js data

    return $OutputRaw;
}

sub _Show {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TicketID!' );
        return;
    }

    # get move queues
    my %MoveQueues = $Self->{TicketObject}->MoveList(
        TicketID => $Param{TicketID},
        UserID   => $Self->{UserID},
        Action   => $Self->{LayoutObject}->{Action},
        Type     => 'move_into',
    );

    # get last article
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
        TicketID => $Param{TicketID},
    );

    # user info
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $Article{OwnerID},
    );
    %Article = ( %UserInfo, %Article );

    # create human age
    $Article{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' );

    # fetch all std. responses ...
    my %StandardResponses
        = $Self->{QueueObject}->GetStandardResponses( QueueID => $Article{QueueID} );

    $Param{StandardResponsesStrg} = $Self->{LayoutObject}->BuildSelection(
        Name => 'ResponseID',
        Data => \%StandardResponses,
    );

    # customer info
    if ( $Param{Config}->{CustomerInfo} ) {
        if ( $Article{CustomerUserID} ) {
            $Article{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                UserLogin => $Article{CustomerUserID},
            );
        }
    }

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
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Menus{$Menu}->{Module}->new( %{$Self}, TicketID => $Param{TicketID}, );

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
                TemplateFile => 'AgentTicketOverviewMedium',
                Data         => $Item,
            );
            $Output =~ s/\n+//g;
            $Output =~ s/\s+/ /g;
            $Output =~ s/<\!--.+?-->//g;

            push @ActionItems, {
                HTML        => $Output,
                ID          => $Item->{ID},
                Name        => $Self->{LayoutObject}->{LanguageObject}->Get( $Item->{Name} ),
                Link        => $Self->{LayoutObject}->{Baselink} . $Item->{Link},
                Target      => $Item->{Target},
                PopupType   => $Item->{PopupType},
                Description => $Item->{Description},
                Block       => $Item->{Block} || 'DocumentMenuItem',
            };
        }
    }

    # prepare subject
    $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject => $Article{Subject} || '',
    );

    $Self->{LayoutObject}->Block(
        Name => 'DocumentContent',
        Data => { %Param, %Article },
    );

    # if "Actions per Ticket" (Inline Action Row) is active
    if ( $Param{Config}->{TicketActionsPerTicket} ) {
        $Self->{LayoutObject}->Block(
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

            if ( $Item->{Block} eq 'DocumentMenuItem' ) {
                $Self->{LayoutObject}->Block(
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
                $Self->{LayoutObject}->Block(
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
        $Self->{LayoutObject}->Block(
            Name => 'Bulk',
            Data => \%Param,
        );
    }

    # show ticket flags
    my @TicketMetaItems = $Self->{LayoutObject}->TicketMetaItems(
        Ticket => \%Article,
    );
    for my $Item (@TicketMetaItems) {
        $Self->{LayoutObject}->Block(
            Name => 'Meta',
            Data => $Item,
        );
        if ($Item) {
            $Self->{LayoutObject}->Block(
                Name => 'MetaIcon',
                Data => $Item,
            );
        }
    }

    # run article modules
    if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticlePreViewModule') eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticlePreViewModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                ArticleID => $Article{ArticleID},
                UserID    => $Self->{UserID},
                Debug     => $Self->{Debug},
            );

            # run module
            my @Data = $Object->Check( Article => \%Article, %Param, Config => $Jobs{$Job} );

            for my $DataRef (@Data) {
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleOption',
                    Data => $DataRef,
                );
            }

            # filter option
            $Object->Filter( Article => \%Article, %Param, Config => $Jobs{$Job} );
        }
    }

    # build header lines
    #    for (qw(From To Cc Subject)) {
    #        next if !$Article{$_};
    #        $Self->{LayoutObject}->Block(
    #            Name => 'Row',
    #            Data => {
    #                Key   => $_,
    #                Value => $Article{$_},
    #            },
    #        );
    #    }
    for my $Count ( 1 .. 3 ) {
        next if !$Article{"ArticleFreeText$Count"};
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText',
            Data => {
                Key   => $Article{"ArticleFreeKey$Count"},
                Value => $Article{"ArticleFreeText$Count"},
            },
        );
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        next if !$Article{ 'TicketFreeText' . $Count };
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText' . $Count,
            Data => { %Param, %Article, %AclAction },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText',
            Data => {
                %Param, %Article, %AclAction,
                TicketFreeKey  => $Article{ 'TicketFreeKey' . $Count },
                TicketFreeText => $Article{ 'TicketFreeText' . $Count },
                Count          => $Count,
            },
        );
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeText' . $Count . '::Link' ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextPlain' . $Count,
                Data => { %Param, %Article, %AclAction },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextPlain',
                Data => {
                    %Param, %Article, %AclAction,
                    TicketFreeKey  => $Article{ 'TicketFreeKey' . $Count },
                    TicketFreeText => $Article{ 'TicketFreeText' . $Count },
                    Count          => $Count,
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextLink' . $Count,
                Data => { %Param, %Article, %AclAction },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextLink',
                Data => {
                    %Param, %Article, %AclAction,
                    TicketFreeTextLink =>
                        $Self->{ConfigObject}->Get( 'TicketFreeText' . $Count . '::Link' ),
                    TicketFreeKey  => $Article{ 'TicketFreeKey' . $Count },
                    TicketFreeText => $Article{ 'TicketFreeText' . $Count },
                    Count          => $Count,
                },
            );
        }
    }

    # ticket free time
    for my $Count ( 1 .. 6 ) {
        next if !$Article{ 'TicketFreeTime' . $Count };
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime' . $Count,
            Data => { %Param, %Article, %AclAction },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime',
            Data => {
                %Param, %Article, %AclAction,
                TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                TicketFreeTime    => $Article{ 'TicketFreeTime' . $Count },
                Count             => $Count,
            },
        );
    }

    # create output
    $Self->{LayoutObject}->Block(
        Name => 'AgentAnswer',
        Data => { %Param, %Article, %AclAction },
    );
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketCompose}
        && ( !defined $AclAction{AgentTicketCompose} || $AclAction{AgentTicketCompose} )
        )
    {
        my $Access = 1;
        my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketCompose");
        if ( $Config->{Permission} ) {
            my $Ok = $Self->{TicketObject}->TicketPermission(
                Type     => $Config->{Permission},
                TicketID => $Param{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            if ( !$Ok ) {
                $Access = 0;
            }
            if ($Access) {
                $Self->{LayoutObject}->Block(
                    Name => 'AgentAnswerCompose',
                    Data => { %Param, %Article, %AclAction },
                );
            }
        }
    }
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPhoneOutbound}
        && (
            !defined $AclAction{AgentTicketPhoneOutbound}
            || $AclAction{AgentTicketPhoneOutbound}
        )
        )
    {
        my $Access = 1;
        my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketPhoneOutbound");
        if ( $Config->{Permission} ) {
            my $OK = $Self->{TicketObject}->TicketPermission(
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
            $Self->{LayoutObject}->Block(
                Name => 'AgentAnswerPhoneOutbound',
                Data => { %Param, %Article, %AclAction },
            );
        }
    }

    # ticket type
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Self->{LayoutObject}->Block(
            Name => 'Type',
            Data => { %Param, %Article },
        );
    }

    # ticket service
    if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Article{Service} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Service',
            Data => { %Param, %Article },
        );
        if ( $Article{SLA} ) {
            $Self->{LayoutObject}->Block(
                Name => 'SLA',
                Data => { %Param, %Article },
            );
        }
    }

    # show first response time if needed
    if ( defined $Article{FirstResponseTime} ) {
        $Article{FirstResponseTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{FirstResponseTime},
            Space => ' ',
        );
        $Article{FirstResponseTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{FirstResponseTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Article{FirstResponseTime} ) {
            $Article{FirstResponseTimeClass} = 'Warning'
        }
        $Self->{LayoutObject}->Block(
            Name => 'FirstResponseTime',
            Data => { %Param, %Article },
        );
    }

    # show update time if needed
    if ( defined $Article{UpdateTime} ) {
        $Article{UpdateTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{UpdateTime},
            Space => ' ',
        );
        $Article{UpdateTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{UpdateTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Article{UpdateTime} ) {
            $Article{UpdateTimeClass} = 'Warning'
        }
        $Self->{LayoutObject}->Block(
            Name => 'UpdateTime',
            Data => { %Param, %Article },
        );
    }

    # show solution time if needed
    if ( defined $Article{SolutionTime} ) {
        $Article{SolutionTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{SolutionTime},
            Space => ' ',
        );
        $Article{SolutionTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{SolutionTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Article{SolutionTime} ) {
            $Article{SolutionTimeClass} = 'Warning'
        }
        $Self->{LayoutObject}->Block(
            Name => 'SolutionTime',
            Data => { %Param, %Article },
        );
    }

    # get MoveQueuesStrg
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') =~ /^form$/i ) {
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name       => 'DestQueueID',
            Data       => \%MoveQueues,
            SelectedID => $Article{QueueID},
        );
    }
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketMove}
        && ( !defined $AclAction{AgentTicketMove} || $AclAction{AgentTicketMove} )
        )
    {
        my $Access = $Self->{TicketObject}->TicketPermission(
            Type     => 'move',
            TicketID => $Param{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
        if ($Access) {
            $Self->{LayoutObject}->Block(
                Name => 'Move',
                Data => { %Param, %AclAction },
            );
        }
    }

    # add action items as js
    if ( @ActionItems && !$Param{Config}->{TicketActionsPerTicket} ) {
        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => \@ActionItems,
        );

        $Self->{LayoutObject}->Block(
            Name => 'DocumentReadyActionRowAdd',
            Data => {
                TicketID => $Param{TicketID},
                Data     => $JSON,
            },
        );
    }

    # create & return output
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewMedium',
        Data => { %Param, %Article, %AclAction },
    );

    return \$Output;
}
1;
