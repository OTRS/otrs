# --
# Kernel/System/Ticket/Compress/Plain.pm - article compress plain backend
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Plain.pm,v 1.1 2002-12-08 20:47:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Compress::Plain;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub CompressInit {
    my $Self = shift;
    my %Param = @_;
}
# --
sub Compress {
    my $Self = shift;
    my $What = shift || ''; 
    return $What;
}
# --
sub Uncompress {
    my $Self = shift;
    my $What = shift || ''; 
    return $What;
}
# --
1;
