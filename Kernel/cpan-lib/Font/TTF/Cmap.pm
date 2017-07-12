package Font::TTF::Cmap;

=head1 NAME

Font::TTF::Cmap - Character map table

=head1 DESCRIPTION

Looks after the character map. For ease of use, the actual cmap is held in
a hash against codepoint. Thus for a given table:

    $gid = $font->{'cmap'}{'Tables'}[0]{'val'}{$code};

Note that C<$code> should be a true value (0x1234) rather than a string representation.

=head1 INSTANCE VARIABLES

The instance variables listed here are not preceded by a space due to their
emulating structural information in the font.

=over 4

=item Num

Number of subtables in this table

=item Tables

An array of subtables ([0..Num-1])

Each subtable also has its own instance variables which are, again, not
preceded by a space.

=over 4

=item Platform

The platform number for this subtable

=item Encoding

The encoding number for this subtable

=item Format

Gives the stored format of this subtable

=item Ver

Gives the version (or language) information for this subtable

=item val

A hash keyed by the codepoint value (not a string) storing the glyph id

=back

=back

The following cmap options are controlled by instance variables that start with a space:

=over 4

=item allowholes

By default, when generating format 4 cmap subtables character codes that point to glyph zero
(normally called .notdef) are not included in the subtable. In some cases including some of these
character codes can result in a smaller format 4 subtable. To enable this behavior, set allowholes 
to non-zero. 

=back

=head1 METHODS

=cut

use strict;
use vars qw(@ISA);
use Font::TTF::Table;
use Font::TTF::Utils;

@ISA = qw(Font::TTF::Table);


=head2 $t->read

Reads the cmap into memory. Format 4 subtables read the whole subtable and
fill in the segmented array accordingly.

=cut

