package Font::TTF::Silf;

=head1 NAME

Font::TTF::Silf - The main Graphite table

=head1 DESCRIPTION

The Silf table holds the core of the Graphite rules for a font. A Silf table has
potentially multiple silf subtables, although there is usually only one. Within a silf subtable,
there are a number of passes which contain the actual finite state machines to match rules
and the constraint and action code to be executed when a rule matches.

=head1 INSTANCE VARIABLES

=over 4

=item Version

Silf table format version

=item Compiler

Lowest compiler version necessary to fully support the semantics expressed in this
Graphite description

=item SILF

An array of Silf subtables

=over 4

=item maxGlyphID

The maximum glyph id referenced including pseudo and non glyphs

=item Ascent

Extra ascent to be added to the font ascent.

=item Descent

Extra descent to be added to the font descent. Both values are assumed to be
positive for a descender below the base line.

=item substPass

Pass index into PASS of the first substitution pass.

=item posPass

Pass index into PASS of the first positioning pass.

=item justPass

Pass index into PASS of the first justification pass.

=item bidiPass

Pass index of the pass before which the bidirectional processing pass will be executed.
0xFF indicates that there is no bidi pass to be executed.

=item Flags

A bitfield of flags:

    0 - Indicates there are line end contextual rules in one of the passes

=item maxPreContext

Maximum length of a context preceding a cross line boundary contextualisation.

=item maxPostContext

Maximum length of a context following a cross line boundary contextualsation.

=item attrPseudo

Glyph attribute for the actual glyph id associated with a pseudo glyph.

=item attrBreakWeight

Glyph attribute number of the attribute holding the default breakweight associated with a glyph.

=item attrDirectionality

Glyph attribute number of the attribute holding the default directionality value associated with a glyph.

=item JUST

The may be a number of justification levels each with their own property values.
This points to an array of hashes, one for each justification level.

=over 4

=item attrStretch

Glyph attribute number for the amount of stretch allowed before this glyph.

=item attrShrink

Glyph attribute number for the amount of shrink allowed before this glyph.

=item attrStep

Glyph attribute number specifying the minimum granularity of actual spacing associated with this glyph at this level.

=item attrWeight

Glyph attribute number giving the weight associated with spreading space across a run of glyphs.

=item runto

Which level starts the next stage.

=back

=item numLigComp

Number of initial glyph attributes that represent ligature components

=item numUserAttr

Number of user defined slot attributes referenced. Tells the engine how much space to
allocate to a slot for user attributes.

=item maxCompPerLig

Maximum number of components per ligature.

=item direction

Supported directions for this writing system

=item CRIT_FEATURE

Array of critical features.

=item scripts

Array of script tags that indicate which set of GDL rules to execute if there is more than one in a font.

=item lbGID

Glyph ID of the linebreak pseudo glyph.

=item pseudos

Hash of Unicode values to pseduo glyph ids.

=item classes

This is an array of classes, each of which is an array of glyph ids in class order.

=item PASS

The details of rules and actions are stored in passes. This value is an array of pass subobjects one for each pass.

=over 4

=item flags

This is a bitfield:

    0 - If true, this pass makes no change to the slot stream considered as a sequence of glyph ids.
        Only slot attributes are expected to change (for example during positioning).

=item maxRuleLoop

How many times the engine will allow rules to be tested and run without the engine advancing through the
input slot stream.

=item maxRuleContext

Number of slots of input needed to run this pass.

=item maxBackup

Number of slots by which the following pass needs to trail this pass (i.e. the maximum this pass is allowed to back up).

=item numRules

Number of action code blocks, and so uncompressed rules, in this pass.

=item numRows

Number of rows in the finite state machine.

=item numTransitional

Number of rows in the finite state machine that are not final states. This specifies the number of rows in the fsm
element.

=item numSuccess

Number of success states. A success state may also be a transitional state.

=item numColumns

Number of columns in the finite state machine.

=item colmap

A hash, indexed by glyphid, that gives the fsm column number associated with that glyphid. If not present, then
the glyphid is not part of the fsm and will finish fsm processing if it occurs.

=item rulemap

An array of arrays, one for each success state. Each array holds a list of rule numbers associated with that state.

=item minRulePreContext

