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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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
</otrs_config>
EOF

    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput => $ValidSettingXML,
);

my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$DateTimeObject->Add( Minutes => 30 );

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $SettingName = 'ProductName ' . $HelperObject->GetRandomNumber();

# Add default setting
my $DefaultSettingID = $SysConfigDBObject->DefaultSettingAdd(
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
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 1',
    UserID                   => 1,
);

my $Result = $DefaultSettingID ? 1 : 0;

$Self->Is(
    $Result,
    1,
    'DefaultSettingAdd() must succeed.',
);

my $SettingName2 = 'CompanyName ' . $HelperObject->GetRandomNumber();

# Add default setting
my $DefaultSettingID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName2,
    Description              => 'Defines the name of the company ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 0,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 0,
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 2',
    UserID                   => 1,
);

$Result = $DefaultSettingID2 ? 1 : 0;

$Self->Is(
    $Result,
    1,
    'DefaultSettingAdd() must succeed.',
);

# Get testing random number
my $RandomNumber = $HelperObject->GetRandomNumber();

# disable email checks to create new user
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $TestUserID;
my $UserRand = 'example-user' . $RandomNumber;

# get user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# add test user
$TestUserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

# Test configuration
my @Tests = (
    {
        Description => 'Complete testing cycle',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 0,
                    EffectiveValue => 'Служба поддержки (support)',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Update only IsDirty flag',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    IsDirty        => 0,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing DefaultID',
        Config      => {
            ModifiedSettingAdd => {
                Data => {

                    Name                   => 'Missing DefaultID ' . $RandomNumber,
                    TargetUserID           => $TestUserID,
                    IsValid                => 1,
                    UserModificationActive => 1,
                    EffectiveValue         => '/usr/pgp',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Missing Name',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    TargetUserID           => $TestUserID,
                    IsValid                => 1,
                    UserModificationActive => 1,
                    EffectiveValue         => '/usr/pgp',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Missing TargetUserID',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    EffectiveValue         => '/usr/pgp',
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing IsValid',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    EffectiveValue => '/usr/pgp',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing UserModificationActive',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    EffectiveValue => '/usr/pgp',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing EffectiveValue',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    TargetUserID           => $TestUserID,
                    IsValid                => 1,
                    UserModificationActive => 1,
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Missing UserID',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    TargetUserID           => $TestUserID,
                    IsValid                => 1,
                    UserModificationActive => 1,
                    EffectiveValue         => '/usr/pgp',
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Take IsValid from Default',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    EffectiveValue => 'AnyValue',
                    UserID         => 1,
                },
                CheckDefaultValues => {
                    IsValid => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    EffectiveValue => 'Something new.',
                    UserID         => 1,
                },
                CheckDefaultValues => {
                    IsValid => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Take IsValid from Default and set it to a new value later',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    EffectiveValue => 'This should be valid by default',
                    UserID         => 1,
                },
                CheckDefaultValues => {
                    IsValid => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 0,
                    EffectiveValue => 'Set new IsValid value',
                    UserID         => 1,
                },
                CheckDefaultValues => {
                    IsValid => 0,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'TargetUserID && UserModificationActive at the same time aading a setting.',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    TargetUserID           => $TestUserID,
                    IsValid                => 1,
                    UserModificationActive => 1,
                    EffectiveValue         => '/usr/pgp',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'TargetUserID && UserModificationActive at the same time updating a setting',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    TargetUserID           => 1,
                    IsValid                => 0,
                    UserModificationActive => 1,
                    EffectiveValue         => 'Служба поддержки éáóíúß',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description =>
            'ModifiedSettingAdd - Not possible to set UserModificationActive if not UserModificationPossible',
        Config => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    EffectiveValue         => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserModificationActive => 1,
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'ModifiedSettingAdd - Not possible to set UserModificationActive for a user setting',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID2,
                    Name                   => $SettingName2,
                    TargetUserID           => 1,
                    IsValid                => 1,
                    EffectiveValue         => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserModificationActive => 1,
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description =>
            'ModifiedSettingAdd - Is possible to set UserModificationActive if UserModificationPossible in default',
        Config => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID              => $DefaultSettingID2,
                    Name                   => $SettingName2,
                    IsValid                => 1,
                    EffectiveValue         => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserModificationActive => 1,
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description =>
            'ModifiedSettingUpdate - Not possible to set UserModificationActive if not UserModificationPossible',
        Config => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID => $DefaultSettingID,
                    Name      => $SettingName,

                    # TargetUserID        => 1,
                    IsValid                => 0,
                    UserModificationActive => 1,
                    EffectiveValue         => 'Служба поддержки éáóíúß',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'ModifiedSettingUpdate - unset UserModificationActive is not possible any way',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    TargetUserID           => 1,
                    IsValid                => 0,
                    UserModificationActive => 0,
                    EffectiveValue         => 'Служба поддержки éáóíúß',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description =>
            'ModifiedSettingUpdate - if UserModificationActive is an empty value and not UserModificationPossible does not matter',
        Config => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID,
                    Name           => $SettingName,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID              => $DefaultSettingID,
                    Name                   => $SettingName,
                    IsValid                => 0,
                    UserModificationActive => 0,
                    EffectiveValue         => 'Служба поддержки éáóíúß',
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'ModifiedSettingUpdate - Is possible to set UserModificationActive if UserModificationPossible',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID2,
                    Name           => $SettingName2,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID              => $DefaultSettingID2,
                    Name                   => $SettingName2,
                    IsValid                => 0,
                    UserModificationActive => 1,
                    EffectiveValue         => 'Служба поддержки éáóíúß',
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'ModifiedSettingUpdate - unset UserModificationActive is possible any way',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID2,
                    Name           => $SettingName2,
                    TargetUserID   => 1,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID              => $DefaultSettingID2,
                    Name                   => $SettingName2,
                    TargetUserID           => 1,
                    IsValid                => 0,
                    UserModificationActive => 0,
                    EffectiveValue         => 'Служба поддержки éáóíúß',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'ModifiedSettingUpdate - Set UserModificationActive when UserModificationPossible is set',
        Config      => {
            ModifiedSettingAdd => {
                Data => {
                    DefaultID      => $DefaultSettingID2,
                    Name           => $SettingName2,
                    IsValid        => 1,
                    EffectiveValue => 'öäüßüüäöäüß1öää?ÖÄPÜ',
                    UserID         => 1,
                },
                ExpectedResult => 1,
            },
            ModifiedSettingUpdate => {
                Data => {
                    DefaultID              => $DefaultSettingID2,
                    Name                   => $SettingName2,
                    IsValid                => 0,
                    UserModificationActive => 1,
                    EffectiveValue         => 'Служба поддержки éáóíúß',
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },

);

TEST:
for my $Test (@Tests) {

    my $CurrentDefaultSettingID = $Test->{Config}->{ModifiedSettingAdd}->{Data}->{DefaultID} || $DefaultSettingID;

    # Lock setting
    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        DefaultID => $CurrentDefaultSettingID,
        UserID    => $Test->{Config}->{ModifiedSettingAdd}->{Data}->{TargetUserID} || 1,
        Force     => 1,
    );

    my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
        DefaultID => $CurrentDefaultSettingID,
    );

    $Self->True(
        $IsLock,
        'Default setting must be lock.',
    );

    $Test->{Config}->{ModifiedSettingAdd}->{Data}->{ExclusiveLockGUID} = $ExclusiveLockGUID;

    my $ModifiedSettingID = $SysConfigDBObject->ModifiedSettingAdd(
        %{ $Test->{Config}->{ModifiedSettingAdd}->{Data} },
    );

    $Result = $ModifiedSettingID ? 1 : 0;
    $Self->Is(
        $Result,
        $Test->{Config}->{ModifiedSettingAdd}->{ExpectedResult},
        $Test->{Description}
            . '-  ModifiedSettingAdd() must '
            . ( $Test->{Config}->{ModifiedSettingAdd}->{ExpectedResult} ? 'succeed' : 'fail' )
            . '.',
    );

    # Not Result means next tests will fail any way
    # due not ModifiedSettingID available.
    next TEST if !$Result;

    # Test for ModifiedSettingGet()
    my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet( ModifiedID => $ModifiedSettingID );

    # check values set by default if not defined in params
    if ( IsHashRefWithData( $Test->{Config}->{ModifiedSettingAdd}->{CheckDefaultValues} ) ) {
        for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingAdd}->{CheckDefaultValues} } ) {
            $Self->Is(
                $ModifiedSetting{$Key},
                $Test->{Config}->{ModifiedSettingAdd}->{CheckDefaultValues}->{$Key},
                $Test->{Description}
                    . " - ModifiedSettingGet() checking default value for: $Key",
            );
        }
    }

    for my $Date (qw(CreateTime ChangeTime)) {
        $Self->True(
            $ModifiedSetting{$Date} =~ m{\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}} ? 1 : 0,
            $Test->{Description}
                . " - ModifiedSettingGet() checking $Date format",
        );
    }

    my %ModifiedSettingToCompare;
    for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingAdd}->{Data} } ) {
        $ModifiedSettingToCompare{$Key} = $ModifiedSetting{$Key};

        # Add missing items not reported by ModifiedSettingGet()
        for my $Item (qw(UserID ExclusiveLockGUID)) {
            if ( $Key eq $Item ) {
                $ModifiedSettingToCompare{$Key} = $Test->{Config}->{ModifiedSettingAdd}->{Data}->{$Item};
            }
        }
    }

    $Self->IsDeeply(
        \%ModifiedSettingToCompare,
        $Test->{Config}->{ModifiedSettingAdd}->{Data},
        $Test->{Description} . ' - ModifiedSettingGet() must return stored data.'
    );

    if ( !$Test->{Config}->{ModifiedSettingAdd}->{Data}->{TargetUserID} ) {

        # Get by name and test it.
        my %ModifiedSettingName
            = $SysConfigDBObject->ModifiedSettingGet( Name => $Test->{Config}->{ModifiedSettingAdd}->{Data}->{Name} );

        my %ModifiedSettingToCompareName;
        for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingAdd}->{Data} } ) {
            $ModifiedSettingToCompareName{$Key} = $ModifiedSettingName{$Key};

            # Add missing items not reported by ModifiedSettingGet()
            for my $Item (qw(UserID ExclusiveLockGUID)) {
                if ( $Key eq $Item ) {
                    $ModifiedSettingToCompareName{$Key} = $Test->{Config}->{ModifiedSettingAdd}->{Data}->{$Item};
                }
            }
        }

        $Self->IsDeeply(
            \%ModifiedSettingToCompareName,
            $Test->{Config}->{ModifiedSettingAdd}->{Data},
            $Test->{Description} . ' - ModifiedSettingGet() must return stored data, requested by name.'
        );
    }

    # If not data for update defined make not sense to execute testing
    if ( exists $Test->{Config}->{ModifiedSettingUpdate} ) {

        # Lock setting
        my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            DefaultID => $CurrentDefaultSettingID,
            UserID    => $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{TargetUserID} || 1,
            Force     => 1,
        );

        my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
            DefaultID => $CurrentDefaultSettingID,
        );

        $Self->True(
            $IsLock,
            'Default setting must be lock.',
        );

        $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{ExclusiveLockGUID} = $ExclusiveLockGUID;

        # Test for ModifiedSettingUpdate()
        $Result = $SysConfigDBObject->ModifiedSettingUpdate(
            ModifiedID => $ModifiedSettingID,
            %{ $Test->{Config}->{ModifiedSettingUpdate}->{Data} },
        );

        $Result = $Result ? 1 : 0;
        $Self->Is(
            $Result,
            $Test->{Config}->{ModifiedSettingUpdate}->{ExpectedResult},
            $Test->{Description}
                . ' - ModifiedSettingUpdate() must '
                . ( $Test->{Config}->{ModifiedSettingUpdate}->{ExpectedResult} ? 'succeed' : 'fail' )
                . '.',
        );

        # If not have a base for comparison go to next test
        if ( $Test->{Config}->{ModifiedSettingUpdate}->{ExpectedResult} ) {

            # Test for ModifiedSettingGet()
            %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet( ModifiedID => $ModifiedSettingID );

            # check values set by default if not defined in params
            if ( IsHashRefWithData( $Test->{Config}->{ModifiedSettingUpdate}->{CheckDefaultValues} ) ) {
                for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingUpdate}->{CheckDefaultValues} } ) {
                    $Self->Is(
                        $ModifiedSetting{$Key},
                        $Test->{Config}->{ModifiedSettingUpdate}->{CheckDefaultValues}->{$Key},
                        $Test->{Description}
                            . " - ModifiedSettingGet() checking default value for: $Key",
                    );
                }
            }
            for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingUpdate}->{Data} } ) {
                $ModifiedSettingToCompare{$Key} = $ModifiedSetting{$Key};

                # Add UserID or ExclusiveLockGUID as this not reported by ModifiedSettingGet()
                if ( $Key eq 'UserID' || $Key eq 'ExclusiveLockGUID' ) {
                    $ModifiedSettingToCompare{$Key} = $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{$Key};
                }
            }

            if ( !$Test->{Config}->{ModifiedSettingUpdate}->{Data}->{TargetUserID} ) {

                my %ModifiedSettingToCompareName;

                # Get by Name and test it.
                my %ModifiedSettingName = $SysConfigDBObject->ModifiedSettingGet(
                    Name => $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{Name}
                );
                for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingUpdate}->{Data} } ) {
                    $ModifiedSettingToCompareName{$Key} = $ModifiedSetting{$Key};

                    # Add UserID or ExclusiveLockGUID as this not reported by ModifiedSettingGet()
                    if ( $Key eq 'UserID' || $Key eq 'ExclusiveLockGUID' ) {
                        $ModifiedSettingToCompareName{$Key} = $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{$Key};
                    }
                }

                $Self->IsDeeply(
                    \%ModifiedSettingToCompareName,
                    $Test->{Config}->{ModifiedSettingUpdate}->{Data},
                    $Test->{Description}
                        . ' - Update - ModifiedSettingGet() must return stored data, requested by name.'
                );
            }

            # Test for ModifiedSettingListGet()
            my %ListGetParams;
            for my $Item (qw(IsInvisible IsReadonly IsRequired IsValid HasConfigLevel UserModificationActive)) {
                $ListGetParams{$Item} = $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{$Item};
            }

            $ListGetParams{ChangeBy} = $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{UserID};

            my @ModifiedSettingList = $SysConfigDBObject->ModifiedSettingListGet(
                %ListGetParams,
            );

            $Self->True(
                IsArrayRefWithData( \@ModifiedSettingList ),
                $Test->{Description} . ' - ModifiedSettingListGet() must return at least one setting.',
            );

            my @ModifiedSettings = grep { $_->{ModifiedID} == $ModifiedSettingID } @ModifiedSettingList;
            $Self->True(
                @ModifiedSettings == 1,
                $Test->{Description} . ' - ModifiedSettingListGet() must return exactly one matching setting.',
            );

            my $ModifiedSetting = shift @ModifiedSettings;
            %ModifiedSettingToCompare = ();
            for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingUpdate}->{Data} } ) {
                $ModifiedSettingToCompare{$Key} = $ModifiedSetting{$Key};

                # Add UserID as this not reported by ModifiedSettingListGet()
                if ( $Key eq 'UserID' || $Key eq 'ExclusiveLockGUID' ) {
                    $ModifiedSettingToCompare{$Key} = $Test->{Config}->{ModifiedSettingUpdate}->{Data}->{$Key};
                }
            }

            $Self->IsDeeply(
                \%ModifiedSettingToCompare,
                $Test->{Config}->{ModifiedSettingUpdate}->{Data},
                $Test->{Description}
                    . ' - ModifiedSettingListGet() must return stored data.'
            );

        }
    }

    if ($ModifiedSettingID) {

        # Delete modified setting
        my $Result = $SysConfigDBObject->ModifiedSettingDelete( ModifiedID => $ModifiedSettingID );
        $Self->True(
            $Result,
            $Test->{Description} . ' - ModifiedSettingDelete() must succeed.',
        );

        # Test for ModifiedSettingGet()
        %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet( ModifiedID => $ModifiedSettingID );
        $Self->True(
            ref \%ModifiedSetting eq 'HASH' && !%ModifiedSetting,
            $Test->{Description}
                . ' - ModifiedSettingGet() must return empty hash for deleted modified setting.',
        );

        # Test for ModifiedSettingListGet()
        my @ModifiedSettingListByName = $SysConfigDBObject->ModifiedSettingListGet(
            Name => $Test->{Config}->{ModifiedSettingAdd}->{Data},
        );
        $Self->True(
            ref \@ModifiedSettingListByName eq 'ARRAY',
            $Test->{Description} . ' - ModifiedSettingListGet() must return an array reference.',
        );

        @ModifiedSettingListByName = grep { $_->{ModifiedID} == $ModifiedSettingID } @ModifiedSettingListByName;
        $Self->True(
            @ModifiedSettingListByName == 0,
            $Test->{Description}
                . ' - ModifiedSettingListGet() must return no matching setting for deleted modified setting.',
        );
    }

}

