# --
# Kernel/System/Ticket/Crypt/Plain.pm - article crypt plain backend
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Plain.pm,v 1.2 2003-01-03 00:38:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Crypt::Plain;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub CryptInit {
    my $Self = shift;
    my %Param = @_;
}
# --
sub Encrypt {
    my $Self = shift;
    my $What = shift || ''; 
    return $What;
}
# --
sub Decrypt {
    my $Self = shift;
    my $What = shift || ''; 
    return $What;
}
# --
1;
