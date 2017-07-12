package PDF::API2::Basic::PDF::Filter::LZWDecode;

use base 'PDF::API2::Basic::PDF::Filter::FlateDecode';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

sub new {
    my ($class, $decode_parms) = @_;
    my $self = {
        DecodeParms => $decode_parms,
    };

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
    my ($code, $result);
    my $partial_code = $self->{'partial_code'};
    my $partial_bits = $self->{'partial_bits'};

    my $early_change = 1;
    if ($self->{'DecodeParms'} and $self->{'DecodeParms'}->{'EarlyChange'}) {
        $early_change = $self->{'DecodeParms'}->{'EarlyChange'}->val();
    }

    while ($data ne '') {
        ($code, $partial_code, $partial_bits) = $self->read_dat(\$data, $partial_code, $partial_bits, $self->{'code_length'});
        last unless defined $code;

        unless ($early_change) {
            if ($self->{'next_code'} == (1 << $self->{'code_length'}) and $self->{'code_length'} < 12) {
                $self->{'code_length'}++;
            }
        }

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

        if ($early_change) {
            if ($self->{'next_code'} == (1 << $self->{'code_length'}) and $self->{'code_length'} < 12) {
                $self->{'code_length'}++;
            }
        }
    }
    $self->{'partial_code'} = $partial_code;
    $self->{'partial_bits'} = $partial_bits;
    return $result;
}

sub read_dat {
    my ($self, $data_ref, $partial_code, $partial_bits, $code_length) = @_;
    $partial_bits = 0 unless defined $partial_bits;

    while ($partial_bits < $code_length) {
        return (undef, $partial_code, $partial_bits) unless length($$data_ref);
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
