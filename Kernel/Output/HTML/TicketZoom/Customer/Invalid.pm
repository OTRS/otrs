# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketZoom::Customer::Invalid;

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

Returns article HTML.

    my $HTML = $ArticleBaseObject->ArticleRender(
        TicketID               => 123,         # (required)
        ArticleID              => 123,         # (required)
        Class                  => 'Visible',   # (optional)
        ShowBrowserLinkMessage => 1,           # (optional) Default: 0.
        ArticleActions         => [],          # (optional)
    );

Result:
    $HTML = "<div>...</div>";

=cut

sub ArticleRender {
    my ( $Self, %Param ) = @_;

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

    # Check if HTML should be displayed.
    my $ShowHTML = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

    my $ArticleContent = $LayoutObject->ArticlePreview(
        %Param,
        ResultType => $ShowHTML ? 'HTML' : 'plain',
    );

    if ( !$ShowHTML ) {

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

    my $Content = $LayoutObject->Output(
        TemplateFile => 'CustomerTicketZoom/ArticleRender/Invalid',
        Data         => {
            %Article,
            ArticleFields        => \%ArticleFields,
            Body                 => $ArticleContent,
            HTML                 => $ShowHTML,
            CommunicationChannel => $CommunicationChannel{DisplayName},
            ChannelIcon          => $CommunicationChannel{DisplayIcon},
            Class                => $Param{Class},
            Age                  => $Param{ArticleAge},
        },
    );

    return $Content;
}

1;
