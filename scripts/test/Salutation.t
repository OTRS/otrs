# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $SalutationObject = $Kernel::OM->Get('Kernel::System::Salutation');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# add salutation
my $SalutationName = 'salutation' . $Helper->GetRandomID();
my $Salutation     = "Dear <OTRS_CUSTOMER_REALNAME>,

Thank you for your request. Your email address in our database
is \"<OTRS_CUSTOMER_DATA_UserEmail>\".
";

my $SalutationID = $SalutationObject->SalutationAdd(
    Name        => $SalutationName,
    Text        => $Salutation,
    ContentType => 'text/plain; charset=iso-8859-1',
    Comment     => 'some comment',
    ValidID     => 1,
    UserID      => 1,
);

$Self->True(
    $SalutationID,
    'SalutationAdd()',
);

my %Salutation = $SalutationObject->SalutationGet( ID => $SalutationID );

$Self->Is(
    $Salutation{Name} || '',
    $SalutationName,
    'SalutationGet() - Name',
);
$Self->True(
    $Salutation{Text} eq $Salutation,
    'SalutationGet() - Salutation',
);
$Self->Is(
    $Salutation{ContentType} || '',
    'text/plain; charset=iso-8859-1',
    'SalutationGet() - Comment',
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

my %SalutationList = $SalutationObject->SalutationList( Valid => 0 );
$Self->True(
    exists $SalutationList{$SalutationID} && $SalutationList{$SalutationID} eq $SalutationName,
    'SalutationList() contains the salutation ' . $SalutationName . ' with ID ' . $SalutationID,
);

%SalutationList = $SalutationObject->SalutationList( Valid => 1 );
$Self->True(
    exists $SalutationList{$SalutationID} && $SalutationList{$SalutationID} eq $SalutationName,
    'SalutationList() contains the salutation ' . $SalutationName . ' with ID ' . $SalutationID,
);

my $SalutationNameUpdate = $SalutationName . '1';
my $SalutationUpdate     = $SalutationObject->SalutationUpdate(
    ID          => $SalutationID,
    Name        => $SalutationNameUpdate,
    Text        => $Salutation . '1',
    ContentType => 'text/plain; charset=utf-8',
    Comment     => 'some comment 1',
    ValidID     => 2,
    UserID      => 1,
);

$Self->True(
    $SalutationUpdate,
    'SalutationUpdate()',
);

%Salutation = $SalutationObject->SalutationGet( ID => $SalutationID );

$Self->Is(
    $Salutation{Name} || '',
    $SalutationNameUpdate,
    'SalutationGet() - Name',
);
$Self->True(
    $Salutation{Text} eq $Salutation . '1',
    'SalutationGet() - Salutation',
);
$Self->Is(
    $Salutation{ContentType} || '',
    'text/plain; charset=utf-8',
    'SalutationGet() - Comment',
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

%SalutationList = $SalutationObject->SalutationList( Valid => 0 );
$Self->True(
    exists $SalutationList{$SalutationID} && $SalutationList{$SalutationID} eq $SalutationNameUpdate,
    'SalutationList() contains the salutation ' . $SalutationNameUpdate . ' with ID ' . $SalutationID,
);

%SalutationList = $SalutationObject->SalutationList( Valid => 1 );
$Self->False(
    exists $SalutationList{$SalutationID},
    'SalutationList() does not contain the salutation ' . $SalutationNameUpdate . ' with ID ' . $SalutationID,
);

# cleanup is done by RestoreDatabase

1;
