package Font::TTF::Glat;

=head1 NAME

Font::TTF::Glat - Hold glyph attributes

=head1 DESCRIPTION

Holds glyph attributes associated with each glyph.

=over 4

=item Version

Table format version

=item attribs

An array of hashes. On array entry for each glyph id. Since the glyph attributes are usually in a sparse
array, they are stored in a hash keyed by the attribute id and with the value as attribute value.

=cut

use Font::TTF::Table;
use Font::TTF::Utils;
use strict;
use vars qw(@ISA);
@ISA = qw(Font::TTF::Table);

sub read
{
    my ($self) = @_;
    $self->SUPER::read or return $self;

    my ($gloc) = $self->{' PARENT'}{'Gloc'};
    my ($fh) = $self->{' INFILE'};
    my ($numGlyphs);
    my ($base) = $self->{' OFFSET'};
    my ($dat, $i);

    $gloc->read;
    $numGlyphs = $gloc->{'numGlyphs'};
    $fh->seek($base, 0);
    $fh->read($dat, 4);
    ($self->{'Version'}) = TTF_Unpack('v', $dat);

    for ($i = 0; $i < $numGlyphs; $i++)
    {
        my ($j) = 0;
        my ($num) = $gloc->{'locations'}[$i + 1] - $gloc->{'locations'}[$i];
        my ($first, $number, @vals);
        $fh->seek($base + $gloc->{'locations'}[$i], 0);
        $fh->read($dat, $num);
        while ($j < $num)
        {
            if ($self->{'Version'} > 1)
            {
                ($first, $number) = unpack("n2", substr($dat, $j, 4));
                @vals = unpack("n$number", substr($dat, $j + 4, $number * 2));
                $j += ($number + 2) * 2;
            }
            else
            {
                ($first, $number) = unpack("C2", substr($dat, $j, 2));
                @vals = unpack("n$number", substr($dat, $j + 2, $number * 2));
                $j += $number * 2 + 2;
            }
            for (my $k = 0; $k < $number; $k++)
            { $self->{'attribs'}[$i]{$first + $k} = $vals[$k]; }
        }
    }
}

sub out
{
    my ($self, $fh) = @_;
    my ($gloc) = $self->{' PARENT'}{'Gloc'};
    my ($numGlyphs) = 0;
    my ($base) = $fh->tell();
    my ($i, $type);

    return $self->SUPER::out($fh) unless ($self->{' read'});
    $numGlyphs = scalar @{$self->{'attribs'}};
    if ($gloc->{'numAttrib'} > 256)
    {
        $self->{'Version'} = 2;
        $type = "n";
    }
    else
    {
        $self->{'Version'} = 1;
        $type = "C";
    }

    $gloc->{'locations'} = [];
    $fh->print(TTF_Pack('v', $self->{'Version'}));
    for ($i = 0; $i < $numGlyphs; $i++)
    {
        my (@a) = sort {$a <=> $b} keys %{$self->{'attribs'}[$i]};
        push(@{$gloc->{'locations'}}, $fh->tell() - $base);
        while (@a)
        {
            my ($first) = shift(@a);
            my ($next) = $first;
            my (@v, $j);
            while (@a and $a[0] <= $next + 2)
            { $next = shift(@a); }
            for ($j = $first; $j <= $next; $j++)
            { push (@v, $self->{'attribs'}[$i]{$j}); }
            { $fh->print(pack("${type}2n*", $first, $next - $first + 1, @v)); }
        }
    }
    push(@{$gloc->{'locations'}}, $fh->tell() - $base);
}

=back

=head2 $t->minsize()

Returns the minimum size this table can be. If it is smaller than this, then the table
must be bad and should be deleted or whatever.

=cut

sub minsize
{
    return 4;
}

1;

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>. 


=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.



=cut
