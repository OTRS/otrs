# --
# Kernel/Language/xx_Custom.pm - provides xx custom language translation
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: xx_Custom.pm,v 1.7 2007-10-02 10:45:42 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::xx_Custom;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub Data {
    my ( $Self, %Param ) = @_;

    # $$START$$

    # own translations
    $Self->{Translation}->{'Lock'}   = 'Lala';
    $Self->{Translation}->{'Unlock'} = 'Lulu';

    # or a other syntax would be
    #    $Self->{Translation} = {
    #        %{$Self->{Translation}},
    #        # own translations
    #        Lock => 'Lala',
    #        UnLock => 'Lulu',
    #    };

    # $$STOP$$
}

1;
