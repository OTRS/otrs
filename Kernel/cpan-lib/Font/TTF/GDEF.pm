package Font::TTF::GDEF;

=head1 NAME

Font::TTF::GDEF - Opentype GDEF table support

=head1 DESCRIPTION

The GDEF table contains various global lists of information which are apparantly
used in other places in an OpenType renderer. But precisely where is open to
speculation...

=head1 INSTANCE VARIABLES

There are up to 5 tables in the GDEF table, each with their own structure:

=over 4

=item GLYPH

This is an L<Font::TTF::Coverage> Class Definition table containing information
as to what type each glyph is.

=item ATTACH

The attach table consists of a coverage table and then attachment points for
each glyph in the coverage table:

=over 8

=item COVERAGE

This is a coverage table

=item POINTS

This is an array of point elements. Each element is an array of curve points
corresponding to the attachment points on that glyph. The order of the curve points
in the array corresponds to the attachment point number specified in the MARKS
coverage table (see below).

=back

=item LIG

This contains the ligature caret positioning information for ligature glyphs

=over 8

=item COVERAGE

A coverage table to say which glyphs are ligatures

=item LIGS

An array of elements for each ligature. Each element is an array of information
for each caret position in the ligature (there being number of components - 1 of
these, generally)

=over 12

=item FMT

This is the format of the information and is important to provide the semantics
for the value. This value must be set correctly before output

=item VAL

The value which has meaning according to FMT

=item DEVICE

For FMT = 3, a device table is also referenced which is stored here

=back

=back

=item MARKS

This class definition table defines the classes of mark glyphs that can be selected
for processing using the MarkAttachmentType field of lookup FLAG words. 

=item MARKSETS

Contains an array of coverage tables indexed by the FILTER value of a lookup.

=back


=head1 METHODS

=cut

use strict;
use Font::TTF::Table;
use Font::TTF::Utils;
use Font::TTF::Ttopen;
use vars qw(@ISA $new_gdef);

@ISA = qw(Font::TTF::Table);
$new_gdef = 1;  # Prior to 2012-07, this config variable did more than it does today.
                # Currently all it does is force the GDEF to include a field in the
                # header for the MARKS class definition. That is, it makes sure the
                # font is compatible with at least the OT 1.2 specification.

=head2 $t->read

Reads the table into the data structure

=cut

