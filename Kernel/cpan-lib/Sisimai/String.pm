package Sisimai::String;
use feature ':5.10';
use strict;
use warnings;
use Encode;
use Encode::Guess;
use Digest::SHA;

sub EOM {
    # End of email message as a sentinel for parsing bounce messages
    # @private
    # @return   [String] Fixed length string like a constant
    return '__END_OF_EMAIL_MESSAGE__';
}

sub token {
    # Create the message token from an addresser and a recipient
    # @param    [String] addr1  A sender's email address
    # @param    [String] addr2  A recipient's email address
    # @param    [Integer] epoch Machine time of the email bounce
    # @return   [String]        Message token(MD5 hex digest) or empty string 
    #                           if the any argument is missing
    # @see       http://en.wikipedia.org/wiki/ASCII
    # @see       https://metacpan.org/pod/Digest::MD5
    my $class = shift || return '';
    my $addr1 = shift || return '';
    my $addr2 = shift || return '';
    my $epoch = shift // return '';

    # Format: STX(0x02) Sender-Address RS(0x1e) Recipient-Address ETX(0x03)
    return Digest::SHA::sha1_hex(
        sprintf("\x02%s\x1e%s\x1e%d\x03", lc $addr1, lc $addr2, $epoch));
}

sub is_8bit {
    # The argument is 8-bit text or not
    # @param    [String] argv1  Any string to be checked
    # @return   [Integer]       0: ASCII Characters only
    #                           1: Including 8-bit character
    my $class = shift;
    my $argv1 = shift // return undef;

    return undef unless ref $argv1;
    return undef unless ref $argv1 eq 'SCALAR';
    return 1 unless $$argv1 =~ /\A[\x00-\x7f]+\z/;
    return 0;
}

sub sweep {
    # Clean the string out
    # @param    [String] argv1  String to be cleaned
    # @return   [Scalar]        Cleaned out string
    # @example  Clean up text
    #   sweep('  neko ') #=> 'neko'
    my $class = shift;
    my $argv1 = shift // return undef;

    chomp $argv1;
    $argv1 =~ y/ //s;
    $argv1 =~ y/\t//d;
    $argv1 =~ s/\A //g;
    $argv1 =~ s/ \z//g;
    $argv1 =~ s/ [-]{2,}[^ \t].+\z//;
    return $argv1;
}

