# --
# LinkObject.t - link object module testscript
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObject.t,v 1.13 2008-07-02 15:20:53 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Data::Dumper;
use Kernel::System::Ticket;
use Kernel::System::LinkObject;
use Kernel::System::User;

$Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );
$Self->{LinkObject}   = Kernel::System::LinkObject->new( %{$Self} );
$Self->{UserObject}   = Kernel::System::User->new( %{$Self} );

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# create needed users
my @UserIDs;

# disable email checks to create new user
my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

for my $Counter ( 1 .. 2 ) {

    # create new users for the tests
    my $UserID = $Self->{UserObject}->UserAdd(
        UserFirstname => 'LinkObject' . $Counter,
        UserLastname  => 'UnitTest',
        UserLogin     => 'UnitTest-LinkObject-' . $Counter . int rand 1_000_000,
        UserEmail     => 'UnitTest-LinkObject-' . $Counter . '@localhost',
        ValidID       => 1,
        ChangeUserID  => 1,
    );

    push @UserIDs, $UserID;
}

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# create needed random type names
my @TypeNames;
for my $Counter ( 1 .. 100 ) {
    push @TypeNames, 'UnitTestType' . int rand 1_000_000;
}

# read ticket backend file
my $TicketBackendContent = $Self->{MainObject}->FileRead(
    Location => $Self->{ConfigObject}->Get('Home') . '/scripts/test/sample/LinkBackendDummy.pm',
    Result   => 'SCALAR',
);

# get location of the backend modules
my $BackendLocation = $Self->{ConfigObject}->Get('Home') . '/Kernel/System/LinkObject/';

# create needed random object names
my @ObjectNames;
for my $Counter ( 1 .. 100 ) {

    # copy the content
    my $Content = ${$TicketBackendContent};

    # generate name
    my $Name = 'UnitTestObject' . int rand 1_000_000;

    # replace Dummy with the UnitTestName
    $Content =~ s{ Dummy }{$Name}xmsg;

    # create the backend file
    $Self->{MainObject}->FileWrite(
        Directory => $BackendLocation,
        Filename  => $Name . '.pm',
        Content   => \$Content,
    );

    push @ObjectNames, $Name;
}

# save original LinkObject::Type settings
my %TypesOrg = %{ $Self->{ConfigObject}->Get('LinkObject::Type') };

# save original LinkObject::TypeGroup settings
my %TypeGroupsOrg = %{ $Self->{ConfigObject}->Get('LinkObject::TypeGroup') };

# save original LinkObject::PossibleLink settings
my %PossibleLinksOrg = %{ $Self->{ConfigObject}->Get('LinkObject::PossibleLink') };

my $TestCount = 1;

# ------------------------------------------------------------ #
# define type tests
# ------------------------------------------------------------ #

my $TypeData = [

    # TypeGet() needs a Name argument (check return false)
    {
        SourceData => {
            TypeGet => {
                UserID => 1,
            },
        },
    },

    # TypeGet() needs a UserID argument (check return false)
    {
        SourceData => {
            TypeGet => {
                Name => 'Dummy',
            },
        },
    },

    # type doesn't exist in database AND sysconfig (check return false)
    {
        SourceData => {
            TypeGet => {
                Name   => $TypeNames[0],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[0],
            },
        },
    },

    # invalid source name is given (check return false)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[3],
                SourceName => '',
                TargetName => $TypeNames[3] . ' Target',
                Pointed    => 1,
            },
            TypeGet => {
                Name   => $TypeNames[3],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[3],
            },
        },
    },

    # invalid target name is given (check return false)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[4],
                SourceName => $TypeNames[4] . ' Source',
                TargetName => '',
                Pointed    => 1,
            },
            TypeGet => {
                Name   => $TypeNames[4],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[4],
            },
        },
    },

    # all required options are given (check returned reference data)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[5],
                SourceName => " \t \n \r " . $TypeNames[5] . ' Source' . " \t \n \r ",
                TargetName => " \t \n \r " . $TypeNames[5] . ' Target' . " \t \n \r ",
            },
            TypeGet => {
                Name   => " \t \n \r " . $TypeNames[5] . " \t \n \r ",
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[5],
            },
            TypeGet => {
                Name       => $TypeNames[5],
                SourceName => $TypeNames[5] . ' Source',
                TargetName => $TypeNames[5] . ' Target',
                Pointed    => 1,
                CreateBy   => 1,
                ChangeBy   => 1,
            },
        },
    },

    # all required options are given (check returned reference data)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[51],
                SourceName => $TypeNames[51] . ' Source',
                TargetName => $TypeNames[51] . ' Target',
            },
            TypeGet => {
                Name   => $TypeNames[51],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[51],
            },
            TypeGet => {
                Name       => $TypeNames[51],
                SourceName => $TypeNames[51] . ' Source',
                TargetName => $TypeNames[51] . ' Target',
                Pointed    => 1,
                CreateBy   => 1,
                ChangeBy   => 1,
            },
        },
    },

    # all required options are given (check returned reference data)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[2],
                SourceName => $TypeNames[2],
                TargetName => $TypeNames[2],
            },
            TypeGet => {
                Name   => $TypeNames[2],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[2],
            },
            TypeGet => {
                Name       => $TypeNames[2],
                SourceName => $TypeNames[2],
                TargetName => $TypeNames[2],
                Pointed    => 0,
                CreateBy   => 1,
                ChangeBy   => 1,
            },
        },
    },

    # this type must be inserted sucessfully (check string clean function)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[5],
                SourceName => " \t \n \r " . $TypeNames[5] . ' Source' . " \t \n \r ",
                TargetName => " \t \n \r " . $TypeNames[5] . ' Target' . " \t \n \r ",
            },
            TypeGet => {
                Name   => $TypeNames[5],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[5],
            },
            TypeGet => {
                Name       => $TypeNames[5],
                SourceName => $TypeNames[5] . ' Source',
                TargetName => $TypeNames[5] . ' Target',
                Pointed    => 1,
                CreateBy   => 1,
                ChangeBy   => 1,
            },
        },
    },

    # this type must be inserted sucessfully (unicode checks)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[6],
                SourceName => ' Պ Č Đ' . $TypeNames[6] . ' Source' . ' ŝ Њ Д ',
                TargetName => ' Ճ ζ φ' . $TypeNames[6] . ' Target' . ' Σ Վ έ ',
            },
            TypeGet => {
                Name   => $TypeNames[6],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[6],
            },
            TypeGet => {
                Name       => $TypeNames[6],
                SourceName => 'Պ Č Đ' . $TypeNames[6] . ' Source' . ' ŝ Њ Д',
                TargetName => 'Ճ ζ φ' . $TypeNames[6] . ' Target' . ' Σ Վ έ',
                Pointed    => 1,
                CreateBy   => 1,
                ChangeBy   => 1,
            },
        },
    },

    # this type must be inserted sucessfully (special character checks)
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[7],
                SourceName => ' [test]%*\\ ' . $TypeNames[7] . ' Source' . ' [test]%*\\ ',
                TargetName => ' [test]%*\\ ' . $TypeNames[7] . ' Target' . ' [test]%*\\ ',
            },
            TypeGet => {
                Name   => $TypeNames[7],
                UserID => 1,
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[7],
            },
            TypeGet => {
                Name       => $TypeNames[7],
                SourceName => '[test]%*\\ ' . $TypeNames[7] . ' Source' . ' [test]%*\\',
                TargetName => '[test]%*\\ ' . $TypeNames[7] . ' Target' . ' [test]%*\\',
                Pointed    => 1,
                CreateBy   => 1,
                ChangeBy   => 1,
            },
        },
    },

    # this type must be inserted sucessfully
    {
        SourceData => {
            ConfigSet => {
                Name       => $TypeNames[8],
                SourceName => $TypeNames[8] . ' Source',
                TargetName => $TypeNames[8] . ' Target',
            },
            TypeGet => {
                Name   => $TypeNames[8],
                UserID => $UserIDs[0],
            },
        },
        ReferenceData => {
            TypeLookup => {
                Name => $TypeNames[8],
            },
            TypeGet => {
                Name       => $TypeNames[8],
                SourceName => $TypeNames[8] . ' Source',
                TargetName => $TypeNames[8] . ' Target',
                Pointed    => 1,
                CreateBy   => $UserIDs[0],
                ChangeBy   => $UserIDs[0],
            },
        },
    },
];

