# --
# Kernel/Language/xx_Custom.pm - provides xx custom language translation
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: xx_Custom.pm,v 1.2 2004-11-04 11:05:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::xx_Custom;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
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
# --
1;