sub read
{
    my ($self, $keepzeros) = @_;
    $self->SUPER::read or return $self;

    my ($dat, $i, $j, $k, $id, @ids, $s);
    my ($start, $end, $range, $delta, $form, $len, $num, $ver, $sg);
    my ($fh) = $self->{' INFILE'};

    $fh->read($dat, 4);
    $self->{'Num'} = unpack("x2n", $dat);
    $self->{'Tables'} = [];
    for ($i = 0; $i < $self->{'Num'}; $i++)
    {
        $s = {};
        $fh->read($dat, 8);
        ($s->{'Platform'}, $s->{'Encoding'}, $s->{'LOC'}) = (unpack("nnN", $dat));
        $s->{'LOC'} += $self->{' OFFSET'};
        push(@{$self->{'Tables'}}, $s);
    }
    for ($i = 0; $i < $self->{'Num'}; $i++)
    {
        $s = $self->{'Tables'}[$i];
        $fh->seek($s->{'LOC'}, 0);
        $fh->read($dat, 2);
        $form = unpack("n", $dat);

        $s->{'Format'} = $form;
        if ($form == 0)
        {
            my $j = 0;

            $fh->read($dat, 4);
            ($len, $s->{'Ver'}) = unpack('n2', $dat);
            $fh->read($dat, 256);
            $s->{'val'} = {map {$j++; ($_ ? ($j - 1, $_) : ())} unpack("C*", $dat)};
        } elsif ($form == 6)
        {
            my ($start, $ecount);
            
            $fh->read($dat, 8);
            ($len, $s->{'Ver'}, $start, $ecount) = unpack('n4', $dat);
            $fh->read($dat, $ecount << 1);
            $s->{'val'} = {map {$start++; ($_ ? ($start - 1, $_) : ())} unpack("n*", $dat)};
        } elsif ($form == 2)        # Contributed by Huw Rogers
        {
            $fh->read($dat, 4);
            ($len, $s->{'Ver'}) = unpack('n2', $dat);
            $fh->read($dat, 512);
            my ($j, $k, $l, $m, $n, @subHeaderKeys, @subHeaders, $subHeader);
            $n = 1;
            for ($j = 0; $j < 256; $j++) {
                my $k = unpack('@'.($j<<1).'n', $dat)>>3;
                $n = $k + 1 if $k >= $n;
                $subHeaders[$subHeaderKeys[$j] = $k] ||= [ ];
            }
            $fh->read($dat, $n<<3); # read subHeaders[]
            for ($k = 0; $k < $n; $k++) {
                $subHeader = $subHeaders[$k];
                $l = $k<<3;
                @$subHeader = unpack('@'.$l.'n4', $dat);
                $subHeader->[2] = unpack('s', pack('S', $subHeader->[2]))
                    if $subHeader->[2] & 0x8000; # idDelta
                $subHeader->[3] =
                    ($subHeader->[3] - (($n - $k)<<3) + 6)>>1; # idRangeOffset
            }
            $fh->read($dat, $len - ($n<<3) - 518); # glyphIndexArray[]
            for ($j = 0; $j < 256; $j++) {
                $k = $subHeaderKeys[$j];
                $subHeader = $subHeaders[$k];
                unless ($k) {
                    $l = $j - $subHeader->[0];
                    if ($l >= 0 && $l < $subHeader->[1]) {
                        $m = unpack('@'.(($l + $subHeader->[3])<<1).'n', $dat);
                        $m += $subHeader->[2] if $m;
                        $s->{'val'}{$j} = $m;
                    }
                } else {
                    for ($l = 0; $l < $subHeader->[1]; $l++) {
                        $m = unpack('@'.(($l + $subHeader->[3])<<1).'n', $dat);
                        $m += $subHeader->[2] if $m;
                        $s->{'val'}{($j<<8) + $l + $subHeader->[0]} = $m;
                    }
                }
            }
        } elsif ($form == 4)
        {
            $fh->read($dat, 12);
            ($len, $s->{'Ver'}, $num) = unpack('n3', $dat);
            $num >>= 1;
            $fh->read($dat, $len - 14);
            for ($j = 0; $j < $num; $j++)
            {
                $end = unpack("n", substr($dat, $j << 1, 2));
                $start = unpack("n", substr($dat, ($j << 1) + ($num << 1) + 2, 2));
                $delta = unpack("n", substr($dat, ($j << 1) + ($num << 2) + 2, 2));
                $delta -= 65536 if $delta > 32767;
                $range = unpack("n", substr($dat, ($j << 1) + $num * 6 + 2, 2));
                for ($k = $start; $k <= $end; $k++)
                {
                    if ($range == 0 || $range == 65535)         # support the buggy FOG with its range=65535 for final segment
                    { $id = $k + $delta; }
                    else
                    { $id = unpack("n", substr($dat, ($j << 1) + $num * 6 +
                                        2 + ($k - $start) * 2 + $range, 2)) + $delta; }
                    $id -= 65536 if $id >= 65536;
                    $s->{'val'}{$k} = $id if ($id || $keepzeros);
                }
            }
        } elsif ($form == 8 || $form == 12 || $form == 13)
        {
            $fh->read($dat, 10);
            ($len, $s->{'Ver'}) = unpack('x2N2', $dat);
            if ($form == 8)
            {
                $fh->read($dat, 8196);
                $num = unpack("N", substr($dat, 8192, 4)); # don't need the map
            } else
            {
                $fh->read($dat, 4);
                $num = unpack("N", $dat);
            }
            $fh->read($dat, 12 * $num);
            for ($j = 0; $j < $num; $j++)
            {
                ($start, $end, $sg) = unpack("N3", substr($dat, $j * 12, 12));
                for ($k = $start; $k <= $end; $k++)
                { $s->{'val'}{$k} = $form == 13 ? $sg : $sg++; }
            }
        } elsif ($form == 10)
        {
            $fh->read($dat, 18);
            ($len, $s->{'Ver'}, $start, $num) = unpack('x2N4', $dat);
            $fh->read($dat, $num << 1);
            for ($j = 0; $j < $num; $j++)
            { $s->{'val'}{$start + $j} = unpack("n", substr($dat, $j << 1, 2)); }
        }
    }
    $self;
}


=head2 $t->ms_lookup($uni)

Finds a Unicode table, giving preference to the MS one, and looks up the given
Unicode codepoint in it to find the glyph id.

=cut

sub ms_lookup
{
    my ($self, $uni) = @_;

    $self->find_ms || return undef unless (defined $self->{' mstable'});
    return $self->{' mstable'}{'val'}{$uni};
}


=head2 $t->find_ms

Finds the a Unicode table, giving preference to the Microsoft one, and sets the C<mstable> instance variable
to it if found. Returns the table it finds.

=cut

