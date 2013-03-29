# --
# Kernel/System/VariableCheck.pm - helpers to check variables
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::VariableCheck;

use strict;
use warnings;

use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS);

use Exporter;
%EXPORT_TAGS = (    ## no critic
    all => [
        'IsArrayRefWithData',
        'IsHashRefWithData',
        'IsInteger',
        'IsIPv4Address',
        'IsIPv6Address',
        'IsMD5Sum',
        'IsNotEqual',
        'IsNumber',
        'IsPositiveInteger',
        'IsString',
        'IsStringWithData',
        'DataIsDifferent',
    ],
);
Exporter::export_ok_tags('all');

@ISA = qw(Exporter);

=head1 NAME

Kernel::System::VariableCheck - helper functions to check variables

=head1 SYNOPSIS

Provides several helper functions to check variables, e.g.
if a variable is a string, a hash ref etc. This is helpful for
input data validation, for example.

Call this module directly without instantiating:

    use Kernel::System::VariableCheck qw(:all);             # export all functions into the calling package
    use Kernel::System::VariableCheck qw(IsHashRefWitData); # export just one function

    if (IsHashRefWithData($HashRef)) {
        ...
    }

The functions can be grouped as follows:

=head2 Variable type checks

=over 4

=item L<IsString()>

=item L<IsStringWithData()>

=item L<IsArrayRefWithData()>

=item L<IsHashRefWithData()>

=back

=head2 Number checks

=over 4

=item L<IsNumber()>

=item L<IsInteger()>

=item L<IsPositiveInteger()>

=back

=head2 Special data format checks

=over 4

=item L<IsIPv4Address()>

=item L<IsIPv6Address()>

=item L<IsMD5Sum()>

=back

=head1 PUBLIC INTERFACE

=over 4

=cut

=item IsString()

test supplied data to determine if it is a string - an empty string is valid

returns 1 if data matches criteria or undef otherwise

    my $Result = IsString(
        'abc', # data to be tested
    );

=cut

sub IsString {
    my $TestData = $_[0];

    return if scalar @_ ne 1;
    return if ref $TestData;
    return if !defined $TestData;

    return 1;
}

=item IsStringWithData()

test supplied data to determine if it is a non zero-length string

returns 1 if data matches criteria or undef otherwise

    my $Result = IsStringWithData(
        'abc', # data to be tested
    );

=cut

sub IsStringWithData {
    my $TestData = $_[0];

    return if !IsString(@_);
    return if $TestData eq '';

    return 1;
}

=item IsArrayRefWithData()

test supplied data to determine if it is an array reference and contains at least one key

returns 1 if data matches criteria or undef otherwise

    my $Result = IsArrayRefWithData(
        [ # data to be tested
            'key',
            ...
        ],
    );

=cut

sub IsArrayRefWithData {
    my $TestData = $_[0];

    return if scalar @_ ne 1;
    return if ref $TestData ne 'ARRAY';
    return if !@{$TestData};

    return 1;
}

=item IsHashRefWithData()

test supplied data to determine if it is a hash reference and contains at least one key/value pair

returns 1 if data matches criteria or undef otherwise

    my $Result = IsHashRefWithData(
        { # data to be tested
            'key' => 'value',
            ...
        },
    );

=cut

sub IsHashRefWithData {
    my $TestData = $_[0];

    return if scalar @_ ne 1;
    return if ref $TestData ne 'HASH';
    return if !%{$TestData};

    return 1;
}

=item IsNumber()

test supplied data to determine if it is a number
(integer, floating point, possible exponent, positive or negative)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsNumber(
        999, # data to be tested
    );

=cut

sub IsNumber {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{
        \A [-]? (?: \d+ | \d* [.] \d+ | (?: \d+ [.]? \d* | \d* [.] \d+ ) [eE] [-+]? \d* ) \z
    }xms;

    return 1;
}

=item IsInteger()

test supplied data to determine if it is an integer (only digits, positive or negative)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsInteger(
        999, # data to be tested
    );

=cut

sub IsInteger {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{ \A [-]? (?: 0 | [1-9] \d* ) \z }xms;

    return 1;
}

=item IsPositiveInteger()

test supplied data to determine if it is a positive integer (only digits and positive)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsPositiveInteger(
        999, # data to be tested
    );

=cut

sub IsPositiveInteger {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{ \A [1-9] \d* \z }xms;

    return 1;
}

=item IsIPv4Address()

test supplied data to determine if it is a valid IPv4 address (syntax check only)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsIPv4Address(
        '192.168.0.1', # data to be tested
    );

=cut

sub IsIPv4Address {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{ \A [\d\.]+ \z }xms;
    my @Part = split '\.', $TestData;

    # four parts delimited by '.' needed
    return if scalar @Part ne 4;
    for my $Part (@Part) {

        # allow numbers 0 to 255, no leading zeroes
        return if $Part !~ m{
            \A (?: \d | [1-9] \d | [1] \d{2} | [2][0-4]\d | [2][5][0-5] ) \z
        }xms;
    }

    return 1;
}

=item IsIPv6Address()

test supplied data to determine if it is a valid IPv6 address (syntax check only)
shorthand notation and mixed IPv6/IPv4 notation allowed
# FIXME IPv6/IPv4 notation currently not supported

returns 1 if data matches criteria or undef otherwise

    my $Result = IsIPv6Address(
        '0000:1111:2222:3333:4444:5555:6666:7777', # data to be tested
    );

=cut

