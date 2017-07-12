package Font::TTF::Gloc;

=head1 NAME

Font::TTF::Gloc - Offsets into Glat table for the start of the attributes for each glyph

=head1 DESCRIPTION

The Gloc table is a bit like the Loca table only for Graphite glyph attributes. The table
has the following elements:

=over 4

=item Version

Table format version

=item numAttrib

Maximum number of attributes associated with a glyph.

=item locations

An array of offsets into the Glat table for the start of each glyph

=item names

If defined, an array of name table name ids indexed by attribute number.

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

    my ($fh) = $self->{' INFILE'};
    my ($numGlyphs);
    my ($dat, $flags);

    $fh->read($dat, 4);
    ($self->{'Version'}) = TTF_Unpack("v", $dat);
    $fh->read($dat, 4);
    ($flags, $self->{'numAttrib'}) = TTF_Unpack("SS", $dat);
    $numGlyphs = ($self->{' LENGTH'} - 8 - ($flags & 2 ? $self->{'numAttrib'} * 2 : 0)) / (($flags & 1) ? 4 : 2) - 1;
    $self->{'numGlyphs'} = $numGlyphs;
    if ($flags & 1)
    {
        $fh->read($dat, 4 * ($numGlyphs + 1));
        $self->{'locations'} = [unpack("N*", $dat)];
    }
    else
    {
        $fh->read($dat, 2 * ($numGlyphs + 1));
        $self->{'locations'} = [unpack("n*", $dat)];
    }
    if ($flags & 2)
    {
        $fh->read($dat, 2 * $self->{'numAttrib'});
        $self->{'names'} = [unpack("n*", $dat)];
    }
    return $self;
}

sub out
{
    my ($self, $fh) = @_;
    my ($numGlyphs) = 0;
    my ($flags, $num);

    return $self->SUPER::out($fh) unless ($self->{' read'});
    $numGlyphs = scalar @{$self->{' PARENT'}{'Glat'}{'attribs'}};
    $num = $self->{'numAttrib'};
    $flags = 1 if ($self->{'locations'}[-1] > 0xFFFF);
    $flags |= 2 if ($self->{'names'});
    $fh->print(TTF_Pack("vSS", $self->{'Version'}, $flags, $num));
    $fh->write(pack(($flags & 1 ? "N" : "n") . ($numGlyphs + 1), @{$self->{'locations'}}));
    if ($flags & 2)
    { $fh->write(pack("n$num", @{$self->{'names'}})); }
}

=back 

=head2 $t->minsize()

Returns the minimum size this table can be. If it is smaller than this, then the table
must be bad and should be deleted or whatever.

=cut

sub minsize
{
    return 8;
}

1;

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>. 


=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.



=cut