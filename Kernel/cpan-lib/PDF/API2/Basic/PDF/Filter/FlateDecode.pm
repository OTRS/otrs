package PDF::API2::Basic::PDF::Filter::FlateDecode;

use base 'PDF::API2::Basic::PDF::Filter';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use POSIX qw(ceil floor);

our $havezlib;

BEGIN
{
    eval { require Compress::Zlib };
    $havezlib = !$@;
}

sub new
{
    return unless $havezlib;
    my ($class, $decode_parms) = @_;
    my ($self) = {
        DecodeParms => $decode_parms,
    };

    $self->{'outfilt'} = Compress::Zlib::deflateInit(
      -Level=>9,
      -Bufsize=>32768,
    );
    $self->{'infilt'} = Compress::Zlib::inflateInit();
    bless $self, $class;
}

sub outfilt
{
    my ($self, $str, $isend) = @_;
    my ($res);

    $res = $self->{'outfilt'}->deflate($str);
    $res .= $self->{'outfilt'}->flush() if ($isend);
    $res;
}

sub infilt
{
    my ($self, $dat, $last) = @_;
    my ($res, $status) = $self->{'infilt'}->inflate("$dat");

    if ($self->{'DecodeParms'} and $self->{'DecodeParms'}->{'Predictor'}) {
        my $predictor = $self->{'DecodeParms'}->{'Predictor'}->val();
        if ($predictor == 2) {
            die "The TIFF predictor logic has not been implemented";
        }
        elsif ($predictor >= 10 and $predictor <= 15) {
            $res = $self->_depredict_png($res);
        }
        else {
            die "Invalid predictor: $predictor";
        }
    }

    return $res;
}

sub _depredict_png {
    my ($self, $stream) = @_;
    my $param  = $self->{'DecodeParms'};

    my $prev = '';
    $stream = $self->{'_depredict_next'} . $stream if defined $self->{'_depredict_next'};
    $prev   = $self->{'_depredict_prev'}           if defined $self->{'_depredict_prev'};

    my $alpha   = $param->{Alpha}            ? $param->{Alpha}->val()            : 0;
    my $bpc     = $param->{BitsPerComponent} ? $param->{BitsPerComponent}->val() : 8;
    my $colors  = $param->{Colors}           ? $param->{Colors}->val()           : 1;
    my $columns = $param->{Columns}          ? $param->{Columns}->val()          : 1;
    my $height  = $param->{Height}           ? $param->{Height}->val()           : 0;

    my $comp     = $colors + $alpha;
    my $bpp      = ceil($bpc * $comp / 8);
    my $scanline = 1 + ceil($bpp * $columns);

    my $clearstream = '';
    my $lastrow = ($height || int(length($stream) / $scanline)) - 1;
    foreach my $n (0 .. $lastrow) {
        # print STDERR "line $n:";
        my $line = substr($stream, $n * $scanline, $scanline);
        my $filter = vec($line, 0, 8);
        my $clear = '';
        $line = substr($line, 1);
        # print STDERR " filter=$filter ";
        if ($filter == 0) {
            $clear = $line;
        }
        elsif ($filter == 1) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear, $x, 8) = (vec($line, $x, 8) + vec($clear, $x - $bpp, 8)) % 256;
            }
        }
        elsif ($filter == 2) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear, $x, 8) = (vec($line, $x, 8) + vec($prev, $x, 8)) % 256;
            }
        }
        elsif ($filter == 3) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear, $x, 8) = (vec($line, $x, 8) + floor((vec($clear, $x - $bpp, 8) + vec($prev, $x, 8)) / 2)) % 256;
            }
        }
        elsif ($filter == 4) {
            foreach my $x (0 .. length($line) - 1) {
                vec($clear, $x, 8) = (vec($line, $x, 8) + _paeth_predictor(vec($clear, $x - $bpp, 8), vec($prev, $x, 8), vec($prev, $x - $bpp, 8))) % 256;
            }
        }
        else {
            die "Unexpected depredictor algorithm $filter requested on line $n (valid options are 0-4)";
        }
        $prev = $clear;
        foreach my $x (0 .. ($columns * $comp) - 1) {
            vec($clearstream, ($n * $columns * $comp) + $x, $bpc) = vec($clear, $x, $bpc);
            # print STDERR "" . vec($clear, $x, $bpc) . ",";
        }
        # print STDERR "\n";
    }
    $self->{'_depredict_next'} = substr($stream, ($lastrow + 1) * $scanline);
    $self->{'_depredict_prev'} = $prev;

    return $clearstream;
}

sub _paeth_predictor {
    my ($a, $b, $c) = @_;
    my $p = $a + $b - $c;
    my $pa = abs($p - $a);
    my $pb = abs($p - $b);
    my $pc = abs($p - $c);
    if ($pa <= $pb && $pa <= $pc) {
        return $a;
    }
    elsif ($pb <= $pc) {
        return $b;
    }
    else {
        return $c;
    }
}

1;
