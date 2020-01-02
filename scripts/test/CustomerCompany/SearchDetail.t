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
        ObjectType => 'CustomerCompany',
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
        ObjectType => 'CustomerCompany',
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
        ObjectType => 'CustomerCompany',
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
        ObjectType => 'CustomerCompany',
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
        ObjectType => 'CustomerCompany',
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

    push @{ $ConfigObject->{CustomerCompany}->{Map} }, [
        'DynamicField_' . $DynamicField->{Name}, undef, $DynamicField->{Name}, 0, 0, 'dynamic_field', undef, 0,
    ];
}

$ConfigObject->{CustomerCompany}->{Selections} = {
    CustomerCompanyCountry => {
        'Austria'       => 'Austria',
        'Belgium'       => 'Belgium',
        'Germany'       => 'Germany',
        'United States' => 'United States',
    },
};

my %ReferenceCustomerCompanySearchFields = (
    CustomerID => {
        DatabaseField => 'customer_id',
        Name          => 'CustomerID',
        Label         => 'CustomerID',
        Type          => 'Input',
        StorageType   => 'var',
    },
    CustomerCompanyName => {
        DatabaseField => 'name',
        Name          => 'CustomerCompanyName',
        Label         => 'Customer',
        Type          => 'Input',
        StorageType   => 'var',
    },
    CustomerCompanyCountry => {
        DatabaseField  => 'country',
        Name           => 'CustomerCompanyCountry',
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

my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

my @CustomerCompanySearchFields       = $CustomerCompanyObject->CustomerCompanySearchFields();
my %LookupCustomerCompanySearchFields = map { $_->{Name} => $_ } @CustomerCompanySearchFields;

for my $FieldName ( sort keys %ReferenceCustomerCompanySearchFields ) {

    $Self->IsDeeply(
        $LookupCustomerCompanySearchFields{$FieldName},
        $ReferenceCustomerCompanySearchFields{$FieldName},
        "Test CustomerCompanySearchFields() - $FieldName."
    );
}

my $CompanyRand = 'search.customer.company-' . $RandomID;

my @CustomerCompanies;
my %CustomerCompanyiesForSearchTest;

my @CustomerCompanyTests = (
    {
        CustomerCompanyData => {
            CustomerID             => $CompanyRand . ' Test1',
            CustomerCompanyName    => $CompanyRand . ' Test1 Inc',
            CustomerCompanyStreet  => 'Some Street',
            CustomerCompanyZIP     => '12345',
            CustomerCompanyCity    => 'Some city',
            CustomerCompanyCountry => 'Germany',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => 1,
        },
        CustomerCompanyDynamicFieldData => {
            $DynamicFieldIDs[0] => 'Example text',
            $DynamicFieldIDs[1] => 1,
            $DynamicFieldIDs[2] => [ 'a', ],
            $DynamicFieldIDs[3] => '2016-09-18 00:00:00',
        },
        SearchTest => [ 2, 3, 4, 6, 9, 11, 12, 14, 15, 18, ],
    },
    {
        CustomerCompanyData => {
            CustomerID             => $CompanyRand . ' Test2',
            CustomerCompanyName    => $CompanyRand . ' Test2 Inc',
            CustomerCompanyStreet  => 'Some Street',
            CustomerCompanyZIP     => '12345',
            CustomerCompanyCity    => 'Some city',
            CustomerCompanyCountry => 'Germany',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => 1,
        },
        CustomerCompanyDynamicFieldData => {
            $DynamicFieldIDs[0] => 'Example 123 text',
            $DynamicFieldIDs[1] => 1,
            $DynamicFieldIDs[2] => [ 'a', 'b', ],
            $DynamicFieldIDs[3] => '2016-10-01 00:00:00',
            $DynamicFieldIDs[4] => '2016-10-01 08:00:00',
        },
        SearchTest => [ 2, 3, 4, 6, 9, 12, 14, 15, 17, 21, 24, ],
    },
    {
        CustomerCompanyData => {
            CustomerID             => $CompanyRand . ' Test3',
            CustomerCompanyName    => $CompanyRand . ' Test3 Inc',
            CustomerCompanyStreet  => 'Some Street',
            CustomerCompanyZIP     => '12345',
            CustomerCompanyCity    => 'Some city',
            CustomerCompanyCountry => 'Austria',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => 1,
        },
        CustomerCompanyDynamicFieldData => {
            $DynamicFieldIDs[0] => 'A Example text',
            $DynamicFieldIDs[1] => 0,
            $DynamicFieldIDs[2] => [ 'c', 'd', ],
            $DynamicFieldIDs[3] => '2016-09-20 00:00:00',
            $DynamicFieldIDs[4] => '2016-10-01 10:00:00',
        },
        SearchTest => [ 2, 3, 4, 10, 11, 13, 14, 16, 19, 20, 21, 22, 23, ],
    },
    {
        CustomerCompanyData => {
            CustomerID             => $CompanyRand . ' Test4',
            CustomerCompanyName    => $CompanyRand . ' Test4 Inc',
            CustomerCompanyStreet  => 'Other Street',
            CustomerCompanyZIP     => '54321',
            CustomerCompanyCity    => 'Some city',
            CustomerCompanyCountry => 'United States',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => 1,
        },
        CustomerCompanyDynamicFieldData => {
            $DynamicFieldIDs[1] => 0,
            $DynamicFieldIDs[2] => [ 'a', 'b', 'c', 'd', ],
            $DynamicFieldIDs[4] => '2016-10-01 18:00:00',
        },
        SearchTest => [ 2, 3, 5, 6, 13, 14, 15, 16, 20, ],
    },
);

my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

for my $CustomerCompany (@CustomerCompanyTests) {

    my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
        %{ $CustomerCompany->{CustomerCompanyData} }
    );

    push @CustomerCompanies, $CustomerCompanyID;

    $Self->True(
        $CustomerCompanyID,
        "CustomerCompanyAdd() - $CustomerCompanyID",
    );

    if ( IsHashRefWithData( $CustomerCompany->{CustomerCompanyDynamicFieldData} ) ) {

        for my $DynamicFieldID ( sort keys %{ $CustomerCompany->{CustomerCompanyDynamicFieldData} } ) {

            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFieldID,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectName         => $CustomerCompanyID,
                Value              => $CustomerCompany->{CustomerCompanyDynamicFieldData}->{$DynamicFieldID},
                UserID             => 1,
            );
        }
    }

    # save customer company id for use in search tests
    if ( exists $CustomerCompany->{SearchTest} ) {
        my @SearchTests = @{ $CustomerCompany->{SearchTest} };

        for my $SearchTestNr (@SearchTests) {
            $CustomerCompanyiesForSearchTest{$SearchTestNr}->{$CustomerCompanyID} = 1;
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

    # Nr 2 - search for all added customer companies for the search test per CustomerID.
    {
        Description => 'CustomerID',
        SearchData  => {
            CustomerID => $CompanyRand . '*',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 3 - search for all added customer companies for the search test per CustomerCompanyName.
    {
        Description => 'CustomerCompanyName',
        SearchData  => {
            CustomerCompanyName => $CompanyRand . '*',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 4 - search for all added customer companies for the search test per CustomerCompanyStreet.
    {
        Description => 'CustomerCompanyStreet',
        SearchData  => {
            CustomerID            => $CompanyRand . '*',
            CustomerCompanyStreet => 'Some Street',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 5 - search for all added customer companies for the search test per CustomerCompanyZIP.
    {
        Description => 'CustomerCompanyZIP',
        SearchData  => {
            CustomerID         => $CompanyRand . '*',
            CustomerCompanyZIP => '54321',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 6 - search for all added customer companies for the search test per CustomerCompanyCountry.
    {
        Description => 'CustomerCompanyCountry',
        SearchData  => {
            CustomerID             => $CompanyRand . '*',
            CustomerCompanyCountry => [ 'Germany', 'United States', ],
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 7 - search for invalid customer company country.
    {
        Description => 'Search for invalid company country',
        SearchData  => {
            CustomerID             => $CompanyRand . '*',
            CustomerCompanyCountry => [ 'Unknown', ],
        },
        SearchFails => 1,
    },

    # Nr 8 - search which should find no customer company.
    {
        Description => 'Search which should find no customer company',
        SearchData  => {
            CustomerID => $CompanyRand . '-Unknown123456789',
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 9 - search for customer companies with the value 'Example*' in the text dynamic field.
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

    # Nr 10 - search for customer companies with the value 'A Example text' in the text dynamic field.
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

# Nr 11 - search for customer companies with the strings 'A Example text' and string 'Example text' in the text dynamic field.
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

    # Nr 12 - search for customer companies with the vaule '1' in the select field.
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

    # Nr 13 - search for customer companies with the vaule '0' in the select field.
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

    # Nr 14 - search for customer companies with the vaule '0' or '1' in the select field.
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

    # Nr 15 - search for customer companies with the vaule 'a' or 'b' in multi select field.
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

    # Nr 16 - search for customer companies with the vaule 'd' in multi select field.
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

    # Nr 17 - search for customer companies with the date greater than '2016-09-20'.
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

    # Nr 18 - search for customer companies with the date greater than '2016-09-20'.
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

    # Nr 19 - search for customer companies with the date greater than '2016-09-19' and smaller than '2016-09-21'.
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

    # Nr 20 - search for customer companies with the date greater than equals '2016-10-01 10:00:00'.
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

    # Nr 21 - search for customer companies with the date smaller than equals '2016-10-01 10:00:00'.
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

    # Nr 22 - search for customer companies with the date greater than equals '2016-10-01 08:01:00'
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

    # Nr 23 - search for customer companies with the date greater than equals '2016-10-01 08:01:00'
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

    # Nr 24 - search for customer companies with the all dynamic fields.
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

    # Nr 25 - search for customer companies with the vaule 'e' which not exists.
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
        "Test $TestCount: CustomerCompanySearchDetail() with params: $Test->{Description}",
    );

    # get a ref to an array of found ids
    my $CustomerCompanyIDs = $CustomerCompanyObject->CustomerCompanySearchDetail(
        %{ $Test->{SearchData} },
        Result => 'ARRAY',
        UserID => 1,
    );

    # get a count of found ids
    my $CountCustomerCompanyIDs = $CustomerCompanyObject->CustomerCompanySearchDetail(
        %{ $Test->{SearchData} },
        Result => 'COUNT',
        UserID => 1,
    );

    if ( $Test->{SearchFails} ) {

        $Self->True(
            !defined $CustomerCompanyIDs,
            "Test $TestCount: CustomerCompanySearchDetail() is expected to fail (Result => 'ARRAY')",
        );
        $Self->True(
            !defined $CountCustomerCompanyIDs,
            "Test $TestCount: CustomerCompanySearchDetail() is expected to fail (Result => 'COUNT')",
        );
    }
    else {

        $Self->True(
            defined $CustomerCompanyIDs && ref $CustomerCompanyIDs eq 'ARRAY',
            "Test $TestCount: |- array ref for CustomerCompanyIDs.",
        );
        $Self->True(
            defined $CountCustomerCompanyIDs && ref $CountCustomerCompanyIDs eq '',
            "Test $TestCount: |- scalar for CountCustomerCompanyIDs.",
        );
    }

    $CountCustomerCompanyIDs ||= 0;

    if ( $Test->{ResultData}->{TestCount} ) {

        # get number of customer company ids CustomerCompanySearchDetail should return
        my $ExpectedCount = scalar keys %{ $CustomerCompanyiesForSearchTest{$TestCount} };

        # get defined expected result count (defined in search test case!)
        if ( exists $Test->{ResultData}->{Count} ) {
            $ExpectedCount = $Test->{ResultData}->{Count};
        }

        # check the number of customer company in the returned arrayref
        $Self->Is(
            scalar @{$CustomerCompanyIDs},
            $ExpectedCount,
            "Test $TestCount: |- Number of found customer companies (Result => 'ARRAY').",
        );

        # When a 'Limit' has been passed, then the returned count not necessarily matches
        # the number of IDs in the returned array. In that case testing is futile.
        if ( !$Test->{SearchData}->{Limit} ) {
            $Self->Is(
                $CountCustomerCompanyIDs,
                $ExpectedCount,
                "Test $TestCount: |- Number of found customer companies (Result => 'COUNT').",
            );
        }
    }

    if ( $Test->{ResultData}->{TestExistence} ) {

        # check if all ids that belongs to this searchtest are returned
        my @ReferenceCustomerCompanyIDs = keys %{ $CustomerCompanyiesForSearchTest{$TestCount} };
        my %ReturnedCustomerCompanyIDs  = map { $_ => 1 } @{$CustomerCompanyIDs};
        for my $CustomerCompany (@ReferenceCustomerCompanyIDs) {
            $Self->True(
                $ReturnedCustomerCompanyIDs{$CustomerCompany},
                "Test $TestCount: |- CustomerCompany $CustomerCompany found in returned list.",
            );
        }
    }
}
continue {
    $TestCount++;
}

# -------------------------------------------------------------------------------
# define customer company search details tests for 'OrderBy' searches
# -------------------------------------------------------------------------------

my @OrderBySearchTestCustomerCompanies;

for my $CustomerCompanyForOrderByTests (@CustomerCompanies) {
    my %CustomerCompanyData = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CustomerCompanyForOrderByTests,
    );
    push @OrderBySearchTestCustomerCompanies, \%CustomerCompanyData;
}

my @OrderByColumns = qw(
    CustomerID
    CustomerCompanyName
    CustomerCompanyStreet
    CustomerCompanyZIP
    CustomerCompanyCity
    CustomerCompanyCountry
);

for my $OrderByColumn (@OrderByColumns) {

    my @SortedCustomerCompanies
        = sort { $a->{$OrderByColumn} cmp $b->{$OrderByColumn} || $b->{CustomerID} cmp $a->{CustomerID} }
        @OrderBySearchTestCustomerCompanies;
    my @ReferenceSortedIDs = map { $_->{CustomerID} } @SortedCustomerCompanies;

    my $CustomerIDs = $CustomerCompanyObject->CustomerCompanySearchDetail(
        CustomerID       => $CompanyRand . '*',
        OrderBy          => [$OrderByColumn],
        OrderByDirection => ['Up'],
    );

    $Self->IsDeeply(
        $CustomerIDs,
        \@ReferenceSortedIDs,
        "Test $TestCount: CustomerCompanySearchDetail() OrderBy $OrderByColumn (Up)."
    );

    my @SortedCustomerCompaniesDown
        = sort { $b->{$OrderByColumn} cmp $a->{$OrderByColumn} || $b->{CustomerID} cmp $a->{CustomerID} }
        @OrderBySearchTestCustomerCompanies;
    my @ReferenceSortedIDsDown = map { $_->{CustomerID} } @SortedCustomerCompaniesDown;

    my $CustomerUserIDsDown = $CustomerCompanyObject->CustomerCompanySearchDetail(
        CustomerID => $CompanyRand . '*',
        OrderBy    => [$OrderByColumn],
    );

    $Self->IsDeeply(
        $CustomerUserIDsDown,
        \@ReferenceSortedIDsDown,
        "Test $TestCount: CustomerCompanySearchDetail() OrderBy $OrderByColumn (Down)."
    );

    # check if non-existent OrderByDirection criteria were handeled correct
    my $CustomerUserIDsSideways = $CustomerCompanyObject->CustomerCompanySearchDetail(
        CustomerID       => $CompanyRand . '*',
        OrderBy          => [$OrderByColumn],
        OrderByDirection => ['Sideways'],
        UserID           => 1,
    );

    $Self->Is(
        $CustomerUserIDsSideways,
        undef,
        "Test $TestCount: CustomerCompanySearchDetail() OrderBy $OrderByColumn (Sideways)."
    );
}
continue {
    $TestCount++;
}

1;
