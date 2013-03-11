# --
# Kernel/Output/HTML/LayoutTicket.pm - provides generic ticket HTML output
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutTicket;

use strict;
use warnings;

use vars qw(@ISA $VERSION);

sub AgentCustomerViewTable {
    my ( $Self, %Param ) = @_;

    # check customer params
    if ( ref $Param{Data} ne 'HASH' ) {
        $Self->FatalError( Message => 'Need Hash ref in Data param' );
    }
    elsif ( ref $Param{Data} eq 'HASH' && !%{ $Param{Data} } ) {
        return $Self->{LanguageObject}->Get('none');
    }

    # add ticket params if given
    if ( $Param{Ticket} ) {
        %{ $Param{Data} } = ( %{ $Param{Data} }, %{ $Param{Ticket} } );
    }

    my @MapNew;
    my $Map = $Param{Data}->{Config}->{Map};
    if ($Map) {
        @MapNew = ( @{$Map} );
    }

    # check if customer company support is enabled
    if ( $Param{Data}->{Config}->{CustomerCompanySupport} ) {
        my $Map2 = $Param{Data}->{CompanyConfig}->{Map};
        if ($Map2) {
            push( @MapNew, @{$Map2} );
        }
    }

    my $ShownType = 1;
    if ( $Param{Type} && $Param{Type} eq 'Lite' ) {
        $ShownType = 2;

        # check if min one lite view item is configured, if not, use
        # the normal view also
        my $Used = 0;
        for my $Field (@MapNew) {
            if ( $Field->[3] == 2 ) {
                $Used = 1;
            }
        }
        if ( !$Used ) {
            $ShownType = 1;
        }
    }

    # build html table
    $Self->Block(
        Name => 'Customer',
        Data => $Param{Data},
    );

    # check Frontend::CustomerUser::Image
    my $CustomerImage = $Self->{ConfigObject}->Get('Frontend::CustomerUser::Image');
    if ($CustomerImage) {
        my %Modules = %{$CustomerImage};
        for my $Module ( sort keys %Modules ) {
            if ( !$Self->{MainObject}->Require( $Modules{$Module}->{Module} ) ) {
                $Self->FatalDie();
            }

            my $Object = $Modules{$Module}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            # run module
            next if !$Object;

            $Object->Run(
                Config => $Modules{$Module},
                Data   => $Param{Data},
            );
        }
    }

    # build table
    for my $Field (@MapNew) {
        if ( $Field->[3] && $Field->[3] >= $ShownType && $Param{Data}->{ $Field->[0] } ) {
            my %Record = (
                %{ $Param{Data} },
                Key   => $Field->[1],
                Value => $Param{Data}->{ $Field->[0] },
            );
            if ( $Field->[6] ) {
                $Record{LinkStart} = "<a href=\"$Field->[6]\"";
                if ( $Field->[8] ) {
                    $Record{LinkStart} .= " target=\"$Field->[8]\"";
                }
                if ( $Field->[9] ) {
                    $Record{LinkStart} .= " class=\"$Field->[9]\"";
                }
                $Record{LinkStart} .= ">";
                $Record{LinkStop} = "</a>";
            }
            if ( $Field->[0] ) {
                $Record{ValueShort} = $Self->Ascii2Html(
                    Text => $Record{Value},
                    Max  => $Param{Max}
                );
            }
            $Self->Block(
                Name => 'CustomerRow',
                Data => \%Record,
            );
        }
    }

    # check Frontend::CustomerUser::Item
    my $CustomerItem      = $Self->{ConfigObject}->Get('Frontend::CustomerUser::Item');
    my $CustomerItemCount = 0;
    if ($CustomerItem) {
        $Self->Block(
            Name => 'CustomerItem',
        );
        my %Modules = %{$CustomerItem};
        for my $Module ( sort keys %Modules ) {
            if ( !$Self->{MainObject}->Require( $Modules{$Module}->{Module} ) ) {
                $Self->FatalDie();
            }

            my $Object = $Modules{$Module}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            # run module
            next if !$Object;

            my $Run = $Object->Run(
                Config => $Modules{$Module},
                Data   => $Param{Data},
            );

            next if !$Run;

            $CustomerItemCount++;
        }
    }

    # Acivity Index: History
    # CTI
    # vCard
    # Bugzilla Status
    # create & return output
    return $Self->Output( TemplateFile => 'AgentCustomerTableView', Data => \%Param );
}

