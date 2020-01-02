# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Prevent used once warning.
use Kernel::System::ObjectManager;

# Use AutoIncrement backend to have access to the base class functions.
my $TicketNumberBaseObject = $Kernel::OM->Get('Kernel::System::Ticket::Number::AutoIncrement');

# _GetUID tests
my %UIDs;
for my $Count ( 1 .. 10_000 ) {
    my $UID = $TicketNumberBaseObject->_GetUID();

    if ( $UIDs{$UID} ) {
        $Self->Is(
            $UIDs{$UID},
            undef,
            "_GetUID() $Count - $UID does not exist",
        );
    }
    $UIDs{$UID}++;
}
$Self->Is(
    scalar keys %UIDs,
    10_000,
    "_GetUID() generated all UIDs."
);

1;
