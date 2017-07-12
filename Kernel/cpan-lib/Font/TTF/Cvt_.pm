package Font::TTF::Cvt_;

=head1 NAME

Font::TTF::Cvt_ - Control Value Table in a TrueType font

=head1 DESCRIPTION

This is a minimal class adding nothing beyond a table, but is a repository
for cvt type information for those processes brave enough to address hinting.

=head1 INSTANCE VARIABLES

=over 4

=item val

This is an array of CVT values. Thus access to the CVT is via:

    $f->{'cvt_'}{'val'}[$num];

=back    

=head1 METHODS

=cut

use strict;
use vars qw(@ISA $VERSION);
use Font::TTF::Utils;

@ISA = qw(Font::TTF::Table);

$VERSION = 0.0001;

=head2 $t->read

Reads the CVT table into both the tables C<' dat'> variable and the C<val>
array.

=cut

sub read
{
    my ($self) = @_;

    $self->read_dat || return undef;
    $self->{' read'} = 1;
    $self->{'val'} = [TTF_Unpack("s*", $self->{' dat'})];
    $self;
}


=head2 $t->update

Updates the RAM file copy C<' dat'> to be the same as the array.

=cut

sub update
{
    my ($self) = @_;

    return undef unless ($self->{' read'} && $#{$self->{'val'}} >= 0);
    $self->{' dat'} = TTF_Pack("s*", @{$self->{'val'}});
    $self;
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