# AgentQueueListOption()
#
# !! DONT USE THIS FUNCTION !! Use BuildSelection() instead.
#
# Due to compatibility reason this function is still in use and will be removed
# in a future release.

sub AgentQueueListOption {
    my ( $Self, %Param ) = @_;

    my $Size           = $Param{Size}                      ? "size='$Param{Size}'"  : '';
    my $MaxLevel       = defined( $Param{MaxLevel} )       ? $Param{MaxLevel}       : 10;
    my $SelectedID     = defined( $Param{SelectedID} )     ? $Param{SelectedID}     : '';
    my $Selected       = defined( $Param{Selected} )       ? $Param{Selected}       : '';
    my $CurrentQueueID = defined( $Param{CurrentQueueID} ) ? $Param{CurrentQueueID} : '';
    my $Class          = defined( $Param{Class} )          ? $Param{Class}          : '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $Multiple       = $Param{Multiple}                  ? 'multiple = "multiple"' : '';
    my $OptionTitle    = defined( $Param{OptionTitle} )    ? $Param{OptionTitle}     : 0;
    my $OnChangeSubmit = defined( $Param{OnChangeSubmit} ) ? $Param{OnChangeSubmit}  : '';
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit();\"";
    }
    else {
        $OnChangeSubmit = '';
    }

    # set OnChange if AJAX is used
    if ( $Param{Ajax} ) {
        if ( !$Param{Ajax}->{Depend} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Depend Param Ajax option!',
            );
            $Self->FatalError();
        }
        if ( !$Param{Ajax}->{Update} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Update Param Ajax option()!',
            );
            $Self->FatalError();
        }
        $Param{OnChange}
            = "Core.AJAX.FormUpdate(\$('#"
            . $Param{Name} . "'), '"
            . $Param{Ajax}->{Subaction} . "',"
            . " '$Param{Name}',"
            . " ['"
            . join( "', '", @{ $Param{Ajax}->{Update} } ) . "']);";
    }

    if ( $Param{OnChange} ) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    # just show a simple list
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'list' ) {
        $Param{MoveQueuesStrg} = $Self->BuildSelection(
            %Param,
            HTMLQuote     => 0,
            SelectedID    => $Param{SelectedID} || $Param{SelectedIDRefArray} || '',
            SelectedValue => $Param{Selected},
            Translation   => 0,
        );
        return $Param{MoveQueuesStrg};
    }

    # build tree list
    $Param{MoveQueuesStrg}
        = '<select name="'
        . $Param{Name}
        . '" id="'
        . $Param{Name}
        . '" class="'
        . $Class
        . "\" $Size $Multiple $OnChangeSubmit>\n";
    my %UsedData;
    my %Data;

    if ( $Param{Data} && ref $Param{Data} eq 'HASH' ) {
        %Data = %{ $Param{Data} };
    }
    else {
        return 'Need Data Ref in AgentQueueListOption()!';
    }

    # add suffix for correct sorting
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        $Data{$_} .= '::';
    }

    # to show disabled queues only one time in the selection tree
    my %DisabledQueueAlreadyUsed;

    # build selection string
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        my @Queue = split( /::/, $Param{Data}->{$_} );
        $UsedData{ $Param{Data}->{$_} } = 1;
        my $UpQueue = $Param{Data}->{$_};
        $UpQueue =~ s/^(.*)::.+?$/$1/g;
        if ( !$Queue[$MaxLevel] && $Queue[-1] ne '' ) {
            $Queue[-1] = $Self->Ascii2Html( Text => $Queue[-1], Max => 50 - $#Queue );
            my $Space = '';
            for ( my $i = 0; $i < $#Queue; $i++ ) {
                $Space .= '&nbsp;&nbsp;';
            }

            # check if SelectedIDRefArray exists
            if ($SelectedIDRefArray) {
                for my $ID ( @{$SelectedIDRefArray} ) {
                    if ( $ID eq $_ ) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }

            if ( !$UsedData{$UpQueue} ) {

                # integrate the not selectable parent and root queues of this queue
                # useful for ACLs and complex permission settings
                for my $Index ( 0 .. ( scalar @Queue - 2 ) ) {

                    # get the Full Queue Name (with all it's parents separed by '::') this will
                    # make a unique name and will be used to set the %DisabledQueueAlreadyUsed
                    # using unique names will prevent erroneous hide of Sub-Queues with the
                    # same name, refer to bug#8148
                    my $FullQueueName;
                    for my $Counter ( 0 .. $Index ) {
                        $FullQueueName .= $Queue[$Counter];
                        if ( int $Counter < int $Index ) {
                            $FullQueueName .= '::';
                        }
                    }

                    if ( !$DisabledQueueAlreadyUsed{$FullQueueName} ) {
                        my $DSpace               = '&nbsp;&nbsp;' x $Index;
                        my $OptionTitleHTMLValue = '';
                        if ($OptionTitle) {
                            my $HTMLValue = $Self->{HTMLUtilsObject}->ToHTML(
                                String => $Queue[$Index],
                            );
                            $OptionTitleHTMLValue = ' title="' . $HTMLValue . '"';
                        }
                        $Param{MoveQueuesStrg}
                            .= '<option value="-" disabled="disabled"'
                            . $OptionTitleHTMLValue
                            . '>'
                            . $DSpace
                            . $Queue[$Index]
                            . "</option>\n";
                        $DisabledQueueAlreadyUsed{$FullQueueName} = 1;
                    }
                }
            }

            # create selectable elements
            my $String               = $Space . $Queue[-1];
            my $OptionTitleHTMLValue = '';
            if ($OptionTitle) {
                my $HTMLValue = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Queue[-1],
                );
                $OptionTitleHTMLValue = ' title="' . $HTMLValue . '"';
            }
            if (
                $SelectedID eq $_
                || $Selected eq $Param{Data}->{$_}
                || $Param{SelectedIDRefArrayOK}->{$_}
                )
            {
                $Param{MoveQueuesStrg}
                    .= '<option selected="selected" value="'
                    . $_ . '"'
                    . $OptionTitleHTMLValue . '>'
                    . $String
                    . "</option>\n";
            }
            elsif ( $CurrentQueueID eq $_ )
            {
                $Param{MoveQueuesStrg}
                    .= '<option value="-" disabled="disabled"'
                    . $OptionTitleHTMLValue . '>'
                    . $String
                    . "</option>\n";
            }
            else {
                $Param{MoveQueuesStrg}
                    .= '<option value="'
                    . $_ . '"'
                    . $OptionTitleHTMLValue . '>'
                    . $String
                    . "</option>\n";
            }
        }
    }
    $Param{MoveQueuesStrg} .= "</select>\n";

    return $Param{MoveQueuesStrg};
}

