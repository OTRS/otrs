# --
# Kernel/System/Ticket/Crypt/Plain.pm - article crypt plain backend
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Plain.pm,v 1.1 2002-12-08 20:46:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Crypt::Plain;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
