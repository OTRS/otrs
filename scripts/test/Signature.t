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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get signature object
my $SignatureObject = $Kernel::OM->Get('Kernel::System::Signature');

# add signature
my $SignatureName = $Helper->GetRandomID();
my $SignatureText = "Your OTRS-Team

<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>

--
Super Support Company Inc. - Waterford Business Park
5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA
Email: hot\@florida.com - Web: http://hot.florida.com/
--";

my $SignatureID = $SignatureObject->SignatureAdd(
    Name        => $SignatureName,
    Text        => $SignatureText,
    ContentType => 'text/plain; charset=iso-8859-1',
    Comment     => 'some comment',
    ValidID     => 1,
    UserID      => 1,
);

$Self->True(
    $SignatureID,
    'SignatureAdd()',
);

my %Signature = $SignatureObject->SignatureGet( ID => $SignatureID );

$Self->Is(
    $Signature{Name} || '',
    $SignatureName,
    'SignatureGet() - Name',
);
$Self->True(
    $Signature{Text} eq $SignatureText,
    'SignatureGet() - Signature text',
);
$Self->Is(
    $Signature{ContentType} || '',
    'text/plain; charset=iso-8859-1',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{Comment} || '',
    'some comment',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{ValidID} || '',
    1,
    'SignatureGet() - ValidID',
);

my %SignatureList = $SignatureObject->SignatureList( Valid => 0 );
$Self->True(
    exists $SignatureList{$SignatureID} && $SignatureList{$SignatureID} eq $SignatureName,
    "SignatureList() contains the signature $SignatureName",
);

my $SignatureNameUpdate = $SignatureName . ' - Update';
my $SignatureTextUpdate = $SignatureText . ' - Update';
my $SignatureUpdate     = $SignatureObject->SignatureUpdate(
    ID          => $SignatureID,
    Name        => $SignatureNameUpdate,
    Text        => $SignatureTextUpdate,
    ContentType => 'text/plain; charset=utf-8',
    Comment     => 'some comment 1',
    ValidID     => 2,
    UserID      => 1,
);

$Self->True(
    $SignatureUpdate,
    'SignatureUpdate()',
);

%Signature = $SignatureObject->SignatureGet( ID => $SignatureID );

$Self->Is(
    $Signature{Name} || '',
    $SignatureNameUpdate,
    'SignatureGet() - Name',
);
$Self->True(
    $Signature{Text} eq $SignatureTextUpdate,
    'SignatureGet() - Signature',
);
$Self->Is(
    $Signature{ContentType} || '',
    'text/plain; charset=utf-8',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{Comment} || '',
    'some comment 1',
    'SignatureGet() - Comment',
);
$Self->Is(
    $Signature{ValidID} || '',
    2,
    'SignatureGet() - ValidID',
);

%SignatureList = $SignatureObject->SignatureList( Valid => 1 );
$Self->False(
    exists $SignatureList{$SignatureID},
    "SignatureList() does not contain invalid signature $SignatureNameUpdate",
);

# cleanup is done by RestoreDatabase

1;
