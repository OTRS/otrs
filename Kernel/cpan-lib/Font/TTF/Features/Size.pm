package Font::TTF::Features::Size;

=head1 NAME

Font::TTF::Features::Size - Class for Size Feature Parameters

=head1 DESCRIPTION

Handles the Feature Parameters valus for Size features

=head1 INSTANCE VARIABLES

=over 4

=item INFILE

The read file handle

=item OFFSET

Location of the file in the input file

=item DesignSize

Design Size in decipoints

=item SubFID

Identifier for the fonts in a subfamily

=item SubFNameID

The 'name' table name ID for the subfamily name

=item MinSize

Bottom end of recomended usage size range

=item MaxSize

Top end of recomended usage size range


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
    $fh->read($dat, 10);

    (    $self->{'DesignSize'}
				,$self->{'SubFID'}
				,$self->{'SubFNameID'}
				,$self->{'MinSize'}
				,$self->{'MaxSize'} ) = TTF_Unpack("S*", $dat);

    return $self;
}

=head2 $t->out($fh)

Writes the FeatureParams table to the output

=cut

sub out
{
    my ($self, $fh) = @_;
    
    $fh->print(TTF_Pack("S*" 
    		,$self->{'DesignSize'}
    		,$self->{'SubFID'}
    		,$self->{'SubFNameID'}
    		,$self->{'MinSize'}
    		,$self->{'MaxSize'} ));
    $self;
}

=head2 Font::TTF::Features::Sset->new()

Creates a new FeatureParams object.  Table instance variables are passed in
at this point as an associative array.

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