sub find_ms
{
    my ($self) = @_;
    my ($i, $s, $alt, $found);

    return $self->{' mstable'} if defined $self->{' mstable'};
    $self->read;
    for ($i = 0; $i < $self->{'Num'}; $i++)
    {
        $s = $self->{'Tables'}[$i];
        if ($s->{'Platform'} == 3)
        {
            $self->{' mstable'} = $s;
            return $s if ($s->{'Encoding'} == 10);
            $found = 1 if ($s->{'Encoding'} == 1);
        } elsif ($s->{'Platform'} == 0 || ($s->{'Platform'} == 2 && $s->{'Encoding'} == 1))
        { $alt = $s; }
    }
    $self->{' mstable'} = $alt if ($alt && !$found);
    $self->{' mstable'};
}


=head2 $t->ms_enc

Returns the encoding of the microsoft table (0 => symbol, etc.). Returns undef if there is
no Microsoft cmap.

=cut

sub ms_enc
{
    my ($self) = @_;
    my ($s);
    
    return $self->{' mstable'}{'Encoding'} 
        if (defined $self->{' mstable'} && $self->{' mstable'}{'Platform'} == 3);
    
    foreach $s (@{$self->{'Tables'}})
    {
        return $s->{'Encoding'} if ($s->{'Platform'} == 3);
    }
    return undef;
}


=head2 $t->out($fh)

Writes out a cmap table to a filehandle. If it has not been read, then
just copies from input file to output

=cut

