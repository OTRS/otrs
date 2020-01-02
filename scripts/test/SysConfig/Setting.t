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

my %DefaultSettingAddTemplate = (
    Description    => "Test.",
    Navigation     => "Core::Test",
    IsInvisible    => 0,
    IsReadonly     => 0,
    IsRequired     => 0,
    IsValid        => 1,
    HasConfigLevel => 0,
    XMLFilename    => 'UnitTest.xml',
);

my $SetingsXML = << 'EOF',
<?xml version="1.0" encoding="utf-8"?>
<otrs_config version="2.0" init="Application">
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
    <Setting Name="Test4" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex="\d+">1</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

    # Get SysConfig XML object.
    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');
my $SysConfigObject        = $Kernel::OM->Get('Kernel::System::SysConfig');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    %DefaultSettingAddTemplate,
    XMLInput => $SetingsXML,
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

# Get SysConfig DB object.
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DefaultID0 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[0] },
    Name                     => "Test0$RandomID",
    UserModificationPossible => 0,
    UserModificationActive   => 0,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID0,
    0,
    "DefaultSettingAdd() - Test0",
);

my $DefaultID1 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[1] },
    Name                     => "Test1$RandomID",
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID1,
    0,
    "DefaultSettingAdd() - Test1",
);

my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[1] },
    Name                     => "Test2$RandomID",
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
    IsRequired               => 1,
);
$Self->IsNot(
    $DefaultID2,
    0,
    "DefaultSettingAdd() - Test2",
);

my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    Force     => 1,
    DefaultID => $DefaultID1,
);
$Self->IsNot(
    $ExclusiveLockGUID,
    0,
    "DefaultSettingLock() - for Setting $DefaultID1",
);

my $DefaultID3 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[1] },
    Name                     => "Test3$RandomID",
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
    IsRequired               => 1,
    IsReadonly               => 1,
);
$Self->IsNot(
    $DefaultID3,
    0,
    "DefaultSettingAdd() - Test3",
);

my $DefaultID4 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[2] },
    Name                     => "Test4$RandomID",
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
    IsRequired               => 0,
    IsReadonly               => 0,
);
$Self->IsNot(
    $DefaultID3,
    0,
    "DefaultSettingAdd() - Test4",
);

my $ExclusiveLockGUID3 = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    Force     => 1,
    DefaultID => $DefaultID3,
);
$Self->False(
    $ExclusiveLockGUID3,
    "DefaultSettingLock() - for Setting $DefaultID3",
);

my $ModifiedID1 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID              => $DefaultID1,
    Name                   => "Test1$RandomID",
    IsValid                => 0,
    UserModificationActive => 0,
    EffectiveValue         => 'Test Updated',
    ExclusiveLockGUID      => $ExclusiveLockGUID,
    UserID                 => 1,
);
$Self->IsNot(
    $ModifiedID1,
    undef,
    "ModifiedSettingAdd() for Setting $DefaultID1",
);

my $SuccessUnlock1 = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID1,
);
$Self->IsNot(
    $SuccessUnlock1,
    0,
    "DefaultSettingUnLock() - for Setting $DefaultID1",
);

my $ExclusiveLockGUID2 = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    Force     => 1,
    DefaultID => $DefaultID2,
);
$Self->IsNot(
    $ExclusiveLockGUID2,
    0,
    "DefaultSettingLock() - for Setting $DefaultID2",
);

my %UpdateResult = $SysConfigObject->SettingUpdate(
    Name              => "Test2$RandomID",
    IsValid           => 0,
    EffectiveValue    => 'Test Updated',
    ExclusiveLockGUID => $ExclusiveLockGUID2,
    UserID            => 1,
);

$Self->True(
    $UpdateResult{Success},
    "Setting $DefaultID2 updated.",
);

my %Setting2 = $SysConfigObject->SettingGet(
    Name => "Test2$RandomID",
);
$Self->True(
    $Setting2{IsValid},
    "Make sure that required setting is not disabled."
);

my $Setting2Name = $Setting2{Name};
my $ModifiedID   = $Setting2{ModifiedID};

%Setting2 = $SysConfigObject->SettingGet(
    Name       => "Test2$RandomID",
    ModifiedID => $ModifiedID,
);

$Self->Is(
    $Setting2Name,
    $Setting2{Name},
    "Make sure, that Get with ModifiedID $ModifiedID works also.",
);

