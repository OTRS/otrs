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
my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');
my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomNumber();
my $UserID   = 1;

my @Tests = (
    {
        Name => 'Test1',
        Add  => {
            Config => {
                Name        => 'AnyName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'something for label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 1,
            UserID     => $UserID,
        },
        UpdateDBIncorrectYAML => "-\nDefaultValue: ''\nPossibleValues: ~\n",
        UpdateDBCorrectYAML   => "---\nDefaultValue: ''\nPossibleValues: ~\n",
        ReferenceUpdate       => {
            Config => {
                DefaultValue   => '',
                PossibleValues => undef,
            },
        }
    },
);

TEST:
for my $Test (@Tests) {

    my $FieldName = $Test->{Name} . $RandomID;

    # add config
    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name => $FieldName,
        %{ $Test->{Add} },
    );

    $Self->True(
        $DynamicFieldID,
        "$Test->{Name} - DynamicFieldAdd()",
    );

    # get config
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet() Name",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - DynamicFieldGet() - Config",
    );

    # Update the dynamic field directly in the database, because at the moment we have no idea, in
    #   which case the YAML strings which make problems can be insert with the normal backend functionality.
    return if !$DBObject->Do(
        SQL  => 'UPDATE dynamic_field SET config = ? WHERE id = ?',
        Bind => [
            \$Test->{UpdateDBIncorrectYAML},
            \$DynamicFieldID,
        ],
    );

    $CacheObject->CleanUp(
        Type => 'DynamicField',
    );

    $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # Verify that config is empty.
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet()",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        {},
        "$Test->{Name} - DynamicFieldGet() - Config (after incorrect YAML)",
    );

    return if !$DBObject->Do(
        SQL  => 'UPDATE dynamic_field SET config = ? WHERE id = ?',
        Bind => [
            \$Test->{UpdateDBCorrectYAML},
            \$DynamicFieldID,
        ],
    );

    # After this update we need no cache cleanup, because the
    #   last DynamicFieldGet should not cache something.
    $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # Verify that config is empty.
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet()",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        $Test->{ReferenceUpdate}->{Config},
        "$Test->{Name} - DynamicFieldGet() - Config (after correct YAML, nothing cached)",
    );
}

# cleanup is done by RestoreDatabase

1;