Minimum number of items in a rule's precontext.

=item maxRulePreContext

The maximum number of items in any rule's precontext.

=item startStates

Array of starting state numbers dependeing on the length of actual precontext.
There are maxRulePreContext - minRulePreContext + 1 of these.

=item ruleSortKeys

An array of sort keys one for each rule giving the length of the rule including its precontext.

=item rulePreContexts

An array of precontext lengths for each rule.

=item fsm

A two dimensional array such that $p->{'fsm'}[$row][$col] gives the row of the next node to try in the fsm.

=item passConstraintLen

Length in bytes of the passConstraint code.

=item passConstraintCode

A byte string holding the pass constraint code.

=item constraintCode

An array of byte strings holding the constraint code for each rule.

=item actionCode

An array of byte strings holding the action code for each rule.

=back

=back

=back

=cut

use Font::TTF::Table;
use Font::TTF::Utils;
use strict;
use vars qw(@ISA);

@ISA = qw(Font::TTF::Table);

=head2 @opcodes

Each array holds the name of the opcode, the number of operand bytes and a string describing the operands.
The characters in the string have the following meaning:

    c - lsb of class id
    C - msb of class id
    f - feature index
    g - lsb of glyph attribute id
    G - msb of glyph attribute id
    l - lsb of a 32-bit extension to a 16-bit number
    L - msb of a 32-bit number
    m - glyph metric id
    n - lsb of a number
    N - msb of a 16-bit number
    o - offset (jump)
    s - slot reference
    S - slot attribute id
    v - variable number of following arguments

=cut

our @opcodes = ( ["nop", 0, ""], ["push_byte", 1, "n"], ["push_byte_u", 1, "n"], ["push_short", 2, "Nn"],
             ["push_short_u", 2, "Nn"], ["push_long", 4, "LlNn"], ["add", 0, ""], ["sub", 0, ""],
             ["mul", 0, ""], ["div", 0, ""], ["min", 0, ""], ["max", 0, ""],
             ["neg", 0, ""], ["trunc8", 0, ""], ["trunc16", 0, ""], ["cond", 0, ""],
             ["and", 0, ""], ["or", 0, ""], ["not", 0, ""], ["equal", 0, ""],                                               # 16
             ["not_eq", 0, ""], ["less", 0, ""], ["gtr", 0, ""], ["less_eq", 0, ""],
             ["gtr_eq", 0, ""], ["next", 0, ""], ["next_n", 1, "n"], ["copy_next", 0, ""],
             ["put_glyph_8bit_obs", 1, "c"], ["put_subs_8bit_obs", 3, "scc"], ["put_copy", 1, "s"], ["insert", 0, ""],
             ["delete", 0, ""], ["assoc", -1, "v"], ["cntxt_item", 2, "so"], ["attr_set", 1, "S"],                          # 32
             ["attr_add", 1, "S"], ["attr_sub", 1, "S"], ["attr_set_slot", 1, "S"], ["iattr_set_slot", 2, "Sn"],
             ["push_slot_attr", 2, "Ss"], ["push_glyph_attr_obs", 2, "gs"], ["push_glyph_metric", 3, "msn"], ["push_feat", 2, "fs"],
             ["push_att_to_gattr_obs", 2, "gs"], ["push_att_to_glyph_metric", 3, "msn"], ["push_islot_attr", 3, "Ssn"], ["push_iglyph_attr", 3, "gsn"],
             ["pop_ret", 0, ""], ["ret_zero", 0, ""], ["ret_true", 0, ""], ["iattr_set", 2, "Sn"],                          # 48
             ["iattr_add", 2, "Sn"], ["iattr_sub", 2, "Sn"], ["push_proc_state", 1, "n"], ["push_version", 0, ""],
             ["put_subs", 5, "sCcCc"], ["put_subs2", 4, "cscc"], ["put_subs3", 7, "scscscc"], ["put_glyph", 2, "Cc"],
             ["push_glyph_attr", 3, "Ggs"], ["push_att_to_glyph_attr", 3, "Ggs"], ["bitand", 0, ""], ["bitor", 0, ""],
             ["bitnot", 0, ""], ["setbits", 4, "NnNn"], ["setfeat", 2, "fs"] );                                             # 64

