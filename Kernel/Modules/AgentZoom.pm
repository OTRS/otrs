# --
# Kernel/Modules/AgentZoom.pm - to get a closer view
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentZoom.pm,v 1.87.2.1 2008-07-24 10:09:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentZoom;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = '$Revision: 1.87.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

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
    $Redirect =~ s/AgentZoom/AgentTicketZoom/;
    return $Self->{LayoutObject}->Redirect(OP => $Redirect);
}

1;
