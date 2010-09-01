# --
# Kernel/Modules/AgentTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketZoom.pm,v 1.114 2010-09-01 09:54:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketZoom;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.114 $) [1];

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
    if ( !defined $Self->{ZoomExpand} ) {
        $Self->{ZoomExpand} = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomExpand');
    }
    if ( !defined $Self->{ZoomExpandSort} ) {
        $Self->{ZoomExpandSort} = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomExpandSort');
    }
    my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketQueue');
    if ($Config) {
        $Self->{HighlightColor1} = $Config->{HighlightColor1} || 'orange';
        $Self->{HighlightColor2} = $Config->{HighlightColor2} || 'red';
    }
    $Self->{ArticleFilterActive}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::TicketArticleFilter');

    # define if rich text should be used
    $Self->{RichText}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomRichTextForce')
        || $Self->{LayoutObject}->{BrowserRichText}
        || 0;

    # strip html and ascii attachments of content
    $Self->{StripPlainBodyAsAttachment} = 1;

    # check if rich text is enabled, if not only stip ascii attachments
    if ( !$Self->{RichText} ) {
        $Self->{StripPlainBodyAsAttachment} = 2;
    }

    # ticket id lookup
    if ( !$Self->{TicketID} && $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ) ) {
        $Self->{TicketID} = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ),
            UserID => $Self->{UserID},
        );
    }
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get ticket attributes
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

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

    # article update
    if ( $Self->{Subaction} eq 'ArticleUpdate' ) {
        my $Count = $Self->{ParamObject}->GetParam( Param => 'Count' );
        my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );
        $Article{Count} = $Count;

        # get attachment index (without attachments)
        my %AtmIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID                  => $Self->{ArticleID},
            StripPlainBodyAsAttachment => $Self->{StripPlainBodyAsAttachment},
            Article                    => \%Article,
            UserID                     => $Self->{UserID},
        );
        $Article{Atms} = \%AtmIndex;

        # fetch all std. responses
        my %StandardResponses = $Self->{QueueObject}->GetStandardResponses(
            QueueID => $Ticket{QueueID},
        );

        my $Content = $Self->_ArticleItem(
            Ticket            => \%Ticket,
            Article           => \%Article,
            AclAction         => \%AclAction,
            StandardResponses => \%StandardResponses,
            Type              => 'OnLoad',
        );
        if ( !$Content ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't get for ArticleID $Self->{ArticleID}!",
            );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Content     => $Content,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # write article filter settings to session
    if ( $Self->{Subaction} eq 'ArticleFilterSet' ) {

        # get params
        my $TicketID     = $Self->{ParamObject}->GetParam( Param => 'TicketID' );
        my $SaveDefaults = $Self->{ParamObject}->GetParam( Param => 'SaveDefaults' );
        my @ArticleTypeFilterIDs = $Self->{ParamObject}->GetArray( Param => 'ArticleTypeFilter' );
        my @ArticleSenderTypeFilterIDs
            = $Self->{ParamObject}->GetArray( Param => 'ArticleSenderTypeFilter' );

        # build session string
        my $SessionString = '';
        if (@ArticleTypeFilterIDs) {
            $SessionString .= 'ArticleTypeFilter<';
            $SessionString .= join ',', @ArticleTypeFilterIDs;
            $SessionString .= '>';
        }
        if (@ArticleSenderTypeFilterIDs) {
            $SessionString .= 'ArticleSenderTypeFilter<';
            $SessionString .= join ',', @ArticleSenderTypeFilterIDs;
            $SessionString .= '>';
        }

        # write the session

        # save default filter settings to user preferences
        if ($SaveDefaults) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key    => 'ArticleFilterDefault',
                Value  => $SessionString,
            );
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'ArticleFilterDefault',
                Value     => $SessionString,
            );
        }

        # turn off filter explicitly for this ticket
        if ( $SessionString eq '' ) {
            $SessionString = 'off';
        }

        # update the session
        my $Update = $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => "ArticleFilter$TicketID",
            Value     => $SessionString,
        );

        # build JSON output
        my $JSON = '';
        if ($Update) {
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    Message => 'Article filter settings were saved.',
                },
            );
        }

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # store last screen
    if ( $Self->{Subaction} ne 'ShowHTMLeMail' ) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $Self->{RequestedURL},
        );
    }

    # article filter is activated in sysconfig
    if ( $Self->{ArticleFilterActive} ) {

        # get article filter settings from session string
        my $ArticleFilterSessionString = $Self->{ 'ArticleFilter' . $Self->{TicketID} };

        # set article filter for this ticket from user preferences
        if ( !$ArticleFilterSessionString ) {
            $ArticleFilterSessionString = $Self->{ArticleFilterDefault};
        }

        # do not use defaults for this ticket if filter was explicitly turned off
        elsif ( $ArticleFilterSessionString eq 'off' ) {
            $ArticleFilterSessionString = '';
        }

        # extract ArticleTypeIDs
        if (
            $ArticleFilterSessionString
            && $ArticleFilterSessionString =~ m{ ArticleTypeFilter < ( [^<>]+ ) > }xms
            )
        {
            my @IDs = split /,/, $1;
            $Self->{ArticleFilter}->{ArticleTypeID} = { map { $_ => 1 } @IDs };
        }

        # extract ArticleSenderTypeIDs
        if (
            $ArticleFilterSessionString
            && $ArticleFilterSessionString =~ m{ ArticleSenderTypeFilter < ( [^<>]+ ) > }xms
            )
        {
            my @IDs = split /,/, $1;
            $Self->{ArticleFilter}->{SenderTypeID} = { map { $_ => 1 } @IDs };
        }
    }

    # return if HTML email
    if ( $Self->{Subaction} eq 'ShowHTMLeMail' ) {

        # check needed ArticleID
        if ( !$Self->{ArticleID} ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need ArticleID!' );
        }

        # get article data
        my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );

        # check if article data exists
        if ( !%Article ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Invalid ArticleID!' );
        }

        # if it is a html email, return here
        return $Self->{LayoutObject}->Attachment(
            Filename => $Self->{ConfigObject}->Get('Ticket::Hook')
                . "-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
            Type        => 'inline',
            ContentType => "$Article{MimeType}; charset=$Article{Charset}",
            Content     => $Article{Body},
        );
    }

    # generate output
    my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{TicketNumber} );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->MaskAgentZoom( Ticket => \%Ticket, AclAction => \%AclAction );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub MaskAgentZoom {
    my ( $Self, %Param ) = @_;

    my %Ticket    = %{ $Param{Ticket} };
    my %AclAction = %{ $Param{AclAction} };

    # else show normal ticket zoom view
    # fetch all move queues
    my %MoveQueues = $Self->{TicketObject}->MoveList(
        TicketID => $Ticket{TicketID},
        UserID   => $Self->{UserID},
        Action   => $Self->{Action},
        Type     => 'move_into',
    );

    # fetch all std. responses
    my %StandardResponses
        = $Self->{QueueObject}->GetStandardResponses( QueueID => $Ticket{QueueID} );

    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->TicketAccountedTimeGet(%Ticket);

    # owner info
    my %OwnerInfo = $Self->{UserObject}->GetUserData(
        UserID => $Ticket{OwnerID},
    );

    # responsible info
    my %ResponsibleInfo = $Self->{UserObject}->GetUserData(
        UserID => $Ticket{ResponsibleID} || 1,
    );

    # generate shown articles

    # get content
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(
        TicketID                   => $Self->{TicketID},
        StripPlainBodyAsAttachment => $Self->{StripPlainBodyAsAttachment},
        UserID                     => $Self->{UserID},
    );

    # add counter
    my $Count = 0;
    for my $Article (@ArticleBox) {
        $Count++;
        $Article->{Count} = $Count;
    }

    # get selected or last customer article
    my $ArticleID;
    if ( $Self->{ArticleID} ) {
        $ArticleID = $Self->{ArticleID};
    }
    else {

        # find latest not seen article
        for my $Article (@ArticleBox) {
            my %ArticleFlag = $Self->{TicketObject}->ArticleFlagGet(
                ArticleID => $Article->{ArticleID},
                UserID    => $Self->{UserID},
            );
            next if $ArticleFlag{Seen} || $ArticleFlag{seen};
            $ArticleID = $Article->{ArticleID};
            last;
        }

        # set first article as default
        if ( !$ArticleID ) {
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
    }

    # remember shown article ids if article filter is activated in sysconfig
    if ( $Self->{ArticleFilterActive} && $Self->{ArticleFilter} ) {

        # reset shown article ids
        $Self->{ArticleFilter}->{ShownArticleIDs} = undef;

        my $NewArticleID = '';
        my $Count        = 0;

        ARTICLE:
        for my $Article (@ArticleBox) {

            # article type id does not match
            if (
                $Self->{ArticleFilter}->{ArticleTypeID}
                && !$Self->{ArticleFilter}->{ArticleTypeID}->{ $Article->{ArticleTypeID} }
                )
            {
                next ARTICLE;
            }

            # article sender type id does not match
            if (
                $Self->{ArticleFilter}->{SenderTypeID}
                && !$Self->{ArticleFilter}->{SenderTypeID}->{ $Article->{SenderTypeID} }
                )
            {
                next ARTICLE;
            }

            # count shown articles
            $Count++;

            # remember article id
            $Self->{ArticleFilter}->{ShownArticleIDs}->{ $Article->{ArticleID} } = 1;

            # set article id to first shown article
            if ( $Count == 1 ) {
                $NewArticleID = $Article->{ArticleID};
            }

            # set article id to last shown customer article
            if ( $Article->{SenderType} eq 'customer' ) {
                $NewArticleID = $Article->{ArticleID};
            }
        }

        # change article id if it was filtered out
        if ( $NewArticleID && !$Self->{ArticleFilter}->{ShownArticleIDs}->{$ArticleID} ) {
            $ArticleID = $NewArticleID;
        }

        # add current article id
        $Self->{ArticleFilter}->{ShownArticleIDs}->{$ArticleID} = 1;
    }

    # check if expand view is usable (only for less then 400 article)
    # if you have more articles is going to be slow and not usable
    my $ArticleMaxLimit = 400;
    if ( $Self->{ZoomExpand} && $#ArticleBox > $ArticleMaxLimit ) {
        $Self->{ZoomExpand} = 0;
    }

    # get shown article(s)
    my @ArticleBoxShown;
    if ( !$Self->{ZoomExpand} ) {
        for my $ArticleTmp (@ArticleBox) {
            if ( $ArticleID eq $ArticleTmp->{ArticleID} ) {
                push @ArticleBoxShown, $ArticleTmp;
            }
        }
    }
    else {
        @ArticleBoxShown = @ArticleBox;
    }

    # resort article order
    if ( $Self->{ZoomExpandSort} ne 'reverse' ) {
        @ArticleBox      = reverse @ArticleBox;
        @ArticleBoxShown = reverse @ArticleBoxShown;
    }

    # show article tree
    $Param{ArticleTree} = $Self->_ArticleTree(
        Ticket          => \%Ticket,
        ArticleID       => $ArticleID,
        ArticleMaxLimit => $ArticleMaxLimit,
        ArticleBox      => \@ArticleBox,
    );

    # show articles items
    $Param{ArticleItems} = '';
    for my $ArticleTmp (@ArticleBoxShown) {
        my %Article = %$ArticleTmp;

        # article filter is activated in sysconfig and there are articles that passed the filter
        if ( $Self->{ArticleFilterActive} ) {
            if ( $Self->{ArticleFilter} && $Self->{ArticleFilter}->{ShownArticleIDs} ) {

                # do not show article if it does not match the filter
                if ( !$Self->{ArticleFilter}->{ShownArticleIDs}->{ $Article{ArticleID} } ) {
                    next;
                }
            }
        }

        $Param{ArticleItems} .= $Self->_ArticleItem(
            Ticket            => \%Ticket,
            Article           => \%Article,
            AclAction         => \%AclAction,
            StandardResponses => \%StandardResponses,
            Type              => 'Static',
        );
    }

    # age design
    $Ticket{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Ticket{Age}, Space => ' ' );
    if ( $Ticket{UntilTime} ) {
        if ( $Ticket{UntilTime} < -1 && $Self->{HighlightColor2} ) {
            $Ticket{PendingUntil} = qq§<span style="color: $Self->{HighlightColor2};">§;
        }
        $Ticket{PendingUntil} .= $Self->{LayoutObject}->CustomerAge(
            Age   => $Ticket{UntilTime},
            Space => '<br/>'
        );
        if ( $Ticket{UntilTime} < -1 && $Self->{HighlightColor2} ) {
            $Ticket{PendingUntil} .= "</span>";
        }
    }

    # number of articles
    $Param{ArticleCount} = scalar @ArticleBox;

    $Self->{LayoutObject}->Block(
        Name => 'Header',
        Data => { %Param, %Ticket, %AclAction },
    );

    # run ticket menu modules
    if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule') };
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
            }

            my $Object = $Menus{$Menu}->{Module}->new( %{$Self}, TicketID => $Self->{TicketID}, );

            # run module
            my $Item = $Object->Run(
                %Param,
                Ticket => \%Ticket,
                ACL    => \%AclAction,
                Config => $Menus{$Menu},
            );
            next if !$Item;
            if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                $Item->{Class} = 'AsPopup';
            }
            $Self->{LayoutObject}->Block(
                Name => 'TicketMenu',
                Data => $Item,
            );
        }
    }

    # get MoveQueuesStrg
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') =~ /^form$/i ) {
        $MoveQueues{0}
            = '- ' . $Self->{LayoutObject}->{LanguageObject}->Get('Move') . ' -';
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => \%MoveQueues,
        );
    }
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketMove}
        && ( !defined $AclAction{AgentTicketMove} || $AclAction{AgentTicketMove} )
        )
    {
        my $Access = $Self->{TicketObject}->TicketPermission(
            Type     => 'move',
            TicketID => $Ticket{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
        $Param{TicketID} = $Ticket{TicketID};
        if ($Access) {
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') =~ /^form$/i ) {
                $Self->{LayoutObject}->Block(
                    Name => 'MoveLink',
                    Data => { %Param, %AclAction },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'MoveForm',
                    Data => { %Param, %AclAction },
                );
            }
        }
    }

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'Ticket',
        Key    => $Self->{TicketID},
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

    # ticket type
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Self->{LayoutObject}->Block(
            Name => 'Type',
            Data => { %Ticket, %AclAction },
        );
    }

    # ticket service
    if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Ticket{Service} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Service',
            Data => { %Ticket, %AclAction },
        );
        if ( $Ticket{SLA} ) {
            $Self->{LayoutObject}->Block(
                Name => 'SLA',
                Data => { %Ticket, %AclAction },
            );
        }
    }

    # show first response time if needed
    if ( defined $Ticket{FirstResponseTime} ) {
        $Ticket{FirstResponseTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Ticket{FirstResponseTime},
            Space => ' ',
        );
        $Ticket{FirstResponseTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Ticket{FirstResponseTimeWorkingTime},
            Space => ' ',
        );
        $Self->{LayoutObject}->Block(
            Name => 'FirstResponseTime',
            Data => { %Ticket, %AclAction },
        );
        if ( 60 * 60 * 1 > $Ticket{FirstResponseTime} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FirstResponseTimeFontStart',
                Data => { %Ticket, %AclAction },
            );
            $Self->{LayoutObject}->Block(
                Name => 'FirstResponseTimeFontStop',
                Data => { %Ticket, %AclAction },
            );
        }
    }

    # show update time if needed
    if ( defined $Ticket{UpdateTime} ) {
        $Ticket{UpdateTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Ticket{UpdateTime},
            Space => ' ',
        );
        $Ticket{UpdateTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Ticket{UpdateTimeWorkingTime},
            Space => ' ',
        );
        $Self->{LayoutObject}->Block(
            Name => 'UpdateTime',
            Data => { %Ticket, %AclAction },
        );
        if ( 60 * 60 * 1 > $Ticket{UpdateTime} ) {
            $Self->{LayoutObject}->Block(
                Name => 'UpdateTimeFontStart',
                Data => { %Ticket, %AclAction },
            );
            $Self->{LayoutObject}->Block(
                Name => 'UpdateTimeFontStop',
                Data => { %Ticket, %AclAction },
            );
        }
    }

    # show solution time if needed
    if ( defined $Ticket{SolutionTime} ) {
        $Ticket{SolutionTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Ticket{SolutionTime},
            Space => ' ',
        );
        $Ticket{SolutionTimeWorkingTime} = $Self->{LayoutObject}->CustomerAgeInHours(
            Age   => $Ticket{SolutionTimeWorkingTime},
            Space => ' ',
        );
        $Self->{LayoutObject}->Block(
            Name => 'SolutionTime',
            Data => { %Ticket, %AclAction },
        );
        if ( 60 * 60 * 1 > $Ticket{SolutionTime} ) {
            $Self->{LayoutObject}->Block(
                Name => 'SolutionTimeFontStart',
                Data => { %Ticket, %AclAction },
            );
            $Self->{LayoutObject}->Block(
                Name => 'SolutionTimeFontStop',
                Data => { %Ticket, %AclAction },
            );
        }
    }

    # show pending until, if set:
    if ( defined $Ticket{PendingUntil} ) {
        $Self->{LayoutObject}->Block(
            Name => 'PendingUntil',
            Data => { %Ticket, }
        );
    }

    # show owner
    $Self->{LayoutObject}->Block(
        Name => 'Owner',
        Data => { %Ticket, %OwnerInfo, %AclAction },
    );

    # show responsible
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
        $Self->{LayoutObject}->Block(
            Name => 'Responsible',
            Data => { %Ticket, %ResponsibleInfo, %AclAction },
        );
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        next if !$Ticket{ 'TicketFreeText' . $Count };
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText' . $Count,
            Data => { %Ticket, %AclAction },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText',
            Data => {
                %Ticket, %AclAction,
                TicketFreeKey  => $Ticket{ 'TicketFreeKey' . $Count },
                TicketFreeText => $Ticket{ 'TicketFreeText' . $Count },
                Count          => $Count,
            },
        );
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeText' . $Count . '::Link' ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextPlain' . $Count,
                Data => { %Ticket, %AclAction },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextPlain',
                Data => {
                    %Ticket, %AclAction,
                    TicketFreeKey  => $Ticket{ 'TicketFreeKey' . $Count },
                    TicketFreeText => $Ticket{ 'TicketFreeText' . $Count },
                    Count          => $Count,
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextLink' . $Count,
                Data => { %Ticket, %AclAction },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextLink',
                Data => {
                    %Ticket, %AclAction,
                    TicketFreeTextLink => $Self->{ConfigObject}->Get(
                        'TicketFreeText' . $Count . '::Link'
                    ),
                    TicketFreeKey  => $Ticket{ 'TicketFreeKey' . $Count },
                    TicketFreeText => $Ticket{ 'TicketFreeText' . $Count },
                    Count          => $Count,
                },
            );
        }
    }

    # ticket free time
    for my $Count ( 1 .. 6 ) {
        next if !$Ticket{ 'TicketFreeTime' . $Count };
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime' . $Count,
            Data => { %Ticket, %AclAction },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime',
            Data => {
                %Ticket, %AclAction,
                TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                TicketFreeTime    => $Ticket{ 'TicketFreeTime' . $Count },
                Count             => $Count,
            },
        );
    }

    # customer info string
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoom') ) {

        # customer info
        my %CustomerData;
        if ( $Ticket{CustomerUserID} ) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data   => \%CustomerData,
            Ticket => \%Ticket,
            Max    => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoomMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # get link table view mode
    my $LinkTableViewMode = $Self->{ConfigObject}->Get('LinkObject::ViewMode');

    # create the link table
    my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithData,
        ViewMode         => $LinkTableViewMode,
    );

    # output the simple link table
    if ( $LinkTableStrg && $LinkTableViewMode eq 'Simple' ) {
        $Self->{LayoutObject}->Block(
            Name => 'LinkTableSimple',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
    }

    # output the complex link table
    if ( $LinkTableStrg && $LinkTableViewMode eq 'Complex' ) {
        $Self->{LayoutObject}->Block(
            Name => 'LinkTableComplex',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
    }

    # article filter is activated in sysconfig
    if ( $Self->{ArticleFilterActive} ) {

        # get article types
        my %ArticleTypes = $Self->{TicketObject}->ArticleTypeList(
            Result => 'HASH',
        );

        # build article type list for filter dialog
        $Param{ArticleTypeFilterString} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%ArticleTypes,
            SelectedID  => [ keys %{ $Self->{ArticleFilter}->{ArticleTypeID} } ],
            Translation => 1,
            Multiple    => 1,
            Sort        => 'AlphanumericValue',
            Name        => 'ArticleTypeFilter',
        );

        # get sender types
        my %ArticleSenderTypes = $Self->{TicketObject}->ArticleSenderTypeList(
            Result => 'HASH',
        );

        # build article sender type list for filter dialog
        $Param{ArticleSenderTypeFilterString} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%ArticleSenderTypes,
            SelectedID  => [ keys %{ $Self->{ArticleFilter}->{SenderTypeID} } ],
            Translation => 1,
            Multiple    => 1,
            Sort        => 'AlphanumericValue',
            Name        => 'ArticleSenderTypeFilter',
        );

        # Ticket ID
        $Param{TicketID} = $Self->{TicketID};

        $Self->{LayoutObject}->Block(
            Name => 'ArticleFilterDialog',
            Data => {%Param},
        );
    }

    # check if ticket need to be marked as seen
    my $ArticleAllSeen = 1;
    for my $Article (@ArticleBox) {
        my %ArticleFlag = $Self->{TicketObject}->ArticleFlagGet(
            ArticleID => $Article->{ArticleID},
            UserID    => $Self->{UserID},
        );

        # last if article was not shown
        if ( !$ArticleFlag{Seen} && !$ArticleFlag{seen} ) {
            $ArticleAllSeen = 0;
            last;
        }
    }

    # mark ticket as seen if all article are shown
    if ($ArticleAllSeen) {
        $Self->{TicketObject}->TicketFlagSet(
            TicketID => $Self->{TicketID},
            Key      => 'Seen',
            Value    => 1,
            UserID   => $Self->{UserID},
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketZoom',
        Data => { %Param, %Ticket, %AclAction },
    );
}