# ------------------------------------------------------------ #
# run type tests
# ------------------------------------------------------------ #

TYPETEST:
for my $Test ( @{$TypeData} ) {

    # check SourceData attribute
    if ( !$Test->{SourceData} || ref $Test->{SourceData} ne 'HASH' ) {
        $Self->True(
            0,
            "Test $TestCount: No SourceData found for this test.",
        );
        next TYPETEST;
    }

    # extract source data
    my $Source = $Test->{SourceData};

    # check TypeGet attribute
    if ( !$Source->{TypeGet} || ref $Source->{TypeGet} ne 'HASH' ) {
        $Self->True(
            0,
            "Test $TestCount: No TypeGet found for this test.",
        );
        next TYPETEST;
    }

    # set config option
    if ( $Source->{ConfigSet} && $Source->{ConfigSet}->{Name} ) {

        # get original option
        my $ConfiguredOptions = $Self->{ConfigObject}->Get('LinkObject::Type');

        # add new option
        $ConfiguredOptions->{ $Source->{ConfigSet}->{Name} } = {
            SourceName => $Source->{ConfigSet}->{SourceName} || undef,
            TargetName => $Source->{ConfigSet}->{TargetName} || undef,
        };

        # add new type
        $Self->{ConfigObject}->Set(
            Key   => 'LinkObject::Type',
            Value => $ConfiguredOptions,
        );
    }
    else {

        # get original option
        my $ConfiguredOptions = $Self->{ConfigObject}->Get('LinkObject::Type');

        # delete option
        $Source->{TypeGet}->{Name} ||= '';
        delete $ConfiguredOptions->{ $Source->{TypeGet}->{Name} };

        # add new type
        $Self->{ConfigObject}->Set(
            Key   => 'LinkObject::Type',
            Value => $ConfiguredOptions,
        );
    }

    # lookup type id
    my $TypeID = $Self->{LinkObject}->TypeLookup(
        Name   => $Source->{TypeGet}->{Name},
        UserID => $Source->{TypeGet}->{UserID},
    );

    if ( $Test->{ReferenceData}->{TypeLookup} ) {

        $Self->True(
            $TypeID,
            "Test $TestCount: TypeLookup() - return valid type id '$TypeID' for type name '$Source->{TypeGet}{Name}'",
        );

        my $TypeName = $Self->{LinkObject}->TypeLookup(
            TypeID => $TypeID,
            UserID => 1,
        );

        $Self->Is(
            $TypeName,
            $Test->{ReferenceData}->{TypeLookup}->{Name},
            "Test $TestCount: TypeLookup() - check type name",
        );

    }
    else {
        $Self->False(
            $TypeID,
            "Test $TestCount: TypeLookup() - return false",
        );
    }

    # get type data
    my %TypeGet = $Self->{LinkObject}->TypeGet(
        TypeID => $TypeID,
        UserID => $Source->{TypeGet}->{UserID},
    );

    if ( $Test->{ReferenceData}->{TypeGet} ) {

        if ( !%TypeGet ) {
            $Self->True(
                0,
                "Test $TestCount: TypeGet() - get type data."
            );
            next TYPETEST;
        }

        # check type data
        for my $Attribute ( keys %{ $Test->{ReferenceData}->{TypeGet} } ) {
            $Self->Is(
                $TypeGet{$Attribute},
                $Test->{ReferenceData}->{TypeGet}->{$Attribute},
                "Test $TestCount: TypeGet() - $Attribute",
            );
        }

        # get type list
        my %TypeList = $Self->{LinkObject}->TypeList(
            UserID => 1,
        );

        # extract TypeGet reference data
        my $ReferenceData = $Test->{ReferenceData}->{TypeGet};

        if ( $ReferenceData->{SourceName} && $ReferenceData->{TargetName} ) {

            #check type name
            $Self->True(
                $TypeList{ $ReferenceData->{Name} },
                "Test $TestCount: TypeList() - $ReferenceData->{Name}",
            );

            # check source name
            $Self->Is(
                $TypeList{ $ReferenceData->{Name} }->{SourceName},
                $ReferenceData->{SourceName},
                "Test $TestCount: TypeList() - check SourceName",
            );

            # check target name
            $Self->Is(
                $TypeList{ $ReferenceData->{Name} }->{TargetName},
                $ReferenceData->{TargetName},
                "Test $TestCount: TypeList() - check TargetName",
            );

        }
        else {
            $Self->False(
                $TypeList{ $ReferenceData->{Name} },
                "Test $TestCount: TypeList() - $ReferenceData->{Name}",
            );
        }

    }
    else {

        my $TypeData = %TypeGet ? 1 : 0;
        my $TypeName = $TypeGet{Name} || '';

        $Self->False(
            $TypeData,
            "Test $TestCount: TypeGet() - return false :   $TypeName",
        );
    }
}
continue {
    $TestCount++;
}

# restore original LinkObject::Type settings
$Self->{ConfigObject}->Set(
    Key   => 'LinkObject::Type',
    Value => \%TypesOrg,
);

# ------------------------------------------------------------ #
# run state list tests
# ------------------------------------------------------------ #

