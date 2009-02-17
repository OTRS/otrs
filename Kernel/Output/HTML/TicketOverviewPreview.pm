# --
# Kernel/Output/HTML/TicketOverviewPreview.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TicketOverviewPreview.pm,v 1.9 2009-02-17 00:31:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketOverviewPreview;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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
        Name => 'TicketHeader',
        Data => \%Param,
    );
    my $OutputMeta = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewPreviewMeta',
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
    for my $TicketID ( @{ $Param{TicketIDs} } ) {
        $Counter++;
        if ( $Counter >= $Param{StartHit} && $Counter < ( $Param{PageShown} + $Param{StartHit} ) ) {
            push @TicketIDsShown, $TicketID;
            my $Output = $Self->_Show(
                TicketID => $TicketID,
                Counter  => $CounterOnSite,
                Bulk     => $BulkFeature,
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
    if ( $BulkFeature ) {
        $Self->{LayoutObject}->Block(
            Name => 'TicketFooter',
            Data => \%Param,
        );
        for my $TicketID (@TicketIDsShown) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFooterBulkItem',
                Data => \%Param,
            );
        }
        my $OutputMeta = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketOverviewPreviewMeta',
            Data         => \%Param,
        );
        if ( !$Param{Output} ) {
            $Self->{LayoutObject}->Print( Output => \$OutputMeta );
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TicketID!' );
        return;
    }

    # check if bulk feature is enabled
    if ( $Param{Bulk} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Bulk',
            Data => \%Param,
        );
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

    # fetch all std. responses ...
    my %StdResponses = $Self->{QueueObject}->GetStdResponses( QueueID => $Article{QueueID} );
    $Param{StdResponsesStrg} = $Self->{LayoutObject}->TicketStdResponseString(
        StdResponsesRef => \%StdResponses,
        TicketID        => $Article{TicketID},
        ArticleID       => $Article{ArticleID},
    );

    # customer info
    my %CustomerData = ();
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoQueue') ) {
        if ( $Article{CustomerUserID} ) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Article{CustomerUserID},
            );
        }
        elsif ( $Article{CustomerID} ) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                CustomerID => $Article{CustomerID},
            );
        }
    }

    # build header lines
    for (qw(From To Cc Subject)) {
        next if !$Article{$_};
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {
                Key   => $_,
                Value => $Article{$_},
            },
        );
    }
    for ( 1 .. 3 ) {
        next if !$Article{"ArticleFreeText$_"};
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText',
            Data => {
                Key   => $Article{"ArticleFreeKey$_"},
                Value => $Article{"ArticleFreeText$_"},
            },
        );
    }

    # create human age
    $Article{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' );

    # customer info string
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoQueue') ) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data   => \%CustomerData,
            Ticket => \%Article,
            Type   => 'Lite',
            Max    => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoQueueMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # check if just a only html email
    my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(
        %Article,
        Action => 'AgentTicketZoom',
    );
    if ($MimeTypeText) {
        $Article{BodyNote} = $MimeTypeText;
        $Article{Body}     = '';
    }
    else {

        # html quoting
        $Article{Body} = $Self->{LayoutObject}->Ascii2Html(
            NewLine         => $Self->{ConfigObject}->Get('DefaultViewNewLine'),
            Text            => $Article{Body},
            VMax            => $Self->{ConfigObject}->Get('DefaultPreViewLines') || 25,
            LinkFeature     => 1,
            HTMLResultMode  => 1,
            StripEmptyLines => $Self->{Config}->{StripEmptyLines},
        );

        # do charset check
        my $CharsetText = $Self->{LayoutObject}->CheckCharset(
            Action         => 'AgentTicketZoom',
            ContentCharset => $Article{ContentCharset},
            TicketID       => $Article{TicketID},
            ArticleID      => $Article{ArticleID}
        );
        if ($CharsetText) {
            $Article{BodyNote} = $CharsetText;
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
    if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') eq 'HASH' ) {
        my %Menus   = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Menus{$Menu}->{Module}->new( %{$Self}, TicketID => $Param{TicketID}, );

            # run module
            $Counter = $Object->Run(
                %Param,
                Ticket  => \%Article,
                Counter => $Counter,
                ACL     => \%AclAction,
                Config  => $Menus{$Menu},
            );
        }
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        if ( $Article{ 'TicketFreeText' . $Count } ) {
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
    }

    # ticket free time
    for my $Count ( 1 .. 6 ) {
        if ( $Article{ 'TicketFreeTime' . $Count } ) {
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
    }

    # create output
    if (
        $Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer')
        && $Article{CustomerUserID}
        && $Article{CustomerUserID} =~ /^$Self->{UserLogin}$/i
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'AgentIsCustomer',
            Data => { %Param, %Article, %AclAction },
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'AgentAnswer',
            Data => { %Param, %Article, %AclAction },
        );
        if (
            $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketCompose}
            && ( !defined( $AclAction{AgentTicketCompose} ) || $AclAction{AgentTicketCompose} )
            )
        {
            my $Access = 1;
            my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketCompose");
            if ( $Config->{Permission} ) {
                my $Ok = $Self->{TicketObject}->Permission(
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
                !defined( $AclAction{AgentTicketPhoneOutbound} )
                || $AclAction{AgentTicketPhoneOutbound}
            )
            )
        {
            my $Access = 1;
            my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketPhoneOutbound");
            if ( $Config->{Permission} ) {
                my $OK = $Self->{TicketObject}->Permission(
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
    }

    # ticket title
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::Title') ) {
        $Self->{LayoutObject}->Block(
            Name => 'Title',
            Data => { %Param, %Article },
        );
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
    if ( defined( $Article{FirstResponseTime} ) ) {
        $Article{FirstResponseTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{'FirstResponseTime'},
            Space => ' ',
        );
        $Article{FirstResponseTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{'FirstResponseTimeWorkingTime'},
            Space => ' ',
        );
        $Self->{LayoutObject}->Block(
            Name => 'FirstResponseTime',
            Data => { %Param, %Article },
        );
        if ( 60 * 60 * 1 > $Article{FirstResponseTime} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FirstResponseTimeFontStart',
                Data => { %Param, %Article },
            );
            $Self->{LayoutObject}->Block(
                Name => 'FirstResponseTimeFontStop',
                Data => { %Param, %Article },
            );
        }
    }

    # show update time if needed
    if ( defined( $Article{UpdateTime} ) ) {
        $Article{UpdateTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{'UpdateTime'},
            Space => ' ',
        );
        $Article{UpdateTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{'UpdateTimeWorkingTime'},
            Space => ' ',
        );
        $Self->{LayoutObject}->Block(
            Name => 'UpdateTime',
            Data => { %Param, %Article },
        );
        if ( 60 * 60 * 1 > $Article{UpdateTime} ) {
            $Self->{LayoutObject}->Block(
                Name => 'UpdateTimeFontStart',
                Data => { %Param, %Article },
            );
            $Self->{LayoutObject}->Block(
                Name => 'UpdateTimeFontStop',
                Data => { %Param, %Article },
            );
        }
    }

    # show solution time if needed
    if ( defined( $Article{SolutionTime} ) ) {
        $Article{SolutionTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{'SolutionTime'},
            Space => ' ',
        );
        $Article{SolutionTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Article{'SolutionTimeWorkingTime'},
            Space => ' ',
        );
        $Self->{LayoutObject}->Block(
            Name => 'SolutionTime',
            Data => { %Param, %Article },
        );
        if ( 60 * 60 * 1 > $Article{SolutionTime} ) {
            $Self->{LayoutObject}->Block(
                Name => 'SolutionTimeFontStart',
                Data => { %Param, %Article },
            );
            $Self->{LayoutObject}->Block(
                Name => 'SolutionTimeFontStop',
                Data => { %Param, %Article },
            );
        }
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
        && ( !defined( $AclAction{AgentTicketMove} ) || $AclAction{AgentTicketMove} )
        )
    {
        my $Access = $Self->{TicketObject}->Permission(
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

    # create & return output
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewPreview',
        Data => { %Param, %Article, %AclAction },
    );
    return \$Output;
}
1;