$Self->False(
    $Setting2{Deployed},
    "Make sure, this is undef for ModifiedID $ModifiedID.",
);

my $SuccessUnlock2 = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID1,
);
$Self->IsNot(
    $SuccessUnlock2,
    0,
    "DefaultSettingUnLock() - for Setting $DefaultID2",
);

my @Tests = (
    {
        Name    => 'No Params',
        Params  => {},
        Success => 0,
    },
    {
        Name   => 'No Name',
        Params => {
            Default => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Name',
        Params => {
            Name => "Test00$RandomID",
        },
        Success => 0,
    },
    {
        Name   => 'Setting Test0',
        Params => {
            Name => "Test0$RandomID",
        },
        Success       => 1,
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified               => 0,
            CreateBy                 => 1,
            ChangeBy                 => 1,
        },
    },
    {
        Name   => 'Setting Test0 Default',
        Params => {
            Name    => "Test0$RandomID",
            Default => 1,
        },
        Success       => 1,
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            CreateBy                 => 1,
            ChangeBy                 => 1,
        },
    },
    {
        Name   => 'Setting Test1',
        Params => {
            Name => "Test1$RandomID",
        },
        Success       => 1,
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID1,
            ModifiedID               => $ModifiedID1,
            Name                     => "Test1$RandomID",
            UserModificationPossible => 1,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            EffectiveValue           => 'Test Updated',
            IsValid                  => '0',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Setting Test1 Default',
        Params => {
            Name    => "Test1$RandomID",
            Default => 1,
        },
        Success       => 1,
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Setting Test1 Default with Deployed',
        Params => {
            Name     => "Test1$RandomID",
            Deployed => 1,
        },
        Success       => 1,
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            CreateBy                 => '1',
            ChangeBy                 => '1',
            HasConfigLevel           => '0',
            IsInvisible              => '0',
            IsReadonly               => '0',
            IsRequired               => '0',
            IsValid                  => '1',
            UserModificationActive   => '1',
            UserModificationPossible => '1',
            IsModified               => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
);

TEST:
for my $Test (@Tests) {

    my %Setting = $SysConfigObject->SettingGet( %{ $Test->{Params} } );

    if ( $Test->{Name} =~ m{(Deployed)} ) {
        delete $Setting{ChangeTime};
        delete $Setting{CreateTime};
        delete $Setting{SettingUID};
    }

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            \%Setting,
            {},
            "$Test->{Name} SettingGet() - Failure",
        );
        next TEST;
    }

    # Remove not important attributes
    for my $Attribute (
        qw(CreateTime ChangeTime ExclusiveLockGUID ExclusiveLockUserID ExclusiveLockExpiryTime IsDirty SettingUID)
        )
    {
        delete $Setting{$Attribute};
    }

    $Self->IsDeeply(
        \%Setting,
        $Test->{ExpectedValue},
        "$Test->{Name} SettingGet() -",
    );
}

