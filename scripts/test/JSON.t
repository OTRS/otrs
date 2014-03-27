# --
# scripts/test/JSON.t - JSON module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: JSON.t,v 1.8 2010-10-29 05:03:20 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use utf8;

use Kernel::System::JSON;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw( $Self %Param );

my $JSONObject = Kernel::System::JSON->new( %{$Self} );

# Tests for JSON encode method
my @Tests = (
    {
        Input  => undef,
        Result => undef,
        Name   => 'JSON - undef test',
    },
    {
        Input  => '',
        Result => '""',
        Name   => 'JSON - empty test',
    },
    {
        Input  => 'Some Text',
        Result => '"Some Text"',
        Name   => 'JSON - simple'
    },
    {
        Input  => 42,
        Result => '42',
        Name   => 'JSON - simple'
    },
    {
        Input => [ 1, 2, "3", "Foo", 5 ],
        Result => '[1,2,"3","Foo",5]',
        Name   => 'JSON - simple'
    },
    {
        Input => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        Result => '{"Key1":"Value1","Key2":42,"Key3":"Another Value"}',
        Name   => 'JSON - simple'
    },
    {
        Input  => Kernel::System::JSON::True(),
        Result => 'true',
        Name   => 'JSON - bool true'
    },
    {
        Input  => Kernel::System::JSON::False(),
        Result => 'false',
        Name   => 'JSON - bool false'
    },
    {
        Input => [
            [ 1, 2, "Foo", "Bar" ],
            {
                Key1 => 'Something',
                Key2 => [ "Foo", "Bar" ],
                Key3 => {
                    Foo => 'Bar',
                },
                Key4 => {
                    Bar => [ "f", "o", "o" ]
                    }
            },
        ],
        Result =>
            '[[1,2,"Foo","Bar"],{"Key1":"Something","Key2":["Foo","Bar"],"Key3":{"Foo":"Bar"},"Key4":{"Bar":["f","o","o"]}}]',
        Name => 'JSON - complex structure'
    },
);

for my $Test (@Tests) {
    my $JSON = $JSONObject->Encode(
        Data     => $Test->{Input},
        SortKeys => 1,
    );

    $Self->Is(
        $JSON,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
