# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

#
# Prepare valid config XML and Perl
#
my @ValidSettingXML = (
    <<'EOF',
<Setting Name="Test1" Required="1" Valid="1">
    <Description Translatable="1">Test 1.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="String" ValueRegex=".*">Test setting 1</Item>
    </Value>
</Setting>
EOF
    <<'EOF',
<Setting Name="Test2" Required="1" Valid="1">
    <Description Translatable="1">Test 2.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="File">/usr/bin/gpg</Item>
    </Value>
</Setting>
EOF
    <<'EOF',
<Setting Name="Test3" Required="1" Valid="1">
    <Description Translatable="1">Test 3.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="Directory">/etc/ssl/certs</Item>
    </Value>
</Setting>
EOF
    <<'EOF',
<Setting Name="Test4" Required="1" Valid="1">
    <Description Translatable="1">Test 4.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="Textarea">123\n456</Item>
    </Value>
</Setting>
EOF
    <<'EOF',
<Setting Name="Test5" Required="1" Valid="1">
    <Description Translatable="1">Test 5.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="Checkbox">1</Item>
    </Value>
</Setting>
EOF
);

my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');
my @ValidSettingXMLAndPerl;
for my $ValidSettingXML (@ValidSettingXML) {
    push @ValidSettingXMLAndPerl, {
        XML  => $ValidSettingXML,
        Perl => $SysConfigXMLObject->SettingParse( SettingXML => $ValidSettingXML ),
    };
}

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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[1]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[1]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    HasConfigLevel           => 'test',                               # invalid, must be integer
                    UserModificationPossible => 1,
                    UserModificationActive   => 1,
                    XMLContentRaw            => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[1]->{Perl},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => '/usr/bin/gpg',
                    ExclusiveLockGUID        => 0,
                    ExclusiveLockUserID      => 1,
                    ExclusiveLockExpiryTime  => $DateTimeObject->ToString(),
                    UserID                   => 1,
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    HasConfigLevel           => 'test',                               # invalid, must be integer
                    UserModificationPossible => 0,
                    UserModificationActive   => 0,
                    XMLContentRaw            => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[1]->{Perl},
                    XMLFilename              => 'UnitTest.xml',
                    EffectiveValue           => 'usr/sbin/gpg',
                    UserID                   => 1,
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    XMLContentRaw    => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed => $ValidSettingXMLAndPerl[1]->{Perl},
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
                    XMLContentRaw    => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    XMLContentRaw    => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed => $ValidSettingXMLAndPerl[1]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[1]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},

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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[1]->{Perl},

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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
                    XMLContentRaw            => $ValidSettingXMLAndPerl[1]->{XML},
                    XMLContentParsed         => $ValidSettingXMLAndPerl[1]->{Perl},

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
            %{ $Test->{Config}->{DefaultSettingAdd}->{Data} }
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
        $DefaultSettingVersionID = $SysConfigDBObject->DefaultSettingVersionAdd(
            DefaultID => $Test->{Config}->{DefaultSettingVersionAdd}->{DefaultID}
            ? $Test->{Config}->{DefaultSettingVersionAdd}->{DefaultID}
            : $DefaultSettingID,
            %{ $Test->{Config}->{DefaultSettingVersionAdd}->{Data} }
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

        # Default setting shoult NOT be locked
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

@Tests = (
    {
        Name    => 'Empty',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing Search',
        Config => {
            SearchType => 'XMLContent',
        },
        Success => 0,
    },
    {
        Name   => 'Search XMLContent WrongSearch',
        Config => {
            Search     => "OTRSNoneExsitingString$RandomNumber-UnitTest",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata WrongSearch',
        Config => {
            Search     => "OTRSNoneExsitingString$RandomNumber-UnitTest",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename WrongSearch',
        Config => {
            Search     => "OTRSNoneExsitingString$RandomNumber-UnitTest",
            SearchType => 'Filename',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent ValueType=',
        Config => {
            Search     => "ValueType=",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [qw(Daemon::Log::STDERR AdminEmail Ticket::Hook)],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata ValueType=',
        Config => {
            Search     => "ValueType=",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename ValueType=',
        Config => {
            CategoryFiles => ["ValueType="],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket',
        Config => {
            Search     => "Ticket",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Metadata Ticket',
        Config => {
            Search     => "Ticket",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Filename Ticket',
        Config => {
            CategoryFiles => ["Ticket.xml"],
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket:',
        Config => {
            Search     => "Ticket:",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Metadata Ticket:',
        Config => {
            Search     => "Ticket:",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Filename Ticket:',
        Config => {
            CategoryFiles => ["Ticket:.xml"],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket.xml',
        Config => {
            Search     => "Ticket.xml",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata Ticket.xml',
        Config => {
            Search     => "Ticket.xml",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename Ticket.xml',
        Config => {
            CategoryFiles => ["Ticket.xml"],
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Metadata Ticket::Hook',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGeneratorDaemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search Filename Ticket::Hook',
        Config => {
            CategoryFiles => ["Ticket::Hook"],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket:',
        Config => {
            Search     => [qw(Ticket::Hook Ticket::NumberGenerator)],
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata Ticket:',
        Config => {
            Search     => [qw(Ticket::Hook Ticket::NumberGenerator)],
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename Ticket:',
        Config => {
            CategoryFiles => [qw(Ticket::Hook Ticket::NumberGenerator)],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XMLContent Ticket.xml Framework.xml',
        Config => {
            Search     => [qw(TTicket.xml Framework.xml)],
            SearchType => 'XMLContent',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Metadata Ticket.xml Framework.xml',
        Config => {
            Search     => [qw(Ticket.xml Framework.xml)],
            SearchType => 'Metadata',
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search Filename Ticket.xml Framework.xml',
        Config => {
            CategoryFiles => [qw(Ticket.xml Framework.xml)],
        },
        ExpectedResultsInclude    => [qw(AdminEmail Ticket::Hook Ticket::NumberGenerator)],
        ExpectedResultsNotInclude => [qw(Daemon::Log::STDERR )],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook Valid 1',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'XMLContent',
            Valid      => 1,
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail )],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::Hook Valid 0',
        Config => {
            Search     => "Ticket::Hook",
            SearchType => 'XMLContent',
            Valid      => 0,
        },
        ExpectedResultsInclude    => [qw(Ticket::Hook)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::WatcherGroup Valid 1',
        Config => {
            Search     => "Ticket::WatcherGroup",
            SearchType => 'XMLContent',
            Valid      => 1,
        },
        ExpectedResultsInclude => [qw()],
        ExpectedResultsNotInclude =>
            [qw(Ticket::WatcherGroup Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail )],
        Success => 1,
    },
    {
        Name   => 'Search XMLContent Ticket::WatcherGroup Valid 0',
        Config => {
            Search     => "Ticket::WatcherGroup",
            SearchType => 'XMLContent',
            Valid      => 0,
        },
        ExpectedResultsInclude    => [qw(Ticket::WatcherGroup)],
        ExpectedResultsNotInclude => [qw(Ticket::NumberGenerator Daemon::Log::STDERR AdminEmail)],
        Success                   => 1,
    },
    {
        Name   => 'Search XMLContent AdminEmail in Ticket.xml ',
        Config => {
            Search        => "AdminEmail",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Ticket.xml)],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },
    {
        Name   => 'Search XXMLContent AdminEmail in Framework.xml ',
        Config => {
            Search        => "AdminEmail",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Framework.xml)],
        },
        ExpectedResultsInclude => [qw(AdminEmail)],
        Success                => 1,
    },
    {
        Name   => 'Search XXMLContent Ticket::Hook in Ticket.xml ',
        Config => {
            Search        => "Ticket::Hook",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Ticket.xml)],
        },
        ExpectedResultsInclude => [qw(Ticket::Hook)],
        Success                => 1,
    },
    {
        Name   => 'Search XXMLContent Ticket::Hook in Framework.xml ',
        Config => {
            Search        => "Ticket::Hook",
            SearchType    => 'XMLContent',
            CategoryFiles => [qw(Framework.xml)],
        },
        ExpectedResultsInclude => [],
        Success                => 1,
    },

);

TEST:
for my $Test (@Tests) {

    my @Result = $SysConfigDBObject->DefaultSettingSearch( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            \@Result,
            [],
            "$Test->{Name} DefaultSettingSearch() - not succeed",
        );
        next TEST;
    }

    if ( scalar @{ $Test->{ExpectedResultsInclude} } == 0 ) {
        $Self->IsDeeply(
            \@Result,
            $Test->{ExpectedResultsInclude},
            "$Test->{Name} DefaultSettingSearch() - empty return",
        );

        next TEST;
    }

    my %ResultLookup = map { $_ => 1 } @Result;

    for my $ExpectedResult ( @{ $Test->{ExpectedResultsInclude} } ) {
        $Self->True(
            $ResultLookup{$ExpectedResult},
            "$Test->{Name} DefaultSettingSearch() - $ExpectedResult found with true",
        );
    }
    for my $NotExpectedResult ( @{ $Test->{NotExpectedResultsInclude} } ) {
        $Self->False(
            $ResultLookup{$NotExpectedResult},
            "$Test->{Name} DefaultSettingSearch() - $NotExpectedResult found with false",
        );
    }
}

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>TestPackage1</Name>
    <Version>0.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>http://otrs.com/</URL>
    <License>GNU AFFERO GENERAL PUBLIC LICENSE Version 3, November 2007</License>
    <Description Lang="en">TestPackage1.</Description>
    <Framework>6.0.x</Framework>
    <BuildDate>2016-10-11 02:35:46</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdHJzX2NvbmZpZyB2ZXJzaW9uPSIyLjAiIGluaXQ9IkFwcGxpY2F0aW9uIj4KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMTo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+IAogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxLZXl3b3Jkcz5UZXN0UGFja2FnZTwvS2V5d29yZHM+CiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U8L05hdmlnYXRpb24+CiAgICAgICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgICAgIDxJdGVtIFZhbHVlVHlwZT0iU3RyaW5nIj48L0l0ZW0+CiAgICAgICAgICAgIDwvVmFsdWU+CiAgICA8L1NldHRpbmc+Cjwvb3Ryc19jb25maWc+Cg==</File>
    </Filelist>
</otrs_package>
';

my $String2 = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>TestPackage2</Name>
    <Version>0.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>http://otrs.com/</URL>
    <License>GNU AFFERO GENERAL PUBLIC LICENSE Version 3, November 2007</License>
    <Description Lang="en">TestPackage2.</Description>
    <Framework>6.0.x</Framework>
    <BuildDate>2016-10-11 02:36:29</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage2.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdHJzX2NvbmZpZyB2ZXJzaW9uPSIyLjAiIGluaXQ9IkFwcGxpY2F0aW9uIj4KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMjo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+CiAgICAgICAgPERlc2NyaXB0aW9uIFRyYW5zbGF0YWJsZT0iMSI+VGVzdCBTZXR0aW5nLjwvRGVzY3JpcHRpb24+CiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U8L05hdmlnYXRpb24+CiAgICAgICAgPFZhbHVlPgogICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IlN0cmluZyI+PC9JdGVtPgogICAgICAgIDwvVmFsdWU+CiAgICA8L1NldHRpbmc+CiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTI6OlNldHRpbmcyIiBSZXF1aXJlZD0iMCIgVmFsaWQ9IjEiPgogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlPC9OYXZpZ2F0aW9uPgogICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJTdHJpbmciPjwvSXRlbT4KICAgICAgICA8L1ZhbHVlPgogICAgPC9TZXR0aW5nPgo8L290cnNfY29uZmlnPg==</File>
    </Filelist>
</otrs_package>
';

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# Cleanup the system.
for my $PackageName (qw(TestPackage1 TestPackage2)) {
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackageRemove = $PackageObject->PackageUninstall(
            Name    => $PackageName,
            Version => '0.0.1',
        );

        $Self->True(
            $PackageRemove,
            "RepositoryRemove() $PackageName",
        );
    }
}
my $Counter = 0;
for my $PackageString ( $String, $String2 ) {
    $Counter++;
    my $PackageName = "TestPackage$Counter";
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackagUninstall = $PackageObject->PackageUninstall( String => $PackageString );

        $Self->True(
            $PackagUninstall,
            "$PackagUninstall() $PackageName",
        );
    }

    my $PackageInstall = $PackageObject->PackageInstall( String => $PackageString );
    $Self->True(
        $PackageInstall,
        "PackageInstall() $PackageName",
    );
}

@Tests = (
    {
        Name   => 'TestPackage1',
        Config => {
            Category      => 'TestPackage1',
            CategoryFiles => ['TestPackage1.xml'],
        },
        ExpectedResults => {
            'TestPackage1::Setting1' => 1,
        },
    },
    {
        Name   => 'TestPackage2',
        Config => {
            Category      => 'TestPackage2',
            CategoryFiles => ['TestPackage2.xml'],
        },
        ExpectedResults => {
            'TestPackage2::Setting1' => 1,
            'TestPackage2::Setting2' => 1,
        },
    },
);

for my $Test (@Tests) {
    my @List = $SysConfigDBObject->DefaultSettingListGet( %{ $Test->{Config} } );

    my %Results = map { $_->{Name} => 1 } @List;

    $Self->IsDeeply(
        \%Results,
        $Test->{ExpectedResults},
        "$Test->{Name} DefaultSettingListGet() Category Search",
    );
}

my %List2 = $SysConfigDBObject->DefaultSettingList();
$Self->True(
    %List2,
    'DefaultSettingList() returned some value.'
);
for my $ID ( sort keys %List2 ) {
    my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
        DefaultID => $ID,
    );
    if ( $DefaultSetting{Name} ne $List2{$ID} ) {
        $Self->Is(
            $List2{$ID},
            $DefaultSetting{Name},
            "DefaultSettingList() is DIFFERENT from DefaultSettingGet() for ID $ID .",
        );
    }

    # would produce +1000 tests - that would be alsways OK
    # else {
    #     $Self->Is(
    #         $List2{$ID},
    #         $DefaultSetting{Name},
    #         "DefaultSettingList() has same data as DefaultSettingGet() for $ID .",
    #     );
    # }
}

# Cleanup the system.
$Counter = 0;
for my $PackageString ( $String, $String2 ) {
    $Counter++;
    my $PackageName = "TestPackage$Counter";
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackagUninstall = $PackageObject->PackageUninstall( String => $PackageString );

        $Self->True(
            $PackagUninstall,
            "PackagUninstall() $PackageName",
        );
    }
}

1;
