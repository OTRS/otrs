# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketZoom::Agent::MIMEBase;

use parent 'Kernel::Output::HTML::TicketZoom::Agent::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsPositiveInteger);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Article::MIMEBase',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

=head2 ArticleRender()

Returns article html.

    my $HTML = $ArticleBaseObject->ArticleRender(
        TicketID               => 123,         # (required)
        ArticleID              => 123,         # (required)
        ShowBrowserLinkMessage => 1,           # (optional) Default: 0.
        ArticleActions         => [],          # (optional)
        UserID                 => 123,         # (optional)
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

    # Get data from modules like Google CVE search
    my @ArticleModuleMeta = $Self->_ArticleModuleMeta(%Param);

    # Show created by string, if creator is different from admin user.
    if ( $Article{CreateBy} > 1 ) {
        $Article{CreateByUser} = $Kernel::OM->Get('Kernel::System::User')->UserName( UserID => $Article{CreateBy} );
    }

    my $RichTextEnabled = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

    # Show HTML if RichText is enabled and HTML attachment isn't missing.
    my $ShowHTML         = $RichTextEnabled;
    my $HTMLBodyAttachID = $Kernel::OM->Get('Kernel::Output::HTML::Article::MIMEBase')->HTMLBodyAttachmentIDGet(
        %Param,
    );
    if ( $ShowHTML && !$HTMLBodyAttachID ) {
        $ShowHTML = 0;
    }

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

    # Add block for attachments.
    if (%AtmIndex) {
        my $Config = $ConfigObject->Get('Ticket::Frontend::ArticleAttachmentModule');

        ATTACHMENT:
        for my $FileID ( sort keys %AtmIndex ) {

            my $Attachment;

            # Run article attachment modules.
            next ATTACHMENT if ref $Config ne 'HASH';
            my %Jobs = %{$Config};

            JOB:
            for my $Job ( sort keys %Jobs ) {
                my %File = %{ $AtmIndex{$FileID} };

                # load module
                next JOB if !$MainObject->Require( $Jobs{$Job}->{Module} );
                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    TicketID  => $Param{TicketID},
                    ArticleID => $Param{ArticleID},
                    UserID    => $Param{UserID} || 1,
                );

                # run module
                my %Data = $Object->Run(
                    File => {
                        %File,
                        FileID => $FileID,
                    },
                    TicketID => $Param{TicketID},
                    Article  => \%Article,
                );

                if (%Data) {
                    %File = %Data;
                }

                $File{Links} = [
                    {
                        Action => $File{Action},
                        Class  => $File{Class},
                        Link   => $File{Link},
                        Target => $File{Target},
                    },
                ];
                if ( $File{Action} && $File{Action} ne 'Download' ) {
                    delete $File{Action};
                    delete $File{Class};
                    delete $File{Link};
                    delete $File{Target};
                }

                if ($Attachment) {
                    push @{ $Attachment->{Links} }, $File{Links}->[0];
                }
                else {
                    $Attachment = \%File;
                }
            }
            push @ArticleAttachments, $Attachment;
        }
    }

    my $ArticleContent;

    if ($ShowHTML) {
        if ( $Param{ShowBrowserLinkMessage} ) {
            $LayoutObject->Block(
                Name => 'BrowserLinkMessage',
            );
        }
    }
    else {
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

    if ( $CommunicationChannel{ChannelName} eq 'Email' ) {
        my $TransmissionStatus = $ArticleBackendObject->ArticleTransmissionStatus(
            ArticleID => $Article{ArticleID},
        );
        if ($TransmissionStatus) {
            $LayoutObject->Block(
                Name => 'TransmissionStatusMessage',
                Data => $TransmissionStatus,
            );
        }
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/ArticleRender/MIMEBase',
        Data         => {
            %Article,
            ArticleFields        => \%ArticleFields,
            ArticleMetaFields    => \%ArticleMetaFields,
            ArticleModuleMeta    => \@ArticleModuleMeta,
            Attachments          => \@ArticleAttachments,
            MenuItems            => $Param{ArticleActions},
            Body                 => $ArticleContent,
            HTML                 => $ShowHTML,
            CommunicationChannel => $CommunicationChannel{DisplayName},
            ChannelIcon          => $CommunicationChannel{DisplayIcon},
            SenderImage          => $Self->_ArticleSenderImage(
                Sender => $Article{From},
                UserID => $Param{UserID},
            ),
            SenderInitials => $LayoutObject->UserInitialsGet(
                Fullname => $Article{FromRealname},
            ),
        },
    );

    return $Content;
}

1;
