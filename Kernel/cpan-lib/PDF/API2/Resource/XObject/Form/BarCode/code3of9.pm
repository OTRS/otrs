package PDF::API2::Resource::XObject::Form::BarCode::code3of9;

use base 'PDF::API2::Resource::XObject::Form::BarCode';

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub new {
    my ($class, $pdf, %options) = @_;
    my $self = $class->SUPER::new($pdf, %options);

    my @bars = encode_3of9($options{'-code'},
                           $options{'-chk'} ? 1 : 0,
                           $options{'-ext'} ? 1 : 0);

    $self->drawbar([@bars], $options{'caption'});

    return $self;
}

my $code3of9 = q(0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*);

my @bar3of9 = qw(
    1112212111  2112111121  1122111121  2122111111
    1112211121  2112211111  1122211111  1112112121
    2112112111  1122112111  2111121121  1121121121
    2121121111  1111221121  2111221111  1121221111
    1111122121  2111122111  1121122111  1111222111
    2111111221  1121111221  2121111211  1111211221
    2111211211  1121211211  1111112221  2111112211
    1121112211  1111212211  2211111121  1221111121
    2221111111  1211211121  2211211111  1221211111
    1211112121  2211112111  1221112111  1212121111
    1212111211  1211121211  1112121211  abaababaa1
);

my @extended_map = (
    '%U', '$A', '$B', '$C', '$D', '$E', '$F', '$G', '$H', '$I',
    '$J', '$K', '$L', '$M', '$N', '$O', '$P', '$Q', '$R', '$S',
    '$T', '$U', '$V', '$W', '$X', '$Y', '$Z', '%A', '%B', '%C',
    '%D', '$E', ' ',  '/A', '/B', '/C', '/D', '/E', '/F', '/G',
    '/H', '/I', '/J', '/K', '/L', '-',  '.',  '/O', '0',  '1',
    '2',  '3',  '4',  '5',  '6',  '7',  '8',  '9',  '/Z', '%F',
    '%G', '%H', '%I', '%J', '%V', 'A',  'B',  'C',  'D',  'E',
    'F',  'G',  'H',  'I',  'J',  'K',  'L',  'M',  'N',  'O',
    'P',  'Q',  'R',  'S',  'T',  'U',  'V',  'W',  'X',  'Y',
    'Z',  '%K', '%L', '%M', '%N', '%O', '%W', '+A', '+B', '+C',
    '+D', '+E', '+F', '+G', '+H', '+I', '+J', '+K', '+L', '+M',
    '+N', '+O', '+P', '+Q', '+R', '+S', '+T', '+U', '+V', '+W',
    '+X', '+Y', '+Z', '%P', '%Q', '%R', '%S', '%T'
);

sub encode_3of9_char {
    my $character = shift();
    return $bar3of9[index($code3of9, $character)];
}

sub encode_3of9_string {
    my ($string, $is_mod43) = @_;

    my $bar;
    my $checksum = 0;
    foreach my $char (split //, $string) {
        $bar .= encode_3of9_char($char);
        $checksum += index($code3of9, $char);
    }

    if ($is_mod43) {
        $checksum %= 43;
        $bar .= $bar3of9[$checksum];
    }

    return $bar;
}

# Deprecated (rolled into encode_3of9_string)
sub encode_3of9_string_w_chk { return encode_3of9_string(shift(), 1); }

sub encode_3of9 {
    my ($string, $is_mod43, $is_extended) = @_;

    my $display;
    unless ($is_extended) {
        $string = uc $string;
        $string =~ s/[^0-9A-Z\-\.\ \$\/\+\%]+//g;
        $display = $string;
    }
    else {
        # Extended Code39 supports all 7-bit ASCII characters
        $string =~ s/[^\x00-\x7f]//g;
        $display = $string;

        # Encode, but don't display, non-printable characters
        $display =~ s/[[:cntrl:]]//g;

        $string = join('', map { $extended_map[ord($_)] } split //, $string);
    }

    my @bars;
    push @bars, encode_3of9_char('*');
    push @bars, [ encode_3of9_string($string, $is_mod43), $display ];
    push @bars, encode_3of9_char('*');
    return @bars;
}

# Deprecated (rolled into encode_3of9)
sub encode_3of9_w_chk     { return encode_3of9(shift(), 1, 0); }
sub encode_3of9_ext       { return encode_3of9(shift(), 0, 1); }
sub encode_3of9_ext_w_chk { return encode_3of9(shift(), 1, 1); }

1;
