# --
# Kernel/Output/HTML/HeaderMetaTicketSearch.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: HeaderMetaTicketSearch.pm,v 1.1 2008-07-03 18:21:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::HeaderMetaTicketSearch;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject TimeObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Session = '';
    if ( !$Self->{LayoutObject}->{SessionIDCookie} ) {
        $Session = '&' . $Self->{LayoutObject}->{SessionName} . '='
            . $Self->{LayoutObject}->{SessionID};
    }

    $Self->{LayoutObject}->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => '$Quote{"$Config{"ProductName"}"} ($Quote{"$Config{"Ticket::Hook"}"})',
            Href  => '$Env{"Baselink"}Action=' . $Param{Config}->{Action}
                . '&Subaction=OpenSearchDescription' . $Session,
        },
    );
    return 1;
}

1;