# SettingUpdate() tests
@Tests = (
    {
        Name           => 'No Params',
        Params         => {},
        ExpectedResult => 0,
    },
    {
        Name   => 'No Name',
        Params => {
            DefaultID      => $DefaultID0,
            EffectiveValue => 'Test Update',
            UserID         => 1,
        },
        ExpectedResult => 0,
    },
    {
        Name   => 'No UserID',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test0$RandomID",
            EffectiveValue => 'Test Update',
        },
        ExpectedResult => 0,
    },
    {
        Name   => 'No EffectiveValue and disable',
        Params => {
            DefaultID => $DefaultID0,
            Name      => "Test0$RandomID",
            UserID    => 1,
            IsValid   => 0,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            EffectiveValue           => 'Test',
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            CreateBy                 => 1,
            ChangeBy                 => 1,
            IsValid                  => 0,
            IsModified               => 1,
        },
    },
    {
        Name   => 'Wrong Name',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test00$RandomID",
            EffectiveValue => 'Test Update',
            UserID         => 1,
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Setting Test00$RandomID does not exists!",
        },
    },
    {
        Name   => 'Correct Value Test Update',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test0$RandomID",
            EffectiveValue => 'Test Update',
            UserID         => 1,
            IsValid        => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            EffectiveValue           => 'Test Update',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified               => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    }
                ],
                'Name'       => 'Test0',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test'
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Wrong Value Test Update',
        Params => {
            DefaultID      => $DefaultID4,
            Name           => "Test4$RandomID",
            EffectiveValue => 'Test Update',      # Setting must be a number not a string
            UserID         => 1,
            IsValid        => 1,
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Setting value is not valid!',
        },
    },
    {
        Name   => 'Value Test II Update',
        Params => {
            DefaultID => $DefaultID0,
            Name      => "Test0$RandomID",
            EffectiveValue =>
                '☠☬☹♓♻⚛⛑⛯⛴ <br></html></xml> Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
            UserID  => 1,
            IsValid => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            EffectiveValue =>
                '☠☬☹♓♻⚛⛑⛯⛴ <br></html></xml> Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
            DefaultValue     => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified       => 1,
            CreateBy         => 1,
            ChangeBy         => 1,
            XMLContentParsed => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    }
                ],
                'Name'       => 'Test0',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test'
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Correct Value 0',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test0$RandomID",
            EffectiveValue => 0,
            UserID         => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            EffectiveValue           => 0,
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified               => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test0',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Correct Value UTF8',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test0$RandomID",
            EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ Служба поддержки',
            UserID         => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            EffectiveValue           => 'öäüßüüäöäüß1öää?ÖÄPÜ Служба поддержки',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified               => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test0',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => "Test",
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Correct Value Test',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test0$RandomID",
            EffectiveValue => 'Test',
            UserID         => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified               => 0,                                               # Same EffectiveValue
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test0',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    }
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            }
                        ]
                    }
                ]
            },
        },
    },
    {
        Name   => 'Correct IsValid 0',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test0$RandomID",
            EffectiveValue => 'Test',
            IsValid        => 0,
            UserID         => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            IsValid                  => 0,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified               => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test0',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    }
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Correct IsValid 1',
        Params => {
            DefaultID      => $DefaultID0,
            Name           => "Test0$RandomID",
            EffectiveValue => 'Test',
            IsValid        => 1,
            UserID         => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[0] },
            DefaultID                => $DefaultID0,
            Name                     => "Test0$RandomID",
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[0]->{EffectiveValue},
            IsModified               => 0,
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test0',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Allowed UserModificationPossible 1',
        Params => {
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            EffectiveValue           => 'Test',
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            IsValid                  => 1,
            UserID                   => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 0,                                               # it was already allowed
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },

    # In this test should succeed but the UserModificationPossible should not be changed from the default setting.
    {
        Name   => 'UserModificationPossible 0 Combined with TargetUserID 1',
        Params => {
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            EffectiveValue           => 'Test',
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            UserPreferencesGroup     => '',
            TargetUserID             => 1,
            UserID                   => 1,
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
        },

        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 0,                                               # nothing was changed
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },
    {
        Name   => 'Test 1 - UserModificationPossible 1 update EffectiveValue globaly(not deployed)',
        Params => {
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            EffectiveValue           => 'Global value',
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            UserID                   => 1,
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
        },

        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            EffectiveValue           => 'Global value',
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
        ExpectedUserValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID => $DefaultID1,
            Name      => "Test1$RandomID",

            # EffectiveValue           => 'Global value',  # It's not deployed yet, so it's default EffectiveValue
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 0,
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
        },
    },

    # In this test update EffectiveValue globaly and in next test on user level.
    {
        Name   => 'Test 1 - UserModificationPossible 1 update EffectiveValue globaly',
        Params => {
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            EffectiveValue           => 'Global value',
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            UserID                   => 1,
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
        },

        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID1,
            Name                     => "Test1$RandomID",
            EffectiveValue           => 'Global value',
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
    },

    {
        Name   => 'Test 2 - UserModificationPossible 1 update EffectiveValue globaly(deployed)',
        Params => {
            DefaultID                => $DefaultID2,
            Name                     => "Test2$RandomID",
            EffectiveValue           => 'Global value',
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            UserID                   => 1,
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
        },
        ExpectedResult => {
            Success => 1,
        },
        ExpectedValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID2,
            Name                     => "Test2$RandomID",
            EffectiveValue           => 'Global value',
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue             => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified               => 1,
            IsValid                  => 1,
            CreateBy                 => 1,
            ChangeBy                 => 1,
            IsRequired               => 1,
            XMLContentParsed         => {
                'Description' => [
                    {
                        'Content'      => 'Test.',
                        'Translatable' => '1',
                    },
                ],
                'Name'       => 'Test1',
                'Navigation' => [
                    {
                        'Content' => 'Core::Test',
                    },
                ],
                'Required' => '1',
                'Valid'    => '1',
                'Value'    => [
                    {
                        'Item' => [
                            {
                                'Content'    => 'Test',
                                'ValueRegex' => '.*',
                                'ValueType'  => 'String',
                            },
                        ],
                    },
                ],
            },
        },
        Deploy            => 1,
        ExpectedUserValue => {
            %DefaultSettingAddTemplate,
            %{ $DefaultSettingAddParams[1] },
            DefaultID                => $DefaultID2,
            Name                     => "Test2$RandomID",
            EffectiveValue           => 'Global value',     # It's deployed, user don't have own settings
            UserModificationPossible => 1,
            UserModificationActive   => 1,
            UserPreferencesGroup     => '',
            DefaultValue => $DefaultSettingAddParams[1]->{EffectiveValue},
            IsModified   => 1,
            IsValid      => 1,
            CreateBy     => 1,
            ChangeBy     => 1,
        },
    },
);