=item ArticleQuote()

get body and attach e. g. inline documents and/or attach all attachments to
upload cache

for forward or split, get body and attach all attachments

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCacheObject   => $Self->{UploadCacheObject},
        AttachmentsInclude => 1,
    );

or just for including inline documents to upload cache

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCacheObject   => $Self->{UploadCacheObject},
        AttachmentsInclude => 0,
    );

Both will also work without rich text (if $ConfigObject->Get('Frontend::RichText')
is false), return param will be text/plain instead.

=cut

sub ArticleQuote {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ArticleID FormID UploadCacheObject)) {
        if ( !$Param{$_} ) {
            $Self->FatalError( Message => "Need $_!" );
        }
    }

    # body preparation for plain text processing
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {

        my $Body = '';

        # check for html body
        my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(
            TicketID                   => $Param{TicketID},
            StripPlainBodyAsAttachment => 3,
            UserID                     => $Self->{UserID},
            DynamicFields              => 0,
        );

        my %NotInlineAttachments;
        ARTICLE:
        for my $ArticleTmp (@ArticleBox) {

            # search for article to answer (reply article)
            next ARTICLE if $ArticleTmp->{ArticleID} ne $Param{ArticleID};

            # check if no html body exists
            last ARTICLE if !$ArticleTmp->{AttachmentIDOfHTMLBody};

            my %AttachmentHTML = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $ArticleTmp->{ArticleID},
                FileID    => $ArticleTmp->{AttachmentIDOfHTMLBody},
                UserID    => $Self->{UserID},
            );
            my $Charset = $AttachmentHTML{ContentType} || '';
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;

            # convert html body to correct charset
            $Body = $Self->{EncodeObject}->Convert(
                Text => $AttachmentHTML{Content},
                From => $Charset,
                To   => $Self->{UserCharset},
            );

            # add url quoting
            $Body = $Self->{HTMLUtilsObject}->LinkQuote(
                String => $Body,
            );

            # strip head, body and meta elements
            $Body = $Self->{HTMLUtilsObject}->DocumentStrip(
                String => $Body,
            );

            # display inline images if exists
            my $SessionID = '';
            if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
                $SessionID = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
            }
            my $AttachmentLink = $Self->{Baselink}
                . 'Action=PictureUpload'
                . ';FormID='
                . $Param{FormID}
                . $SessionID
                . ';ContentID=';

            # search inline documents in body and add it to upload cache
            my %Attachments = %{ $ArticleTmp->{Atms} };
            my %AttachmentAlreadyUsed;
            $Body =~ s{
                (=|"|')cid:(.*?)("|'|>|\/>|\s)
            }
            {
                my $Start= $1;
                my $ContentID = $2;
                my $End = $3;

                # improve html quality
                if ( $Start ne '"' && $Start ne '\'' ) {
                    $Start .= '"';
                }
                if ( $End ne '"' && $End ne '\'' ) {
                    $End = '"' . $End;
                }

                # find attachment to include
                ATMCOUNT:
                for my $AttachmentID ( sort keys %Attachments ) {

                    # next is cid is not matchin
                    if ( lc $Attachments{$AttachmentID}->{ContentID} ne lc "<$ContentID>" ) {
                        next ATMCOUNT;
                    }

                    # get whole attachment
                    my %AttachmentPicture = $Self->{TicketObject}->ArticleAttachment(
                        ArticleID => $Param{ArticleID},
                        FileID    => $AttachmentID,
                        UserID    => $Self->{UserID},
                    );

                    # content id cleanup
                    $AttachmentPicture{ContentID} =~ s/^<//;
                    $AttachmentPicture{ContentID} =~ s/>$//;

                    # find cid, add attachment URL and remeber, file is already uploaded
                    $ContentID = $AttachmentLink . $Self->LinkEncode( $AttachmentPicture{ContentID} );

                    # add to upload cache if not uploaded and remember
                    if (!$AttachmentAlreadyUsed{$AttachmentID}) {

                        # remember
                        $AttachmentAlreadyUsed{$AttachmentID} = 1;

                        # write attachment to upload cache
                        $Param{UploadCacheObject}->FormIDAddFile(
                            FormID      => $Param{FormID},
                            Disposition => 'inline',
                            %{ $Attachments{$AttachmentID} },
                            %AttachmentPicture,
                        );
                    }
                }

                # return link
                $Start . $ContentID . $End;
            }egxi;

            # find inlines images using Content-Location instead of Content-ID
            for my $AttachmentID ( sort keys %Attachments ) {

                next if !$Attachments{$AttachmentID}->{ContentID};

                # get whole attachment
                my %AttachmentPicture = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentID,
                    UserID    => $Self->{UserID},
                );

                # content id cleanup
                $AttachmentPicture{ContentID} =~ s/^<//;
                $AttachmentPicture{ContentID} =~ s/>$//;

                $Body =~ s{
                    ("|')(\Q$AttachmentPicture{ContentID}\E)("|'|>|\/>|\s)
                }
                {
                    my $Start= $1;
                    my $ContentID = $2;
                    my $End = $3;

                    # find cid, add attachment URL and remeber, file is already uploaded
                    $ContentID = $AttachmentLink . $Self->LinkEncode( $AttachmentPicture{ContentID} );

                    # add to upload cache if not uploaded and remember
                    if (!$AttachmentAlreadyUsed{$AttachmentID}) {

                        # remember
                        $AttachmentAlreadyUsed{$AttachmentID} = 1;

                        # write attachment to upload cache
                        $Param{UploadCacheObject}->FormIDAddFile(
                            FormID      => $Param{FormID},
                            Disposition => 'inline',
                            %{ $Attachments{$AttachmentID} },
                            %AttachmentPicture,
                        );
                    }

                    # return link
                    $Start . $ContentID . $End;
                }egxi;
            }

            # find not inline images
            for my $AttachmentID ( sort keys %Attachments ) {
                next if $AttachmentAlreadyUsed{$AttachmentID};
                $NotInlineAttachments{$AttachmentID} = 1;
            }

            # do no more article
            last ARTICLE;
        }

        # attach also other attachments on article forward
        if ( $Body && $Param{AttachmentsInclude} ) {
            for my $AttachmentID ( sort keys %NotInlineAttachments ) {
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentID,
                    UserID    => $Self->{UserID},
                );

                # add attachment
                $Param{UploadCacheObject}->FormIDAddFile(
                    FormID => $Param{FormID},
                    %Attachment,
                );
            }
        }
        return $Body if $Body;
    }

    # as fallback use text body for quote
    my %Article = $Self->{TicketObject}->ArticleGet(
        ArticleID     => $Param{ArticleID},
        DynamicFields => 0,
    );

    # check if original content isn't text/plain or text/html, don't use it
    if ( !$Article{ContentType} ) {
        $Article{ContentType} = 'text/plain';
    }

    if ( $Article{ContentType} !~ /text\/(plain|html)/i ) {
        $Article{Body}        = '-> no quotable message <-';
        $Article{ContentType} = 'text/plain';
    }
    else {
        my $Size = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail') || 82;
        $Article{Body} =~ s/(^>.+|.{4,$Size})(?:\s|\z)/$1\n/gm;
    }

    # attach attachments
    if ( $Param{AttachmentsInclude} ) {
        my %ArticleIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID => $Param{ArticleID},
            UserID    => $Self->{UserID},
        );
        for my $Index ( sort keys %ArticleIndex ) {
            my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $Param{ArticleID},
                FileID    => $Index,
                UserID    => $Self->{UserID},
            );

            # add attachment
            $Param{UploadCacheObject}->FormIDAddFile(
                FormID => $Param{FormID},
                %Attachment,
            );
        }
    }

    # return body as html
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {

        $Article{Body} = $Self->Ascii2Html(
            Text           => $Article{Body},
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    # return body as plain text
    return $Article{Body};
}

sub TicketListShow {
    my ( $Self, %Param ) = @_;

    # take object ref to local, remove it from %Param (prevent memory leak)
    my $Env = $Param{Env};
    delete $Param{Env};

    # lookup latest used view mode
    if ( !$Param{View} && $Self->{ 'UserTicketOverview' . $Env->{Action} } ) {
        $Param{View} = $Self->{ 'UserTicketOverview' . $Env->{Action} };
    }

    # set defaut view mode to 'small'
    my $View = $Param{View} || 'Small';

    # set default view mode for AgentTicketQueue
    if ( !$Param{View} && $Env->{Action} eq 'AgentTicketQueue' ) {
        $View = 'Preview';
    }

    # store latest view mode
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserTicketOverview' . $Env->{Action},
        Value     => $View,
    );

    # update preferences if needed
    my $Key = 'UserTicketOverview' . $Env->{Action};
    if ( !$Self->{ConfigObject}->Get('DemoSystem') && $Self->{$Key} ne $View ) {
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Key,
            Value  => $View,
        );
    }

    # check backends
    my $Backends = $Self->{ConfigObject}->Get('Ticket::Frontend::Overview');
    if ( !$Backends ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Need config option Ticket::Frontend::Overview',
        );
    }
    if ( ref $Backends ne 'HASH' ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Config option Ticket::Frontend::Overview need to be HASH ref!',
        );
    }

    # check if selected view is available
    if ( !$Backends->{$View} ) {

        # try to find fallback, take first configured view mode
        for my $Key ( sort keys %{$Backends} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No Config option found for view mode $View, took $Key instead!",
            );
            $View = $Key;
            last;
        }
    }

    # load overview backend module
    if ( !$Self->{MainObject}->Require( $Backends->{$View}->{Module} ) ) {
        return $Env->{LayoutObject}->FatalError();
    }
    my $Object = $Backends->{$View}->{Module}->new( %{$Env} );
    return if !$Object;

    # run action row backend module
    $Param{ActionRow} = $Object->ActionRow(
        %Param,
        Config => $Backends->{$View},
    );

    # run overview backend module
    $Param{SortOrderBar} = $Object->SortOrderBar(
        %Param,
        Config => $Backends->{$View},
    );

    # check start option, if higher then tickets available, set
    # it to the last ticket page (Thanks to Stefan Schmidt!)
    my $StartHit = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;

    # get personal page shown count
    my $PageShownPreferencesKey = 'UserTicketOverview' . $View . 'PageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 10;
    my $Group                   = 'TicketOverview' . $View . 'PageShown';

    # get data selection
    my %Data;
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # calculate max. shown per page
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # build nav bar
    my $Limit = $Param{Limit} || 20_000;
    my %PageNav = $Env->{LayoutObject}->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Env->{LayoutObject}->{Action},
        Link      => $Param{LinkPage},
        IDPrefix  => $Env->{LayoutObject}->{Action},
    );

    # build shown ticket per page
    $Param{RequestedURL}    = "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PreferencesKey}  = $PageShownPreferencesKey;
    $Param{PageShownString} = $Self->BuildSelection(
        Name        => $PageShownPreferencesKey,
        SelectedID  => $PageShown,
        Translation => 0,
        Data        => \%Data,
    );

    # nav bar at the beginning of a overview
    $Param{View} = $View;
    $Env->{LayoutObject}->Block(
        Name => 'OverviewNavBar',
        Data => \%Param,
    );

    # back link
    if ( $Param{LinkBack} ) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageBack',
            Data => \%Param,
        );
    }

    # filter selection
    if ( $Param{Filters} ) {
        my @NavBarFilters;
        for my $Prio ( sort keys %{ $Param{Filters} } ) {
            push @NavBarFilters, $Param{Filters}->{$Prio};
        }
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarFilter',
            Data => {
                %Param,
            },
        );
        my $Count = 0;
        for my $Filter (@NavBarFilters) {
            $Count++;
            if ( $Count == scalar @NavBarFilters ) {
                $Filter->{CSS} = 'Last';
            }
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarFilterItem',
                Data => {
                    %Param,
                    %{$Filter},
                },
            );
            if ( $Filter->{Filter} eq $Param{Filter} ) {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelected',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
            else {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelectedNot',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
        }
    }

    # view mode
    for my $Backend (
        sort { $Backends->{$a}->{ModulePriority} <=> $Backends->{$b}->{ModulePriority} }
        keys %{$Backends}
        )
    {

        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarViewMode',
            Data => {
                %Param,
                %{ $Backends->{$Backend} },
                Filter => $Param{Filter},
                View   => $Backend,
            },
        );
        if ( $View eq $Backend ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
        else {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeNotSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
    }

    if (%PageNav) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        # don't show context settings in AJAX case (e. g. in customer ticket history),
        #   because the submit with page reload will not work there
        if ( !$Param{AJAX} ) {
            $Env->{LayoutObject}->Block(
                Name => 'ContextSettings',
                Data => {
                    %PageNav,
                    %Param,
                },
            );
        }
    }

    if ( $Param{NavBar} ) {
        if ( $Param{NavBar}->{MainName} ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarMain',
                Data => $Param{NavBar},
            );
        }
    }

    my $OutputNavBar = $Env->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewNavBar',
        Data         => { %Param, },
    );
    my $OutputRaw = '';
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print( Output => \$OutputNavBar );
    }
    else {
        $OutputRaw .= $OutputNavBar;
    }

    # run overview backend module
    my $Output = $Object->Run(
        %Param,
        Config    => $Backends->{$View},
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Output    => $Param{Output} || '',
    );
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print( Output => \$Output );
    }
    else {
        $OutputRaw .= $Output;
    }

    return $OutputRaw;
}