# Lock setting
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID,
    UserID    => 1,
    Force     => 1,
);

# Add one Modified setting for version testing.
my $ModifiedSettingID = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID              => $DefaultSettingID,
    Name                   => $SettingName,
    Description            => 'A description for this setting áœ∑´®†¥¨ˆø',
    Navigation             => 'ASimple::Path::Used',
    IsInvisible            => 0,
    IsReadonly             => 1,
    IsRequired             => 1,
    IsValid                => 1,
    HasConfigLevel         => 300,
    UserModificationActive => 0,
    XMLContentRaw          => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed       => $DefaultSettingAddParams[0]->{XMLContentParsed},
    EffectiveValue         => 'Test setting 1',
    ExclusiveLockGUID      => $ExclusiveLockGUID,
    UserID                 => 1,
);

$Self->True(
    $ModifiedSettingID,
    'ModifiedSettingAdd used for version testing.',
);

my %DefaultSettingVersionGetLast = $SysConfigDBObject->DefaultSettingVersionGetLast(
    DefaultID => $DefaultSettingID,
);
$Self->True(
    \%DefaultSettingVersionGetLast,
    'DefaultSettingVersionGetLast get version for default.',
);

my $DefaultSettingVersionID = $DefaultSettingVersionGetLast{DefaultVersionID};

