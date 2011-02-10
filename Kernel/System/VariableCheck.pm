# --
# Kernel/System/VariableCheck.pm - helpers to check variables
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: VariableCheck.pm,v 1.1 2011-02-10 13:08:20 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::VariableCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION @EXPORT_OK %EXPORT_TAGS);
$VERSION = qw($Revision: 1.1 $) [1];

use Exporter;
%EXPORT_TAGS = (
    all => [
        'IsHashRefWithData',
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
        Data => 'abc' # data to be tested
    );

=cut

sub IsString {
    my $TestData = $_[0];

    return if ref $TestData;
    return if !defined $TestData;

    return 1;
}

=item IsStringWithData()

test supplied data to determine if it is a non zero-length string

returns 1 if data matches criteria or undef otherwise

    my $Result = IsStringWithData(
        Data => 'abc' # data to be tested
    );

=cut

sub IsStringWithData {
    my $TestData = $_[0];

    return if ref $TestData;
    return if !$TestData;

    return 1;
}

=item IsHashRefWithData()

test supplied data to deterine if it is a hash reference and contains at least one key/value pair

returns 1 if data matches criteria or undef otherwise

    my $Result = IsHashRefWithData(
        Data => { # data to be tested
            'key' => 'value',
            ...
        },
    );

=cut

sub IsHashRefWithData {
    my $TestData = $_[0];

    return if ref $TestData ne 'HASH';
    return if !%{$TestData};

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

$Revision: 1.1 $ $Date: 2011-02-10 13:08:20 $

=cut
