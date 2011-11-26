# --
# ReferenceData.t - ReferenceData module tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReferenceData.t,v 1.1 2011-11-26 16:57:20 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::ReferenceData;
use Kernel::Config;

# create local object
my $ConfigObject = Kernel::Config->new();

# get configuration
my $Countries = $ConfigObject->Get('ReferenceData::OwnCountryList');
use Data::Dumper;
print Dumper($Countries);

# set configuration to invalid
if ( keys %$Countries ) {
    $ConfigObject->Set(
        Key   => 'ReferenceData::OwnCountryList',
        Value => undef,
    );
}
my $ReferenceDataObject = Kernel::System::ReferenceData->new(
    %{ $Self, },
    ConfigObject => $ConfigObject,
);

# tests the method to make sure there are at least 100 countries
my $CountryList = $ReferenceDataObject->CountryList();

my $CountryListLength = scalar keys %$CountryList;

$Self->True(
    $CountryListLength > 100,
    "There are $CountryListLength countries registered",
);

# let's assume these countries don't go anywhere

my @CountryList = ( 'Netherlands', 'Germany', 'Switzerland', 'United States', 'Japan' );

for my $Country (@CountryList) {
    $Self->True(
        $$CountryList{$Country},
        "Testing existence of country ($Country)",
    );
}

# set configuration to small list

$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => {
        'FR' => 'France',
        'NL' => 'Netherlands',
        'DE' => 'Germany'
    },
);

$CountryList = $ReferenceDataObject->CountryList();

@CountryList = ( 'Switzerland', 'United States', 'Japan' );

for my $Country (@CountryList) {
    $Self->False(
        $$CountryList{$Country},
        "OwnCountryList: Testing non-existence of country ($Country)",
    );
}

@CountryList = ( 'France', 'Netherlands', 'Germany' );

for my $Country (@CountryList) {
    $Self->True(
        $$CountryList{$Country},
        "OwnCountryList: Testing existence of country ($Country)",
    );
}

# restore configuration
if ( keys %$Countries ) {
    $ConfigObject->Set(
        Key   => 'ReferenceData::OwnCountryList',
        Value => $Countries,
        Valid => 1,
    );
}

1;