# Test configuration
@Tests = (
    {
        Description => 'Complete testing cycle, not user identifier',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID       => $DefaultSettingVersionID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    TargetUserID           => $TestUserID,
                    EffectiveValue         => 'ASimpleString',
                    DeploymentTimeStamp    => '2016-07-28 12:07:23',
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing Default Version ID',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {

                    # ModifiedID            => $ModifiedSettingID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    TargetUserID           => $TestUserID,
                    EffectiveValue         => 'ASimpleString',
                    DeploymentTimeStamp    => '2016-07-28 12:07:23',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Missing Name',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID       => $DefaultSettingVersionID,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    TargetUserID           => $TestUserID,
                    EffectiveValue         => 'ASimpleString',
                    DeploymentTimeStamp    => '2016-07-28 12:07:23',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Missing IsValid',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID       => $DefaultSettingVersionID,
                    Name                   => $SettingName,
                    UserModificationActive => 0,
                    TargetUserID           => $TestUserID,
                    EffectiveValue         => 'ASimpleString',
                    DeploymentTimeStamp    => '2016-07-28 12:07:23',
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing UserModificationActive',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID    => $DefaultSettingVersionID,
                    Name                => $SettingName,
                    IsValid             => 1,
                    TargetUserID        => $TestUserID,
                    EffectiveValue      => 'ASimpleString',
                    DeploymentTimeStamp => '2016-07-28 12:07:23',
                    UserID              => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing TargetUserID',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID       => $DefaultSettingVersionID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    EffectiveValue         => 'ASimpleString',
                    DeploymentTimeStamp    => '2016-07-28 12:07:23',
                    UserID                 => 1,
                },
                ExpectedResult => 1,
            },
        },
    },
    {
        Description => 'Missing EffectiveValue',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID       => $DefaultSettingVersionID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    TargetUserID           => $TestUserID,
                    DeploymentTimeStamp    => '2016-07-28 12:07:23',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Missing DeploymentTimeStamp',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID       => $DefaultSettingVersionID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    TargetUserID           => $TestUserID,
                    EffectiveValue         => 'ASimpleString',
                    UserID                 => 1,
                },
                ExpectedResult => 0,
            },
        },
    },
    {
        Description => 'Missing UserID',
        Config      => {
            ModifiedSettingVersionAdd => {
                Data => {
                    DefaultVersionID       => $DefaultSettingVersionID,
                    Name                   => $SettingName,
                    IsValid                => 1,
                    UserModificationActive => 0,
                    TargetUserID           => $TestUserID,
                    EffectiveValue         => 'ASimpleString',
                    DeploymentTimeStamp    => '2016-07-28 12:07:23',
                },
                ExpectedResult => 0,
            },
        },
    },
);

