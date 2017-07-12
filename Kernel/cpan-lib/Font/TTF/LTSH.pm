package Font::TTF::LTSH;

=head1 NAME

Font::TTF::LTSH - Linear Threshold table

=head1 DESCRIPTION

Holds the linear threshold for each glyph. This is the ppem value at which a
glyph's metrics become linear. The value is set to 1 if a glyph's metrics are
always linear.

=head1 INSTANCE VARIABLES

=over 4

=item glyphs

An array of ppem values. One value per glyph

=back

=head1 METHODS

=cut

use strict;
use vars qw(@ISA);
use Font::TTF::Table;

@ISA = qw(Font::TTF::Table);

=head2 $t->read

Reads the table

=cut

sub read
{
    my ($self) = @_;
    $self->SUPER::read or return $self;

    my ($fh) = $self->{' INFILE'};
    my ($numg, $dat);

    $fh->read($dat, 4);
    ($self->{'Version'}, $numg) = unpack("nn", $dat);
    $self->{'Num'} = $numg;

    $fh->read($dat, $numg);
    $self->{'glyphs'} = [unpack("C$numg", $dat)];
    $self;
}


=head2 $t->out($fh)

Outputs the LTSH to the given fh.

=cut

sub out
{
    my ($self, $fh) = @_;
    my ($numg) = $self->{' PARENT'}{'maxp'}{'numGlyphs'};

    return $self->SUPER::out($fh) unless ($self->{' read'});

    $fh->print(pack("nn", 0, $numg));
    $fh->print(pack("C$numg", @{$self->{'glyphs'}}));
    $self;
}
    
=head2 $t->minsize()

Returns the minimum size this table can be. If it is smaller than this, then the table
must be bad and should be deleted or whatever.

=cut

sub minsize
{
    return 4;
}


1;

=head1 BUGS

None known

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>. 


=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.



=cut


