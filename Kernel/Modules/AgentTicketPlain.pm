# --
# Kernel/Modules/AgentTicketPlain.pm - to get a plain view
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketPlain.pm,v 1.11 2009-07-25 18:26:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPlain;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

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
            Comment => 'Please contact your admin'
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->Permission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );
    my $Plain   = $Self->{TicketObject}->ArticlePlain( ArticleID => $Self->{ArticleID} );
    if ( !$Plain ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Can\'t read plain article! Maybe there is no plain email in backend! '
                , 'Read BackendMessage.',
            Comment => 'Please contact your admin!',
        );
    }

    # download email
    if ( $Self->{Subaction} eq 'Download' ) {

        # return file
        my $Filename = "Ticket-$Article{TicketNumber}-TicketID-$Article{TicketID}-"
            . "ArticleID-$Article{ArticleID}.eml";
        return $Self->{LayoutObject}->Attachment(
            Filename    => $Filename,
            ContentType => 'text/plain',
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
        =~ s/^((From|To|Cc|Bcc|Subject|Reply-To|Organization|X-Company):.*)/<font color=\"red\">$1<\/font>/gmi;
    $Plain =~ s/^(Date:.*)/<FONT COLOR=777777>$1<\/font>/m;
    $Plain
        =~ s/^((X-Mailer|User-Agent|X-OS):.*(Mozilla|Win?|Outlook|Microsoft|Internet Mail Service).*)/<blink>$1<\/blink>/gmi;
    $Plain
        =~ s/(^|^<blink>)((X-Mailer|User-Agent|X-OS|X-Operating-System):.*)/<font color=\"blue\">$1$2<\/font>/gmi;
    $Plain =~ s/^((Resent-.*):.*)/<font color=\"green\">$1<\/font>/gmi;
    $Plain =~ s/^(From .*)/<font color=\"gray\">$1<\/font>/gm;
    $Plain =~ s/^(X-OTRS.*)/<font color=\"#99BBDD\">$1<\/font>/gmi;

    my $Output = $Self->{LayoutObject}->Header(
        Value => "$Article{TicketNumber} / $Self->{TicketID} / $Self->{ArticleID}"
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketPlain',
        Data         => {
            Text => $Plain,
            %Article,
        }
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
