# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketZoom;

use strict;
use warnings;
use utf8;

our $ObjectManagerDisabled = 1;

use POSIX qw/ceil/;
use Kernel::System::EmailParser;
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

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
    $Self->{ArticleView}    = $ParamObject->GetParam( Param => 'ArticleView' );
    $Self->{ZoomExpand}     = $ParamObject->GetParam( Param => 'ZoomExpand' );
    $Self->{ZoomExpandSort} = $ParamObject->GetParam( Param => 'ZoomExpandSort' );
    $Self->{ZoomTimeline}   = $ParamObject->GetParam( Param => 'ZoomTimeline' );

    my %UserPreferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    # save last used view type in preferences
    if ( !$Self->{Subaction} ) {

        if (
            !defined $Self->{ArticleView}
            && !defined $Self->{ZoomExpand}
            && !defined $Self->{ZoomTimeline}
            )
        {
            $Self->{ZoomExpand} = $ConfigObject->Get('Ticket::Frontend::AgentZoomExpand');
            if ( $UserPreferences{UserLastUsedZoomViewType} ) {
                if ( $UserPreferences{UserLastUsedZoomViewType} eq 'Expand' ) {
                    $Self->{ZoomExpand} = 1;
                }
                elsif ( $UserPreferences{UserLastUsedZoomViewType} eq 'Collapse' ) {
                    $Self->{ZoomExpand} = 0;
                }
                elsif ( $UserPreferences{UserLastUsedZoomViewType} eq 'Timeline' ) {
                    $Self->{ZoomTimeline} = 1;
                }
            }
        }

        elsif (
            defined $Self->{ArticleView}
            || defined $Self->{ZoomExpand}
            || defined $Self->{ZoomTimeline}
            )
        {
            my $LastUsedZoomViewType = '';

            if ( defined $Self->{ArticleView} ) {
                $LastUsedZoomViewType = $Self->{ArticleView};

                if ( $Self->{ArticleView} eq 'Expand' ) {
                    $Self->{ZoomExpand} = 1;
                }
                elsif ( $Self->{ArticleView} eq 'Collapse' ) {
                    $Self->{ZoomExpand} = 0;
                }
                elsif ( $Self->{ArticleView} eq 'Timeline' ) {
                    $Self->{ZoomTimeline} = 1;
                }
                else {
                    $LastUsedZoomViewType = $ConfigObject->Get('Ticket::Frontend::AgentZoomExpand')
                        ? 'Expand'
                        : 'Collapse';
                }
            }
            elsif ( defined $Self->{ZoomExpand} && $Self->{ZoomExpand} == 1 ) {
                $LastUsedZoomViewType = 'Expand';
            }
            elsif ( defined $Self->{ZoomExpand} && $Self->{ZoomExpand} == 0 ) {
                $LastUsedZoomViewType = 'Collapse';
            }
            elsif ( defined $Self->{ZoomTimeline} && $Self->{ZoomTimeline} == 1 ) {
                $LastUsedZoomViewType = 'Timeline';
            }
            $UserObject->SetPreferences(
                UserID => $Self->{UserID},
                Key    => 'UserLastUsedZoomViewType',
                Value  => $LastUsedZoomViewType,
            );
        }
    }

    # Please note: ZoomTimeline is an OTRSBusiness feature
    if ( !$ConfigObject->Get('TimelineViewEnabled') ) {
        $Self->{ZoomTimeline} = 0;
    }

    if ( !defined $Self->{DoNotShowBrowserLinkMessage} ) {
        if ( $UserPreferences{UserAgentDoNotShowBrowserLinkMessage} ) {
            $Self->{DoNotShowBrowserLinkMessage} = 1;
        }
        else {
            $Self->{DoNotShowBrowserLinkMessage} = 0;
        }
    }

    if ( !defined $Self->{ZoomExpandSort} ) {
        $Self->{ZoomExpandSort} = $ConfigObject->Get('Ticket::Frontend::ZoomExpandSort');
    }

    $Self->{ArticleFilterActive} = $ConfigObject->Get('Ticket::Frontend::TicketArticleFilter');

    # define if rich text should be used
    $Self->{RichText} = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

    # Always exclude plain text attachment, but exclude HTML body only if rich text is enabled.
    $Self->{ExcludeAttachments} = {
        ExcludePlainText => 1,
        ExcludeHTMLBody  => $Self->{RichText},
        ExcludeInline    => $Self->{RichText},
    };

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
        TicketLinkDelete                => Translatable('Link Deleted'),
        Lock                            => Translatable('Ticket Locked'),
        SetPendingTime                  => Translatable('Pending Time Set'),
        TicketDynamicFieldUpdate        => Translatable('Dynamic Field Updated'),
        EmailAgentInternal              => Translatable('Outgoing Email (internal)'),
        NewTicket                       => Translatable('Ticket Created'),
        TypeUpdate                      => Translatable('Type Updated'),
        EscalationUpdateTimeStart       => Translatable('Escalation Update Time In Effect'),
        EscalationUpdateTimeStop        => Translatable('Escalation Update Time Stopped'),
        EscalationFirstResponseTimeStop => Translatable('Escalation First Response Time Stopped'),
        CustomerUpdate                  => Translatable('Customer Updated'),
        ChatInternal                    => Translatable('Internal Chat'),
        SendAutoFollowUp                => Translatable('Automatic Follow-Up Sent'),
        AddNote                         => Translatable('Note Added'),
        AddNoteCustomer                 => Translatable('Note Added (Customer)'),
        AddSMS                          => Translatable('SMS Added'),
        AddSMSCustomer                  => Translatable('SMS Added (Customer)'),
        StateUpdate                     => Translatable('State Updated'),
        SendAnswer                      => Translatable('Outgoing Answer'),
        ServiceUpdate                   => Translatable('Service Updated'),
        TicketLinkAdd                   => Translatable('Link Added'),
        EmailCustomer                   => Translatable('Incoming Customer Email'),
        WebRequestCustomer              => Translatable('Incoming Web Request'),
        PriorityUpdate                  => Translatable('Priority Updated'),
        Unlock                          => Translatable('Ticket Unlocked'),
        EmailAgent                      => Translatable('Outgoing Email'),
        TitleUpdate                     => Translatable('Title Updated'),
        OwnerUpdate                     => Translatable('New Owner'),
        Merged                          => Translatable('Ticket Merged'),
        PhoneCallAgent                  => Translatable('Outgoing Phone Call'),
        Forward                         => Translatable('Forwarded Message'),
        Unsubscribe                     => Translatable('Removed User Subscription'),
        TimeAccounting                  => Translatable('Time Accounted'),
        PhoneCallCustomer               => Translatable('Incoming Phone Call'),
        SystemRequest                   => Translatable('System Request.'),
        FollowUp                        => Translatable('Incoming Follow-Up'),
        SendAutoReply                   => Translatable('Automatic Reply Sent'),
        SendAutoReject                  => Translatable('Automatic Reject Sent'),
        ResponsibleUpdate               => Translatable('New Responsible'),
        EscalationSolutionTimeStart     => Translatable('Escalation Solution Time In Effect'),
        EscalationSolutionTimeStop      => Translatable('Escalation Solution Time Stopped'),
        EscalationResponseTimeStart     => Translatable('Escalation Response Time In Effect'),
        EscalationResponseTimeStop      => Translatable('Escalation Response Time Stopped'),
        SLAUpdate                       => Translatable('SLA Updated'),
        ChatExternal                    => Translatable('External Chat'),
        Move                            => Translatable('Queue Changed'),
        SendAgentNotification           => Translatable('Notification Was Sent'),
    };

    # Add custom files to the zoom's frontend module registration on the fly
    #    to avoid conflicts with other modules.
    if (
        defined $ConfigObject->Get('TimelineViewEnabled')
        && $ConfigObject->Get('TimelineViewEnabled') == 1
        )
    {
        $ConfigObject->Set(
            Key   => 'Loader::Module::AgentTicketZoom###003-OTRSBusiness',
            Value => {
                JavaScript => [
                    'Core.Agent.TicketZoom.TimelineView.js',
                ],
            },
        );
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
            Message => Translatable('No TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get needed objects
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    return $LayoutObject->NoPermission(
        Message => Translatable(
            "This ticket does not exist, or you don't have permissions to access it in its current state."
        ),
        WithHeader => $Self->{Subaction} && $Self->{Subaction} eq 'ArticleUpdate' ? 'no' : 'yes',
    ) if !$Access;

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

    # send parameter TicketID to JS
    $LayoutObject->AddJSData(
        Key   => 'TicketID',
        Value => $Self->{TicketID},
    );

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
            my %ArticleFlag = $ArticleObject->ArticleFlagGet(
                TicketID  => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
                UserID    => 1,
            );

            my $ArticleIsImportant = $ArticleFlag{Important};
            if ($ArticleIsImportant) {

                # Always use user id 1 because other users also have to see the important flag
                $ArticleObject->ArticleFlagDelete(
                    TicketID  => $Self->{TicketID},
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Important',
                    UserID    => 1,
                );
            }
            else {

                # Always use user id 1 because other users also have to see the important flag
                $ArticleObject->ArticleFlagSet(
                    TicketID  => $Self->{TicketID},
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

    # get required objects
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');

    if ( $Self->{Subaction} eq 'FormDraftDelete' ) {
        my %Response;

        my $FormDraftID = $ParamObject->GetParam( Param => 'FormDraftID' ) || '';
        if ($FormDraftID) {
            $Response{Success} = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftDelete(
                FormDraftID => $FormDraftID,
                UserID      => $Self->{UserID},
            );
        }
        else {
            $Response{Error} = $LayoutObject->{LanguageObject}->Translate("Missing FormDraftID!");
        }

        # build JSON output
        my $JSON = $LayoutObject->JSONEncode(
            Data => \%Response,
        );

        # send JSON response
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    if ( $Self->{Subaction} eq 'LoadWidget' ) {
        my $ElementID = $ParamObject->GetParam( Param => 'ElementID' );
        my $Config;
        WIDGET:
        for my $Key ( sort keys %{ $Self->{DisplaySettings}->{Widgets} // {} } ) {
            if ( $ElementID eq 'Async_' . $LayoutObject->LinkEncode($Key) ) {
                $Config = $Self->{DisplaySettings}->{Widgets}->{$Key};
                last WIDGET;
            }
        }
        if ($Config) {
            my $Success = eval { $MainObject->Require( $Config->{Module} ) };
            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Cannot load $Config->{Module}: $@",
                );
                return $LayoutObject->Attachment(
                    ContentType => 'text/html',
                    Content     => '',
                    Type        => 'inline',
                    NoCache     => 1,
                );
            }
            my $Module = eval { $Config->{Module}->new( %{$Self} ) };
            if ( !$Module ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "new() of Widget module $Config->{Module} not successful!",

                );
                return $LayoutObject->Attachment(
                    ContentType => 'text/html',
                    Content     => '',
                    Type        => 'inline',
                    NoCache     => 1,
                );
            }
            my $WidgetOutput = $Module->Run(
                Ticket    => \%Ticket,
                AclAction => \%AclAction,
                Config    => $Config,
            );

            return $LayoutObject->Attachment(
                ContentType => 'text/html',
                Content     => $WidgetOutput->{Output} // ' ',
                Type        => 'inline',
                NoCache     => 1,
            );
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Cannot locate module for ElementID $ElementID",
            );
            return $LayoutObject->Attachment(
                ContentType => 'text/html',
                Content     => '',
                Type        => 'inline',
                NoCache     => 1,
            );
        }
    }

    # mark shown article as seen
    if ( $Self->{Subaction} eq 'MarkAsSeen' ) {
        my $Success = 1;

        # always show archived tickets as seen
        if ( $Ticket{ArchiveFlag} ne 'y' ) {
            $Success = $Self->_ArticleItemSeen(
                TicketID  => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
            );
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

        my $ArticleBackendObject = $ArticleObject->BackendForArticle(
            TicketID  => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
        );

        my %Article = $ArticleBackendObject->ArticleGet(
            TicketID      => $Self->{TicketID},
            ArticleID     => $Self->{ArticleID},
            RealNames     => 1,
            DynamicFields => 0,
        );
        $Article{Count} = $Count;

        # Get attachment index (excluding body attachments).
        my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID => $Self->{ArticleID},
            %{ $Self->{ExcludeAttachments} },
        );
        $Article{Atms} = \%AtmIndex;

        # fetch all std. templates
        my %StandardTemplates = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberList(
            QueueID       => $Ticket{QueueID},
            TemplateTypes => 1,
            Valid         => 1,
        );

        my $ArticleWidgetsHTML = $Self->_ArticleItem(
            Ticket            => \%Ticket,
            Article           => \%Article,
            AclAction         => \%AclAction,
            StandardResponses => $StandardTemplates{Answer},
            StandardForwards  => $StandardTemplates{Forward},
            Type              => 'OnLoad',
        );

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'ArticleIDs',
            Value => [ $Self->{ArticleID} ],
        );
        $LayoutObject->AddJSData(
            Key   => 'MenuItems',
            Value => $Self->{MenuItems},
        );

        my $Content = $LayoutObject->Output(
            TemplateFile => 'AgentTicketZoom',
            Data         => {
                %Ticket,
                %Article,
                %AclAction,
                ArticleWidgetsHTML => $ArticleWidgetsHTML
            },
            AJAX => 1,
        );
        if ( !$Content ) {
            $LayoutObject->FatalError(
                Message =>
                    $LayoutObject->{LanguageObject}->Translate( 'Can\'t get for ArticleID %s!', $Self->{ArticleID} ),
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
        my @CommunicationChannelFilterIDs = $ParamObject->GetArray( Param => 'CommunicationChannelFilter' );
        my $CustomerVisibility            = $ParamObject->GetParam( Param => 'CustomerVisibilityFilter' );
        my @ArticleSenderTypeFilterIDs    = $ParamObject->GetArray( Param => 'ArticleSenderTypeFilter' );

        # build session string
        my $SessionString = '';
        if (@CommunicationChannelFilterIDs) {
            $SessionString .= 'CommunicationChannelFilter<';
            $SessionString .= join ',', @CommunicationChannelFilterIDs;
            $SessionString .= '>';
        }
        if ( defined $CustomerVisibility && $CustomerVisibility != 2 ) {
            $SessionString .= "CustomerVisibilityFilter<$CustomerVisibility>";
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
                    Message => Translatable('Article filter settings were saved.'),
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
                    Message => Translatable('Event type filter settings were saved.'),
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

        # extract CommunicationChannels
        if (
            $ArticleFilterSessionString
            && $ArticleFilterSessionString =~ m{ CommunicationChannelFilter < ( [^<>]+ ) > }xms
            )
        {
            my @IDs = split /,/, $1;
            $Self->{ArticleFilter}->{CommunicationChannelID} = \@IDs;
        }

        # extract CustomerVisibility
        if (
            $ArticleFilterSessionString
            && $ArticleFilterSessionString =~ m{ CustomerVisibilityFilter < ( [^<>]+ ) > }xms
            )
        {
            $Self->{ArticleFilter}->{CustomerVisibility} = $1;
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

        # Set article filter with value if it exists.
        if (
            $EventTypeFilterSessionString
            && $EventTypeFilterSessionString =~ m{ EventTypeFilter < ( [^<>]+ ) > }xms
            )
        {
            my @IDs = split /,/, $1;
            $Self->{EventTypeFilter}->{EventTypeID} = \@IDs;
        }
    }

    # return if HTML email
    if ( $Self->{Subaction} eq 'ShowHTMLeMail' ) {

        # check needed ArticleID
        if ( !$Self->{ArticleID} ) {
            return $LayoutObject->ErrorScreen( Message => Translatable('Need ArticleID!') );
        }

        # get article data
        my %Article = $ArticleObject->ArticleGet(
            TicketID      => $Self->{TicketID},
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 0,
        );

        # check if article data exists
        if ( !%Article ) {
            return $LayoutObject->ErrorScreen( Message => Translatable('Invalid ArticleID!') );
        }

        # if it is a HTML email, return here
        return $LayoutObject->Attachment(
            Filename => $ConfigObject->Get('Ticket::Hook')
                . "-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
            Type        => 'inline',
            ContentType => "$Article{MimeType}; charset=$Article{Charset}",
            Content     => $Article{Body},
        );
    }

    # generate output
    my $Output = $LayoutObject->Header(
        Value    => $Ticket{TicketNumber},
        TicketID => $Ticket{TicketID},
    );
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

    # get needed objects
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Create a list of article sender types for lookup
    my %ArticleSenderTypeList = $ArticleObject->ArticleSenderTypeList();

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

    my $IsVisibleForCustomer;
    if ( defined $Self->{ArticleFilter}->{CustomerVisibility} ) {
        $IsVisibleForCustomer = $Self->{ArticleFilter}->{CustomerVisibility};
    }

    # Get all articles.
    my @ArticleBoxAll = $ArticleObject->ArticleList(
        TicketID             => $Self->{TicketID},
        IsVisibleForCustomer => $IsVisibleForCustomer,
    );

    if ( IsArrayRefWithData( $Self->{ArticleFilter}->{CommunicationChannelID} ) ) {
        my %Filter = map { $_ => 1 } @{ $Self->{ArticleFilter}->{CommunicationChannelID} };

        @ArticleBoxAll = grep { $Filter{ $_->{CommunicationChannelID} } } @ArticleBoxAll;
    }

    if ( IsArrayRefWithData( $Self->{ArticleFilter}->{ArticleSenderTypeID} ) ) {
        my %Filter = map { $_ => 1 } @{ $Self->{ArticleFilter}->{ArticleSenderTypeID} };

        @ArticleBoxAll = grep { $Filter{ $_->{SenderTypeID} } } @ArticleBoxAll;
    }

    if ( $Order eq 'DESC' ) {
        @ArticleBoxAll = reverse @ArticleBoxAll;
    }

    my %ArticleFlags = $ArticleObject->ArticleFlagsOfTicketGet(
        TicketID => $Ticket{TicketID},
        UserID   => $Self->{UserID},
    );
    my $ArticleID;

    if ( $Self->{ArticleID} ) {

        my @ArticleIDs = map { $_->{ArticleID} } @ArticleBoxAll;

        my %ArticleIndex;
        @ArticleIndex{@ArticleIDs} = ( 0 .. $#ArticleIDs );

        my $Index = $ArticleIndex{ $Self->{ArticleID} };
        $Index //= 0;
        $Page = int( $Index / $Limit ) + 1;
    }
    elsif ($ArticlePage) {
        $Page = $ArticlePage;
    }
    else {

        # Find latest not seen article.
        ARTICLE:
        for my $Article (@ArticleBoxAll) {

            # Ignore system sender type.
            if (
                $ConfigObject->Get('Ticket::NewArticleIgnoreSystemSender')
                && $ArticleSenderTypeList{ $Article->{SenderTypeID} } eq 'system'
                )
            {
                next ARTICLE;
            }

            next ARTICLE if $ArticleFlags{ $Article->{ArticleID} }->{Seen};
            $ArticleID = $Article->{ArticleID};

            my @ArticleIDs = map { $_->{ArticleID} } @ArticleBoxAll;

            my %ArticleIndex;
            @ArticleIndex{@ArticleIDs} = ( 0 .. $#ArticleIDs );

            my $Index = $ArticleIndex{$ArticleID};
            $Page = int( $Index / $Limit ) + 1;

            last ARTICLE;
        }

        if ( !$ArticleID ) {
            $Page = 1;
        }
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

    my @ArticleBox = $Self->_ArticleBoxGet(
        Page          => $Page,
        ArticleBoxAll => \@ArticleBoxAll,
        Limit         => $Limit,
    );

    if ( !@ArticleBox && $Page > 1 ) {

        # If the page argument is past the actual number of pages.
        # This can happen when a new article filter was added.
        # Try to get results for the 1st page.

        @ArticleBox = $Self->_ArticleBoxGet(
            Page          => 1,
            ArticleBoxAll => \@ArticleBoxAll,
            Limit         => $Limit,
        );
    }

    if ( @ArticleBox > $Limit ) {
        pop @ArticleBox;
        $NeedPagination = 1;
    }
    elsif ( $Page == 1 && scalar @ArticleBoxAll <= $Limit ) {
        $NeedPagination = 0;
    }
    else {
        $NeedPagination = 1;
    }

    $Page ||= 1;

    my $Pages;
    if ($NeedPagination) {
        $Pages = ceil( scalar @ArticleBoxAll / $Limit );
    }

    my $ArticleIDFound = 0;
    ARTICLE:
    for my $Article (@ArticleBox) {
        next ARTICLE if !$Self->{ArticleID};
        next ARTICLE if !$Article->{ArticleID};
        next ARTICLE if $Self->{ArticleID} ne $Article->{ArticleID};

        $ArticleIDFound = 1;
    }

    # get selected or last customer article
    if ($ArticleIDFound) {
        $ArticleID = $Self->{ArticleID};
    }
    else {
        if ( !$ArticleID ) {
            if (@ArticleBox) {

                # set first listed article as fallback
                $ArticleID = $ArticleBox[0]->{ArticleID};

                # set last customer article as selected article replacing last set
                ARTICLETMP:
                for my $ArticleTmp (@ArticleBox) {
                    if ( $ArticleSenderTypeList{ $ArticleTmp->{SenderTypeID} } eq 'customer' ) {
                        $ArticleID = $ArticleTmp->{ArticleID};
                        last ARTICLETMP if $Self->{ZoomExpandSort} eq 'reverse';
                    }
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

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # age design
    $Ticket{Age} = $LayoutObject->CustomerAge(
        Age   => $Ticket{Age},
        Space => ' '
    );

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my %Widgets;
    my %AsyncWidgetActions;
    WIDGET:
    for my $Key ( sort keys %{ $Self->{DisplaySettings}->{Widgets} // {} } ) {
        my $Config = $Self->{DisplaySettings}->{Widgets}->{$Key};

        if ( $Config->{Async} ) {
            if ( !$Config->{Location} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "The configuration for $Config->{Module} must contain a Location, because it is marked as Async.",
                );
                next WIDGET;
            }
            my $ElementID = 'Async_' . $LayoutObject->LinkEncode($Key);
            push @{ $Widgets{ $Config->{Location} } }, {
                Async => 1,
                Rank  => $Config->{Rank} || $Key,
                %Ticket,
                ElementID => $ElementID,
            };
            $AsyncWidgetActions{$ElementID} = "Action=$Self->{Action};Subaction=LoadWidget;"
                . "TicketID=$Self->{TicketID};ElementID=$ElementID";
            next WIDGET;
        }
        my $Success = eval { $MainObject->Require( $Config->{Module} ) };
        next WIDGET if !$Success;
        my $Module = eval { $Config->{Module}->new(%$Self) };
        if ( !$Module ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "new() of Widget module $Config->{Module} not successful!",

            );
            next WIDGET;
        }
        my $WidgetOutput = $Module->Run(
            Ticket    => \%Ticket,
            AclAction => \%AclAction,
            Config    => $Config,
        );
        if ( !$WidgetOutput ) {
            next WIDGET;
        }
        $WidgetOutput->{Rank} //= $Key;
        my $Location = $WidgetOutput->{Location} || $Config->{Location};
        push @{ $Widgets{$Location} }, $WidgetOutput;
    }
    for my $Location ( sort keys %Widgets ) {
        $Param{ $Location . 'Widgets' } = [
            sort { $a->{Rank} cmp $b->{Rank} } @{ $Widgets{$Location} }
        ];
    }
    $LayoutObject->AddJSData(
        Key   => 'AsyncWidgetActions',
        Value => \%AsyncWidgetActions,
    );

    # set display options
    $Param{Hook} = $ConfigObject->Get('Ticket::Hook') || 'Ticket#';

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

    # show articles items
    if ( !$Self->{ZoomTimeline} ) {

        my @ArticleIDs;
        $Param{ArticleItems} = '';

        my $ArticleWidgetsHTML = '';

        ARTICLE:
        for my $ArticleTmp (@ArticleBoxShown) {
            my %Article = %$ArticleTmp;

            $ArticleWidgetsHTML .= $Self->_ArticleItem(
                Ticket            => \%Ticket,
                Article           => \%Article,
                AclAction         => \%AclAction,
                StandardResponses => $StandardTemplates{Answer},
                StandardForwards  => $StandardTemplates{Forward},
                ActualArticleID   => $ArticleID,
                Type              => 'Static',
            );
            push @ArticleIDs, $ArticleTmp->{ArticleID};
        }

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'ArticleIDs',
            Value => \@ArticleIDs,
        );
        $LayoutObject->AddJSData(
            Key   => 'MenuItems',
            Value => $Self->{MenuItems},
        );

        $Param{ArticleItems} .= $LayoutObject->Output(
            TemplateFile => 'AgentTicketZoom',
            Data         => {
                %Ticket,
                %AclAction,
                ArticleWidgetsHTML => $ArticleWidgetsHTML,
            },
        );
    }

    # always show archived tickets as seen
    if ( $Self->{ZoomExpand} && $Ticket{ArchiveFlag} ne 'y' ) {

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'TicketItemMarkAsSeen',
            Value => 1,
        );
    }

    # number of articles
    $Param{ArticleCount} = scalar @ArticleBox;

    $LayoutObject->Block(
        Name => 'Header',
        Data => { %Param, %Ticket, %AclAction },
    );

    my %ActionLookup;
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

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

            if ( $Menus{$Menu}->{Action} ) {
                $ActionLookup{ $Menus{$Menu}->{Action} } = {
                    Link           => $Item->{Link},
                    Class          => $Item->{Class},
                    LinkParam      => $Item->{LinkParam},
                    Description    => $Item->{Description},
                    Name           => $Item->{Name},
                    TranslatedName => $Kernel::OM->Get('Kernel::Language')->Translate( $Item->{Name} ),
                };
            }

            if ( !$Menus{$Menu}->{ClusterName} ) {

                $ZoomMenuItems{$Menu} = $Item;
            }
            else {

                # check the configured priority for this item. The lowest ClusterPriority
                # within the same cluster wins.
                my $Priority = $MenuClusters{ $Menus{$Menu}->{ClusterName} }->{Priority} || 0;
                $Menus{$Menu}->{ClusterPriority} ||= 0;
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
            };
        }

        # display all items
        for my $Item ( sort keys %ZoomMenuItems ) {
            if ( $ZoomMenuItems{$Item}->{ExternalLink} && $ZoomMenuItems{$Item}->{ExternalLink} == 1 ) {
                $LayoutObject->Block(
                    Name => 'TicketMenuExternalLink',
                    Data => $ZoomMenuItems{$Item},
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'TicketMenu',
                    Data => $ZoomMenuItems{$Item},
                );
            }

            if ( $ZoomMenuItems{$Item}->{Type} eq 'Cluster' ) {

                $LayoutObject->Block(
                    Name => 'TicketMenuSubContainer',
                    Data => {
                        Name => $ZoomMenuItems{$Item}->{Name},
                    },
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
        $MoveQueues{0}         = '- ' . $LayoutObject->{LanguageObject}->Translate('Move') . ' -';
        $Param{MoveQueuesStrg} = $LayoutObject->AgentQueueListOption(
            Name           => 'DestQueueID',
            Data           => \%MoveQueues,
            Class          => 'Modernize Small',
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

            $ActionLookup{AgentTicketMove} = {
                Link           => 'Action=AgentTicketMove;TicketID=[% Data.TicketID | uri %]',
                Class          => 'AsPopup PopupType_TicketAction',
                LinkParam      => '',
                Description    => Translatable('Change Queue'),
                Name           => Translatable('Queue'),
                TranslatedName => $Kernel::OM->Get('Kernel::Language')->Translate('Queue'),
            };
        }
    }

    # Check if AgentTicketCompose and AgentTicketForward are allowed as action (for display of FormDrafts).
    my %ActionConfig = (
        AgentTicketCompose => {
            Link           => 'Action=AgentTicketCompose;TicketID=[% Data.TicketID | uri %]',
            Class          => 'AsPopup PopupType_TicketAction',
            LinkParam      => '',
            Description    => Translatable('Reply'),
            Name           => Translatable('Reply'),
            TranslatedName => $Kernel::OM->Get('Kernel::Language')->Translate('Reply'),
        },
        AgentTicketForward => {
            Link           => 'Action=AgentTicketForward;TicketID=[% Data.TicketID | uri %]',
            Class          => 'AsPopup PopupType_TicketAction',
            LinkParam      => '',
            Description    => Translatable('Forward article via mail'),
            Name           => Translatable('Forward'),
            TranslatedName => $Kernel::OM->Get('Kernel::Language')->Translate('Forward'),
        },
    );
    ACTION:
    for my $Action (qw(AgentTicketCompose AgentTicketForward)) {
        next ACTION if !$ConfigObject->Get('Frontend::Module')->{$Action};
        next ACTION if !$AclActionLookup{$Action};

        my $Config = $ConfigObject->Get( 'Ticket::Frontend::' . $Action );
        if ( $Config->{Permission} ) {
            next ACTION if !$TicketObject->TicketPermission(
                Type     => $Config->{Permission},
                TicketID => $Ticket{TicketID},
                UserID   => $Self->{UserID},
                LogNo    => 1,
            );
        }
        $ActionLookup{$Action} = $ActionConfig{$Action};
    }

    # Get and show available FormDrafts.
    my %ShownFormDraftEntries;
    my $FormDraftList = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftListGet(
        ObjectType => 'Ticket',
        ObjectID   => $Self->{TicketID},
        UserID     => $Self->{UserID},
    );
    if ( IsArrayRefWithData($FormDraftList) ) {
        FormDraft:
        for my $FormDraft ( @{$FormDraftList} ) {
            next FormDraft if !$ActionLookup{ $FormDraft->{Action} };
            push @{ $ShownFormDraftEntries{ $FormDraft->{Action} } }, $FormDraft;
        }
    }
    if (%ShownFormDraftEntries) {

        my $LastArticle;
        if ( $Order eq 'DESC' ) {
            $LastArticle = $ArticleBoxAll[0];
        }
        else {
            $LastArticle = $ArticleBoxAll[-1];
        }

        my $LastArticleSystemTime;
        if ( $LastArticle->{CreateTime} ) {
            my $LastArticleSystemTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $LastArticle->{CreateTime},
                },
            );
            $LastArticleSystemTime = $LastArticleSystemTimeObject->ToEpoch();
        }

        my @FormDrafts;

        for my $Action (
            sort {
                $ActionLookup{$a}->{TranslatedName}
                    cmp
                    $ActionLookup{$b}->{TranslatedName}
            } keys %ShownFormDraftEntries
            )
        {
            my $ActionData = $ActionLookup{$Action};

            SHOWNFormDraftACTIONENTRY:
            for my $ShownFormDraftActionEntry (
                sort {
                    $a->{Title}
                        cmp
                        $b->{Title}
                        ||
                        $a->{FormDraftID}
                        <=>
                        $b->{FormDraftID}
                } @{ $ShownFormDraftEntries{$Action} }
                )
            {
                $ShownFormDraftActionEntry->{CreatedByUser} = $UserObject->UserName(
                    UserID => $ShownFormDraftActionEntry->{CreateBy},
                );
                $ShownFormDraftActionEntry->{ChangedByUser} = $UserObject->UserName(
                    UserID => $ShownFormDraftActionEntry->{ChangeBy},
                );

                $ShownFormDraftActionEntry = {
                    %{$ShownFormDraftActionEntry},
                    %{$ActionData},

                };

                push @FormDrafts, $ShownFormDraftActionEntry;
            }
        }

        $LayoutObject->Block(
            Name => 'FormDraftTable',
            Data => {
                FormDrafts => \@FormDrafts,
                TicketID   => $Self->{TicketID},
            },
        );
    }

    # show created by if different then User ID 1
    if ( $Ticket{CreateBy} > 1 ) {

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        $Ticket{CreatedByUser} = $UserObject->UserName( UserID => $Ticket{CreateBy} );
        $LayoutObject->Block(
            Name => 'CreatedBy',
            Data => {%Ticket},
        );
    }

    # show no articles block if ticket does not contain articles
    if ( !@ArticleBox && !$Self->{ZoomTimeline} ) {
        $LayoutObject->Block(
            Name => 'HintNoArticles',
        );
    }

    # check if ticket is normal or process ticket
    my $IsProcessTicket = $TicketObject->TicketCheckForProcessType(
        'TicketID' => $Self->{TicketID}
    );

    # show process widget  and activity dialogs on process tickets
    if ($IsProcessTicket) {

        $Param{WidgetTitle} = $Self->{DisplaySettings}->{ProcessDisplay}->{WidgetTitle};

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

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'ProcessWidget',
            Value => 1,
        );

        # output the process widget in the main screen
        $LayoutObject->Block(
            Name => 'ProcessWidget',
            Data => {
                WidgetTitle => $Param{WidgetTitle},
            },
        );

        # get next activity dialogs
        my $NextActivityDialogs;
        if ( $Ticket{$ActivityEntityIDField} ) {
            $NextActivityDialogs = ${ActivityData}->{ActivityDialog} || {};
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
                %{$NextActivityDialogs} = $TicketObject->TicketAclData();
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
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # to store dynamic fields to be displayed in the process widget and in the sidebar
    my (@FieldsWidget);

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
            my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                LayoutObject       => $LayoutObject,

                # no ValueMaxChars here, enough space available
            );

            push @FieldsWidget, {
                $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                Name                        => $DynamicFieldConfig->{Name},
                Title                       => $ValueStrg->{Title},
                Value                       => $ValueStrg->{Value},
                ValueKey                    => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                Label                       => $Label,
                Link                        => $ValueStrg->{Link},
                LinkPreview                 => $ValueStrg->{LinkPreview},

                # Include unique parameter with dynamic field name in case of collision with others.
                #   Please see bug#13362 for more information.
                "DynamicField_$DynamicFieldConfig->{Name}" => $ValueStrg->{Title},
            };
        }
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
                                    $Field->{Name} => $Field->{Title},
                                    %Ticket,

                                    # alias for ticket title, Title will be overwritten
                                    TicketTitle => $Ticket{Title},
                                    Value       => $Field->{Value},
                                    Title       => $Field->{Title},
                                    Link        => $Field->{Link},
                                    LinkPreview => $Field->{LinkPreview},

                                    # Include unique parameter with dynamic field name in case of collision with others.
                                    #   Please see bug#13362 for more information.
                                    "DynamicField_$Field->{Name}" => $Field->{Title},
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
                        $Field->{Name} => $Field->{Title},
                        %Ticket,

                        # alias for ticket title, Title will be overwritten
                        TicketTitle => $Ticket{Title},
                        Value       => $Field->{Value},
                        Title       => $Field->{Title},
                        Link        => $Field->{Link},

                        # Include unique parameter with dynamic field name in case of collision with others.
                        #   Please see bug#13362 for more information.
                        "DynamicField_$Field->{Name}" => $Field->{Title},
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
                Class       => 'Modernize',
            );

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'ArticleFilterDialog',
                Value => 0,
            );

            $LayoutObject->Block(
                Name => 'EventTypeFilterDialog',
                Data => {%Param},
            );
        }
        else {

            my @CommunicationChannels = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelList(
                ValidID => 1,
            );

            my %Channels = map { $_->{ChannelID} => $_->{DisplayName} } @CommunicationChannels;

            # build article type list for filter dialog
            $Param{Channels} = $LayoutObject->BuildSelection(
                Data        => \%Channels,
                SelectedID  => $Self->{ArticleFilter}->{CommunicationChannelID},
                Translation => 1,
                Multiple    => 1,
                Sort        => 'AlphanumericValue',
                Name        => 'CommunicationChannelFilter',
                Class       => 'Modernize',
            );

            $Param{CustomerVisibility} = $LayoutObject->BuildSelection(
                Data => {
                    0 => Translatable('Invisible only'),
                    1 => Translatable('Visible only'),
                    2 => Translatable('Visible and invisible'),
                },
                SelectedID  => $Self->{ArticleFilter}->{CustomerVisibility} // 2,
                Translation => 1,
                Sort        => 'NumericKey',
                Name        => 'CustomerVisibilityFilter',
                Class       => 'Modernize',
            );

            # get sender types
            my %ArticleSenderTypes = $ArticleObject->ArticleSenderTypeList();

            # build article sender type list for filter dialog
            $Param{ArticleSenderTypeFilterString} = $LayoutObject->BuildSelection(
                Data        => \%ArticleSenderTypes,
                SelectedID  => $Self->{ArticleFilter}->{ArticleSenderTypeID},
                Translation => 1,
                Multiple    => 1,
                Sort        => 'AlphanumericValue',
                Name        => 'ArticleSenderTypeFilter',
                Class       => 'Modernize',
            );

            # Ticket ID
            $Param{TicketID} = $Self->{TicketID};

            # send data to JS
            $LayoutObject->AddJSData(
                Key   => 'ArticleFilterDialog',
                Value => 1,
            );

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
            && $ArticleSenderTypeList{ $Article->{SenderTypeID} } eq 'system';

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

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'ArticleTableHeight',
        Value => $LayoutObject->{UserTicketZoomArticleTableHeight},
    );
    $LayoutObject->AddJSData(
        Key   => 'Ticket::Frontend::HTMLArticleHeightDefault',
        Value => $ConfigObject->Get('Ticket::Frontend::HTMLArticleHeightDefault'),
    );
    $LayoutObject->AddJSData(
        Key   => 'Ticket::Frontend::HTMLArticleHeightMax',
        Value => $ConfigObject->Get('Ticket::Frontend::HTMLArticleHeightMax'),
    );
    $LayoutObject->AddJSData(
        Key   => 'Language',
        Value => {
            AttachmentViewMessage => Translatable(
                'Article could not be opened! Perhaps it is on another article page?'
            ),
        },
    );

    # init js
    $LayoutObject->Block(
        Name => 'TicketZoomInit',
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

    my @ArticleViews = (
        {
            Key   => 'Collapse',
            Value => Translatable('Show one article'),
        },
        {
            Key   => 'Expand',
            Value => Translatable('Show all articles'),
        },
    );

    # Add timeline view option only if enabled.
    if ( $Kernel::OM->Get('Kernel::Config')->Get('TimelineViewEnabled') ) {
        push @ArticleViews, {
            Key   => 'Timeline',
            Value => Translatable('Show Ticket Timeline View'),
        };
    }

    my $ArticleViewSelected = 'Collapse';
    if ( $Self->{ZoomExpand} ) {
        $ArticleViewSelected = 'Expand';
    }
    elsif ( $Self->{ZoomTimeline} ) {
        $ArticleViewSelected = 'Timeline';
    }

    # Add disabled teaser option for OTRSBusiness timeline view
    my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
    if ( !$OTRSBusinessIsInstalled ) {
        push @ArticleViews, {
            Key   => 'Timeline',
            Value => $LayoutObject->{LanguageObject}
                ->Translate( 'Show Ticket Timeline View (%s)', 'OTRS Business Solution™' ),
            Disabled => 1,
        };
    }

    my $ArticleViewStrg = $LayoutObject->BuildSelection(
        Data        => \@ArticleViews,
        SelectedID  => $ArticleViewSelected,
        Translation => 1,
        Sort        => 'AlphanumericValue',
        Name        => 'ArticleView',
        Class       => 'Modernize',
    );

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'ArticleViewStrg',
        Value => $ArticleViewStrg,
    );
    $LayoutObject->AddJSData(
        Key   => 'ZoomExpand',
        Value => $Self->{ZoomExpand},
    );

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
            ( !$Self->{ZoomTimeline} && IsHashRefWithData( $Self->{ArticleFilter} ) )
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
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

    # Create a list of article sender types for lookup
    my %ArticleSenderTypeList = $ArticleObject->ArticleSenderTypeList();

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
                    && $ArticleSenderTypeList{ $Article{SenderTypeID} } ne 'system'
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
                    $Self->{UserID} == $Ticket{OwnerID}
                    || $Self->{UserID} == $Ticket{ResponsibleID}
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

                TicketNumber => $Ticket{TicketNumber},
                Subject      => $Article{Subject} || '',
            );

            my %ArticleFields = $LayoutObject->ArticleFields(%Article);

            # Get transmission status information for email articles.
            my $TransmissionStatus;
            if ( $Article{ChannelName} && $Article{ChannelName} eq 'Email' ) {
                $TransmissionStatus = $ArticleObject->BackendForArticle(%Article)->ArticleTransmissionStatus(
                    ArticleID => $Article{ArticleID},
                );
            }

            # check if we need to show also expand/collapse icon
            $LayoutObject->Block(
                Name => 'TreeItem',
                Data => {
                    %Article,
                    ArticleFields      => \%ArticleFields,
                    Class              => $Class,
                    ClassRow           => $ClassRow,
                    Subject            => $TmpSubject,
                    TransmissionStatus => $TransmissionStatus,
                    ZoomExpand         => $Self->{ZoomExpand},
                    ZoomExpandSort     => $Self->{ZoomExpandSort},
                },
            );

            # get article flags
            # Always use user id 1 because other users also have to see the important flag
            my %ArticleImportantFlags = $ArticleObject->ArticleFlagGet(
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

            # Determine communication direction.
            if ( $Article{ChannelName} eq 'Internal' ) {
                $LayoutObject->Block( Name => 'TreeItemDirectionInternal' );
            }
            elsif ( $ArticleSenderTypeList{ $Article{SenderTypeID} } eq 'customer' ) {
                $LayoutObject->Block( Name => 'TreeItemDirectionIncoming' );
            }
            else {
                $LayoutObject->Block( Name => 'TreeItemDirectionOutgoing' );
            }

            # Get attachment index (excluding body attachments).
            my %AtmIndex = $ArticleObject->BackendForArticle(%Article)->ArticleAttachmentIndex(
                ArticleID => $Article{ArticleID},
                %{ $Self->{ExcludeAttachments} },
            );
            $Article{Atms} = \%AtmIndex;

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
                        TicketID    => $Article{TicketID},
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
        my @TimelineArticleBox = $ArticleObject->ArticleList(
            TicketID => $Self->{TicketID},
        );

        for my $ArticleItem (@TimelineArticleBox) {
            my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$ArticleItem} );

            my %Article = $ArticleBackendObject->ArticleGet(
                TicketID      => $Self->{TicketID},
                ArticleID     => $ArticleItem->{ArticleID},
                DynamicFields => 1,
                RealNames     => 1,
            );

            # Append article meta data.
            $ArticleItem = {
                %{$ArticleItem},
                %Article,
            };
        }

        my $ArticlesByArticleID = {};
        for my $Article ( sort @TimelineArticleBox ) {
            my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$Article} );

            # Get attachment index (excluding body attachments).
            my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $Article->{ArticleID},
                %{ $Self->{ExcludeAttachments} },
            );
            $Article->{Atms}                                = \%AtmIndex;
            $Article->{Backend}                             = $ArticleBackendObject->ChannelNameGet();
            $ArticlesByArticleID->{ $Article->{ArticleID} } = $Article;

            # Check if there is HTML body attachment.
            my %AttachmentIndexHTMLBody = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID    => $Article->{ArticleID},
                OnlyHTMLBody => 1,
            );
            ( $Article->{HTMLBodyAttachmentID} ) = sort keys %AttachmentIndexHTMLBody;
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
            EmailAgentInternal
        );

        # outgoing types
        my @TypesOutgoing = qw(
            AddSMS
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
            AddSMSCustomer
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

            # special treatment for certain types, e.g. external notes from customers
            if (
                $Item->{ArticleID}
                && $Item->{HistoryType} eq 'AddNote'
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticleSenderTypeList{ $ArticlesByArticleID->{ $Item->{ArticleID} }->{SenderTypeID} } eq 'customer'
                )
            {
                $Item->{Class} = 'TypeIncoming';

                # We fake a custom history type because external notes from customers still
                # have the history type 'AddNote' which does not allow for distinguishing.
                $Item->{HistoryType} = 'AddNoteCustomer';
            }

            # special treatment for certain types, e.g. external SMS from customers
            elsif (
                $Item->{ArticleID}
                && $Item->{HistoryType} eq 'AddSMS'
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticleSenderTypeList{ $ArticlesByArticleID->{ $Item->{ArticleID} }->{SenderTypeID} } eq 'customer'
                )
            {
                $Item->{Class} = 'TypeIncoming';

                # We fake a custom history type because external notes from customers still
                # have the history type 'AddSMS' which does not allow for distinguishing.
                $Item->{HistoryType} = 'AddSMSCustomer';
            }

            # special treatment for internal emails
            elsif (
                $Item->{ArticleID}
                && $Item->{HistoryType} eq 'EmailAgent'
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{Backend} eq 'Email'
                && $ArticleSenderTypeList{ $ArticlesByArticleID->{ $Item->{ArticleID} }->{SenderTypeID} } eq 'agent'
                && !$ArticlesByArticleID->{ $Item->{ArticleID} }->{IsVisibleForCustomer}
                )
            {
                $Item->{Class}       = 'TypeNoteInternal';
                $Item->{HistoryType} = 'EmailAgentInternal';
            }

            # special treatment for certain types, e.g. external notes from customers
            elsif (
                $Item->{ArticleID}
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{Backend} eq 'Chat'
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{IsVisibleForCustomer}
                )
            {
                $Item->{HistoryType} = 'ChatExternal';
                $Item->{Class}       = 'TypeIncoming';
            }
            elsif (
                $Item->{ArticleID}
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{Backend} eq 'Chat'
                && !$ArticlesByArticleID->{ $Item->{ArticleID} }->{IsVisibleForCustomer}
                )
            {
                $Item->{HistoryType} = 'ChatInternal';
                $Item->{Class}       = 'TypeInternal';
            }
            elsif (
                $Item->{HistoryType} eq 'Forward'
                && $Item->{ArticleID}
                && IsHashRefWithData( $ArticlesByArticleID->{ $Item->{ArticleID} } )
                && $ArticlesByArticleID->{ $Item->{ArticleID} }->{Backend} eq 'Email'
                && $ArticleSenderTypeList{ $ArticlesByArticleID->{ $Item->{ArticleID} }->{SenderTypeID} } eq 'agent'
                && !$ArticlesByArticleID->{ $Item->{ArticleID} }->{IsVisibleForCustomer}
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

            if ( grep { $_ eq $Item->{HistoryType} } @TypesDodge ) {
                next HISTORYITEM;
            }

            $Item->{Counter} = $ItemCounter++;

            if ( $Item->{HistoryType} eq 'NewTicket' ) {

                # if the 'NewTicket' item has an article, display this "creation article" event separately
                if ( $Item->{ArticleID} ) {
                    push @{ $Param{Items} }, {
                        %{$Item},
                        Counter             => $Item->{Counter}++,
                        Class               => 'NewTicket',
                        Name                => '',
                        ArticleID           => '',
                        HistoryTypeReadable => Translatable('Ticket Created'),
                        Orientation         => 'Right',
                    };
                }
                else {
                    $Item->{Class} = 'NewTicket';
                    delete $Item->{ArticleID};
                    delete $Item->{Name};
                }
            }

            # remove article information from types which should not display articles
            if ( !grep { $_ eq $Item->{HistoryType} } @TypesWithArticles ) {
                delete $Item->{ArticleID};
            }

            # get article (if present)
            if ( $Item->{ArticleID} ) {
                $Item->{ArticleData} = $ArticlesByArticleID->{ $Item->{ArticleID} };

                my %ArticleFields = $LayoutObject->ArticleFields(
                    TicketID  => $Item->{ArticleData}->{TicketID},
                    ArticleID => $Item->{ArticleData}->{ArticleID},
                );
                $Item->{ArticleData}->{ArticleFields} = \%ArticleFields;

                # Get dynamic fields and accounted time
                my $Backend = $ArticlesByArticleID->{ $Item->{ArticleID} }->{Backend};

                # Get dynamic fields and accounted time
                my %ArticleMetaFields
                    = $Kernel::OM->Get("Kernel::Output::HTML::TicketZoom::Agent::$Backend")->ArticleMetaFields(
                    TicketID  => $Item->{ArticleData}->{TicketID},
                    ArticleID => $Item->{ArticleData}->{ArticleID},
                    UserID    => $Self->{UserID},
                    );
                $Item->{ArticleData}->{ArticleMetaFields} = \%ArticleMetaFields;

                my @ArticleActions = $LayoutObject->ArticleActions(
                    TicketID  => $Item->{ArticleData}->{TicketID},
                    ArticleID => $Item->{ArticleData}->{ArticleID},
                    Type      => 'OnLoad',
                );

                $Item->{ArticleData}->{ArticlePlain} = $LayoutObject->ArticlePreview(
                    TicketID   => $Item->{ArticleData}->{TicketID},
                    ArticleID  => $Item->{ArticleData}->{ArticleID},
                    ResultType => 'plain',
                );

                $Item->{ArticleData}->{ArticleHTML}
                    = $Kernel::OM->Get("Kernel::Output::HTML::TimelineView::$Backend")->ArticleRender(
                    TicketID       => $Item->{ArticleData}->{TicketID},
                    ArticleID      => $Item->{ArticleData}->{ArticleID},
                    ArticleActions => \@ArticleActions,
                    UserID         => $Self->{UserID},
                    );

                # remove empty lines
                $Item->{ArticleData}->{ArticlePlain} =~ s{^[\n\r]+}{}xmsg;

                # Modify plain text and body to avoid '</script>' tag issue (see bug#14023).
                $Item->{ArticleData}->{ArticlePlain} =~ s{</script>}{<###/script>}xmsg;
                $Item->{ArticleData}->{Body}         =~ s{</script>}{<###/script>}xmsg;

                my %ArticleFlagsAll = $ArticleObject->ArticleFlagGet(
                    ArticleID => $Item->{ArticleID},
                    UserID    => 1,
                );

                my %ArticleFlagsMe = $ArticleObject->ArticleFlagGet(
                    ArticleID => $Item->{ArticleID},
                    UserID    => $Self->{UserID},
                );

                $Item->{ArticleData}->{ArticleIsImportant} = $ArticleFlagsAll{Important};
                $Item->{ArticleData}->{ArticleIsSeen}      = $ArticleFlagsMe{Seen};
            }
            else {

                if ( $Item->{Name} && $Item->{Name} =~ m/^%%/x ) {

                    $Item->{Name} =~ s/^%%//xg;
                    my @Values = split( /%%/x, $Item->{Name} );

                    # See documentation in AgentTicketHistory.pm, line 141+
                    if ( $Item->{HistoryType} eq 'TicketDynamicFieldUpdate' ) {
                        @Values = ( $Values[1], $Values[5] // '', $Values[3] // '' );
                    }
                    elsif ( $Item->{HistoryType} eq 'TypeUpdate' ) {
                        @Values = ( $Values[2], $Values[3], $Values[0], $Values[1] );
                    }

                    $Item->{Name} = $LayoutObject->{LanguageObject}->Translate(
                        $HistoryTypes{ $Item->{HistoryType} },
                        @Values,
                    );

                    # remove not needed place holder
                    $Item->{Name} =~ s/\%s//xg;
                }
            }

            # make the history type more readable (if applicable)
            $Item->{HistoryTypeReadable} = $Self->{HistoryTypeMapping}->{ $Item->{HistoryType} }
                || $Item->{HistoryType};

            # group items which happened (nearly) coincidently together
            my $CreateSystemTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Item->{CreateTime},
                },
            );
            $Item->{CreateSystemTime} = $CreateSystemTimeObject
                ? $CreateSystemTimeObject->ToEpoch()
                : undef;

            # if we have two events that happened 'nearly' the same time, treat
            # them as if they happened exactly on the same time (threshold 5 seconds)
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

        # set key 'TimeLong' for JS
        for my $Item ( @{ $Param{Items} } ) {
            $Item->{TimeLong}
                = $LayoutObject->{LanguageObject}->FormatTimeString( $Item->{CreateTime}, 'DateFormatLong' );
        }

        for my $ArticleID ( sort keys %{$ArticlesByArticleID} ) {

            # Check if article has attachment(s).
            if ( IsHashRefWithData( $ArticlesByArticleID->{$ArticleID}->{Atms} ) ) {

                my ($Index)
                    = grep { $Param{Items}->[$_]->{ArticleID} && $Param{Items}->[$_]->{ArticleID} == $ArticleID }
                    0 .. @{ $Param{Items} };
                $Param{Items}->[$Index]->{HasAttachment} = 1;
            }
        }

        # Get NoTimelineViewAutoArticle config value for usage in JS.
        $LayoutObject->AddJSData(
            Key   => 'NoTimelineViewAutoArticle',
            Value => $ConfigObject->Get('NoTimelineViewAutoArticle') || '0',
        );

        # Include current article ID only if it's selected.
        $Param{CurrentArticleID} //= $Self->{ArticleID};

        # Modify body text to avoid '</script>' tag issue (see bug#14023).
        for my $ArticleBoxItem (@ArticleBox) {
            $ArticleBoxItem->{Body} =~ s{</script>}{<###/script>}xmsg;
        }

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'TimelineView',
            Value => {
                Enabled => $ConfigObject->Get('TimelineViewEnabled'),
                Data    => \%Param,
            },
        );

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

            # show attachments box
            if ( IsHashRefWithData( $ArticlesByArticleID->{$ArticleID}->{Atms} ) ) {

                my $ArticleAttachments = $Self->_CollectArticleAttachments(
                    Article => $ArticlesByArticleID->{$ArticleID},
                );

                $LayoutObject->Block(
                    Name => 'TimelineViewArticleAttachments',
                    Data => {
                        TicketID    => $Self->{TicketID},
                        ArticleID   => $ArticleID,
                        Attachments => $ArticleAttachments,
                    },
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

    my @Articles = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
        TicketID => $Param{TicketID},
    );

    for my $Article (@Articles) {
        $Self->_ArticleItemSeen(
            TicketID  => $Param{TicketID},
            ArticleID => $Article->{ArticleID},
        );
    }

    return 1;
}

sub _ArticleItemSeen {
    my ( $Self, %Param ) = @_;

    # mark shown article as seen
    $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleFlagSet(
        TicketID  => $Param{TicketID},
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

    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Get article data.
    # my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    # show article actions
    my @MenuItems = $LayoutObject->ArticleActions(
        %Param,
        TicketID  => $Param{Ticket}->{TicketID},
        ArticleID => $Param{Article}->{ArticleID},
        Type      => $Param{Type},
    );

    push @{ $Self->{MenuItems} }, \@MenuItems;

    # TODO: Review
    return $Self->_ArticleRender(
        TicketID               => $Ticket{TicketID},
        ArticleID              => $Article{ArticleID},
        UserID                 => $Self->{UserID},
        ShowBrowserLinkMessage => $Self->{DoNotShowBrowserLinkMessage} ? 0 : 1,
        Type                   => $Param{Type},
        MenuItems              => \@MenuItems,
    );
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
        };
    }

    return \%Attachments;
}

sub _ArticleBoxGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Page ArticleBoxAll Limit)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my $Start = ( $Param{Page} - 1 ) * $Param{Limit};

    my $End = $Param{Page} * $Param{Limit} - 1;
    if ( $End >= scalar @{ $Param{ArticleBoxAll} } ) {

        # Make sure that end index doesn't exceed array size.
        $End = scalar @{ $Param{ArticleBoxAll} } - 1;
    }

    my @ArticleIndexes = ( $Start .. $End );

    my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

    # Save communication channel data to improve performance.
    my %CommunicationChannelData;

    my @ArticleBox;
    for my $Index (@ArticleIndexes) {
        my $ArticleBackendObject = $ArticleObject->BackendForArticle(
            TicketID  => $Self->{TicketID},
            ArticleID => $Param{ArticleBoxAll}->[$Index]->{ArticleID},
        );

        my %Article = $ArticleBackendObject->ArticleGet(
            TicketID      => $Self->{TicketID},
            ArticleID     => $Param{ArticleBoxAll}->[$Index]->{ArticleID},
            DynamicFields => 1,
            RealNames     => 1,
        );

        # Include some information about communication channel.
        if ( !$CommunicationChannelData{ $Article{CommunicationChannelID} } ) {

            # Communication channel display name is part of the configuration.
            my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
                ChannelID => $Article{CommunicationChannelID},
            );

            # Presence of communication channel object indicates its validity.
            my $ChannelObject = $CommunicationChannelObject->ChannelObjectGet(
                ChannelID => $Article{CommunicationChannelID},
            );

            $CommunicationChannelData{ $Article{CommunicationChannelID} } = {
                ChannelName        => $CommunicationChannel{ChannelName},
                ChannelDisplayName => $CommunicationChannel{DisplayName},
                ChannelInvalid     => !$ChannelObject,
            };
        }

        %Article = ( %Article, %{ $CommunicationChannelData{ $Article{CommunicationChannelID} } } );

        push @ArticleBox, \%Article;
    }

    return @ArticleBox;
}

=head2 _ArticleRender()

Returns article html.

    my $HTML = $Self->_ArticleRender(
        TicketID               => 123,      # (required)
        ArticleID              => 123,      # (required)
        Type                   => 'Static', # (required) Static or OnLoad
        ShowBrowserLinkMessage => 1,        # (optional)
    );

Result:
    $HTML = "<div>...</div>";

=cut

sub _ArticleRender {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID Type)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Get article data.
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    # Determine channel name for this Article.
    my $ChannelName = $ArticleBackendObject->ChannelNameGet();

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        "Kernel::Output::HTML::TicketZoom::Agent::$ChannelName",
    );
    return if !$Loaded;

    return $Kernel::OM->Get("Kernel::Output::HTML::TicketZoom::Agent::$ChannelName")->ArticleRender(
        %Param,
        ArticleActions => $Param{MenuItems},
        UserID         => $Self->{UserID},
    );
}

1;
