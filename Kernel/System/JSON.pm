# --
# Kernel/System/JSON.pm - Wrapper functions for encoding and decoding JSON
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: JSON.pm,v 1.1 2009-12-31 10:47:25 mn Exp $
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
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::JSON - the JSON wrapper lib

=head1 SYNOPSIS

Functions for encoding perl data structures to JSON.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a JSON object

    use Kernel::System::JSON;

    my $JSONObject = Kernel::System::JSON->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    my $json = new JSON;
    $json = $json->allow_nonref(1);

    $Self->{JSON} = $json;

    return $Self;
}

=item Encode()

Encode a perl data structure to a JSON string.

    $JSONObject->Encode(
        Data => $data,
    );

=cut

sub Encode {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Data} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Data!" );
        return;
    }

    my $JSON = '';
    $JSON = $Self->{JSON}->encode( $Param{Data} );

    return $JSON;
}

# function is not used yet
#=item Decode()
#
#Decode a JSON string to a perl data structure.
#
#    $JSONObject->Decode(
#        Data => $jsonstring,
#    );
#
#=cut

sub Decode {
    my ( $Self, %Param ) = @_;

    return if !defined $Param{Data};

    my $scalar;
    $scalar = $Self->{JSON}->decode( $Param{Data} );

    return $scalar;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=head1 VERSION

$Revision: 1.1 $ $Date: 2009-12-31 10:47:25 $

=cut
