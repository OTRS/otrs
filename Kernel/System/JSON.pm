# --
# Kernel/System/JSON.pm - Wrapper functions for encoding and decoding JSON
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::JSON;

use strict;
use warnings;

# on PerlEx JSON::XS causes problems so force JSON::PP as backend
# see http://bugs.otrs.org/show_bug.cgi?id=7337
BEGIN {
    if ( $ENV{GATEWAY_INTERFACE} && $ENV{GATEWAY_INTERFACE} =~ m{\A CGI-PerlEx}xmsi ) {
        $ENV{PERL_JSON_BACKEND} = 'JSON::PP';
    }
}

use JSON;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::JSON - the JSON wrapper lib

=head1 SYNOPSIS

Functions for encoding perl data structures to JSON.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a JSON object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Encode()

Encode a perl data structure to a JSON string.

    my $JSONString = $JSONObject->Encode(
        Data     => $Data,
        SortKeys => 1,    (optional) (0|1) default 0, to sort the keys of the json data
    );

=cut

sub Encode {
    my ( $Self, %Param ) = @_;

    # check for needed data
    if ( !defined $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    # create json object
    my $JSONObject = JSON->new();

    $JSONObject->allow_nonref(1);

    # sort the keys of the JSON data
    if ( $Param{SortKeys} ) {
        $JSONObject->canonical( [1] );
    }

    # get JSON-encoded presentation of perl structure
    my $JSONEncoded = $JSONObject->encode( $Param{Data} ) || '""';

    return $JSONEncoded;
}

=item Decode()

Decode a JSON string to a perl data structure.

    my $PerlStructureScalar = $JSONObject->Decode(
        Data => $JSONString,
    );

=cut

sub Decode {
    my ( $Self, %Param ) = @_;

    # check for needed data
    return if !defined $Param{Data};

    # create json object
    my $JSONObject = JSON->new();

    $JSONObject->allow_nonref(1);

    # decode JSON encoded to perl structure
    my $Scalar;

    # use eval here, as JSON::XS->decode() dies when providing a malformed JSON string
    if ( !eval { $Scalar = $JSONObject->decode( $Param{Data} ) } ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Decoding the JSON string failed: ' . $@,
        );

        return;
    }

    return $Scalar;
}

=item True()

returns a constant that can be mapped to a boolean true value
in JSON rather than a string with "true".

    my $TrueConstant = $JSONObject->True();

    my $TrueJS = $JSONObject->Encode(
        Data => $TrueConstant,
    );

This will return the string 'true'.
If you pass the perl string 'true' to JSON, it will return '"true"'
as a JavaScript string instead.

=cut

sub True {
    return JSON::true();
}

=item False()

like C<True()>, but for a false boolean value.

=cut

sub False {
    return JSON::false();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
