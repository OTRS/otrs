# --
# Kernel/Modules/CustomerZoom.pm - to get a closer view
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerZoom.pm,v 1.34.4.1 2008-07-24 10:09:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::CustomerZoom;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.34.4.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Objects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # compat link
    my $Redirect = $ENV{REQUEST_URI};
    $Redirect =~ s/CustomerZoom/CustomerTicketZoom/;
    return $Self->{LayoutObject}->Redirect(OP => $Redirect);
}

1;
