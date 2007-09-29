# --
# Salutation.t - Salutation tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Salutation.t,v 1.2 2007-09-29 11:09:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Salutation;

$Self->{SalutationObject} = Kernel::System::Salutation->new(%{$Self});

# add salutation
my $SalutationNameRand0 = 'example-salutation'.int(rand(1000000));
my $Salutation = "Dear <OTRS_CUSTOMER_Realname>,

Thank you for your request. Your email address in our database
is \"<OTRS_CUSTOMER_DATA_UserEmail>\".
";

my $SalutationID = $Self->{SalutationObject}->SalutationAdd(
    Name => $SalutationNameRand0,
    Text => $Salutation,
    Comment => 'some comment',
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $SalutationID,
    'SalutationAdd()',
);

my %Salutation = $Self->{SalutationObject}->SalutationGet(ID => $SalutationID);

$Self->Is(
    $Salutation{Name} || '',
    $SalutationNameRand0,
    'SalutationGet() - Name',
);
$Self->True(
    $Salutation{Text} eq $Salutation,
    'SalutationGet() - Salutation',
);
$Self->Is(
    $Salutation{Comment} || '',
    'some comment',
    'SalutationGet() - Comment',
);
$Self->Is(
    $Salutation{ValidID} || '',
    1,
    'SalutationGet() - ValidID',
);

my %SalutationList = $Self->{SalutationObject}->SalutationList(
    Valid => 0,
);
my $Hit = 0;
for (sort keys %SalutationList) {
    if ($_ eq $SalutationID) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'SalutationList()',
);

my $SalutationUpdate = $Self->{SalutationObject}->SalutationUpdate(
    ID => $SalutationID,
    Name => $SalutationNameRand0.'1',
    Text => $Salutation.'1',
    Comment => 'some comment 1',
    ValidID => 2,
    UserID => 1,
);

$Self->True(
    $SalutationUpdate,
    'SalutationUpdate()',
);

%Salutation = $Self->{SalutationObject}->SalutationGet(ID => $SalutationID);

$Self->Is(
    $Salutation{Name} || '',
    $SalutationNameRand0.'1',
    'SalutationGet() - Name',
);
$Self->True(
    $Salutation{Text} eq $Salutation.'1',
    'SalutationGet() - Salutation',
);
$Self->Is(
    $Salutation{Comment} || '',
    'some comment 1',
    'SalutationGet() - Comment',
);
$Self->Is(
    $Salutation{ValidID} || '',
    2,
    'SalutationGet() - ValidID',
);

1;