sub read
{
    my ($self) = @_;
    $self->SUPER::read or return $self;

    my ($fh) = $self->{' INFILE'};
    my ($boff) = $self->{' OFFSET'};
    my ($dat, $goff, $aoff, $loff, $macoff, $mgsoff, $r, $s, $bloc);

    $bloc = $fh->tell();
    $fh->read($dat, 10);
    ($self->{'Version'}, $goff, $aoff, $loff) = TTF_Unpack('LS3', $dat);
    
    # GDEF is the ONLY table that uses a ULONG for version rather than a Fixed or USHORT,
    # and this seems to clearly be a hack. 
    # OpenType 1.2 introduced MarkAttachClassDef but left the table version at 0x00010000
    # Up through OpenType 1.5, the Version field was typed as Fixed.
    # OpenType 1.6 introduced MarkGlyphSetsDef and bumped table version to 0x00010002 (sic)
    # and changed it to ULONG.
    
    
    # Thus some trickery here to read the table correctly!
    
    if ($self->{'Version'} > 0x00010000)
    {
        # Ok, header guaranteed to have both MarAttachClassDef MarkGlyphSetsDef
        $fh->read($dat, 4);
        ($macoff, $mgsoff) = TTF_Unpack('S2', $dat);
    }
    else
    {
        # What I've seen in other code (examples:
        #     http://skia.googlecode.com/svn/trunk/third_party/harfbuzz/src/harfbuzz-gdef.c and
        #     http://doxygen.reactos.org/d0/d55/otvalid_8h_a0487daffceceb98ba425bbf2806fbaff.html
        # ) is to read GPOS and GDEF and see if any lookups have a
        # MarkAttachType in the upper byte of their flag word and if so then assume that the
        # MarkAttachClassDef field is in the header. While this is probably the most 
        # reliable way to do it, it would require us to read GSUB and GPOS. 
        # Prior to 2012-07 what we did is depend on our $new_gdef class variable to tell us
        # whether to assume a MarkAttachClassDef. 
        # What we do now is see if the header actually has room for the MarkAttachClassDef field.
        
        my $minOffset = $self->{' LENGTH'};
        foreach ($goff, $aoff, $loff)
        {
            $minOffset = $_ if $_ > 0 && $_ < $minOffset;
        }
        if ($minOffset >= 12)
        {
            # There is room for the field, so read it:
            $fh->read($dat, 2);
            ($macoff) = TTF_Unpack('S', $dat);
            # Sanity check:
            $macoff = 0 if $macoff >= $self->{' LENGTH'};
        }
    }

    if ($goff > 0)
    {
        $fh->seek($goff + $boff, 0);
        $self->{'GLYPH'} = Font::TTF::Coverage->new(0)->read($fh);
    }

    if ($aoff > 0)
    {
        my ($off, $gcount, $pcount);
        
        $fh->seek($aoff + $boff, 0);
        $fh->read($dat, 4);
        ($off, $gcount) = TTF_Unpack('SS', $dat);
        $fh->read($dat, $gcount << 1);

        $fh->seek($aoff + $boff +  $off, 0);
        $self->{'ATTACH'}{'COVERAGE'} = Font::TTF::Coverage->new(1)->read($fh);

        foreach $r (TTF_Unpack('S*', $dat))
        {
            unless ($r)
            {
                push (@{$self->{'ATTACH'}{'POINTS'}}, []);
                next;
            }
            $fh->seek($aoff + $boff + $r, 0);
            $fh->read($dat, 2);
            $pcount = TTF_Unpack('S', $dat);
            $fh->read($dat, $pcount << 1);
            push (@{$self->{'ATTACH'}{'POINTS'}}, [TTF_Unpack('S*', $dat)]);
        }
    }

    if ($loff > 0)
    {
        my ($lcount, $off, $ccount, $srec, $comp);

        $fh->seek($loff + $boff, 0);
        $fh->read($dat, 4);
        ($off, $lcount) = TTF_Unpack('SS', $dat);
        $fh->read($dat, $lcount << 1);

        $fh->seek($off + $loff + $boff, 0);
        $self->{'LIG'}{'COVERAGE'} = Font::TTF::Coverage->new(1)->read($fh);

        foreach $r (TTF_Unpack('S*', $dat))
        {
            $fh->seek($r + $loff + $boff, 0);
            $fh->read($dat, 2);
            $ccount = TTF_Unpack('S', $dat);
            $fh->read($dat, $ccount << 1);

            $srec = [];
            foreach $s (TTF_Unpack('S*', $dat))
            {
                $comp = {};
                $fh->seek($s + $r + $loff + $boff, 0);
                $fh->read($dat, 4);
                ($comp->{'FMT'}, $comp->{'VAL'}) = TTF_Unpack('S*', $dat);
                if ($comp->{'FMT'} == 3)
                {
                    $fh->read($dat, 2);
                    $off = TTF_Unpack('S', $dat);
                    if (defined $self->{' CACHE'}{$off + $s + $r + $loff})
                    { $comp->{'DEVICE'} = $self->{' CACHE'}{$off + $s + $r + $loff}; }
                    else
                    {
                        $fh->seek($off + $s + $r + $loff + $boff, 0);
                        $comp->{'DEVICE'} = Font::TTF::Delta->new->read($fh);
                        $self->{' CACHE'}{$off + $s + $r + $loff} = $comp->{'DEVICE'};
                    }
                }
                push (@$srec, $comp);
            }
            push (@{$self->{'LIG'}{'LIGS'}}, $srec);
        }
    }

    if ($macoff > 0)
    {
        $fh->seek($macoff + $boff, 0);
        $self->{'MARKS'} = Font::TTF::Coverage->new(0)->read($fh);
    }
    
    if ($mgsoff > 0)
    {
        my ($fmt, $count, $off);
        $fh->seek($mgsoff + $boff, 0);
        $fh->read($dat, 4);
        ($fmt, $count) = TTF_Unpack('SS', $dat);
        # Sanity check opportunity: Could verify $fmt == 1, but I don't.
        $self->{'MARKSETS'} = [];
        $fh->read($dat, $count << 2);   # NB: These offets are ULONGs!
        foreach $off (TTF_Unpack('L*', $dat))
        {
            unless (defined $self->{' CACHE'}{$off + $mgsoff})
            {
                $fh->seek($off + $mgsoff + $boff, 0);
                $self->{' CACHE'}{$off + $mgsoff} = Font::TTF::Coverage->new(1)->read($fh);
            }
            push @{$self->{'MARKSETS'}}, $self->{' CACHE'}{$off + $mgsoff};
        }
    }

    $self;
}