for my $Valid ( 0 .. 1 ) {

    # get state list
    my %StateList = $Self->{LinkObject}->StateList(
        Valid  => $Valid,
        UserID => 1,
    );

    my $StateCheck = %StateList ? 1 : 0;

    # check if state list exists
    $Self->True(
        $StateCheck,
        "Test $TestCount: StateList() - valid check",
    );

    # check all state ids
    for my $StateID ( keys %StateList ) {

        # check if value is valid
        $Self->True(
            $StateList{$StateID},
            "Test $TestCount: StateList() - valid items check - $StateID => $StateList{$StateID}",
        );

        # lookup the state name
        my $LookupName = $Self->{LinkObject}->StateLookup(
            StateID => $StateID,
            UserID  => 1,
        );

        # check the lookup name
        $Self->Is(
            $LookupName,
            $StateList{$StateID},
            "Test $TestCount: StateLookup() - lookup the name",
        );

        # lookup the state id
        my $LookupStateID = $Self->{LinkObject}->StateLookup(
            Name   => $StateList{$StateID},
            UserID => 1,
        );

        # check the lookup state id
        $Self->Is(
            $LookupStateID,
            $StateID,
            "Test $TestCount: StateLookup() - lookup the state id",
        );
    }
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# define object lookup tests
# ------------------------------------------------------------ #

my $ObjectData = [

    # this object must be inserted sucessfully
    {
        SourceName    => $ObjectNames[0],
        ReferenceName => $ObjectNames[0],
    },

    # invalid source name is given (check return false)
    {
        SourceName => $ObjectNames[1] . ' Test ',
    },

    # this object must be inserted sucessfully (check string trim function)
    {
        SourceName    => $ObjectNames[1] . 'Test ',
        ReferenceName => $ObjectNames[1] . 'Test',
    },

    # this object must be inserted sucessfully (check string trim function)
    {
        SourceName    => " \t \n \r " . $ObjectNames[2] . " \t \n \r ",
        ReferenceName => $ObjectNames[2],
    },

    # invalid source name is given (check return false)
    {
        SourceName => " \n \t \r ",
    },

    # this type must be inserted sucessfully (unicode checks)
    {
        SourceName    => ' ԺΛϢ' . $ObjectNames[3] . 'ΞΏΓ ',
        ReferenceName => 'ԺΛϢ' . $ObjectNames[3] . 'ΞΏΓ',
    },

    # invalid source name is given (check return false)
    {
        SourceName => ' Ϭ ϯ Λ ' . $ObjectNames[4] . ' Ϩ ϴ Γ ',
    },
];

# ------------------------------------------------------------ #
# run object lookup tests
# ------------------------------------------------------------ #

OBJECTTEST:
for my $Test ( @{$ObjectData} ) {

    if ( !$Test->{SourceName} ) {
        $Self->True(
            0,
            "Test $TestCount: No SourceName found for this test.",
        );
        next OBJECTTEST;
    }

    # lookup the object id
    my $ObjectID = $Self->{LinkObject}->ObjectLookup(
        Name   => $Test->{SourceName},
        UserID => 1,
    );

    if ( !$Test->{ReferenceName} ) {
        $Self->False(
            $ObjectID,
            "Test $TestCount: ObjectLookup() - valid ObjectID",
        );
        next OBJECTTEST;
    }

    $Self->True(
        $ObjectID,
        "Test $TestCount: ObjectLookup() - valid ObjectID",
    );

    next OBJECTTEST if !$ObjectID;

    # lookup the name
    my $LookupName = $Self->{LinkObject}->ObjectLookup(
        ObjectID => $ObjectID,
        UserID   => 1,
    );

    # check the lookup object id
    $Self->Is(
        $LookupName,
        $Test->{ReferenceName},
        "Test $TestCount: ObjectLookup() - lookup the name",
    );

    # lookup the object id a second time
    my $ObjectID2 = $Self->{LinkObject}->ObjectLookup(
        Name   => $Test->{SourceName},
        UserID => 1,
    );

    # check the lookup object id a second time
    $Self->Is(
        $ObjectID,
        $ObjectID2,
        "Test $TestCount: ObjectLookup() - ids identical",
    );
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# define possible links tests
# ------------------------------------------------------------ #
{

    # add test types to config for later tests
    my $Settings;
    for my $TypeName (@TypeNames) {
        $Settings->{$TypeName} = {
            SourceName => $TypeName,
            TargetName => $TypeName,
        };
    }

    # add new types to config
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::Type',
        Value => $Settings,
    );

    # add possible link relations for later tests
    my $PossibleLinksConfig = {
        10001 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            Type    => $TypeNames[0],
        },
        10002 => {
            Object1 => ' Λ λ Ə' . $ObjectNames[0] . 'ϔ Ϡ ԉ ',
            Object2 => ' Ϋ ά Ƣ' . $ObjectNames[0] . 'ƒ ƥ Ư ',
            Type    => $TypeNames[1],
        },
        10003 => {
            Object1 => " \t \n \r " . $ObjectNames[0] . " \t \n \r ",
            Object2 => " \t \n \r " . $ObjectNames[2] . " \t \n \r ",
            Type    => " \t \n \r " . $TypeNames[2] . " \t \n \r ",
        },
        10004 => {
            Object1 => " \t \n \r " . $ObjectNames[2] . " \t \n \r ",
            Object2 => " \t \n \r " . $ObjectNames[2] . " \t \n \r ",
            Type    => " \t \n \r " . $TypeNames[2] . " \t \n \r ",
        },
        10005 => {
            Object1 => $ObjectNames[0] . '::Test',
            Object2 => $ObjectNames[0] . '::Test',
            Type    => $TypeNames[0] . '::Test',
        },
        10006 => {
            ObjectA => $ObjectNames[0],
            ObjectB => $ObjectNames[0],
            TypeX   => $TypeNames[0],
        },
        10007 => {
            ObjectA => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            Type    => $TypeNames[0],
        },
        10008 => {
            Object1 => $ObjectNames[0],
            ObjectB => $ObjectNames[0],
            Type    => $TypeNames[0],
        },
        10009 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            TypeX   => $TypeNames[0],
        },
    };

    # create above config settings for later tests
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::PossibleLink',
        Value => $PossibleLinksConfig,
    );
}

# define reference data
my %PossibleLinksReference = (
    10001 => {
        Object1 => $ObjectNames[0],
        Object2 => $ObjectNames[0],
        Type    => $TypeNames[0],
    },
    10003 => {
        Object1 => $ObjectNames[0],
        Object2 => $ObjectNames[2],
        Type    => $TypeNames[2],
    },
    10004 => {
        Object1 => $ObjectNames[2],
        Object2 => $ObjectNames[2],
        Type    => $TypeNames[2],
    },
);

# ------------------------------------------------------------ #
# run possible links tests
# ------------------------------------------------------------ #

my %PossibleLinkList = $Self->{LinkObject}->PossibleLinkList(
    UserID => 1,
);

# check setting data
$Self->Is(
    scalar keys %PossibleLinkList,
    scalar keys %PossibleLinksReference,
    "Test $TestCount: PossibleLinkList() - same number of elements",
);

