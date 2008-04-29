# --
# Kernel/Language/xx_Custom.pm - provides xx custom language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: xx_Custom.pm,v 1.8 2008-04-29 13:21:32 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::xx_Custom;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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
