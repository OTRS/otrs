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

use Kernel::System::VariableCheck qw(:all);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $RandomID = $Helper->GetRandomID();

my @DynamicFields = (
    {
        Name       => 'TestText' . $RandomID,
        Label      => 'TestText' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'Text',
        ObjectType => 'CustomerUser',
        Config     => {
            DefaultValue => '',
            Link         => '',
        },
        Reorder => 1,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => 'TestDropdown' . $RandomID,
        Label      => 'TestDropdown' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'Dropdown',
        ObjectType => 'CustomerUser',
        Config     => {
            DefaultValue   => '',
            Link           => '',
            PossibleNone   => 0,
            PossibleValues => {
                0 => 'No',
                1 => 'Yes',
            },
            TranslatableValues => 1,
        },
        Reorder => 1,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => 'TestMultiselect' . $RandomID,
        Label      => 'TestMultiselect' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'Multiselect',
        ObjectType => 'CustomerUser',
        Config     => {
            DefaultValue   => '',
            Link           => '',
            PossibleNone   => 0,
            PossibleValues => {
                'a' => 'a',
                'b' => 'b',
                'c' => 'c',
                'd' => 'd',
            },
            TranslatableValues => 1,
        },
        Reorder => 1,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => 'TestDate' . $RandomID,
        Label      => 'TestDate' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'Date',
        ObjectType => 'CustomerUser',
        Config     => {
            DefaultValue  => 0,
            YearsInFuture => 0,
            YearsInPast   => 0,
            YearsPeriod   => 0,
        },
        Reorder => 1,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => 'TestDateTime' . $RandomID,
        Label      => 'TestDateTime' . $RandomID,
        FieldOrder => 9990,
        FieldType  => 'DateTime',
        ObjectType => 'CustomerUser',
        Config     => {
            DefaultValue  => 0,
            YearsInFuture => 0,
            YearsInPast   => 0,
            YearsPeriod   => 0,
        },
        Reorder => 1,
        ValidID => 1,
        UserID  => 1,
    },
);

my @DynamicFieldIDs;
my @DynamicFieldEnhancedSearchFields;

# Create test dynamic field of type date
for my $DynamicField (@DynamicFields) {

    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicField},
    );

    $Self->True(
        $DynamicFieldID,
        "Dynamic field $DynamicField->{Name} - ID $DynamicFieldID - created",
    );

    push @DynamicFieldIDs,                  $DynamicFieldID;
    push @DynamicFieldEnhancedSearchFields, 'DynamicField_' . $DynamicField->{Name};

    push @{ $ConfigObject->{CustomerUser}->{Map} }, [
        'DynamicField_' . $DynamicField->{Name}, undef, $DynamicField->{Name}, 0, 0, 'dynamic_field', undef, 0,
    ];
}

$ConfigObject->{CustomerUser}->{Selections} = {
    UserTitle => {
        'Mr.'  => 'Mr.',
        'Mrs.' => 'Mrs.',
    },
    UserCountry => {
        'Austria'       => 'Austria',
        'Belgium'       => 'Belgium',
        'Germany'       => 'Germany',
        'United States' => 'United States',
    },
};

my %ReferenceCustomerUserSearchFields = (
    UserLogin => {
        DatabaseField => 'login',
        Name          => 'UserLogin',
        Label         => 'Username',
        Type          => 'Input',
        StorageType   => 'var',
    },
    UserCountry => {
        DatabaseField  => 'country',
        Name           => 'UserCountry',
        Label          => 'Country',
        Type           => 'Selection',
        SelectionsData => {
            'Austria'       => 'Austria',
            'Belgium'       => 'Belgium',
            'Germany'       => 'Germany',
            'United States' => 'United States',
        },
        StorageType => 'var',
    },
);

my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my @CustomerUserSearchFields       = $CustomerUserObject->CustomerUserSearchFields();
my %LookupCustomerUserSearchFields = map { $_->{Name} => $_ } @CustomerUserSearchFields;

for my $FieldName ( sort keys %ReferenceCustomerUserSearchFields ) {

    $Self->IsDeeply(
        $LookupCustomerUserSearchFields{$FieldName},
        $ReferenceCustomerUserSearchFields{$FieldName},
        "Test CustomerCompanySearchFields() - $FieldName."
    );
}

my $UserRand = 'Search-Customer-User' . $RandomID;

my @CustomerLogins;
my %CustomerLoginForSearchTest;