for my $PossibleLink ( keys %PossibleLinkList ) {

    # check if setting name is the same as in reference data
    $Self->True(
        $PossibleLinksReference{$PossibleLink},
        "Test $TestCount: PossibleLinkList() - check config name - LinkObject::PossibleLink###$PossibleLink",
    );

    # check setting data
    for my $Attribute ( keys %{ $PossibleLinkList{$PossibleLink} } ) {
        $Self->Is(
            $PossibleLinkList{$PossibleLink}->{$Attribute},
            $PossibleLinksReference{$PossibleLink}->{$Attribute},
            "Test $TestCount: PossibleLinkList() - check $Attribute",
        );
    }
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# define possible objects tests
# ------------------------------------------------------------ #
{

    # add possible link relations for later tests
    my $PossibleLinksConfig = {
        10001 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            Type    => $TypeNames[0],
        },
        10002 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[1],
            Type    => $TypeNames[1],
        },
        10003 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[2],
        },
        10004 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[3],
            Type    => $TypeNames[2],
        },
        10005 => {
            Object1 => $ObjectNames[10],
            Object2 => $ObjectNames[10],
            Type    => $TypeNames[0],
        },
        10006 => {
            Object1 => $ObjectNames[10],
            Object2 => $ObjectNames[10],
            Type    => $TypeNames[1],
        },
        10007 => {
            Object1 => $ObjectNames[10],
            Object2 => $ObjectNames[11],
            Type    => $TypeNames[0],
        },
        10008 => {
            Object1 => $ObjectNames[11],
            Object2 => $ObjectNames[10],
            Type    => $TypeNames[0],
        },
        10009 => {
            Object1 => $ObjectNames[20],
            Object2 => $ObjectNames[21],
            Type    => $TypeNames[0],
        },
        10010 => {
            Object1 => $ObjectNames[21],
            Object2 => $ObjectNames[20],
            Type    => $TypeNames[0],
        },
        10011 => {
            Object1 => $ObjectNames[20],
            Object2 => $ObjectNames[21],
            Type    => $TypeNames[0],
        },
        10012 => {
            Object1 => $ObjectNames[21],
            Object2 => $ObjectNames[20],
            Type    => $TypeNames[0],
        },
        10013 => {
            Object1 => $ObjectNames[30],
            Object2 => $ObjectNames[30],
            Type    => $TypeNames[1],
        },
        10014 => {
            Object1 => $ObjectNames[30],
            Object2 => $ObjectNames[31],
            Type    => 'UnitTestTypeDummy',
        },
        10015 => {
            Object1 => " \t \n \r " . $ObjectNames[50] . " \t \n \r ",
            Object2 => " \t \n \r " . $ObjectNames[50] . " \t \n \r ",
            Type    => " \t \n \r " . $TypeNames[1] . " \t \n \r ",
        },
        10016 => {
            Object1 => " \t \n \r " . $ObjectNames[50] . " \t \n \r ",
            Object2 => " \t \n \r " . $ObjectNames[51] . " \t \n \r ",
            Type    => " \t \n \r " . $TypeNames[1] . " \t \n \r ",
        },
    };

    # create above config settings for later tests
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::PossibleLink',
        Value => $PossibleLinksConfig,
    );
}

my $PossibleObjectsReference = [

    # PossibleObjectsList() needs a Object argument (check return false)
    {
        SourceData => {
            UserID => 1,
        },
    },

    # PossibleObjectsList() needs a UserID argument (check return false)
    {
        SourceData => {
            Object => 'Ticket',
        },
    },

    # try to get PossibleObjectsList for an Object with no valid type (check return false)
    {
        SourceData => {
            Object => $ObjectNames[31],
            UserID => 1,
        },
    },

    # this test must return the corect number of entries
    {
        SourceData => {
            Object => $ObjectNames[0],
            UserID => 1,
        },
        ReferenceData => [
            $ObjectNames[0],
            $ObjectNames[1],
            $ObjectNames[2],
            $ObjectNames[3],
        ],
    },

    # this test must return the corect number of entries
    {
        SourceData => {
            Object => $ObjectNames[10],
            UserID => 1,
        },
        ReferenceData => [
            $ObjectNames[10],
            $ObjectNames[11],
        ],
    },

    # this test must return the corect number of entries
    {
        SourceData => {
            Object => $ObjectNames[20],
            UserID => 1,
        },
        ReferenceData => [
            $ObjectNames[21],
        ],
    },

    # this test must return the corect number of entries
    {
        SourceData => {
            Object => $ObjectNames[30],
            UserID => 1,
        },
        ReferenceData => [
            $ObjectNames[30],
        ],
    },

    # this test must return the corect number of entries ( zero )
    {
        SourceData => {
            Object => $ObjectNames[40],
            UserID => 1,
        },
        ReferenceData => [
        ],
    },

    # this test must return the corect number of entries
    {
        SourceData => {
            Object => $ObjectNames[50],
            UserID => 1,
        },
        ReferenceData => [
            $ObjectNames[50],
            $ObjectNames[51],
        ],
    },
];

# ------------------------------------------------------------ #
# run possible objects tests
# ------------------------------------------------------------ #

POSSIBLEOBJECTS:
for my $Test ( @{$PossibleObjectsReference} ) {

    # check SourceData attribute
    if ( !$Test->{SourceData} || ref $Test->{SourceData} ne 'HASH' ) {
        $Self->True(
            0,
            "Test $TestCount: No SourceData found for this test.",
        );
        next POSSIBLEOBJECTS;
    }

    # get possible objects list
    my %PossibleObjectsList = $Self->{LinkObject}->PossibleObjectsList(
        %{ $Test->{SourceData} },
    );

    # check if ReferenceData is present
    if ( $Test->{ReferenceData} && ref $Test->{ReferenceData} eq 'ARRAY' ) {

        # compare if list has the correct size
        $Self->Is(
            scalar keys %PossibleObjectsList,
            scalar @{ $Test->{ReferenceData} },
            "Test $TestCount: PossibleObjectsList() - check number of elements",
        );

        # create lookup hash for ReferenceData
        my %ObjectsReference = map { $_ => 1 } @{ $Test->{ReferenceData} };

        # compare if all elements of both lists are the same
        for my $PossibleObject ( keys %PossibleObjectsList ) {
            $Self->True(
                $ObjectsReference{$PossibleObject},
                "Test $TestCount: PossibleObjectsList() - check values - $PossibleObject",
            );
        }
    }
    else {
        $Self->False(
            scalar keys %PossibleObjectsList,
            "Test $TestCount: PossibleObjectsList() - return false",
        );
    }
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# define possible types tests
# ------------------------------------------------------------ #
{

    # add possible link relations for later tests
    my $PossibleLinksConfig = {
        10001 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            Type    => $TypeNames[0],
        },
        10002 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            Type    => $TypeNames[0],
        },
        10003 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            Type    => $TypeNames[1],
        },
        10004 => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            Type    => $TypeNames[2],
        },
        10005 => {
            Object1 => $ObjectNames[10],
            Object2 => $ObjectNames[11],
            Type    => $TypeNames[0],
        },
        10006 => {
            Object1 => $ObjectNames[11],
            Object2 => $ObjectNames[10],
            Type    => $TypeNames[0],
        },
        10007 => {
            Object1 => $ObjectNames[10],
            Object2 => $ObjectNames[11],
            Type    => $TypeNames[1],
        },
        10008 => {
            Object1 => $ObjectNames[11],
            Object2 => $ObjectNames[10],
            Type    => $TypeNames[1],
        },
        10009 => {
            Object1 => $ObjectNames[20],
            Object2 => $ObjectNames[21],
            Type    => $TypeNames[0],
        },
        10010 => {
            Object1 => $ObjectNames[20],
            Object2 => $ObjectNames[21],
            Type    => $TypeNames[1],
        },
        10011 => {
            Object1 => $ObjectNames[21],
            Object2 => $ObjectNames[20],
            Type    => $TypeNames[1],
        },
        10012 => {
            Object1 => $ObjectNames[20],
            Object2 => $ObjectNames[21],
            Type    => $TypeNames[0],
        },
        10013 => {
            Object1 => $ObjectNames[21],
            Object2 => $ObjectNames[20],
            Type    => $TypeNames[2],
        },
        10014 => {
            Object1 => $ObjectNames[20],
            Object2 => $ObjectNames[21],
            Type    => $TypeNames[3],
        },
        10015 => {
            Object1 => $ObjectNames[30],
            Object2 => $ObjectNames[30],
            Type    => $TypeNames[1],
        },
        10016 => {
            Object1 => $ObjectNames[30],
            Object2 => $ObjectNames[31],
            Type    => 'UnitTestTypeDummy',
        },
        10017 => {
            Object1 => " \t \n \r " . $ObjectNames[40] . " \t \n \r ",
            Object2 => " \t \n \r " . $ObjectNames[40] . " \t \n \r ",
            Type    => " \t \n \r " . $TypeNames[0] . " \t \n \r ",
        },
        10018 => {
            Object1 => " \t \n \r " . $ObjectNames[40] . " \t \n \r ",
            Object2 => " \t \n \r " . $ObjectNames[40] . " \t \n \r ",
            Type    => " \t \n \r " . $TypeNames[1] . " \t \n \r ",
        },
    };

    # create above config settings for later tests
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::PossibleLink',
        Value => $PossibleLinksConfig,
    );
}