TESTVERSION:
for my $Test (@Tests) {

    # Test for ModifiedSettingVersionAdd()
    my $ModifiedSettingVersionID = $SysConfigDBObject->ModifiedSettingVersionAdd(
        %{ $Test->{Config}->{ModifiedSettingVersionAdd}->{Data} }
    );

    my $Result = $ModifiedSettingVersionID ? 1 : 0;
    $Self->Is(
        $Result,
        $Test->{Config}->{ModifiedSettingVersionAdd}->{ExpectedResult},
        $Test->{Description}
            . ' - ModifiedSettingVersionAdd() must '
            . ( $Test->{Config}->{ModifiedSettingVersionAdd}->{ExpectedResult} ? 'succeed' : 'fail' )
            . '.',
    );

    # Not Result means next tests will fail any way
    # due not ModifiedSettingID available.
    next TESTVERSION if !$Result;

    # Test for ModifiedSettingGet()
    my %ModifiedSettingVersion
        = $SysConfigDBObject->ModifiedSettingVersionGet( ModifiedVersionID => $ModifiedSettingVersionID );
    my %ModifiedSettingVersionToCompare;
    for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingVersionAdd}->{Data} } ) {
        $ModifiedSettingVersionToCompare{$Key} = $ModifiedSettingVersion{$Key};

        # Add UserID as this not reported by ModifiedSettingVersionGet()
        if ( $Key eq 'UserID' ) {
            $ModifiedSettingVersionToCompare{$Key} = 1;
        }
    }
    use Data::Dumper;
    print STDERR "Debug - ModuleName - ModifiedSettingVersionToCompare = "
        . Dumper( \%ModifiedSettingVersionToCompare ) . "\n";
    $Self->IsDeeply(
        \%ModifiedSettingVersionToCompare,
        $Test->{Config}->{ModifiedSettingVersionAdd}->{Data},
        $Test->{Description} . ' - ModifiedSettingVersionGet() must return stored data.'
    );

    my @ModifiedSettingVersionList = $SysConfigDBObject->ModifiedSettingVersionListGet(
        Name => $Test->{Config}->{ModifiedSettingVersionAdd}->{Data}->{Name},
    );

    $Self->True(
        IsArrayRefWithData( \@ModifiedSettingVersionList ),
        $Test->{Description} . ' - ModifiedSettingVersionListGet() must return at least one setting.',
    );

    my @ModifiedSettingVersions
        = grep { $_->{ModifiedVersionID} == $ModifiedSettingVersionID } @ModifiedSettingVersionList;
    $Self->True(
        @ModifiedSettingVersions == 1,
        $Test->{Description} . ' - ModifiedSettingVersionListGet() must return exactly one matching setting.',
    );

    my $ModifiedSettingVersion = shift @ModifiedSettingVersions;
    %ModifiedSettingVersionToCompare = ();
    for my $Key ( sort keys %{ $Test->{Config}->{ModifiedSettingVersionUpdate}->{Data} } ) {
        $ModifiedSettingVersionToCompare{$Key} = $ModifiedSettingVersion{$Key};

        # Add UserID as this not reported by ModifiedSettingVersionListGet()
        if ( $Key eq 'UserID' || $Key eq 'ExclusiveLockGUID' ) {
            $ModifiedSettingVersionToCompare{$Key} = $Test->{Config}->{ModifiedSettingVersionUpdate}->{Data}->{$Key};
        }
    }

    $Self->IsDeeply(
        \%ModifiedSettingVersionToCompare,
        $Test->{Config}->{ModifiedSettingVersionUpdate}->{Data},
        $Test->{Description}
            . ' - ModifiedSettingVersionListGet() must return stored data.'
    );

    # Delete modified setting
    $Result = $SysConfigDBObject->ModifiedSettingVersionDelete( ModifiedVersionID => $ModifiedSettingVersionID );
    $Self->True(
        $Result,
        $Test->{Description} . ' - ModifiedSettingVersionDelete() must succeed.',
    );

    # Test for ModifiedSettingVersionGet()
    %ModifiedSettingVersion
        = $SysConfigDBObject->ModifiedSettingVersionGet( ModifiedVersionID => $ModifiedSettingVersionID );
    $Self->True(
        ref \%ModifiedSettingVersion eq 'HASH' && !%ModifiedSettingVersion,
        $Test->{Description}
            . ' - ModifiedSettingVersionGet() must return empty hash for deleted modified setting.',
    );

    # Test for ModifiedSettingVersionListGet()
    @ModifiedSettingVersionList = $SysConfigDBObject->ModifiedSettingVersionListGet(
        Name => $Test->{Config}->{ModifiedSettingVersionAdd}->{Data}->{Name},
    );
    $Self->True(
        ref \@ModifiedSettingVersionList eq 'ARRAY',
        $Test->{Description} . ' - ModifiedSettingVersionListGet() must return an array reference.',
    );

    @ModifiedSettingVersions = grep { $_->{ModifiedID} == $ModifiedSettingVersionID } @ModifiedSettingVersionList;
    $Self->True(
        @ModifiedSettingVersions == 0,
        $Test->{Description}
            . ' - ModifiedSettingVersionListGet() must return no matching setting for deleted modified setting.',
    );
}

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Delete sysconfig_modified_version
return if !$DBObject->Do(
    SQL => 'DELETE FROM sysconfig_modified_version',
);

