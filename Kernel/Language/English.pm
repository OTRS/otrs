# --
# English.pm - provides english languag translation
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: English.pm,v 1.1 2001-12-05 18:46:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::English;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # maybe nothing ... or help texts

    return;
}
# --

1;

