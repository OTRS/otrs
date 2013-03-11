# --
# Kernel/Output/HTML/CustomerHeaderMetaTicketSearch.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::CustomerHeaderMetaTicketSearch;

use strict;
use warnings;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject LayoutObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Session = '';
    if ( !$Self->{LayoutObject}->{SessionIDCookie} ) {
        $Session = ';' . $Self->{LayoutObject}->{SessionName} . '='
            . $Self->{LayoutObject}->{SessionID};
    }
    my $Title = $Self->{ConfigObject}->Get('ProductName');
    $Title .= ' - ' . $Self->{LayoutObject}->{LanguageObject}->Get('Customer');
    $Title .= ' (' . $Self->{ConfigObject}->Get('Ticket::Hook') . ')';
    $Self->{LayoutObject}->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => $Title,
            Href  => '$Env{"Baselink"}Action=' . $Param{Config}->{Action}
                . ';Subaction=OpenSearchDescription' . $Session,
        },
    );

    return 1;
}

1;