my @SettingDirtyNames;

TEST:
for my $Test (@Tests) {

    # Lock setting (so it can be updated).
    my $ExclusiveLockGUID;
    if ( $Test->{Params}->{UserID} && $Test->{Params}->{DefaultID} ) {
        $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            UserID    => $Test->{Params}->{UserID},
            Force     => 1,
            DefaultID => $Test->{Params}->{DefaultID},
        );

        $Self->True(
            $ExclusiveLockGUID,
            "$Test->{Name} SettingUpdate() - $Test->{Params}->{Name} is locked",
        );
    }

    my %Result = $SysConfigObject->SettingUpdate(
        %{ $Test->{Params} },
        ExclusiveLockGUID => $ExclusiveLockGUID,
    );

    if ( !$Test->{ExpectedResult} ) {
        $Self->True(
            !%Result,

            # undef,
            "$Test->{Name} SettingUpdate() - Failure",
        );

        next TEST;
    }

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        "$Test->{Name} SettingUpdate() -",
    );
    next TEST if !$Result{Success};

    my %Setting = $SysConfigObject->SettingGet( Name => $Test->{Params}->{Name} );

    $Self->IsNot(
        $Setting{ModifiedID},
        undef,
        "$Test->{Name} Setting ModifiedID - Should not be undefined",
    );

    # Remove not important attributes
    for my $Attribute (
        qw(ModifiedID CreateTime ChangeTime ExclusiveLockGUID ExclusiveLockUserID ExclusiveLockExpiryTime IsDirty SettingUID)
        )
    {
        delete $Setting{$Attribute};
    }

    $Self->IsDeeply(
        \%Setting,
        $Test->{ExpectedValue},
        "$Test->{Name} SettingGet()",
    );

    # TODO: Inspect why it's not working
    # if ($Test->{Deploy}) {
    #     my $DeploySuccess = $SysConfigObject->ConfigurationDeploy(
    #         UserID              => 1,
    #         Force               => 1,
    #         DirtySettings       => [
    #             $Test->{Params}->{Name},
    #         ],
    #     );

    #     $Self->True(
    #         $DeploySuccess,
    #         "$Test->{Params}->{Name} deployed."
    #     );
    # }
    # if ($Test->{ExpectedUserValue}) {
    #     my %UserSetting = $SysConfigObject->SettingGet(
    #         Name => $Test->{Params}->{Name},
    #         TargetUserID => 1,
    #     );

    #     # remove not important data
    #     for my $Key (qw(ExclusiveLockUserID ExclusiveLockExpiryTime ExclusiveLockGUID ModifiedID
    #         CreateTime ChangeTime IsDirty)) {
    #         delete $UserSetting{$Key};
    #     }

    #     $Self->IsDeeply(
    #         \%UserSetting,
    #         $Test->{ExpectedUserValue},
    #         "$Test->{Name} SettingGet() - user settings",
    #     );

    #     next TEST;
    # }

    # Save the Name to use it in the next test
    push @SettingDirtyNames, $Setting{Name};
}

# Check for dirty settings
my @SettingDirtyList = $SysConfigObject->ConfigurationDirtySettingsList();

for my $IsDirty (@SettingDirtyNames) {
    my $InList = 0;
    if ( grep( {/^$IsDirty/} @SettingDirtyList ) ) {
        $InList = 1;
    }
    $Self->Is(
        $InList,
        1,
        "SettingDirtyListGet() - $IsDirty - $InList",
    );
}

1;