my ($i) = 0;
our %opnames = map {$_->[0] => $i++} @opcodes;

=head2 read

Reads the Silf table into the internal data structure

=cut

sub read
{
    my ($self) = @_;
    $self->SUPER::read or return $self;

    my ($dat, $d);
    my ($fh) = $self->{' INFILE'};
    my ($moff) = $self->{' OFFSET'};
    my ($numsilf, @silfo);
    
    $fh->read($dat, 4);
    ($self->{'Version'}) = TTF_Unpack("v", $dat);
    if ($self->{'Version'} >= 3)
    {
        $fh->read($dat, 4);
        ($self->{'Compiler'}) = TTF_Unpack("v", $dat);
    }
    $fh->read($dat, 4);
    ($numsilf) = TTF_Unpack("S", $dat);
    $fh->read($dat, $numsilf * 4);
    foreach my $i (0 .. $numsilf - 1)
    { push (@silfo, TTF_Unpack("L", substr($dat, $i * 4, 4))); }

    foreach my $sili (0 .. $numsilf - 1)
    {
        my ($silf) = {};
        my (@passo, @classo, $classbase, $numJust, $numCritFeatures, $numScript, $numPasses, $numPseudo, $i);

        push (@{$self->{'SILF'}}, $silf);
        $fh->seek($moff + $silfo[$sili], 0);
        if ($self->{'Version'} >= 3)
        {
            $fh->read($dat, 8);
            ($silf->{'Version'}) = TTF_Unpack("v", $dat);
        }
        $fh->read($dat, 20);
        ($silf->{'maxGlyphID'}, $silf->{'Ascent'}, $silf->{'Descent'},
         $numPasses, $silf->{'substPass'}, $silf->{'posPass'}, $silf->{'justPass'}, $silf->{'bidiPass'},
         $silf->{'Flags'}, $silf->{'maxPreContext'}, $silf->{'maxPostContext'}, $silf->{'attrPseudo'},
         $silf->{'attrBreakWeight'}, $silf->{'attrDirectionality'}, $silf->{'attrMirror'}, $silf->{'passBits'}, $numJust) = 
            TTF_Unpack("SssCCCCCCCCCCCCCC", $dat);
        if ($numJust)
        {
            foreach my $j (0 .. $silf->{'numJust'} - 1)
            {
                my ($just) = {};
                push (@{$silf->{'JUST'}}, $just);
                $fh->read($dat, 8);
                ($just->{'attrStretch'}, $just->{'attrShrink'}, $just->{'attrStep'}, $just->{'attrWeight'},
                 $just->{'runto'}) = TTF_Unpack("CCCCC", $dat);
            }
        }
        $fh->read($dat, 10);
        ($silf->{'numLigComp'}, $silf->{'numUserAttr'}, $silf->{'maxCompPerLig'}, $silf->{'direction'},
         $silf->{'attCollisions'}, $d, $d, $d, $numCritFeatures) = TTF_Unpack("SCCCCCCCC", $dat);
        if ($numCritFeatures)
        {
            $fh->read($dat, $numCritFeatures * 2);
            $silf->{'CRIT_FEATURE'} = [TTF_Unpack("S$numCritFeatures", $dat)];
        }
        $fh->read($dat, 2);
        ($d, $numScript) = TTF_Unpack("CC", $dat);
        if ($numScript)
        {
            $fh->read($dat, $numScript * 4);
            foreach (0 .. $numScript - 1)
            { push (@{$silf->{'scripts'}}, unpack('a4', substr($dat, $_ * 4, 4))); }
        }
        $fh->read($dat, 2);
        ($silf->{'lbGID'}) = TTF_Unpack("S", $dat);
        $fh->read($dat, $numPasses * 4 + 4);
        @passo = unpack("N*", $dat);
        $fh->read($dat, 8);
        ($numPseudo) = TTF_Unpack("S", $dat);
        if ($numPseudo)
        {
            $fh->read($dat, $numPseudo * 6);
            foreach (0 .. $numPseudo - 1)
            {
                my ($uni, $gid) = TTF_Unpack("LS", substr($dat, $_ * 6, 6));
                $silf->{'pseudos'}{$uni} = $gid;
            }
        }
        $classbase = $fh->tell();
        $fh->read($dat, 4);
        my ($numClasses, $numLinearClasses) = TTF_Unpack("SS", $dat);
        $silf->{'numLinearClasses'} = $numLinearClasses;
        $fh->read($dat, ($numClasses + 1) * ($self->{'Version'} >= 4 ? 4 : 2));
        @classo = unpack($self->{'Version'} >= 4 ? "N*" : "n*", $dat);
        $fh->read($dat, $classo[-1] - $classo[0]);
        for ($i = 0; $i < $numLinearClasses; $i++)
        {
            push (@{$silf->{'classes'}}, [unpack("n*", substr($dat, $classo[$i] - $classo[0], 
                                                            $classo[$i+1] - $classo[$i]))]) 
        }
        for ($i = $numLinearClasses; $i < $numClasses; $i++)
        {
            my (@res);
            my (@c) = unpack("n*", substr($dat, $classo[$i] - $classo[0] + 8, $classo[$i+1] - $classo[$i] - 8));
            for (my $j = 0; $j < @c; $j += 2)
            { $res[$c[$j+1]] = $c[$j]; }
            push (@{$silf->{'classes'}}, \@res);
        }
        foreach (0 .. $numPasses - 1)
        { $self->read_pass($fh, $passo[$_], $moff + $silfo[$sili], $silf, $_); }
    }
    return $self;
}