my @CustomerUserTests = (
    {
        CustomerUserData => {
            Source         => 'CustomerUser',
            UserFirstname  => 'Firstname Test1',
            UserLastname   => 'Lastname Test1',
            UserCustomerID => $UserRand . '-1-Customer-Id',
            UserLogin      => $UserRand . '-1',
            UserEmail      => $UserRand . '-1-Email@example.com',
            UserPassword   => 'some_pass',
            UserTitle      => 'Mr.',
            UserCountry    => 'Germany',
            ValidID        => 1,
            UserID         => 1,
        },
        CustomerUserDynamicFieldData => {
            $DynamicFieldIDs[0] => 'Example text',
            $DynamicFieldIDs[1] => 1,
            $DynamicFieldIDs[2] => [ 'a', ],
            $DynamicFieldIDs[3] => '2016-09-18 00:00:00',
        },
        SearchTest => [ 2, 3, 4, 5, 7, 8, 9, 14, 16, 17, 19, 20, 23, ],
    },
    {
        CustomerUserData => {
            Source         => 'CustomerUser',
            UserFirstname  => 'Firstname Test2',
            UserLastname   => 'Lastname Test2',
            UserCustomerID => $UserRand . '-2-Customer-Id',
            UserLogin      => $UserRand . '-2',
            UserEmail      => $UserRand . '-2-Email@example.com',
            UserPassword   => 'some_pass',
            UserTitle      => 'Mrs.',
            UserCountry    => 'Austria',
            ValidID        => 1,
            UserID         => 1,
        },
        CustomerUserDynamicFieldData => {
            $DynamicFieldIDs[0] => 'Example 123 text',
            $DynamicFieldIDs[1] => 1,
            $DynamicFieldIDs[2] => [ 'a', 'b', ],
            $DynamicFieldIDs[3] => '2016-10-01 00:00:00',
            $DynamicFieldIDs[4] => '2016-10-01 08:00:00',
        },
        SearchTest => [ 2, 3, 4, 5, 7, 8, 10, 14, 17, 19, 20, 22, 26, 29, ],
    },
    {
        CustomerUserData => {
            Source         => 'CustomerUser',
            UserFirstname  => 'Firstname Test3',
            UserLastname   => 'Lastname Test3',
            UserCustomerID => $UserRand . '-3-Customer-Id',
            UserLogin      => $UserRand . '-3',
            UserEmail      => $UserRand . '-3-Email@example.com',
            UserPassword   => 'some_pass',
            UserTitle      => 'Mrs.',
            UserCountry    => 'Germany',
            ValidID        => 1,
            UserID         => 1,
        },
        CustomerUserDynamicFieldData => {
            $DynamicFieldIDs[0] => 'A Example text',
            $DynamicFieldIDs[1] => 0,
            $DynamicFieldIDs[2] => [ 'c', 'd', ],
            $DynamicFieldIDs[3] => '2016-09-20 00:00:00',
            $DynamicFieldIDs[4] => '2016-10-01 10:00:00',
        },
        SearchTest => [ 2, 3, 4, 5, 7, 8, 11, 15, 16, 18, 19, 21, 24, 25, 26, 27, 28, ],
    },
    {
        CustomerUserData => {
            Source         => 'CustomerUser',
            UserFirstname  => 'John Test4',
            UserLastname   => 'Doe Test4',
            UserCustomerID => $UserRand . '-4-Customer-Id',
            UserLogin      => $UserRand . '-4',
            UserEmail      => $UserRand . '-4-Email@example.com',
            UserPassword   => 'some_pass',
            UserTitle      => 'Mr.',
            UserCountry    => 'United States',
            ValidID        => 1,
            UserID         => 1,
        },
        CustomerUserDynamicFieldData => {
            $DynamicFieldIDs[1] => 0,
            $DynamicFieldIDs[2] => [ 'a', 'b', 'c', 'd', ],
            $DynamicFieldIDs[4] => '2016-10-01 18:00:00',
        },
        SearchTest => [ 2, 3, 6, 7, 9, 11, 18, 19, 20, 21, 25, ],
    },
);

my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

