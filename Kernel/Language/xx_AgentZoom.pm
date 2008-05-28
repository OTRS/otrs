# --
# Kernel/Language/xx_AgentZoom.pm - provides xx Kernel/Modules/*.pm module language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: xx_AgentZoom.pm,v 1.9 2008-05-28 13:49:49 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::xx_AgentZoom;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$

    $Self->{Translation}->{'Lock'}   = 'Auau';
    $Self->{Translation}->{'Unlock'} = 'Laulau';

    # $$STOP$$
}

1;