sub IsIPv6Address {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);

    # only hex characters (0-9,A-Z) plus separator ':' allowed
    return if $TestData !~ m{ \A [\da-f:]+ \z }xmsi;

    # special case - equals only zeroes
    return 1 if $TestData eq '::';

    # special cases - address must not start or end with single ':'
    return if $TestData =~ m{ \A : [^:] }xms;
    return if $TestData =~ m{ [^:] : \z }xms;

    # special case - address must not start and end with ':'
    return if $TestData =~ m{ \A : .+ : \z }xms;

    my $SkipFirst;
    if ( $TestData =~ m{ \A :: }xms ) {
        $TestData  = 'X' . $TestData;
        $SkipFirst = 1;
    }
    my $SkipLast;
    if ( $TestData =~ m{ :: \z }xms ) {
        $TestData .= 'X';
        $SkipLast = 1;
    }
    my @Part = split ':', $TestData;
    if ($SkipFirst) {
        shift @Part;
    }
    if ($SkipLast) {
        delete $Part[-1];
    }
    return if scalar @Part < 2 || scalar @Part > 8;
    return if scalar @Part ne 8 && $TestData !~ m{ :: }xms;

    # handle full addreses
    if ( scalar @Part eq 8 ) {
        my $EmptyPart;
        PART:
        for my $Part (@Part) {
            if ( $Part eq '' ) {
                return if $EmptyPart;
                $EmptyPart = 1;
                next PART;
            }
            return if $Part !~ m{ \A [\da-f]{1,4} \z }xmsi;
        }
    }

    # handle shorthand addresses
    my $ShortHandUsed;
    PART:
    for my $Part (@Part) {
        next PART if $Part eq 'X';

        # empty part means shorthand - do we already have more than one consecutive empty parts?
        return if $Part eq '' && $ShortHandUsed;
        if ( $Part eq '' ) {
            $ShortHandUsed = 1;
            next PART;
        }
        return if $Part !~ m{ \A [\da-f]{1,4} \z }xmsi;
    }

    return 1;
}

=item IsMD5Sum()

test supplied data to determine if it is an md5sum (32 hex characters)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsMD5Sum(
        '6f1ed002ab5595859014ebf0951522d9', # data to be tested
    );

=cut

sub IsMD5Sum {
    my $TestData = $_[0];

    return if !IsStringWithData(@_);
    return if $TestData !~ m{ \A [\da-f]{32} \z }xmsi;

    return 1;
}

=item DataIsDifferent()

compares two data structures with each other. Returns 1 if
they are different, undef otherwise.

Data parameters need to be passed by reference and can be SCALAR,
ARRAY or HASH.

    my $DataIsDifferent = DataDiff(
        Data1 => \$Data1,
        Data2 => \$Data2,
    );

=cut

sub DataIsDifferent {
    my (%Param) = @_;

    # check needed stuff
    for (qw(Data1 Data2)) {
        return if ( !defined $Param{$_} );
    }

    # ''
    if ( ref $Param{Data1} eq '' && ref $Param{Data2} eq '' ) {

        # do nothing, it's ok
        return if !defined $Param{Data1} && !defined $Param{Data2};

        # return diff, because its different
        return 1 if !defined $Param{Data1} || !defined $Param{Data2};

        # return diff, because its different
        return 1 if $Param{Data1} ne $Param{Data2};

        # return, because its not different
        return;
    }

    # SCALAR
    if ( ref $Param{Data1} eq 'SCALAR' && ref $Param{Data2} eq 'SCALAR' ) {

        # do nothing, it's ok
        return if !defined ${ $Param{Data1} } && !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if !defined ${ $Param{Data1} } || !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if ${ $Param{Data1} } ne ${ $Param{Data2} };

        # return, because its not different
        return;
    }

    # ARRAY
    if ( ref $Param{Data1} eq 'ARRAY' && ref $Param{Data2} eq 'ARRAY' ) {
        my @A = @{ $Param{Data1} };
        my @B = @{ $Param{Data2} };

        # check if the count is different
        return 1 if $#A ne $#B;

        # compare array
        for my $Count ( 0 .. $#A ) {

            # do nothing, it's ok
            next if !defined $A[$Count] && !defined $B[$Count];

            # return diff, because its different
            return 1 if !defined $A[$Count] || !defined $B[$Count];

            if ( $A[$Count] ne $B[$Count] ) {
                if ( ref $A[$Count] eq 'ARRAY' || ref $A[$Count] eq 'HASH' ) {
                    return 1 if DataIsDifferent( Data1 => $A[$Count], Data2 => $B[$Count] );
                    next;
                }
                return 1;
            }
        }
        return;
    }

    # HASH
    if ( ref $Param{Data1} eq 'HASH' && ref $Param{Data2} eq 'HASH' ) {
        my %A = %{ $Param{Data1} };
        my %B = %{ $Param{Data2} };

        # compare %A with %B and remove it if checked
        for my $Key ( sort keys %A ) {

            # Check if both are undefined
            if ( !defined $A{$Key} && !defined $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next;
            }

            # return diff, because its different
            return 1 if !defined $A{$Key} || !defined $B{$Key};

            if ( $A{$Key} eq $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next;
            }

            # return if values are different
            if ( ref $A{$Key} eq 'ARRAY' || ref $A{$Key} eq 'HASH' ) {
                return 1 if DataIsDifferent( Data1 => $A{$Key}, Data2 => $B{$Key} );
                delete $A{$Key};
                delete $B{$Key};
                next;
            }
            return 1;
        }

        # check rest
        return 1 if %B;
        return;
    }

    if ( ref $Param{Data1} eq 'REF' && ref $Param{Data2} eq 'REF' ) {
        return 1 if DataIsDifferent( Data1 => ${ $Param{Data1} }, Data2 => ${ $Param{Data2} } );
        return;
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