for my $CustomerUser (@CustomerUserTests) {

    my $UserLogin = $CustomerUserObject->CustomerUserAdd(
        %{ $CustomerUser->{CustomerUserData} }
    );

    push @CustomerLogins, $UserLogin;

    $Self->True(
        $UserLogin,
        "CustomerUserAdd() - $UserLogin",
    );

    if ( IsHashRefWithData( $CustomerUser->{CustomerUserDynamicFieldData} ) ) {

        for my $DynamicFieldID ( sort keys %{ $CustomerUser->{CustomerUserDynamicFieldData} } ) {

            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFieldID,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectName         => $UserLogin,
                Value              => $CustomerUser->{CustomerUserDynamicFieldData}->{$DynamicFieldID},
                UserID             => 1,
            );
        }
    }

    # save customer user id for use in search tests
    if ( exists $CustomerUser->{SearchTest} ) {
        my @SearchTests = @{ $CustomerUser->{SearchTest} };

        for my $SearchTestNr (@SearchTests) {
            $CustomerLoginForSearchTest{$SearchTestNr}->{$UserLogin} = 1;
        }
    }
}

# -------------------------------------------------------------------------------
# run SearchDetail tests
# -------------------------------------------------------------------------------

my @SearchTests = (

    # Nr 1 - a simple check if the search functions takes care of "Limit".
    {
        Description => 'Limit',
        SearchData  => {
            Limit => 3,    # expect only 3 results
        },
        ResultData => {
            TestCount => 1,    # flag for check result amount
            Count     => 3,    # check on 3 results
        },
    },

    # Nr 2 - search for all added customer user for the search test per UserLogin.
    {
        Description => 'UserLogin',
        SearchData  => {
            UserLogin => $UserRand . '*',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 3 - search for all added customer user for the search test per UserEmail.
    {
        Description => 'UserEmail',
        SearchData  => {
            UserEmail => $UserRand . '*',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 4 - search for added customer user for the search test per UserFirstname.
    {
        Description => 'UserFirstname',
        SearchData  => {
            UserLogin     => $UserRand . '*',
            UserFirstname => 'Firstname*',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 5 - search for added customer user for the search test per UserLastname.
    {
        Description => 'UserLastname',
        SearchData  => {
            UserLogin    => $UserRand . '*',
            UserLastname => 'Lastname*',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 6 - search for added customer user for the search test per UserLastname and UserFirstname.
    {
        Description => 'UserLastname and UserFirstname',
        SearchData  => {
            UserLogin     => $UserRand . '*',
            UserLastname  => 'Doe Test4',
            UserFirstname => 'John Test4',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 7 - search for added customer user for the search test per UserCustomerID.
    {
        Description => 'UserCustomerID',
        SearchData  => {
            UserCustomerID => $UserRand . '*',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 8 - search for added customer user for the search test per UserCountry (Array-Field).
    {
        Description => 'UserCountry (Selection-Field)',
        SearchData  => {
            UserLogin   => $UserRand . '*',
            UserCountry => [ 'Germany', 'Austria', ],
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 9 - search for added customer user for the search test per UserTitle (Array-Field).
    {
        Description => 'UserTitle (Selection-Field)',
        SearchData  => {
            UserLogin => $UserRand . '*',
            UserTitle => [ 'Mr.', ],
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 10 - search for added customer user for the search test per UserTitle and UserCountry (Array-Field).
    {
        Description => 'UserTitle (Selection-Field) and UserCountry (Selection-Field)',
        SearchData  => {
            UserLogin   => $UserRand . '*',
            UserTitle   => [ 'Mrs.', ],
            UserCountry => [ 'Austria', ],
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 11 - search for added customer user for the search test per UserEmail
    #   and ExcludeUserLogins (to exluce some customer user).
    {
        Description => 'UserEmail and ExcludeUserLogins',
        SearchData  => {
            UserEmail         => $UserRand . '*',
            ExcludeUserLogins => [ $CustomerLogins[0], $CustomerLogins[1] ],
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 12 - search for invalid country.
    {
        Description => 'Search for invalid country',
        SearchData  => {
            UserLogin   => $UserRand . '*',
            UserCountry => [ 'Unknown', ],
        },
        SearchFails => 1,
    },

    # Nr 13 - search which should find no customer user.
    {
        Description => 'Search which should find no customer user',
        SearchData  => {
            UserLogin => $UserRand . '-Unknown123456789',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 14 - search for customer user with the value 'Example*' in the text dynamic field.
    {
        Description => "Search for $DynamicFields[0]->{Name} with string 'Example*'",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[0] => {
                Like => 'Example*',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 15 - search for customer user with the value 'A Example text' in the text dynamic field.
    {
        Description => "Search for $DynamicFields[0]->{Name} with string 'A Example text'",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[0] => {
                Equals => 'A Example text',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

# Nr 16 - search for customer user with the strings 'A Example text' and string 'Example text' in the text dynamic field.
    {
        Description => "Search for $DynamicFields[0]->{Name} with string 'A Example text' and string 'Example text'",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[0] => {
                Equals => [ 'A Example text', 'Example text' ],
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 17 - search for customer user with the vaule '1' in the select field.
    {
        Description => "Search for $DynamicFields[1]->{Name} with the value '1' (select field)",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[1] => {
                Equals => 1,
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 18 - search for customer user with the vaule '0' in the select field.
    {
        Description => "Search for $DynamicFields[1]->{Name} with the value '0' (select field)",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[1] => {
                Equals => 0,
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 19 - search for customer user with the vaule '0' or '1' in the select field.
    {
        Description => "Search for $DynamicFields[1]->{Name} with the value '0' or '1' (select field)",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[1] => {
                Equals => [ 0, 1, ],
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 20 - search for customer user with the vaule 'a' or 'b' in multi select field.
    {
        Description => "Search for $DynamicFields[2]->{Name} with the value 'a' or 'b' (multi select field)",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[2] => {
                Equals => [ 'a', 'b', ],
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 21 - search for customer user with the vaule 'd' in multi select field.
    {
        Description => "Search for $DynamicFields[2]->{Name} with the value 'd' (multi select field)",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[2] => {
                Equals => 'd',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 22 - search for customer user with the date greater than '2016-09-20'.
    {
        Description => "Search for $DynamicFields[3]->{Name} with the date greater than '2016-09-20'",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[3] => {
                GreaterThan => '2016-09-21 00:00:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 23 - search for customer user with the date greater than '2016-09-20'.
    {
        Description => "Search for $DynamicFields[3]->{Name} with the date smaller than '2016-09-20'",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[3] => {
                SmallerThan => '2016-09-20 00:00:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 24 - search for customer user with the date greater than '2016-09-19' and smaller than '2016-09-21'.
    {
        Description =>
            "Search for $DynamicFields[3]->{Name} with the date greater than '2016-09-19' and smaller than '2016-09-21'",
        SearchData => {
            $DynamicFieldEnhancedSearchFields[3] => {
                GreaterThan => '2016-09-19 00:00:00',
                SmallerThan => '2016-09-21 00:00:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 25 - search for customer user with the date greater than equals '2016-10-01 10:00:00'.
    {
        Description => "Search for $DynamicFields[4]->{Name} with the date greater than equals '2016-10-01 10:00:00'",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[4] => {
                GreaterThanEquals => '2016-10-01 10:00:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 26 - search for customer user with the date smaller than equals '2016-10-01 10:00:00'.
    {
        Description => "Search for $DynamicFields[4]->{Name} with the date smaller than equals '2016-10-01 10:00:00'",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[4] => {
                SmallerThanEquals => '2016-10-01 10:00:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 27 - search for customer user with the date greater than equals '2016-10-01 08:01:00'
    #   and smaller than equals '016-09-21 10:00:00'.
    {
        Description =>
            "Search for $DynamicFields[4]->{Name} with the date greater than equals '2016-10-01 08:01:00' and smaller than equals '2016-09-21 10:00:00'",
        SearchData => {
            $DynamicFieldEnhancedSearchFields[4] => {
                GreaterThanEquals => '2016-10-01 08:01:00',
                SmallerThanEquals => '2016-10-01 10:00:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 28 - search for customer user with the date greater than equals '2016-10-01 08:01:00'
    #   and smaller than equals '016-09-21 10:00:00 and vaule '0' in the select field.'.
    {
        Description =>
            "Search for $DynamicFields[4]->{Name} with the date greater than equals '2016-10-01 08:01:00' and smaller than equals '2016-09-21 10:00:00' and $DynamicFields[1]->{Name} vaule '0' in the select field.",
        SearchData => {
            $DynamicFieldEnhancedSearchFields[1] => {
                Equals => 0,
            },
            $DynamicFieldEnhancedSearchFields[4] => {
                GreaterThanEquals => '2016-10-01 08:01:00',
                SmallerThanEquals => '2016-10-01 10:00:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 29 - search for customer user with the all dynamic fields.
    {
        Description => "Search for with all dynamic fields as filter",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[0] => {
                Like => 'Example*',
            },
            $DynamicFieldEnhancedSearchFields[1] => {
                Equals => 1,
            },
            $DynamicFieldEnhancedSearchFields[2] => {
                Equals => 'b',
            },
            $DynamicFieldEnhancedSearchFields[3] => {
                GreaterThanEquals => '2016-10-01 00:00:00',
            },
            $DynamicFieldEnhancedSearchFields[4] => {
                GreaterThanEquals => '2016-10-01 07:30:00',
                SmallerThanEquals => '2016-10-01 18:30:00',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 30 - search for customer user with the vaule 'e' which not exists.
    {
        Description => "Search for $DynamicFields[2]->{Name} with the vaule 'e' which not exists",
        SearchData  => {
            $DynamicFieldEnhancedSearchFields[2] => {
                Equals => 'e',
            },
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },
);

my $TestCount = 1;

SEARCHTEST:
for my $Test (@SearchTests) {

    # check SearchData attribute
    if ( !$Test->{SearchData} || ref( $Test->{SearchData} ) ne 'HASH' ) {
        $Self->True(
            0,
            "Test $TestCount: SearchData found for this test.",
        );

        next SEARCHTEST;
    }

    $Self->True(
        1,
        "Test $TestCount: CustomerSearchDetail() with params: $Test->{Description}",
    );

    # get a ref to an array of found ids
    my $CustomerUserIDs = $CustomerUserObject->CustomerSearchDetail(
        %{ $Test->{SearchData} },
        Result => 'ARRAY',
        UserID => 1,
    );

    # get a count of found ids
    my $CountCustomerUserIDs = $CustomerUserObject->CustomerSearchDetail(
        %{ $Test->{SearchData} },
        Result => 'COUNT',
        UserID => 1,
    );

    if ( $Test->{SearchFails} ) {

        $Self->True(
            !defined $CustomerUserIDs,
            "Test $TestCount: CustomerSearchDetail() is expected to fail (Result => 'ARRAY')",
        );
        $Self->True(
            !defined $CountCustomerUserIDs,
            "Test $TestCount: CustomerSearchDetail() is expected to fail (Result => 'COUNT')",
        );
    }
    else {

        $Self->True(
            defined $CustomerUserIDs && ref $CustomerUserIDs eq 'ARRAY',
            "Test $TestCount: |- array ref for CustomerUserIDs.",
        );
        $Self->True(
            defined $CountCustomerUserIDs && ref $CountCustomerUserIDs eq '',
            "Test $TestCount: |- scalar for CountCustomerUserIDs.",
        );
    }

    $CountCustomerUserIDs ||= 0;

    if ( $Test->{ResultData}->{TestCount} ) {

        # get number of customer user ids CustomerSearchDetail should return
        my $ExpectedCount = scalar keys %{ $CustomerLoginForSearchTest{$TestCount} };

        # get defined expected result count (defined in search test case!)
        if ( exists $Test->{ResultData}->{Count} ) {
            $ExpectedCount = $Test->{ResultData}->{Count};
        }

        # check the number of customer user in the returned arrayref
        $Self->Is(
            scalar @{$CustomerUserIDs},
            $ExpectedCount,
            "Test $TestCount: |- Number of found customer user (Result => 'ARRAY').",
        );

        # When a 'Limit' has been passed, then the returned count not necessarily matches
        # the number of IDs in the returned array. In that case testing is futile.
        if ( !$Test->{SearchData}->{Limit} ) {
            $Self->Is(
                $CountCustomerUserIDs,
                $ExpectedCount,
                "Test $TestCount: |- Number of found customer users (Result => 'COUNT').",
            );
        }
    }

    if ( $Test->{ResultData}->{TestExistence} ) {

        # check if all ids that belongs to this searchtest are returned
        my @ReferenceCustomerUserLogins = keys %{ $CustomerLoginForSearchTest{$TestCount} };
        my %ReturnedCustomerUserIDs     = map { $_ => 1 } @{$CustomerUserIDs};
        for my $CustomerUserLogin (@ReferenceCustomerUserLogins) {
            $Self->True(
                $ReturnedCustomerUserIDs{$CustomerUserLogin},
                "Test $TestCount: |- CustomerUserLogin $CustomerUserLogin found in returned list.",
            );
        }
    }
}
continue {
    $TestCount++;
}

# -------------------------------------------------------------------------------
# define customer user search details tests for 'OrderBy' searches
# -------------------------------------------------------------------------------

my @OrderBySearchTestCustomerLogins;

for my $CustomerLoginForOrderByTests (@CustomerLogins) {
    my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
        User => $CustomerLoginForOrderByTests,
    );
    push @OrderBySearchTestCustomerLogins, \%CustomerUserData;
}

my @OrderByColumns = qw(
    UserLogin
    UserFirstname
    UserLastname
    UserEmail
    UserTitle
    UserCountry
    UserCustomerID
);

for my $OrderByColumn (@OrderByColumns) {

    my @SortedCustomerLogins
        = sort { $a->{$OrderByColumn} cmp $b->{$OrderByColumn} || $b->{UserLogin} cmp $a->{UserLogin} }
        @OrderBySearchTestCustomerLogins;
    my @ReferenceSortedIDs = map { $_->{UserLogin} } @SortedCustomerLogins;

    my $CustomerUserIDs = $CustomerUserObject->CustomerSearchDetail(
        UserLogin        => $UserRand . '*',
        OrderBy          => [$OrderByColumn],
        OrderByDirection => ['Up'],
    );

    $Self->IsDeeply(
        $CustomerUserIDs,
        \@ReferenceSortedIDs,
        "Test $TestCount: CustomerSearchDetail() OrderBy $OrderByColumn (Up)."
    );

    my @SortedCustomerLoginsDown
        = sort { $b->{$OrderByColumn} cmp $a->{$OrderByColumn} || $b->{UserLogin} cmp $a->{UserLogin} }
        @OrderBySearchTestCustomerLogins;
    my @ReferenceSortedIDsDown = map { $_->{UserLogin} } @SortedCustomerLoginsDown;

    my $CustomerUserIDsDown = $CustomerUserObject->CustomerSearchDetail(
        UserLogin => $UserRand . '*',
        OrderBy   => [$OrderByColumn],
    );

    $Self->IsDeeply(
        $CustomerUserIDsDown,
        \@ReferenceSortedIDsDown,
        "Test $TestCount: CustomerSearchDetail() OrderBy $OrderByColumn (Down)."
    );

    # check if non-existent OrderByDirection criteria were handeled correct
    my $CustomerUserIDsSideways = $CustomerUserObject->CustomerSearchDetail(
        UserLogin        => $UserRand . '*',
        OrderBy          => [$OrderByColumn],
        OrderByDirection => ['Sideways'],
        UserID           => 1,
    );

    $Self->Is(
        $CustomerUserIDsSideways,
        undef,
        "Test $TestCount: CustomerSearchDetail() OrderBy $OrderByColumn (Sideways)."
    );
}
continue {
    $TestCount++;
}

# -------------------------------------------------------------------------------------------
# define special customer user search details tests for CustomerCompanySearchCustomerIDs
# -------------------------------------------------------------------------------------------

# add a customer company
my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
    CustomerID             => $UserRand,
    CustomerCompanyName    => $UserRand . ' Inc',
    CustomerCompanyStreet  => 'Some Street',
    CustomerCompanyZIP     => '12345',
    CustomerCompanyCity    => 'Some city',
    CustomerCompanyCountry => 'USA',
    CustomerCompanyURL     => 'http://example.com',
    CustomerCompanyComment => 'some comment',
    ValidID                => 1,
    UserID                 => 1,
);

# update one customer user with the new customer company id
my $Update = $CustomerUserObject->CustomerUserUpdate(
    ID             => $UserRand . '-1',
    UserFirstname  => 'Firstname Test1',
    UserLastname   => 'Lastname Test1',
    UserCustomerID => $CustomerCompanyID,
    UserLogin      => $UserRand . '-1',
    UserEmail      => $UserRand . '-1-Email@example.com',
    UserPassword   => 'some_pass',
    UserTitle      => 'Mr.',
    UserCountry    => 'Germany',
    ValidID        => 1,
    UserID         => 1,
);

my $ReferenceCustomerUserLogins = [ $CustomerLogins[0] ];

# get a ref to an array of found ids
my $CustomerUserLogins = $CustomerUserObject->CustomerSearchDetail(
    CustomerCompanySearchCustomerIDs => [$CustomerCompanyID],
    Result                           => 'ARRAY',
    UserID                           => 1,
);

$Self->IsDeeply(
    $CustomerUserLogins,
    $ReferenceCustomerUserLogins,
    "Test $TestCount: CustomerSearchDetail() special param 'CustomerCompanySearchCustomerIDs'."
);

# get a ref to an array of found ids
$CustomerUserLogins = $CustomerUserObject->CustomerSearchDetail(
    CustomerCompanySearchCustomerIDs => [ $CustomerCompanyID, 1 .. 1000 ],
    Result                           => 'ARRAY',
    UserID                           => 1,
);

$Self->IsDeeply(
    $CustomerUserLogins,
    $ReferenceCustomerUserLogins,
    "Test $TestCount: CustomerSearchDetail() special param 'CustomerCompanySearchCustomerIDs' (with more then 1000 values)."
);

1;
