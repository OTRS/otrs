# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketZoom::Agent::Chat;

use parent 'Kernel::Output::HTML::TicketZoom::Agent::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsPositiveInteger);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

=head2 ArticleRender()

Returns article html.

    my $HTML = $ArticleBaseObject->ArticleRender(
        TicketID       => 123,   # (required)
        ArticleID      => 123,   # (required)
        ArticleActions => [],    # (optional)
        UserID         => 123,   # (optional)
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
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Article = $ArticleBackendObject->ArticleGet(%Param);
    if ( !%Article ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Article not found (ArticleID=$Param{ArticleID})!"
        );
        return;
    }

    # Check if HTML should be displayed.
    my $ShowHTML = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

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

    my $ArticleContent = $LayoutObject->ArticlePreview(
        TicketID   => $Param{TicketID},
        ArticleID  => $Param{ArticleID},
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
        TemplateFile => 'AgentTicketZoom/ArticleRender/Chat',
        Data         => {
            %Article,
            ArticleFields        => \%ArticleFields,
            ArticleMetaFields    => \%ArticleMetaFields,
            ArticleModuleMeta    => \@ArticleModuleMeta,
            MenuItems            => $Param{ArticleActions},
            Body                 => $ArticleContent,
            HTML                 => $ShowHTML,
            CommunicationChannel => $CommunicationChannel{DisplayName},
            ChannelIcon          => $CommunicationChannel{DisplayIcon},
            SenderImage          => $Self->_ArticleSenderImage(
                Sender => $ArticleFields{Sender}->{Value},
                UserID => $Param{UserID},
            ),
            SenderInitials => $LayoutObject->UserInitialsGet(
                Fullname => $ArticleFields{Sender}->{Realname},
            ),
        },
    );

    return $Content;
}

1;
