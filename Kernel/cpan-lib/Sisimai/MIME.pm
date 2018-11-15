package Sisimai::MIME;
use strict;
use warnings;
use Encode;
use MIME::Base64 ();
use MIME::QuotedPrint ();
use Sisimai::String;

my $ReE = {
    '7bit-encoded' => qr/^content-transfer-encoding:[ ]*7bit/m,
    'quoted-print' => qr/^content-transfer-encoding:[ ]*quoted-printable/m,
    'some-iso2022' => qr/^content-type:[ ]*.+;[ ]*charset=["']?(iso-2022-[-a-z0-9]+)['"]?\b/m,
    'with-charset' => qr/^content[-]type:[ ]*.+[;][ ]*charset=['"]?([-0-9a-z]+)['"]?\b/,
    'only-charset' => qr/^[\s\t]+charset=['"]?([-0-9a-z]+)['"]?\b/,
    'html-message' => qr|^content-type:[ ]*text/html;|m,
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

    if( rindex($$argv1, ' ') > -1 ) {
        # Multiple MIME-Encoded strings in a line
        @piece = split(' ', $$argv1);
    } else {
        push @piece, $$argv1;
    }

    while( my $e = shift @piece ) {
        # Check all the string in the array
        next unless $e =~ /[ \t]*=[?][-_0-9A-Za-z]+[?][BbQq][?].+[?]=?[ \t]*/;
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
    my @decodedtext0 = ();
    my $decodedtext1 = '';
    my $utf8decoded1 = '';

    for my $e ( @$argvs ) {
        # Check and decode each element
        $e =~ s/\A[ \t]+//g;
        $e =~ s/[ \t]+\z//g;
        $e =~ y/"//d;

        if( __PACKAGE__->is_mimeencoded(\$e) ) {
            # MIME Encoded string
            if( $e =~ m{\A(.*)=[?]([-_0-9A-Za-z]+)[?]([BbQq])[?](.+)[?]=?(.*)\z} ) {
                # =?utf-8?B?55m954yr44Gr44KD44KT44GT?=
                $characterset ||= lc $2;
                $encodingname ||= uc $3;

                push @decodedtext0, $1;
                if( $encodingname eq 'Q' ) {
                    # Quoted-Printable
                    push @decodedtext0, MIME::QuotedPrint::decode($4);

                } elsif( $encodingname eq 'B' ) {
                    # Base64
                    push @decodedtext0, MIME::Base64::decode($4);
                }
                push @decodedtext0, $5;
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
            eval { Encode::from_to($decodedtext1, $characterset, 'utf8') };
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

    return \'' unless ref $argv1;
    return \'' unless ref $argv1 eq 'SCALAR';

    if( ! exists $heads->{'content-type'} || ! $heads->{'content-type'} ) {
        # There is no Content-Type: field
        $plain = MIME::QuotedPrint::decode($$argv1);
        return \$plain;
    }

    # Quoted-printable encoded part is the part of the text
    my $boundary00 = __PACKAGE__->boundary($heads->{'content-type'}, 0);
    if( ! $boundary00 || lc($$argv1) !~ $ReE->{'quoted-print'} ) {
        # There is no boundary string or no
        # Content-Transfer-Encoding: quoted-printable field.
        $plain = MIME::QuotedPrint::decode($$argv1);
        return \$plain;
    }

    my $boundary01 = Sisimai::MIME->boundary($heads->{'content-type'}, 1);
    my $bodystring = '';
    my $notdecoded = '';

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
            if( $e eq $boundary00 ) {
                # The next boundary string has appeared
                # --=_gy7C4Gpes0RP4V5Bs9cK4o2Us2ZT57b-3OLnRN+4klS8dTmQ
                my $hasdecoded = MIME::QuotedPrint::decode($notdecoded);
                   $hasdecoded = Sisimai::String->to_utf8(\$hasdecoded, $encodename);
                $bodystring .= $$hasdecoded;
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
            my $lowercased = lc $e;
            if( $e =~ /\A[-]{2}[^\s]+[^-]\z/ ) {
                # Start of the boundary block
                # --=_gy7C4Gpes0RP4V5Bs9cK4o2Us2ZT57b-3OLnRN+4klS8dTmQ
                unless( $e eq $boundary00 ) {
                    # New boundary string has appeared
                    $boundary00 = $e;
                    $boundary01 = $e . '--';
                }
            } elsif( $lowercased =~ $ReE->{'with-charset'} || $lowercased =~ $ReE->{'only-charset'} ) {
                # Content-Type: text/plain; charset=ISO-2022-JP
                $encodename = $1;
                $mimeinside = 1 if $ctencoding;

            } elsif( $lowercased =~ $ReE->{'quoted-print'} ){
                # Content-Transfer-Encoding: quoted-printable
                $ctencoding = $e;
                $mimeinside = 1 if $encodename;

            } elsif( $e eq $boundary01 ) {
                # The end of boundary block
                # --=_gy7C4Gpes0RP4V5Bs9cK4o2Us2ZT57b-3OLnRN+4klS8dTmQ--
                $mimeinside = 0;
            }
            $bodystring .= $e . "\n";
        }
    }

    $bodystring .= $notdecoded if length $notdecoded;
    return \$bodystring;
}

sub base64d {
    # Decode MIME BASE64 Encoded string
    # @param    [String] argv1   MIME Encoded text
    # @return   [String]         MIME-Decoded text
    my $class = shift;
    my $argv1 = shift // return undef;
    my $plain = undef;

    return \'' unless ref $argv1;
    return \'' unless ref $argv1 eq 'SCALAR';

    # Decode BASE64
    $plain = MIME::Base64::decode($1) if $$argv1 =~ m|([+/=0-9A-Za-z\r\n]+)|;
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

    if( lc $argv1 =~ /\bboundary=([^ ]+)/ ) {
        # Content-Type: multipart/mixed; boundary=Apple-Mail-5--931376066
        # Content-Type: multipart/report; report-type=delivery-status;
        #    boundary="n6H9lKZh014511.1247824040/mx.example.jp"
        $value =  $1;
        $value =~ y/"';\\//d;
        $value =  '--'.$value if $start > -1;
        $value =  $value.'--' if $start >  0;
    }
    return $value;
}

sub breaksup {
    # Breaks up each multipart/* block
    # @param    [String] argv0 Text block of multipart/*
    # @param    [String] argv1 MIME type of the outside part
    # @return   [String] Decoded part as a plain text(text part only)
    my $class = shift;
    my $argv0 = shift || return undef;
    my $argv1 = shift || '';

    my $hasflatten = '';    # Message body including only text/plain and message/*
    my $alsoappend = qr{\A(?:text/rfc822-headers|message/)};
    my $thisformat = qr/\A(?:Content-Transfer-Encoding:\s*.+\n)?Content-Type:\s*([^ ;]+)/;
    my $leavesonly = qr{\A(?>
         text/(?:plain|html|rfc822-headers)
        |message/(?:x?delivery-status|rfc822|partial|feedback-report)
        |multipart/(?:report|alternative|mixed|related|partial)
        )
    }x;
    my $mimeformat = $$argv0 =~ $thisformat ? lc($1) : '';
    my $alternates = index($argv1, 'multipart/alternative') == 0 ? 1 : 0;

    # Sisimai require only MIME types defined in $leavesonly variable
    return \'' unless $mimeformat =~ $leavesonly;
    return \'' if $alternates && $mimeformat eq 'text/html';

    my ($upperchunk, $lowerchunk) = split(/^$/m, $$argv0, 2);
    $upperchunk =~ s/\n/ /g;
    $upperchunk =~ y/ //s;

    # Content-Description: Undelivered Message
    # Content-Type: message/rfc822
    # <EOM>
    $lowerchunk ||= '';

    if( index($mimeformat, 'multipart/') == 0 ) {
        # Content-Type: multipart/*
        my $mpboundary = __PACKAGE__->boundary($upperchunk, 0);
        my @innerparts = split(/\Q$mpboundary\E\n/, $lowerchunk);

        shift @innerparts unless length $innerparts[0];
        while( my $e = shift @innerparts ) {
            # Find internal multipart/* blocks and decode
            if( $e =~ $thisformat ) {
                # Found Content-Type field at the first or second line of this
                # splitted part
                my $nextformat = lc $1;

                next unless $nextformat =~ $leavesonly;
                next if $nextformat eq 'text/html';

                $hasflatten .= ${ __PACKAGE__->breaksup(\$e, $mimeformat) };

            } else {
                # The content of this part is almost '--': a part of boundary
                # string which is used for splitting multipart/* blocks.
                $hasflatten .= "\n";
            }
        }
    } else {
        # Is not "Content-Type: multipart/*"
        if( $upperchunk =~ /Content-Transfer-Encoding: ([^\s;]+)/ ) {
            # Content-Transfer-Encoding: quoted-printable|base64|7bit|...
            my $ctencoding = lc $1;
            my $getdecoded = '';

            if( $ctencoding eq 'quoted-printable' ) {
                # Content-Transfer-Encoding: quoted-printable
                $getdecoded = ${ __PACKAGE__->qprintd(\$lowerchunk) };

            } elsif( $ctencoding eq 'base64' ) {
                # Content-Transfer-Encoding: base64
                $getdecoded = ${ __PACKAGE__->base64d(\$lowerchunk) };

            } elsif( $ctencoding eq '7bit' ) {
                # Content-Transfer-Encoding: 7bit
                if( lc($upperchunk) =~ $ReE->{'some-iso2022'} ) {
                    # Content-Type: text/plain; charset=ISO-2022-JP
                    $getdecoded = ${ Sisimai::String->to_utf8(\$lowerchunk, $1) };

                } else {
                    # No "charset" parameter in Content-Type: field
                    $getdecoded = $lowerchunk;
                }
            } else {
                # Content-Transfer-Encoding: 8bit, binary, and so on
                $getdecoded = $lowerchunk;
            }
            $getdecoded =~ s|\r\n|\n|g; # Convert CRLF to LF

            if( $mimeformat =~ $alsoappend ) {
                # Append field when the value of Content-Type: begins with
                # message/ or equals text/rfc822-headers.
                $upperchunk =~ s/Content-Transfer-Encoding:.+\z//;
                $upperchunk =~ s/[ ]\z//g;
                $hasflatten .= $upperchunk;

            } elsif( $mimeformat eq 'text/html' ) {
                # Delete HTML tags inside of text/html part whenever possible
                $getdecoded = ${ Sisimai::String->to_plain(\$getdecoded) };
            }
            $hasflatten .= $getdecoded."\n\n" if length $getdecoded;

        } else {
            # Content-Type: text/plain OR text/rfc822-headers OR message/*
            if( index($mimeformat, 'message/') == 0 || $mimeformat eq 'text/rfc822-headers' ) {
                # Append headers of multipart/* when the value of "Content-Type"
                # is inlucded in the following MIME types:
                #  - message/delivery-status
                #  - message/rfc822
                #  - text/rfc822-headers
                $hasflatten .= $upperchunk;
            }
            $lowerchunk =~ s/^--\z//m;
            $lowerchunk .= "\n" unless $lowerchunk =~ /\n\z/;
            $hasflatten .= $lowerchunk;
        }
    }
    return \$hasflatten;
}

sub makeflat {
    # MIME decode entire message body
    # @param    [String] argv0 Content-Type header
    # @param    [String] argv1 Entire message body
    # @return   [String] Decoded message body
    my $class = shift;
    my $argv0 = shift // return undef;
    my $argv1 = shift // return undef;

    my $ehboundary = __PACKAGE__->boundary($argv0, 0);
    my $mimeformat = $argv0 =~ qr|\A([0-9a-z]+/[^ ;]+)| ? $1 : '';
    my $bodystring = '';

    return \'' unless index($mimeformat, 'multipart/') > -1;
    return \'' unless $ehboundary;

    # Some bounce messages include lower-cased "content-type:" field such as
    #   content-type: message/delivery-status
    #   content-transfer-encoding: quoted-printable
    $$argv1 =~ s/[Cc]ontent-[Tt]ype:/Content-Type:/gm;
    $$argv1 =~ s/[Cc]ontent-[Tt]ransfer-[Ee]ncodeing:/Content-Transfer-Encoding:/gm;

    # 1. Some bounce messages include upper-cased "Content-Transfer-Encoding",
    #    and "Content-Type" value such as
    #      - Content-Type: multipart/RELATED;
    #      - Content-Transfer-Encoding: 7BIT
    # 2. Unused fields inside of mutipart/* block should be removed
    $$argv1 =~ s/(Content-[A-Za-z-]+?):[ ]*([^\s]+)/$1.': '.lc($2)/eg;
    $$argv1 =~ s/^Content-(?:Description|Disposition):.+\n//gm;

    my @multiparts = split(/\Q$ehboundary\E\n/, $$argv1);
    shift @multiparts unless length $multiparts[0];
    while( my $e = shift @multiparts ) {
        # Find internal multipart blocks and decode
        if( $e =~ /\A(?:Content-[A-Za-z-]+:.+?\r\n)?Content-Type:[ ]*[^\s]+/ ) {
            # Content-Type: multipart/*
            $bodystring .= ${ __PACKAGE__->breaksup(\$e, $mimeformat) };

        } else {
            # Is not multipart/* block
            $e =~ s|^Content-Transfer-Encoding:.+?\n||sim;
            $e =~ s|^Content-Type:\s*text/plain.+?\n||sim;
            $bodystring .= $e;
        }
    }

    # Remove entire message body of the original message beginning from
    # Content-Type: message/rfc822 field so Sisimai does not read the message
    # body for detecting a bounce reason, for getting email header fields of
    # the original message.
    $bodystring =~ s{^(Content-Type:\s*message/(?:rfc822|delivery-status)).+$}{$1}gm;
    $bodystring =~ s|^\n{2,}|\n|gm;

    return \$bodystring;
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

=head2 C<B<breaksup(I<\String>, I<String>)>>

C<breaksup> is a multipart/* message decoder: Decode quoted-printable, base64,
and other encoded message part, leave only text/plain, message/*, text/html 
(only in multipart/alternative), returns string as a reference. This method is
called from makeflat() and breaksup() itself.

=head2 C<B<makeflat(I<String>, I<\String>)>>

C<makeflat> makes flat multipart/* message: it leaves only text/html, message/*,
and text/html (Content-Type of upper part is not multipart/alternative) part.
In other words, this method remove parts which is not needed to parse bounce
message such as image/*, text/html inside of multipart/alternative.

    my $r = 'multipart/report; ...';    # Content-Type: MIME type, boundary
    my $b = '...';                      # Multipart message body
    my $v = Sisimai::MIME->makeflat($r, \$b);   # Returns scalar reference
    print $$v;                  # Flatten message body

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