sub out
{
    my ($self, $fh) = @_;
    my ($loc, $s, $i, $base_loc, $j, @keys);

    return $self->SUPER::out($fh) unless $self->{' read'};


    $self->{'Tables'} = [sort {$a->{'Platform'} <=> $b->{'Platform'}
                                || $a->{'Encoding'} <=> $b->{'Encoding'}
                                || $a->{'Ver'} <=> $b->{'Ver'}} @{$self->{'Tables'}}];
    $self->{'Num'} = scalar @{$self->{'Tables'}};

    $base_loc = $fh->tell();
    $fh->print(pack("n2", 0, $self->{'Num'}));

    for ($i = 0; $i < $self->{'Num'}; $i++)
    { $fh->print(pack("nnN", $self->{'Tables'}[$i]{'Platform'}, $self->{'Tables'}[$i]{'Encoding'}, 0)); }

    for ($i = 0; $i < $self->{'Num'}; $i++)
    {
        $s = $self->{'Tables'}[$i];
        if ($s->{'Format'} < 8)
        { @keys = sort {$a <=> $b} grep { $_ <= 0xFFFF} keys %{$s->{'val'}}; }
        else
        { @keys = sort {$a <=> $b} keys %{$s->{'val'}}; }
        $s->{' outloc'} = $fh->tell();
        if ($s->{'Format'} < 8)
        { $fh->print(pack("n3", $s->{'Format'}, 0, $s->{'Ver'})); }       # come back for length
        else
        { $fh->print(pack("n2N2", $s->{'Format'}, 0, 0, $s->{'Ver'})); }
            
        if ($s->{'Format'} == 0)
        {
            $fh->print(pack("C256", map {defined $_ ? $_ : 0} @{$s->{'val'}}{0 .. 255}));
        } elsif ($s->{'Format'} == 6)
        {
            $fh->print(pack("n2", $keys[0], $keys[-1] - $keys[0] + 1));
            $fh->print(pack("n*", map {defined $_ ? $_ : 0} @{$s->{'val'}}{$keys[0] .. $keys[-1]}));
        } elsif ($s->{'Format'} == 2)       # Contributed by Huw Rogers
        {
            my ($g, $k, $h, $l, $m, $n);
            my (@subHeaderKeys, @subHeaders, $subHeader, @glyphIndexArray);
            $n = 0;
            @subHeaderKeys = (-1) x 256;
            for $j (@keys) {
                next unless defined($g = $s->{'val'}{$j});
                $h = int($j>>8);
                $l = ($j & 0xff);
                if (($k = $subHeaderKeys[$h]) < 0) {
                    $subHeader = [ $l, 1, 0, 0, [ $g ] ];
                    $subHeaders[$k = $n++] = $subHeader;
                    $subHeaderKeys[$h] = $k;
                } else {
                    $subHeader = $subHeaders[$k];
                    $m = ($l - $subHeader->[0] + 1) - $subHeader->[1];
                    $subHeader->[1] += $m;
                    push @{$subHeader->[4]}, (0) x ($m - 1), $g - $subHeader->[2];
                }
            }
            @subHeaderKeys = map { $_ < 0 ? 0 : $_ } @subHeaderKeys;
            $subHeader = $subHeaders[0];
            $subHeader->[3] = 0;
            push @glyphIndexArray, @{$subHeader->[4]};
            splice(@$subHeader, 4);
            {
                my @subHeaders_ = sort {@{$a->[4]} <=> @{$b->[4]}} @subHeaders[1..$#subHeaders];
                my ($f, $d, $r, $subHeader_);
                for ($k = 0; $k < @subHeaders_; $k++) {
                    $subHeader = $subHeaders_[$k];
                    $f = $r = shift @{$subHeader->[4]};
                    $subHeader->[5] = join(':',
                        map {
                            $d = $_ - $r;
                            $r = $_;
                            $d < 0 ?
                                sprintf('-%04x', -$d) :
                                sprintf('+%04x', $d)
                        } @{$subHeader->[4]});
                    unshift @{$subHeader->[4]}, $f;
                }
                for ($k = 0; $k < @subHeaders_; $k++) {
                    $subHeader = $subHeaders_[$k];
                    next unless $subHeader->[4];
                    $subHeader->[3] = @glyphIndexArray;
                    push @glyphIndexArray, @{$subHeader->[4]};
                    for ($l = $k + 1; $l < @subHeaders_; $l++) {
                        $subHeader_ = $subHeaders_[$l];
                        next unless $subHeader_->[4];
                        $d = $subHeader_->[5];
                        if ($subHeader->[5] =~ /\Q$d\E/) {
                            my $o = length($`)/6;               #`
                            $subHeader_->[2] +=
                                $subHeader_->[4]->[$o] - $subHeader->[4]->[0];
                            $subHeader_->[3] = $subHeader->[3] + $o;
                            splice(@$subHeader_, 4);
                        }
                    }
                    splice(@$subHeader, 4);
                }
            }
            $fh->print(pack('n*', map { $_<<3 } @subHeaderKeys));
            for ($j = 0; $j < 256; $j++) {
                $k = $subHeaderKeys[$j];
                $subHeader = $subHeaders[$k];
            }
            for ($k = 0; $k < $n; $k++) {
                $subHeader = $subHeaders[$k];
                $fh->print(pack('n4',
                    $subHeader->[0],
                    $subHeader->[1],
                    $subHeader->[2] < 0 ?
                        unpack('S', pack('s', $subHeader->[2])) :
                        $subHeader->[2],
                    ($subHeader->[3]<<1) + (($n - $k)<<3) - 6
                ));
            }
            $fh->print(pack('n*', @glyphIndexArray));
        } elsif ($s->{'Format'} == 4)
        {
            my (@starts, @ends, @deltas, @range);

            # There appears to be a bug in Windows that requires the final 0xFFFF (sentry)
            # to be in a segment by itself -- otherwise Windows 7 and 8 (at least) won't install
            # or preview the font, complaining that it doesn't appear to be a valid font.
            # Therefore we can't just add 0XFFFF to the USV list as we used to do:
            # push(@keys, 0xFFFF) unless ($keys[-1] == 0xFFFF);
            # Instead, for now *remove* 0xFFFF from the USV list, and add a segement
            # for it after all the other segments are computed.
            pop @keys if $keys[-1] == 0xFFFF;
            
            # Step 1: divide into maximal length idDelta runs
            
            my ($prevUSV, $prevgid);
            for ($j = 0; $j <= $#keys; $j++)
            {
                my $u = $keys[$j];
                my $g = $s->{'val'}{$u};
                if ($j == 0 || $u != $prevUSV+1 || $g != $prevgid+1)
                {
                    push @ends, $prevUSV unless $j == 0;
                    push @starts, $u;
                    push @range, 0;
                }
                $prevUSV = $u;
                $prevgid = $g;
            }
            push @ends, $prevUSV;
            
            # Step 2: find each macro-range
            
            my ($start, $end);  # Start and end of macro-range
            for ($start = 0; $start < $#starts; $start++)
            {
                next if $ends[$start] - $starts[$start]  >  7;      # if count > 8, we always treat this as a run unto itself
                for ($end = $start+1; $end <= $#starts; $end++)
                {
                    last if $starts[$end] - $ends[$end-1] > ($self->{' allowholes'} ? 5 : 1) 
                        || $ends[$end] - $starts[$end] > 7;   # gap > 4 or count > 8 so $end is beyond end of macro-range
                }
                $end--; #Ending index of this macro-range
                
                # Step 3: optimize this macro-range (from $start through $end)
                L1: for ($j = $start; $j < $end; )
                {
                    my $size1 = ($range[$j] ? 8 + 2 * ($ends[$j] - $starts[$j] + 1) : 8); # size of first range (which may now be idRange type)
                    for (my $k = $j+1; $k <= $end; $k++)
                    {
                        if (8 + 2 * ($ends[$k] - $starts[$j] + 1) <= $size1 + 8 * ($k - $j))
                        {
                            # Need to coalesce $j..$k into $j:
                            $ends[$j] = $ends[$k];
                            $range[$j] = 1;         # for now use boolean to indicate this is an idRange segment
                            splice @starts, $j+1, $k-$j;
                            splice @ends,   $j+1, $k-$j;
                            splice @range,  $j+1, $k-$j;
                            $end -= ($k-$j);
                            next L1;    # Note that $j isn't incremented so this is a redo
                        }
                    }
                    # Nothing coalesced
                    $j++;
                }
                
                # Finished with this macro-range
                $start = $end;
            }

            # Ok, add the final segment containing the sentry value
            push(@keys, 0xFFFF);
            push @starts, 0xFFFF;
            push @ends, 0xFFFF;
            push @range, 0;
            
            # What is left is a collection of segments that will represent the cmap in mimimum-sized format 4 subtable
            
            my ($num, $count, $sRange, $eSel, $eShift);

            $num = scalar(@starts);
            $count = 0;
            for ($j = 0; $j < $num; $j++)
            {
                if ($range[$j])
                {
                    $range[$j] = ($count + $num - $j) << 1;
                    $count += $ends[$j] - $starts[$j] + 1;
                    push @deltas, 0;
                }
                else
                {
                    push @deltas, ($s->{'val'}{$starts[$j]} || 0) - $starts[$j];
                }
            }

            ($num, $sRange, $eSel, $eShift) = Font::TTF::Utils::TTF_bininfo($num, 2);
            $fh->print(pack("n4", $num * 2, $sRange, $eSel, $eShift));
            $fh->print(pack("n*", @ends));
            $fh->print(pack("n", 0));
            $fh->print(pack("n*", @starts));
            $fh->print(pack("n*", @deltas));
            $fh->print(pack("n*", @range));

            for ($j = 0; $j < $num; $j++)
            {
                next if ($range[$j] == 0);
                $fh->print(pack("n*", map {$_ || 0} @{$s->{'val'}}{$starts[$j] .. $ends[$j]}));
            }
        } elsif ($s->{'Format'} == 8 || $s->{'Format'} == 12 || $s->{'Format'} == 13)
        {
            my (@jobs, $start, $current, $curr_glyf, $map);
            
            $current = 0; $curr_glyf = 0;
            $map = "\000" x 8192;
            foreach $j (@keys)
            {
                if ($j > 0xFFFF && $s->{'Format'} == 8)
                {
                    if (defined $s->{'val'}{$j >> 16})
                    { $s->{'Format'} = 12; }
                    vec($map, $j >> 16, 1) = 1;
                }
                if ($j != $current + 1 || $s->{'val'}{$j} != ($s->{'Format'} == 13 ? $curr_glyf : $curr_glyf + 1))
                {
                    push (@jobs, [$start, $current, $s->{'Format'} == 13 ? $curr_glyf : $curr_glyf - ($current - $start)]) if (defined $start);
                    $start = $j; $current = $j; $curr_glyf = $s->{'val'}{$j};
                }
                $current = $j;
                $curr_glyf = $s->{'val'}{$j};
            }
            push (@jobs, [$start, $current, $s->{'Format'} == 13 ? $curr_glyf : $curr_glyf - ($current - $start)]) if (defined $start);
            $fh->print($map) if ($s->{'Format'} == 8);
            $fh->print(pack('N', $#jobs + 1));
            foreach $j (@jobs)
            { $fh->print(pack('N3', @{$j})); }
        } elsif ($s->{'Format'} == 10)
        {
            $fh->print(pack('N2', $keys[0], $keys[-1] - $keys[0] + 1));
            $fh->print(pack('n*', $s->{'val'}{$keys[0] .. $keys[-1]}));
        }

        $loc = $fh->tell();
        if ($s->{'Format'} < 8)
        {
            $fh->seek($s->{' outloc'} + 2, 0);
            $fh->print(pack("n", $loc - $s->{' outloc'}));
        } else
        {
            $fh->seek($s->{' outloc'} + 4, 0);
            $fh->print(pack("N", $loc - $s->{' outloc'}));
        }
        $fh->seek($base_loc + 8 + ($i << 3), 0);
        $fh->print(pack("N", $s->{' outloc'} - $base_loc));
        $fh->seek($loc, 0);
    }
    $self;
}


=head2 $t->XML_element($context, $depth, $name, $val)

Outputs the elements of the cmap in XML. We only need to process val here

=cut

sub XML_element
{
    my ($self, $context, $depth, $k, $val) = @_;
    my ($fh) = $context->{'fh'};
    my ($i);

    return $self if ($k eq 'LOC');
    return $self->SUPER::XML_element($context, $depth, $k, $val) unless ($k eq 'val');

    $fh->print("$depth<mappings>\n");
    foreach $i (sort {$a <=> $b} keys %{$val})
    { $fh->printf("%s<map code='%04X' glyph='%s'/>\n", $depth . $context->{'indent'}, $i, $val->{$i}); }
    $fh->print("$depth</mappings>\n");
    $self;
}


=head2 $t->minsize()

Returns the minimum size this table can be in bytes. If it is smaller than this, then the table
must be bad and should be deleted or whatever.

=cut

sub minsize
{
    return 4;
}


=head2 $t->update

Tidies the cmap table.

Removes MS Fmt12 cmap if it is no longer needed.

Removes from all cmaps any codepoint that map to GID=0. Note that such entries will
be re-introduced as necessary depending on the cmap format.

=cut

sub update
{
    my ($self) = @_;
    my ($max, $code, $gid, @keep);
    
    return undef unless ($self->SUPER::update);

    foreach my $s (@{$self->{'Tables'}})
    {
        $max = 0;
        while (($code, $gid) = each %{$s->{'val'}})
        {
            if ($gid)
            {
                # remember max USV
                $max = $code if $max < $code;
            }
            else
            {
                # Remove unneeded key
                delete $s->{'val'}{$code};  # nb: this is a safe delete according to perldoc perlfunc.
            }
        }
        push @keep, $s unless $s->{'Platform'} == 3 && $s->{'Encoding'} == 10 && $s->{'Format'} == 12 && $max <= 0xFFFF;
    }
    
    $self->{'Tables'} = [ @keep ];  
    
    delete $self->{' mstable'};     # Force rediscovery of this.
    
    $self;
}

=head2 @map = $t->reverse(%opt)

Returns a reverse map of the Unicode cmap. I.e. given a glyph gives the Unicode value for it. Options are:

=over 4

=item tnum

Table number to use rather than the default Unicode table

=item array

Returns each element of reverse as an array since a glyph may be mapped by more
than one Unicode value. The arrays are unsorted. Otherwise store any one unicode value for a glyph.

=back

=cut

sub reverse
{
    my ($self, %opt) = @_;
    my ($table) = defined $opt{'tnum'} ? $self->{'Tables'}[$opt{'tnum'}] : $self->find_ms;
    my (@res, $code, $gid);

    while (($code, $gid) = each(%{$table->{'val'}}))
    {
        if ($opt{'array'})
        { push (@{$res[$gid]}, $code); }
        else
        { $res[$gid] = $code unless (defined $res[$gid] && $res[$gid] > 0 && $res[$gid] < $code); }
    }
    @res;
}


=head2 is_unicode($index)

Returns whether the table of a given index is known to be a unicode table
(as specified in the specifications)

=cut

sub is_unicode
{
    my ($self, $index) = @_;
    my ($pid, $eid) = ($self->{'Tables'}[$index]{'Platform'}, $self->{'Tables'}[$index]{'Encoding'});

    return ($pid == 3 || $pid == 0 || ($pid == 2 && $eid == 1));
}

1;

=head1 BUGS

=over 4

=item *

Format 14 (Unicode Variation Sequences) cmaps are not supported.

=back

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>. 


=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.



=cut

