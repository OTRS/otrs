# --
# German.pm - provides german languag translation
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: German.pm,v 1.1 2001-12-05 18:47:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::German;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # some common words
    $Self->{Lock} = 'Ziehen';
    $Self->{Unlock} = 'Frei geben';
    $Self->{Zoom} = 'Genauer';
    $Self->{History} = 'Geschichte';

    # .... ans so on ...

    return;
}
# --

1;