sub chopcode
{
    my ($dest, $dat, $offsets, $isconstraint) = @_;
    my ($last) = $offsets->[-1];
    my ($i);

    for ($i = $#{$offsets} - 1; $i >= 0; $i--)
    {
        if ((!$isconstraint || $offsets->[$i]) && $offsets->[$i] != $last)
        {
            unshift(@{$dest}, substr($dat, $offsets->[$i], $last - $offsets->[$i]));
            $last = $offsets->[$i];
        }
        else
        { unshift(@{$dest}, ""); }
    }
}


sub read_pass
{
    my ($self, $fh, $offset, $base, $silf, $id) = @_;
    my ($pass) = {'id' => $id};
    my ($d, $dat, $i, @orulemap, @oconstraints, @oactions, $numRanges);

    $fh->seek($offset + $base, 0);
    # printf "pass base = %04X\n", $offset;
    push (@{$silf->{'PASS'}}, $pass);
    $fh->read($dat, 40);
    ($pass->{'flags'}, $pass->{'maxRuleLoop'}, $pass->{'maxRuleContext'}, $pass->{'maxBackup'},
     $pass->{'numRules'}, $d, $d, $d, $d, $d, $pass->{'numRows'}, $pass->{'numTransitional'},
     $pass->{'numSuccess'}, $pass->{'numColumns'}, $numRanges) =
        TTF_Unpack("CCCCSSLLLLSSSSS", $dat);
    $fh->read($dat, $numRanges * 6);
    foreach $i (0 .. $numRanges - 1)
    {
        my ($first, $last, $col) = TTF_Unpack('SSS', substr($dat, $i * 6, 6));
        foreach ($first .. $last)
        { $pass->{'colmap'}{$_} = $col; }
    }
    $fh->read($dat, $pass->{'numSuccess'} * 2 + 2);
    @orulemap = unpack("n*", $dat);
    $fh->read($dat, $orulemap[-1] * 2);
    foreach (0 .. $pass->{'numSuccess'} - 1)
    { push (@{$pass->{'rulemap'}}, [unpack("n*", substr($dat, $orulemap[$_] * 2, ($orulemap[$_+1] - $orulemap[$_]) * 2))]); }
    $fh->read($dat, 2);
    ($pass->{'minRulePreContext'}, $pass->{'maxRulePreContext'}) = TTF_Unpack("CC", $dat);
    $fh->read($dat, ($pass->{'maxRulePreContext'} - $pass->{'minRulePreContext'} + 1) * 2);
    $pass->{'startStates'} = [unpack('n*', $dat)];
    $fh->read($dat, $pass->{'numRules'} * 2);
    $pass->{'ruleSortKeys'} = [unpack('n*', $dat)];
    $fh->read($dat, $pass->{'numRules'});
    $pass->{'rulePreContexts'} = [unpack('C*', $dat)];
    $fh->read($dat, 3);
    ($pass->{'collisionThreshold'}, $pass->{'passConstraintLen'}) = TTF_Unpack("CS", $dat);
    $fh->read($dat, ($pass->{'numRules'} + 1) * 2);
    @oconstraints = unpack('n*', $dat);
    $fh->read($dat, ($pass->{'numRules'} + 1) * 2);
    @oactions = unpack('n*', $dat);
    foreach (0 .. $pass->{'numTransitional'} - 1)
    {
        $fh->read($dat, $pass->{'numColumns'} * 2);
        push (@{$pass->{'fsm'}}, [unpack('n*', $dat)]);
    }
    $fh->read($dat, 1);
    if ($pass->{'passConstraintLen'})
    { $fh->read($pass->{'passConstraintCode'}, $pass->{'passConstraintLen'}); }
    $fh->read($dat, $oconstraints[-1]);
    $pass->{'constraintCode'} = [];
    chopcode($pass->{'constraintCode'}, $dat, \@oconstraints, 1);
    $fh->read($dat, $oactions[-1]);
    $pass->{'actionCode'} = [];
    chopcode($pass->{'actionCode'}, $dat, \@oactions, 0);
    return $pass;
}

sub chopranges
{
    my ($map, $numg) = @_;
    my ($dat, $numRanges);
    my (@keys) = sort {$a <=> $b} keys %{$map};
    my ($first, $last, $col, $g);

    $first = -1;
    $last = -1;
    $col = -1;
    foreach $g (@keys)
    {
        next unless ($g > 0 or $g eq '0');
        if ($g != $last + 1 || $map->{$g} != $col)
        {
            if ($col != -1)
            {
                $dat .= pack("nnn", $first, $last, $col);
                $numRanges++;
            }
            $first = $last = $g;
            $col = $map->{$g};
        }
        else
        { $last++; }
    }
    if ($col != -1)
    {
        $dat .= pack("nnn", $first, $last, $col);
        $numRanges++;
    }
    return ($numRanges, $dat);
}

sub unpack_code
{
    my ($self, $str) = @_;
    my (@res, $i, $j);
    my ($l) = length($str);

    for ($i = 0; $i < $l; )
    {
        my ($a) = unpack('C', substr($str, $i, 1));
        my ($o) = $opcodes[$a];
        my (@args);
        my (@types) = split('', $o->[2]);
        ++$i;
        for ($j = 0; $j < @types; ++$j)
        {
            my ($t) = $types[$j];
            if ($t eq 'v')
            {
                my ($n) = unpack('C', substr($str, $i, 1));
                push (@args, unpack('C*', substr($str, $i + 1, $n)));
                $i += $n + 1;
            }
            elsif ($t eq 'L' or $t eq 'N' or $t eq 'G' or $t eq 'C')
            {
                push (@args, unpack('n', substr($str, $i, 2)));
                $i += 2;
                $j++;
            }
            else
            {
                push (@args, unpack($t eq 's' ? 'c' : 'C', substr($str, $i, 1)));
                $i++;
            }
        }
        push (@res, [$o->[0], @args]);
    }
    return @res;
}

sub pack_code
{
    my ($self, $cmds) = @_;
    my ($res);

    foreach my $c (@{$cmds})
    {
        my ($ind) = $opnames{$c->[0]};
        my ($i) = 1;
        $res .= pack('C', $ind);
        # my (@types) = unpack('C*', $opcodes[$ind][2]);
        my (@types) = split('', $opcodes[$ind][2]);
        for (my $j = 0; $j < @types; $j++)
        {
            my ($t) = $types[$j];
            if ($t eq 'v')
            {
                my ($n) = scalar @{$c} - 1;
                $res .= pack('C*', $n, @{$c}[1..$#{$c}]);
                $i += $n;
            }
            elsif ($t eq 'C' or $t eq 'G' or $t eq 'L' or $t eq 'N')
            {
                $res .= pack('n', $c->[$i]);
                $j++;
            }
            else
            { $res .= pack($t eq 's' ? 'c' : 'C', $c->[$i]); }
            $i++;
        }
    }
    return $res;
}

sub packcode
{
    my ($code, $isconstraint) = @_;
    my ($dat, $c, $res);

    $c = 1;
    $dat = "\000";
    foreach (@{$code})
    {
        if ($_)
        {
            push(@{$res}, $c);
            $dat .= $_;
            $c += length($_);
        }
        else
        { push(@{$res}, $isconstraint ? 0 : $c); }
    }
    push(@{$res}, $c);
    return ($res, $dat);
}

sub out_pass
{
    my ($self, $fh, $pass, $silf, $subbase) = @_;
    my (@orulemap, $dat, $actiondat, $numRanges, $c);
    my (@offsets, $res, $pbase);

    $pbase = $fh->tell();
    # printf "pass base = %04X, ", $pbase - $subbase;
    $fh->print(TTF_Pack("CCCCSSLLLLSSSS", $pass->{'flags'}, $pass->{'maxRuleLoop'}, $pass->{'maxRuleContext'},
                $pass->{'maxBackup'}, $pass->{'numRules'}, 24, 0, 0, 0, 0, $pass->{'numRows'},
                $pass->{'numTransitional'}, $pass->{'numSuccess'}, $pass->{'numColumns'}));
    ($numRanges, $dat) = chopranges($pass->{'colmap'});
#    print "numranges = $numRanges\n";
    $fh->print(TTF_Pack("SSSS", TTF_bininfo($numRanges, 6)));
    $fh->print($dat);
    $dat = "";
    $c = 0;
#    print "transitions = $pass->{'numTransitional'}, success = $pass->{'numSuccess'}, rows = $pass->{'numRows'}\n";
    my ($sucbase) = $pass->{'numRows'} - $pass->{'numSuccess'};
    foreach (0 .. ($pass->{'numSuccess'} - 1))
    {
        push(@orulemap, $c);
        if (defined $pass->{'rulemap'}[$_])
        {
            $dat .= pack("n*", @{$pass->{'rulemap'}[$_]});
            $c += @{$pass->{'rulemap'}[$_]};
        }
        else
        {
            print "No rules for " . ($sucbase + $_);
            if ($sucbase + $_ < $pass->{'numTransitional'})
            { print ": (" . join(",", @{$pass->{'fsm'}[$sucbase + $_]}) . ")"; }
            print "\n";
        }
    }
    push (@orulemap, $c);
    $fh->print(pack("n*", @orulemap));
    $fh->print($dat);
    $fh->print(TTF_Pack("CC", $pass->{'minRulePreContext'}, $pass->{'maxRulePreContext'}));
    $fh->print(pack("n*", @{$pass->{'startStates'}}));
    $fh->print(pack("n*", @{$pass->{'ruleSortKeys'}}));
    $fh->print(pack("C*", @{$pass->{'rulePreContexts'}}));
    $fh->print(TTF_Pack("CS", 0, $pass->{'passConstraintLen'}));
    my ($oconstraints, $oactions);
    ($oconstraints, $dat) = packcode($pass->{'constraintCode'}, 1);
    ($oactions, $actiondat) = packcode($pass->{'actionCode'}, 0);
#    printf "constraint offsets @ %X\n", $fh->tell();
    $fh->print(pack("n*", @{$oconstraints}));
#    printf "action offsets @ %X\n", $fh->tell();
    $fh->print(pack("n*", @{$oactions}));
#    printf "fsm @ %X\n", $fh->tell();
    foreach (@{$pass->{'fsm'}})
    { $fh->print(pack("n*", @{$_})); }
#    printf "end of fsm @ %X\n", $fh->tell();
    $fh->print(pack("C", $pass->{'collisionThreshold'}));
    push(@offsets, $fh->tell() - $subbase);
    $fh->print($pass->{'passConstraintCode'});
    push(@offsets, $fh->tell() - $subbase);
    $fh->print($dat);
    push(@offsets, $fh->tell() - $subbase);
    $fh->print($actiondat);
    push(@offsets, 0);
    print join(", ", @offsets) . "\n";
    $res = $fh->tell();
    $fh->seek($pbase + 8, 0);
    $fh->print(pack("N*", @offsets));
    $fh->seek($res, 0);
#    printf "end = %04X\n", $res - $subbase;
    return $res;
}

=head2 out

Outputs a Silf data structure to a font file in binary format

=cut

sub out
{
    my ($self, $fh) = @_;
    my ($silf, $base, $subbase, $silfc, $end);

    return $self->SUPER::out($fh) unless ($self->{' read'});
    $base = $fh->tell();
    if ($self->{'Version'} >= 3)
    { $fh->print(TTF_Pack("vvSS", $self->{'Version'}, $self->{'Compiler'}, $#{$self->{'SILF'}} + 1, 0)); }
    else
    { $fh->print(TTF_Pack("vSS", $self->{'Version'}, $#{$self->{'SILF'}} + 1, 0)); }
    $fh->print(pack('N*', (0) x (@{$self->{'SILF'}})));
    foreach $silf (@{$self->{'SILF'}})
    {
        my ($subbase) = $fh->tell();
        my ($numlin, $i, @opasses, $oPasses, $oPseudo, $ooPasses);
        if ($self->{'Version'} >= 3)
        {
            $fh->seek($base + 12 + $silfc * 4, 0);
            $fh->print(pack('N', $subbase - $base));
            $fh->seek($subbase, 0);
            $fh->print(TTF_Pack("vSS", $silf->{'Version'}, $ooPasses, $oPseudo));
        }
        else
        {
            $fh->seek($base + 8 + $silfc * 4, 0);
            $fh->print(pack('N', $subbase - $base));
            $fh->seek($subbase, 0);
        }
        $fh->print(TTF_Pack("SssCCCCCCCCCCCCCC", 
             $silf->{'maxGlyphID'}, $silf->{'Ascent'}, $silf->{'Descent'},
             scalar @{$silf->{'PASS'}}, $silf->{'substPass'}, $silf->{'posPass'}, $silf->{'justPass'}, $silf->{'bidiPass'},
             $silf->{'Flags'}, $silf->{'maxPreContext'}, $silf->{'maxPostContext'}, $silf->{'attrPseudo'},
             $silf->{'attrBreakWeight'}, $silf->{'attrDirectionality'}, $silf->{'attrMirror'}, $silf->{'passBits'}, $#{$silf->{'JUST'}} + 1));
        foreach (@{$silf->{'JUST'}})
        { $fh->print(TTF_Pack("CCCCCCCC", $_->{'attrStretch'}, $_->{'attrShrink'}, $_->{'attrStep'},
                        $_->{'attrWeight'}, $_->{'runto'}, 0, 0, 0)); }
        
        $fh->print(TTF_Pack("SCCCCCCCC", $silf->{'numLigComp'}, $silf->{'numUserAttr'}, $silf->{'maxCompPerLig'},
                        $silf->{'direction'}, $silf->{'attCollisions'}, 0, 0, 0, $#{$silf->{'CRIT_FEATURE'}} + 1));
        $fh->print(pack("n*", @{$silf->{'CRIT_FEATURE'}}));
        $fh->print(TTF_Pack("CC", 0, $#{$silf->{'scripts'}} + 1));
        foreach (@{$self->{'scripts'}})
        { $fh->print(pack("a4", $_)); }
        $fh->print(TTF_Pack("S", $silf->{'lbGID'}));
        $ooPasses = $fh->tell();
        if ($silf->{'PASS'}) { $fh->print(pack("N*", (0) x (@{$silf->{'PASS'}} + 1)));}
        $oPseudo = $fh->tell() - $subbase;
        my (@pskeys) = keys %{$silf->{'pseudos'}};
        $fh->print(TTF_Pack("SSSS", TTF_bininfo(scalar @pskeys, 6)));
        foreach my $k (sort {$a <=> $b} @pskeys)
        { $fh->print(TTF_Pack("Ls", $k, $silf->{'pseudos'}{$k})); }
        $numlin = $silf->{'numLinearClasses'};
        $fh->print(TTF_Pack("SS", scalar @{$silf->{'classes'}}, $numlin));
        my (@coffsets);
        # printf "%X, ", $fh->tell() - $base;
        my ($cbase) = (scalar @{$silf->{'classes'}} + 1) * ($self->{'Version'} >= 4 ? 4 : 2) + 4;
        for ($i = 0; $i < $numlin; $i++)
        {
            push (@coffsets, $cbase);
            $cbase += 2 * scalar @{$silf->{'classes'}[$i]};
        }
        my (@nonlinclasses);
        for ($i = $numlin; $i < @{$silf->{'classes'}}; $i++)
        {
            my (@c, $d, @d);
            my $c = $silf->{'classes'}[$i];
            push (@coffsets, $cbase);
            @c = sort {$c->[$a] <=> $c->[$b]} (0 .. $#{$c});
            foreach $d (@c)
            { push (@d, $c->[$d], $d); }
            push (@nonlinclasses, [@d]);
            my ($len) = scalar @d;
            $cbase += 8 + 2 * $len;
        }
        push (@coffsets, $cbase);
        $fh->print(pack(($self->{'Version'} >= 4 ? 'N*' : 'n*'), @coffsets));
        for ($i = 0; $i < $numlin; $i++)
        { $fh->print(pack("n*", @{$silf->{'classes'}[$i]})); }
        # printf "%X, ", $fh->tell() - $base;
        for ($i = $numlin; $i < @{$silf->{'classes'}}; $i++)
        {
            
            my ($num) = scalar @{$nonlinclasses[$i-$numlin]};
            my (@bin) = TTF_bininfo($num/2, 1);
            $fh->print(TTF_Pack("SSSS", @bin));
            $fh->print(pack("n*", @{$nonlinclasses[$i-$numlin]}));
        }
        $oPasses = $fh->tell() - $subbase;
#        printf "original pass = %04X\n", $oPasses;
        push (@opasses, $oPasses);
        foreach (@{$silf->{'PASS'}})
        { push(@opasses, $self->out_pass($fh, $_, $silf, $subbase) - $subbase); }
        $end = $fh->tell();
        $fh->seek($ooPasses, 0);
        $fh->print(pack("N*", @opasses));
        if ($self->{'Version'} >= 3)
        {
            $fh->seek($subbase + 4, 0);
            $fh->print(TTF_Pack("SS", $ooPasses - $subbase, $oPseudo));
        }
        $fh->seek($end, 0);
        $silfc++;
    }
}

sub XML_element
{
    my ($self, $context, $depth, $k, $val, $ind) = @_;
    my ($fh) = $context->{'fh'};
    my ($i);

    return $self if ($k eq 'LOC');

    if ($k eq 'classes')
    {
        $fh->print("$depth<classes>\n");
        foreach $i (0 .. $#{$val})
        {
            $fh->printf("$depth    <class num='%d'>\n", $i);
            $fh->printf("$depth        " . join(" ", map{sprintf("%d", $_)} @{$val->[$i]}));
            $fh->print("\n$depth    </class>\n");
        }
        $fh->print("$depth</classes>\n");
    }
    elsif ($k eq 'fsm')
    {
        $fh->print("$depth<fsm>\n");
        my ($i) = 0;
        foreach (@{$val})
        { $fh->print("$depth    <row index='$i'>" . join(" ", @{$_}) . "</row>\n"); $i++; }
        $fh->print("$depth</fsm>\n");
    }
    elsif ($k eq 'colmap')
    {
        my ($i);
        $fh->print("$depth<colmap>");
        foreach my $k (sort {$a <=> $b} keys %{$val})
        {
            if ($i++ % 8 == 0)
            { $fh->print("\n$depth  "); }
            $fh->printf(" %d=%d", $k, $val->{$k});
        }
        $fh->print("\n$depth</colmap>\n");
    }
    elsif ($k eq 'constraintCode' or $k eq 'actionCode')
    {
        $fh->print("$depth<$k>\n");
        foreach my $i (0 .. $#{$val})
        {
            my (@rules) = $self->unpack_code($val->[$i]);
            next unless (@rules);
            $fh->print("$depth  <elem index='$i' code='" . join(" ", unpack('C*', $val->[$i])) . "'>\n");
            foreach my $r (@rules)
            { $fh->print("$depth    $r->[0]: ". join(", ", @{$r}[1..$#{$r}]) . "\n"); }
            $fh->print("$depth  </elem>\n");
        }
        $fh->print("$depth</$k>\n");
    }       
    else
    { return $self->SUPER::XML_element($context, $depth, $k, $val, $ind); }

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

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>. 


=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.



=cut
