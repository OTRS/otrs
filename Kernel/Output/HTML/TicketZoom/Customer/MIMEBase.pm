# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketZoom::Customer::MIMEBase;

use parent 'Kernel::Output::HTML::TicketZoom::Customer::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsPositiveInteger);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
    'Kernel::Output::HTML::Article::MIMEBase',
);

=head2 ArticleRender()

Returns article html.

    my $HTML = $ArticleBaseObject->ArticleRender(
        TicketID               => 123,         # (required)
        ArticleID              => 123,         # (required)
        ShowBrowserLinkMessage => 1,           # (optional) Default: 0.
        ArticleActions         => [],          # (optional)
        Class                  => 'Visible',   # (optional)
    );

Result:
    $HTML = "<div>...</div>";

=cut

sub ArticleRender {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Article = $ArticleBackendObject->ArticleGet(
        %Param,
        RealNames => 1,
    );
    if ( !%Article ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Article not found (ArticleID=$Param{ArticleID})!"
        );
        return;
    }

    # Get channel specific fields
    my %ArticleFields = $LayoutObject->ArticleFields(%Param);

    # Get dynamic fields and accounted time
    my %ArticleMetaFields = $Self->ArticleMetaFields(%Param);

    my $RichTextEnabled = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

    # Strip plain text attachments by default.
    my $ExcludePlainText = 1;

    # Do not strip plain text attachments if no plain text article body was found.
    if ( $Article{Body} && $Article{Body} eq '- no text message => see attachment -' ) {
        $ExcludePlainText = 0;
    }

    # Get attachment index (excluding body attachments).
    my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID        => $Param{ArticleID},
        ExcludePlainText => $ExcludePlainText,
        ExcludeHTMLBody  => $RichTextEnabled,
        ExcludeInline    => $RichTextEnabled,
    );

    my @ArticleAttachments;

    # Include attachments.
    if (%AtmIndex) {

        my $Type = $ConfigObject->Get('AttachmentDownloadType') || 'attachment';

        # If attachment will be downloaded, don't open the link in new window!
        my $Target = '';
        if ( $Type =~ /inline/i ) {
            $Target = 'target="attachment" ';
        }

        ATTACHMENT:
        for my $FileID ( sort keys %AtmIndex ) {
            push @ArticleAttachments, {
                %{ $AtmIndex{$FileID} },
                Action => 'Download',
                Link   => $LayoutObject->{Baselink} .
                    "Action=CustomerTicketAttachment;TicketID=$Param{TicketID};ArticleID=$Param{ArticleID};FileID=$FileID",
                Target => $Target,
            };
        }
    }

    # Check if HTML should be displayed.
    my $ShowHTML = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

    # Check if HTML attachment is missing.
    if ( $ShowHTML && !$Kernel::OM->Get('Kernel::Output::HTML::Article::MIMEBase')->HTMLBodyAttachmentIDGet(%Param) ) {
        $ShowHTML = 0;
    }

    my $ArticleContent;

    if ( !$ShowHTML ) {

        $ArticleContent = $LayoutObject->ArticlePreview(
            %Param,
            ResultType => 'plain',
        );

        # html quoting
        $ArticleContent = $LayoutObject->Ascii2Html(
            NewLine        => $ConfigObject->Get('DefaultViewNewLine'),
            Text           => $ArticleContent,
            VMax           => $ConfigObject->Get('DefaultViewLines') || 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
        ChannelID => $Article{CommunicationChannelID},
    );

    # Get screen config for CustomerTicketZoom
    my $ScreenConfig = $ConfigObject->Get('Ticket::Frontend::CustomerTicketZoom');

    # Define if internal notes that are marked as "visible for customer" should show the real name of the agent
    #   or just a default agent name.
    if (
        $ScreenConfig->{DisplayNoteFrom}
        && $ScreenConfig->{DisplayNoteFrom} eq 'DefaultAgentName'
        && $CommunicationChannel{ChannelName} eq 'Internal'
        && $Article{SenderType} eq 'agent'
        && $Article{IsVisibleForCustomer}
        )
    {

        my $DefaultAgentName
            = $LayoutObject->{LanguageObject}->Translate( $ScreenConfig->{DefaultAgentName} || 'Support Agent' );
        $ArticleFields{From}->{Realname}   = $DefaultAgentName;
        $ArticleFields{From}->{Value}      = $DefaultAgentName;
        $ArticleFields{Sender}->{Realname} = $DefaultAgentName;
        $ArticleFields{Sender}->{Value}    = $DefaultAgentName;
        $Article{FromRealname}             = $DefaultAgentName;
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'CustomerTicketZoom/ArticleRender/MIMEBase',
        Data         => {
            %Article,
            ArticleFields        => \%ArticleFields,
            ArticleMetaFields    => \%ArticleMetaFields,
            Class                => $Param{Class},
            Attachments          => \@ArticleAttachments,
            MenuItems            => $Param{ArticleActions},
            Body                 => $ArticleContent,
            HTML                 => $ShowHTML,
            CommunicationChannel => $CommunicationChannel{DisplayName},
            ChannelIcon          => $CommunicationChannel{DisplayIcon},
            BrowserLinkMessage   => $Param{ShowBrowserLinkMessage} && $ShowHTML,
            BodyHTMLLoad         => $Param{ArticleExpanded},
            Age                  => $Param{ArticleAge},
        },
    );

    return $Content;
}

1;
