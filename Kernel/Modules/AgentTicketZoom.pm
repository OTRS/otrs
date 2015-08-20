# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketZoom;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use POSIX qw/ceil/;
use Kernel::System::EmailParser;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $Self->{ArticleID}      = $ParamObject->GetParam( Param => 'ArticleID' );
    $Self->{ZoomExpand}     = $ParamObject->GetParam( Param => 'ZoomExpand' );
    $Self->{ZoomExpandSort} = $ParamObject->GetParam( Param => 'ZoomExpandSort' );

    # Please note: ZoomTimeline is an OTRSBusiness feature
    $Self->{ZoomTimeline} = $ParamObject->GetParam( Param => 'ZoomTimeline' );
    if ( !$ConfigObject->Get('TimelineViewEnabled') ) {
        $Self->{ZoomTimeline} = 0;
    }

    # save last used view type in preferences
    if ( defined $Self->{ZoomExpand} || defined $Self->{ZoomTimeline} ) {

        my $LastUsedZoomViewType = '';
        if ( $Self->{ZoomExpand} && $Self->{ZoomExpand} == 1 ) {
            $LastUsedZoomViewType = 'Expand';
        }
        elsif ( $Self->{ZoomTimeline} && $Self->{ZoomTimeline} == 1 ) {
            $LastUsedZoomViewType = 'Timeline';
        }
        $UserObject->SetPreferences(
            UserID => $Self->{UserID},
            Key    => 'UserLastUsedZoomViewType',
            Value  => $LastUsedZoomViewType,
        );
    }

    my %UserPreferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( !defined $Self->{DoNotShowBrowserLinkMessage} ) {
        if ( $UserPreferences{UserAgentDoNotShowBrowserLinkMessage} ) {
            $Self->{DoNotShowBrowserLinkMessage} = 1;
        }
        else {
            $Self->{DoNotShowBrowserLinkMessage} = 0;
        }
    }

    if ( !defined $Self->{ZoomExpand} ) {
        if (
            $UserPreferences{UserLastUsedZoomViewType}
            && $UserPreferences{UserLastUsedZoomViewType} eq 'Expand'
            )
        {
            $Self->{ZoomExpand} = 1;
        }
        else {
            $Self->{ZoomExpand} = $ConfigObject->Get('Ticket::Frontend::ZoomExpand');
        }
    }

    if (
        !defined $Self->{ZoomTimeline}
        && $UserPreferences{UserLastUsedZoomViewType}
        && $UserPreferences{UserLastUsedZoomViewType} eq 'Timeline'
        )
    {
        $Self->{ZoomTimeline} = 1;
    }

    if ( !defined $Self->{ZoomExpandSort} ) {
        $Self->{ZoomExpandSort} = $ConfigObject->Get('Ticket::Frontend::ZoomExpandSort');
    }

    $Self->{ArticleFilterActive} = $ConfigObject->Get('Ticket::Frontend::TicketArticleFilter');

    # define if rich text should be used
    $Self->{RichText} = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

    # strip html and ascii attachments of content
    $Self->{StripPlainBodyAsAttachment} = 1;

    # check if rich text is enabled, if not only strip ascii attachments
    if ( !$Self->{RichText} ) {
        $Self->{StripPlainBodyAsAttachment} = 2;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # ticket id lookup
    if ( !$Self->{TicketID} && $ParamObject->GetParam( Param => 'TicketNumber' ) ) {
        $Self->{TicketID} = $TicketObject->TicketIDLookup(
            TicketNumber => $ParamObject->GetParam( Param => 'TicketNumber' ),
            UserID       => $Self->{UserID},
        );
    }

    # get zoom settings depending on ticket type
    $Self->{DisplaySettings} = $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom");

    # this is a mapping of history types which is being used
    # for the timeline view and its event type filter
    $Self->{HistoryTypeMapping} = {
        NewTicket                       => 'Ticket Created',
        AddNote                         => 'Note Added',
        AddNoteCustomer                 => 'Note Added (Customer)',
        EmailAgent                      => 'Outgoing Email',
        EmailCustomer                   => 'Incoming Customer Email',
        TicketDynamicFieldUpdate        => 'Dynamic Field Updated',
        PhoneCallAgent                  => 'Outgoing Phone Call',
        PhoneCallCustomer               => 'Incoming Phone Call',
        SendAnswer                      => 'Outgoing Answer',
        ResponsibleUpdate               => 'New Responsible',
        OwnerUpdate                     => 'New Owner',
        SLAUpdate                       => 'SLA Updated',
        ServiceUpdate                   => 'Service Updated',
        CustomerUpdate                  => 'Customer Updated',
        StateUpdate                     => 'State Updated',
        FollowUp                        => 'Incoming Follow-Up',
        EscalationUpdateTimeStop        => 'Escalation Update Time Stopped',
        EscalationSolutionTimeStop      => 'Escalation Solution Time Stopped',
        EscalationFirstResponseTimeStop => 'Escalation First Response Time Stopped',
        EscalationResponseTimeStop      => 'Escalation Response Time Stopped',
        TicketLinkAdd                   => 'Link Added',
        TicketLinkDelete                => 'Link Deleted',
        Merged                          => 'Ticket Merged',
        SetPendingTime                  => 'Pending Time Set',
        Lock                            => 'Ticket Locked',
        Unlock                          => 'Ticket Unlocked',
        Move                            => 'Queue Updated',
        PriorityUpdate                  => 'Priority Updated',
        TitleUpdate                     => 'Title Updated',
        TypeUpdate                      => 'Type Updated',
        WebRequestCustomer              => 'Incoming Web Request',
        SendAutoFollowUp                => 'Automatic Follow-Up Sent',
        SendAutoReply                   => 'Automatic Reply Sent',
        TimeAccounting                  => 'Time Accounted',
        ChatExternal                    => 'External Chat',
        ChatInternal                    => 'Internal Chat',
    };

    # Add custom files to the zoom's frontend module registration on the fly
    #    to avoid conflicts with other modules.
    if (
        defined $ConfigObject->Get('TimelineViewEnabled')
        && $ConfigObject->Get('TimelineViewEnabled') == 1
        )
    {
        my $ZoomFrontendConfiguration = $ConfigObject->Get('Frontend::Module')->{AgentTicketZoom};
        my @CustomJSFiles             = (
            'Core.Agent.TicketZoom.TimelineView.js',
        );
        push( @{ $ZoomFrontendConfiguration->{Loader}->{JavaScript} || [] }, @CustomJSFiles );
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        my $TranslatableMessage = $LayoutObject->{LanguageObject}->Translate(
            "We are sorry, you do not have permissions anymore to access this ticket in its current state. "
        );

        return $LayoutObject->NoPermission(
            Message    => $TranslatableMessage,
            WithHeader => 'yes',
        );
    }

    # get ticket attributes
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    # get ACL restrictions
    my %PossibleActions;
    my $Counter = 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get all registered Actions
    if ( ref $ConfigObject->Get('Frontend::Module') eq 'HASH' ) {

        my %Actions = %{ $ConfigObject->Get('Frontend::Module') };

        # only use those Actions that stats with Agent
        %PossibleActions = map { ++$Counter => $_ }
            grep { substr( $_, 0, length 'Agent' ) eq 'Agent' }
            sort keys %Actions;
    }

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );

    my %AclAction = %PossibleActions;
    if ($ACL) {
        %AclAction = $TicketObject->TicketAclActionData();
    }

    # check if ACL restrictions exist
    my %AclActionLookup = reverse %AclAction;

    # show error screen if ACL prohibits this action
    if ( !$AclActionLookup{ $Self->{Action} } ) {
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # mark shown ticket as seen
    if ( $Self->{Subaction} eq 'TicketMarkAsSeen' ) {
        my $Success = 1;

        # always show archived tickets as seen
        if ( $Ticket{ArchiveFlag} ne 'y' ) {
            $Success = $Self->_TicketItemSeen( TicketID => $Self->{TicketID} );
        }

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => $Success,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    if ( $Self->{Subaction} eq 'MarkAsImportant' ) {

        # Owner and Responsible can mark articles as important or remove mark
        if (
            $Self->{UserID} == $Ticket{OwnerID}
            || (
                $ConfigObject->Get('Ticket::Responsible')
                && $Self->{UserID} == $Ticket{ResponsibleID}
            )
            )
        {

            # Always use user id 1 because other users also have to see the important flag
            my %ArticleFlag = $TicketObject->ArticleFlagGet(
                ArticleID => $Self->{ArticleID},
                UserID    => 1,
            );

            my $ArticleIsImportant = $ArticleFlag{Important};
            if ($ArticleIsImportant) {

                # Always use user id 1 because other users also have to see the important flag
                $TicketObject->ArticleFlagDelete(
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Important',
                    UserID    => 1,
                );
            }
            else {

                # Always use user id 1 because other users also have to see the important flag
                $TicketObject->ArticleFlagSet(
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Important',
                    Value     => 1,
                    UserID    => 1,
                );
            }
        }

        return $LayoutObject->Redirect(
            OP => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$Self->{ArticleID}",
        );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # mark shown article as seen
    if ( $Self->{Subaction} eq 'MarkAsSeen' ) {
        my $Success = 1;

        # always show archived tickets as seen
        if ( $Ticket{ArchiveFlag} ne 'y' ) {
            $Success = $Self->_ArticleItemSeen( ArticleID => $Self->{ArticleID} );
        }

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => $Success,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # article update
    elsif ( $Self->{Subaction} eq 'ArticleUpdate' ) {
        my $Count = $ParamObject->GetParam( Param => 'Count' );
        my %Article = $TicketObject->ArticleGet(
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 0,
        );
        $Article{Count} = $Count;

        # get attachment index (without attachments)
        my %AtmIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID                  => $Self->{ArticleID},
            StripPlainBodyAsAttachment => $Self->{StripPlainBodyAsAttachment},
            Article                    => \%Article,
            UserID                     => $Self->{UserID},
        );
        $Article{Atms} = \%AtmIndex;

        # fetch all std. templates
        my %StandardTemplates = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberList(
            QueueID       => $Ticket{QueueID},
            TemplateTypes => 1,
            Valid         => 1,
        );

        $Self->_ArticleItem(
            Ticket            => \%Ticket,
            Article           => \%Article,
            AclAction         => \%AclAction,
            StandardResponses => $StandardTemplates{Answer},
            StandardForwards  => $StandardTemplates{Forward},
            Type              => 'OnLoad',
        );
        my $Content = $LayoutObject->Output(
            TemplateFile => 'AgentTicketZoom',
            Data         => { %Ticket, %Article, %AclAction },
        );
        if ( !$Content ) {
            $LayoutObject->FatalError(
                Message => "Can't get for ArticleID $Self->{ArticleID}!",
            );
        }
        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Content,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # get needed objects
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # write article filter settings to session
    if ( $Self->{Subaction} eq 'ArticleFilterSet' ) {

        # get params
        my $TicketID     = $ParamObject->GetParam( Param => 'TicketID' );
        my $SaveDefaults = $ParamObject->GetParam( Param => 'SaveDefaults' );
        my @ArticleTypeFilterIDs       = $ParamObject->GetArray( Param => 'ArticleTypeFilter' );
        my @ArticleSenderTypeFilterIDs = $ParamObject->GetArray( Param => 'ArticleSenderTypeFilter' );

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
            $UserObject->SetPreferences(
                UserID => $Self->{UserID},
                Key    => 'ArticleFilterDefault',
                Value  => $SessionString,
            );
            $SessionObject->UpdateSessionID(
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
        my $Update = $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => "ArticleFilter$TicketID",
            Value     => $SessionString,
        );

        # build JSON output
        my $JSON = '';
        if ($Update) {
            $JSON = $LayoutObject->JSONEncode(
                Data => {
                    Message => 'Article filter settings were saved.',
                },
            );
        }

        # send JSON response
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # write article filter settings to session
    if ( $Self->{Subaction} eq 'EvenTypeFilterSet' ) {

        # get params
        my $TicketID     = $ParamObject->GetParam( Param => 'TicketID' );
        my $SaveDefaults = $ParamObject->GetParam( Param => 'SaveDefaults' );
        my @EventTypeFilterIDs = $ParamObject->GetArray( Param => 'EventTypeFilter' );

        # build session string
        my $SessionString = '';
        if (@EventTypeFilterIDs) {
            $SessionString .= 'EventTypeFilter<';
            $SessionString .= join ',', @EventTypeFilterIDs;
            $SessionString .= '>';
        }

        # write the session

        # save default filter settings to user preferences
        if ($SaveDefaults) {
            $UserObject->SetPreferences(
                UserID => $Self->{UserID},
                Key    => 'EventTypeFilterDefault',
                Value  => $SessionString,
            );
            $SessionObject->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'EventTypeFilterDefault',
                Value     => $SessionString,
            );
        }

        # turn off filter explicitly for this ticket
        if ( $SessionString eq '' ) {
            $SessionString = 'off';
        }

        # update the session
        my $Update = $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => "EventTypeFilter$TicketID",
            Value     => $SessionString,
        );

        # build JSON output
        my $JSON = '';
        if ($Update) {
            $JSON = $LayoutObject->JSONEncode(
                Data => {
                    Message => 'Event type filter settings were saved.',
                },
            );
        }

        # send JSON response
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
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
            $Self->{ArticleFilter}->{ArticleTypeID} = \@IDs;
        }

        # extract ArticleSenderTypeIDs
        if (
            $ArticleFilterSessionString
            && $ArticleFilterSessionString =~ m{ ArticleSenderTypeFilter < ( [^<>]+ ) > }xms
            )
        {
            my @IDs = split /,/, $1;
            $Self->{ArticleFilter}->{ArticleSenderTypeID} = \@IDs;
        }

        # get event type filter settings from session string
        my $EventTypeFilterSessionString = $Self->{ 'EventTypeFilter' . $Self->{TicketID} };

        # set article filter for this ticket from user preferences
        if ( !$EventTypeFilterSessionString ) {
            $EventTypeFilterSessionString = $Self->{EventTypeFilterDefault};
        }

        # do not use defaults for this ticket if filter was explicitly turned off
        elsif ( $EventTypeFilterSessionString eq 'off' ) {
            $EventTypeFilterSessionString = '';
        }

        # extract ArticleTypeIDs
        if (
            $EventTypeFilterSessionString
            && $EventTypeFilterSessionString =~ m{ EventTypeFilter < ( [^<>]+ ) > }xms
            )
        {
            my @IDs = split /,/, $1;
            $Self->{EventTypeFilter}->{EventTypeID} = \@IDs,
        }
    }

    # return if HTML email
    if ( $Self->{Subaction} eq 'ShowHTMLeMail' ) {

        # check needed ArticleID
        if ( !$Self->{ArticleID} ) {
            return $LayoutObject->ErrorScreen( Message => 'Need ArticleID!' );
        }

        # get article data
        my %Article = $TicketObject->ArticleGet(
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 0,
        );

        # check if article data exists
        if ( !%Article ) {
            return $LayoutObject->ErrorScreen( Message => 'Invalid ArticleID!' );
        }

        # if it is a html email, return here
        return $LayoutObject->Attachment(
            Filename => $ConfigObject->Get('Ticket::Hook')
                . "-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
            Type        => 'inline',
            ContentType => "$Article{MimeType}; charset=$Article{Charset}",
            Content     => $Article{Body},
        );
    }

    # generate output
    my $Output = $LayoutObject->Header( Value => $Ticket{TicketNumber} );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Self->MaskAgentZoom(
        Ticket    => \%Ticket,
        AclAction => \%AclAction
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub MaskAgentZoom {
    my ( $Self, %Param ) = @_;

    my %Ticket    = %{ $Param{Ticket} };
    my %AclAction = %{ $Param{AclAction} };

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # else show normal ticket zoom view
    # fetch all move queues
    my %MoveQueues = $TicketObject->MoveList(
        TicketID => $Ticket{TicketID},
        UserID   => $Self->{UserID},
        Action   => $Self->{Action},
        Type     => 'move_into',
    );

    # fetch all std. templates
    my %StandardTemplates = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberList(
        QueueID       => $Ticket{QueueID},
        TemplateTypes => 1,
    );

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # owner info
    my %OwnerInfo = $UserObject->GetUserData(
        UserID => $Ticket{OwnerID},
    );

    # responsible info
    my %ResponsibleInfo = $UserObject->GetUserData(
        UserID => $Ticket{ResponsibleID} || 1,
    );

    # get cofig object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # generate shown articles
    my $Limit = $ConfigObject->Get('Ticket::Frontend::MaxArticlesPerPage');

    my $Order = $Self->{ZoomExpandSort} eq 'reverse' ? 'DESC' : 'ASC';
    my $Page;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get article page
    my $ArticlePage = $ParamObject->GetParam( Param => 'ArticlePage' );

    if ( $Self->{ArticleID} ) {
        $Page = $TicketObject->ArticlePage(
            TicketID    => $Self->{TicketID},
            ArticleID   => $Self->{ArticleID},
            RowsPerPage => $Limit,
            Order       => $Order,
            %{ $Self->{ArticleFilter} // {} },
        );
    }
    elsif ($ArticlePage) {
        $Page = $ArticlePage;
    }
    else {
        $Page = 1;
    }

    # We need to find out whether pagination is actually necessary.
    # The easiest way would be count the articles, but that would slow
    # down the most common case (fewer articles than $Limit in the ticket).
    # So instead we use the following trick:
    # 1) if the $Page > 1, we need pagination
    # 2) if not, request $Limit + 1 articles. If $Limit + 1 are actually
    #    returned, pagination is necessary
    my $Extra = $Page > 1 ? 0 : 1;
    my $NeedPagination;
    my $ArticleCount;

    my @ArticleContentArgs = (
        TicketID                   => $Self->{TicketID},
        StripPlainBodyAsAttachment => $Self->{StripPlainBodyAsAttachment},
        UserID                     => $Self->{UserID},
        Limit                      => $Limit + $Extra,
        Order                      => $Order,
        DynamicFields => 0,    # fetch later only for the article(s) to display
        %{ $Self->{ArticleFilter} // {} },    # limit by ArticleSenderTypeID/ArticleTypeID

    );

    # get content
    my @ArticleBox = $TicketObject->ArticleContentIndex(
        @ArticleContentArgs,
        Page => $Page,
    );

    if ( !@ArticleBox && $Page > 1 ) {

        # if the page argument is past the actual number of pages,
        # assume page 1 instead.
        # This can happen when a new article filter was added.
        $Page       = 1;
        @ArticleBox = $TicketObject->ArticleContentIndex(
            @ArticleContentArgs,
            Page => $Page,
        );
        $ArticleCount = $TicketObject->ArticleCount(
            TicketID => $Self->{TicketID},
            %{ $Self->{ArticleFilter} // {} },
        );
        $NeedPagination = $ArticleCount > $Limit;
    }
    elsif ( @ArticleBox > $Limit ) {
        pop @ArticleBox;
        $NeedPagination = 1;
        $ArticleCount   = $TicketObject->ArticleCount(
            TicketID => $Self->{TicketID},
            %{ $Self->{ArticleFilter} // {} },
        );
    }
    elsif ( $Page == 1 ) {
        $ArticleCount   = @ArticleBox;
        $NeedPagination = 0;
    }
    else {
        $NeedPagination = 1;
        $ArticleCount   = $TicketObject->ArticleCount(
            TicketID => $Ticket{TicketID},
            %{ $Self->{ArticleFilter} // {} },
        );
    }

    $Page ||= 1;

    my $Pages;
    if ($NeedPagination) {
        $Pages = ceil( $ArticleCount / $Limit );
    }

    # add counter
    my $Count = ( $Page - 1 ) * $Limit;

    # in case of reverse sorting, count top-down
    if ( $ConfigObject->Get('Ticket::Frontend::ZoomExpandSort') eq 'reverse' ) {
        $Count = $ArticleCount - ( ( $Page - 1 ) * $Limit ) + 1;
    }

    my $ArticleIDFound = 0;
    for my $Article (@ArticleBox) {

        if ( $ConfigObject->Get('Ticket::Frontend::ZoomExpandSort') eq 'reverse' ) {
            $Count--;
        }
        else {
            $Count++;
        }

        $Article->{Count} = $Count;
        if ( $Self->{ArticleID} && $Self->{ArticleID} == $Article->{ArticleID} ) {
            $ArticleIDFound = 1;
        }
    }

    my %ArticleFlags = $TicketObject->ArticleFlagsOfTicketGet(
        TicketID => $Ticket{TicketID},
        UserID   => $Self->{UserID},
    );

    # get selected or last customer article
    my $ArticleID;
    if ($ArticleIDFound) {
        $ArticleID = $Self->{ArticleID};
    }
    else {

        # find latest not seen article
        ARTICLE:
        for my $Article (@ArticleBox) {

            # ignore system sender type
            next ARTICLE
                if $ConfigObject->Get('Ticket::NewArticleIgnoreSystemSender')
                && $Article->{SenderType} eq 'system';

            next ARTICLE if $ArticleFlags{ $Article->{ArticleID} }->{Seen};
            $ArticleID = $Article->{ArticleID};
            last ARTICLE;
        }

        # set selected article
        if ( !$ArticleID ) {
            if (@ArticleBox) {

                # set first listed article as fallback
                $ArticleID = $ArticleBox[0]->{ArticleID};
            }

            # set last customer article as selected article replacing last set
            ARTICLETMP:
            for my $ArticleTmp (@ArticleBox) {
                if ( $ArticleTmp->{SenderType} eq 'customer' ) {
                    $ArticleID = $ArticleTmp->{ArticleID};
                    last ARTICLETMP if $Self->{ZoomExpandSort} eq 'reverse';
                }
            }
        }
    }

    # check if expand view is usable (only for less then 400 article)
    # if you have more articles is going to be slow and not usable
    my $ArticleMaxLimit = $ConfigObject->Get('Ticket::Frontend::MaxArticlesZoomExpand')
        // 400;
    if ( $Self->{ZoomExpand} && $#ArticleBox > $ArticleMaxLimit ) {
        $Self->{ZoomExpand} = 0;
    }

    # get shown article(s)
    my @ArticleBoxShown;
    if ( !$Self->{ZoomExpand} ) {
        ARTICLEBOX:
        for my $ArticleTmp (@ArticleBox) {
            if ( $ArticleID eq $ArticleTmp->{ArticleID} ) {
                push @ArticleBoxShown, $ArticleTmp;
                last ARTICLEBOX;
            }
        }
    }
    else {
        @ArticleBoxShown = @ArticleBox;
    }

    # set display options
    $Param{WidgetTitle} = 'Ticket Information';
    $Param{Hook} = $ConfigObject->Get('Ticket::Hook') || 'Ticket#';

    # check if ticket is normal or process ticket
    my $IsProcessTicket = $TicketObject->TicketCheckForProcessType(
        'TicketID' => $Self->{TicketID}
    );

    # overwrite display options for process ticket
    if ($IsProcessTicket) {
        $Param{WidgetTitle} = $Self->{DisplaySettings}->{ProcessDisplay}->{WidgetTitle};
    }

    # only show article tree if articles are present,
    # or if a filter is set (so that the user has the option to
    # disable the filter)
    if ( @ArticleBox || $Self->{ArticleFilter} ) {

        my $Pagination;

        if ($NeedPagination) {
            $Pagination = {
                Pages       => $Pages,
                CurrentPage => $Page,
                TicketID    => $Ticket{TicketID},
            };
        }

        # show article tree
        $Param{ArticleTree} = $Self->_ArticleTree(
            Ticket            => \%Ticket,
            ArticleFlags      => \%ArticleFlags,
            ArticleID         => $ArticleID,
            ArticleMaxLimit   => $ArticleMaxLimit,
            ArticleBox        => \@ArticleBox,
            Pagination        => $Pagination,
            Page              => $Page,
            ArticleCount      => scalar @ArticleBox,
            AclAction         => \%AclAction,
            StandardResponses => $StandardTemplates{Answer},
            StandardForwards  => $StandardTemplates{Forward},
        );
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # show articles items
    if ( !$Self->{ZoomTimeline} ) {

        $Param{ArticleItems} = '';
        ARTICLE:
        for my $ArticleTmp (@ArticleBoxShown) {
            my %Article = %$ArticleTmp;

            $Self->_ArticleItem(
                Ticket            => \%Ticket,
                Article           => \%Article,
                AclAction         => \%AclAction,
                StandardResponses => $StandardTemplates{Answer},
                StandardForwards  => $StandardTemplates{Forward},
                ActualArticleID   => $ArticleID,
                Type              => 'Static',
            );
        }
        $Param{ArticleItems} .= $LayoutObject->Output(
            TemplateFile => 'AgentTicketZoom',
            Data         => { %Ticket, %AclAction },
        );
    }

    # always show archived tickets as seen
    if ( $Self->{ZoomExpand} && $Ticket{ArchiveFlag} ne 'y' ) {
        $LayoutObject->Block(
            Name => 'TicketItemMarkAsSeen',
            Data => { TicketID => $Ticket{TicketID} },
        );
    }

    # age design
    $Ticket{Age} = $LayoutObject->CustomerAge(
        Age   => $Ticket{Age},
        Space => ' '
    );

    # number of articles
    $Param{ArticleCount} = scalar @ArticleBox;

    if ( $ConfigObject->Get('Ticket::UseArticleColors') ) {
        $Param{UseArticleColors} = 1;
    }

    $LayoutObject->Block(
        Name => 'Header',
        Data => { %Param, %Ticket, %AclAction },
    );

    # run ticket menu modules
    if ( ref $ConfigObject->Get('Ticket::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus = %{ $ConfigObject->Get('Ticket::Frontend::MenuModule') };
        my %MenuClusters;
        my %ZoomMenuItems;

        MENU:
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Menus{$Menu}->{Module} ) ) {
                return $LayoutObject->FatalError();
            }

            my $Object = $Menus{$Menu}->{Module}->new(
                %{$Self},
                TicketID => $Self->{TicketID},
            );

            # run module
            my $Item = $Object->Run(
                %Param,
                Ticket => \%Ticket,
                ACL    => \%AclAction,
                Config => $Menus{$Menu},
            );
            next MENU if !$Item;
            if ( $Menus{$Menu}->{PopupType} ) {
                $Item->{Class} = "AsPopup PopupType_$Menus{$Menu}->{PopupType}";
            }

            if ( !$Menus{$Menu}->{ClusterName} ) {

                $ZoomMenuItems{$Menu} = $Item;
            }
            else {

                # check the configured priority for this item. The lowest ClusterPriority
                # within the same cluster wins.
                my $Priority = $MenuClusters{ $Menus{$Menu}->{ClusterName} }->{Priority};
                if ( !$Priority || $Priority !~ /^\d{3}$/ || $Priority > $Menus{$Menu}->{ClusterPriority} ) {
                    $Priority = $Menus{$Menu}->{ClusterPriority};
                }
                $MenuClusters{ $Menus{$Menu}->{ClusterName} }->{Priority} = $Priority;
                $MenuClusters{ $Menus{$Menu}->{ClusterName} }->{Items}->{$Menu} = $Item;
            }
        }

        for my $Cluster ( sort keys %MenuClusters ) {
            $ZoomMenuItems{ $MenuClusters{$Cluster}->{Priority} . $Cluster } = {
                Name  => $Cluster,
                Type  => 'Cluster',
                Link  => '#',
                Class => 'ClusterLink',
                Items => $MenuClusters{$Cluster}->{Items},
                }
        }

        # display all items
        for my $Item ( sort keys %ZoomMenuItems ) {

            $LayoutObject->Block(
                Name => 'TicketMenu',
                Data => $ZoomMenuItems{$Item},
            );

            if ( $ZoomMenuItems{$Item}->{Type} eq 'Cluster' ) {

                $LayoutObject->Block(
                    Name => 'TicketMenuSubContainer'
                );

                for my $SubItem ( sort keys %{ $ZoomMenuItems{$Item}->{Items} } ) {
                    $LayoutObject->Block(
                        Name => 'TicketMenuSubContainerItem',
                        Data => $ZoomMenuItems{$Item}->{Items}->{$SubItem},
                    );
                }
            }
        }
    }

    # get MoveQueuesStrg
    if ( $ConfigObject->Get('Ticket::Frontend::MoveType') =~ /^form$/i ) {
        $MoveQueues{0} = '- ' . $LayoutObject->{LanguageObject}->Translate('Move') . ' -';
        $Param{MoveQueuesStrg} = $LayoutObject->AgentQueueListOption(
            Name           => 'DestQueueID',
            Data           => \%MoveQueues,
            CurrentQueueID => $Ticket{QueueID},
        );
    }
    my %AclActionLookup = reverse %AclAction;
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentTicketMove}
        && ( $AclActionLookup{AgentTicketMove} )
        )
    {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'move',
            TicketID => $Ticket{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
        $Param{TicketID} = $Ticket{TicketID};
        if ($Access) {
            if ( $ConfigObject->Get('Ticket::Frontend::MoveType') =~ /^form$/i ) {
                $LayoutObject->Block(
                    Name => 'MoveLink',
                    Data => { %Param, %AclAction },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'MoveForm',
                    Data => { %Param, %AclAction },
                );
            }
        }
    }

    # show created by if different then User ID 1
    if ( $Ticket{CreateBy} > 1 ) {
        $Ticket{CreatedByUser} = $UserObject->UserName( UserID => $Ticket{CreateBy} );
        $LayoutObject->Block(
            Name => 'CreatedBy',
            Data => {%Ticket},
        );
    }

    if ( $Ticket{ArchiveFlag} eq 'y' ) {
        $LayoutObject->Block(
            Name => 'ArchiveFlag',
            Data => { %Ticket, %AclAction },
        );
    }

    # ticket type
    if ( $ConfigObject->Get('Ticket::Type') ) {
        $LayoutObject->Block(
            Name => 'Type',
            Data => { %Ticket, %AclAction },
        );
    }

    # ticket service
    if ( $ConfigObject->Get('Ticket::Service') && $Ticket{Service} ) {
        $LayoutObject->Block(
            Name => 'Service',
            Data => { %Ticket, %AclAction },
        );
        if ( $Ticket{SLA} ) {
            $LayoutObject->Block(
                Name => 'SLA',
                Data => { %Ticket, %AclAction },
            );
        }
    }

    # show first response time if needed
    if ( defined $Ticket{FirstResponseTime} ) {
        $Ticket{FirstResponseTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{FirstResponseTime},
            Space => ' ',
        );
        $Ticket{FirstResponseTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{FirstResponseTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{FirstResponseTime} ) {
            $Ticket{FirstResponseTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'FirstResponseTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show update time if needed
    if ( defined $Ticket{UpdateTime} ) {
        $Ticket{UpdateTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{UpdateTime},
            Space => ' ',
        );
        $Ticket{UpdateTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{UpdateTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{UpdateTime} ) {
            $Ticket{UpdateTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'UpdateTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show solution time if needed
    if ( defined $Ticket{SolutionTime} ) {
        $Ticket{SolutionTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{SolutionTime},
            Space => ' ',
        );
        $Ticket{SolutionTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{SolutionTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{SolutionTime} ) {
            $Ticket{SolutionTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'SolutionTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show total accounted time if feature is active:
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        $Ticket{TicketTimeUnits} = $TicketObject->TicketAccountedTimeGet(%Ticket);
        $LayoutObject->Block(
            Name => 'TotalAccountedTime',
            Data => \%Ticket,
        );
    }

    # show pending until, if set:
    if ( $Ticket{UntilTime} ) {
        if ( $Ticket{UntilTime} < -1 ) {
            $Ticket{PendingUntilClass} = 'Warning';
        }

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        $Ticket{UntilTimeHuman} = $TimeObject->SystemTime2TimeStamp(
            SystemTime => ( $Ticket{UntilTime} + $TimeObject->SystemTime() ),
        );
        $Ticket{PendingUntil} .= $LayoutObject->CustomerAge(
            Age   => $Ticket{UntilTime},
            Space => ' '
        );
        $LayoutObject->Block(
            Name => 'PendingUntil',
            Data => \%Ticket,
        );
    }

    # show owner
    $LayoutObject->Block(
        Name => 'Owner',
        Data => { %Ticket, %OwnerInfo, %AclAction },
    );

    # show responsible
    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        $LayoutObject->Block(
            Name => 'Responsible',
            Data => { %Ticket, %ResponsibleInfo, %AclAction },
        );
    }

    # show no articles block if ticket does not contain articles
    if ( !@ArticleBox && !$Self->{ZoomTimeline} ) {
        $LayoutObject->Block(
            Name => 'HintNoArticles',
        );
    }

    # show process widget  and activity dialogs on process tickets
    if ($IsProcessTicket) {

        # get the DF where the ProcessEntityID is stored
        my $ProcessEntityIDField = 'DynamicField_'
            . $ConfigObject->Get("Process::DynamicFieldProcessManagementProcessID");

        # get the DF where the AtivityEntityID is stored
        my $ActivityEntityIDField = 'DynamicField_'
            . $ConfigObject->Get("Process::DynamicFieldProcessManagementActivityID");

        my $ProcessData = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessGet(
            ProcessEntityID => $Ticket{$ProcessEntityIDField},
        );
        my $ActivityData = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity')->ActivityGet(
            Interface        => 'AgentInterface',
            ActivityEntityID => $Ticket{$ActivityEntityIDField},
        );

        # output process information in the sidebar
        $LayoutObject->Block(
            Name => 'ProcessData',
            Data => {
                Process  => $ProcessData->{Name}  || '',
                Activity => $ActivityData->{Name} || '',
            },
        );

        # output the process widget the the main screen
        $LayoutObject->Block(
            Name => 'ProcessWidget',
            Data => {
                WidgetTitle => $Param{WidgetTitle},
            },
        );

        # get next activity dialogs
        my $NextActivityDialogs;
        if ( $Ticket{$ActivityEntityIDField} ) {
            $NextActivityDialogs = ${ActivityData}->{ActivityDialog} // {};
        }
        my $ActivityName = $ActivityData->{Name};

        if ($NextActivityDialogs) {

            # get ActivityDialog object
            my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');

            # we have to check if the current user has the needed permissions to view the
            # different activity dialogs, so we loop over every activity dialog and check if there
            # is a permission configured. If there is a permission configured we check this
            # and display/hide the activity dialog link
            my %PermissionRights;
            my %PermissionActivityDialogList;
            ACTIVITYDIALOGPERMISSION:
            for my $Index ( sort { $a <=> $b } keys %{$NextActivityDialogs} ) {
                my $CurrentActivityDialogEntityID = $NextActivityDialogs->{$Index};
                my $CurrentActivityDialog         = $ActivityDialogObject->ActivityDialogGet(
                    Interface              => 'AgentInterface',
                    ActivityDialogEntityID => $CurrentActivityDialogEntityID
                );

                # create an interface lookup-list
                my %InterfaceLookup = map { $_ => 1 } @{ $CurrentActivityDialog->{Interface} };

                next ACTIVITYDIALOGPERMISSION if !$InterfaceLookup{AgentInterface};

                if ( $CurrentActivityDialog->{Permission} ) {

                    # performance-boost/cache
                    if ( !defined $PermissionRights{ $CurrentActivityDialog->{Permission} } ) {
                        $PermissionRights{ $CurrentActivityDialog->{Permission} } = $TicketObject->TicketPermission(
                            Type     => $CurrentActivityDialog->{Permission},
                            TicketID => $Ticket{TicketID},
                            UserID   => $Self->{UserID},
                        );
                    }

                    if ( !$PermissionRights{ $CurrentActivityDialog->{Permission} } ) {
                        next ACTIVITYDIALOGPERMISSION;
                    }
                }

                $PermissionActivityDialogList{$Index} = $CurrentActivityDialogEntityID;
            }

            # reduce next activity dialogs to the ones that have permissions
            $NextActivityDialogs = \%PermissionActivityDialogList;

            # get ACL restrictions
            my $ACL = $TicketObject->TicketAcl(
                Data          => \%PermissionActivityDialogList,
                TicketID      => $Ticket{TicketID},
                ReturnType    => 'ActivityDialog',
                ReturnSubType => '-',
                UserID        => $Self->{UserID},
            );

            if ($ACL) {
                %{$NextActivityDialogs} = $TicketObject->TicketAclData()
            }

            $LayoutObject->Block(
                Name => 'NextActivityDialogs',
                Data => {
                    'ActivityName' => $ActivityName,
                },
            );

            if ( IsHashRefWithData($NextActivityDialogs) ) {
                for my $NextActivityDialogKey ( sort { $a <=> $b } keys %{$NextActivityDialogs} ) {
                    my $ActivityDialogData = $ActivityDialogObject->ActivityDialogGet(
                        Interface              => 'AgentInterface',
                        ActivityDialogEntityID => $NextActivityDialogs->{$NextActivityDialogKey},
                    );
                    $LayoutObject->Block(
                        Name => 'ActivityDialog',
                        Data => {
                            ActivityDialogEntityID
                                => $NextActivityDialogs->{$NextActivityDialogKey},
                            Name            => $ActivityDialogData->{Name},
                            ProcessEntityID => $Ticket{$ProcessEntityIDField},
                            TicketID        => $Ticket{TicketID},
                        },
                    );
                }
            }
            else {
                $LayoutObject->Block(
                    Name => 'NoActivityDialogs',
                    Data => {},
                );
            }
        }
    }

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = {
        %{ $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")->{DynamicField} || {} },
        %{
            $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")
                ->{ProcessWidgetDynamicField}
                || {}
        },
    };

    # get the dynamic fields for ticket object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );
    my $DynamicFieldBeckendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # to store dynamic fields to be displayed in the process widget and in the sidebar
    my ( @FieldsWidget, @FieldsSidebar );

    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
        next DYNAMICFIELD if $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } eq '';

        # use translation here to be able to reduce the character length in the template
        my $Label = $LayoutObject->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} );

        if (
            $IsProcessTicket &&
            $Self->{DisplaySettings}->{ProcessWidgetDynamicField}->{ $DynamicFieldConfig->{Name} }
            )
        {
            my $ValueStrg = $DynamicFieldBeckendObject->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                LayoutObject       => $LayoutObject,

                # no ValueMaxChars here, enough space available
            );

            push @FieldsWidget, {
                Name  => $DynamicFieldConfig->{Name},
                Title => $ValueStrg->{Title},
                Value => $ValueStrg->{Value},
                ValueKey
                    => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                Label                       => $Label,
                Link                        => $ValueStrg->{Link},
                $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
            };
        }

        my $ValueStrg = $DynamicFieldBeckendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            LayoutObject       => $LayoutObject,
            ValueMaxChars      => $ConfigObject->
                Get('Ticket::Frontend::DynamicFieldsZoomMaxSizeSidebar')
                || 18,    # limit for sidebar display
        );

        if (
            $Self->{DisplaySettings}->{DynamicField}->{ $DynamicFieldConfig->{Name} }
            )
        {
            push @FieldsSidebar, {
                Name                        => $DynamicFieldConfig->{Name},
                Title                       => $ValueStrg->{Title},
                Value                       => $ValueStrg->{Value},
                Label                       => $Label,
                Link                        => $ValueStrg->{Link},
                $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
            };
        }

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
            },
        );

        $LayoutObject->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
            Data => {
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );
    }

    if ($IsProcessTicket) {

        # output dynamic fields registered for a group in the process widget
        my @FieldsInAGroup;
        for my $GroupName (
            sort keys %{ $Self->{DisplaySettings}->{ProcessWidgetDynamicFieldGroups} }
            )
        {

            $LayoutObject->Block(
                Name => 'ProcessWidgetDynamicFieldGroups',
            );

            my $GroupFieldsString = $Self->{DisplaySettings}->{ProcessWidgetDynamicFieldGroups}->{$GroupName};

            $GroupFieldsString =~ s{\s}{}xmsg;
            my @GroupFields = split( ',', $GroupFieldsString );

            if ( $#GroupFields + 1 ) {

                my $ShowGroupTitle = 0;
                for my $Field (@FieldsWidget) {

                    if ( grep { $_ eq $Field->{Name} } @GroupFields ) {

                        $ShowGroupTitle = 1;
                        $LayoutObject->Block(
                            Name => 'ProcessWidgetDynamicField',
                            Data => {
                                Label => $Field->{Label},
                                Name  => $Field->{Name},
                            },
                        );

                        $LayoutObject->Block(
                            Name => 'ProcessWidgetDynamicFieldValueOverlayTrigger',
                        );

                        if ( $Field->{Link} ) {
                            $LayoutObject->Block(
                                Name => 'ProcessWidgetDynamicFieldLink',
                                Data => {
                                    %Ticket,

                                    # alias for ticket title, Title will be overwritten
                                    TicketTitle    => $Ticket{Title},
                                    Value          => $Field->{Value},
                                    Title          => $Field->{Title},
                                    Link           => $Field->{Link},
                                    $Field->{Name} => $Field->{Title},
                                },
                            );
                        }
                        else {
                            $LayoutObject->Block(
                                Name => 'ProcessWidgetDynamicFieldPlain',
                                Data => {
                                    Value => $Field->{Value},
                                    Title => $Field->{Title},
                                },
                            );
                        }
                        push @FieldsInAGroup, $Field->{Name};
                    }
                }

                if ($ShowGroupTitle) {
                    $LayoutObject->Block(
                        Name => 'ProcessWidgetDynamicFieldGroupSeparator',
                        Data => {
                            Name => $GroupName,
                        },
                    );
                }
            }
        }

        # output dynamic fields not registered in a group in the process widget
        my @RemainingFieldsWidget;
        for my $Field (@FieldsWidget) {

            if ( !grep { $_ eq $Field->{Name} } @FieldsInAGroup ) {
                push @RemainingFieldsWidget, $Field;
            }
        }

        $LayoutObject->Block(
            Name => 'ProcessWidgetDynamicFieldGroups',
        );

        if ( $#RemainingFieldsWidget + 1 ) {

            $LayoutObject->Block(
                Name => 'ProcessWidgetDynamicFieldGroupSeparator',
                Data => {
                    Name =>
                        $LayoutObject->{LanguageObject}->Translate('Fields with no group'),
                },
            );
        }
        for my $Field (@RemainingFieldsWidget) {

            $LayoutObject->Block(
                Name => 'ProcessWidgetDynamicField',
                Data => {
                    Label => $Field->{Label},
                    Name  => $Field->{Name},
                },
            );

            $LayoutObject->Block(
                Name => 'ProcessWidgetDynamicFieldValueOverlayTrigger',
            );

            if ( $Field->{Link} ) {
                $LayoutObject->Block(
                    Name => 'ProcessWidgetDynamicFieldLink',
                    Data => {
                        %Ticket,

                        # alias for ticket title, Title will be overwritten
                        TicketTitle    => $Ticket{Title},
                        Value          => $Field->{Value},
                        Title          => $Field->{Title},
                        Link           => $Field->{Link},
                        $Field->{Name} => $Field->{Title},
                    },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'ProcessWidgetDynamicFieldPlain',
                    Data => {
                        Value => $Field->{Value},
                        Title => $Field->{Title},
                    },
                );
            }
        }
    }

    # output dynamic fields in the sidebar
    for my $Field (@FieldsSidebar) {

        $LayoutObject->Block(
            Name => 'TicketDynamicField',
            Data => {
                Label => $Field->{Label},
            },
        );

        if ( $Field->{Link} ) {
            $LayoutObject->Block(
                Name => 'TicketDynamicFieldLink',
                Data => {
                    %Ticket,

                    # alias for ticket title, Title will be overwritten
                    TicketTitle    => $Ticket{Title},
                    Value          => $Field->{Value},
                    Title          => $Field->{Title},
                    Link           => $Field->{Link},
                    $Field->{Name} => $Field->{Title},
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'TicketDynamicFieldPlain',
                Data => {
                    Value => $Field->{Value},
                    Title => $Field->{Title},
                },
            );
        }
    }

    # customer info string
    if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoZoom') ) {

        # customer info
        my %CustomerData;
        if ( $Ticket{CustomerUserID} ) {
            %CustomerData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }
        $Param{CustomerTable} = $LayoutObject->AgentCustomerViewTable(
            Data   => \%CustomerData,
            Ticket => \%Ticket,
            Max    => $ConfigObject->Get('Ticket::Frontend::CustomerInfoZoomMaxSize'),
        );
        $LayoutObject->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # get linked objects
    my $LinkListWithData = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkListWithData(
        Object           => 'Ticket',
        Key              => $Self->{TicketID},
        State            => 'Valid',
        UserID           => $Self->{UserID},
        ObjectParameters => {
            Ticket => {
                IgnoreLinkedTicketStateTypes => 1,
            },
        },
    );

    # get link table view mode
    my $LinkTableViewMode = $ConfigObject->Get('LinkObject::ViewMode');

    # create the link table
    my $LinkTableStrg = $LayoutObject->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithData,
        ViewMode         => $LinkTableViewMode,
    );

    # output the simple link table
    if ( $LinkTableStrg && $LinkTableViewMode eq 'Simple' ) {
        $LayoutObject->Block(
            Name => 'LinkTableSimple',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
    }

    # output the complex link table
    if ( $LinkTableStrg && $LinkTableViewMode eq 'Complex' ) {
        $LayoutObject->Block(
            Name => 'LinkTableComplex',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
    }

    # article filter is activated in sysconfig
    if ( $Self->{ArticleFilterActive} ) {

        if ( $Self->{ZoomTimeline} ) {

            # build event type list for filter dialog
            $Param{EventTypeFilterString} = $LayoutObject->BuildSelection(
                Data        => $Self->{HistoryTypeMapping},
                SelectedID  => $Self->{EventTypeFilter}->{EventTypeID},
                Translation => 1,
                Multiple    => 1,
                Sort        => 'AlphanumericValue',
                Name        => 'EventTypeFilter',
            );

            $LayoutObject->Block(
                Name => 'EventTypeFilterDialog',
                Data => {%Param},
            );
        }
        else {

            # get article types
            my %ArticleTypes = $TicketObject->ArticleTypeList(
                Result => 'HASH',
            );

            # build article type list for filter dialog
            $Param{ArticleTypeFilterString} = $LayoutObject->BuildSelection(
                Data        => \%ArticleTypes,
                SelectedID  => $Self->{ArticleFilter}->{ArticleTypeID},
                Translation => 1,
                Multiple    => 1,
                Sort        => 'AlphanumericValue',
                Name        => 'ArticleTypeFilter',
            );

            # get sender types
            my %ArticleSenderTypes = $TicketObject->ArticleSenderTypeList(
                Result => 'HASH',
            );

            # build article sender type list for filter dialog
            $Param{ArticleSenderTypeFilterString} = $LayoutObject->BuildSelection(
                Data        => \%ArticleSenderTypes,
                SelectedID  => $Self->{ArticleFilter}->{ArticleSenderTypeID},
                Translation => 1,
                Multiple    => 1,
                Sort        => 'AlphanumericValue',
                Name        => 'ArticleSenderTypeFilter',
            );

            # Ticket ID
            $Param{TicketID} = $Self->{TicketID};

            $LayoutObject->Block(
                Name => 'ArticleFilterDialog',
                Data => {%Param},
            );
        }

    }

    # check if ticket need to be marked as seen
    my $ArticleAllSeen = 1;
    ARTICLE:
    for my $Article (@ArticleBox) {

        # ignore system sender type
        next ARTICLE
            if $ConfigObject->Get('Ticket::NewArticleIgnoreSystemSender')
            && $Article->{SenderType} eq 'system';

        # last ARTICLE if article was not shown
        if ( !$ArticleFlags{ $Article->{ArticleID} }->{Seen} ) {
            $ArticleAllSeen = 0;
            last ARTICLE;
        }
    }

    # mark ticket as seen if all article are shown
    if ($ArticleAllSeen) {
        $TicketObject->TicketFlagSet(
            TicketID => $Self->{TicketID},
            Key      => 'Seen',
            Value    => 1,
            UserID   => $Self->{UserID},
        );
    }

    # init js
    $LayoutObject->Block(
        Name => 'TicketZoomInit',
        Data => {%Param},
    );

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom',
        Data         => { %Param, %Ticket, %AclAction },
    );
}

sub _ArticleTree {
    my ( $Self, %Param ) = @_;

    my %Ticket          = %{ $Param{Ticket} };
    my %ArticleFlags    = %{ $Param{ArticleFlags} };
    my @ArticleBox      = @{ $Param{ArticleBox} };
    my $ArticleMaxLimit = $Param{ArticleMaxLimit};
    my $ArticleID       = $Param{ArticleID};
    my $TableClasses;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build thread string
    $LayoutObject->Block(
        Name => 'Tree',
        Data => {
            %Param,
            TableClasses => $TableClasses,
            ZoomTimeline => $Self->{ZoomTimeline},
        },
    );

    if ( $Param{Pagination} && !$Self->{ZoomTimeline} ) {
        $LayoutObject->Block(
            Name => 'ArticlePages',
            Data => $Param{Pagination},
        );
    }

    # check if expand/collapse view is usable (not available for too many
    # articles)
    if ( $Self->{ZoomExpand} && $#ArticleBox < $ArticleMaxLimit ) {
        $LayoutObject->Block(
            Name => 'Collapse',
            Data => {
                %Ticket,
                ArticleID      => $ArticleID,
                ZoomExpand     => $Self->{ZoomExpand},
                ZoomExpandSort => $Self->{ZoomExpandSort},
                Page           => $Param{Page},
            },
        );
    }
    elsif ( $Self->{ZoomTimeline} ) {

        # show trigger for timeline view
        $LayoutObject->Block(
            Name => 'Timeline',
            Data => {
                %Ticket,
                ArticleID      => $ArticleID,
                ZoomExpand     => $Self->{ZoomExpand},
                ZoomExpandSort => $Self->{ZoomExpandSort},
                Page           => $Param{Page},
            },
        );
    }
    elsif ( $#ArticleBox < $ArticleMaxLimit ) {
        $LayoutObject->Block(
            Name => 'Expand',
            Data => {
                %Ticket,
                ArticleID      => $ArticleID,
                ZoomExpand     => $Self->{ZoomExpand},
                ZoomExpandSort => $Self->{ZoomExpandSort},
                Page           => $Param{Page},
            },
        );
    }

    # article filter is activated in sysconfig
    if ( $Self->{ArticleFilterActive} ) {

        # define highlight style for links if filter is active
        my $HighlightStyle = 'menu';
        if ( $Self->{ArticleFilter} ) {
            $HighlightStyle = 'PriorityID-5';
        }

        # build article filter links
        $LayoutObject->Block(
            Name => 'ArticleFilterDialogLink',
            Data => {
                %Param,
                HighlightStyle => $HighlightStyle,
            },
        );

        # build article filter reset link only if filter is set
        if (
            ( !$Self->{ZoomTimeline} && $Self->{ArticleFilter} )
            || ( $Self->{ZoomTimeline} && $Self->{EventTypeFilter} )
            )
        {
            $LayoutObject->Block(
                Name => 'ArticleFilterResetLink',
                Data => {%Param},
            );
        }
    }

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # show article tree
    if ( !$Self->{ZoomTimeline} ) {

        $LayoutObject->Block(
            Name => 'ArticleList',
            Data => {
                %Param,
                TableClasses => $TableClasses,
            },
        );

        ARTICLE:
        for my $ArticleTmp (@ArticleBox) {
            my %Article = %$ArticleTmp;

            # article filter is activated in sysconfig and there are articles
            # that passed the filter
            if ( $Self->{ArticleFilterActive} ) {
                if ( $Self->{ArticleFilter} && $Self->{ArticleFilter}->{ShownArticleIDs} ) {

                    # do not show article in tree if it does not match the filter
                    if ( !$Self->{ArticleFilter}->{ShownArticleIDs}->{ $Article{ArticleID} } ) {
                        next ARTICLE;
                    }
                }
            }

            # show article flags
            my $Class      = '';
            my $ClassRow   = '';
            my $NewArticle = 0;

            # ignore system sender types
            if (
                !$ArticleFlags{ $Article{ArticleID} }->{Seen}
                && (
                    !$ConfigObject->Get('Ticket::NewArticleIgnoreSystemSender')
                    || $ConfigObject->Get('Ticket::NewArticleIgnoreSystemSender')
                    && $Article{SenderType} ne 'system'
                )
                )
            {
                $NewArticle = 1;

                # show ticket flags

                # always show archived tickets as seen
                if ( $Ticket{ArchiveFlag} ne 'y' ) {
                    $Class    .= ' UnreadArticles';
                    $ClassRow .= ' UnreadArticles';
                }

                # just show ticket flags if agent belongs to the ticket
                my $ShowMeta;
                if (
                    $Self->{UserID} == $Article{OwnerID}
                    || $Self->{UserID} == $Article{ResponsibleID}
                    )
                {
                    $ShowMeta = 1;
                }
                if ( !$ShowMeta && $ConfigObject->Get('Ticket::Watcher') ) {
                    my %Watch = $TicketObject->TicketWatchGet(
                        TicketID => $Article{TicketID},
                    );
                    if ( $Watch{ $Self->{UserID} } ) {
                        $ShowMeta = 1;
                    }
                }

                # show ticket flags
                if ($ShowMeta) {
                    $Class .= ' Remarkable';
                }
                else {
                    $Class .= ' Ordinary';
                }
            }

            # if this is the shown article -=> set class to active
            if ( $ArticleID eq $Article{ArticleID} && !$Self->{ZoomExpand} ) {
                $ClassRow .= ' Active';
            }

            my $TmpSubject = $TicketObject->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject      => $Article{Subject} || '',
            );

            # check if we need to show also expand/collapse icon
            $LayoutObject->Block(
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

            # get article flags
            # Always use user id 1 because other users also have to see the important flag
            my %ArticleImportantFlags = $TicketObject->ArticleFlagGet(
                ArticleID => $Article{ArticleID},
                UserID    => 1,
            );

            # show important flag
            if ( $ArticleImportantFlags{Important} ) {
                $LayoutObject->Block(
                    Name => 'TreeItemImportantArticle',
                    Data => {},
                );
            }

            # always show archived tickets as seen
            if ( $NewArticle && $Ticket{ArchiveFlag} ne 'y' ) {
                $LayoutObject->Block(
                    Name => 'TreeItemNewArticle',
                    Data => {
                        %Article,
                        Class => $Class,
                    },
                );
            }

            # Bugfix for IE7: a table cell should not be empty
            # (because otherwise the cell borders are not shown):
            # we add an empty element here
            else {
                $LayoutObject->Block(
                    Name => 'TreeItemNoNewArticle',
                    Data => {},
                );
            }

            # Determine communication direction
            if ( $Article{ArticleType} =~ /-internal$/smx ) {
                $LayoutObject->Block( Name => 'TreeItemDirectionInternal' );
            }
            else {
                if ( $Article{SenderType} eq 'customer' ) {
                    $LayoutObject->Block( Name => 'TreeItemDirectionIncoming' );
                }
                else {
                    $LayoutObject->Block( Name => 'TreeItemDirectionOutgoing' );
                }
            }

            # show attachment info
            # Bugfix for IE7: a table cell should not be empty
            # (because otherwise the cell borders are not shown):
            # we add an empty element here
            if ( !$Article{Atms} || !%{ $Article{Atms} } ) {
                $LayoutObject->Block(
                    Name => 'TreeItemNoAttachment',
                    Data => {},
                );

                next ARTICLE;
            }
            else {

                my $Attachments = $Self->_CollectArticleAttachments(
                    Article => \%Article,
                );

                $LayoutObject->Block(
                    Name => 'TreeItemAttachment',
                    Data => {
                        ArticleID   => $Article{ArticleID},
                        Attachments => $Attachments,
                    },
                );
            }

        }
    }

    # show timeline view
    else {

        # get ticket history
        my @HistoryLines = $TicketObject->HistoryGet(
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );

        # get articles for later use
        my @TimelineArticleBox = $TicketObject->ArticleContentIndex(
            TicketID                   => $Self->{TicketID},
            DynamicFields              => 0,
            UserID                     => $Self->{UserID},
            StripPlainBodyAsAttachment => 2,
        );

        my $ArticlesByArticleID = {};
        for my $Article ( sort @TimelineArticleBox ) {

            # get attachment index (without attachments)
            my %AtmIndex = $TicketObject->ArticleAttachmentIndex(
                ArticleID                  => $Article->{ArticleID},
                Article                    => $Article,
                UserID                     => $Self->{UserID},
                StripPlainBodyAsAttachment => 1,
            );
            $Article->{Atms} = \%AtmIndex;
            $ArticlesByArticleID->{ $Article->{ArticleID} } = $Article;
        }

        # do not display these types
        my @TypesDodge = qw(
            Misc
            ArchiveFlagUpdate
            LoopProtection
            Remove
            Subscribe
            Unsubscribe
            SystemRequest
            SendAgentNotification
            SendCustomerNotification
            SendAutoReject
        );

        # sort out non-filtered event types (if applicable)
        if (
            $Self->{EventTypeFilter}->{EventTypeID}
            && IsArrayRefWithData( $Self->{EventTypeFilter}->{EventTypeID} )
            )
        {
            for my $EventType ( sort keys %{ $Self->{HistoryTypeMapping} } ) {
                if (
                    $EventType ne 'NewTicket' && !grep { $_ eq $EventType }
                    @{ $Self->{EventTypeFilter}->{EventTypeID} }
                    )
                {
                    push @TypesDodge, $EventType;
                }
            }
        }

        # types which can be described as 'action on a ticket'
        my @TypesTicketAction = qw(
            ServiceUpdate
            SLAUpdate
            StateUpdate
            SetPendingTime
            Unlock
            Lock
            ResponsibleUpdate
            OwnerUpdate
            CustomerUpdate
            NewTicket
            TicketLinkAdd
            TicketLinkDelete
            TicketDynamicFieldUpdate
            Move
            Merged
            PriorityUpdate
            TitleUpdate
            TypeUpdate
            EscalationResponseTimeNotifyBefore
            EscalationResponseTimeStart
            EscalationResponseTimeStop
            EscalationSolutionTimeNotifyBefore
            EscalationSolutionTimeStart
            EscalationSolutionTimeStop
            EscalationUpdateTimeNotifyBefore
            EscalationUpdateTimeStart
            EscalationUpdateTimeStop
            TimeAccounting
        );

        # types which are usually being connected to some kind of
        # automatic process (e.g. triggered by another action)
        my @TypesTicketAutoAction = qw(
            SendAutoFollowUp
            SendAutoReject
            SendAutoReply
        );

        # types which can be considered as internal
        my @TypesInternal = qw(
            AddNote
            ChatInternal
        );

        # outgoing types
        my @TypesOutgoing = qw(
            Forward
            EmailAgent
            PhoneCallAgent
            Bounce
            SendAnswer
        );

        # incoming types
        my @TypesIncoming = qw(
            EmailCustomer
            AddNoteCustomer
            PhoneCallCustomer
            FollowUp
            WebRequestCustomer
            ChatExternal
        );

        my @TypesLeft = (
            @TypesOutgoing,
            @TypesInternal,
            @TypesTicketAutoAction,
        );

        my @TypesRight = (
            @TypesIncoming,
            @TypesTicketAction,
        );

        my @TypesWithArticles = (
            @TypesOutgoing,
            @TypesInternal,
            @TypesIncoming,
            'PhoneCallCustomer',
        );

        my %HistoryItems;
        my $ItemCounter = 0;
        my $LastCreateTime;
        my $LastCreateSystemTime;

        # Get mapping of history types to readable strings
        my %HistoryTypes;
        my %HistoryTypeConfig = %{ $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::HistoryTypes') // {} };
        for my $Entry ( sort keys %HistoryTypeConfig ) {
            %HistoryTypes = (
                %HistoryTypes,
                %{ $HistoryTypeConfig{$Entry} },
            );
        }

        HISTORYITEM:
        for my $Item ( reverse @HistoryLines ) {

            if ( grep { $_ eq $Item->{HistoryType} } @TypesDodge ) {
                next HISTORYITEM;
            }

            $Item->{Counter} = $ItemCounter++;

            # check which color the item should have
            if ( $Item->{HistoryType} eq 'NewTicket' ) {

                # if the 'NewTicket' item has an article, display this "creation article" event separately
                if ( $Item->{ArticleID} ) {
                    push @{ $Param{Items} }, {
                        %{$Item},
                        Counter             => $Item->{Counter}++,
                        Class               => 'NewTicket',
                        Name                => '',
                        ArticleID           => '',
                        HistoryTypeReadable => 'Ticket Created',
                        Orientation         => 'Right',
                    };
                }
                else {
                    $Item->{Class} = 'NewTicket';
                    delete $Item->{ArticleID};
                    delete $Item->{Name};
                }
            }

            # special treatment for certain types, e.g. external notes from customers
            elsif (
                $Item->{ArticleID}
                && $Item->{HistoryType} eq 'AddNote'
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{SenderType} eq 'customer'
                )
            {
                $Item->{Class} = 'TypeIncoming';

                # We fake a custom history type because external notes from customers still
                # have the history type 'AddNote' which does not allow for distinguishing.
                $Item->{HistoryType} = 'AddNoteCustomer';
            }

            # special treatment for certain types, e.g. external notes from customers
            elsif (
                $Item->{ArticleID}
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{ArticleType} eq 'chat-external'
                )
            {
                $Item->{HistoryType} = 'ChatExternal';
                $Item->{Class}       = 'TypeIncoming';
            }
            elsif (
                $Item->{ArticleID}
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{ArticleType} eq 'chat-internal'
                )
            {
                $Item->{HistoryType} = 'ChatInternal';
                $Item->{Class}       = 'TypeInternal';
            }
            elsif (
                $Item->{HistoryType} eq 'Forward'
                && $Item->{ArticleID}
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{ArticleType} eq 'email-internal'
                )
            {

                $Item->{Class} = 'TypeNoteInternal';
            }
            elsif ( grep { $_ eq $Item->{HistoryType} } @TypesTicketAction ) {
                $Item->{Class} = 'TypeTicketAction';
            }
            elsif ( grep { $_ eq $Item->{HistoryType} } @TypesTicketAutoAction ) {
                $Item->{Class} = 'TypeTicketAutoAction';
            }
            elsif ( grep { $_ eq $Item->{HistoryType} } @TypesInternal ) {
                $Item->{Class} = 'TypeNoteInternal';
            }
            elsif ( grep { $_ eq $Item->{HistoryType} } @TypesIncoming ) {
                $Item->{Class} = 'TypeIncoming';
            }
            elsif ( grep { $_ eq $Item->{HistoryType} } @TypesOutgoing ) {
                $Item->{Class} = 'TypeOutgoing';
            }

            # remove article information from types which should not display articles
            if ( !grep { $_ eq $Item->{HistoryType} } @TypesWithArticles ) {
                delete $Item->{ArticleID};
            }

            # get article (if present)
            if ( $Item->{ArticleID} ) {
                $Item->{ArticleData} = $ArticlesByArticleID->{ $Item->{ArticleID} };

                # security="restricted" may break SSO - disable this feature if requested
                if ( $ConfigObject->Get('DisableMSIFrameSecurityRestricted') ) {
                    $Item->{ArticleData}->{MSSecurityRestricted} = '';
                }
                else {
                    $Item->{ArticleData}->{MSSecurityRestricted} = 'security="restricted"';
                }

                my %ArticleFlagsAll = $TicketObject->ArticleFlagGet(
                    ArticleID => $Item->{ArticleID},
                    UserID    => 1,
                );

                my %ArticleFlagsMe = $TicketObject->ArticleFlagGet(
                    ArticleID => $Item->{ArticleID},
                    UserID    => $Self->{UserID},
                );

                $Item->{ArticleData}->{ArticleIsImportant} = $ArticleFlagsAll{Important};
                $Item->{ArticleData}->{ArticleIsSeen}      = $ArticleFlagsMe{Seen};

                if (
                    $Item->{ArticleData}->{ArticleType} eq 'chat-external'
                    || $Item->{ArticleData}->{ArticleType} eq 'chat-internal'
                    )
                {
                    $Item->{IsChatArticle} = 1;

                    # display only the first three (shortened) lines of a chart article
                    my $ChatMessages = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                        Data => $Item->{ArticleData}->{Body},
                    );

                    my $ItemCounter = 0;

                    CHATITEM:
                    for my $MessageData ( sort { $a->{ID} <=> $b->{ID} } @{$ChatMessages} ) {
                        if ( $MessageData->{SystemGenerated} == 1 ) {

                            $Item->{ArticleData}->{BodyChat} .= $LayoutObject->Output(
                                Template =>
                                    '<div class="ChatMessage SystemGenerated"><span>[[% Data.CreateTime | html %]]</span> - [% Data.MessageText | html %]</div>',
                                Data => $MessageData,
                            );
                        }
                        else {

                            $Item->{ArticleData}->{BodyChat} .= $LayoutObject->Output(
                                Template =>
                                    '<div class="ChatMessage"><span>[[% Data.CreateTime | html %]]</span> - [% Data.ChatterName | html %]: [% Data.MessageText | html %]</div>',
                                Data => $MessageData,
                            );
                        }
                        $ItemCounter++;
                        last CHATITEM if $ItemCounter == 7;
                    }
                }
                else {

                    # remove empty lines
                    $Item->{ArticleData}->{Body} =~ s{^[\n\r]+}{}xmsg;
                }
            }
            else {

                if ( $Item->{Name} && $Item->{Name} =~ m/^%%/x ) {
                    $Item->{Name} =~ s/^%%//xg;
                    my @Values = split( /%%/x, $Item->{Name} );
                    $Item->{Name} = $LayoutObject->{LanguageObject}->Translate(
                        $HistoryTypes{ $Item->{HistoryType} },
                        @Values,
                    );

                    # remove not needed place holder
                    $Item->{Name} =~ s/\%s//xg;

                    # remove IDs
                    $Item->{Name} =~ s/\s+\(\d\)//xg;
                    $Item->{Name} =~ s/\s+\(ID=\d\)//xg;
                    $Item->{Name} =~ s/\s+\(ID=\)//xg;
                }
            }

            # make the history type more readable (if applicable)
            $Item->{HistoryTypeReadable}
                = $Self->{HistoryTypeMapping}->{ $Item->{HistoryType} } || $Item->{HistoryType};

            # group items which happened (nearly) coincidently together
            $Item->{CreateSystemTime} = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
                String => $Item->{CreateTime}
            );

            # if we have two events that happened 'nearly' the same time, treat
            # them as if they happened exactly on the same time (treshold 5 seconds)
            if (
                $LastCreateSystemTime
                && $Item->{CreateSystemTime} <= $LastCreateSystemTime
                && $Item->{CreateSystemTime} >= ( $LastCreateSystemTime - 5 )
                )
            {
                push @{ $HistoryItems{$LastCreateTime} }, $Item;
                $Item->{CreateTime} = $LastCreateTime;
            }
            else {
                push @{ $HistoryItems{ $Item->{CreateTime} } }, $Item;
            }

            $LastCreateTime       = $Item->{CreateTime};
            $LastCreateSystemTime = $Item->{CreateSystemTime};
        }

        my $SortByArticle = sub {

            my $IsA = grep { $_ eq $a->{HistoryType} } @TypesWithArticles;
            my $IsB = grep { $_ eq $b->{HistoryType} } @TypesWithArticles;
            $IsB cmp $IsA;
        };

        # sort history items based on items with articles
        # these items should always be on top of a list of connected items
        $ItemCounter = 0;
        for my $Item ( reverse sort keys %HistoryItems ) {

            for my $SubItem ( sort $SortByArticle @{ $HistoryItems{$Item} } ) {
                $SubItem->{Counter} = $ItemCounter++;

                if ( grep { $_ eq $SubItem->{HistoryType} } @TypesRight ) {
                    $SubItem->{Orientation} = 'Right';
                }
                else {
                    $SubItem->{Orientation} = 'Left';
                }
                push @{ $Param{Items} }, $SubItem;
            }
        }

        # set TicketID for usage in JS
        $Param{TicketID} = $Self->{TicketID};

        $LayoutObject->Block(
            Name => 'TimelineView',
            Data => \%Param,
        );

        # jump to selected article
        if ( $Self->{ArticleID} ) {
            $LayoutObject->Block(
                Name => 'ShowSelectedArticle',
                Data => {
                    ArticleID => $Self->{ArticleID},
                },
            );
        }

        # render action menu for all articles
        for my $ArticleID ( sort keys %{$ArticlesByArticleID} ) {

            my @MenuItems = $Self->_ArticleMenu(
                Ticket            => $Param{Ticket},
                AclAction         => $Param{AclAction},
                Article           => $ArticlesByArticleID->{$ArticleID},
                StandardResponses => $Param{StandardResponses},
                StandardForwards  => $Param{StandardForwards},
                Type              => 'Static',
            );

            $LayoutObject->Block(
                Name => 'TimelineViewTicketActions',
                Data => {
                    ArticleID => $ArticleID,
                    TicketID  => $Self->{TicketID},
                    MenuItems => \@MenuItems,
                    }
            );

            # show attachments box
            if ( IsHashRefWithData( $ArticlesByArticleID->{$ArticleID}->{Atms} ) ) {

                my $ArticleAttachments = $Self->_CollectArticleAttachments(
                    Article => $ArticlesByArticleID->{$ArticleID},
                );

                $LayoutObject->Block(
                    Name => 'TimelineViewArticleAttachments',
                    Data => {
                        ArticleID   => $ArticleID,
                        Attachments => $ArticleAttachments,
                        }
                );
            }
        }
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom',
        Data         => { %Param, %Ticket },
    );
}

sub _TicketItemSeen {
    my ( $Self, %Param ) = @_;

    my @ArticleIDs = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleIndex(
        TicketID => $Param{TicketID},
    );

    for my $ArticleID (@ArticleIDs) {
        $Self->_ArticleItemSeen(
            ArticleID => $ArticleID,
        );
    }

    return 1;
}

sub _ArticleItemSeen {
    my ( $Self, %Param ) = @_;

    # mark shown article as seen
    $Kernel::OM->Get('Kernel::System::Ticket')->ArticleFlagSet(
        ArticleID => $Param{ArticleID},
        Key       => 'Seen',
        Value     => 1,
        UserID    => $Self->{UserID},
    );

    return 1;
}

sub _ArticleItem {
    my ( $Self, %Param ) = @_;

    my %Ticket    = %{ $Param{Ticket} };
    my %Article   = %{ $Param{Article} };
    my %AclAction = %{ $Param{AclAction} };

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # cleanup subject
    $Article{Subject} = $TicketObject->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject      => $Article{Subject} || '',
        Size         => 0,
    );

    # show article actions
    my @MenuItems = $Self->_ArticleMenu(
        %Param,
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'ArticleItem',
        Data => { %Param, %Article, %AclAction, MenuItems => \@MenuItems },
    );

    # show created by if different from User ID 1
    if ( $Article{CreatedBy} > 1 ) {
        $Article{CreatedByUser} = $Kernel::OM->Get('Kernel::System::User')->UserName( UserID => $Article{CreatedBy} );
        $LayoutObject->Block(
            Name => 'ArticleCreatedBy',
            Data => {%Article},
        );
    }

    # always show archived tickets as seen
    if ( $Ticket{ArchiveFlag} ne 'y' ) {

        # mark shown article as seen
        if ( $Param{Type} eq 'OnLoad' ) {
            $Self->_ArticleItemSeen( ArticleID => $Article{ArticleID} );
        }
        else {
            if (
                !$Self->{ZoomExpand}
                && defined $Param{ActualArticleID}
                && $Param{ActualArticleID} == $Article{ArticleID}
                )
            {
                $LayoutObject->Block(
                    Name => 'ArticleItemMarkAsSeen',
                    Data => { %Param, %Article, %AclAction },
                );
            }
        }
    }

    # get cofig object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # do some strips && quoting
    my $RecipientDisplayType = $ConfigObject->Get('Ticket::Frontend::DefaultRecipientDisplayType') || 'Realname';
    my $SenderDisplayType    = $ConfigObject->Get('Ticket::Frontend::DefaultSenderDisplayType')    || 'Realname';
    KEY:
    for my $Key (qw(From To Cc)) {
        next KEY if !$Article{$Key};

        my $DisplayType = $Key eq 'From'             ? $SenderDisplayType : $RecipientDisplayType;
        my $HiddenType  = $DisplayType eq 'Realname' ? 'Value'            : 'Realname';
        $LayoutObject->Block(
            Name => 'RowRecipient',
            Data => {
                Key                  => $Key,
                Value                => $Article{$Key},
                Realname             => $Article{ $Key . 'Realname' },
                ArticleID            => $Article{ArticleID},
                $HiddenType . Hidden => 'Hidden',
            },
        );
    }

    # show accounted article time
    if (
        $ConfigObject->Get('Ticket::ZoomTimeDisplay')
        && $ConfigObject->Get('Ticket::Frontend::AccountTime')
        )
    {
        my $ArticleTime = $TicketObject->ArticleAccountedTimeGet(
            ArticleID => $Article{ArticleID}
        );
        if ($ArticleTime) {
            $LayoutObject->Block(
                Name => 'ArticleAccountedTime',
                Data => {
                    Key   => 'Time',
                    Value => $ArticleTime,
                },
            );
        }
    }

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = {
        %{ $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")->{DynamicField} || {} },
        %{
            $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")
                ->{ProcessWidgetDynamicField}
                || {}
        },
    };

    # get the dynamic fields for article object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Article'],
        FieldFilter => $DynamicFieldFilter || {},
    );
    my $DynamicFieldBeckendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # cycle trough the activated Dynamic Fields
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $Value = $DynamicFieldBeckendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Article{ArticleID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq '';

        # get print string for this dynamic field
        my $ValueStrg = $DynamicFieldBeckendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            ValueMaxChars      => $ConfigObject->
                Get('Ticket::Frontend::DynamicFieldsZoomMaxSizeArticle')
                || 160,    # limit for article display
            LayoutObject => $LayoutObject,
        );

        my $Label = $DynamicFieldConfig->{Label};

        $LayoutObject->Block(
            Name => 'ArticleDynamicField',
            Data => {
                Label => $Label,
            },
        );

        if ( $ValueStrg->{Link} ) {

            # output link element
            $LayoutObject->Block(
                Name => 'ArticleDynamicFieldLink',
                Data => {
                    %Ticket,

                    # alias for ticket title, Title will be overwritten
                    TicketTitle                 => $Ticket{Title},
                    Value                       => $ValueStrg->{Value},
                    Title                       => $ValueStrg->{Title},
                    Link                        => $ValueStrg->{Link},
                    $DynamicFieldConfig->{Name} => $ValueStrg->{Title}
                },
            );
        }
        else {

            # output non link element
            $LayoutObject->Block(
                Name => 'ArticleDynamicFieldPlain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'ArticleDynamicField' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );

        if ( $ValueStrg->{Link} ) {

            # output link element
            $LayoutObject->Block(
                Name => 'ArticleDynamicField' . $DynamicFieldConfig->{Name} . 'Link',
                Data => {
                    %Ticket,

                    # alias for ticket title, Title will be overwritten
                    TicketTitle                 => $Ticket{Title},
                    Value                       => $ValueStrg->{Value},
                    Title                       => $ValueStrg->{Title},
                    Link                        => $ValueStrg->{Link},
                    $DynamicFieldConfig->{Name} => $ValueStrg->{Title}
                },
            );
        }
        else {

            # output non link element
            $LayoutObject->Block(
                Name => 'ArticleDynamicField' . $DynamicFieldConfig->{Name} . 'Plain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # run article view modules
    my $Config = $ConfigObject->Get('Ticket::Frontend::ArticleViewModule');
    if ( ref $Config eq 'HASH' ) {
        my %Jobs = %{$Config};
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                return $LayoutObject->ErrorScreen();
            }
            my $Object = $Jobs{$Job}->{Module}->new(
                %{$Self},
                TicketID  => $Self->{TicketID},
                ArticleID => $Article{ArticleID},
            );

            # run module
            my @Data = $Object->Check(
                Article => \%Article,
                %Ticket, Config => $Jobs{$Job}
            );
            for my $DataRef (@Data) {
                if ( !$DataRef->{Successful} ) {
                    $DataRef->{Result} = 'Error';
                }
                else {
                    $DataRef->{Result} = 'Notice';
                }

                $LayoutObject->Block(
                    Name => 'ArticleOption',
                    Data => $DataRef,
                );

                for my $Warning ( @{ $DataRef->{Warnings} } ) {
                    $LayoutObject->Block(
                        Name => 'ArticleOption',
                        Data => $Warning,
                    );
                }
            }

            # filter option
            $Object->Filter(
                Article => \%Article,
                %Ticket, Config => $Jobs{$Job}
            );
        }
    }

    %Article = $TicketObject->ArticleGet(
        ArticleID     => $Article{ArticleID},
        DynamicFields => 0,
    );

    # get attachment index (without attachments)
    my %AtmIndex = $TicketObject->ArticleAttachmentIndex(
        ArticleID                  => $Article{ArticleID},
        StripPlainBodyAsAttachment => $Self->{StripPlainBodyAsAttachment},
        Article                    => \%Article,
        UserID                     => $Self->{UserID},
    );
    $Article{Atms} = \%AtmIndex;

    # add block for attachments
    if ( $Article{Atms} && %{ $Article{Atms} } ) {
        my %AtmIndex = %{ $Article{Atms} };
        $LayoutObject->Block(
            Name => 'ArticleAttachment',
            Data => {},
        );

        my $Config = $ConfigObject->Get('Ticket::Frontend::ArticleAttachmentModule');
        ATTACHMENT:
        for my $FileID ( sort keys %AtmIndex ) {
            my %File = %{ $AtmIndex{$FileID} };
            $LayoutObject->Block(
                Name => 'ArticleAttachmentRow',
                Data => \%File,
            );

            # run article attachment modules
            next ATTACHMENT if ref $Config ne 'HASH';
            my %Jobs = %{$Config};
            JOB:
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                    return $LayoutObject->ErrorScreen();
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

                # check for the display of the filesize
                if ( $Job eq '2-HTML-Viewer' ) {
                    $Data{DataFileSize} = ", " . $File{Filesize};
                }
                $LayoutObject->Block(
                    Name => $Data{Block} || 'ArticleAttachmentRowLink',
                    Data => {%Data},
                );
            }
        }
    }

    # Special treatment for chat articles
    if ( $Article{ArticleType} eq 'chat-external' || $Article{ArticleType} eq 'chat-internal' ) {

        $LayoutObject->Block(
            Name => 'BodyChat',
            Data => {
                ChatMessages => $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                    Data => $Article{Body},
                ),
            },
        );

        return 1;
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
        $Article{Body} = $LayoutObject->Ascii2Html(
            NewLine        => $ConfigObject->Get('DefaultViewNewLine'),
            Text           => $Article{Body},
            VMax           => $ConfigObject->Get('DefaultViewLines') || 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    # security="restricted" may break SSO - disable this feature if requested
    if ( $ConfigObject->Get('DisableMSIFrameSecurityRestricted') ) {
        $Article{MSSecurityRestricted} = '';
    }
    else {
        $Article{MSSecurityRestricted} = 'security="restricted"';
    }

    # show body
    # Create a reference to an anonymous copy of %Article and pass it to
    # the LayoutObject, because %Article may be modified afterwards.
    $LayoutObject->Block(
        Name => $ViewMode,
        Data => {%Article},
    );

    # show message about links in iframes, if user didn't close it already
    if ( $ViewMode eq 'BodyHTML' && !$Self->{DoNotShowBrowserLinkMessage} ) {
        $LayoutObject->Block(
            Name => 'BrowserLinkMessage',
        );
    }

    # restore plain body for further processing by ArticleViewModules
    if ( !$Self->{RichText} || !$Article{AttachmentIDOfHTMLBody} ) {
        $Article{Body} = $Article{BodyPlain};
    }

    return 1;
}

sub _ArticleMenu {

    my ( $Self, %Param ) = @_;

    my %Ticket    = %{ $Param{Ticket} };
    my %Article   = %{ $Param{Article} };
    my %AclAction = %{ $Param{AclAction} };

    my @MenuItems;

    my %AclActionLookup = reverse %AclAction;

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # select the output template
    if ( $Article{ArticleType} !~ /^(note|email-noti|chat)/i ) {

        # check if compose link should be shown
        if (
            $ConfigObject->Get('Frontend::Module')->{AgentTicketCompose}
            && ( $AclActionLookup{AgentTicketCompose} )
            )
        {
            my $Access = 1;
            my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketCompose');
            if ( $Config->{Permission} ) {
                my $Ok = $TicketObject->TicketPermission(
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
                my $Locked = $TicketObject->TicketLockGet(
                    TicketID => $Ticket{TicketID}
                );
                if ($Locked) {
                    my $AccessOk = $TicketObject->OwnerCheck(
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
                my %StandardResponseHash = %{ $Param{StandardResponses} || {} };

                # get revers StandardResponseHash because we need to sort by Values
                # from %ReverseStandardResponseHash we get value of Key by %StandardResponseHash Value
                # and @StandardResponseArray is created as array of hashes with elements Key and Value

                my %ReverseStandardResponseHash = reverse %StandardResponseHash;
                my @StandardResponseArray       = map {
                    {
                        Key   => $ReverseStandardResponseHash{$_},
                        Value => $_
                    }
                } sort values %StandardResponseHash;

                # use this array twice (also for Reply All), so copy it first
                my @StandardResponseArrayReplyAll = @StandardResponseArray;

                unshift(
                    @StandardResponseArray,
                    {
                        Key   => '0',
                        Value => '- '
                            . $LayoutObject->{LanguageObject}->Translate('Reply') . ' -',
                        Selected => 1,
                    }
                );

                # build html string
                my $StandardResponsesStrg = $LayoutObject->BuildSelection(
                    Name => 'ResponseID',
                    ID   => 'ResponseID',
                    Data => \@StandardResponseArray,
                );

                push @MenuItems, {
                    ItemType              => 'Dropdown',
                    DropdownType          => 'Reply',
                    StandardResponsesStrg => $StandardResponsesStrg,
                    Name                  => 'Reply',
                    Class                 => 'AsPopup PopupType_TicketAction',
                    Action                => 'AgentTicketCompose',
                    FormID                => 'Reply' . $Article{ArticleID},
                    ResponseElementID     => 'ResponseID',
                    Type                  => $Param{Type},
                };

                # check if reply all is needed
                my $Recipients = '';
                KEY:
                for my $Key (qw(From To Cc)) {
                    next KEY if !$Article{$Key};
                    if ($Recipients) {
                        $Recipients .= ', ';
                    }
                    $Recipients .= $Article{$Key};
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
                        my $IsLocal = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress(
                            Address => $Email,
                        );
                        next ADDRESS if $IsLocal;
                        $RecipientCount++;
                    }
                }
                if ( $RecipientCount > 1 ) {
                    unshift(
                        @StandardResponseArrayReplyAll,
                        {
                            Key   => '0',
                            Value => '- '
                                . $LayoutObject->{LanguageObject}->Translate('Reply All') . ' -',
                            Selected => 1,
                        }
                    );

                    $StandardResponsesStrg = $LayoutObject->BuildSelection(
                        Name => 'ResponseID',
                        ID   => 'ResponseIDAll' . $Article{ArticleID},
                        Data => \@StandardResponseArrayReplyAll,
                    );

                    push @MenuItems, {
                        ItemType              => 'Dropdown',
                        DropdownType          => 'Reply',
                        StandardResponsesStrg => $StandardResponsesStrg,
                        Name                  => 'Reply All',
                        Class                 => 'AsPopup PopupType_TicketAction',
                        Action                => 'AgentTicketCompose',
                        FormID                => 'ReplyAll' . $Article{ArticleID},
                        ReplyAll              => 1,
                        ResponseElementID     => 'ResponseIDAll' . $Article{ArticleID},
                        Type                  => $Param{Type},
                    };
                }
            }
        }

        # check if forward link should be shown
        # (only show forward on email-external, email-internal, phone, webrequest and fax
        if (
            $ConfigObject->Get('Frontend::Module')->{AgentTicketForward}
            && $AclActionLookup{AgentTicketForward}
            && $Article{ArticleType} =~ /^(email-external|email-internal|phone|webrequest|fax)$/i
            )
        {
            my $Access = 1;
            my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketForward');
            if ( $Config->{Permission} ) {
                my $OK = $TicketObject->TicketPermission(
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
                if ( $TicketObject->TicketLockGet( TicketID => $Ticket{TicketID} ) )
                {
                    my $AccessOk = $TicketObject->OwnerCheck(
                        TicketID => $Ticket{TicketID},
                        OwnerID  => $Self->{UserID},
                    );
                    if ( !$AccessOk ) {
                        $Access = 0;
                    }
                }
            }
            if ($Access) {

                if ( IsHashRefWithData( $Param{StandardForwards} ) ) {

                    # get StandardForwardsStrg
                    my %StandardForwardHash = %{ $Param{StandardForwards} };

                    # get revers @StandardForwardHash because we need to sort by Values
                    # from %ReverseStandarForward we get value of Key by %StandardForwardHash Value
                    # and @StandardForwardArray is created as array of hashes with elements Key and Value
                    my %ReverseStandarForward = reverse %StandardForwardHash;
                    my @StandardForwardArray  = map {
                        {
                            Key   => $ReverseStandarForward{$_},
                            Value => $_
                        }
                    } sort values %StandardForwardHash;

                    unshift(
                        @StandardForwardArray,
                        {
                            Key   => '0',
                            Value => '- '
                                . $LayoutObject->{LanguageObject}->Translate('Forward')
                                . ' -',
                            Selected => 1,
                        }
                    );

                    # build html string
                    my $StandardForwardsStrg = $LayoutObject->BuildSelection(
                        Name => 'ForwardTemplateID',
                        ID   => 'ForwardTemplateID',
                        Data => \@StandardForwardArray,
                    );

                    push @MenuItems, {
                        ItemType             => 'Dropdown',
                        DropdownType         => 'Forward',
                        StandardForwardsStrg => $StandardForwardsStrg,
                        Name                 => 'Forward',
                        Class                => 'AsPopup PopupType_TicketAction',
                        Action               => 'AgentTicketForward',
                        FormID               => 'Forward' . $Article{ArticleID},
                        ForwardElementID     => 'ForwardTemplateID',
                        Type                 => $Param{Type},
                    };

                }
                else {

                    push @MenuItems, {
                        ItemType    => 'Link',
                        Description => 'Forward article via mail',
                        Name        => 'Forward',
                        Class       => 'AsPopup PopupType_TicketAction',
                        Link =>
                            "Action=AgentTicketForward;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID}"
                    };
                }
            }
        }

        # check if bounce link should be shown
        # (only show forward on email-external and email-internal
        if (
            $ConfigObject->Get('Frontend::Module')->{AgentTicketBounce}
            && $AclActionLookup{AgentTicketBounce}
            && $Article{ArticleType} =~ /^(email-external|email-internal)$/i
            )
        {
            my $Access = 1;
            my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketBounce');
            if ( $Config->{Permission} ) {
                my $OK = $TicketObject->TicketPermission(
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
                if ( $TicketObject->TicketLockGet( TicketID => $Ticket{TicketID} ) )
                {
                    my $AccessOk = $TicketObject->OwnerCheck(
                        TicketID => $Ticket{TicketID},
                        OwnerID  => $Self->{UserID},
                    );
                    if ( !$AccessOk ) {
                        $Access = 0;
                    }
                }
            }
            if ($Access) {

                push @MenuItems, {
                    ItemType    => 'Link',
                    Description => 'Bounce Article to a different mail address',
                    Name        => 'Bounce',
                    Class       => 'AsPopup PopupType_TicketAction',
                    Link =>
                        "Action=AgentTicketBounce;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID}"
                };
            }
        }
    }

    # check if split link should be shown
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentTicketPhone}
        && $AclActionLookup{AgentTicketPhone}
        && $Article{ArticleType} !~ /^(chat-external|chat-internal)$/i
        )
    {

        push @MenuItems, {
            ItemType    => 'Link',
            Description => 'Split this article',
            Name        => 'Split',
            Link =>
                "Action=AgentTicketPhone;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID};LinkTicketID=$Ticket{TicketID}"
        };
    }

    # check if print link should be shown
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentTicketPrint}
        && $AclActionLookup{AgentTicketPrint}
        )
    {
        my $OK = $TicketObject->TicketPermission(
            Type     => 'ro',
            TicketID => $Ticket{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
        if ($OK) {

            push @MenuItems, {
                ItemType    => 'Link',
                Description => 'Print this article',
                Name        => 'Print',
                Class       => 'AsPopup PopupType_TicketAction',
                Link =>
                    "Action=AgentTicketPrint;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID}"
            };
        }
    }

    # check if plain link should be shown
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentTicketPlain}
        && $ConfigObject->Get('Ticket::Frontend::PlainView')
        && $AclActionLookup{AgentTicketPlain}
        && $Article{ArticleType} =~ /email/i
        )
    {
        my $OK = $TicketObject->TicketPermission(
            Type     => 'ro',
            TicketID => $Ticket{TicketID},
            UserID   => $Self->{UserID},
            LogNo    => 1,
        );
        if ($OK) {

            push @MenuItems, {
                ItemType    => 'Link',
                Description => 'View the source for this Article',
                Name        => 'Plain Format',
                Class       => 'AsPopup PopupType_TicketAction',
                Link =>
                    "Action=AgentTicketPlain;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID}",
            };
        }
    }

    # Owner and Responsible can mark articles as important or remove mark
    if (
        $Self->{UserID} == $Ticket{OwnerID}
        || (
            $ConfigObject->Get('Ticket::Responsible')
            && $Self->{UserID} == $Ticket{ResponsibleID}
        )
        )
    {

        # Always use user id 1 because other users also have to see the important flag
        my %ArticleFlags = $TicketObject->ArticleFlagGet(
            ArticleID => $Article{ArticleID},
            UserID    => 1,
        );

        my $ArticleIsImportant = $ArticleFlags{Important};

        my $Link
            = "Action=AgentTicketZoom;Subaction=MarkAsImportant;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID}";
        my $Description = 'Mark';
        if ($ArticleIsImportant) {
            $Description = 'Unmark';
        }

        # set important menu item
        push @MenuItems, {
            ItemType    => 'Link',
            Description => $Description,
            Name        => $Description,
            Link        => $Link,
        };
    }

    # check if internal reply link should be shown
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentTicketNote}
        && $AclActionLookup{AgentTicketNote}
        && $Article{ArticleType} =~ /^note-(internal|external)$/i
        )
    {

        my $Link        = "Action=AgentTicketNote;TicketID=$Ticket{TicketID};ReplyToArticle=$Article{ArticleID}";
        my $Description = 'Reply to note';

        # set important menu item
        push @MenuItems, {
            ItemType    => 'Link',
            Description => $Description,
            Name        => $Description,
            Class       => 'AsPopup PopupType_TicketAction',
            Link        => $Link,
        };
    }

    return @MenuItems;
}

sub _CollectArticleAttachments {

    my ( $Self, %Param ) = @_;

    my %Article = %{ $Param{Article} };

    my %Attachments;

    # get cofig object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # download type
    my $Type = $ConfigObject->Get('AttachmentDownloadType') || 'attachment';

    $Article{AtmCount} = scalar keys %{ $Article{Atms} // {} };

    # if attachment will be forced to download, don't open a new download window!
    my $Target = 'target="AttachmentWindow" ';
    if ( $Type =~ /inline/i ) {
        $Target = 'target="attachment" ';
    }

    $Attachments{ZoomAttachmentDisplayCount} = $ConfigObject->Get('Ticket::ZoomAttachmentDisplayCount');

    ATTACHMENT:
    for my $FileID ( sort keys %{ $Article{Atms} } ) {
        push @{ $Attachments{Files} }, {
            ArticleID => $Article{ArticleID},
            %{ $Article{Atms}->{$FileID} },
            FileID => $FileID,
            Target => $Target,
            }
    }

    return \%Attachments;
}

1;
