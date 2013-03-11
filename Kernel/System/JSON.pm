# --
# Kernel/System/JSON.pm - Wrapper functions for encoding and decoding JSON
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::JSON;

use strict;
use warnings;

use JSON;

use vars qw(@ISA $VERSION);

=head1 NAME

Kernel::System::JSON - the JSON wrapper lib

=head1 SYNOPSIS

Functions for encoding perl data structures to JSON.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a JSON object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::JSON;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $JSONObject = Kernel::System::JSON->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject EncodeObject LogObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{JSONObject} = JSON->new();
    $Self->{JSONObject}->allow_nonref(1);

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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    # sort the keys of the JSON data
    if ( $Param{SortKeys} ) {
        $Self->{JSONObject}->canonical( [1] );
    }

    # get JSON-encoded presentation of perl structure
    my $JSONEncoded = $Self->{JSONObject}->encode( $Param{Data} ) || '""';

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

    # decode JSON encoded to perl structure
    my $Scalar;

    # use eval here, as JSON::XS->decode() dies when providing a malformed JSON string
    if ( !eval { $Scalar = $Self->{JSONObject}->decode( $Param{Data} ) } ) {
        $Self->{LogObject}->Log(
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