my $PossibleTypesReference = [

    # PossibleTypesList() needs a Object1 argument (check return false)
    {
        SourceData => {
            Object2 => 'Ticket',
            UserID  => 1,
        },
    },

    # PossibleTypesList() needs a Object2 argument (check return false)
    {
        SourceData => {
            Object1 => 'Ticket',
            UserID  => 1,
        },
    },

    # PossibleTypesList() needs a UserID argument (check return false)
    {
        SourceData => {
            Object1 => 'Ticket',
            Object2 => 'Ticket',
        },
    },

    # try to get PossibleTypesList for an Object with no valid type (check return false)
    {
        SourceData => {
            Object => $ObjectNames[31],
            UserID => 1,
        },
    },

    # this test must return the correct number of entries
    {
        SourceData => {
            Object1 => $ObjectNames[0],
            Object2 => $ObjectNames[0],
            UserID  => 1,
        },
        ReferenceData => [
            $TypeNames[0],
            $TypeNames[1],
            $TypeNames[2],
        ],
    },

    # this test must return the correct number of entries
    {
        SourceData => {
            Object1 => $ObjectNames[10],
            Object2 => $ObjectNames[11],
            UserID  => 1,
        },
        ReferenceData => [
            $TypeNames[0],
            $TypeNames[1],
        ],
    },

    # this test must return the correct number of entries
    {
        SourceData => {
            Object1 => $ObjectNames[20],
            Object2 => $ObjectNames[21],
            UserID  => 1,
        },
        ReferenceData => [
            $TypeNames[0],
            $TypeNames[1],
            $TypeNames[2],
            $TypeNames[3],
        ],
    },

    # this test must return the correct number of entries
    {
        SourceData => {
            Object1 => $ObjectNames[30],
            Object2 => $ObjectNames[30],
            UserID  => 1,
        },
        ReferenceData => [
            $TypeNames[1],
        ],
    },

    # this test must return the correct number of entries
    {
        SourceData => {
            Object1 => $ObjectNames[30],
            Object2 => $ObjectNames[31],
            UserID  => 1,
        },
        ReferenceData => [
        ],
    },

    # this test must return the correct number of entries
    {
        SourceData => {
            Object1 => $ObjectNames[40],
            Object2 => $ObjectNames[40],
            UserID  => 1,
        },
        ReferenceData => [
            $TypeNames[0],
            $TypeNames[1],
        ],
    },
];

# ------------------------------------------------------------ #
# run possible types tests
# ------------------------------------------------------------ #

POSSIBLETYPES:
for my $Test ( @{$PossibleTypesReference} ) {

    # check SourceData attribute
    if ( !$Test->{SourceData} || ref $Test->{SourceData} ne 'HASH' ) {
        $Self->True(
            0,
            "Test $TestCount: No SourceData found for this test.",
        );
        next POSSIBLETYPES;
    }

    # get possible objects list
    my %PossibleTypesList = $Self->{LinkObject}->PossibleTypesList(
        %{ $Test->{SourceData} },
    );

    # check if ReferenceData is present
    if ( $Test->{ReferenceData} && ref $Test->{ReferenceData} eq 'ARRAY' ) {

        # compare if list has the correct size
        $Self->Is(
            scalar keys %PossibleTypesList,
            scalar @{ $Test->{ReferenceData} },
            "Test $TestCount: PossibleTypesList() - check number of elements",
        );

        # create lookup hash for ReferenceData
        my %TypesReference = map { $_ => 1 } @{ $Test->{ReferenceData} };

        # compare if all elements of both lists are the same
        for my $PossibleType ( keys %PossibleTypesList ) {
            $Self->True(
                $TypesReference{$PossibleType},
                "Test $TestCount: PossibleTypesList() - check values - $PossibleType",
            );
        }
    }
    else {
        $Self->False(
            scalar keys %PossibleTypesList,
            "Test $TestCount: PossibleTypesList() - return false",
        );
    }
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# define type group tests
# ------------------------------------------------------------ #
{

    # add test types to config for later tests
    my $Settings;
    for my $TypeName (@TypeNames) {
        $Settings->{$TypeName} = {
            SourceName => $TypeName,
            TargetName => $TypeName,
        };
    }

    # add new types to config
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::Type',
        Value => $Settings,
    );

    # add possible link relations for later tests
    my $TypeGroupConfig = {
        10001 => [
            $TypeNames[0],
            $TypeNames[1],
        ],
        10002 => [
            $TypeNames[10],
            $TypeNames[11],
            $TypeNames[12],
        ],
        10003 => [
            " \t \n \r " . $TypeNames[23] . " \t \n \r ",
            " \t \n \r " . $TypeNames[24] . " \t \n \r ",
        ],
        10004 => [
            $TypeNames[23],
            $TypeNames[25],
        ],
        10005 => [
            $TypeNames[20],
            'Invalid::DummyType1',
        ],
        10006 => [
            $TypeNames[20],
            ' Invalid::DummyType2 ',
        ],
        10007 => [
            $TypeNames[21],
            'Invalid DummyType3',
        ],
        10008 => [
            $TypeNames[22],
            'UndefinedDummyType1',
        ],
    };

    # create above config settings for later tests
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::TypeGroup',
        Value => $TypeGroupConfig,
    );
}

# define reference data
my %TypeGroupReference = (
    10001 => [
        $TypeNames[0],
        $TypeNames[1],
    ],
    10002 => [
        $TypeNames[10],
        $TypeNames[11],
        $TypeNames[12],
    ],
    10003 => [
        $TypeNames[23],
        $TypeNames[24],
    ],
    10004 => [
        $TypeNames[23],
        $TypeNames[25],
    ],
);

# ------------------------------------------------------------ #
# run type group tests
# ------------------------------------------------------------ #

# get type group list
my %TypeGroupList = $Self->{LinkObject}->TypeGroupList(
    UserID => 1,
);

# check if the type group list has same number of entries as the reference list
$Self->Is(
    scalar keys %TypeGroupList,
    scalar keys %TypeGroupReference,
    "Test $TestCount: TypeGroupList() - same number of elements",
);

