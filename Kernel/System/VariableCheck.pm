# --
# Kernel/System/VariableCheck.pm - helpers to check variables
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: VariableCheck.pm,v 1.2 2011-02-14 12:45:13 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::VariableCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION @EXPORT_OK %EXPORT_TAGS);
$VERSION = qw($Revision: 1.2 $) [1];

use Exporter;
%EXPORT_TAGS = (
    all => [
        'IsArrayRefWithData',
        'IsHashRefWithData',
        'IsInteger',
        'IsNumber',
        'IsString',
        'IsStringWithData',
    ],
);
Exporter::export_ok_tags('all');

@ISA = qw(Exporter);

=head1 NAME

Kernel::System::VariableCheck - helpers to check variables

=head1 SYNOPSIS

Provides several helper functions to check variables.
E.g. if a variable is a string, a hash ref etc.

This module is called directly if needed and is not added to $Self

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
    return if $TestData !~ m{ \A [-]? \d+ \z }xms;

    return 1;
}

=item IsNumber()

test supplied data to determine if it is a number
(integer, floating point, possible exponent, positive or negative)

returns 1 if data matches criteria or undef otherwise

    my $Result = IsInteger(
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

=item IsHashRefWithData()

test supplied data to deterine if it is a hash reference and contains at least one key/value pair

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

    return if scalar @_     ne 1;
    return if ref $TestData ne 'HASH';
    return if !%{$TestData};

    return 1;
}

=item IsArrayRefWithData()

test supplied data to deterine if it is an array reference and contains at least one key

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

    return if scalar @_     ne 1;
    return if ref $TestData ne 'ARRAY';
    return if !@{$TestData};

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

=head1 VERSION

$Revision: 1.2 $ $Date: 2011-02-14 12:45:13 $

=cut
