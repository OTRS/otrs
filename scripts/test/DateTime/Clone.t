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

my $DateTimeObject       = $Kernel::OM->Create('Kernel::System::DateTime');
my $ClonedDateTimeObject = $DateTimeObject->Clone();

$Self->IsDeeply(
    $ClonedDateTimeObject->Get(),
    $DateTimeObject->Get(),
    'Values of cloned DateTime object must match those of original object.'
);

# Change cloned DateTime object, must not influence original object
$ClonedDateTimeObject->Add( Days => 10 );
$Self->IsNotDeeply(
    $ClonedDateTimeObject->Get(),
    $DateTimeObject->Get(),
    'Changed values of cloned DateTime object must not influence those of original object.'
);

1;