TYPEGROUP:
for my $TypeGroup ( keys %TypeGroupReference ) {

    # check if setting names are identical
    $Self->True(
        $TypeGroupReference{$TypeGroup},
        "Test $TestCount: TypeGroupList() - check config name - LinkObject::TypeGroup###$TypeGroup",
    );

    # check if reference data is present
    if ( !$TypeGroupList{$TypeGroup} || ref $TypeGroupList{$TypeGroup} ne 'ARRAY' ) {
        $Self->True(
            0,
            "Test $TestCount: TypeGroupList() - No reference data found",
        );
        next TYPEGROUP;
    }

    # check if the type list in each group has same number of entries as the reference list
    $Self->Is(
        scalar @{ $TypeGroupList{$TypeGroup} },
        scalar @{ $TypeGroupReference{$TypeGroup} },
        "Test $TestCount: TypeGroupList() - number of entries - LinkObject::TypeGroup###$TypeGroup",
    );

    # create lookup hash for ReferenceData
    my %TypesReference = map { $_ => 1 } @{ $TypeGroupReference{$TypeGroup} };

    # compare if all elements of both lists are the same
    for my $Type ( @{ $TypeGroupList{$TypeGroup} } ) {
        $Self->True(
            $TypesReference{$Type},
            "Test $TestCount: TypeGroupList() - check values - $Type",
        );
    }
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# define tests for the PossibleType() function)
# ------------------------------------------------------------ #

{

    # add test types to config for later tests
    my $Settings;
    for my $Count ( 0 .. 100 ) {
        $Settings->{"UnitTestType$Count"} = {
            SourceName => 'Parent' . $Count,
            TargetName => 'Child' . $Count,
        };
    }

    # add new types to config
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::Type',
        Value => $Settings,
    );

    # add possible link relations for later tests
    my $TypeGroupConfig = {

        10001 => [
            'UnitTestType0',
            'UnitTestType1',
        ],
        10002 => [
            'UnitTestType10',
            'UnitTestType11',
            'UnitTestType12',
        ],
        10003 => [
            'UnitTestType23',
            'UnitTestType24',
            'UnitTestType25',
        ],
        10004 => [
            'UnitTestType23',
            'UnitTestType26',
        ],
    };

    # create above config settings for later tests
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::TypeGroup',
        Value => $TypeGroupConfig,
    );
}

# define reference data
my $PossibleTypeReference = [

    # PossibleTypes() (check return false)
    {
        SourceData => {
            Type1 => 'UnitTestType0',
            Type2 => 'UnitTestType1',
        },
    },

    # PossibleTypes() (check return false)
    {
        SourceData => {
            Type1 => 'UnitTestType10',
            Type2 => 'UnitTestType11',
        },
    },

    # PossibleTypes() (check return false)
    {
        SourceData => {
            Type1 => 'UnitTestType11',
            Type2 => 'UnitTestType12',
        },
    },

    # PossibleTypes() (check return false)
    {
        SourceData => {
            Type1 => 'UnitTestType23',
            Type2 => 'UnitTestType24',
        },
    },

    # PossibleTypes() (check return false)
    {
        SourceData => {
            Type1 => 'UnitTestType23',
            Type2 => 'UnitTestType26',
        },
    },

    # PossibleTypes() (check return true)
    {
        SourceData => {
            Type1 => 'UnitTestType0',
            Type2 => 'UnitTestType10',
        },
        ReferenceData => 1,
    },

    # PossibleTypes() (check return true)
    {
        SourceData => {
            Type1 => 'UnitTestType10',
            Type2 => 'UnitTestType23',
        },
        ReferenceData => 1,
    },

    # PossibleTypes() (check return true)
    {
        SourceData => {
            Type1 => 'UnitTestType25',
            Type2 => 'UnitTestType26',
        },
        ReferenceData => 1,
    },

    # PossibleTypes() (check return true)
    {
        SourceData => {
            Type1 => 'UnitTestType0',
            Type2 => 'UnitTestType12',
        },
        ReferenceData => 1,
    },

    # PossibleTypes() (check return true)
    {
        SourceData => {
            Type1 => 'UnitTestType1',
            Type2 => 'UnitTestType25',
        },
        ReferenceData => 1,
    },
];

# ------------------------------------------------------------ #
# run tests for the PossibleType() function)
# ------------------------------------------------------------ #
TEST:
for my $Test ( @{$PossibleTypeReference} ) {

    # check SourceData attribute
    if ( !$Test->{SourceData} || ref $Test->{SourceData} ne 'HASH' ) {
        $Self->True(
            0,
            "Test $TestCount: No SourceData found for this test.",
        );
        next TEST;
    }

    my $Result = $Self->{LinkObject}->PossibleType(
        %{ $Test->{SourceData} },
        UserID => 1,
    );

    # check if ReferenceData is present
    if ( $Test->{ReferenceData} ) {
        $Self->True(
            $Result,
            "Test $TestCount: PossibleType() - check possible type",
        );
    }
    else {
        $Self->False(
            $Result,
            "Test $TestCount: PossibleType() - return false",
        );
    }
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# define link tests
# ------------------------------------------------------------ #

# make type preparations
{
    my $Settings;

    # add unpointed test types to config for later tests
    for my $Counter ( 1 .. 49 ) {
        $Settings->{ $TypeNames[$Counter] } = {
            SourceName => 'Normal' . $Counter,
            TargetName => 'Normal' . $Counter,
        };
    }

    # add pointed test types to config for later tests
    for my $Counter ( 50 .. 99 ) {
        $Settings->{ $TypeNames[$Counter] } = {
            SourceName => 'Parent' . $Counter,
            TargetName => 'Child' . $Counter,
        };
    }

    # add new types to config
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::Type',
        Value => $Settings,
    );
}

# make possible link preparations
{

    # add possible link relations for later tests
    my $PossibleLinksConfig = {
        10001 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[1],
            Type    => $TypeNames[1],
        },
        10002 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[1],
            Type    => $TypeNames[50],
        },
        10003 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[1],
            Type    => $TypeNames[3],
        },
        10004 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[1],
        },
        10005 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[60],
        },
        10006 => {
            Object1 => $ObjectNames[2],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[51],
        },
        10007 => {
            Object1 => $ObjectNames[2],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[1],
        },
        10008 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[5],
            Type    => $TypeNames[30],
        },
        10009 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[48],
        },
        10010 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[49],
        },
        10011 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[98],
        },
        10012 => {
            Object1 => $ObjectNames[1],
            Object2 => $ObjectNames[2],
            Type    => $TypeNames[99],
        },
    };

    # create above config settings for later tests
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::PossibleLink',
        Value => $PossibleLinksConfig,
    );

}

# make type group preparations
{

    # add type groups for later tests
    my $TypeGroupConfig = {

        10001 => [
            $TypeNames[49],
            $TypeNames[99],
        ],
        10002 => [
            $TypeNames[48],
            $TypeNames[98],
            $TypeNames[99],
        ],
        10003 => [
            $TypeNames[1],
            $TypeNames[99],
        ],
    };

    # create above config settings for later tests
    $Self->{ConfigObject}->Set(
        Key   => 'LinkObject::TypeGroup',
        Value => $TypeGroupConfig,
    );

}

# build ObjectID hash for later tests
my %ObjectID;
for my $Object (@ObjectNames) {
    $ObjectID{$Object} = $Self->{LinkObject}->ObjectLookup(
        Name   => $Object,
        UserID => 1,
    );
}

