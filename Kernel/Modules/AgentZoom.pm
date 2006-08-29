# --
# Kernel/Modules/AgentZoom.pm - to get a closer view
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentZoom.pm,v 1.85 2006-08-29 17:17:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentZoom;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = '$Revision: 1.85 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # compat link
    my $Redirect = $ENV{REQUEST_URI};
    $Redirect =~ s/AgentZoom/AgentTicketZoom/;
    return $Self->{LayoutObject}->Redirect(OP => $Redirect);
}
# --
1;