sub to_plain {
    # Convert given HTML text to plain text
    # @param    [Scalar]  argv1 HTML text(reference to string)
    # @param    [Integer] loose Loose check flag
    # @return   [Scalar]        Plain text(reference to string)
    my $class = shift;
    my $argv1 = shift // return \'';
    my $loose = shift // 0;

    return \'' unless ref $argv1;
    return \'' unless ref $argv1 eq 'SCALAR';

    my $plain = $$argv1;
    my $match = {
        'html' => qr|<html[ >].+?</html>|sim,
        'body' => qr|<head>.+</head>.*<body[ >].+</body>|sim,
    };

    if( $loose || $plain =~ $match->{'html'} || $plain =~ $match->{'body'} ) {
        # <html> ... </html>
        # 1. Remove <head>...</head>
        # 2. Remove <style>...</style>
        # 3. <a href = 'http://...'>...</a> to " http://... "
        # 4. <a href = 'mailto:...'>...</a> to " Value <mailto:...> "
        $plain =~ s|<head>.+</head>||gsim;
        $plain =~ s|<style.+?>.+</style>||gsim;
        $plain =~ s|<a\s+href\s*=\s*['"](https?://.+?)['"].*?>(.*?)</a>| [$2]($1) |gsim;
        $plain =~ s|<a\s+href\s*=\s*["']mailto:([^\s]+?)["']>(.*?)</a>| [$2](mailto:$1) |gsim;

        $plain =~ s/<[^<@>]+?>\s*/ /g;  # Delete HTML tags except <neko@example.jp>
        $plain =~ s/&lt;/</g;           # Convert to left angle brackets
        $plain =~ s/&gt;/>/g;           # Convert to right angle brackets
        $plain =~ s/&amp;/&/g;          # Convert to "&"
        $plain =~ s/&quot;/"/g;         # Convert to '"'
        $plain =~ s/&apos;/'/g;         # Convert to "'"
        $plain =~ s/&nbsp;/ /g;         # Convert to ' '

        if( length($$argv1) > length($plain) ) {
            $plain =~ y/ //s;
            $plain .= "\n"
        }
    }
    return \$plain;
}

sub to_utf8 {
    # Convert given string to UTF-8
    # @param    [String] argv1  String to be converted
    # @param    [String] argv2  Encoding name before converting
    # @return   [String]        UTF-8 Encoded string
    my $class = shift;
    my $argv1 = shift || return \'';
    my $argv2 = shift;

    my $tobeutf8ed = $$argv1;
    my $encodefrom = lc $argv2 || '';
    my $hasencoded = undef;
    my $hasguessed = Encode::Guess->guess($tobeutf8ed);
    my $encodingto = ref $hasguessed ? lc($hasguessed->name) : '';
    my $dontencode = qr/\A(?>utf[-]?8|(?:us[-])?ascii)\z/;

    if( $encodefrom ) {
        # The 2nd argument is a encoding name of the 1st argument
        while(1) {
            # Encode a given string when the encoding of the string is neigther
            # utf8 nor ascii.
            last if $encodefrom =~ $dontencode;
            last if $encodingto =~ $dontencode;

            eval { 
                # Try to convert the string to UTF-8
                Encode::from_to($tobeutf8ed, $encodefrom, 'utf8');
                $hasencoded = 1;
            };
            last;
        }
    }

    unless( $hasencoded ) {
        # The 2nd argument was not given or failed to convert from $encodefrom
        # to UTF-8
        if( $encodingto ) {
            # Guessed encoding name is available, try to encode using it.
            unless( $encodingto =~ $dontencode ) {
                # Encode a given string when the encoding of the string is neigther
                # utf8 nor ascii.
                eval { 
                    Encode::from_to($tobeutf8ed, $encodingto, 'utf8');
                    $hasencoded = 1;
                };
            }
        }
    }
    return \$tobeutf8ed;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::String - String related class

=head1 SYNOPSIS

    use Sisimai::String;
    my $s = 'envelope-sender@example.jp';
    my $r = 'envelope-recipient@example.org';
    my $t = time();

    print Sisimai::String->token($s, $r, $t);  # 2d635de42a44c54b291dda00a93ac27b
    print Sisimai::String->is_8bit(\'猫');     # 1
    print Sisimai::String->sweep(' neko cat ');# 'neko cat'

    print Sisimai::String->to_utf8('^[$BG-^[(B', 'iso-2022-jp');  # 猫
    print Sisimai::String->to_plain('<html>neko</html>');   # neko

=head1 DESCRIPTION

Sisimai::String provide utilities for dealing string

=head1 CLASS METHODS

=head2 C<B<token(I<sender>, I<recipient>)>>

C<token()> generates a token: Unique string generated by an envelope sender
address and a envelope recipient address.

    my $s = 'envelope-sender@example.jp';
    my $r = 'envelope-recipient@example.org';

    print Sisimai::String->token($s, $r);    # 2d635de42a44c54b291dda00a93ac27b

=head2 C<B<is_8bit(I<Reference to String>)>>

C<is_8bit()> checks the argument include any 8bit character or not.

    print Sisimai::String->is_8bit(\'cat');  # 0;
    print Sisimai::String->is_8bit(\'ねこ'); # 1;

=head2 C<B<sweep(I<String>)>>

C<sweep()> clean the argument string up: remove trailing spaces, squeeze spaces.

    print Sisimai::String->sweep(' cat neko ');  # 'cat neko';
    print Sisimai::String->sweep(' nyaa   !!');  # 'nyaa !!';

=head2 C<B<to_utf8(I<Reference to String>, [I<Encoding>])>>

C<to_utf8> converts given string to UTF-8.

    my $v = '^[$BG-^[(B';   # ISO-2022-JP
    print Sisimai::String->to_utf8($v, 'iso-2022-jp');  # 猫

=head2 C<B<to_plain(I<Reference to String>, [I<Loose Check>])>>

C<to_plain> converts given string as HTML to plain text.

    my $v = '<html>neko</html>';
    print Sisimai::String->to_plain($v);    # neko

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
