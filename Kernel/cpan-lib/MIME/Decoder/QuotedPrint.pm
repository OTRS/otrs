package MIME::Decoder::QuotedPrint;


=head1 NAME

MIME::Decoder::QuotedPrint - encode/decode a "quoted-printable" stream


=head1 SYNOPSIS

A generic decoder object; see L<MIME::Decoder> for usage.


=head1 DESCRIPTION

A MIME::Decoder subclass for the C<"quoted-printable"> encoding.
The name was chosen to jibe with the pre-existing MIME::QuotedPrint
utility package, which this class actually uses to translate each line.

=over 4

=item *

The B<decoder> does a line-by-line translation from input to output.

=item *

The B<encoder> does a line-by-line translation, breaking lines
so that they fall under the standard 76-character limit for this
encoding.  

=back


B<Note:> just like MIME::QuotedPrint, we currently use the 
native C<"\n"> for line breaks, and not C<CRLF>.  This may
need to change in future versions.


=head1 AUTHOR

Eryq (F<eryq@zeegee.com>), ZeeGee Software Inc (F<http://www.zeegee.com>).

All rights reserved.  This program is free software; you can redistribute 
it and/or modify it under the same terms as Perl itself.


=head1 VERSION

$Revision: 1.1 $ $Date: 2002-11-10 23:00:46 $


=cut

use vars qw(@ISA $VERSION);
use MIME::Decoder;
use MIME::QuotedPrint 2.03;

@ISA = qw(MIME::Decoder);

# The package version, both in 1.23 style *and* usable by MakeMaker:
$VERSION = substr q$Revision: 1.1 $, 10;

#------------------------------
#
# encode_qp_really STRING
#
# Encode QP, and then follow guideline 8 from RFC 2049 (thanks to Denis 
# N. Antonioli) whereby we make things a little safer for the transport
# and storage of messages.  WARNING: we can only do this if the line won't
# grow beyond 76 characters!
#
sub encode_qp_really {
    my $enc = encode_qp($_[0]);
    if (length($enc) < 74) {
	$enc =~ s/^\.$/=2E/g;         # force encoding of /^\.$/
	$enc =~ s/^From /=46rom /g;   # force encoding of /^From /
    }
    $enc;
}

#------------------------------
#
# decode_it IN, OUT
#
sub decode_it {
    my ($self, $in, $out) = @_;

    while (defined($_ = $in->getline)) {
	$out->print(decode_qp($_));
    }
    1;
}

#------------------------------
#
# encode_it IN, OUT
#
sub encode_it {
    my ($self, $in, $out) = @_;

    while (defined($_ = $in->getline)) {
	$out->print(encode_qp_really($_));
    }
    1;
}

#------------------------------
1;
