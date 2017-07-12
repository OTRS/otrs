package Font::TTF::Features::Sset;

=head1 NAME

Font::TTF::Features::Sset - Class for Stylistic Set Feature Parameters

=head1 DESCRIPTION

Handles the Feature Parameters valus for Stylistic Sets

=head1 INSTANCE VARIABLES

=over 4

=item INFILE

The read file handle

=item OFFSET

Location of the file in the input file

=item Version

The minor version number, currently always 0

=item UINameID

The 'name' table name ID that specifies a string (or strings, for multiple 
languages) for a user-interface label for this feature

=back

=head1 METHODS

=cut

use Font::TTF::Utils;
use strict;

=head2 $t->read

Reads the Feature Params

=cut

sub read
{
    my ($self) = @_;
    my ($fh) = $self->{' INFILE'};
    my ($off) = $self->{' OFFSET'};
    my $dat;
		$fh->seek($off, 0); 
    $fh->read($dat, 4);
    ($self->{'Version'}, $self->{'UINameID'}) = TTF_Unpack("SS", $dat);

    return $self;
}

=head2 $t->out($fh)

Writes the FeatureParams table to the output

=cut

sub out
{
    my ($self, $fh) = @_;
    $fh->print(TTF_Pack("S", $self->{'Version'}));
    $fh->print(TTF_Pack("S", $self->{'UINameID'}));
    $self;
}

=head2 Font::TTF::Features::Sset->new()

Creates a new FeatureParams object.
Values for INFILE and OFFSET canbe passed as parameters

=cut

sub new
{
    my ($class,%parms) = @_;
    my ($self) = {};
    my ($p);
    foreach $p (keys %parms)
    { $self->{" $p"} = $parms{$p}; }
    bless $self, $class;
}

sub out_xml
{
}

1;

=head1 AUTHOR

David Raymond L<http://scripts.sil.org/FontUtils>. 

=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.

=cut
