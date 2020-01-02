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

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

#
# Prepare valid config XML and Perl
#
my $ValidSettingXML = <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otrs_config version="2.0" init="Framework">
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test setting 1</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>
    <Setting Name="Test3" Required="1" Valid="1">
        <Description Translatable="1">Test 3.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="Directory">/etc/ssl/certs</Item>
        </Value>
    </Setting>
    <Setting Name="Test4" Required="1" Valid="1">
        <Description Translatable="1">Test 4.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="Textarea">123\n456</Item>
        </Value>
    </Setting>
    <Setting Name="Test5" Required="1" Valid="1">
        <Description Translatable="1">Test 5.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="Checkbox">1</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput => $ValidSettingXML,
);

my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$DateTimeObject->Add( Minutes => 30 );

#
# Test configuration
#
my $SettingName  = 'ProductName ' . $HelperObject->GetRandomNumber();
my $RandomNumber = $HelperObject->GetRandomNumber();

my @Tests = (
    {
        Description => 'Full succeeding test cycle 1',
        Config      => {
            DefaultSettingAdd => {
                Data => {
                    Name                     => $SettingName,
                    Description              => 'Defines the name of the application ...',
                    Navigation               => 'ASimple::Path::Structure',
                    IsInvisible              => 1,
                    IsReadonly               => 0,
                    IsRequired               => 1,
                    IsValid                  => 1,
                    HasConfigLevel           => 200,
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    UserPreferencesGroup     => 'Test',
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'Test setting 1',
                    UserModificationActive   => 0,
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingUpdate => {
                Data => {
                    Name                     => $SettingName,
                    Description              => 'Defines the name of the application ... (default setting update)',
                    Navigation               => 'ASimple::Path::Structure::DefaultSettingUpdate',
                    IsInvisible              => 0,
                    IsReadonly               => 1,
                    IsRequired               => 0,
                    IsValid                  => 1,
                    HasConfigLevel           => 201,
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    UserPreferencesGroup     => 'TestUpdte',
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => '/usr/bin/gpg',
                    ExclusiveLockGUID        => 0,
                    ExclusiveLockUserID      => 1,
                    ExclusiveLockExpiryTime  => $DateTimeObject->ToString(),
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingVersionAdd => {
                Data => {
                    Name           => 'ProductName (default setting version add) ' . $HelperObject->GetRandomNumber(),
                    Description    => 'Defines the name of the application ... (default setting version add)',
                    Navigation     => 'ASimple::Path::Structure::DefaultSettingVersionAdd',
                    IsInvisible    => 1,
                    IsReadonly     => 0,
                    IsRequired     => 1,
                    IsValid        => 1,
                    HasConfigLevel => 202,
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    UserPreferencesGroup     => 'Test',
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'usr/sbin/gpg',
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingAdd => {
                Data => {
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    EffectiveValue => '/usr/pgp',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 0,
                    EffectiveValue => '/usr/pgp2',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Trying to add default setting with missing parameters',
        Config      => {
            DefaultSettingAdd => {
                Data           => {},
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to add default setting with invalid parameters',
        Config      => {
            DefaultSettingAdd => {
                Data => {
                    Name           => 'ProductName ' . $HelperObject->GetRandomNumber(),
                    Description    => 'Defines the name of the application ...',
                    Navigation     => 'ASimple::Path::Structure',
                    IsInvisible    => 1,
                    IsReadonly     => 0,
                    IsRequired     => 1,
                    IsValid        => 1,
                    HasConfigLevel => 'test',                                              # invalid, must be integer
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'Test setting 1',
                    UserID                   => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to update default setting with missing parameters',
        Config      => {
            DefaultSettingUpdate => {
                Data           => {},
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to update default setting with invalid parameters',
        Config      => {

            # add must succeed, it is needed for the failing update test below
            DefaultSettingAdd => {
                Data => {
                    Name                     => 'ProductName ' . $HelperObject->GetRandomNumber(),
                    Description              => 'Defines the name of the application ...',
                    Navigation               => 'ASimple::Path::Structure',
                    IsInvisible              => 1,
                    IsReadonly               => 0,
                    IsRequired               => 1,
                    IsValid                  => 1,
                    HasConfigLevel           => 200,
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'Test setting 1',
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingUpdate => {
                Data => {

                    # DefaultID                      => $DefaultSettingID, # will be retrieved from DefaultSettingAdd()
                    Name        => 'ProductName (default setting update) ' . $HelperObject->GetRandomNumber(),
                    Description => 'Defines the name of the application ... (default setting update)',
                    Navigation  => 'ASimple::Path::Structure::DefaultSettingUpdate',
                    IsInvisible => 0,
                    IsReadonly  => 1,
                    IsRequired  => 0,
                    IsValid     => 1,
                    HasConfigLevel           => 'test',                                       # invalid, must be integer
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed        => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename             => 'UnitTest.xml',
                    EffectiveValue          => '/usr/bin/gpg',
                    ExclusiveLockGUID       => 0,
                    ExclusiveLockUserID     => 1,
                    ExclusiveLockExpiryTime => $DateTimeObject->ToString(),
                    UserID                  => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to add default setting version with missing parameters',
        Config      => {
            DefaultSettingVersionAdd => {
                Data           => {},
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to add default setting version with invalid parameters',
        Config      => {

            # add must succeed, it is needed for the failing default setting version add below
            DefaultSettingAdd => {
                Data => {
                    Name                     => 'ProductName ' . $HelperObject->GetRandomNumber(),
                    Description              => 'Defines the name of the application ...',
                    Navigation               => 'ASimple::Path::Structure',
                    IsInvisible              => 1,
                    IsReadonly               => 0,
                    IsRequired               => 1,
                    IsValid                  => 1,
                    HasConfigLevel           => 200,
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'Test setting 1',
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingVersionAdd => {
                Data => {

                    # DefaultID             => 456, # will be retrieved from DefaultSettingAdd()
                    Name        => 'ProductName (default setting version add) ' . $HelperObject->GetRandomNumber(),
                    Description => 'Defines the name of the application ... (default setting version add)',
                    Navigation  => 'ASimple::Path::Structure::DefaultSettingVersionAdd',
                    IsInvisible => 1,
                    IsReadonly  => 0,
                    IsRequired  => 1,
                    IsValid     => 1,
                    HasConfigLevel           => 'test',                                       # invalid, must be integer
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename      => 'UnitTest.xml',
                    EffectiveValue   => 'usr/sbin/gpg',
                    UserID           => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to add modified setting with missing parameters',
        Config      => {
            ModifiedSettingAdd => {
                Data           => {},
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to update modified setting with missing parameters',
        Config      => {
            ModifiedSettingUpdate => {
                Data           => {},
                ExpectedResult => 0,
            },
        },
    },

    {
        Description => 'Trying to add default setting with not defined HasConfigLevel',
        Config      => {

            # add must succeed, it is needed for the failing default setting version add below
            DefaultSettingAdd => {
                Data => {
                    Name        => 'ProductName ' . $HelperObject->GetRandomNumber(),
                    Description => 'Defines the name of the application ...',
                    Navigation  => 'ASimple::Path::Structure',
                    IsInvisible => 1,
                    IsReadonly  => 0,
                    IsRequired  => 1,
                    IsValid     => 1,

                    # HasConfigLevel        => 0, # should not be a problem have not a config level
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'Test setting 1',
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingVersionAdd => {
                Data => {

                    # DefaultID             => 456, # will be retrieved from DefaultSettingAdd()
                    Name        => 'ProductName (default setting version add) ' . $HelperObject->GetRandomNumber(),
                    Description => 'Defines the name of the application ... (default setting version add)',
                    Navigation  => 'ASimple::Path::Structure::DefaultSettingVersionAdd',
                    IsInvisible => 1,
                    IsReadonly  => 0,
                    IsRequired  => 1,
                    IsValid     => 1,
                    HasConfigLevel           => 0,    # it should be 0 since was not defined in beginning
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw    => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename      => 'UnitTest.xml',
                    EffectiveValue   => 'usr/sbin/gpg',
                    UserID           => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Trying to add default setting with HasConfigLevel on 0',
        Config      => {

            # add must succeed, it is needed for the failing default setting version add below
            DefaultSettingAdd => {
                Data => {
                    Name        => 'ProductName Testing' . $RandomNumber,
                    Description => 'Defines the name of the application ...',
                    Navigation  => 'ASimple::Path::Structure',
                    IsInvisible => 1,
                    IsReadonly  => 0,
                    IsRequired  => 1,
                    IsValid     => 1,
                    HasConfigLevel           => 0,    # should not be a problem have not a config level
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw    => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename      => 'UnitTest.xml',
                    EffectiveValue   => 'Test setting 1',
                    UserID           => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingVersionAdd => {
                Data => {

                    # DefaultID             => 456, # will be retrieved from DefaultSettingAdd()
                    Name        => 'ProductName Testing' . $RandomNumber,
                    Description => 'Defines the name of the application ... (default setting version add)',
                    Navigation  => 'ASimple::Path::Structure::DefaultSettingVersionAdd',
                    IsInvisible => 1,
                    IsReadonly  => 0,
                    IsRequired  => 1,
                    IsValid     => 1,
                    HasConfigLevel           => 0,    # it should be 0 since was not defined in beginning
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw    => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename      => 'UnitTest.xml',
                    EffectiveValue   => 'usr/sbin/gpg',
                    UserID           => 1,
                },
                ExpectedResult => 1,
            },

            DefaultSettingUpdate => {
                Data => {
                    Name        => 'ProductName Testing' . $RandomNumber,
                    Description => 'Defines the name of the application ... (default setting update)',
                    Navigation  => 'ASimple::Path::Structure::DefaultSettingUpdate',
                    IsInvisible => 0,
                    IsReadonly  => 1,
                    IsRequired  => 0,
                    IsValid     => 1,

                    # HasConfigLevel          => 0, # should not be a problem have not a config level
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => '/usr/bin/gpg/mod',
                    ExclusiveLockGUID        => 0,
                    ExclusiveLockUserID      => 1,
                    ExclusiveLockExpiryTime  => $DateTimeObject->ToString(),
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
        },
    },

    {
        Description => 'Trying to add default setting with not defined XMLFilename',
        Config      => {
            DefaultSettingAdd => {
                Data => {
                    Name        => 'ProductName ' . $HelperObject->GetRandomNumber(),
                    Description => 'Defines the name of the application ...',
                    Navigation  => 'ASimple::Path::Structure',
                    IsInvisible => 1,
                    IsReadonly  => 0,
                    IsRequired  => 1,
                    IsValid     => 1,

                    HasConfigLevel           => 0,
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},

                    # XMLFilename           => 'UnitTest.xml',       # XMLFilename is mandatory
                    EffectiveValue => 'Test setting 1',
                    UserID         => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to add default setting version with not defined XMLFilename',
        Config      => {

            # add must succeed, it is needed for the failing default setting version add below
            DefaultSettingAdd => {
                Data => {
                    Name                     => 'ProductName ' . $HelperObject->GetRandomNumber(),
                    Description              => 'Defines the name of the application ...',
                    Navigation               => 'ASimple::Path::Structure',
                    IsInvisible              => 1,
                    IsReadonly               => 0,
                    IsRequired               => 1,
                    IsValid                  => 1,
                    HasConfigLevel           => 0,
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'Test setting 1',
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingVersionAdd => {
                Data => {

                    # DefaultID             => 456, # will be retrieved from DefaultSettingAdd()
                    Name           => 'ProductName (default setting version add) ' . $HelperObject->GetRandomNumber(),
                    Description    => 'Defines the name of the application ... (default setting version add)',
                    Navigation     => 'ASimple::Path::Structure::DefaultSettingVersionAdd',
                    IsInvisible    => 1,
                    IsReadonly     => 0,
                    IsRequired     => 1,
                    IsValid        => 1,
                    HasConfigLevel => 0,
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},

                    # XMLFilename           => 'UnitTest.xml',      # XMLFilename is mandatory
                    EffectiveValue => 'usr/sbin/gpg',
                    UserID         => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Trying to update default setting with not defined XMLFilename',
        Config      => {

            # add must succeed, it is needed for the failing default setting update below
            DefaultSettingAdd => {
                Data => {
                    Name                     => 'ProductName Testing' . $RandomNumber,
                    Description              => 'Defines the name of the application ...',
                    Navigation               => 'ASimple::Path::Structure',
                    IsInvisible              => 1,
                    IsReadonly               => 0,
                    IsRequired               => 1,
                    IsValid                  => 1,
                    HasConfigLevel           => 0,
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'Test setting 1',
                    UserID                   => 1,
                },
                ExpectedResult => 1,
            },
            DefaultSettingUpdate => {
                Data => {
                    Name                     => 'ProductName Testing' . $RandomNumber,
                    Description              => 'Defines the name of the application ... (default setting update)',
                    Navigation               => 'ASimple::Path::Structure::DefaultSettingUpdate',
                    IsInvisible              => 0,
                    IsReadonly               => 1,
                    IsRequired               => 0,
                    IsValid                  => 1,
                    HasConfigLevel           => 0,
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
                    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},

                    # XMLFilename           => 'UnitTest.xml',      # XMLFilename is mandatory
                    EffectiveValue          => '/usr/bin/gpg/mod',
                    ExclusiveLockGUID       => 0,
                    ExclusiveLockUserID     => 1,
                    ExclusiveLockExpiryTime => $DateTimeObject->ToString(),
                    UserID                  => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

for my $Test (@Tests) {

    #
    # Test for DefaultSettingAdd()
    #
    my $DefaultSettingID;
    if ( exists $Test->{Config}->{DefaultSettingAdd} ) {

        $DefaultSettingID = $SysConfigDBObject->DefaultSettingAdd(
            %{ $Test->{Config}->{DefaultSettingAdd}->{Data} },
        );

        my $Result = $DefaultSettingID ? 1 : 0;
        $Self->Is(
            $Result,
            $Test->{Config}->{DefaultSettingAdd}->{ExpectedResult},
            $Test->{Description}
                . ': DefaultSettingAdd() must '
                . ( $Test->{Config}->{DefaultSettingAdd}->{ExpectedResult} ? 'succeed' : 'fail' )
                . '.',
        );

        if ( $Test->{Config}->{DefaultSettingAdd}->{ExpectedResult} ) {

            #
            # Additional DefaultSettingAdd() with the same data must fail
            #
            my $DuplicateDefaultSettingID = $SysConfigDBObject->DefaultSettingAdd(
                %{ $Test->{Config}->{DefaultSettingAdd}->{Data} }
            );

            my $Result = $DuplicateDefaultSettingID ? 1 : 0;
            $Self->False(
                $Result,
                $Test->{Description}
                    . ': Additional DefaultSettingAdd() with same data must fail.',
            );

            #
            # Test for DefaultSettingGet()
            #
            my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet( DefaultID => $DefaultSettingID );
            my %DefaultSettingToCompare;
            for my $Key ( sort keys %{ $Test->{Config}->{DefaultSettingAdd}->{Data} } ) {
                $DefaultSettingToCompare{$Key} = $DefaultSetting{$Key};

                # Add UserID as this not reported by DefaultSettingGet()
                if ( $Key eq 'UserID' || $Key eq 'ExclusiveLockUserID' || $Key eq 'ExclusiveLockExpiryTime' ) {
                    $DefaultSettingToCompare{$Key} = $Test->{Config}->{DefaultSettingAdd}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%DefaultSettingToCompare,
                $Test->{Config}->{DefaultSettingAdd}->{Data},
                $Test->{Description}
                    . ': DefaultSettingGet() must return stored data.'
            );

            #
            # Test for DefaultSettingListGet()
            #
            my @DefaultSettingList = $SysConfigDBObject->DefaultSettingListGet(
                IsInvisible              => $Test->{Config}->{DefaultSettingAdd}->{Data}->{IsInvisible},
                IsReadonly               => $Test->{Config}->{DefaultSettingAdd}->{Data}->{IsReadonly},
                IsRequired               => $Test->{Config}->{DefaultSettingAdd}->{Data}->{IsRequired},
                IsValid                  => $Test->{Config}->{DefaultSettingAdd}->{Data}->{IsValid},
                HasConfigLevel           => $Test->{Config}->{DefaultSettingAdd}->{Data}->{HasConfigLevel},
                UserModificationPossible => $Test->{Config}->{DefaultSettingAdd}->{Data}->{UserModificationPossible},
                UserModificationActive   => $Test->{Config}->{DefaultSettingAdd}->{Data}->{UserModificationActive},
            );

            $Self->True(
                IsArrayRefWithData( \@DefaultSettingList ),
                $Test->{Description} . ': DefaultSettingListGet() must return at least one setting.',
            );

            my @DefaultSettings = grep { $_->{DefaultID} == $DefaultSettingID } @DefaultSettingList;
            $Self->True(
                @DefaultSettings == 1,
                $Test->{Description} . ': DefaultSettingListGet() must return exactly one matching setting.',
            );

            my $DefaultSetting = shift @DefaultSettings;
            %DefaultSettingToCompare = ();
            for my $Key ( sort keys %{ $Test->{Config}->{DefaultSettingAdd}->{Data} } ) {
                $DefaultSettingToCompare{$Key} = $DefaultSetting{$Key};

                # Add UserID as this not reported by DefaultSettingListGet()
                if ( $Key eq 'UserID' ) {
                    $DefaultSettingToCompare{$Key} = $Test->{Config}->{DefaultSettingAdd}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%DefaultSettingToCompare,
                $Test->{Config}->{DefaultSettingAdd}->{Data},
                $Test->{Description}
                    . ': DefaultSettingListGet() must return stored data.'
            );
        }
    }

    #
    # Test for DefaultSettingVersionAdd()
    #
    my $DefaultSettingVersionID;
    if ( exists $Test->{Config}->{DefaultSettingVersionAdd} ) {

        my $XMLContentParsedYAML = $YAMLObject->Dump(
            Data => $Test->{Config}->{DefaultSettingVersionAdd}->{Data}->{XMLContentParsed},
        );

        my $EffectiveValueYAML = $YAMLObject->Dump(
            Data => $Test->{Config}->{DefaultSettingVersionAdd}->{Data}->{EffectiveValue},
        );

        $DefaultSettingVersionID = $SysConfigDBObject->DefaultSettingVersionAdd(
            DefaultID => $Test->{Config}->{DefaultSettingVersionAdd}->{DefaultID}
            ? $Test->{Config}->{DefaultSettingVersionAdd}->{DefaultID}
            : $DefaultSettingID,
            %{ $Test->{Config}->{DefaultSettingVersionAdd}->{Data} },
            XMLContentParsed => $XMLContentParsedYAML,
            EffectiveValue   => $EffectiveValueYAML,
        );

        my $Result = $DefaultSettingVersionID ? 1 : 0;
        $Self->Is(
            $Result,
            $Test->{Config}->{DefaultSettingVersionAdd}->{ExpectedResult},
            $Test->{Description}
                . ': DefaultSettingVersionAdd() must '
                . ( $Test->{Config}->{DefaultSettingVersionAdd}->{ExpectedResult} ? 'succeed' : 'fail' )
                . '.',
        );

        if ( $Test->{Config}->{DefaultSettingVersionAdd}->{ExpectedResult} ) {

            #
            # Test for DefaultSettingVersionGet()
            #
            my %DefaultSettingVersion
                = $SysConfigDBObject->DefaultSettingVersionGet( DefaultVersionID => $DefaultSettingVersionID );
            my %DefaultSettingVersionToCompare;
            for my $Key ( sort keys %{ $Test->{Config}->{DefaultSettingVersionAdd}->{Data} } ) {
                $DefaultSettingVersionToCompare{$Key} = $DefaultSettingVersion{$Key};

                # Add UserID as this not reported by DefaultSettingVersionGet()
                if ( $Key eq 'UserID' ) {
                    $DefaultSettingVersionToCompare{$Key} = $Test->{Config}->{DefaultSettingVersionAdd}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%DefaultSettingVersionToCompare,
                $Test->{Config}->{DefaultSettingVersionAdd}->{Data},
                $Test->{Description}
                    . ': DefaultSettingVersionGet() must return stored data.'
            );

            #
            # Test for DefaultSettingVersionListGet()
            #
            my @DefaultSettingVersionList = $SysConfigDBObject->DefaultSettingVersionListGet(
                DefaultID => $Test->{Config}->{DefaultSettingVersionAdd}->{DefaultID}
                ? $Test->{Config}->{DefaultSettingVersionAdd}->{DefaultID}
                : $DefaultSettingID,
            );

            $Self->True(
                IsArrayRefWithData( \@DefaultSettingVersionList ),
                $Test->{Description} . ': DefaultSettingVersionListGet() must return at least one setting.',
            );

            my @DefaultSettingVersions
                = grep { $_->{DefaultVersionID} == $DefaultSettingVersionID } @DefaultSettingVersionList;
            $Self->True(
                @DefaultSettingVersions == 1,
                $Test->{Description} . ': DefaultSettingVersionListGet() must return exactly one matching setting.',
            );

            my $DefaultSettingVersion = shift @DefaultSettingVersions;
            %DefaultSettingVersionToCompare = ();
            for my $Key ( sort keys %{ $Test->{Config}->{DefaultSettingVersionAdd}->{Data} } ) {
                $DefaultSettingVersionToCompare{$Key} = $DefaultSettingVersion{$Key};

                # Add UserID as this not reported by DefaultSettingListGet()
                if ( $Key eq 'UserID' ) {
                    $DefaultSettingVersionToCompare{$Key} = $Test->{Config}->{DefaultSettingVersionAdd}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%DefaultSettingVersionToCompare,
                $Test->{Config}->{DefaultSettingVersionAdd}->{Data},
                $Test->{Description}
                    . ': DefaultSettingVersionListGet() must return stored data.'
            );
        }
    }

    #
    # Test for ModifiedSettingAdd()
    #
    my $ModifiedSettingID;
    if ( exists $Test->{Config}->{ModifiedSettingAdd} ) {

        # Lock setting
        my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
            ? $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
            : $DefaultSettingID,
        );

        my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
            DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
                || $DefaultSettingID,
        );

        if ($ExclusiveLockGUID) {
            $Self->True(
                $IsLock,
                $Test->{Description} . ': Default setting must be lock.',
            );
        }

        $ModifiedSettingID = $SysConfigDBObject->ModifiedSettingAdd(
            DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
            ? $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
            : $DefaultSettingID,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            %{ $Test->{Config}->{ModifiedSettingAdd}->{Data} }
        );

        my $Result = $ModifiedSettingID ? 1 : 0;
        $Self->Is(
            $Result,
            $Test->{Config}->{ModifiedSettingAdd}->{ExpectedResult},
            $Test->{Description}
                . ': ModifiedSettingAdd() must '
                . ( $Test->{Config}->{ModifiedSettingAdd}->{ExpectedResult} ? 'succeed' : 'fail' )
                . '.',
        );

        # Default setting should NOT be locked
        $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
            DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
                || $DefaultSettingID,
        );

        $Self->False(
            $IsLock,
            $Test->{Description} . ': Default setting should NOT be locked.',
        );

        if ( $Test->{Config}->{ModifiedSettingAdd}->{ExpectedResult} ) {

            #
            # Additional ModifiedSettingAdd() with same data must fail
            #
            my $DuplicateModifiedSettingID = $SysConfigDBObject->ModifiedSettingAdd(
                DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
                ? $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
                : $DefaultSettingID,
                %{ $Test->{Config}->{ModifiedSettingAdd}->{Data} }
            );

            my $Result = $DuplicateModifiedSettingID ? 1 : 0;
            $Self->False(
                $Result,
                $Test->{Description}
                    . ': Additional ModifiedSettingAdd() with same data must fail.',
            );

            #
            # Test for ModifiedSettingGet()
            #
            my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet( ModifiedID => $ModifiedSettingID );
            my %ModifiedSettingToCompare;
            for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingAdd}->{Data} } ) {
                $ModifiedSettingToCompare{$Key} = $ModifiedSetting{$Key};

                # Add UserID as this not reported by ModifiedSettingGet()
                if ( $Key eq 'UserID' ) {
                    $ModifiedSettingToCompare{$Key} = $Test->{Config}->{ModifiedSettingAdd}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%ModifiedSettingToCompare,
                $Test->{Config}->{ModifiedSettingAdd}->{Data},
                $Test->{Description}
                    . ': ModifiedSettingGet() must return stored data.'
            );
        }
    }

    #
    # Test for ModifiedSettingUpdate()
    #
    if ( exists $Test->{Config}->{ModifiedSettingUpdate} ) {

        # Lock setting
        my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
            ? $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
            : $DefaultSettingID,
        );

        my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
            DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
                || $DefaultSettingID,
        );

        if ($ExclusiveLockGUID) {
            $Self->True(
                $IsLock,
                $Test->{Description} . ': Default setting must be lock.',
            );
        }

        my $Result = $SysConfigDBObject->ModifiedSettingUpdate(
            ModifiedID => $Test->{Config}->{ModifiedSettingUpdate}->{ModifiedID}
            ? $Test->{Config}->{ModifiedSettingUpdate}->{ModifiedID}
            : $ModifiedSettingID,
            DefaultID => $Test->{Config}->{ModifiedSettingUpdate}->{DefaultID}
            ? $Test->{Config}->{ModifiedSettingUpdate}->{DefaultID}
            : $DefaultSettingID,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            %{ $Test->{Config}->{ModifiedSettingUpdate}->{Data} }
        );

        $Result = $Result ? 1 : 0;
        $Self->Is(
            $Result,
            $Test->{Config}->{ModifiedSettingUpdate}->{ExpectedResult},
            $Test->{Description}
                . ': ModifiedSettingUpdate() must '
                . ( $Test->{Config}->{ModifiedSettingUpdate}->{ExpectedResult} ? 'succeed' : 'fail' )
                . '.',
        );

        my $Success = $SysConfigDBObject->DefaultSettingUnlock(
            DefaultID => $Test->{Config}->{ModifiedSettingUpdate}->{DefaultID}
            ? $Test->{Config}->{ModifiedSettingUpdate}->{DefaultID}
            : $DefaultSettingID,
        );

        # Default setting shoult NOT be locked
        $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
            DefaultID => $Test->{Config}->{ModifiedSettingAdd}->{DefaultID}
                || $DefaultSettingID,
        );

        $Self->False(
            $IsLock,
            $Test->{Description} . ': Default setting should NOT be locked.',
        );

        if ( $Test->{Config}->{ModifiedSettingUpdate}->{ExpectedResult} ) {

            #
            # Test for ModifiedSettingGet()
            #
            my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet( ModifiedID => $ModifiedSettingID );
            my %ModifiedSettingToCompare;
            for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingUpdate}->{Data} } ) {
                $ModifiedSettingToCompare{$Key} = $ModifiedSetting{$Key};

                # Add UserID as this not reported by ModifiedSettingGet()
                if ( $Key eq 'UserID' ) {
                    $ModifiedSettingToCompare{$Key} = $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%ModifiedSettingToCompare,
                $Test->{Config}->{ModifiedSettingUpdate}->{Data},
                $Test->{Description}
                    . ': ModifiedSettingGet() must return stored data.'
            );
        }
    }

    #
    # Test for DefaultSettingUpdate()
    #
    if ( exists $Test->{Config}->{DefaultSettingUpdate} ) {

        # Lock setting
        my $GUID;
        my $DefaultID = $Test->{Config}->{DefaultSettingUpdate}->{DefaultID}
            ? $Test->{Config}->{DefaultSettingUpdate}->{DefaultID} : $DefaultSettingID;

        if ($DefaultID) {
            $GUID = $SysConfigDBObject->DefaultSettingLock(
                DefaultID => $DefaultID,
                Force     => 1,
                UserID    => 1,
            );

            $Self->True(
                $GUID,
                "Lock before DefaultSettingUpdate."
            );

            my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
                DefaultID => $DefaultID,
            );

            $Self->True(
                $IsLock,
                $Test->{Description} . ': Default setting must be lock.',
            );
        }

        my $Result = $SysConfigDBObject->DefaultSettingUpdate(
            DefaultID => $DefaultID,
            %{ $Test->{Config}->{DefaultSettingUpdate}->{Data} },
            ExclusiveLockGUID => $GUID,
        );

        $Result = $Result ? 1 : 0;
        $Self->Is(
            $Result,
            $Test->{Config}->{DefaultSettingUpdate}->{ExpectedResult},
            $Test->{Description}
                . ': DefaultSettingUpdate() must '
                . ( $Test->{Config}->{DefaultSettingUpdate}->{ExpectedResult} ? 'succeed' : 'fail' )
                . '.',
        );

        if ( $Test->{Config}->{DefaultSettingUpdate}->{ExpectedResult} ) {

            #
            # Test for DefaultSettingGet()
            #
            my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet( DefaultID => $DefaultSettingID );
            my %DefaultSettingToCompare;
            for my $Key ( sort keys %{ $Test->{Config}->{DefaultSettingUpdate}->{Data} } ) {
                $DefaultSettingToCompare{$Key} = $DefaultSetting{$Key};

                # Add UserID as this not reported by DefaultSettingGet()
                if ( $Key eq 'UserID' || $Key eq 'ExclusiveLockUserID' || $Key eq 'ExclusiveLockExpiryTime' ) {
                    $DefaultSettingToCompare{$Key} = $Test->{Config}->{DefaultSettingUpdate}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%DefaultSettingToCompare,
                $Test->{Config}->{DefaultSettingUpdate}->{Data},
                $Test->{Description}
                    . ': DefaultSettingGet() must return stored data.'
            );

            #
            # Test for DefaultSettingListGet()
            #
            my @DefaultSettingList = $SysConfigDBObject->DefaultSettingListGet(
                IsInvisible              => $Test->{Config}->{DefaultSettingUpdate}->{Data}->{IsInvisible},
                IsReadonly               => $Test->{Config}->{DefaultSettingUpdate}->{Data}->{IsReadonly},
                IsRequired               => $Test->{Config}->{DefaultSettingUpdate}->{Data}->{IsRequired},
                IsValid                  => $Test->{Config}->{DefaultSettingUpdate}->{Data}->{IsValid},
                HasConfigLevel           => $Test->{Config}->{DefaultSettingUpdate}->{Data}->{HasConfigLevel},
                UserModificationPossible => $Test->{Config}->{DefaultSettingUpdate}->{Data}->{UserModificationPossible},
                UserModificationActive   => $Test->{Config}->{DefaultSettingUpdate}->{Data}->{UserModificationActive},
            );

            $Self->True(
                IsArrayRefWithData( \@DefaultSettingList ),
                $Test->{Description} . ': DefaultSettingListGet() must return at least one setting.',
            );

            my @DefaultSettings = grep { $_->{DefaultID} == $DefaultSettingID } @DefaultSettingList;
            $Self->True(
                @DefaultSettings == 1,
                $Test->{Description} . ': DefaultSettingListGet() must return exactly one matching setting.',
            );

            my $DefaultSetting = shift @DefaultSettings;
            %DefaultSettingToCompare = ();
            for my $Key ( sort keys %{ $Test->{Config}->{DefaultSettingUpdate}->{Data} } ) {
                $DefaultSettingToCompare{$Key} = $DefaultSetting{$Key};

                # Add UserID as this not reported by DefaultSettingListGet()
                if ( $Key eq 'UserID' || $Key eq 'ExclusiveLockUserID' || $Key eq 'ExclusiveLockExpiryTime' ) {
                    $DefaultSettingToCompare{$Key} = $Test->{Config}->{DefaultSettingUpdate}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%DefaultSettingToCompare,
                $Test->{Config}->{DefaultSettingUpdate}->{Data},
                $Test->{Description}
                    . ': DefaultSettingListGet() must return stored data.'
            );
        }
    }

    #
    # Delete modified setting again
    #
    if ($ModifiedSettingID) {
        my $Result = $SysConfigDBObject->ModifiedSettingDelete( ModifiedID => $ModifiedSettingID );
        $Self->True(
            $Result,
            $Test->{Description} . ': ModifiedSettingDelete() must succeed.',
        );

        #
        # Test for ModifiedSettingGet()
        #
        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet( ModifiedID => $ModifiedSettingID );
        $Self->True(
            ref \%ModifiedSetting eq 'HASH' && !%ModifiedSetting,
            $Test->{Description}
                . ': ModifiedSettingGet() must return empty hash for deleted modified setting.',
        );
    }

    #
    # Delete default setting version again
    #
    if ($DefaultSettingVersionID) {
        my $Result = $SysConfigDBObject->DefaultSettingVersionDelete( DefaultVersionID => $DefaultSettingVersionID );
        $Self->True(
            $Result,
            $Test->{Description} . ': DefaultSettingVersionDelete() must succeed.',
        );

        #
        # Test for DefaultSettingVersionGet()
        #
        my %DefaultSettingVersion
            = $SysConfigDBObject->DefaultSettingVersionGet( DefaultIDVersionID => $DefaultSettingVersionID );
        $Self->True(
            ref \%DefaultSettingVersion eq 'HASH' && !%DefaultSettingVersion,
            $Test->{Description}
                . ': DefaultSettingVersionGet() must return empty hash for deleted default setting version.',
        );
    }

    #
    # Delete default setting again
    #
    if ($DefaultSettingID) {
        my $Result = $SysConfigDBObject->DefaultSettingDelete( DefaultID => $DefaultSettingID );
        $Self->True(
            $Result,
            $Test->{Description} . ': DefaultSettingDelete() must succeed.',
        );

        #
        # Test for DefaultSettingGet()
        #
        my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet( DefaultID => $DefaultSettingID );
        $Self->True(
            ref \%DefaultSetting eq 'HASH' && !%DefaultSetting,
            $Test->{Description}
                . ': DefaultSettingGet() must return empty hash for deleted default setting.',
        );

        #
        # Test for DefaultSettingListGet()
        #
        my @DefaultSettingList = $SysConfigDBObject->DefaultSettingListGet();
        $Self->True(
            ref \@DefaultSettingList eq 'ARRAY',
            $Test->{Description} . ': DefaultSettingListGet() must return an array reference.',
        );

        my @DefaultSettings = grep { $_->{DefaultID} == $DefaultSettingID } @DefaultSettingList;
        $Self->True(
            @DefaultSettings == 0,
            $Test->{Description}
                . ': DefaultSettingListGet() must return no matching setting for deleted default setting..',
        );
    }
}

1;
