# --
# VariableCheck.t - tests for VariableCheck
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: VariableCheck.t,v 1.1 2011-02-14 12:45:12 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

# import all possible checks
use Kernel::System::VariableCheck qw(:all);

# create variables to test
use Kernel::Config;
my $ConfigObject  = Kernel::Config->new();
my $Variable      = 'string';
my $Reference     = \$Variable;
my $TestVariables = {
    ArrayRef1     => [undef],
    ArrayRef2     => [''],
    ArrayRef3     => [0],
    ArrayRef4     => [1],
    ArrayRef5     => ['key'],
    ArrayRef6     => [ 'key', 'key2' ],
    ArrayRef7     => [ 'key' => 'value' ],          # becomes [ 'key', 'value' ]
    ArrayRefEmpty => [],
    HashRef1      => { 'key' => 'value' },
    HashRef2      => {undef},                       # becomes { '' => undef }
    HashRef3      => {''},                          # becomes { '' => undef }
    HashRef4      => {0},                           # becomes { 0 => undef }
    HashRef5      => {1},                           # becomes { 1 => undef }
    HashRef6      => {'key'},                       # becomes { 'key' => undef }
    HashRefEmpty  => {},
    Integer1      => 1,
    Integer2      => 99,
    Integer3      => '-987654321',
    Number1       => '.00001',
    Number2       => '-.999999',
    Number3       => '999.999',
    Number4       => '-999.999',
    Number5       => '9.999e+99',
    Number6       => '-9.999e+99',
    Number7       => '1.111e-99',
    Number8       => '-9.999e-99',
    Number9       => '1.e1',
    ObjectRef     => $ConfigObject,
    RefRef        => \$Reference,
    ScalarRef     => \$Variable,
    String1       => '111,111',
    String2       => 'text',
    String3       => 'iso-8859-15-text-äöüß',
    String4       => 'utf8-text-Ã¤Ã¶Ã¼ÃŸâ‚¬Ð¸Ñ',
    String5       => '-.e',
    StringEmpty   => '',
    Undef         => undef,
    Zero          => 0,
};

# which variables should pass the check for specified function (all others have to fail)
my $Tests = {
    IsString => {
        Integer1    => 1,
        Integer2    => 1,
        Integer3    => 1,
        Number1     => 1,
        Number2     => 1,
        Number3     => 1,
        Number4     => 1,
        Number5     => 1,
        Number6     => 1,
        Number7     => 1,
        Number8     => 1,
        Number9     => 1,
        String1     => 1,
        String2     => 1,
        String3     => 1,
        String4     => 1,
        String5     => 1,
        StringEmpty => 1,
        Zero        => 1,
    },
    IsStringWithData => {
        Integer1 => 1,
        Integer2 => 1,
        Integer3 => 1,
        Number1  => 1,
        Number2  => 1,
        Number3  => 1,
        Number4  => 1,
        Number5  => 1,
        Number6  => 1,
        Number7  => 1,
        Number8  => 1,
        Number9  => 1,
        String1  => 1,
        String2  => 1,
        String3  => 1,
        String4  => 1,
        String5  => 1,
        Zero     => 1,
    },
    IsInteger => {
        Integer1 => 1,
        Integer2 => 1,
        Integer3 => 1,
        Zero     => 1,
    },
    IsNumber => {
        Integer1 => 1,
        Integer2 => 1,
        Integer3 => 1,
        Number1  => 1,
        Number2  => 1,
        Number3  => 1,
        Number4  => 1,
        Number5  => 1,
        Number6  => 1,
        Number7  => 1,
        Number8  => 1,
        Number9  => 1,
        Zero     => 1,
    },
    IsHashRefWithData => {
        HashRef1 => 1,
        HashRef2 => 1,
        HashRef3 => 1,
        HashRef4 => 1,
        HashRef5 => 1,
        HashRef6 => 1,
    },
    IsArrayRefWithData => {
        ArrayRef1 => 1,
        ArrayRef2 => 1,
        ArrayRef3 => 1,
        ArrayRef4 => 1,
        ArrayRef5 => 1,
        ArrayRef6 => 1,
        ArrayRef7 => 1,
    },
};

# loop through functions
for my $FunctionName ( sort keys %{$Tests} ) {
    for my $TestKey ( sort keys %{$TestVariables} ) {

        # variable names defined for this function should return 1
        if ( $Tests->{$FunctionName}->{$TestKey} ) {
            $Self->True(
                Test( $FunctionName, $TestVariables->{$TestKey} ),
                "VariableCheck $FunctionName ($TestKey)",
            );
        }

        # variable names not defined for this function should return undef (turned to 0 in Test())
        else {
            $Self->False(
                Test( $FunctionName, $TestVariables->{$TestKey} ),
                "VariableCheck $FunctionName ($TestKey)",
            );
        }

        # all currently existing functions should only accept a single parameter
        # if more functions are added, we need to distinguish here
        $Self->False(
            Test( $FunctionName, $TestVariables->{$TestKey}, undef, 'another value' ),
            "VariableCheck $FunctionName (Array)",
        );
    }
}

sub Test {
    my ( $FunctionName, @Param ) = @_;

    if ( $FunctionName eq 'IsString' ) {
        return IsString(@Param) || 0;
    }
    if ( $FunctionName eq 'IsStringWithData' ) {
        return IsStringWithData(@Param) || 0;
    }
    if ( $FunctionName eq 'IsInteger' ) {
        return IsInteger(@Param) || 0;
    }
    if ( $FunctionName eq 'IsNumber' ) {
        return IsNumber(@Param) || 0;
    }
    if ( $FunctionName eq 'IsHashRefWithData' ) {
        return IsHashRefWithData(@Param) || 0;
    }
    if ( $FunctionName eq 'IsArrayRefWithData' ) {
        return IsArrayRefWithData(@Param) || 0;
    }

    return 0;
}

1;