sub TicketMetaItemsCount {
    my ( $Self, %Param ) = @_;
    return ( 'Priority', 'New Article' );
}

sub TicketMetaItems {
    my ( $Self, %Param ) = @_;

    if ( ref $Param{Ticket} ne 'HASH' ) {
        $Self->FatalError( Message => 'Need Hash ref in Ticket param!' );
    }

    # return attributes
    my @Result;

    # show priority
    push @Result, {

        #            Image => $Image,
        Title      => $Param{Ticket}->{Priority},
        Class      => 'Flag',
        ClassSpan  => 'PriorityID-' . $Param{Ticket}->{PriorityID},
        ClassTable => 'Flags',
    };

    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{Ticket}->{TicketID} );

    # Show if new message is in there, but show archived tickets as read.
    my %TicketFlag;
    if ( $Ticket{ArchiveFlag} ne 'y' ) {
        %TicketFlag = $Self->{TicketObject}->TicketFlagGet(
            TicketID => $Param{Ticket}->{TicketID},
            UserID   => $Self->{UserID},
        );
    }

    if ( $Ticket{ArchiveFlag} eq 'y' || $TicketFlag{Seen} ) {
        push @Result, undef;
    }
    else {

        # just show ticket flags if agent belongs to the ticket
        my $ShowMeta;
        if (
            $Self->{UserID} == $Param{Ticket}->{OwnerID}
            || $Self->{UserID} == $Param{Ticket}->{ResponsibleID}
            )
        {
            $ShowMeta = 1;
        }
        if ( !$ShowMeta && $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
            my %Watch = $Self->{TicketObject}->TicketWatchGet(
                TicketID => $Param{Ticket}->{TicketID},
            );
            if ( $Watch{ $Self->{UserID} } ) {
                $ShowMeta = 1;
            }
        }

        # show ticket flags
        my $Image = 'meta-new-inactive.png';
        if ($ShowMeta) {
            $Image = 'meta-new.png';
            push @Result, {
                Image      => $Image,
                Title      => 'Unread article(s) available',
                Class      => 'UnreadArticles',
                ClassSpan  => 'UnreadArticles Important',
                ClassTable => 'UnreadArticles',
            };
        }
        else {
            push @Result, {
                Image      => $Image,
                Title      => 'Unread article(s) available',
                Class      => 'UnreadArticles',
                ClassSpan  => 'UnreadArticles Unimportant',
                ClassTable => 'UnreadArticles',
            };
        }
    }

    return @Result;
}

1;
