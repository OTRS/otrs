# --
# Kernel/Output/HTML/LayoutPopup.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutPopup.pm,v 1.1 2010-07-13 21:18:40 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutPopup;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::Output::HTML::LayoutPopup - CSS/JavaScript

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item PopupClose()

Generate the call Header() and Footer() for Pop-Up Close.

    $LayoutObject->PopupClose(
        URL => "The URL"
    );

    $Self->{LayoutObject}->PopupClose(
        URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID",
    );

=cut

sub PopupClose {
    my ( $Self, %Param ) = @_;

    if ( !$Param{URL} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need URL!' );
        return;
    }

    # Generate the call Header() and Footer(
    my $Output = $Self->Header( Type => 'Small' );
    $Self->Block(
        Name => 'LoadParentURLAndClose',
        Data => {
            URL => $Param{URL},
        },
    );
    $Output .= $Self->Output( TemplateFile => 'AgentTicketActionPopupClose' );
    $Output .= $Self->Footer( Type => 'Small' );
    return $Output;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2010-07-13 21:18:40 $

=cut
