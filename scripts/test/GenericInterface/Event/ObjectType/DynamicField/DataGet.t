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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Rand = $Helper->GetRandomNumber();

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name   => 'TestDynamicField' . $Rand,
    Config => {
        Name        => 'AnyName',
        Description => 'Description for Dynamic Field.',
    },
    Label      => 'something for label',
    FieldOrder => 10000,
    FieldType  => 'Text',
    ObjectType => 'Article',
    ValidID    => 1,
    UserID     => 1,
);
$Self->True(
    $DynamicFieldID,
    'DynamicFieldAdd()',
);

my %ExpectedDataRaw = %{ $DynamicFieldObject->DynamicFieldGet( ID => $DynamicFieldID ) };

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                NewData => {
                    ID => $DynamicFieldID,
                },
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::DynamicField');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.
1;
