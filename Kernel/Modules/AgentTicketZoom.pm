# --
# Kernel/Modules/AgentTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketZoom.pm,v 1.51 2008-05-08 09:58:00 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketZoom;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.51 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject UserObject SessionObject)
        )
    {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # set debug
    $Self->{Debug} = 0;

    # get params
    $Self->{ArticleID}      = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );
    $Self->{ZoomExpand}     = $Self->{ParamObject}->GetParam( Param => 'ZoomExpand' );
    $Self->{ZoomExpandSort} = $Self->{ParamObject}->GetParam( Param => 'ZoomExpandSort' );
    if ( !defined( $Self->{ZoomExpand} ) ) {
        $Self->{ZoomExpand} = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomExpand');
    }
    if ( !defined( $Self->{ZoomExpandSort} ) ) {
        $Self->{ZoomExpandSort} = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomExpandSort');
    }
    $Self->{HighlightColor1} = $Self->{ConfigObject}->Get('HighlightColor1');
    $Self->{HighlightColor2} = $Self->{ConfigObject}->Get('HighlightColor2');

    # ticket id lookup
    if ( !$Self->{TicketID} && $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ) ) {
        $Self->{TicketID} = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ),
            UserID => $Self->{UserID},
        );
    }

    # customer user object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    # link object
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No TicketID is given!",
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    if (
        !$Self->{TicketObject}->Permission(
            Type     => 'ro',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # store last screen
    if ( $Self->{Subaction} ne 'ShowHTMLeMail' ) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $Self->{RequestedURL},
        );
    }

    # get content
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(
        TicketID                   => $Self->{TicketID},
        StripPlainBodyAsAttachment => 1,
    );

    # return if HTML email
    if ( $Self->{Subaction} eq 'ShowHTMLeMail' ) {

        # check needed ArticleID
        if ( !$Self->{ArticleID} ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need ArticleID!' );
        }

        # get article data
        my %Article = ();
        for my $ArticleTmp (@ArticleBox) {
            if ( $ArticleTmp->{ArticleID} eq $Self->{ArticleID} ) {
                %Article = %{$ArticleTmp};
            }
        }

        # check if article data exists
        if ( !%Article ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Invalid ArticleID!' );
        }

        # if it is a html email, return here
        return $Self->{LayoutObject}->Attachment(
            Filename => $Self->{ConfigObject}->Get('Ticket::Hook')
                . "-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
            Type        => 'inline',
            ContentType => "$Article{MimeType}; charset=$Article{ContentCharset}",
            Content     => $Article{Body},
        );
    }

    # else show normal ticket zoom view
    # fetch all move queues
    my %MoveQueues = $Self->{TicketObject}->MoveList(
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
        Action   => $Self->{Action},
        Type     => 'move_into',
    );

    # fetch all std. responses
    my %StdResponses = $Self->{QueueObject}->GetStdResponses( QueueID => $Ticket{QueueID} );

    # customer info
    my %CustomerData = ();
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoom') ) {
        if ( $Ticket{CustomerUserID} ) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }
        elsif ( $Ticket{CustomerID} ) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                CustomerID => $Ticket{CustomerID},
            );
        }
    }

    # generate output
    $Output .= $Self->{LayoutObject}->Header( Value => $Ticket{TicketNumber} );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show ticket
    $Output .= $Self->MaskAgentZoom(
        MoveQueues      => \%MoveQueues,
        StdResponses    => \%StdResponses,
        ArticleBox      => \@ArticleBox,
        CustomerData    => \%CustomerData,
        TicketTimeUnits => $Self->{TicketObject}->TicketAccountedTimeGet(%Ticket),
        %Ticket,
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return output
    return $Output;
}

