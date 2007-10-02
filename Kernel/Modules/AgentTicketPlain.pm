# --
# Kernel/Modules/AgentTicketPlain.pm - to get a plain view
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketPlain.pm,v 1.7 2007-10-02 10:32:23 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketPlain;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

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
            Message => "No ArticleID!",
            Comment => 'Please contact your admin'
        );
    }

    # check permissions
    if (!$Self->{TicketObject}->Permission(
            Type     => 'ro',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    my %Article = $Self->{TicketObject}->ArticleGet( ArticleID   => $Self->{ArticleID} );
    my $Text    = $Self->{TicketObject}->ArticlePlain( ArticleID => $Self->{ArticleID} );
    if ($Text) {
        if ( $Self->{Subaction} eq 'Download' ) {

            # return new page
            return $Self->{LayoutObject}->Attachment(
                Filename =>
                    "Ticket-$Article{TicketNumber}-TicketID-$Self->{TicketID}-ArticleID-$Self->{ArticleID}.eml",
                ContentType => 'text/plain',
                Content     => $Text,
                Type        => 'attachment',
            );
        }
        else {

            # Ascii2Html
            $Text = $Self->{LayoutObject}->Ascii2Html(
                Text           => $Text,
                HTMLResultMode => 1,
            );

            # do some highlightings
            $Text
                =~ s/^((From|To|Cc|Bcc|Subject|Reply-To|Organization|X-Company):.*)/<font color=\"red\">$1<\/font>/gmi;
            $Text =~ s/^(Date:.*)/<FONT COLOR=777777>$1<\/font>/m;
            $Text
                =~ s/^((X-Mailer|User-Agent|X-OS):.*(Mozilla|Win?|Outlook|Microsoft|Internet Mail Service).*)/<blink>$1<\/blink>/gmi;
            $Text
                =~ s/(^|^<blink>)((X-Mailer|User-Agent|X-OS|X-Operating-System):.*)/<font color=\"blue\">$1$2<\/font>/gmi;
            $Text =~ s/^((Resent-.*):.*)/<font color=\"green\">$1<\/font>/gmi;
            $Text =~ s/^(From .*)/<font color=\"gray\">$1<\/font>/gm;
            $Text =~ s/^(X-OTRS.*)/<font color=\"#99BBDD\">$1<\/font>/gmi;

            my $Output = $Self->{LayoutObject}->Header(
                Value => "$Article{TicketNumber} / $Self->{TicketID} / $Self->{ArticleID}" );
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketPlain',
                Data         => {
                    Text => $Text,
                    %Article,
                    TicketID  => $Self->{TicketID},
                    ArticleID => $Self->{ArticleID},
                }
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message =>
                "Can't read plain article! Maybe there is no plain email in backend! Read BackendMessage.",
            Comment => 'Please contact your admin!',
        );
    }
}

1;
