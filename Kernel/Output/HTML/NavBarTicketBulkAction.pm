# --
# Kernel/Output/HTML/NavBarTicketBulkAction.pm
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NavBarTicketBulkAction.pm,v 1.1 2004-09-20 11:15:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NavBarTicketBulkAction;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my %Return = ();

    if ($Self->{ConfigObject}->Get('FrontendBulkFeature') && $Param{Type} eq 'Ticket') {
        $Return{'0599999'} = {
            Description => 'Bulk Actions on Tickets',
            Name => 'Bulk-Action',
            Image => 'misc.png',
            Link => '',
            LinkOption => 'onclick="BulkSubmit(); return false;"',
        };
    }

    return %Return;
}
# --

1;