my $LinkData = [

    # LinkAdd() needs a SourceObject argument (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => '',
                SourceKey    => 321,
                TargetObject => 'FAQ',
                TargetKey    => '5',
                Type         => 'ParentChild',
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # LinkAdd() needs a SourceKey argument (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => 'Ticket',
                SourceKey    => '',
                TargetObject => 'FAQ',
                TargetKey    => '5',
                Type         => 'ParentChild',
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # LinkAdd() needs a TargetObject argument (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => 'Ticket',
                SourceKey    => '321',
                TargetObject => '',
                TargetKey    => '5',
                Type         => 'ParentChild',
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # LinkAdd() needs a TargetKey argument (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => 'Ticket',
                SourceKey    => '321',
                TargetObject => 'FAQ',
                TargetKey    => '',
                Type         => 'ParentChild',
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # LinkAdd() needs a Type argument (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => 'Ticket',
                SourceKey    => '321',
                TargetObject => 'FAQ',
                TargetKey    => '5',
                Type         => undef,
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # LinkAdd() needs a State argument (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => 'Ticket',
                SourceKey    => '321',
                TargetObject => 'FAQ',
                TargetKey    => '5',
                Type         => 'ParentChild',
                State        => undef,
                UserID       => 1,
            },
        ],
    },

    # LinkAdd() needs a UserID argument (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => 'Ticket',
                SourceKey    => '321',
                TargetObject => 'FAQ',
                TargetKey    => '5',
                Type         => 'ParentChild',
                State        => 'Valid',
                UserID       => undef,
            },
        ],
    },

    # add a link where source and target are the same object (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '1',
                TargetObject => $ObjectNames[1],
                TargetKey    => '1',
                Type         => $TypeNames[1],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # no possible link type can be found for the two objects (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[77],
                SourceKey    => '10',
                TargetObject => $ObjectNames[78],
                TargetKey    => '11',
                Type         => 'Normal',
                State        => 'Dummy',
                UserID       => 1,
            },
        ],
    },

    # add a link
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '1',
                TargetObject => $ObjectNames[1],
                TargetKey    => '2',
                Type         => $TypeNames[1],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '1',
                Type   => $TypeNames[1],
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[1] => {
                    $TypeNames[1] => {
                        Source => {
                            2 => 1,
                        },
                    },
                },
            },
        },
    },

    # add the same link again with same State (check return true)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '1',
                TargetObject => $ObjectNames[1],
                TargetKey    => '2',
                Type         => $TypeNames[1],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '1',
                Type   => $TypeNames[1],
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[1] => {
                    $TypeNames[1] => {
                        Source => {
                            2 => 1,
                        },
                    },
                },
            },
        },
    },

    # add the same link again with different State (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '1',
                TargetObject => $ObjectNames[1],
                TargetKey    => '2',
                Type         => $TypeNames[1],
                State        => 'Temporary',
                UserID       => 1,
            },
        ],
    },

    # try to add a link where no possible link is defined (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '1',
                TargetObject => $ObjectNames[3],
                TargetKey    => '2',
                Type         => $TypeNames[1],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # add a pointed link
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '111',
                TargetObject => $ObjectNames[2],
                TargetKey    => '222',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '111',
                Type   => $TypeNames[60],
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[2] => {
                    $TypeNames[60] => {
                        Target => {
                            222 => 1,
                        },
                    },
                },
            },
        },
    },

    # add some links
    {
        SourceData => [

            # pointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '101',
                TargetObject => $ObjectNames[2],
                TargetKey    => '231',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },

            # pointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '101',
                TargetObject => $ObjectNames[2],
                TargetKey    => '221',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },

            # pointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '101',
                TargetObject => $ObjectNames[2],
                TargetKey    => '201',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },

            # pointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '101',
                TargetObject => $ObjectNames[1],
                TargetKey    => '102',
                Type         => $TypeNames[50],
                State        => 'Valid',
                UserID       => 1,
            },

            # unpointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '101',
                TargetObject => $ObjectNames[1],
                TargetKey    => '103',
                Type         => $TypeNames[1],
                State        => 'Valid',
                UserID       => 1,
            },

            # pointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[2],
                SourceKey    => '999',
                TargetObject => $ObjectNames[1],
                TargetKey    => '101',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },

            # pointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[2],
                SourceKey    => '202',
                TargetObject => $ObjectNames[1],
                TargetKey    => '101',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },

            # unpointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[5],
                SourceKey    => '105',
                TargetObject => $ObjectNames[1],
                TargetKey    => '101',
                Type         => $TypeNames[30],
                State        => 'Valid',
                UserID       => 1,
            },

            # unpointed link
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '101',
                TargetObject => $ObjectNames[5],
                TargetKey    => '103',
                Type         => $TypeNames[30],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => 101,
                Type   => '',
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {

                $ObjectNames[1] => {
                    $TypeNames[50] => {
                        Target => {
                            102 => 1,
                        },
                    },
                    $TypeNames[1] => {
                        Source => {
                            103 => 1,
                        },
                    },
                },
                $ObjectNames[2] => {
                    $TypeNames[60] => {
                        Source => {
                            202 => 1,
                            999 => 1,
                        },
                        Target => {
                            201 => 1,
                            221 => 1,
                            231 => 1,
                        },
                    },
                },
                $ObjectNames[5] => {
                    $TypeNames[30] => {
                        Source => {
                            103 => 1,
                            105 => 1,
                        },
                    },
                },
            },
        },
    },

    # add a link ( test LinkList() with Type option )
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '2000',
                TargetObject => $ObjectNames[2],
                TargetKey    => '3000',
                Type         => $TypeNames[49],
                State        => 'Valid',
                UserID       => 1,
            },
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '2000',
                TargetObject => $ObjectNames[2],
                TargetKey    => '3000',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '2000',
                Type   => $TypeNames[60],
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[2] => {
                    $TypeNames[60] => {
                        Target => {
                            3000 => 1,
                        },
                    },
                },
            },
        },
    },

    # add a link
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '250',
                TargetObject => $ObjectNames[2],
                TargetKey    => '350',
                Type         => $TypeNames[49],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '250',
                Type   => '',
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[2] => {
                    $TypeNames[49] => {
                        Source => {
                            350 => 1,
                        },
                    },
                },
            },
        },
    },

    # add a link which is not allowed by TypeGroup  (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '250',
                TargetObject => $ObjectNames[2],
                TargetKey    => '350',
                Type         => $TypeNames[99],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # add a link
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[2],
                SourceKey    => '500',
                TargetObject => $ObjectNames[1],
                TargetKey    => '400',
                Type         => $TypeNames[48],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '400',
                Type   => '',
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[2] => {
                    $TypeNames[48] => {
                        Source => {
                            500 => 1,
                        },
                    },
                },
            },
        },
    },

    # add a link which is not allowed by TypeGroup (check return false)
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[2],
                SourceKey    => '500',
                TargetObject => $ObjectNames[1],
                TargetKey    => '400',
                Type         => $TypeNames[98],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
    },

    # add an unpointed link
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '555',
                TargetObject => $ObjectNames[2],
                TargetKey    => '666',
                Type         => $TypeNames[48],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '555',
                Type   => '',
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[2] => {
                    $TypeNames[48] => {
                        Source => {
                            666 => 1,
                        },
                    },
                },
            },
        },
    },

    # add a link
    {
        SourceData => [
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '321',
                TargetObject => $ObjectNames[2],
                TargetKey    => '654',
                Type         => $TypeNames[48],
                State        => 'Valid',
                UserID       => 1,
            },
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[1],
                SourceKey    => '321',
                TargetObject => $ObjectNames[2],
                TargetKey    => '655',
                Type         => $TypeNames[49],
                State        => 'Valid',
                UserID       => 1,
            },
            {
                Action       => 'LinkAdd',
                SourceObject => $ObjectNames[2],
                SourceKey    => '777',
                TargetObject => $ObjectNames[1],
                TargetKey    => '321',
                Type         => $TypeNames[60],
                State        => 'Valid',
                UserID       => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '321',
                Type   => '',
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[2] => {
                    $TypeNames[48] => {
                        Source => {
                            654 => 1,
                        },
                    },
                    $TypeNames[60] => {
                        Source => {
                            777 => 1,
                        },
                    },
                    $TypeNames[49] => {
                        Source => {
                            655 => 1,
                        },
                    },
                },
            },
        },
    },

    # delete a link
    {
        SourceData => [
            {
                Action  => 'LinkDelete',
                Object1 => $ObjectNames[1],
                Key1    => '321',
                Object2 => $ObjectNames[2],
                Key2    => '655',
                Type    => $TypeNames[49],
                State   => 'Valid',
                UserID  => 1,
            },
        ],
        ReferenceData => {
            LinkList => {
                Object => $ObjectNames[1],
                Key    => '321',
                Type   => '',
                State  => 'Valid',
                UserID => 1,
            },
            LinkListReference => {
                $ObjectNames[2] => {
                    $TypeNames[48] => {
                        Source => {
                            654 => 1,
                        },
                    },
                    $TypeNames[60] => {
                        Source => {
                            777 => 1,
                        },
                    },
                },
            },
        },
    },
];

