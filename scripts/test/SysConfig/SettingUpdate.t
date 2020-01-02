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

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# disable check email address
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $SetingsXML = << 'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otrs_config version="2.0" init="Framework">
    <Setting Name="Test0" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput    => $SetingsXML,
    XMLFilename => 'UnitTest.xml',
);

for my $Setting (@DefaultSettingAddParams) {

    my $Value = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
        Data => $Setting->{XMLContentParsed}->{Value},
    );

    $Setting->{EffectiveValue} = $SysConfigObject->SettingEffectiveValueGet(
        Value => $Value,
    );
}

my $RandomID = $HelperObject->GetRandomID();

my $SettingName = 'ProductName ' . $RandomID;

my %DefaultSettingAddTemplate = (
    Name           => $SettingName,
    Description    => "Test.",
    Navigation     => "Core::Test",
    IsInvisible    => 0,
    IsReadonly     => 0,
    IsRequired     => 1,
    IsValid        => 1,
    HasConfigLevel => 0,
    XMLFilename    => 'UnitTest.xml',
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DefaultSettingID = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
    %{ $DefaultSettingAddParams[0] },
);
$Self->IsNot(
    $DefaultSettingID,
    0,
    "DefaultSettingAdd() - Test0",
);

my %ModifiedSettingAddTemplate = (
    %DefaultSettingAddTemplate,
    DefaultID => $DefaultSettingID,
);

my @Tests = (
    {
        Name           => 'Correct IsValid 0',
        IsValid        => 0,
        ExpectedResult => {
            Success => 1,
        },
    },
    {
        Name           => 'Correct IsValid 1',
        IsValid        => 1,
        ExpectedResult => {
            Success => 1,
        },
    },
);

TEST:
for my $Test (@Tests) {

    # Add global entry
    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        DefaultID => $DefaultSettingID,
        UserID    => 1,
        Force     => 1,
    );
    my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
        DefaultID => $DefaultSettingID,
    );
    $Self->True(
        $IsLock,
        'Default setting must be lock.',
    );

    my $ModifiedSettingID = $SysConfigDBObject->ModifiedSettingAdd(
        %ModifiedSettingAddTemplate,
        %{ $DefaultSettingAddParams[1] },
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    my $Result = $ModifiedSettingID ? 1 : 0;
    $Self->True(
        $Result,
        'ModifiedSettingAdd() - Testing global.',
    );

    $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $DefaultSettingID,
    );

    $Self->True(
        $ExclusiveLockGUID,
        "$Test->{Name} SettingUpdate() - $SettingName is locked",
    );

    my %Result = $SysConfigObject->SettingUpdate(
        %ModifiedSettingAddTemplate,
        %{ $DefaultSettingAddParams[1] },
        ExclusiveLockGUID => $ExclusiveLockGUID,
        IsValid           => $Test->{IsValid},
        UserID            => 1,
    );

    if ( !$Test->{ExpectedResult} ) {
        $Self->True(
            !%Result,
            "$Test->{Name} SettingUpdate() - Failure",
        );

        next TEST;
    }

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        "$Test->{Name} SettingUpdate() -",
    );

    # Delete global modified setting
    $Result = $SysConfigDBObject->ModifiedSettingDelete( ModifiedID => $ModifiedSettingID );
    $Self->True(
        $Result,
        'Global - ModifiedSettingDelete() must succeed.',
    );

}

1;