sub MaskAgentZoom {
    my ( $Self, %Param ) = @_;

    # owner info
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $Param{OwnerID},
        Cached => 1
    );

    # responsible info
    my %ResponsibleInfo = $Self->{UserObject}->GetUserData(
        UserID => $Param{ResponsibleID} || 1,
        Cached => 1
    );

    # get ack actions
    $Self->{TicketObject}->TicketAcl(
        Data          => '-',
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );

    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # age design
    $Param{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Param{Age}, Space => ' ' );
    if ( $Param{UntilTime} ) {
        if ( $Param{UntilTime} < -1 ) {
            $Param{PendingUntil} = "<font color='$Self->{HighlightColor2}'>";
        }
        $Param{PendingUntil}
            .= $Self->{LayoutObject}->CustomerAge( Age => $Param{UntilTime}, Space => '<br>' );
        if ( $Param{UntilTime} < -1 ) {
            $Param{PendingUntil} .= "</font>";
        }
    }
    $Self->{LayoutObject}->Block(
        Name => 'Header',
        Data => { %Param, %AclAction },
    );

    # ticket title
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::Title') ) {
        $Self->{LayoutObject}->Block(
            Name => 'Title',
            Data => { %Param, %AclAction },
        );
    }

    # run ticket menu modules
    if ( ref( $Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule') ) eq 'HASH' ) {
        my %Menus   = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object
                    = $Menus{$Menu}->{Module}->new( %{$Self}, TicketID => $Self->{TicketID}, );

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Ticket  => \%Param,
                    Counter => $Counter,
                    ACL     => \%AclAction,
                    Config  => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # build article stuff
    my $BaseLink   = $Self->{LayoutObject}->{Baselink} . "TicketID=$Self->{TicketID}&";
    my @ArticleBox = @{ $Param{ArticleBox} };

    # get selected or last customer article
    my $CounterArray = 0;
    my $ArticleID;
    if ( $Self->{ArticleID} ) {
        $ArticleID = $Self->{ArticleID};
    }
    else {

        # set first article
        if (@ArticleBox) {
            $ArticleID = $ArticleBox[0]->{ArticleID};
        }

        # get last customer article
        for my $ArticleTmp (@ArticleBox) {
            if ( $ArticleTmp->{SenderType} eq 'customer' ) {
                $ArticleID = $ArticleTmp->{ArticleID};
            }
        }
    }

    # build thread string
    my $Counter        = '';
    my $Space          = '';
    my $LastSenderType = '';

    # check if expand view is usable (only for less then 300 articles)
    # if you have more articles is going to be slow and not usable
    my $ArticleMaxLimit = 300;
    if ( $Self->{ZoomExpand} && $#ArticleBox > $ArticleMaxLimit ) {
        $Self->{ZoomExpand} = 0;
    }

    # get shown article(s)
    my @NewArticleBox = ();
    if ( !$Self->{ZoomExpand} ) {
        for my $ArticleTmp (@ArticleBox) {
            if ( $ArticleID eq $ArticleTmp->{ArticleID} ) {
                push( @NewArticleBox, $ArticleTmp );
            }
        }
    }
    else {

        # resort article order
        if ( $Self->{ZoomExpandSort} eq 'reverse' ) {
            @ArticleBox = reverse(@ArticleBox);
        }

        @NewArticleBox = @ArticleBox;
    }

    #

    # build shown article(s)
    my $Count      = 0;
    my $BodyOutput = '';
    for my $ArticleTmp (@NewArticleBox) {
        $Count++;
        my %Article = %$ArticleTmp;

        # check if just a only html email
        if ( my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType( %Param, %Article ) ) {
            $Article{"BodyNote"} = $MimeTypeText;
            $Article{"Body"}     = '';
        }
        else {

            # html quoting
            $Article{"BodyHTML"} = $Self->{LayoutObject}->Ascii2Html(
                NewLine        => $Self->{ConfigObject}->Get('DefaultViewNewLine'),
                Text           => $Article{Body},
                VMax           => $Self->{ConfigObject}->Get('DefaultViewLines') || 5000,
                HTMLResultMode => 1,
                LinkFeature    => 1,
            );

            # do charset check
            if (
                my $CharsetText = $Self->{LayoutObject}->CheckCharset(
                    ContentCharset => $Article{ContentCharset},
                    TicketID       => $Param{TicketID},
                    ArticleID      => $Article{ArticleID}
                )
                )
            {
                $Article{"BodyNote"} = $CharsetText;
            }
        }
        $Self->{LayoutObject}->Block(
            Name => 'Body',
            Data => { %Param, %Article, Body => $Article{"BodyHTML"}, %AclAction },
        );

        # show article tree
        if ( $Count == 1 ) {

            # show status info
            $Self->{LayoutObject}->Block(
                Name => 'Status',
                Data => { %Param, %AclAction },
            );

            # ticket type
            if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Type',
                    Data => { %Param, %AclAction },
                );
            }

            # ticket service
            if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Param{Service} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Service',
                    Data => { %Param, %AclAction },
                );
                if ( $Param{SLA} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'SLA',
                        Data => { %Param, %AclAction },
                    );
                }
            }

            # show first response time if needed
            if ( defined( $Param{FirstResponseTime} ) ) {
                $Param{FirstResponseTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $Param{'FirstResponseTime'},
                    Space => ' ',
                );
                $Param{FirstResponseTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $Param{'FirstResponseTimeWorkingTime'},
                    Space => ' ',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'FirstResponseTime',
                    Data => { %Param, %AclAction },
                );
                if ( 60 * 60 * 1 > $Param{FirstResponseTime} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'FirstResponseTimeFontStart',
                        Data => { %Param, %AclAction },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'FirstResponseTimeFontStop',
                        Data => { %Param, %AclAction },
                    );
                }
            }

            # show update time if needed
            if ( defined( $Param{UpdateTime} ) ) {
                $Param{UpdateTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $Param{'UpdateTime'},
                    Space => ' ',
                );
                $Param{UpdateTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $Param{'UpdateTimeWorkingTime'},
                    Space => ' ',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'UpdateTime',
                    Data => { %Param, %AclAction },
                );
                if ( 60 * 60 * 1 > $Param{UpdateTime} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'UpdateTimeFontStart',
                        Data => { %Param, %AclAction },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'UpdateTimeFontStop',
                        Data => { %Param, %AclAction },
                    );
                }
            }

            # show solution time if needed
            if ( defined( $Param{SolutionTime} ) ) {
                $Param{SolutionTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $Param{'SolutionTime'},
                    Space => ' ',
                );
                $Param{SolutionTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age   => $Param{'SolutionTimeWorkingTime'},
                    Space => ' ',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'SolutionTime',
                    Data => { %Param, %AclAction },
                );
                if ( 60 * 60 * 1 > $Param{SolutionTime} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'SolutionTimeFontStart',
                        Data => { %Param, %AclAction },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'SolutionTimeFontStop',
                        Data => { %Param, %AclAction },
                    );
                }
            }

            # customer info string
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoom') ) {
                $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
                    Data => { %Param, %{ $Param{CustomerData} }, },
                    Max => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoomMaxSize'),
                );
                $Self->{LayoutObject}->Block(
                    Name => 'CustomerTable',
                    Data => \%Param,
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'Owner',
                Data => { %Param, %UserInfo, %AclAction },
            );
            if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Responsible',
                    Data => { %Param, %ResponsibleInfo, %AclAction },
                );
            }

            # get linked objects
            my %Links = $Self->{LinkObject}->AllLinkedObjects(
                Object   => 'Ticket',
                ObjectID => $Self->{TicketID},
                UserID   => $Self->{UserID},
            );
            my %LinkTypeBox = ();
            for my $LinkType (qw(Normal Parent Child)) {
                if ( !$Links{$LinkType} ) {
                    next;
                }
                my %ObjectType = %{ $Links{$LinkType} };
                for my $Object ( sort keys %ObjectType ) {
                    my %Data = %{ $ObjectType{$Object} };
                    for my $Item ( sort keys %Data ) {
                        if ( !$LinkTypeBox{$LinkType} ) {
                            $Self->{LayoutObject}->Block(
                                Name => 'Link',
                                Data => {
                                    %Param,
                                    LinkType => $LinkType,
                                },
                            );
                            $LinkTypeBox{$LinkType} = 1;
                        }
                        $Self->{LayoutObject}->Block(
                            Name => 'LinkItem',
                            Data => {
                                %{ $Data{$Item} },
                                LinkType => $LinkType,
                            },
                        );
                    }
                }
            }

            # ticket free text
            for my $Count ( 1 .. 16 ) {
                if ( $Param{ 'TicketFreeText' . $Count } ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'TicketFreeText' . $Count,
                        Data => { %Param, %AclAction },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'TicketFreeText',
                        Data => {
                            %Param, %AclAction,
                            TicketFreeKey  => $Param{ 'TicketFreeKey' . $Count },
                            TicketFreeText => $Param{ 'TicketFreeText' . $Count },
                            Count          => $Count,
                        },
                    );
                    if ( !$Self->{ConfigObject}->Get( 'TicketFreeText' . $Count . '::Link' ) ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'TicketFreeTextPlain' . $Count,
                            Data => { %Param, %AclAction },
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'TicketFreeTextPlain',
                            Data => {
                                %Param, %AclAction,
                                TicketFreeKey  => $Param{ 'TicketFreeKey' . $Count },
                                TicketFreeText => $Param{ 'TicketFreeText' . $Count },
                                Count          => $Count,
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'TicketFreeTextLink' . $Count,
                            Data => { %Param, %AclAction },
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'TicketFreeTextLink',
                            Data => {
                                %Param, %AclAction,
                                TicketFreeTextLink => $Self->{ConfigObject}->Get(
                                    'TicketFreeText' . $Count . '::Link'
                                ),
                                TicketFreeKey  => $Param{ 'TicketFreeKey' . $Count },
                                TicketFreeText => $Param{ 'TicketFreeText' . $Count },
                                Count          => $Count,
                            },
                        );
                    }
                }
            }

            # ticket free time
            for my $Count ( 1 .. 6 ) {
                if ( $Param{ 'TicketFreeTime' . $Count } ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'TicketFreeTime' . $Count,
                        Data => { %Param, %AclAction },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'TicketFreeTime',
                        Data => {
                            %Param, %AclAction,
                            TicketFreeTimeKey =>
                                $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                            TicketFreeTime => $Param{ 'TicketFreeTime' . $Count },
                            Count          => $Count,
                        },
                    );
                }
            }

            # build thread string
            $Self->{LayoutObject}->Block(
                Name => 'Tree',
                Data => { %Param, %Article, %AclAction },
            );
            my $CounterTree    = 0;
            my $Counter        = '';
            my $Space          = '';
            my $LastSenderType = '';
            for my $ArticleTmp (@ArticleBox) {
                my %Article = %$ArticleTmp;
                my $Start   = '';
                my $Stop    = '';
                my $Start2  = '';
                my $Stop2   = '';
                $CounterTree++;
                my $TmpSubject = $Self->{TicketObject}->TicketSubjectClean(
                    TicketNumber => $Article{TicketNumber},
                    Subject => $Article{Subject} || '',
                );
                if ( $LastSenderType ne $Article{SenderType} ) {
                    $Counter .= "&nbsp;";
                    $Space = "$Counter&nbsp;|--&gt;";
                }
                $LastSenderType = $Article{SenderType};

                # if this is the shown article -=> add <b>
                if ( $ArticleID eq $Article{ArticleID} ) {
                    $Start  = '<i><u>';
                    $Start2 = '<b>';
                }

                # if this is the shown article -=> add </b>
                if ( $ArticleID eq $Article{ArticleID} ) {
                    $Stop  = '</u></i>';
                    $Stop2 = '</b>';
                }

                # check if we need to show also expand/collapse icon
                $Self->{LayoutObject}->Block(
                    Name => 'TreeItem',
                    Data => {
                        %Article,
                        Subject        => $TmpSubject,
                        Space          => $Space,
                        Start          => $Start,
                        Stop           => $Stop,
                        Start2         => $Start2,
                        Stop2          => $Stop2,
                        Count          => $CounterTree,
                        ZoomExpand     => $Self->{ZoomExpand},
                        ZoomExpandSort => $Self->{ZoomExpandSort},
                    },
                );

                # show plain link
                if (
                    $Self->{ConfigObject}->Get('Ticket::Frontend::PlainView')
                    && $Article{ArticleType} =~ /^email/
                    )
                {
                    $Self->{LayoutObject}->Block(
                        Name => 'TreeItemEmail',
                        Data => { %Article, },
                    );
                }

                # add attachment icons
                if (
                    $Article{Atms}
                    && %{ $Article{Atms} }
                    && $Self->{ConfigObject}->Get('Ticket::ZoomAttachmentDisplay')
                    )
                {
                    my $Title = '';

                    # download type
                    my $Type = $Self->{ConfigObject}->Get('AttachmentDownloadType')
                        || 'attachment';

                    # if attachment will be forced to download, don't open a new download window!
                    my $Target = '';
                    if ( $Type =~ /inline/i ) {
                        $Target = 'target="attachment" ';
                    }
                    my $ZoomAttachmentDisplayCount
                        = $Self->{ConfigObject}->Get('Ticket::ZoomAttachmentDisplayCount');
                    for my $Count ( 1 .. ( $ZoomAttachmentDisplayCount + 1 ) ) {
                        if ( $Article{Atms}->{$Count} ) {
                            if ( $Count > $ZoomAttachmentDisplayCount ) {
                                $Self->{LayoutObject}->Block(
                                    Name => 'TreeItemAttachmentMore',
                                    Data => {
                                        %Article,
                                        %{ $Article{Atms}->{$Count} },
                                        FileID => $Count,
                                        Target => $Target,
                                    },
                                );
                            }
                            elsif ( $Article{Atms}->{$Count} ) {
                                $Self->{LayoutObject}->Block(
                                    Name => 'TreeItemAttachment',
                                    Data => {
                                        %Article,
                                        %{ $Article{Atms}->{$Count} },
                                        FileID => $Count,
                                        Target => $Target,
                                    },
                                );
                            }
                        }
                    }
                }
            }
        }

        # check if expand/cpllapse view is usable (only for less then 300 articles)
        if ( $Count == 1 && $#ArticleBox < $ArticleMaxLimit ) {
            if ( $Self->{ZoomExpand} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Collapse',
                    Data => {
                        %Article,
                        ArticleID      => $ArticleID,
                        ZoomExpand     => $Self->{ZoomExpand},
                        ZoomExpandSort => $Self->{ZoomExpandSort},
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'Expand',
                    Data => {
                        %Article,
                        ArticleID      => $ArticleID,
                        ZoomExpand     => $Self->{ZoomExpand},
                        ZoomExpandSort => $Self->{ZoomExpandSort},
                    },
                );
            }
        }

        # do some strips && quoting
        for (qw(From To Cc Subject)) {
            if ( $Article{$_} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        Key   => $_,
                        Value => $Article{$_},
                    },
                );
            }
        }

        # show accounted article time
        if ( $Self->{ConfigObject}->Get('Ticket::ZoomTimeDisplay') ) {
            my $ArticleTime = $Self->{TicketObject}->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID}
            );
            $Self->{LayoutObject}->Block(
                Name => "Row",
                Data => {
                    Key   => 'Time',
                    Value => $ArticleTime,
                },
            );
        }

        # show article free text
        for ( 1 .. 3 ) {
            if ( $Article{"ArticleFreeText$_"} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleFreeText',
                    Data => {
                        Key   => $Article{"ArticleFreeKey$_"},
                        Value => $Article{"ArticleFreeText$_"},
                    },
                );
            }
        }

        # run article modules
        if ( ref( $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleViewModule') ) eq 'HASH' ) {
            my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleViewModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( $Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                    my $Object = $Jobs{$Job}->{Module}->new(
                        %{$Self},
                        TicketID  => $Self->{TicketID},
                        ArticleID => $Article{ArticleID},
                    );

                    # run module
                    my @Data
                        = $Object->Check( Article => \%Article, %Param, Config => $Jobs{$Job} );
                    for my $DataRef (@Data) {
                        $Self->{LayoutObject}->Block(
                            Name => 'ArticleOption',
                            Data => $DataRef,
                        );
                    }

                    # filter option
                    $Object->Filter( Article => \%Article, %Param, Config => $Jobs{$Job} );
                }
                else {
                    return $Self->{LayoutObject}->ErrorScreen();
                }
            }
        }

        # get StdResponsesStrg
        $Param{StdResponsesStrg} = $Self->{LayoutObject}->TicketStdResponseString(
            StdResponsesRef => $Param{StdResponses},
            TicketID        => $Param{TicketID},
            ArticleID       => $Article{ArticleID},
        );

        # get attacment string
        my %AtmIndex = ();
        if ( $Article{Atms} ) {

            %AtmIndex = %{ $Article{Atms} };
        }

        # add block for attachments
        if (%AtmIndex) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachment',
                Data => { Key => 'Attachment', },
            );
        }
        for my $FileID ( sort keys %AtmIndex ) {
            my %File = %{ $AtmIndex{$FileID} };
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachmentRow',
                Data => { %File, },
            );

            # run article attachment modules
            if (
                ref( $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleAttachmentModule') ) eq
                'HASH'
                )
            {
                my %Jobs
                    = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleAttachmentModule') };
                for my $Job ( sort keys %Jobs ) {

                    # load module
                    if ( $Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                        my $Object = $Jobs{$Job}->{Module}->new(
                            %{$Self},
                            TicketID  => $Self->{TicketID},
                            ArticleID => $Article{ArticleID},
                        );

                        # run module
                        my %Data = $Object->Run(
                            File => { %File, FileID => $FileID, },
                            Article => \%Article,
                        );
                        if (%Data) {
                            $Self->{LayoutObject}->Block(
                                Name => $Data{Block} || 'ArticleAttachmentRowLink',
                                Data => {%Data},
                            );
                        }
                    }
                    else {
                        return $Self->{LayoutObject}->ErrorScreen();
                    }
                }
            }
        }

        # select the output template
        if ( $Article{ArticleType} =~ /^note/i ) {

            # without compose links!
            if (
                $Param{CustomerUserID}
                && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i
                && $Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer')
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'AgentIsCustomer',
                    Data => { %Param, %Article, %AclAction },
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'AgentArticleCom',
                Data => { %Param, %Article, %AclAction },
            );

            # check if print link should be shown
            if (
                $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPrint}
                && ( !defined( $AclAction{AgentTicketPrint} ) || $AclAction{AgentTicketPrint} )
                )
            {
                my $OK = $Self->{TicketObject}->Permission(
                    Type     => 'ro',
                    TicketID => $Param{TicketID},
                    UserID   => $Self->{UserID},
                    LogNo    => 1,
                );
                if ($OK) {
                    $Self->{LayoutObject}->Block(
                        Name => 'AgentArticleComPrint',
                        Data => { %Param, %Article, %AclAction },
                    );
                }
            }

        }
        else {

            # without all!
            if (
                $Param{CustomerUserID}
                && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i
                && $Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer')
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

                # check if compose link should be shown
                if (
                    $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketCompose}
                    && (
                        !defined( $AclAction{AgentTicketCompose} )
                        || $AclAction{AgentTicketCompose}
                    )
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
                    }
                    if ( $Config->{RequiredLock} ) {
                        if (
                            $Self->{TicketObject}->LockIsTicketLocked(
                                TicketID => $Param{TicketID}
                            )
                            )
                        {
                            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                                TicketID => $Param{TicketID},
                                OwnerID  => $Self->{UserID},
                            );
                            if ( !$AccessOk ) {
                                $Access = 0;
                            }
                        }
                    }
                    if ($Access) {
                        $Self->{LayoutObject}->Block(
                            Name => 'AgentAnswerCompose',
                            Data => { %Param, %Article, %AclAction },
                        );
                    }
                }

                # check if phone link should be shown
                if (
                    $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPhoneOutbound}
                    && (
                        !defined( $AclAction{AgentTicketPhoneOutbound} )
                        || $AclAction{AgentTicketPhoneOutbound}
                    )
                    )
                {
                    my $Access = 1;
                    my $Config
                        = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketPhoneOutbound");
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
                    if ( $Config->{RequiredLock} ) {
                        if (
                            $Self->{TicketObject}->LockIsTicketLocked(
                                TicketID => $Param{TicketID}
                            )
                            )
                        {
                            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                                TicketID => $Param{TicketID},
                                OwnerID  => $Self->{UserID},
                            );
                            if ( !$AccessOk ) {
                                $Access = 0;
                            }
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
            $Self->{LayoutObject}->Block(
                Name => 'AgentArticleCom',
                Data => { %Param, %Article, %AclAction },
            );

            # check if print link should be shown
            if (
                $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPrint}
                && ( !defined( $AclAction{AgentTicketPrint} ) || $AclAction{AgentTicketPrint} )
                )
            {
                my $OK = $Self->{TicketObject}->Permission(
                    Type     => 'ro',
                    TicketID => $Param{TicketID},
                    UserID   => $Self->{UserID},
                    LogNo    => 1,
                );
                if ($OK) {
                    $Self->{LayoutObject}->Block(
                        Name => 'AgentArticleComPrint',
                        Data => { %Param, %Article, %AclAction },
                    );
                }
            }

            # check if forward link should be shown
            if (
                $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketForward}
                && ( !defined( $AclAction{AgentTicketForward} ) || $AclAction{AgentTicketForward} )
                )
            {
                my $Access = 1;
                my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketForward");
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
                if ( $Config->{RequiredLock} ) {
                    if ( $Self->{TicketObject}->LockIsTicketLocked( TicketID => $Param{TicketID} ) )
                    {
                        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                            TicketID => $Param{TicketID},
                            OwnerID  => $Self->{UserID},
                        );
                        if ( !$AccessOk ) {
                            $Access = 0;
                        }
                    }
                }
                if ($Access) {
                    $Self->{LayoutObject}->Block(
                        Name => 'AgentArticleComForward',
                        Data => { %Param, %Article, %AclAction },
                    );
                }
            }

            # check if bounce link should be shown
            if (
                $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketBounce}
                && ( !defined( $AclAction{AgentTicketBounce} ) || $AclAction{AgentTicketBounce} )
                )
            {
                my $Access = 1;
                my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketBounce");
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
                if ( $Config->{RequiredLock} ) {
                    if ( $Self->{TicketObject}->LockIsTicketLocked( TicketID => $Param{TicketID} ) )
                    {
                        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                            TicketID => $Param{TicketID},
                            OwnerID  => $Self->{UserID},
                        );
                        if ( !$AccessOk ) {
                            $Access = 0;
                        }
                    }
                }
                if ($Access) {
                    $Self->{LayoutObject}->Block(
                        Name => 'AgentArticleComBounce',
                        Data => { %Param, %Article, %AclAction },
                    );
                }
            }

            # check if split link should be shown
            if (
                $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPhone}
                && ( !defined( $AclAction{AgentTicketPhone} ) || $AclAction{AgentTicketPhone} )
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'AgentArticleComPhone',
                    Data => { %Param, %Article, %AclAction },
                );
            }
        }
    }

    # get MoveQueuesStrg
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') =~ /^form$/i ) {
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name       => 'DestQueueID',
            Data       => $Param{MoveQueues},
            SelectedID => $Param{QueueID},
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
    $Self->{LayoutObject}->Block(
        Name => 'Footer',
        Data => { %Param, %AclAction },
    );

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketZoom',
        Data => { %Param, %AclAction },
    );
}

1;