# ------------------------------------------------------------ #
# run link tests
# ------------------------------------------------------------ #

LINK:
for my $Test ( @{$LinkData} ) {

    # check SourceData attribute
    if ( !$Test->{SourceData} || ref $Test->{SourceData} ne 'ARRAY' ) {
        $Self->True(
            0,
            "Test $TestCount: No SourceData attribute found for this test.",
        );
        next LINK;
    }

    ACTION:
    for my $SourceData ( @{ $Test->{SourceData} } ) {

        # check Action Attribute
        if ( $SourceData->{Action} ne 'LinkAdd' && $SourceData->{Action} ne 'LinkDelete' ) {
            $Self->True(
                0,
                "Test $TestCount: Unknown Action '$SourceData->{Action}'.",
            );
            next LINK;
        }

        # add link
        my $ActionResult;
        if ( $SourceData->{Action} eq 'LinkAdd' ) {
            $ActionResult = $Self->{LinkObject}->LinkAdd(
                %{$SourceData},
            );
        }

        # delete link
        elsif ( $SourceData->{Action} eq 'LinkDelete' ) {
            $ActionResult = $Self->{LinkObject}->LinkDelete(
                %{$SourceData}
            );
        }

        # next link if no ReferenceData is present
        if ( !$Test->{ReferenceData} || ref $Test->{ReferenceData} ne 'HASH' ) {
            $Self->False(
                $ActionResult,
                "Test $TestCount: $SourceData->{Action}() - return false",
            );
            next ACTION;
        }

        # check if LinkAdd or LinkDelete was successfull
        $Self->True(
            $ActionResult,
            "Test $TestCount: $SourceData->{Action}() - check success",
        );
    }

    # next link if no ReferenceData is present
    next LINK if ( !$Test->{ReferenceData} || ref $Test->{ReferenceData} ne 'HASH' );

    # extract ReferenceData
    my $ReferenceData = $Test->{ReferenceData};

    # check LinkList attribute
    if ( !$ReferenceData->{LinkList} || ref $ReferenceData->{LinkList} ne 'HASH' ) {
        $Self->True(
            0,
            "Test $TestCount: No LinkList attribute found for this test.",
        );
        next LINK;
    }

    # check LinkListReference attribute
    if ( !$ReferenceData->{LinkListReference} || ref $ReferenceData->{LinkListReference} ne 'HASH' )
    {
        $Self->True(
            0,
            "Test $TestCount: No LinkListReference attribute found for this test.",
        );
        next LINK;
    }

    # get all links for ReferenceData
    my $Links = $Self->{LinkObject}->LinkList(
        Object => $ReferenceData->{LinkList}->{Object},
        Key    => $ReferenceData->{LinkList}->{Key},
        Type   => $ReferenceData->{LinkList}->{Type},
        State  => $ReferenceData->{LinkList}->{State},
        UserID => $ReferenceData->{LinkList}->{UserID},
    );

    # turn off all pretty print
    $Data::Dumper::Indent = 0;

    # dump the results from LinkList()
    my $LinksString = Data::Dumper::Dumper($Links);

    # dump the reference data
    my $LinksReferenceString = Data::Dumper::Dumper( $ReferenceData->{LinkListReference} );

    # get objects lists
    my @ReferenceObjects = sort keys %{ $ReferenceData->{LinkListReference} };
    my @LinkObjects      = sort keys %{$Links};

    # check number of objects
    if ( scalar @ReferenceObjects == scalar @LinkObjects ) {

        OBJECT:
        for my $Object (@LinkObjects) {

            my @LinksTypes     = sort keys %{ $Links->{$Object} };
            my @ReferenceTypes = sort keys %{ $ReferenceData->{LinkListReference}->{$Object} };

            # check number of types
            $Self->Is(
                scalar @LinksTypes,
                scalar @ReferenceTypes,
                "Test $TestCount: LinkList()- check number of types",
            );

            TYPE:
            for my $Type (@ReferenceTypes) {

                my @LinksSourceTargetKeys = sort keys %{ $Links->{$Object}->{$Type} };
                my @ReferenceSourceTargetKeys
                    = sort keys %{ $ReferenceData->{LinkListReference}->{$Object}->{$Type} };

                # check number of source target keys
                $Self->Is(
                    scalar @LinksSourceTargetKeys,
                    scalar @ReferenceSourceTargetKeys,
                    "Test $TestCount: LinkList()- check number of source target keys",
                );

                KEY:
                for my $Key (@ReferenceSourceTargetKeys) {

                    my @LinksIDs = sort keys %{ $Links->{$Object}->{$Type}->{$Key} };
                    my @ReferenceIDs
                        = sort
                        keys %{ $ReferenceData->{LinkListReference}->{$Object}->{$Type}->{$Key} };

                    # check number of ids
                    $Self->Is(
                        scalar @LinksIDs,
                        scalar @ReferenceIDs,
                        "Test $TestCount: LinkList()- check number of object ids",
                    );
                }
            }
        }
    }
    else {

        # attributes are different
        $Self->Is(
            $LinksString,
            $LinksReferenceString,
            "Test $TestCount: LinkList()- check number of objects",
        );
    }
}
continue {
    $TestCount++;
}

$Self->True(
    $Self->{LinkObject}->LinkDeleteAll(
        Object => $ObjectNames[1],
        Key    => '321',
        UserID => 1,
    ),
    "Test $TestCount: LinkDeleteAll() - check success",
);

# ------------------------------------------------------------ #
# run link tests
# ------------------------------------------------------------ #

# create needed random object names
for my $Name (@ObjectNames) {

    # create the backend file
    $Self->{MainObject}->FileDelete(
        Directory       => $BackendLocation,
        Filename        => $Name . '.pm',
        DisableWarnings => 1,
    );
}

1;