sub _ArticleTree {
    my ( $Self, %Param ) = @_;

    my %Ticket          = %{ $Param{Ticket} };
    my @ArticleBox      = @{ $Param{ArticleBox} };
    my $ArticleMaxLimit = $Param{ArticleMaxLimit};
    my $ArticleID       = $Param{ArticleID};

    # build thread string
    $Self->{LayoutObject}->Block(
        Name => 'Tree',
        Data => {%Param},
    );

    # check if expand/collapse view is usable (only for less then 300 articles)
    if ( $#ArticleBox < $ArticleMaxLimit ) {
        if ( $Self->{ZoomExpand} ) {
            $Self->{LayoutObject}->Block(
                Name => 'Collapse',
                Data => {
                    %Ticket,
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
                    %Ticket,
                    ArticleID      => $ArticleID,
                    ZoomExpand     => $Self->{ZoomExpand},
                    ZoomExpandSort => $Self->{ZoomExpandSort},
                },
            );
        }
    }

    # article filter is activated in sysconfig
    if ( $Self->{ArticleFilterActive} ) {

        # define highlight style for links if filter is active
        my $HighlightStyle = 'menu';
        if ( $Self->{ArticleFilter} ) {
            $HighlightStyle = 'PriorityID-5';
        }

        # build article filter links
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFilterDialogLink',
            Data => {
                %Param,
                HighlightStyle => $HighlightStyle,
            },
        );

        # build article filter reset link only if filter is set
        if ( $Self->{ArticleFilter} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleFilterResetLink',
                Data => {%Param},
            );
        }
    }

    # show article tree
    for my $ArticleTmp (@ArticleBox) {
        my %Article = %$ArticleTmp;

        # article filter is activated in sysconfig and there are articles
        # that passed the filter
        if ( $Self->{ArticleFilterActive} ) {
            if ( $Self->{ArticleFilter} && $Self->{ArticleFilter}->{ShownArticleIDs} ) {

                # do not show article in tree if it does not match the filter
                if ( !$Self->{ArticleFilter}->{ShownArticleIDs}->{ $Article{ArticleID} } ) {
                    next;
                }
            }
        }

        # show article flags
        my $Class       = '';
        my $ClassRow    = '';
        my $NewArticle  = 0;
        my %ArticleFlag = $Self->{TicketObject}->ArticleFlagGet(
            ArticleID => $Article{ArticleID},
            UserID    => $Self->{UserID},
        );
        if ( !$ArticleFlag{Seen} && !$ArticleFlag{seen} ) {
            $NewArticle = 1;

            # show ticket flags
            $Class    .= ' UnreadArticles';
            $ClassRow .= ' UnreadArticles';

            # just show ticket flags if agent belongs to the ticket
            my $ShowMeta;
            if (
                $Self->{UserID} == $Article{OwnerID}
                || $Self->{UserID} == $Article{ResponsibleID}
                )
            {
                $ShowMeta = 1;
            }
            if ( !$ShowMeta && $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
                my %Watch = $Self->{TicketObject}->TicketWatchGet(
                    TicketID => $Article{TicketID},
                );
                if ( $Watch{ $Self->{UserID} } ) {
                    $ShowMeta = 1;
                }
            }

            # show ticket flags
            if ($ShowMeta) {
                $Class .= ' Important';
            }
            else {
                $Class .= ' Unimportant';
            }
        }

        # if this is the shown article -=> set class to active
        if ( $ArticleID eq $Article{ArticleID} && !$Self->{ZoomExpand} ) {
            $ClassRow .= ' Active';
        }

        my $TmpSubject = $Self->{TicketObject}->TicketSubjectClean(
            TicketNumber => $Article{TicketNumber},
            Subject => $Article{Subject} || '',
        );

        # check if we need to show also expand/collapse icon
        $Self->{LayoutObject}->Block(
            Name => 'TreeItem',
            Data => {
                %Article,
                Class          => $Class,
                ClassRow       => $ClassRow,
                Subject        => $TmpSubject,
                ZoomExpand     => $Self->{ZoomExpand},
                ZoomExpandSort => $Self->{ZoomExpandSort},
            },
        );

        if ($NewArticle) {
            $Self->{LayoutObject}->Block(
                Name => 'TreeItemNewArticle',
                Data => {
                    %Article,
                    Class => $Class,
                },
            );
        }

        # show attachment info
        next if !$Article{Atms};
        next if !%{ $Article{Atms} };

        # download type
        my $Type = $Self->{ConfigObject}->Get('AttachmentDownloadType') || 'attachment';

        # if attachment will be forced to download, don't open a new download window!
        my $Target = '';
        if ( $Type =~ /inline/i ) {
            $Target = 'target="attachment" ';
        }
        my $ZoomAttachmentDisplayCount
            = $Self->{ConfigObject}->Get('Ticket::ZoomAttachmentDisplayCount');
        my $CountShown = 0;
        for my $Count ( 1 .. ( $ZoomAttachmentDisplayCount + 2 ) ) {
            next if !$Article{Atms}->{$Count};
            if ( $CountShown == 0 ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TreeItemAttachment',
                    Data => {
                        %Article,
                    },
                );
            }
            $CountShown++;

            # show more info
            last if ( $CountShown > $ZoomAttachmentDisplayCount );

            # show attachment info
            $Self->{LayoutObject}->Block(
                Name => 'TreeItemAttachmentItem',
                Data => {
                    %Article,
                    %{ $Article{Atms}->{$Count} },
                    FileID => $Count,
                    Target => $Target,
                },
            );
        }
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketZoom',
        Data => { %Param, %Ticket },
    );
}

