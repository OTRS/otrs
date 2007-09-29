# --
# Kernel/Language/xx_AgentZoom.pm - provides xx Kernel/Modules/*.pm module language translation
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: xx_AgentZoom.pm,v 1.6 2007-09-29 10:47:58 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::xx_AgentZoom;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub Data {
    my $Self  = shift;
    my %Param = @_;

    # $$START$$

    $Self->{Translation}->{'Lock'}   = 'Auau';
    $Self->{Translation}->{'Unlock'} = 'Laulau';

    # $$STOP$$
}

1;