# Delete sysconfig_modified
return if !$DBObject->Do(
    SQL => 'DELETE FROM sysconfig_modified',
);

$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID,
    UserID    => 1,
    Force     => 1,
);

my $ModifiedID = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID              => $DefaultSettingID,
    Name                   => $SettingName,
    IsValid                => 1,
    UserModificationActive => 0,
    EffectiveValue         => 'Modified1',
    ExclusiveLockGUID      => $ExclusiveLockGUID,
    UserID                 => 1,
);

my $ModifiedVersionID = $SysConfigDBObject->ModifiedSettingVersionAdd(
    DefaultVersionID       => $DefaultSettingVersionID,
    Name                   => $SettingName,
    IsValid                => 1,
    UserModificationActive => 0,
    EffectiveValue         => 'Modified1',
    DeploymentTimeStamp    => '2015-12-12 12:00:00',
    UserID                 => 1,
);

my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGetLast(
    Name => $SettingName,
);

$Self->Is(
    $ModifiedSettingVersion{EffectiveValue},
    'Modified1',
    "ModifiedSettingVersionGetLast() 1"
);

$ModifiedVersionID = $SysConfigDBObject->ModifiedSettingVersionAdd(
    DefaultVersionID       => $DefaultSettingVersionID,
    Name                   => $SettingName,
    IsValid                => 1,
    UserModificationActive => 0,
    EffectiveValue         => 'Modified2',
    DeploymentTimeStamp    => '2015-12-12 12:00:00',
    UserID                 => 1,
);

%ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGetLast(
    Name => $SettingName,
);

$Self->Is(
    $ModifiedSettingVersion{EffectiveValue},
    'Modified2',
    "ModifiedSettingVersionGetLast() 1"
);

$SettingName2 = 'ProductName ' . $HelperObject->GetRandomNumber() . 2;

# Add default setting
$DefaultSettingID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName2,
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
);

my $ExclusiveLockGUID2 = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID2,
    UserID    => 1,
    Force     => 1,
);

my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID              => $DefaultSettingID2,
    Name                   => $SettingName2,
    IsValid                => 1,
    UserModificationActive => 0,
    EffectiveValue         => 'Modified1',
    ExclusiveLockGUID      => $ExclusiveLockGUID2,
    UserID                 => 1,
);

my %DefaultSettingVersionGetLast2 = $SysConfigDBObject->DefaultSettingVersionGetLast(
    DefaultID => $DefaultSettingID2,
);
$Self->True(
    \%DefaultSettingVersionGetLast2,
    'DefaultSettingVersionGetLast get version for default.',
);

my $DefaultSettingVersionID2 = $DefaultSettingVersionGetLast2{DefaultVersionID};

my $ModifiedVersionID2 = $SysConfigDBObject->ModifiedSettingVersionAdd(
    DefaultVersionID       => $DefaultSettingVersionID2,
    Name                   => $SettingName2,
    IsValid                => 1,
    UserModificationActive => 0,
    EffectiveValue         => 'Modified1',
    DeploymentTimeStamp    => '2015-12-12 12:00:00',
    UserID                 => 1,
);

$ModifiedVersionID2 = $SysConfigDBObject->ModifiedSettingVersionAdd(
    DefaultVersionID       => $DefaultSettingVersionID2,
    Name                   => $SettingName2,
    IsValid                => 1,
    UserModificationActive => 0,
    EffectiveValue         => 'Modified2',
    DeploymentTimeStamp    => '2015-12-12 12:00:00',
    UserID                 => 1,
);

my %ModifiedSettingVersion2 = $SysConfigDBObject->ModifiedSettingVersionGetLast(
    Name => $SettingName2,
);

my @List = $SysConfigDBObject->ModifiedSettingVersionListGetLast();

$Self->IsDeeply(
    \@List,
    [ \%ModifiedSettingVersion, \%ModifiedSettingVersion2 ],
    "ModifiedSettingVersionListGetLast()"
);

@Tests = (
    {
        Name   => 'Missing Name',
        Config => {},
    },
    {
        Name   => 'Wrong Name',
        Config => {
            Name => -1,
        },
    },
);

for my $Test (@Tests) {

    my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGetLast( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \%ModifiedSettingVersion,
        {},
        "$Test->{Name} ModifiedSettingVersionGetLast()",
    );
}

1;
