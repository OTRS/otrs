# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Output = qx{"$^X" bin/otrs.Console.pl Maint::Ticket::PendingCheck --quiet};

$Self->False( scalar( $Output =~ /\S/ ), "No output with --quiet" );

1;
