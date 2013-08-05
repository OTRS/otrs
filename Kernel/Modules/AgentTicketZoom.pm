# --
# Kernel/Modules/AgentTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketZoom;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::EmailParser;
use Kernel::System::LinkObject;
use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::ActivityDialog;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::ProcessManagement::TransitionAction;
use Kernel::System::SystemAddress;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject UserObject SessionObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
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
    $Self->{ArticleFilterActive}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::TicketArticleFilter');

    # define if rich text should be used
    $Self->{RichText}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomRichTextForce')
        || $Self->{LayoutObject}->{BrowserRichText}
        || 0;

    # strip html and ascii attachments of content
    $Self->{StripPlainBodyAsAttachment} = 1;

    # check if rich text is enabled, if not only strip ascii attachments
    if ( !$Self->{RichText} ) {
        $Self->{StripPlainBodyAsAttachment} = 2;
    }

    # ticket id lookup
    if ( !$Self->{TicketID} && $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ) ) {
        $Self->{TicketID} = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ),
            UserID       => $Self->{UserID},
        );
    }
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);
    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # get dynamic field config for frontend module
    $Self->{DynamicFieldFilter} = {
        %{ $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketZoom")->{DynamicField} || {} },
        %{
            $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketZoom")
                ->{ProcessWidgetDynamicField}
                || {}
        },
    };

    # create additional objects for process management
    $Self->{ActivityObject} = Kernel::System::ProcessManagement::Activity->new(%Param);
    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::ActivityDialog->new(%Param);

    $Self->{TransitionObject} = Kernel::System::ProcessManagement::Transition->new(%Param);
    $Self->{TransitionActionObject}
        = Kernel::System::ProcessManagement::TransitionAction->new(%Param);

    $Self->{ProcessObject} = Kernel::System::ProcessManagement::Process->new(
        %Param,
        ActivityObject         => $Self->{ActivityObject},
        ActivityDialogObject   => $Self->{ActivityDialogObject},
        TransitionObject       => $Self->{TransitionObject},
        TransitionActionObject => $Self->{TransitionActionObject},
    );

    # get zoom settings depending on ticket type
    $Self->{DisplaySettings} = $Self->{ConfigObject}->Get("Ticket::Frontend::AgentTicketZoom");

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
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    # get acl actions
    $Self->{TicketObject}->TicketAcl(
        Data          => '-',
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if ACL restrictions exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    # mark shown ticket as seen
    if ( $Self->{Subaction} eq 'TicketMarkAsSeen' ) {
        my $Success = 1;

        # always show archived tickets as seen
        if ( $Ticket{ArchiveFlag} ne 'y' ) {
            $Success = $Self->_TicketItemSeen( TicketID => $Self->{TicketID} );
        }

        return $Self->{LayoutObject}->Attachment(
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
                $Self->{ConfigObject}->Get('Ticket::Responsible')
                && $Self->{UserID} == $Ticket{ResponsibleID}
            )
            )
        {
            # Always use user id 1 because other users also have to see the important flag
            my %ArticleFlag = $Self->{TicketObject}->ArticleFlagGet(
                ArticleID => $Self->{ArticleID},
                UserID    => 1,
            );

            my $ArticleIsImportant = $ArticleFlag{Important};
            if ($ArticleIsImportant) {

                # Always use user id 1 because other users also have to see the important flag
                $Self->{TicketObject}->ArticleFlagDelete(
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Important',
                    UserID    => 1,
                );
            }
            else {

                # Always use user id 1 because other users also have to see the important flag
                $Self->{TicketObject}->ArticleFlagSet(
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Important',
                    Value     => 1,
                    UserID    => 1,
                );
            }
        }

        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$Self->{ArticleID}",
        );
    }

    # mark shown article as seen
    if ( $Self->{Subaction} eq 'MarkAsSeen' ) {
        my $Success = 1;

        # always show archived tickets as seen
        if ( $Ticket{ArchiveFlag} ne 'y' ) {
            $Success = $Self->_ArticleItemSeen( ArticleID => $Self->{ArticleID} );
        }

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Content     => $Success,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # article update
    elsif ( $Self->{Subaction} eq 'ArticleUpdate' ) {
        my $Count = $Self->{ParamObject}->GetParam( Param => 'Count' );
        my %Article = $Self->{TicketObject}->ArticleGet(
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 0,
        );
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

        $Self->_ArticleItem(
            Ticket            => \%Ticket,
            Article           => \%Article,
            AclAction         => \%AclAction,
            StandardResponses => \%StandardResponses,
            Type              => 'OnLoad',
        );
        my $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketZoom',
            Data => { %Ticket, %Article, %AclAction },
        );
        if ( !$Content ) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't get for ArticleID $Self->{ArticleID}!",
            );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
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
        my %Article = $Self->{TicketObject}->ArticleGet(
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 0,
        );

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
        DynamicFields => 0,    # fetch later only for the article(s) to display
    );

    # add counter
    my $Count = 0;
    for my $Article (@ArticleBox) {
        $Count++;
        $Article->{Count} = $Count;
    }

    my %ArticleFlags = $Self->{TicketObject}->ArticleFlagsOfTicketGet(
        TicketID => $Ticket{TicketID},
        UserID   => $Self->{UserID},
    );

    # get selected or last customer article
    my $ArticleID;
    if ( $Self->{ArticleID} ) {
        $ArticleID = $Self->{ArticleID};
    }
    else {

        # find latest not seen article
        ARTICLE:
        for my $Article (@ArticleBox) {

            # ignore system sender type
            next ARTICLE
                if $Self->{ConfigObject}->Get('Ticket::NewArticleIgnoreSystemSender')
                && $Article->{SenderType} eq 'system';

            next ARTICLE if $ArticleFlags{ $Article->{ArticleID} }->{Seen};
            $ArticleID = $Article->{ArticleID};
            last ARTICLE;
        }

        # set selected article
        if ( !$ArticleID ) {
            if ( @ArticleBox && $Self->{ZoomExpandSort} eq 'normal' ) {

                # set first article as default if normal sort
                $ArticleID = $ArticleBox[0]->{ArticleID};
            }
            elsif ( @ArticleBox && $Self->{ZoomExpandSort} eq 'reverse' ) {

                # set last article as default if reverse sort
                $ArticleID = $ArticleBox[$#ArticleBox]->{ArticleID};
            }

            # set last customer article as selected article replacing last set
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
    if ( $Self->{ZoomExpandSort} eq 'reverse' ) {
        @ArticleBox      = reverse @ArticleBox;
        @ArticleBoxShown = reverse @ArticleBoxShown;
    }

    # set display options
    $Param{WidgetTitle} = 'Ticket Information';
    $Param{Hook} = $Self->{ConfigObject}->Get('Ticket::Hook') || 'Ticket#';

    # check if ticket is normal or process ticket
    my $IsProcessTicket = $Self->{TicketObject}->TicketCheckForProcessType(
        'TicketID' => $Self->{TicketID}
    );

    # overwrite display options for process ticket
    if ($IsProcessTicket) {
        $Param{WidgetTitle} = $Self->{DisplaySettings}->{ProcessDisplay}->{WidgetTitle};
    }

    # only show article tree if articles are present
    if (@ArticleBox) {

        # show article tree
        $Param{ArticleTree} = $Self->_ArticleTree(
            Ticket          => \%Ticket,
            ArticleFlags    => \%ArticleFlags,
            ArticleID       => $ArticleID,
            ArticleMaxLimit => $ArticleMaxLimit,
            ArticleBox      => \@ArticleBox,
        );
    }

    # show articles items
    $Param{ArticleItems} = '';
    ARTICLE:
    for my $ArticleTmp (@ArticleBoxShown) {
        my %Article = %$ArticleTmp;

        # article filter is activated in sysconfig and there are articles that passed the filter
        if ( $Self->{ArticleFilterActive} ) {
            if ( $Self->{ArticleFilter} && $Self->{ArticleFilter}->{ShownArticleIDs} ) {

                # do not show article if it does not match the filter
                if ( !$Self->{ArticleFilter}->{ShownArticleIDs}->{ $Article{ArticleID} } ) {
                    next ARTICLE;
                }
            }
        }

        $Self->_ArticleItem(
            Ticket            => \%Ticket,
            Article           => \%Article,
            AclAction         => \%AclAction,
            StandardResponses => \%StandardResponses,
            ActualArticleID   => $ArticleID,
            Type              => 'Static',
        );
    }
    $Param{ArticleItems} .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketZoom',
        Data => { %Ticket, %AclAction },
    );

    # always show archived tickets as seen
    if ( $Self->{ZoomExpand} && $Ticket{ArchiveFlag} ne 'y' ) {
        $Self->{LayoutObject}->Block(
            Name => 'TicketItemMarkAsSeen',
            Data => { TicketID => $Ticket{TicketID} },
        );
    }

    # age design
    $Ticket{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Ticket{Age}, Space => ' ' );

    # number of articles
    $Param{ArticleCount} = scalar @ArticleBox;

    $Self->{LayoutObject}->Block(
        Name => 'Header',
        Data => { %Param, %Ticket, %AclAction },
    );

    # run ticket menu modules
    if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule') };
        MENU:
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
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
            Name           => 'DestQueueID',
            Data           => \%MoveQueues,
            CurrentQueueID => $Ticket{QueueID},
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

    # show created by if different then User ID 1
    if ( $Ticket{CreateBy} > 1 ) {
        $Ticket{CreatedByUser} = $Self->{UserObject}->UserName( UserID => $Ticket{CreateBy} );
        $Self->{LayoutObject}->Block(
            Name => 'CreatedBy',
            Data => {%Ticket},
        );
    }

    if ( $Ticket{ArchiveFlag} eq 'y' ) {
        $Self->{LayoutObject}->Block(
            Name => 'ArchiveFlag',
            Data => { %Ticket, %AclAction },
        );
    }

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
        if ( 60 * 60 * 1 > $Ticket{FirstResponseTime} ) {
            $Ticket{FirstResponseTimeClass} = 'Warning';
        }
        $Self->{LayoutObject}->Block(
            Name => 'FirstResponseTime',
            Data => { %Ticket, %AclAction },
        );
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
        if ( 60 * 60 * 1 > $Ticket{UpdateTime} ) {
            $Ticket{UpdateTimeClass} = 'Warning';
        }
        $Self->{LayoutObject}->Block(
            Name => 'UpdateTime',
            Data => { %Ticket, %AclAction },
        );
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
        if ( 60 * 60 * 1 > $Ticket{SolutionTime} ) {
            $Ticket{SolutionTimeClass} = 'Warning';
        }
        $Self->{LayoutObject}->Block(
            Name => 'SolutionTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # test access to frontend module for Customer
    my $Access = $Self->{LayoutObject}->Permission(
        Action => 'AgentTicketCustomer',
        Type   => 'rw',
    );

    # acl check
    if (
        $Access
        && defined $AclAction{AgentTicketCustomer}
        && !$AclAction{AgentTicketCustomer}
        )
    {
        $Access = 0;
    }

    if ($Access) {

        # test access to ticket
        my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketCustomer');
        if ( $Config->{Permission} ) {
            my $OK = $Self->{TicketObject}->Permission(
                Type     => $Config->{Permission},
                TicketID => $Ticket{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
            if ( !$OK ) {
                $Access = 0;
            }
        }
    }

    # define proper DTL block based on permissions
    my $CustomerIDBlock = $Access ? 'CustomerIDRW' : 'CustomerIDRO';
    $Self->{LayoutObject}->Block(
        Name => $CustomerIDBlock,
        Data => \%Ticket,
    );

    # show total accounted time if feature is active:
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        $Ticket{TicketTimeUnits} = $Self->{TicketObject}->TicketAccountedTimeGet(%Ticket);
        $Self->{LayoutObject}->Block(
            Name => 'TotalAccountedTime',
            Data => \%Ticket,
        );
    }

    # show pending until, if set:
    if ( $Ticket{UntilTime} ) {
        if ( $Ticket{UntilTime} < -1 ) {
            $Ticket{PendingUntilClass} = 'Warning';
        }
        $Ticket{UntilTimeHuman} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => ( $Ticket{UntilTime} + $Self->{TimeObject}->SystemTime() ),
        );
        $Ticket{PendingUntil} .= $Self->{LayoutObject}->CustomerAge(
            Age   => $Ticket{UntilTime},
            Space => ' '
        );
        $Self->{LayoutObject}->Block(
            Name => 'PendingUntil',
            Data => \%Ticket,
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

    # show no articles block if ticket does not contain articles
    if ( !@ArticleBox ) {
        $Self->{LayoutObject}->Block(
            Name => 'HintNoArticles',
        );
    }

    # show process widget  and activity dialogs on process tickets
    if ($IsProcessTicket) {

        # get the DF where the ProcessEntityID is stored
        my $ProcessEntityIDField = 'DynamicField_'
            . $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementProcessID");

        # get the DF where the AtivityEntityID is stored
        my $ActivityEntityIDField = 'DynamicField_'
            . $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementActivityID");

        my $ProcessData = $Self->{ProcessObject}->ProcessGet(
            ProcessEntityID => $Ticket{$ProcessEntityIDField},
        );
        my $ActivityData = $Self->{ActivityObject}->ActivityGet(
            Interface        => 'AgentInterface',
            ActivityEntityID => $Ticket{$ActivityEntityIDField},
        );

        # output process information in the sidebar
        $Self->{LayoutObject}->Block(
            Name => 'ProcessData',
            Data => {
                Process  => $ProcessData->{Name}  || '',
                Activity => $ActivityData->{Name} || '',
            },
        );

        # output the process widget the the main screen
        $Self->{LayoutObject}->Block(
            Name => 'ProcessWidget',
            Data => {
                WidgetTitle => $Param{WidgetTitle},
            },
        );

        # get next activity dialogs
        my $NextActivityDialogs;
        if ( $Ticket{$ActivityEntityIDField} ) {
            $NextActivityDialogs = $ActivityData;
        }

        if ( IsHashRefWithData($NextActivityDialogs) ) {

            # we don't need the whole Activity config,
            # just the Activity Dialogs of the current Activity
            if ( IsHashRefWithData( $NextActivityDialogs->{ActivityDialog} ) ) {
                %{$NextActivityDialogs} = %{ $NextActivityDialogs->{ActivityDialog} };
            }
            else {
                $NextActivityDialogs = {};
            }

            # ACL Check is done in the initial "Run" statement
            # so here we can just pick the possibly reduced Activity Dialogs
            # map and sort reformat the $NextActivityDialogs hash from it's initial form e.g.:
            # 1 => 'AD1',
            # 2 => 'AD3',
            # 3 => 'AD2',
            # to a regular array in correct order:
            # ('AD1', 'AD3', 'AD2')

            my @TmpActivityDialogList
                = map { $NextActivityDialogs->{$_} } sort keys %{$NextActivityDialogs};

            # we have to check if the current user has the needed permissions to view the
            # different activity dialogs, so we loop over every activity dialog and check if there
            # is a permission configured. If there is a permission configured we check this
            # and display/hide the activity dialog link
            my %PermissionRights;
            my @PermissionActivityDialogList;
            ACTIVITYDIALOGPERMISSION:
            for my $CurrentActivityDialogEntityID (@TmpActivityDialogList) {
                my $CurrentActivityDialog
                    = $Self->{ActivityDialogObject}->ActivityDialogGet(
                    Interface              => 'AgentInterface',
                    ActivityDialogEntityID => $CurrentActivityDialogEntityID
                    );

                # create an interface lookuplist
                my %InterfaceLookup = map { $_ => 1 } @{ $CurrentActivityDialog->{Interface} };

                next ACTIVITYDIALOGPERMISSION if !$InterfaceLookup{AgentInterface};

                if ( $CurrentActivityDialog->{Permission} ) {

                    # performanceboost/cache
                    if ( !defined $PermissionRights{ $CurrentActivityDialog->{Permission} } ) {
                        $PermissionRights{ $CurrentActivityDialog->{Permission} }
                            = $Self->{TicketObject}->TicketPermission(
                            Type     => $CurrentActivityDialog->{Permission},
                            TicketID => $Ticket{TicketID},
                            UserID   => $Self->{UserID},
                            );
                    }

                    next ACTIVITYDIALOGPERMISSION
                        if !$PermissionRights{ $CurrentActivityDialog->{Permission} };
                }

                push @PermissionActivityDialogList, $CurrentActivityDialogEntityID;
            }

            my @PossibleActivityDialogs;
            if (@PermissionActivityDialogList) {
                @PossibleActivityDialogs
                    = $Self->{TicketObject}->TicketAclActivityDialogData(
                    ActivityDialogs => \@PermissionActivityDialogList
                    );
            }

            # reformat the @PossibleActivityDialogs that is of the structure:
            # @PossibleActivityDialogs = ('AD1', 'AD3', 'AD4', 'AD2');
            # to get the same structure as in the %NextActivityDialogs
            # e.g.:
            # 1 => 'AD1',
            # 2 => 'AD3',
            %{$NextActivityDialogs}
                = map { $_ => $PossibleActivityDialogs[ $_ - 1 ] }
                1 .. scalar @PossibleActivityDialogs;

            $Self->{LayoutObject}->Block(
                Name => 'NextActivityDialogs',
            );

            if ( IsHashRefWithData($NextActivityDialogs) ) {
                for my $NextActivityDialogKey ( sort keys %{$NextActivityDialogs} ) {
                    my $ActivityDialogData = $Self->{ActivityDialogObject}->ActivityDialogGet(
                        Interface              => 'AgentInterface',
                        ActivityDialogEntityID => $NextActivityDialogs->{$NextActivityDialogKey},
                    );
                    $Self->{LayoutObject}->Block(
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
                $Self->{LayoutObject}->Block(
                    Name => 'NoActivityDialogs',
                    Data => {},
                );
            }
        }
    }

    # get the dynamic fields for ticket object
    my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # to store dynamic fields to be displayed in the process widget and in the sidebar
    my ( @FieldsWidget, @FieldsSidebar );

    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
        next DYNAMICFIELD if $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } eq '';

        # use translation here to be able to reduce the character length in the template
        my $Label = $Self->{LayoutObject}->{LanguageObject}->Get( $DynamicFieldConfig->{Label} );

        if (
            $IsProcessTicket &&
            $Self->{DisplaySettings}->{ProcessWidgetDynamicField}->{ $DynamicFieldConfig->{Name} }
            )
        {
            my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                LayoutObject       => $Self->{LayoutObject},

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

        my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            LayoutObject       => $Self->{LayoutObject},
            ValueMaxChars      => $Self->{ConfigObject}->
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
        $Self->{LayoutObject}->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
            },
        );

        $Self->{LayoutObject}->Block(
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

            $Self->{LayoutObject}->Block(
                Name => 'ProcessWidgetDynamicFieldGroups',
            );

            my $GroupFieldsString
                = $Self->{DisplaySettings}->{ProcessWidgetDynamicFieldGroups}->{$GroupName};

            $GroupFieldsString =~ s{\s}{}xmsg;
            my @GroupFields = split( ',', $GroupFieldsString );

            if ( $#GroupFields + 1 ) {

                my $ShowGroupTitle = 0;
                for my $Field (@FieldsWidget) {

                    if ( grep { $_ eq $Field->{Name} } @GroupFields ) {

                        $ShowGroupTitle = 1;
                        $Self->{LayoutObject}->Block(
                            Name => 'ProcessWidgetDynamicField',
                            Data => {
                                Label => $Field->{Label},
                                Name  => $Field->{Name},
                            },
                        );

                        $Self->{LayoutObject}->Block(
                            Name => 'ProcessWidgetDynamicFieldValueOverlayTrigger',
                        );

                        if ( $Field->{Link} ) {
                            $Self->{LayoutObject}->Block(
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
                            $Self->{LayoutObject}->Block(
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
                    $Self->{LayoutObject}->Block(
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

        $Self->{LayoutObject}->Block(
            Name => 'ProcessWidgetDynamicFieldGroups',
        );

        if ( $#RemainingFieldsWidget + 1 ) {

            $Self->{LayoutObject}->Block(
                Name => 'ProcessWidgetDynamicFieldGroupSeparator',
                Data => {
                    Name => $Self->{LayoutObject}->{LanguageObject}->Get('Fields with no group'),
                },
            );
        }
        for my $Field (@RemainingFieldsWidget) {

            $Self->{LayoutObject}->Block(
                Name => 'ProcessWidgetDynamicField',
                Data => {
                    Label => $Field->{Label},
                    Name  => $Field->{Name},
                },
            );

            $Self->{LayoutObject}->Block(
                Name => 'ProcessWidgetDynamicFieldValueOverlayTrigger',
            );

            if ( $Field->{Link} ) {
                $Self->{LayoutObject}->Block(
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
                $Self->{LayoutObject}->Block(
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

        $Self->{LayoutObject}->Block(
            Name => 'TicketDynamicField',
            Data => {
                Label => $Field->{Label},
            },
        );

        if ( $Field->{Link} ) {
            $Self->{LayoutObject}->Block(
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
            $Self->{LayoutObject}->Block(
                Name => 'TicketDynamicFieldPlain',
                Data => {
                    Value => $Field->{Value},
                    Title => $Field->{Title},
                },
            );
        }
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

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'Ticket',
        Key    => $Self->{TicketID},
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

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
    ARTICLE:
    for my $Article (@ArticleBox) {

        # ignore system sender type
        next ARTICLE
            if $Self->{ConfigObject}->Get('Ticket::NewArticleIgnoreSystemSender')
            && $Article->{SenderType} eq 'system';

        # last if article was not shown
        if ( !$ArticleFlags{ $Article->{ArticleID} }->{Seen} ) {
            $ArticleAllSeen = 0;
            last ARTICLE;
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

    # init js
    $Self->{LayoutObject}->Block(
        Name => 'TicketZoomInit',
        Data => {%Param},
    );

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketZoom',
        Data => { %Param, %Ticket, %AclAction },
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
    if ( $Self->{ConfigObject}->Get('Ticket::UseArticleColors') ) {
        $TableClasses .= 'UseArticleColors';
    }

    # build thread string
    $Self->{LayoutObject}->Block(
        Name => 'Tree',
        Data => {
            %Param,
            TableClasses => $TableClasses,
        },
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
                !$Self->{ConfigObject}->Get('Ticket::NewArticleIgnoreSystemSender')
                || $Self->{ConfigObject}->Get('Ticket::NewArticleIgnoreSystemSender')
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

        # get article flags
        # Always use user id 1 because other users also have to see the important flag
        my %ArticleImportantFlags = $Self->{TicketObject}->ArticleFlagGet(
            ArticleID => $Article{ArticleID},
            UserID    => 1,
        );

        # show important flag
        if ( $ArticleImportantFlags{Important} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TreeItemImportantArticle',
                Data => {},
            );
        }

        # always show archived tickets as seen
        if ( $NewArticle && $Ticket{ArchiveFlag} ne 'y' ) {
            $Self->{LayoutObject}->Block(
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
            $Self->{LayoutObject}->Block(
                Name => 'TreeItemNoNewArticle',
                Data => {},
            );
        }

        # Determine communication direction
        if ( $Article{ArticleType} =~ /-internal$/smx ) {
            $Self->{LayoutObject}->Block( Name => 'TreeItemDirectionInternal' );
        }
        else {
            if ( $Article{SenderType} eq 'customer' ) {
                $Self->{LayoutObject}->Block( Name => 'TreeItemDirectionIncoming' );
            }
            else {
                $Self->{LayoutObject}->Block( Name => 'TreeItemDirectionOutgoing' );
            }
        }

        # show attachment info
        # Bugfix for IE7: a table cell should not be empty
        # (because otherwise the cell borders are not shown):
        # we add an empty element here
        if ( !$Article{Atms} || !%{ $Article{Atms} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'TreeItemNoAttachment',
                Data => {},
            );

            next ARTICLE;
        }

        # download type
        my $Type = $Self->{ConfigObject}->Get('AttachmentDownloadType') || 'attachment';

        # if attachment will be forced to download, don't open a new download window!
        my $Target = 'target="AttachmentWindow" ';
        if ( $Type =~ /inline/i ) {
            $Target = 'target="attachment" ';
        }
        my $ZoomAttachmentDisplayCount
            = $Self->{ConfigObject}->Get('Ticket::ZoomAttachmentDisplayCount');
        my $CountShown = 0;
        ATTACHMENT:
        for my $Count ( 1 .. ( $ZoomAttachmentDisplayCount + 2 ) ) {
            next ATTACHMENT if !$Article{Atms}->{$Count};
            if ( $CountShown == 0 ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TreeItemAttachment',
                    Data => {
                        %Article,
                    },
                );

                if ( scalar keys %{ $Article{Atms} } > 1 ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'TreeItemAttachmentIconMultiple',
                        Data => {
                            %Article,
                        },
                    );
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'TreeItemAttachmentIconSingle',
                        Data => {
                            %Article,
                            %{ $Article{Atms}->{$Count} },
                        },
                    );
                }

            }
            $CountShown++;

            # show more info
            last ATTACHMENT if $CountShown > $ZoomAttachmentDisplayCount;

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

sub _TicketItemSeen {
    my ( $Self, %Param ) = @_;

    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
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
    $Self->{TicketObject}->ArticleFlagSet(
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

    # cleanup subject
    $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject => $Article{Subject} || '',
        Size => 0,
    );

    $Self->{LayoutObject}->Block(
        Name => 'ArticleItem',
        Data => { %Param, %Article, %AclAction },
    );

    # show created by if different from User ID 1
    if ( $Article{CreatedBy} > 1 ) {
        $Article{CreatedByUser} = $Self->{UserObject}->UserName( UserID => $Article{CreatedBy} );
        $Self->{LayoutObject}->Block(
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
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleItemMarkAsSeen',
                    Data => { %Param, %Article, %AclAction },
                );
            }
        }
    }

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
                    Name => 'ArticleReplyAsDropdown',
                    Data => {
                        %Ticket, %Article, %AclAction,
                        StandardResponsesStrg => $StandardResponsesStrg,
                        Name                  => 'Reply',
                        Class                 => 'AsPopup PopupType_TicketAction',
                        Action                => 'AgentTicketCompose',
                        FormID                => 'Reply' . $Article{ArticleID},
                        ResponseElementID     => 'ResponseID',
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleReplyAsDropdownJS' . $Param{Type},
                    Data => {
                        %Ticket, %Article, %AclAction,
                        FormID => 'Reply' . $Article{ArticleID},
                    },
                );

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
                        next if !$Email;
                        my $IsLocal = $Self->{SystemAddress}->SystemAddressIsLocalAddress(
                            Address => $Email,
                        );
                        next ADDRESS if $IsLocal;
                        $RecipientCount++;
                    }
                }
                if ( $RecipientCount > 1 ) {
                    $Param{StandardResponses}->{0}
                        = '- ' . $Self->{LayoutObject}->{LanguageObject}->Get('Reply All') . ' -';

                    $StandardResponsesStrg = $Self->{LayoutObject}->BuildSelection(
                        Name => 'ResponseID',
                        ID   => 'ResponseIDAll',
                        Data => $Param{StandardResponses},
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'ArticleReplyAsDropdown',
                        Data => {
                            %Ticket, %Article, %AclAction,
                            StandardResponsesStrg => $StandardResponsesStrg,
                            Name                  => 'Reply All',
                            Class                 => 'AsPopup PopupType_TicketAction',
                            Action                => 'AgentTicketCompose',
                            FormID                => 'ReplyAll',
                            ReplyAll              => 1,
                            ResponseElementID     => 'ResponseIDAll',
                        },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'ArticleReplyAsDropdownJS' . $Param{Type},
                        Data => {
                            %Ticket, %Article, %AclAction,
                            FormID => 'ReplyAll',
                        },
                    );
                }
            }
        }

        # check if forward link should be shown
        # (only show forward on email-external, email-internal, phone, webrequest and fax
        if (
            $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketForward}
            && ( !defined $AclAction{AgentTicketForward} || $AclAction{AgentTicketForward} )
            && $Article{ArticleType} =~ /^(email-external|email-internal|phone|webrequest|fax)$/i
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
                        Description => 'Forward article via mail',
                        Name        => 'Forward',
                        Class       => 'AsPopup PopupType_TicketAction',
                        Link =>
                            'Action=AgentTicketForward;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}'
                    },
                );
            }
        }

        # check if bounce link should be shown
        # (only show forward on email-external and email-internal
        if (
            $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketBounce}
            && ( !defined $AclAction{AgentTicketBounce} || $AclAction{AgentTicketBounce} )
            && $Article{ArticleType} =~ /^(email-external|email-internal)$/i
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
                        Description => 'Bounce Article to a different mail address',
                        Name        => 'Bounce',
                        Class       => 'AsPopup PopupType_TicketAction',
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
                Description => 'Split this article',
                Name        => 'Split',
                Link =>
                    'Action=AgentTicketPhone;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"};LinkTicketID=$Data{"TicketID"}'
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
                    Description => 'Print this article',
                    Name        => 'Print',
                    Class       => 'AsPopup PopupType_TicketAction',
                    Link =>
                        'Action=AgentTicketPrint;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}'
                },
            );
        }
    }

    # check if plain link should be shown
    if (
        $Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPlain}
        && $Self->{ConfigObject}->Get('Ticket::Frontend::PlainView')
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
                    Description => 'View the source for this Article',
                    Name        => 'Plain Format',
                    Class       => 'AsPopup PopupType_TicketAction',
                    Link        => $Link,
                },
            );
        }
    }

    # Owner and Responsible can mark articles as important or remove mark
    if (
        $Self->{UserID} == $Ticket{OwnerID}
        || (
            $Self->{ConfigObject}->Get('Ticket::Responsible')
            && $Self->{UserID} == $Ticket{ResponsibleID}
        )
        )
    {

        # Always use user id 1 because other users also have to see the important flag
        my %ArticleFlags = $Self->{TicketObject}->ArticleFlagGet(
            ArticleID => $Article{ArticleID},
            UserID    => 1,
        );

        my $ArticleIsImportant = $ArticleFlags{Important};

        my $Link
            = 'Action=AgentTicketZoom;Subaction=MarkAsImportant;TicketID=$Data{"TicketID"};ArticleID=$Data{"ArticleID"}';
        my $Description = 'Mark article as important';
        if ($ArticleIsImportant) {
            $Description = 'Remove important mark';
        }

        # set important menu item
        $Self->{LayoutObject}->Block(
            Name => 'ArticleMenu',
            Data => {
                %Ticket, %Article, %AclAction,
                Description => $Description,
                Name        => $Description,
                Link        => $Link,
            },
        );
    }

    # do some strips && quoting
    KEY:
    for my $Key (qw(From To Cc)) {
        next KEY if !$Article{$Key};
        $Self->{LayoutObject}->Block(
            Name => 'RowRecipient',
            Data => {
                Key      => $Key,
                Value    => $Article{$Key},
                Realname => $Article{ $Key . 'Realname' },
            },
        );
    }

    # show accounted article time
    if (
        $Self->{ConfigObject}->Get('Ticket::ZoomTimeDisplay')
        && $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
        )
    {
        my $ArticleTime = $Self->{TicketObject}->ArticleAccountedTimeGet(
            ArticleID => $Article{ArticleID}
        );
        $Self->{LayoutObject}->Block(
            Name => 'ArticleAccountedTime',
            Data => {
                Key   => 'Time',
                Value => $ArticleTime,
            },
        );
    }

    # get the dynamic fields for article object
    my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Article'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # cycle trough the activated Dynamic Fields
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $Value = $Self->{BackendObject}->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Article{ArticleID},
        );

        next if !$Value;
        next if $Value eq '';

        # get print string for this dynamic field
        my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            ValueMaxChars      => $Self->{ConfigObject}->
                Get('Ticket::Frontend::DynamicFieldsZoomMaxSizeArticle')
                || 160,    # limit for article display
            LayoutObject => $Self->{LayoutObject},
        );

        my $Label = $DynamicFieldConfig->{Label};

        $Self->{LayoutObject}->Block(
            Name => 'ArticleDynamicField',
            Data => {
                Label => $Label,
            },
        );

        if ( $ValueStrg->{Link} ) {

            # output link element
            $Self->{LayoutObject}->Block(
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
            $Self->{LayoutObject}->Block(
                Name => 'ArticleDynamicFieldPlain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }

        # example of dynamic fields order customization
        $Self->{LayoutObject}->Block(
            Name => 'ArticleDynamicField' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );

        if ( $ValueStrg->{Link} ) {

            # output link element
            $Self->{LayoutObject}->Block(
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
            $Self->{LayoutObject}->Block(
                Name => 'ArticleDynamicField' . $DynamicFieldConfig->{Name} . 'Plain',
                Data => {
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
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
                    $DataRef->{Result} = 'Notice';
                }
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleOption',
                    Data => $DataRef,
                );

                for my $Warning ( @{ $DataRef->{Warnings} } ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ArticleOption',
                        Data => $Warning,
                    );
                }
            }

            # filter option
            $Object->Filter( Article => \%Article, %Ticket, Config => $Jobs{$Job} );
        }
    }

    %Article = $Self->{TicketObject}->ArticleGet(
        ArticleID     => $Article{ArticleID},
        DynamicFields => 0,
    );

    # get attachment index (without attachments)
    my %AtmIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
        ArticleID                  => $Article{ArticleID},
        StripPlainBodyAsAttachment => $Self->{StripPlainBodyAsAttachment},
        Article                    => \%Article,
        UserID                     => $Self->{UserID},
    );
    $Article{Atms} = \%AtmIndex;

    # add block for attachments
    if ( $Article{Atms} && %{ $Article{Atms} } ) {
        my %AtmIndex = %{ $Article{Atms} };
        $Self->{LayoutObject}->Block(
            Name => 'ArticleAttachment',
            Data => {},
        );

        my $Config = $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleAttachmentModule');
        ATTACHMENT:
        for my $FileID ( sort keys %AtmIndex ) {
            my %File = %{ $AtmIndex{$FileID} };
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachmentRow',
                Data => \%File,
            );

            # run article attachment modules
            next ATTACHMENT if ref $Config ne 'HASH';
            my %Jobs = %{$Config};
            JOB:
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

                # check for the display of the filesize
                if ( $Job eq '2-HTML-Viewer' && !%Data ) {
                    $Data{DataFileSize} = ", " . $File{Filesize};
                }
                elsif ( $Job eq '2-HTML-Viewer' && %Data ) {
                    $Data{DataFileSize} = ", " . $Data{Filesize};
                }
                $Self->{LayoutObject}->Block(
                    Name => $Data{Block} || 'ArticleAttachmentRowLink',
                    Data => {%Data},
                );
            }
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

    return 1;
}

1;
