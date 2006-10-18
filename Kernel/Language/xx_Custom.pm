# --
# Kernel/Language/xx_Custom.pm - provides xx custom language translation
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: xx_Custom.pm,v 1.4 2006-10-18 10:31:47 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::xx_Custom;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$

    # own translations
    $Self->{Translation}->{'Lock'} = 'Lala';
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