sub _ArticleItem {
    my ( $Self, %Param ) = @_;

    my %Ticket    = %{ $Param{Ticket} };
    my %Article   = %{ $Param{Article} };
    my %AclAction = %{ $Param{AclAction} };

    # mark shown article as seen
    $Self->{TicketObject}->ArticleFlagSet(
        ArticleID => $Article{ArticleID},
        Key       => 'Seen',
        Value     => 1,
        UserID    => $Self->{UserID},
    );

    # cleanup subject
    $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject => $Article{Subject} || '',
    );

    $Self->{LayoutObject}->Block(
        Name => 'ArticleItem',
        Data => { %Param, %Article, %AclAction },
    );

    # show article actions

    # select the output template
    if ( $Article{ArticleType} !~ /^(note|email-noti)/i ) {

        # check if compose link should be shown
        if (
            $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketCompose}
            && (
                !defined $AclAction{AgentTicketCompose}
                || $AclAction{AgentTicketCompose}
            )
            )
        {
            my $Access = 1;
            my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketCompose');
            if ( $Config->{Permission} ) {
                my $Ok = $Self->{TicketObject}->TicketPermission(
                    Type     => $Config->{Permission},
                    TicketID => $Ticket{TicketID},
                    UserID   => $Self->{UserID},
                    LogNo    => 1,
                );
                if ( !$Ok ) {
                    $Access = 0;
                }
            }
            if ( $Config->{RequiredLock} ) {
                my $Locked = $Self->{TicketObject}->TicketLockGet(
                    TicketID => $Ticket{TicketID}
                );
                if ($Locked) {
                    my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                        TicketID => $Ticket{TicketID},
                        OwnerID  => $Self->{UserID},
                    );
                    if ( !$AccessOk ) {
                        $Access = 0;
                    }
                }
            }
            if ($Access) {

                # get StandardResponsesStrg
                $Param{StandardResponses}->{0}
                    = '- ' . $Self->{LayoutObject}->{LanguageObject}->Get('Reply') . ' -';

                # build html string
                my $StandardResponsesStrg = $Self->{LayoutObject}->BuildSelection(
                    Name => 'ResponseID',
                    ID   => 'ResponseID',
                    Data => $Param{StandardResponses},
                );

                $Self->{LayoutObject}->Block(
                    Name => 'ArticleReply',
                    Data => {
                        %Ticket, %Article, %AclAction,
                        StandardResponsesStrg => $StandardResponsesStrg,
                        Name                  => 'Reply',
                        Class                 => 'AsPopup',
                        Action                => 'AgentTicketCompose',
                        FormID                => 'Reply',
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleReply' . $Param{Type},
                    Data => {
                        %Ticket, %Article, %AclAction,
                        FormID => 'Reply',
                    },
                );

                $Param{StandardResponses}->{0}
                    = '- ' . $Self->{LayoutObject}->{LanguageObject}->Get('Reply All') . ' -';

                $StandardResponsesStrg = $Self->{LayoutObject}->BuildSelection(
                    Name => 'ResponseID',
                    ID   => 'ResponseIDAll',
                    Data => $Param{StandardResponses},
                );

                $Self->{LayoutObject}->Block(
                    Name => 'ArticleReply',
                    Data => {
                        %Ticket, %Article, %AclAction,
                        StandardResponsesStrg => $StandardResponsesStrg,
                        Name                  => 'Reply All',
                        Class                 => 'AsPopup',
                        Action                => 'AgentTicketCompose',
                        FormID                => 'ReplyAll',
                        ReplyAll              => 1,
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleReply' . $Param{Type},
                    Data => {
                        %Ticket, %Article, %AclAction,
                        FormID => 'ReplyAll',
                    },
                );
            }
        }

        # check if forward link should be shown
        if (
            $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketForward}
            && ( !defined $AclAction{AgentTicketForward} || $AclAction{AgentTicketForward} )
            && $Article{ArticleType} !~ /^(note|email-noti|phone|webrequest)$/i
            )
        {
            my $Access = 1;
            my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketForward');
            if ( $Config->{Permission} ) {
                my $OK = $Self->{TicketObject}->TicketPermission(
                    Type     => $Config->{Permission},
                    TicketID => $Ticket{TicketID},
                    UserID   => $Self->{UserID},
                    LogNo    => 1,
                );
                if ( !$OK ) {
                    $Access = 0;
                }
            }
            if ( $Config->{RequiredLock} ) {
                if ( $Self->{TicketObject}->TicketLockGet( TicketID => $Ticket{TicketID} ) )
                {
                    my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                        TicketID => $Ticket{TicketID},
                        OwnerID  => $Self->{UserID},
                    );
                    if ( !$AccessOk ) {
                        $Access = 0;
                    }
                }
            }
            if ($Access) {
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleMenu',
                    Data => {
                        %Ticket, %Article, %AclAction,
                        Name  => 'Forward',
                        Class => 'AsPopup',
                        Link =>
                            'Action=AgentTicketForward;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}'
                    },
                );
            }
        }

        # check if bounce link should be shown
        if (
            $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketBounce}
            && ( !defined $AclAction{AgentTicketBounce} || $AclAction{AgentTicketBounce} )
            && $Article{ArticleType} !~ /^(note|email-noti|phone|webrequest)$/i
            )
        {
            my $Access = 1;
            my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketBounce');
            if ( $Config->{Permission} ) {
                my $OK = $Self->{TicketObject}->TicketPermission(
                    Type     => $Config->{Permission},
                    TicketID => $Ticket{TicketID},
                    UserID   => $Self->{UserID},
                    LogNo    => 1,
                );
                if ( !$OK ) {
                    $Access = 0;
                }
            }
            if ( $Config->{RequiredLock} ) {
                if ( $Self->{TicketObject}->TicketLockGet( TicketID => $Ticket{TicketID} ) )
                {
                    my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                        TicketID => $Ticket{TicketID},
                        OwnerID  => $Self->{UserID},
                    );
                    if ( !$AccessOk ) {
                        $Access = 0;
                    }
                }
            }
            if ($Access) {
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleMenu',
                    Data => {
                        %Ticket, %Article, %AclAction,
                        Name  => 'Bounce',
                        Class => 'AsPopup',
                        Link =>
                            'Action=AgentTicketBounce;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}'
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'AgentArticleComBounce',
                    Data => { %Ticket, %Article, %AclAction },
                );
            }
        }
    }

    # check if phone link should be shown
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPhoneOutbound}
        && (
            !defined $AclAction{AgentTicketPhoneOutbound}
            || $AclAction{AgentTicketPhoneOutbound}
        )
        )
    {
        my $Access = 1;
        my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketPhoneOutbound');
        if ( $Config->{Permission} ) {
            my $OK = $Self->{TicketObject}->TicketPermission(
                Type     => $Config->{Permission},
                TicketID => $Ticket{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            if ( !$OK ) {
                $Access = 0;
            }
        }
        if ( $Config->{RequiredLock} ) {
            my $Locked = $Self->{TicketObject}->TicketLockGet(
                TicketID => $Ticket{TicketID}
            );
            if ($Locked) {
                my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                    TicketID => $Ticket{TicketID},
                    OwnerID  => $Self->{UserID},
                );
                if ( !$AccessOk ) {
                    $Access = 0;
                }
            }
        }
        if ($Access) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleMenu',
                Data => {
                    %Ticket, %Article, %AclAction,
                    Name  => 'Phone Call Outbound',
                    Class => 'AsPopup',
                    Link  => 'Action=AgentTicketPhoneOutbound;TicketID=$Data{"TicketID"}'
                },
            );
        }
    }

    # check if split link should be shown
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPhone}
        && ( !defined $AclAction{AgentTicketPhone} || $AclAction{AgentTicketPhone} )
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'ArticleMenu',
            Data => {
                %Ticket, %Article, %AclAction,
                Name => 'Split',
                Link =>
                    'Action=AgentTicketPhone;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}'
            },
        );
    }

    # check if print link should be shown
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPrint}
        && ( !defined $AclAction{AgentTicketPrint} || $AclAction{AgentTicketPrint} )
        )
    {
        my $OK = $Self->{TicketObject}->TicketPermission(
            Type     => 'ro',
            TicketID => $Ticket{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
        if ($OK) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleMenu',
                Data => {
                    %Ticket, %Article, %AclAction,
                    Name  => 'Print',
                    Class => 'AsPopup',
                    Link =>
                        'Action=AgentTicketPrint;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}'
                },
            );
        }
    }

    # check if plain link should be shown
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPlain}
        && ( !defined $AclAction{AgentTicketPlain} || $AclAction{AgentTicketPlain} )
        && $Article{ArticleType} =~ /email/i
        )
    {
        my $OK = $Self->{TicketObject}->TicketPermission(
            Type     => 'ro',
            TicketID => $Ticket{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
        if ($OK) {
            my $Link
                = 'Action=AgentTicketPlain;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}';
            $Self->{LayoutObject}->Block(
                Name => 'ArticleMenu',
                Data => {
                    %Ticket, %Article, %AclAction,
                    Name  => 'Plain Format',
                    Class => 'AsPopup',
                    Link  => $Link,
                },
            );
        }
    }

    # do some strips && quoting
    for my $Key (qw(From To Cc)) {
        next if !$Article{$Key};
        $Self->{LayoutObject}->Block(
            Name => 'RowRecipient',
            Data => {
                Key      => $Key,
                Value    => $Article{$Key},
                Realname => $Article{ $Key . 'Realname' },
            },
        );
    }
    for my $Key (qw(Subject)) {
        next if !$Article{$Key};
        $Self->{LayoutObject}->Block(
            Name => 'RowData',
            Data => {
                Key   => $Key,
                Value => $Article{$Key},
            },
        );
    }

    # show accounted article time
    if ( $Self->{ConfigObject}->Get('Ticket::ZoomTimeDisplay') ) {
        my $ArticleTime = $Self->{TicketObject}->ArticleAccountedTimeGet(
            ArticleID => $Article{ArticleID}
        );
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {
                Key   => 'Time',
                Value => $ArticleTime,
            },
        );
    }

    # show article free text
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

    # add block for attachments
    if ( $Article{Atms} && %{ $Article{Atms} } ) {
        my %AtmIndex = %{ $Article{Atms} };
        $Self->{LayoutObject}->Block(
            Name => 'ArticleAttachment',
            Data => {},
        );

        my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleAttachmentModule');
        for my $FileID ( sort keys %AtmIndex ) {
            my %File = %{ $AtmIndex{$FileID} };
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachmentRow',
                Data => \%File,
            );

            # run article attachment modules
            next if ref $Config ne 'HASH';
            my %Jobs = %{$Config};
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                    return $Self->{LayoutObject}->ErrorScreen();
                }
                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    TicketID  => $Self->{TicketID},
                    ArticleID => $Article{ArticleID},
                );

                # run module
                my %Data = $Object->Run(
                    File => {
                        %File,
                        FileID => $FileID,
                    },
                    Article => \%Article,
                );
                next if !%Data;
                $Self->{LayoutObject}->Block(
                    Name => $Data{Block} || 'ArticleAttachmentRowLink',
                    Data => {%Data},
                );
            }
        }
    }

    # run article view modules
    my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleViewModule');
    if ( ref $Config eq 'HASH' ) {
        my %Jobs = %{$Config};
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                TicketID  => $Self->{TicketID},
                ArticleID => $Article{ArticleID},
            );

            # run module
            my @Data = $Object->Check( Article => \%Article, %Ticket, Config => $Jobs{$Job} );
            for my $DataRef (@Data) {
                if ( !$DataRef->{Successful} ) {
                    $DataRef->{Result} = 'Error';
                }
                else {
                    $DataRef->{Result} = 'Success';
                }
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleOption',
                    Data => $DataRef,
                );
            }

            # filter option
            $Object->Filter( Article => \%Article, %Ticket, Config => $Jobs{$Job} );
        }
    }

    # show body as html or plain text
    my $ViewMode = 'BodyHTML';

    # in case show plain article body (if no html body as attachment exists of if rich
    # text is not enabled)
    if ( !$Self->{RichText} || !$Article{AttachmentIDOfHTMLBody} ) {
        $ViewMode = 'BodyPlain';

        # remember plain body for further processing by ArticleViewModules
        $Article{BodyPlain} = $Article{Body};

        # html quoting
        $Article{Body} = $Self->{LayoutObject}->Ascii2Html(
            NewLine        => $Self->{ConfigObject}->Get('DefaultViewNewLine'),
            Text           => $Article{Body},
            VMax           => $Self->{ConfigObject}->Get('DefaultViewLines') || 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );

        # do charset check
        if ( my $CharsetText = $Self->{LayoutObject}->CheckCharset( %Ticket, %Article ) ) {
            $Article{BodyNote} = $CharsetText;
        }
    }

    # show body
    # Create a reference to an anonymous copy of %Article and pass it to
    # the LayoutObject, because %Article may be modified afterwards.
    $Self->{LayoutObject}->Block(
        Name => $ViewMode,
        Data => {%Article},
    );

    # restore plain body for further processing by ArticleViewModules
    if ( !$Self->{RichText} || !$Article{AttachmentIDOfHTMLBody} ) {
        $Article{Body} = $Article{BodyPlain};
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketZoom',
        Data => { %Param, %Ticket, %AclAction },
    );
}
1;
