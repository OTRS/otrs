# --
# Kernel/Language/en.pm - provides en languag translation
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: en.pm,v 1.8 2004-01-20 00:02:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::en;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();
    
    # $$START$$

    # possible charsets
    $Self->{Charset} = ['us-ascii', 'UTF-8', 'iso-8859-1', 'iso-8859-15'];

    $Self->{DateFormat} = '%M/%D/%Y %T';
    $Self->{DateFormatLong} = '%A %B %D %T %Y';
    $Self->{DateInputFormat} = '%M/%D/%Y';
    $Self->{DateInputFormatLong} = '%M/%D/%Y - %T';

    # maybe nothing ... or help texts

    # $$STOP$$

    $Self->{Translation} = \%Hash;

}
# --

1;
