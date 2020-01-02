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

use Kernel::System::VariableCheck qw( IsHashRefWithData );

use vars (qw($Self));

use Kernel::Config;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $StorableObject     = $Kernel::OM->Get('Kernel::System::Storable');
my $SysConfigObject    = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject  = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

my $RandomID = $HelperObject->GetRandomID();

$HelperObject->FixedTimeSet();

my $SettingsAdd = sub {
    my %Param = @_;

    for my $Counter ( 1 .. $Param{NumberOfSettings} ) {

        my %DefaultSettingAddTemplate = (
            Description    => "Test.",
            Navigation     => "Core::Test",
            IsInvisible    => 0,
            IsReadonly     => 0,
            IsRequired     => 1,
            IsValid        => $Param{IsValid} // 1,
            HasConfigLevel => 0,
            XMLFilename    => 'UnitTest.xml',
        );

        my $SettingName = "Test$Counter$RandomID";

        my $XMLContentRaw = << "EOF";
<?xml version="1.0" encoding="utf-8" ?>
<otrs_config version="2.0" init="Framework">
    <Setting Name="$SettingName" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

        my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
            %DefaultSettingAddTemplate,
            XMLInput => $XMLContentRaw,
        );

        my $Value = $StorableObject->Clone(
            Data => $DefaultSettingAddParams[0]->{XMLContentParsed}->{Value},
        );

        my $EffectiveValue = $SysConfigObject->SettingEffectiveValueGet(
            Value => $Value,
        );

        my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            Name                     => "Test0$RandomID",
            EffectiveValue           => $EffectiveValue,
            Name                     => $SettingName,
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserID                   => 1,
        );
        $Self->IsNot(
            $DefaultID,
            0,
            "$Param{TestName} DefaultSettingAdd() - $SettingName",
        );
    }
};

my $SettingsDelete = sub {
    my %Param = @_;

    for my $Counter ( 1 .. $Param{NumberOfSettings} ) {

        my $SettingName = "Test$Counter$RandomID";

        my @ModifiedList = $SysConfigDBObject->ModifiedSettingListGet(
            Name => $SettingName,
        );

        for my $ModifiedSetting (@ModifiedList) {
            my $Success = $SysConfigDBObject->ModifiedSettingDelete(
                ModifiedID => $ModifiedSetting->{ModifiedID},
            );

            $Self->True(
                $Success,
                "$Param{TestName} ModifiedSettingDelete() - $SettingName with true",
            );
        }

        my $Success = $SysConfigDBObject->DefaultSettingDelete(
            Name => "$SettingName",
        );

        $Self->True(
            $Success,
            "$Param{TestName} DefaultSettingDelete() - $SettingName with true",
        );
    }
};

my @Tests = (
    {
        Name   => 'Wrong Navigation Group',
        Config => {
            Navigation => $RandomID
        },
        NumberOfSettings => 1,
        Success          => 0,
    },
    {
        Name   => '1 default',
        Config => {
            Navigation => 'Core::Test',
        },
        NumberOfSettings => 1,
        Success          => 1,
    },
    {
        Name   => '1 default disabled',
        Config => {
            Navigation => 'Core::Test',
            IsValid    => 1,
        },
        NumberOfSettings => 1,
        IsValid          => 0,
        ModifySettings   => [1],
        Success          => 1,
    },
    {
        Name   => '3 default',
        Config => {
            Navigation => 'Core::Test',
        },
        NumberOfSettings => 3,
        Success          => 1,
    },
    {
        Name   => '3 default 2 modified',
        Config => {
            Navigation => 'Core::Test',
        },
        ModifySettings   => [ 2, 3 ],
        NumberOfSettings => 3,
        Success          => 1,
    },
);

TEST:
for my $Test (@Tests) {

    $SettingsAdd->(
        NumberOfSettings => $Test->{NumberOfSettings},
        TestName         => $Test->{Name},
    );

    for my $Counter ( @{ $Test->{ModifySettings} } ) {

        my $SettingName = "Test$Counter$RandomID";

        # Get default setting
        my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
            Name => $SettingName,
        );

        $Self->True(
            IsHashRefWithData( \%DefaultSetting ) ? 1 : 0,
            "$Test->{Name} DefaultSettingGet() - $SettingName, succesful",
        );

        # Lock setting (so it can be updated).
        my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $DefaultSetting{DefaultID},
        );

        $Self->True(
            $ExclusiveLockGUID,
            "$Test->{Name} SettingUpdate() - $SettingName is locked",
        );

        my $Success = $SysConfigObject->SettingUpdate(
            Name                   => $SettingName,
            IsValid                => 1,
            UserModificationActive => 0,
            EffectiveValue         => 'Test Update',
            ExclusiveLockGUID      => $ExclusiveLockGUID,
            UserID                 => 1,
        );

        $Self->True(
            $Success,
            "$Test->{Name} SettingUpdate() - $SettingName with true",
        );
    }

    # Main function to test.
    my @List = $SysConfigObject->ConfigurationListGet( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            scalar @List,
            0,
            "$Test->{Name} ConfigurationListGet() returns no settings",
        );
        next TEST;
    }

    $Self->Is(
        scalar @List,
        $Test->{NumberOfSettings},
        "$Test->{Name}  ConfigurationListGet() cardinality",
    );

    my @ExpectedResult;
    for my $Counter ( 1 .. $Test->{NumberOfSettings} ) {

        my $SettingName = "Test$Counter$RandomID";

        # First get default settings
        my %Setting = $SysConfigObject->SettingGet(
            Name    => $SettingName,
            Default => 1,
        );

        $Setting{DefaultValue} = $Setting{EffectiveValue};
        $Setting{IsModified}   = 0;

        push @ExpectedResult, \%Setting;
    }

    for my $Counter ( @{ $Test->{ModifySettings} } ) {

        my $Index = $Counter - 1;

        my $SettingName = "Test$Counter$RandomID";

        # If there was any modified setting, combine with the previous gathered default
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        $Setting{IsModified} = 1;

        %{ $ExpectedResult[$Index] } = ( %{ $ExpectedResult[$Index] }, %Setting );
    }

    $Self->IsDeeply(
        \@List,
        \@ExpectedResult,
        "$Test->{Name} ConfigurationListGet()",
    );
}
continue {
    $SettingsDelete->(
        NumberOfSettings => $Test->{NumberOfSettings},
        TestName         => $Test->{Name},
    );
}

1;
