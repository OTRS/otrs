package Font::TTF::DSIG;

use strict;
use vars qw(@ISA);

require Font::TTF::Table;
use Font::TTF::Utils;

@ISA = qw(Font::TTF::Table);

sub create
{
    my ($class) = @_;
    my ($self) = { 'version' => 1, 'numtables' => 0, 'perms' => 0 };
    bless $self, ref $class || $class;
    return $self;
}

sub read
{
    my ($self) = @_;
    my ($dat, $i, @records, $r);

    $self->SUPER::read || return $self;
    $self->{' INFILE'}->read($dat, 8);
    ($self->{'version'}, $self->{'numtables'}, $self->{'perms'}) = unpack("Nnn", $dat);
    for ($i = 0; $i < $self->{'numtables'}; $i++)
    {
        $self->{' INFILE'}->read($dat, 12);
        push (@records, [unpack("N3", $dat)]);
    }
    foreach $r (@records)
    {
        if ($r->[0] == 1)
        {
            $self->{' INFILE'}->seek($self->{' OFFSET'} + $r->[2],0);
            $self->{' INFILE'}->read($dat, $r->[1]);
            push @{$self->{'records'}}, substr($dat, 8);
        }
    }
    $self;
}

sub isempty
{
    my ($self) = @_;
    return $self->read->{'numtables'} == 0;
}

sub out
{
    my ($self, $fh) = @_;
    my ($i, $curlen);

    return $self->SUPER::out($fh) unless $self->{' read'};      # this is never true
    $fh->print(pack("Nnn", $self->{'version'}, $self->{'numtables'}, $self->{'perms'}));
    $curlen = 0;
    for ($i = 0; $i < $self->{'numtables'}; $i++)
    {
        $fh->print(pack("N3", 1, length($self->{'records'}[$i]) + 8, $curlen + $self->{'numtables'} * 12 + 8));
        $curlen += length($self->{'records'}[$i]) + 8;
    }
    for ($i = 0; $i < $self->{'numtables'}; $i++)
    {
        $fh->print(pack("nnN", 0, 0, length($self->{'records'}[$i])));
        $fh->print($self->{'records'}[$i]);
    }
    $self;
}

1;

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>. 


=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.



=cut

