# --
# Kernel/Modules/AgentTicketPlain.pm - to get a plain view
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPlain;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ArticleID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ArticleID' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$ArticleID ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No ArticleID!',
            Comment => 'Please contact your administrator'
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
        return $LayoutObject->NoPermission();
    }

    my %Article = $TicketObject->ArticleGet(
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );
    my $Plain = $TicketObject->ArticlePlain( ArticleID => $ArticleID );
    if ( !$Plain ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Can\'t read plain article! Maybe there is no plain email in backend! '
            , 'Read BackendMessage.',
            Comment => 'Please contact your administrator',
        );
    }

    # download email
    if ( $Self->{Subaction} eq 'Download' ) {

        # return file
        my $Filename = "Ticket-$Article{TicketNumber}-TicketID-$Article{TicketID}-"
            . "ArticleID-$Article{ArticleID}.eml";
        return $LayoutObject->Attachment(
            Filename    => $Filename,
            ContentType => 'message/rfc822',
            Content     => $Plain,
            Type        => 'attachment',
        );
    }

    # show plain emails
    $Plain = $LayoutObject->Ascii2Html(
        Text           => $Plain,
        HTMLResultMode => 1,
    );

    # do some highlightings
    $Plain
        =~ s/^((From|To|Cc|Bcc|Subject|Reply-To|Organization|X-Company):.*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^(Date:.*)/<span class="Error">$1<\/span>/m;
    $Plain
        =~ s/^((X-Mailer|User-Agent|X-OS):.*(Mozilla|Win?|Outlook|Microsoft|Internet Mail Service).*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^((Resent-.*):.*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^(From .*)/<span class="Error">$1<\/span>/gm;
    $Plain =~ s/^(X-OTRS.*)/<span class="Error">$1<\/span>/gmi;

    my $Output = $LayoutObject->Header(
        Type => 'Small',
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentTicketPlain',
        Data         => {
            Text => $Plain,
            %Article,
        },
    );
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );
    return $Output;
}

1;
