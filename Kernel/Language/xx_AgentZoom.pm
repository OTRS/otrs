# --
# Kernel/Language/xx_Custom.pm - provides xx Kernel/Modules/*.pm module language translation
# Copyright (C) 2001-2004 Martin Edenhofer <martin at otrs.org>
# --
# $Id: xx_AgentZoom.pm,v 1.1 2004-06-04 08:50:41 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::xx_AgentZoom;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$

    $Self->{Translation}->{'Lock'} = 'Auau';
    $Self->{Translation}->{'Unlock'} = 'Laulau';

    # $$STOP$$
}
# --
1;
