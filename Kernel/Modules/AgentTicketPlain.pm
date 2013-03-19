# --
# Kernel/Modules/AgentTicketPlain.pm - to get a plain view
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPlain;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{ArticleID} = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Self->{ArticleID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ArticleID!',
            Comment => 'Please contact your administrator'
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
        return $Self->{LayoutObject}->NoPermission();
    }

    my %Article = $Self->{TicketObject}->ArticleGet(
        ArticleID     => $Self->{ArticleID},
        DynamicFields => 0,
    );
    my $Plain = $Self->{TicketObject}->ArticlePlain( ArticleID => $Self->{ArticleID} );
    if ( !$Plain ) {
        return $Self->{LayoutObject}->ErrorScreen(
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
        return $Self->{LayoutObject}->Attachment(
            Filename    => $Filename,
            ContentType => 'message/rfc822',
            Content     => $Plain,
            Type        => 'attachment',
        );
    }

    # show plain emails
    $Plain = $Self->{LayoutObject}->Ascii2Html(
        Text           => $Plain,
        HTMLResultMode => 1,
    );

    # do some highlightings
    $Plain
        =~ s/^((From|To|Cc|Bcc|Subject|Reply-To|Organization|X-Company):.*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^(Date:.*)/<span class="Error">$1<\/span>/m;
    $Plain
        =~ s/^((X-Mailer|User-Agent|X-OS):.*(Mozilla|Win?|Outlook|Microsoft|Internet Mail Service).*)/<span class="Error">$1<\/span>/gmi;
    $Plain
        =~ s/(^|^<blink>)((X-Mailer|User-Agent|X-OS|X-Operating-System):.*)/<span class="Error">$1$2<\/span>/gmi;
    $Plain =~ s/^((Resent-.*):.*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^(From .*)/<span class="Error">$1<\/span>/gm;
    $Plain =~ s/^(X-OTRS.*)/<span class="Error">$1<\/span>/gmi;

    my $Output = $Self->{LayoutObject}->Header(
        Type => 'Small',
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketPlain',
        Data         => {
            Text => $Plain,
            %Article,
        },
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small', );
    return $Output;
}

1;
