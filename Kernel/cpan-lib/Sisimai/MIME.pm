package Sisimai::MIME;
use strict;
use warnings;
use Encode;
use MIME::Base64 ();
use MIME::QuotedPrint ();
use Sisimai::String;

my $ReE = {
    '7bit-encoded' => qr/^Content-Transfer-Encoding:[ ]*7bit$/im,
    'quoted-print' => qr/^Content-Transfer-Encoding:[ ]*quoted-printable$/im,
    'some-iso2022' => qr/^Content-Type:[ ]*.+;[ ]*charset=["']?(iso-2022-[-a-z0-9]+)['"]?/im,
    'with-charset' => qr/^Content[-]Type:[ ]*.+[;][ ]*charset=['"]?([-0-9a-z]+)['"]?/i,
    'only-charset' => qr/^[\s\t]+charset=['"]?([-0-9a-z]+)['"]?/i,
    'html-message' => qr|^Content-Type:[ ]*text/html;|mi,
};

sub patterns {
  # Make MIME-Encoding and Content-Type related headers regurlar expression
  # @return   [Array] Regular expressions related to MIME encoding
  return $ReE;
}

sub is_mimeencoded {
    # Check that the argument is MIME-Encoded string or not
    # @param    [String] argv1  String to be checked
    # @return   [Integer]       0: Not MIME encoded string
    #                           1: MIME encoded string
    my $class = shift;
    my $argv1 = shift || return 0;
    my @piece = ();
    my $mime1 = 0;

    return undef unless ref $argv1;
    return undef unless ref $argv1 eq 'SCALAR';
    $$argv1 =~ y/"//d;

    if( $$argv1 =~ m/[ ]/ ) {
        # Multiple MIME-Encoded strings in a line
        @piece = split(' ', $$argv1);
    } else {
        push @piece, $$argv1;
    }

    for my $e ( @piece ) {
        # Check all the string in the array
        next unless $e =~ m/[ \t]*=[?][-_0-9A-Za-z]+[?][BbQq][?].+[?]=?[ \t]*/;
        $mime1 = 1;
    }
    return $mime1;
}

sub mimedecode {
    # Decode MIME-Encoded string
    # @param    [Array] argvs   Reference to an array including MIME-Encoded text
    # @return   [String]        MIME-Decoded text
    my $class = shift;
    my $argvs = shift;

    return '' unless ref $argvs;
    return '' unless ref $argvs eq 'ARRAY';

    my $characterset = '';
    my $encodingname = '';
    my $mimeencoded0 = '';
    my @decodedtext0 = ();
    my $decodedtext1 = '';
    my $utf8decoded1 = '';

    my $notmimetext0 = '';
    my $notmimetext1 = '';

    for my $e ( @$argvs ) {
        # Check and decode each element
        $e =~ s/\A[ \t]+//g;
        $e =~ s/[ \t]+\z//g;
        $e =~ y/"//d;

        if( __PACKAGE__->is_mimeencoded(\$e) ) {
            # MIME Encoded string
            if( $e =~ m{\A(.*)=[?]([-_0-9A-Za-z]+)[?]([BbQq])[?](.+)[?]=?(.*)\z} ) {
                # =?utf-8?B?55m954yr44Gr44KD44KT44GT?=
                $notmimetext0   = $1;
                $characterset ||= lc $2;
                $encodingname ||= uc $3;
                $mimeencoded0   = $4;
                $notmimetext1   = $5;

                push @decodedtext0, $notmimetext0;
                if( $encodingname eq 'Q' ) {
                    # Quoted-Printable
                    push @decodedtext0, MIME::QuotedPrint::decode($mimeencoded0);

                } elsif( $encodingname eq 'B' ) {
                    # Base64
                    push @decodedtext0, MIME::Base64::decode($mimeencoded0);
                }
                push @decodedtext0, $notmimetext1;
            }
        } else {
            push @decodedtext0, $e;
        }
    }

    return '' unless scalar @decodedtext0;
    $decodedtext1 = join('', @decodedtext0);

    if( $characterset && $encodingname ) {
        # utf-8 => utf8
        $characterset = 'utf8' if $characterset eq 'utf-8';

        if( $characterset ne 'utf8' ) {
            # Characterset is not UTF-8
            eval {
                Encode::from_to($decodedtext1, $characterset, 'utf8');
            };
            $decodedtext1 = 'FAILED TO CONVERT THE SUBJECT' if $@;
        }
    }

    $utf8decoded1 = Encode::decode_utf8 $decodedtext1;
    return $utf8decoded1;
}

sub qprintd {
    # Decode MIME Quoted-Printable Encoded string
    # @param    [String] argv1   MIME Encoded text
    # @param    [Hash]   heads   Email header
    # @return   [String]         MIME Decoded text
    my $class = shift;
    my $argv1 = shift // return undef;
    my $heads = shift // {};
    my $plain = '';

    return undef unless ref $argv1;
    return undef unless ref $argv1 eq 'SCALAR';

    if( ! exists $heads->{'content-type'} || length($heads->{'content-type'}) == 0 ) {
        # There is no Content-Type: field
        $plain = MIME::QuotedPrint::decode($$argv1);
        return \$plain;
    }

    # Quoted-printable encoded part is the part of the text
    my $boundary00 = __PACKAGE__->boundary($heads->{'content-type'}, 0);

    if( length($boundary00) == 0 || $$argv1 !~ $ReE->{'quoted-print'} ) {
        # There is no boundary string or no
        # Content-Transfer-Encoding: quoted-printable field.
        $plain = MIME::QuotedPrint::decode($$argv1);
        return \$plain;
    }

    my $boundary01 = Sisimai::MIME->boundary($heads->{'content-type'}, 1);
    my $reboundary = {
        'begin' => qr/\A\Q$boundary00\E/,
        'until' => qr/\Q$boundary01\E\z/,
    };
    my $bodystring = '';
    my $notdecoded = '';
    my $getencoded = '';

    my $encodename = undef;
    my $ctencoding = undef;
    my $mimeinside = 0;

    for my $e ( split("\n", $$argv1) ) {
        # This is a multi-part message in MIME format. Your mail reader does not
        # understand MIME message format.
        # --=_gy7C4Gpes0RP4V5Bs9cK4o2Us2ZT57b-3OLnRN+4klS8dTmQ
        # Content-Type: text/plain; charset=iso-8859-15
        # Content-Transfer-Encoding: quoted-printable
        if( $mimeinside ) {
            # Quoted-Printable encoded text block
            if( $e =~ $reboundary->{'begin'} ) {
                # The next boundary string has appeared
                # --=_gy7C4Gpes0RP4V5Bs9cK4o2Us2ZT57b-3OLnRN+4klS8dTmQ
                $getencoded  = MIME::QuotedPrint::decode($notdecoded);
                $getencoded  = Sisimai::String->to_utf8(\$getencoded, $encodename);
                $bodystring .= $$getencoded;
                $bodystring .= $e . "\n";

                $notdecoded = '';
                $mimeinside = 0;
                $ctencoding = undef;
                $encodename = undef;

            } else {
                # Inside of Queoted printable encoded text
                $notdecoded .= $e . "\n";
            }
        } else {
            # NOT Quoted-Printable encoded text block
            if( $e =~ m/\A[-]{2}[^\s]+[^-]\z/ ) {
                # Start of the boundary block
                # --=_gy7C4Gpes0RP4V5Bs9cK4o2Us2ZT57b-3OLnRN+4klS8dTmQ
                unless( $e eq $boundary00 ) {
                    # New boundary string has appeared
                    $boundary00 = $e;
                    $boundary01 = $e . '--';
                    $reboundary = {
                        'begin' => qr/\A\Q$boundary00\E/,
                        'until' => qr/\Q$boundary01\E\z/,
                    };
                }
            } elsif( $e =~ $ReE->{'with-charset'} || $e =~ $ReE->{'only-charset'} ) {
                # Content-Type: text/plain; charset=ISO-2022-JP
                $encodename = $1;
                $mimeinside = 1 if $ctencoding;

            } elsif( $e =~ $ReE->{'quoted-print'} ){
                # Content-Transfer-Encoding: quoted-printable
                $ctencoding = $e;
                $mimeinside = 1 if $encodename;

            } elsif( $e =~ $reboundary->{'until'} ) {
                # The end of boundary block
                # --=_gy7C4Gpes0RP4V5Bs9cK4o2Us2ZT57b-3OLnRN+4klS8dTmQ--
                $mimeinside = 0;
            }
            $bodystring .= $e . "\n";
        }
    }
    return \$bodystring;
}

sub base64d {
    # Decode MIME BASE64 Encoded string
    # @param    [String] argv1   MIME Encoded text
    # @return   [String]         MIME-Decoded text
    my $class = shift;
    my $argv1 = shift // return undef;
    my $plain = undef;

    return undef unless ref $argv1;
    return undef unless ref $argv1 eq 'SCALAR';

    if( $$argv1 =~ m|([+/=0-9A-Za-z\r\n]+)| ) {
        # Decode BASE64
        $plain = MIME::Base64::decode($1);
    }
    return \$plain;
}

sub boundary {
    # Get boundary string
    # @param    [String]  argv1 The value of Content-Type header
    # @param    [Integer] start -1: boundary string itself
    #                            0: Start of boundary
    #                            1: End of boundary
    # @return   [String] Boundary string
    my $class = shift;
    my $argv1 = shift || return undef;
    my $start = shift // -1;
    my $value = '';

    if( $argv1 =~ m/\bboundary=([^ ]+)/i ) {
        # Content-Type: multipart/mixed; boundary=Apple-Mail-5--931376066
        # Content-Type: multipart/report; report-type=delivery-status;
        #    boundary="n6H9lKZh014511.1247824040/mx.example.jp"
        $value =  $1;
        $value =~ y/"'//d;
        $value =  sprintf("--%s", $value) if $start > -1;
        $value =  sprintf("%s--", $value) if $start >  0;
    }
    return $value;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::MIME - MIME Utilities

=head1 SYNOPSIS

    use Sisimai::MIME;

    my $e = '=?utf-8?B?55m954yr44Gr44KD44KT44GT?=';
    my $v = Sisimai::MIME->is_mimeencoded(\$e);
    print $v;   # 1

    my $x = Sisimai::MIME->mimedecode([$e]);
    print $x;

=head1 DESCRIPTION

Sisimai::MIME is MIME Utilities for C<Sisimai>.

=head1 CLASS METHODS

=head2 C<B<is_mimeencoded(I<Scalar Reference>)>>

C<is_mimeencoded()> returns that the argument is MIME-Encoded string or not.

    my $e = '=?utf-8?B?55m954yr44Gr44KD44KT44GT?=';
    my $v = Sisimai::MIME->is_mimeencoded(\$e);  # 1

=head2 C<B<mimedecode(I<Array-Ref>)>>

C<mimedecode()> is a decoder method for getting the original string from MIME
Encoded string in email headers.

    my $r = '=?utf-8?B?55m954yr44Gr44KD44KT44GT?=';
    my $v = Sisimai::MIME->mimedecode([$r]);

=head2 C<B<base64d(I<\String>)>>

C<base64d> is a decoder method for getting the original string from MIME Base564
encoded string.

    my $r = '44Gr44KD44O844KT';
    my $v = Sisimai::MIME->base64d(\$r);

=head2 C<B<qprintd(I<\String>)>>

C<qprintd> is a decoder method for getting the original string from MIME Quoted-
printable encoded string.

    my $r = '=4e=65=6b=6f';
    my $v = Sisimai::MIME->qprintd(\$r);

=head2 C<B<boundary(I<String>)>>

C<boundary()> returns a boundary string from the value of Content-Type header.

    my $r = 'Content-Type: multipart/mixed; boundary=Apple-Mail-1-526612466';
    my $v = Sisimai::MIME->boundary($r);
    print $v;   # Apple-Mail-1-526612466

    print Sisimai::MIME->boundary($r, 0); # --Apple-Mail-1-526612466
    print Sisimai::MIME->boundary($r, 1); # --Apple-Mail-1-526612466--

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
