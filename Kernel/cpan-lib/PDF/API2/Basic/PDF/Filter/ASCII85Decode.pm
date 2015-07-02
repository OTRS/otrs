package PDF::API2::Basic::PDF::Filter::ASCII85Decode;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Basic::PDF::Filter';

use strict;
use warnings;

sub outfilt {
    my ($self, $str, $isend) = @_;
    my ($res, $i, $j, $b, @c);

    if ($self->{'outcache'} ne "") {
        $str = $self->{'outcache'} . $str;
        $self->{'outcache'} = "";
    }
    for ($i = 0; $i < length($str); $i += 4) {
        $b = unpack("N", substr($str, $i, 4));
        if ($b == 0) {
            $res .= "z";
            next;
        }
        for ($j = 0; $j < 4; $j++) {
            $c[$j] = $b - int($b / 85) * 85 + 33; $b /= 85;
        }
        $res .= pack("C5", @c, $b + 33);
        $res .= "\n" if ($i % 60 == 56);
    }
    if ($isend && $i > length($str)) {
        $b = unpack("N", substr($str, $i - 4) . "\000\000\000");
        for ($j = 0; $j < 4; $j++) {
            $c[$j] = $b - int($b / 85) * 85 + 33; $b /= 85;
        }
        $res .= substr(pack("C5", @c, $b), 0, $i - length($str) + 1) . "->";
    }
    elsif ($i > length($str)) {
        $self->{'outcache'} = substr($str, $i - 4);
    }

    return $res;
}

sub infilt {
    my ($self, $str, $isend) = @_;
    my ($res, $i, $j, @c, $b, $num);
    $num = 0;
    if (exists($self->{'incache'}) && $self->{'incache'} ne "") {
        $str = $self->{'incache'} . $str;
        $self->{'incache'} = "";
    }
    $str =~ s/(\r|\n)\n?//og;
    for ($i = 0; $i < length($str); $i += 5) {
        $b = 0;
        if (substr($str, $i, 1) eq "z") {
            $i -= 4;
            $res .= pack("N", 0);
            next;
        }
        elsif ($isend && substr($str, $i, 6) =~ m/^(.{2,4})\~\>$/o) {
            $num = 5 - length($1);
            @c = unpack("C5", $1 . ("u" x (4 - $num)));     # pad with 84 to sort out rounding
            $i = length($str);
        }
        else {
            @c = unpack("C5", substr($str, $i, 5));
        }

        for ($j = 0; $j < 5; $j++) {
            $b *= 85;
            $b += $c[$j] - 33;
        }
        $res .= substr(pack("N", $b), 0, 4 - $num);
    }
    if (!$isend && $i > length($str)) {
        $self->{'incache'} = substr($str, $i - 5);
    }

    return $res;
}

1;