=head2 $t->out($fh)

Writes out this table.

=cut

sub out
{
    my ($self, $fh) = @_;
    my ($goff, $aoff, $loff, $macoff, $mgsoff, @offs, $loc1, $coff, $loc);

    return $self->SUPER::out($fh) unless $self->{' read'};

    $loc = $fh->tell();
    if (defined $self->{'MARKSETS'} && @{$self->{'MARKSETS'}} > 0)
    {
        $self->{'Version'} = 0x00010002 if ($self->{'Version'} < 0x00010002);
        $fh->print(TTF_Pack('LSSSSS', $self->{'Version'}, 0, 0, 0, 0, 0));
    }
    else
    {
        $self->{'Version'} = 0x00010000;
        if ($new_gdef || defined $self->{'MARKS'})
        { $fh->print(TTF_Pack('LSSSS', $self->{'Version'}, 0, 0, 0, 0)); }
        else
        { $fh->print(TTF_Pack('LSSS', $self->{'Version'}, 0, 0, 0)); }
    }

    if (defined $self->{'GLYPH'})
    {
        $goff = $fh->tell() - $loc;
        $self->{'GLYPH'}->out($fh);
    }

    if (defined $self->{'ATTACH'})
    {
        my ($r);
        
        $aoff = $fh->tell() - $loc;
        $fh->print(pack('n*', (0) x ($#{$self->{'ATTACH'}{'POINTS'}} + 3)));
        foreach $r (@{$self->{'ATTACH'}{'POINTS'}})
        {
            push (@offs, $fh->tell() - $loc - $aoff);
            $fh->print(pack('n*', $#{$r} + 1, @$r));
        }
        $coff = $fh->tell() - $loc - $aoff;
        $self->{'ATTACH'}{'COVERAGE'}->out($fh);
        $loc1 = $fh->tell();
        $fh->seek($aoff + $loc, 0);
        $fh->print(pack('n*', $coff, $#offs + 1, @offs));
        $fh->seek($loc1, 0);
    }

    if (defined $self->{'LIG'})
    {
        my (@reftables, $ltables, $i, $j, $out, $r, $s);

        $ltables = {};
        $loff = $fh->tell() - $loc;
        $out = pack('n*',
                        Font::TTF::Ttopen::ref_cache($self->{'LIG'}{'COVERAGE'}, $ltables, 0),
                        $#{$self->{'LIG'}{'LIGS'}} + 1,
                        (0) x ($#{$self->{'LIG'}{'LIGS'}} + 1));
        push (@reftables, [$ltables, 0]);
        $i = 0;
        foreach $r (@{$self->{'LIG'}{'LIGS'}})
        {
            $ltables = {};
            $loc1 = length($out);
            substr($out, ($i << 1) + 4, 2) = TTF_Pack('S', $loc1);
            $out .= pack('n*', $#{$r} + 1, (0) x ($#{$r} + 1));
            @offs = (); $j = 0;
            foreach $s (@$r)
            {
                substr($out, ($j << 1) + 2 + $loc1, 2) =
                        TTF_Pack('S', length($out) - $loc1);
                $out .= TTF_Pack('SS', $s->{'FMT'}, $s->{'VAL'});
                $out .= pack('n', Font::TTF::Ttopen::ref_cache($s->{'DEVICE'},
                        $ltables, length($out))) if ($s->{'FMT'} == 3);
                $j++;
            }
            push (@reftables, [$ltables, $loc1]);
            $i++;
        }
        Font::TTF::Ttopen::out_final($fh, $out, \@reftables);
    }

    if (defined $self->{'MARKS'})
    {
        $macoff = $fh->tell() - $loc;
        $self->{'MARKS'}->out($fh);
    }
    
    if (defined $self->{'MARKSETS'})
    {

        my (@reftables, $ctables, $c, $out); 
        $ctables = {};      
        $mgsoff = $fh->tell() - $loc;
        $out = TTF_Pack('SS', 1, $#{$self->{'MARKSETS'}}+1);
        foreach $c (@{$self->{'MARKSETS'}})
        {
            $out .= pack('N', Font::TTF::Ttopen::ref_cache($c, $ctables, length($out), 'N'));
        }
        push (@reftables, [$ctables, 0]);
        Font::TTF::Ttopen::out_final($fh, $out, \@reftables);
    }

    $loc1 = $fh->tell();
    $fh->seek($loc + 4, 0);
    if ($mgsoff)
    { $fh->print(TTF_Pack('S5', $goff, $aoff, $loff, $macoff, $mgsoff)); }
    elsif ($macoff)
    { $fh->print(TTF_Pack('S4', $goff, $aoff, $loff, $macoff)); }
    else
    { $fh->print(TTF_Pack('S3', $goff, $aoff, $loff)); }
    $fh->seek($loc1, 0);
    $self;
}


=head2 $t->minsize()

Returns the minimum size this table can be. If it is smaller than this, then the table
must be bad and should be deleted or whatever.

=cut

sub minsize
{
    return 10;
}


=head2 $t->update

Sort COVERAGE tables.

=cut

sub update
{
    my ($self) = @_;
    
    return undef unless ($self->SUPER::update);
    
    unless ($Font::TTF::Coverage::dontsort)
    {
        if (defined $self->{'ATTACH'} and defined $self->{'ATTACH'}{'COVERAGE'} and !$self->{'ATTACH'}{'COVERAGE'}{'dontsort'} )
        {
            my @map = $self->{'ATTACH'}{'COVERAGE'}->sort();
            if (defined $self->{'ATTACH'}{'POINTS'})
            {
                # And also a POINTS array which now needs to be re-sorted
                my $newpoints = [];
                foreach (0 .. $#map)
                { push @{$newpoints}, $self->{'ATTACH'}{'POINTS'}[$map[$_]]; }
                $self->{'ATTACH'}{'POINTS'} = $newpoints;
            }
        }
        if (defined $self->{'LIG'} and defined $self->{'LIG'}{'COVERAGE'} and !$self->{'LIG'}{'COVERAGE'}{'dontsort'} )
        {
            my @map = $self->{'LIG'}{'COVERAGE'}->sort();
            if (defined $self->{'LIG'}{'LIGS'})
            {
                # And also a LIGS array which now needs to be re-sorted
                my $newligs = [];
                foreach (0 .. $#map)
                { push @{$newligs}, $self->{'LIG'}{'LIGS'}[$map[$_]]; }
                $self->{'LIG'}{'LIGS'} = $newligs;
            }
        }
        if (defined $self->{'MARKSETS'})
        {
            foreach (@{$self->{'MARKSETS'}})
            {$_->sort();}       # Don't care about map
        }
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
