package PDF::API2::Basic::PDF::Filter::LZWDecode;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Basic::PDF::Filter::FlateDecode';

no warnings qw[ deprecated recursion uninitialized ];

sub new {
    my $class = shift();
    my $self = {};

    $self->{'table'} = [map { pack('C', $_) } (0 .. 255, 0, 0)];
    $self->{'initial_code_length'} = 9;
    $self->{'code_length'} = 9;
    $self->{'clear_table'} = 256;
    $self->{'eod_marker'} = 257;
    $self->{'next_code'} = 258;

    bless $self, $class;
    return $self;
}

sub infilt {
    my ($self, $data, $is_last) = @_;
    my ($code, $partial_code, $partial_bits, $result);

    while ($data ne '' or $partial_bits) {
        ($code, $partial_code, $partial_bits) = $self->read_dat(\$data, $partial_code, $partial_bits, $self->{'code_length'});
        $self->{'code_length'}++ if $self->{'next_code'} == (1 << $self->{'code_length'});

        if ($code == $self->{'clear_table'}) {
            $self->{'code_length'} = $self->{'initial_code_length'};
            $self->{'next_code'} = $self->{'eod_marker'} + 1;
            next;
        }
        elsif ($code == $self->{'eod_marker'}) {
            last;
        }
        elsif ($code > $self->{'eod_marker'}) {
            $self->{'table'}[$self->{'next_code'}] = $self->{'table'}[$code];
            $self->{'table'}[$self->{'next_code'}] .= substr($self->{'table'}[$code + 1], 0, 1);
            $result .= $self->{'table'}[$self->{'next_code'}];
            $self->{'next_code'}++;
        }
        else {
            $self->{'table'}[$self->{'next_code'}] = $self->{'table'}[$code];
            $result .= $self->{'table'}[$self->{'next_code'}];
            $self->{'next_code'}++;
        }
    }
    return $result;
}

sub read_dat {
    my ($self, $data_ref, $partial_code, $partial_bits, $code_length) = @_;
    $partial_bits = 0 unless defined $partial_bits;

    while ($partial_bits < $code_length) {
        $partial_code = ($partial_code << 8) + unpack('C', $$data_ref);
        substr($$data_ref, 0, 1) = '';
        $partial_bits += 8;
    }

    my $code = $partial_code >> ($partial_bits - $code_length);
    $partial_code &= (1 << ($partial_bits - $code_length)) - 1;
    $partial_bits -= $code_length;

    return ($code, $partial_code, $partial_bits);
}

1;
