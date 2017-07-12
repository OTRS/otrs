package Font::TTF::OS_2;

=head1 NAME

Font::TTF::OS_2 - the OS/2 table in a TTF font

=head1 DESCRIPTION

The OS/2 table has two versions and forms, one an extension of the other. This
module supports both forms and the switching between them.

=head1 INSTANCE VARIABLES

No other variables than those in table and those in the standard:

    Version
    xAvgCharWidth
    usWeightClass
    usWidthClass
    fsType
    ySubscriptXSize
    ySubScriptYSize
    ySubscriptXOffset
    ySubscriptYOffset
    ySuperscriptXSize
    ySuperscriptYSize
    ySuperscriptXOffset
    ySuperscriptYOffset
    yStrikeoutSize
    yStrikeoutPosition
    sFamilyClass
    bFamilyType
    bSerifStyle
    bWeight
    bProportion
    bContrast
    bStrokeVariation
    bArmStyle
    bLetterform
    bMidline
    bXheight
    ulUnicodeRange1
    ulUnicodeRange2
    ulUnicodeRange3
    ulUnicodeRange4
    achVendID
    fsSelection
    usFirstCharIndex
    usLastCharIndex
    sTypoAscender
    sTypoDescender
    sTypoLineGap
    usWinAscent
    usWinDescent
    ulCodePageRange1
    ulCodePageRange2
    xHeight
    CapHeight
    defaultChar
    breakChar
    maxLookups

Notice that versions 0, 1, 2 & 3 of the table are supported. Notice also that the
Panose variable has been broken down into its elements.

=head1 METHODS

=cut

use strict;
use vars qw(@ISA @fields @lens @field_info @weights @ranges @codepages);
use Font::TTF::Table;

@ISA = qw(Font::TTF::Table);
@field_info = (
    'xAvgCharWidth' => 's',
    'usWeightClass' => 'S',
    'usWidthClass' => 'S',
    'fsType' => 's',
    'ySubscriptXSize' => 's',
    'ySubScriptYSize' => 's',
    'ySubscriptXOffset' => 's',
    'ySubscriptYOffset' => 's',
    'ySuperscriptXSize' => 's',
    'ySuperscriptYSize' => 's',
    'ySuperscriptXOffset' => 's',
    'ySuperscriptYOffset' => 's',
    'yStrikeoutSize' => 's',
    'yStrikeoutPosition' => 's',
    'sFamilyClass' => 's',
    'bFamilyType' => 'C',
    'bSerifStyle' => 'C',
    'bWeight' => 'C',
    'bProportion' => 'C',
    'bContrast' => 'C',
    'bStrokeVariation' => 'C',
    'bArmStyle' => 'C',
    'bLetterform' => 'C',
    'bMidline' => 'C',
    'bXheight' => 'C',
    'ulUnicodeRange1' => 'L',
    'ulUnicodeRange2' => 'L',
    'ulUnicodeRange3' => 'L',
    'ulUnicodeRange4' => 'L',
    'achVendID' => 'L',
    'fsSelection' => 'S',
    'usFirstCharIndex' => 'S',
    'usLastCharIndex' => 'S',
    'sTypoAscender' => 'S',
    'sTypoDescender' => 's',
    'sTypoLineGap' => 'S',
    'usWinAscent' => 'S',
    'usWinDescent' => 'S',
    '' => '',
    'ulCodePageRange1' => 'L',
    'ulCodePageRange2' => 'L',
    '' => '',
    'xHeight' => 's',
    'CapHeight' => 's',
    'defaultChar' => 'S',
    'breakChar' => 'S',
    'maxLookups' => 's',
    '' => '',            # i.e. v3 is basically same as v2
    '' => ''             # i.e. v4 is structurally identical to v3
    );

@weights = qw(64 14 27 35 100 20 14 42 63 3 6 35 20 56 56 17 4 49 56 71 31 10 18 3 18 2 166);

use Font::TTF::Utils;

sub init
{
    my ($k, $v, $c, $n, $i, $t, $j);

    $n = 0;
    @lens = (76, 84, 94, 94, 94);
    for ($j = 0; $j < $#field_info; $j += 2)
    {
        if ($field_info[$j] eq '')
        {
            $n++;
            next;
        }
        ($k, $v, $c) = TTF_Init_Fields($field_info[$j], $c, $field_info[$j+1]);
        next unless defined $k && $k ne "";
        for ($i = $n; $i < 5; $i++)
        { $fields[$i]{$k} = $v; }
    }
}


=head2 $t->read

Reads in the various values from disk (see details of OS/2 table)

=cut

sub read
{
    my ($self) = @_;
    my ($dat, $ver);

    $self->SUPER::read or return $self;

    init unless defined $fields[2]{'xAvgCharWidth'};
    $self->{' INFILE'}->read($dat, 2);
    $ver = unpack("n", $dat);
    $self->{'Version'} = $ver;
    if ($ver < 5)
    {
        $self->{' INFILE'}->read($dat, $lens[$ver]);
        TTF_Read_Fields($self, $dat, $fields[$ver]);
    }
    $self;
}


=head2 $t->out($fh)

Writes the table to a file either from memory or by copying.

=cut

sub out
{
    my ($self, $fh) = @_;
    my ($ver);

    return $self->SUPER::out($fh) unless $self->{' read'};

    $ver = $self->{'Version'};
    $fh->print(pack("n", $ver));
    $fh->print(TTF_Out_Fields($self, $fields[$ver], $lens[$ver]));
    $self;
}


=head2 $t->XML_element($context, $depth, $key, $value)

Tidies up the hex values to output them in hex

=cut

sub XML_element
{
    my ($self) = shift;
    my ($context, $depth, $key, $value) = @_;
    my ($fh) = $context->{'fh'};

    if ($key =~ m/^ul(?:Unicode|CodePage)Range\d$/o)
    { $fh->printf("%s<%s>%08X</%s>\n", $depth, $key, $value, $key); }
    elsif ($key eq 'achVendID')
    { $fh->printf("%s<%s name='%s'/>\n", $depth, $key, pack('N', $value)); }
    else
    { return $self->SUPER::XML_element(@_); }
    $self;
}


=head2 $t->XML_end($context, $tag, %attrs)

Now handle them on the way back in

=cut

sub XML_end
{
    my ($self) = shift;
    my ($context, $tag, %attrs) = @_;

    if ($tag =~ m/^ul(?:Unicode|CodePage)Range\d$/o)
    { return hex($context->{'text'}); }
    elsif ($tag eq 'achVendID')
    { return unpack('N', $attrs{'name'}); }
    else
    { return $self->SUPER::XML_end(@_); }
}

=head2 $t->minsize()

Returns the minimum size this table can be. If it is smaller than this, then the table
must be bad and should be deleted or whatever.

=cut

sub minsize
{
    return 78;
}

=head2 $t->update

Updates the OS/2 table by getting information from other sources:

Updates the C<firstChar> and C<lastChar> values based on the MS table in the
cmap.

Updates the sTypoAscender, sTypoDescender & sTypoLineGap to be the same values
as Ascender, Descender and Linegap from the hhea table (assuming it is dirty)
and also sets usWinAscent to be the sum of Ascender+Linegap and usWinDescent to
be the negative of Descender.

=cut

sub update
{
    my ($self) = @_;
    my ($map, @keys, $table, $i, $avg, $hmtx);

    return undef unless ($self->SUPER::update);

    $self->{' PARENT'}{'cmap'}->update;
    $map = $self->{' PARENT'}{'cmap'}->find_ms || return undef;
    $hmtx = $self->{' PARENT'}{'hmtx'}->read;

    @keys = sort {$a <=> $b} grep {$_ < 0x10000} keys %{$map->{'val'}};

    $self->{'usFirstCharIndex'} = $keys[0];
    $self->{'usLastCharIndex'} = $keys[-1];

    $table = $self->{' PARENT'}{'hhea'}->read;
    
    # try any way we can to get some real numbers passed around!
    if (($self->{'fsSelection'} & 128) != 0)
    {
        # assume the user knows what they are doing and has sensible values already
    }
    elsif ($table->{'Ascender'} != 0 || $table->{'Descender'} != 0)
    {
        $self->{'sTypoAscender'} = $table->{'Ascender'};
        $self->{'sTypoDescender'} = $table->{'Descender'};
        $self->{'sTypoLineGap'} = $table->{'LineGap'};
        $self->{'usWinAscent'} = $self->{'sTypoAscender'} + $self->{'sTypoLineGap'};
        $self->{'usWinDescent'} = -$self->{'sTypoDescender'};
    }
    elsif ($self->{'sTypoAscender'} != 0 || $self->{'sTypoDescender'} != 0)
    {
        $table->{'Ascender'} = $self->{'sTypoAscender'};
        $table->{'Descender'} = $self->{'sTypoDescender'};
        $table->{'LineGap'} = $self->{'sTypoLineGap'};
        $self->{'usWinAscent'} = $self->{'sTypoAscender'} + $self->{'sTypoLineGap'};
        $self->{'usWinDescent'} = -$self->{'sTypoDescender'};
    } 
    elsif ($self->{'usWinAscent'} != 0 || $self->{'usWinDescent'} != 0)
    {
        $self->{'sTypoAscender'} = $table->{'Ascender'} = $self->{'usWinAscent'};
        $self->{'sTypoDescender'} = $table->{'Descender'} = -$self->{'usWinDescent'};
        $self->{'sTypoLineGap'} = $table->{'LineGap'} = 0;
    }

    if ($self->{'Version'} < 3)
    {
        for ($i = 0; $i < 26; $i++)
        { $avg += $hmtx->{'advance'}[$map->{'val'}{$i + 0x0061}] * $weights[$i]; }
        $avg += $hmtx->{'advance'}[$map->{'val'}{0x0020}] * $weights[-1];
        $self->{'xAvgCharWidth'} = $avg / 1000;
    }
    elsif ($self->{'Version'} > 2)
    {
        $i = 0; $avg = 0;
        foreach (@{$hmtx->{'advance'}})
        {
            next unless ($_);
            $i++;
            $avg += $_;
        }
        $avg /= $i if ($i);
        $self->{'xAvgCharWidth'} = $avg;
    }

    $self->{'ulUnicodeRange2'} &= ~0x2000000;
    foreach $i (keys %{$map->{'val'}})
    {
        if ($i >= 0x10000)
        {
            $self->{'ulUnicodeRange2'} |= 0x2000000;
            last;
        }
    }

    $self->{'Version'} = 1 if (defined $self->{'ulCodePageRange1'} && $self->{'Version'} < 1);
    $self->{'Version'} = 2 if (defined $self->{'maxLookups'} && $self->{'Version'} < 2);
    
    if ((exists $self->{' PARENT'}{'GPOS'} && $self->{' PARENT'}{'GPOS'}{' read'}) ||
        (exists $self->{' PARENT'}{'GSUB'} && $self->{' PARENT'}{'GSUB'}{' read'}))
    {
        # one or both of GPOS & GSUB exist and have been read or modified; so update usMaxContexts
        my ($lp, $ls);
        $lp = $self->{' PARENT'}{'GPOS'}->maxContext if exists $self->{' PARENT'}{'GPOS'};
        $ls = $self->{' PARENT'}{'GSUB'}->maxContext if exists $self->{' PARENT'}{'GSUB'};
        $self->{'maxLookups'} = $lp > $ls ? $lp : $ls;
    }
    
    $self;
}


=head2 $t->guessRangeBits (\%map, [$cp_threshold, [%u_threshold]])

Set the ulCodePageRange and ulUnicodeRange fields based on characters actually present in the font.

%map is a hash keyed by USV returning non-zero for characters present (e.g. use {'val'} 
a from Unicode cmap).

The two optional parameters are percentage of characters within the codepage or unicode range that need
to be present to constitute coverage. A threshold of 0 causes corresponding range bits to 
be set if any characters are present at all, while a negative value causes the corresponding
range bits to be unchanged. Defaults are 50 and 0, respectively.

For codepage bits, the threshold is percentage of characters between 0xC0 and 0xFF that need
to be present to constitute coverage). For codepages other than 1252, 
characters (e.g., punctuation) that are defined identically to cp1252 are ignored
for the purposes of this percentage calculation. Looks only for SBCS codepages, not DBCS.

For Unicode range bits that represent multiple ranges, e.g., bit 29 represents:

  Latin Extended Additional  1E00-1EFF
  Latin Extended-C           2C60-2C7F
  Latin Extended-D           A720-A7FF

the bit will be set if any of these ranges meet the threshold requirement.

=cut

sub guessRangeBits
{
    my ($self, $ucmap, $cp_threshold, $u_threshold) = @_; 
    $cp_threshold = 50 unless defined ($cp_threshold); 
    $u_threshold  =  0 unless defined ($u_threshold);
    my $j;  # index into codepages or ranges
    my $u;  # USV

    unless (ref($codepages[0]))
    {
        # One-time work to convert range data
        
        # unpack codepages. But first make sure we have Zlib
        eval {require Compress::Zlib} || croak("Cannot unpack codepage data Compress::Zlib not available");

        for ($j = 0; $j <= $#codepages; $j++)
        {
            next unless $codepages[$j];
            $codepages[$j] = [unpack("n*", Compress::Zlib::uncompress(unpack("u", $codepages[$j])))];
            warn ("Got nothing for codepage # $j\n") if $#{$codepages[$j]} < 128;
        }
        
        # convert Unicode array data to hash
        my @newRanges;
        for ($j = 0; $j <= $#ranges; $j++)
        {
            next unless $ranges[$j][2] =~ m/^([0-9a-f]{4,6})-([0-9a-f]{4,6})$/oi;
            my $s = hex ($1);
            my $e = hex ($2);
            next unless $e > $s;
            push @newRanges, {start => $s, end => $e, bit => $ranges[$j][0], name => $ranges[$j][1]};
        }
        @ranges = sort {$a->{'end'} <=> $b->{'end'}} (@newRanges);
    }

    if ($cp_threshold >= 0)
    {
        my $cpr;    # codepage range vector
        $cp_threshold = 100 if $cp_threshold > 100;
        vec($cpr, 63 ,1) = 0;   # Get all 64 bits into the vector
        for $j (0 .. $#codepages)   # For each codepage
        {
            # Count the number of chars from @range part of codepage that are present in the font
            my $present = 0;
            my $total = 0;
            foreach (0x20 .. 0xFF)
            {
                $u = $codepages[$j][$_];
                next if $u == 0xFFFD;   # Ignore undefined things in codepage
                # For codepage 1252, ignore upper ansi altogether
                # For other codepages, ignore characters that are same as in 1252.
                next if $j > 0 ? $u == $codepages[0][$_] : $u > 0x007F;
                $total++;
                $present++ if exists $ucmap->{$u} && $ucmap->{$u} > 0;
            }
            #printf STDERR "DBG: Got $present / $total (%0.3f%%) in codepage bit $j\n", $present * 100 / $total;
            #print STDERR "DBG: setting bit $j\n" if $cp_threshold == 0 ? ($present > 0) : (($present * 100 / $total) >= $cp_threshold);
            vec($cpr, $j, 1) = 1 if $cp_threshold == 0 ? ($present > 0) : (($present * 100 / $total) >= $cp_threshold);
            #print STDERR "\n";
        }
        ($self->{'ulCodePageRange1'}, $self->{'ulCodePageRange2'}) = unpack ('V2', $cpr);
    } 

    if ($u_threshold >= 0)
    {
        my $ucr;    # Unicode range vector
        my @count;  # Count of chars present in each range
        $u_threshold  = 100 if $u_threshold  > 100;
        vec($ucr, 127,1) = 0;   # Get all 128 bits into the vector
        $j = 0;  
CHAR:   for $u (sort {$a <=> $b} keys %{$ucmap})
        {
            while ($u > $ranges[$j]{'end'})
            {
                last CHAR if ++$j > $#ranges;
            }
            next if $u < $ranges[$j]{'start'};
            $count[$j]++ if $ucmap->{$u};
        }
        foreach $j (0 .. $#ranges)
        {
            vec($ucr, $ranges[$j]{'bit'}, 1) = 1 if $u_threshold == 0 ? 
                ($count[$j] > 0) :
                (($count[$j] * 100 / ($ranges[$j]{'end'} - $ranges[$j]{'start'} + 1)) >= $u_threshold);
        }
        ($self->{'ulUnicodeRange1'},$self->{'ulUnicodeRange2'},$self->{'ulUnicodeRange3'},$self->{'ulUnicodeRange4'}) =
            unpack ('V4', $ucr);
    }
}

BEGIN {

@codepages = (
<<'EOT',    # Bit 0: cp1252
M>)P-R>-B%E```-#S+1O+O%NU;-MVRURV[7?H"3*7;2_;M6S;K=7Y>Q`1)8VT
MTDDO@XPRR2R+K++)+H><<LDM6AYYY9-?`0454E@111537!`C5@DEE1*GM#+*
M*J>\"BJJI+(JJJJFNAIJJJ6V.NJJI[X&&FJDL2:::J:Y%EIJI;4VVFJGO0XZ
MZJ2S+KKJ)EYW/?342V]]]-5/?P,,-$B"P888:ICA1AAIE-'&&&N<\2:8:)+)
MIIAJFNEFF&F6V>:8:Y[Y%E@8$E-30J'(HE`LQ(408J*20I5(0J@;Z9::$IF?
MFO)_"X2"H4@H&F)#=,@3E1P3&QD<ZD7B__^"R"R++;'4,LNML-(JJZVQUCJ)
MUMM@HTTVVV*K;;;;8:===MMCKWWV.^"@0PX[XJACCDMRPDFGG';&6>><=\%%
MEUQVQ5777'?#3;?<=D>RN^ZY[X&''GGLB:>>>>Z%EUYY[8VWWGGO@X\^^>R+
3K[[Y[H>??OGMCQ1_I?X#Q@N!>@``
EOT

<<'EOT',    # Bit 1: cp1250
M>)P-Q^=+U'$`Q_'WY^>LW%K=G:/OG6:VM4R[*RU'.7.EY2BW5E:.MOM?Z8%8
MXB#!,O"1$8A$/2G:$D40$?6D2)`.NP=O>+T!8>&'/P$$$D0P&]C()D(()8QP
M(H@DBFABV,P6MF+#CH-8XH@G@6T8G+A()(GM)+.#%':RB]WL82_[V$\J:1S@
M(.D<(H-,#N/&PQ&.DD4VQSA.#KGDD<\)3E)`(4444T(IIRBCG`HJJ>(TU=1P
MAK/44D<]#9SC/(TTT4P+K;313@>=7.`BE^CB,E>X2C<]]-+'-:YS@YO<XC9W
MZ&>`08889H11,[7N-0Y?"2;9&./T*57-QJUZM6M8_;ZW&;N),_'&9:)-S+K7
MZ5*+\:A!'1K1`'>M)>NM<AB3/^/<XSX3:F22*::9T2`/F+4^*)<Y'O*(>1XK
M0$TL*,M:4;:&5,TB3V3Q5&X%LJ00EF7CF1P\YX7"%*$\%?"25ZK@-6]4JV[>
MJY>/K*B53ZKA,U_DQU=Y%,0WA?)==GXHEI_\4K@BE:]"?O-'E?QE577J84U]
+_,.K-NO=?_3I:`(`
EOT

<<'EOT',    # Bit 2: cp1251
M>)P%P=52%5``0-$-;!KISG,OW=W=#=(IV-W=_H+^@0^.CB,Z^J`^^&V.K@7$
M$$L<$D\"B2213`JII'&*=#+()(ML<L@ECWP***2(8DHHI8QR*@A$B%))%=74
M4$L=]3302!/-M-!*&^UTT$D7W?302Q_]###($,.,,,H8XTPPR133S##+'/,L
ML,@2RZRPRFG66&>#3;;89H==]MCG@$/.<,0Q9SG'>2YPD4M<Y@I7N<9U;G"3
M6]SF#G>YQWT>\)!'/.8)3WG&<U[PDE>\YHVQQH5B-T)YJ`DA1,)):#,Y])MB
MFJEFN!X*0U$H#64A&G)"[K^_D:A[8<!]#SWPF/>F>V02'WS+1SX9PV?E"R=\
MY9N)?.>'"6[[CI_\XK=KD7PW^>.N\6ZY8Z999IMCKGGF6V"A119;8JEEEEMA
M,&+42JNLML9:ZZRWP4:;;+;%5MMLM\-.N^RVQU[[['?`08<<=L11QQQWPDFG
3G';&6>><=\%%EUQVQ=7_+3E$L0``
EOT

<<'EOT',    # Bit 3: cp1253
M>)PUB><WEG$`AB_=[9+,$/J];])&2QE-39+VWKN4T2(-7^A4I]-`DI:.G=<.
M12)-H_ZCYSR]7YS[7!^NZP8\&(48S1C&,H[Q3&`BDYB,)U/P8BK>^."+'_X$
M,(U`@@AF.B&$$L8,#`Z<S"2<640PFSG,91[S6<!"(HDBFD4L9@E+648,RUE!
M+''$D\!*5K&:-:QE'8FL9P,;V<1FMI!$,EM)81NI;&<'.]G%;O:PEWWLYP`'
M.<1ACG"48QSG!"<YQ6G.<)9SG.<"%TGC$I=))X-,LKC"5:YQG1MDD\--<KG%
M;>YPESSCLBT3[%%HPDR$,<;AMF@WL;8U,A-H@DR("35.XVO\;,OA=+>XD9=R
M%>@>%512134UU%+GKO6X:*#1^--,"ZVT*9]V.NC4?3W00[KUB!X]UA,]U3,5
MJDC%>JX2O5"I7JI,K_1:;_16[U2N][:E"E6J2M6J4:WJ]$'U<JE!C6I2LUK4
MJC9]5+LZU*E/^JPN=>N+>O15O>K3-_7KNW[HIW[IM_YH0(,:TK#^ZI]M_0=K
#AH5\
EOT

<<'EOT',    # Bit 4: cp1254
M>)PER6-ST'$``.#GOVPLM]9OJY9KR\NV[99M^SOT";)MV[S,NVQ=]JWKNN?E
M@TB,##+*)+,LLLHFNQQRRB6W//+*)[]8!1142&%%%%5,<7%*B%=2D"!1*:65
MD:2L<LJKH*)**JNBJF0IJJFNAIIJJ:V.5'754U\##3726!---=-<"RVUTEH;
M;;737@<===)9%UUUTUT//?726Q]]]=/?``,-DF:P(88:9K@11AIEM#'&&F>\
M"2::9+(IIIIFNAEFFF6V.>::9[X%%H;UZ7]"L6A1B`])(82$F),A.4H+J5'7
M]#__A2*A:(@+)4)BB`T%8NXE)$:#0]VHV[^+9EELB:6666Z%E599;8VUUEEO
M@XTVV6R+K;;9;H>==MEMC[WVV>^`@PXY[(BCCCGNA)-..>V,L\XY[X*++D7Q
M+KOBJFNNN^&F6VZ[XZY[47(TT'T///3(8T\\]<QS+[STRFMOO/7.^ZBD#S[Z
6Y+,OOOKFNQ]^^N5WE!(-DOX7C-.`8```
EOT

<<'EOT',    # Bit 5: cp1255
M>)Q%C]=7#@`<AI\^7F04"FV_[T-#1G9EE%U66UG9>X;L\3_X"Z)3*4E[G)9Q
MCFLR(MDK71'GN/K.)\[I.,_=\]X\+^"%@T$,1@QA*,/P9C@C&,DH?/!E-&,8
MBQ_^C&,\$P@@D""""2&4,"9B.'$QB<E,(9P((HEB*M%,8SHSF$D,LYC-'.8R
MC_DL()8XXEG((A:SA`026<HREK."E:QB-4DDLX:UK&,]&T@AE332R2"3+#:2
M30Z;V,P6MK*-7+:S@YWL8C=[V,L^]G.`@QSB,$<XRC&.<X(\3G**T^1SAK.<
MXSP7N,@E+G.%JU;N<5N0US4+LW`S<SH>6DR_B?.X![``"[00"S67^9F_H]OI
MZG?Q`RL%7.<&A59&$<64<)-2.KE%.;>IX`Z55%%-#;7444\#C33QFV9::*6-
M=E6J2M6J4:WJ5*\&-:K)XU:S6M2J-K7KKN[IOA[HNWZH3S_UZW_97_1(C]6A
M)WJJ9WJN3KW02W7IE;KU6F_T5N_T7A_T49_T65_T53WZIMY_OWS,U^/^`\"V
"EBL`
EOT

<<'EOT',    # Bit 6: cp1256
M>)P%P;=/%``8A^'W$'\J'*`"2N>[`XX.1^?.1N_UL``*=A'L8$,4-^.J$R,1
M&Q$%%+N2N/@'N+@:%UN"BXDA./@\@(,@5A',:L0:UK*.$$)Q$D8X$:QG`QN)
M)(IH-K&9&&*)(YX$$DDB&<.%FQ122<-#.AEDDD4V.>221SY>"BBDB&)***6,
M<GSXV<)6MK&='5102175U%!+'?4TT$@3S;302AOM=-!)@"YVLHO=[*&;'GK9
MRS[ZZ&<_!SC((0YSA*,<8X#C##+$"4YRBM.<X2SG&&:$\US@(I>XS"A7&.,J
MUQCGNLUHW.(<MRW)/&;F"OIH7HV:SQ'0#4WHIF8MQF(MP1+-;9$6I6F76[?,
M[^@RIX7I#9-R<H<I[G*/^SS@(=-:Y!$S/.8)L\PQSU.>L<!S7O"25[Q6/&]Y
MQWL6E:P/<LFM%*4J31ZE*T.9RE*V<I2K/.7+JP(5JDC%*E$IGU6F<OGD5X4J
M5:5JOJB&KZI5G>K5P#>^\X.?_%*CFECBMYK5HE:U\4?MZN"O.EE6@!7^6;A%
'Z--_?PY;L```
EOT

<<'EOT',    # Bit 7: cp1257
M>)P-B4=/%&``1-^L%`M86(1=FM\N106E]R)2;6`7%"P@%CI([_X5HT8E8N]1
M.5GBV2@22;P("6<C>G"S?H<W\S(#"`>K"""0(()9S1K6LHX00EG/!C:RB3"<
MA+.9"")QX2:*:&*()8XM&#QXB2>!1)+8RC:VDTP*.]A)*FFDDT$F66230RYY
MY%-`(4444\(N2ME-&>544$D5U>QA+_O8SP%JJ.4@ASC,$8YRC..<H(YZ3G**
M!AHYS1G.<HXFFCE/"Q>XR"4NTTH;[73021?=]-#+%?KH9X!!AAAFA%'&&&>"
M2::X:F;\/A-EB3-)QAB/M71+@=_''<='7EIW&;>),;'&:YPFW._S>.U6:/\'
MCN\VKUFN<X.;MF]QFV],JXZ[S'"/^WS@(8]XS!.>\HSGO.`OKU3/:][PEEF6
M%*!4H2#>\5XNA2F$3QI5A+S*5;**U*0*5?%9-7SA*W/J4YD:U,Z"QC7)#P4J
M35(P/UF46TZ%LJPQ12I>>4I1L9I5J6I^J9;?K/!'_2I7HSKXIPE-.>;_`YNL
";XP`
EOT

<<'EOT',    # Bit 8: cp1258
M>)PER>5.EF$`@.'KY;,[,%#1!U3L[NYNL+N[$_L</`*PN[MUBC5U3F>R&;.=
M.J>S&>K<_>^Z$8D3DT=>^>170$&%%%9$4<445T))I906KXRRRBDO004559*H
MLBJ"),FJJJ:Z%#745$MM==153WT---1(8TTTU4QS+;342FMMM-5.>QUTU$EG
M773537<]]-1+;WWTU4]_`PPT2*HT@PTQU###C3#2**.-,=8XXTTPT22333'5
M--/-,-,LL\TQUSSS+;#0(HLML=0RZ99;8:555EMC;=B9FQ,J1.M"Y9`20DB*
MRPH-_TJK*#4WYW^A?$@(E4)B2`ZE0WQ<=E+R7VL=I?U[4;H,F=;;8*---MMB
MJVVVVV&G77;;8Z]]]CO@H$,..^*H8XX[X:133COCK'/.1W$NN"C+)9==<=6U
M&-?=<#,JX5:LH-ON1!GNNN>^!QYZ)#O:$XMY[(FGGD4QS[WPTBNOO?'6NUCD
@O0\^1B5]BE7UV9<HTU???/?#3[_\CO:&'7+_`."G?R``
EOT

undef,      # Bit 9: Reserved
undef,      # Bit 10: Reserved
undef,      # Bit 11: Reserved
undef,      # Bit 12: Reserved
undef,      # Bit 13: Reserved
undef,      # Bit 14: Reserved
undef,      # Bit 15: Reserved

<<'EOT',    # Bit 16: cp874
M>)Q=C=52&U``!1?W11(@@00N`8*[4\'=W>KN[OHK_8#^8J=]Z.0!9E_.S,Z<
M!;+()H=<\LBG@$****:$4LJ0<BJHI(H(4:JIH988<>JH)T&2!AH)-)&BF19:
M2=-&.QUTTD4W/?321S\###+$,".,,L8X$TQRB<M<X2I33#/#+'/,L\`B2RRS
MPBIKK+/!)EMLL\,N>^QSP"%'''/"*6=<XSHWN,DM;G.'N]SC/@]XR",>\X2G
M/.,Y+WC)*U[SAK>\XST?^,@G/O.%KWSC.S_X&7[__?.?D,ZL\X18B(=$2(94
MB(3H1<LOL\PVQUSSS+?`0HLLML12R]1R*ZRTRHA1JZVQUIAQZZPW8=(&&PTV
MF;+9%EM-VV:['7;:9;<]]MIGOP,..N2P(XXZYK@33F;J3CGMC+/..>^"BRZY
@[(JKKKGNAIMNN>V.N^ZY[X&''GGLB:>>91[^`:-3=+0`
EOT

undef,      # Bit 17: Reserved
undef,      # Bit 18: Reserved
undef,      # Bit 19: Reserved
undef,      # Bit 20: Reserved
undef,      # Bit 21: Reserved
undef,      # Bit 22: Reserved
undef,      # Bit 23: Reserved
undef,      # Bit 24: Reserved
undef,      # Bit 25: Reserved
undef,      # Bit 26: Reserved
undef,      # Bit 27: Reserved
undef,      # Bit 28: Reserved
undef,      # Bit 29: Reserved
undef,      # Bit 30: Reserved
undef,      # Bit 31: Reserved
undef,      # Bit 32: Reserved
undef,      # Bit 33: Reserved
undef,      # Bit 34: Reserved
undef,      # Bit 35: Reserved
undef,      # Bit 36: Reserved
undef,      # Bit 37: Reserved
undef,      # Bit 38: Reserved
undef,      # Bit 39: Reserved
undef,      # Bit 40: Reserved
undef,      # Bit 41: Reserved
undef,      # Bit 42: Reserved
undef,      # Bit 43: Reserved
undef,      # Bit 44: Reserved
undef,      # Bit 45: Reserved
undef,      # Bit 46: Reserved
undef,      # Bit 47: Reserved

<<'EOT',    # Bit 48: cp869
M>)Q%R>=7#0`<Q^&/OLB(0G%3N.K^LK*S0U;#+$5$1$141E967I03IZ-QB13=
M3EHJ&@C)WN(_ZN0<;YSGY0,,P@LQF"$,Q9MA#&<$(_%A%*/QQ8\QC&4<_@0P
MG@DX"&0B000SB<E,P<E40@C%A1'&-*8S@YG,(IS9S&$N\YC/`A82P2(6LX2E
M+&,Y*XAD):M8311K6,LZUK.!:&*()8Z-;&(S6]C*-N))8#N))+&#G22SB]VD
ML(>]I+*/_:1Q@(.D<XC#9'"$HV1RC.-DD4T.)SC)*4Z3RQG.<H[S7""/BUSB
M,E>X2OY`_W^Z/M!/-ZTT.!W.0!4Y`W1#-_58Q?_VEEIH5@F==*F5.K7IB9[J
MITK5I]\J4[G<NJT[JM!=>G5/E;308V56;F[S,I?NJTK5>F#IEF#)EJJ'JC$_
M\[<("[=@PR+E4:VE6))E6H:E6;QEJ4Z/5*\&-:I)S>I0I[K,83Y69`5ZIN=V
M32_4K9=ZI=?JT1OUZJW>Z;T^Z),^ZK,*:*-#7_15WVC4=Q723I-^Z)?:]<<\
'>/X"GB5Z;@``
EOT

<<'EOT',    # Bit 49: cp866
M>)P%P45#$P``AN$7_!0#<=088]381XYN&-W=#:,;N]N#!P\>C#_`P1_@S;_G
M\P`II'(#<9-;I'&;.]SE'NG<)X,'!,@DBVQRR"5('B'R"5-`A$****:$4J*4
M$<.44T$E55130YQ:ZJBG@4:::*:%5MIHIX-.NN@F00^]]-'/`(,,,<P(HXPQ
MS@233#'-#+/,,<\"BRRQS`JKK+'.!IMLL<T.27;98Y\##CGBF!-..>.<"RZY
MXB&/>,P3GO*,Y[S@):]XS1O>\H[W?.`CG_BL@#*5I6SE*%=!Y2FD?(55H(@*
M5:1BE:A4494I)JM<%:I4E:I5H[AJ5:=Z-:A136I6BUK5IG9UJ%-=ZE9"/>I5
MGW_ZEW\[U3'O^\"K7O&A%[SF'6][RP'GN,5Q1XP33GK7FU[VN4^\YWE?^=1G
M/O*Q-[SN12_YTA<..=W?_-7?_<-?U*\!#6I(PQK1J,8TK@E-:DK3FM&LYI2B
:!4G+2M.:,I3D;S2??]%P:9`_ON;Z/\R_26T`
EOT

<<'EOT',    # Bit 50: cp865
M>)P%P3=,%&``AN$7?FR(>BH@W>,_/A%%;-BQ*V*G]W9P1[=W:0X.#@P(BR,&
M([$,8B0F1J.)B'%D,0XD*K$W@AHIDNCS`#[X8O!C$I.9PE2FX<]T`IC!3&;A
M8#9SF$L@000SCQ!""2.<""*)8CY.HK&XB$$L():%Q+&(Q<2SA`26LHSEK&`E
MB:QB-6M8RSK6LX$D-K*)S6QA*]O8S@YVDLPN4MC-'O:RC_T<X""II)%.!IED
MD4T.N>213P&%%%%,":6X*:,<#UXJJ*2*:FJHI8Y#'.8(1SG&<4YPDE.<Y@QG
M.<=YZFF@D2::><X$GQGD'6]XST>^\)5/#/&#;_3RC!=\H(_?_.$G?QGC'R\9
M8)1.7CF[?-IXRW=^,<XP_=SD`8]=#F[SB(=<Y1;7=%EM:I>O8N16F;*5I7*E
M*4=%*E2!'`I4HN(5(92D8I4H7YFJ5H5*E:HZ5:I*'GF5IURE*T.UJE&(`G1)
M%]6B5ETPW;PV[>:)Z31/Z3&]YKJY8FZ8>S;*])D>&V?==%NO];B<KFA&;`IW
0;"CW;9BSF;OJH.,_G\AQ]P``
EOT

<<'EOT',    # Bit 51: cp864
M>)P=R'EHSW$<Q_&G_7B[?AB&7;;YVL<Y]]S#S+&YS7W;?;GO<VY_"2%)2\8<
M:18C+<V2/R@W24N2)$G(%5/\7C_E\><#J$<(/NK3`*,AC6A,$YKBIQG-:4$H
M+6E%:\)H0UO:$4X$D40137MBB"6.#GAT)-Z*Z$1GNM"5;G0G@1[TI!>]Z4-?
M^I%(?P8PD$$,9@A#26(8PQE!,B-)812C&<-84DEC'..9P$0F,9DI3"6=:4QG
M!C.9Q6SF,)=YS&<!"UG$8C+()(ML<L@ECWP***2()2QE&<M9P4I6L9HUK&4=
MZ]G`1C:QF2ULI9AM;.<R55Z$%^D..UR(2W+Q+L%%NT07ZOPNS(7[KG@QOCM4
M4L,-+XURJE6GW\%`,*`_^AL,4$J%=E'&&>WYOP=T4$=UW/PZH5,Z:QF6:5F6
M;3F6:WF6;P56J*<6I4I=TW6+Y;1V:*=V:Z_N:9_VZY".Z)A*=%)E.J\+*E>%
M+NFJJE2MF[JEV[JOQYSC(G74ZJXEZYEJ]5*O]5;O]5&?]44_5*,'>J2'>J-B
<2]<[?=`G?=5W/=%S_=0OO=(+?7.EP<`_%"[`E0``
EOT

<<'EOT',    # Bit 52: cp863
M>)P%P4E0#7``Q_%O_9&E>!(M4J__ZQ<I%-E#MA9K^[Z]>J_=4I;L.3@X=$A=
M'!N9:#+3HF+&,@W&.L/%Q3##N%3,<&#&6`X^'\`'7PS3F,X,_)C)+&8S!W\"
MF,L\',PGD`4$L9!%!!-"*&$L)IPE1!")DR@L+J(1,2QE&;$L)XYX5K"25220
MR&K6D,1:UK&>#6QD$YM)9@M;V48*V]G!3G:QFU322">#/>QE'_LYP$$RR2*;
M''+)(Y\""BFBF!)**:.<"BIQ4T4U'KS44$L=]3302!.'.,P1CM),"\<XS@E.
MTLHI3G.&LYSC/!=HXQG_F.(SC_C$&!-\X2N3?.>;,YAQ;O""Y[SD)Z]XPU]^
M<YVW?.`:/;SCO4\GO8SP@S_<Y"ZW&>"UR\$M'G"?A_1S3U?4J2[Y*EIN52E?
M>:I6E@I4IE*5R*$@)2E>X4+)*E>%BI6K>M6H4IEJ4JWJY)%712I4MG+4J`:%
MR%^7=4GMZM!%,\1'TV7&38]YS*AY8GK-5=-G1FR$>6I&;:QU,V2]UN-RNJ+X
39=,9M*'<L6'.-H;53?=_2B5O-```
EOT

<<'EOT',    # Bit 53: cp862
M>)P%P3=,U'$<QN$/_/Q:44]%!40X_L>KHMBQ8V_8Z;T=W-'MO<+@X,"@L#BB
M1(UE$",QL403C;/8.V+7Q,$XF#CY/$`$D3CZ8?1G``,9Q&"&$,50AC$<'R,8
MR2BB&<T8QA)#+'&,(Y[Q))"(GR0\`B0C)C"12:0PF2FD,I5I3&<&,YG%;-*8
MPUSF,9\%+&01Z2QF"4M9QG)6L))5K&8-:\E@'>O9P$8VL9DM9))%-CGDDD<^
M!1121#$EE%)&.154$J2*:D*$J:&6.NIIH)$FMK*-[>Q@)[O8S1[VLH_]'.`@
MASC,$8YRC&9[9#WVV)[84WMFS^V%O;17]MK>V%M[9^^MUSY8GWVT3_;9OMA7
M^V;?[8?]Y"R=G/-?B&BCCU_\X1^_Z>$2-[D;\'&%.]SF#)>YI5-J4[LBE:R@
MJI2O/%4K2P4J4ZE*Y%.TTI2J>*%TE:M"Q<I5O6I4J4PUJ59U"BFL(A4J6SEJ
M5(-B%*43.JY6G52+ZZ+7M;M[KM/=I]L]<.?=:7?17?<2W$/7[:5X0;J\L!<*
8^`-)_/4RN.K%<L.+\S=S31UT_`?UB7$X
EOT

<<'EOT',    # Bit 54: cp861
M>)P%P4=(%7``Q_&O_FU;O4K+W?/__%6F;=NVRZRTW'L]?<_=WD/MT*&#!]-+
M1T,H)`\928<,C4SI$`2!1)@-VB($185F]/D`/OAB\&,2DYG"5*8QG1GX,Y-9
MS,;!'.8RCP`"F<\"@@@FA%#""">"A3B)Q.(B"K&(Q2PAFJ7$$,LREK."E:QB
M-6N(8RWK6,\&-K*)S<2SA:UL8SL[V,DN=K.'!/:2R#[V<X`DDCG((5)()8UT
M,L@DBVQRR"6/?`HHI(AB2G!32AD>O)1302555%-#+8<YPE&.<9P3G.04ISG#
M6<YQG@M<Y!)UU-/``'_YRGL^\):/?.8;(WSA.=\9IH\G/.43_?SD%_\8YS43
M##+$']IXZ;SET\P[1OG!&(]XQ@M>T>-RT,%#NKG!;1[HFIK5(E]%R:U292E3
M94I5M@I5H'PY%*`XQ2I,*%Y%*E:>,E2E<I4H1;6J4*4\\BI7.4I3NFI4K2#Y
MZZJNJ%%-NFPZ>6-:3*]I,X_I,GWFIKENVLT]&V'Z39>-MFXZK==Z7$Y7)+]M
2(G=L,/=MB+.!NVJE]3^&>7'F
EOT

<<'EOT',    # Bit 55: cp860
M>)P%P4E0#7``Q_&O_G8A*MKD]7_]4F2/0F07*NW[]NJ]=DOVO0X=.CB@BV,T
MPU@.931FJ"DR6:8.%0?&#.I@&0[(&,;!YP-,P`O#1"8QF2E,91K3F8$W,YG%
M;'R8PUQ\\<.?><PG@$"""":$!82R$`=A6)R$(R)81"11+&8)T2QE&<M9P4I6
ML9H8UK"66.)8QWHV$,]&-I'`9K:PE6UL9P<[V44BN]G#7I)()H5]I))&.AED
MDD4V.>221SX%%%)$,264XJ*,<MQXJ*"2*JJIH98Z]G.`@QRBGL,<X2C'.,X)
M3G**TYSA+.<X3P-/^<=G1AGC/8_XR!=>\(E!7O*5/A[SG%Z>,<XO?O"&/PSP
MBK=<HXW7CAN,\(%O_.0OWQGB%@_H89@[=-/%56[S4)=T62WR4KA<*E.VLE2N
M-.6H2(4JD(_\%*-HA0C%JU@ERE>FJE6A4J6J3I6JDEL>Y2E7Z<I0K6H4(&\U
MJTD7=%&-IH-WIL7TFC;31Z=Y8JZ;*^:FN6=#3;_IM%'618?U6+?3X0SCMTVD
1W09RWP8Y&KBK5EK_`R9#<9@`
EOT

<<'EOT',    # Bit 56: cp857
M>)P-RE-W%W```-#[7[:6E_O%Y67;7BUKM5HMVSWTT&OU!;)MVSR9YV3K9)_:
MZST7$5'22"N=]#+(*)/,LL@JF^QRR"F7W/*(EE<^^1504"&%Q2BBJ&***Z&D
M4DH+RBBKG/(JJ"A6)955454UU=40IZ9::JNCKGKJ:Z"A1AIKHJEFFFNAI59:
M:Z.M=MKKH*-..NNBJVZZB]=#3PEZZ:V/OOKI;X"!!AELB$1##9-DN!&2C31*
MBM'&&&N<\2:8:)+)IIAJFNEFF&F6V>:8Z[0_7GGLJ8>>>>&U-U[ZX'VDFA-.
M.NNY4[[XYI/??D:JNNF^'Y:['1D0&>B1=S[[Y:,KD:*18@[;9(.##EAJO?UA
M85@4%H>H4-I1QQRQ-B2&KB$A]+?,RI`S1(>X$!MB@M#`$\=#GQ`?DD-2&!2Z
MA!0K[+/..>>=^??719=<#@5"UK`@S+?*A3#/-0]<=]57-^Q,/;?<=<\=;_VS
<V0X;;4W50W99[;L]MEACM[VVVQ:66/(?I8M\J@``
EOT

<<'EOT',    # Bit 57: cp855
M>)P%P<52$``40-$+7$`%*>D&>3327=)("4A(HU@H=K<+%V[5'V#AC`O'+_#G
M/`=(()$D))D44CG#6<Z11CKGR2"3+++)X0*YY)%/`84444P)I9113@655%'-
M16H(:JFCG@8:::*9%B[12AOM=-!)%]WTT$L?_0PPR!##C##*9<889X))IIAF
MAEFN,,<\"RRRQ%6666&5:ZRQS@:;7&>+;7;898]]#CCD!C<YXA:WN<-=[G',
M?1YPPD,>\9@G/.49SWG!2U[QFC>\Y1WO^<!'/O'951.]9I(K)KBFKIOLABEN
MFNIUS[CE6;<]YXYI[IKNOAD>F.F2EYRST3:S;#?;:6OM,M=N\YRTQDXO\(=_
M\3U^Q,](C!JG#/LLC*-8B<W8L]^BR(K<Z(KF*`UBR`&+8SO6XCCNQ&$LQPF_
M'+3$(4L=MLP1RQV-PDB/;_'5"J_&%UN];*5C5CENM1->M,=\.\QQP>:J?/XZ
8;Y.]%CAKO8NV>,4&9ZSC=YQR^A\'$$.V
EOT

<<'EOT',    # Bit 58: cp852
M>)P%P=M/S@$<Q_'WY]?)X:F>%)Z.1%^BG',HG8M2#L^C)]63ZJFG(M+!N;,+
M%]WB'^C"QH:MBRYLKIBMF7'#*H=FS&9FN6%LIJW7"Q`.88030211+&,Y*UB)
MBVABB,5-'*N()X'5K&$M'A))(ID44DEC'>M)9P,;R<#8Q&8RV<)6LLAF&]O9
MP4YVL9L]Y+"7?>SG`+GD<9!\"BBDB&)***6,<@YQF`HJ.4(5U1SE&,<Y@1<?
M)ZG!3RVGJ*.>!@(T<IHFFFDA2"MMA&BG@T[.<)8NSG&>;B[00R]]]'.12USF
M"E>YQG4&&&2(848898QI_O.=+WQ5KZ+XIE)^R"L?/S7`<T7R0KG*XS=_5*!"
M!=3(#!_5K@Z5,*MH/K/`+_XI7!$:T:@\2N2A!N52"P]X8K?LMMTQQS)XRC,E
MJ=E"YK,Z:]*0ALUM"99CV99B6+X<A5G`_-9EG18TKW5S5W%R*X:7BE4%KWBM
M9/.8R\;MIMK48S=XPR?>JDSEJE10K?+S7K7J8Y%YA9CBD3/O?'"FG3GN\9?'
13'+?>:=^U:O!)IA8`NR$89P`
EOT

<<'EOT',    # Bit 59: cp775
M>)P%P<U3S`$<Q_'W)SUA4RJURY:?K6^HE(<46@\][")%D3:;V$3TX*D\]=RA
M0P<']`\T:C*&#!J,\7#"C+,)!S,NF'$VZ.#@]0)$%`N()H98XHAG(8M8C(L$
MEI!($DM))H54EI%&.FX\+&<%7C+(9"4.J_"1139&#JM9PUIRR2.?=110R'HV
ML)%-%+&98DK8PE:V48J?[>Q@)[LHHYP**@D09#=[V$L5^ZBFAOT<H)8Z#G*(
M>@[30(A&CA"FB:,T<XSC1&CA!*V<Y!1MG.8,[73021=G.<=Y+G"1;GJXQ&6N
M<)5K]-)'/P,,,L2P8OG'3XEORN*[XE2N%#4HI#SU\H:WO.<'[U3#'_FXK;":
M^,@7YIGD,Y^8$LKEE_HUH#XG@VGN\H#[O.*ERKC'"[MIMVS<HBQ;T7+)K31K
MM3H+6;,*%+$D2[4BRS>O87YUJ\/"5F_MUF81J[4N#2I&"?(H785J48\Z-61N
M<]F8C=IUNV$C?."KJE7!;^9XHDH5JT2E\BNH9`4<#S,\<KR\YBEW^.MD\M#G
.X1G/F>6Q33#Q'V@>75\`
EOT

<<'EOT',    # Bit 60: cp737
M>)P%P65W#@``AN';'FT8AFV&>>V1T]/3-;WN[M*=\\%QQMG!-IVOH]LFIKOK
M[_CJNH`.A"`ZTHG.=*$KW>A.#T+I22]Z$T8?^M*/</HS@(%$$$D4@XAF,$,8
M2@S#"#"<6,P(1C**T8QA+'&,8SP3F,@D)C.%>*8RC>G,8":SF$T"<YC+/.:S
M@(4L8C%+6,HR$EG."E:RBM6L82U)))-"*FFDDT$F66230RYYY%-`(4444T(I
M991302555%-#+76L8ST;V,@F-K.%K6QC.SO8R2YVLX>][&,_]6I2LUIT0B=U
M2J=U1F=U3N=U01=U29<5U!5=U35=UPW=U"W=5JO:]%A/]%3/U*[G>J&7>J77
M>J.W>J?W^J!/^JC/^J*O^J;O;G*S6QSB6!>[Q!E.=ZF3G>E\YSG780YWO.,<
M;9S@`A<ZQVFN=H6+G.0Z5[K*92YWMK.<XE37NL81#G6##[K1QWU`/W1/]_5`
M/_50O_5'O_17A]2@PSJB1AW5,5H#Y8$RW=%=_@42>12(I#T0%5-/FX,$_P-K
#(&Q0
EOT

undef,      # Bit 61: cp708 (unknown)

<<'EOT',    # Bit 62: cp850
M>)P%P5-C$&```,#;<BW;VI>UC&5[JV6WW++=0P^]5G\@V[9MV[;M.T2(E$QR
M*:242FIII)5.E/0RR"B3S++(*IOL<L@IE]SRR"N?_`HHJ)#"BB@J6E!,<264
M5$II99153GD5Q*BHDLJJJ*J:ZFJHJ998M=515SWU-=!0(XTUT50SS;704BNM
MM=%6G'CMM)>@@XXZZ:R+KKKIKH>>>NFMC[X2]=/?``,-,M@00R499K@11AIE
MM#'&&F>\"2::9+(IIIIFNAF.^>V%AQZ[[XEG7GKEN7?>>NVP(TYXZJC/OOKH
MEQ_^N>JV[Q:Y[EK$7`^\\<E/'URPTD[[K+7:'KLML,JN,"?,#?-"9(AVP$'[
MK0B)(3YT"CTLM"1D"ME"Y5`FY`M"K$<.A:XA(0P.`T+O$!>2+/;>>2>=<CPB
MQAEGG0NY0E28'699ZG28Z9)[+KOHBRNV^.NNFVZYX8\[UMELC0V%<MIKJV6^
2V6Z]Y;;989.-8;[Y_P%EF7O'
EOT

<<'EOT',    # Bit 63: cp437
M>)P%P3=,%&``AN$7?FR(>BH@(.#Q'Y^*(C;LV!LJ*+VW@SNZO1?`P<&!`6%Q
M1`D8RR!&8H(03$2,HXN3B4#LC5@B`4GT>0`??#'X,8G)3&$JT_!G.@',8":S
M<#";.<PED"""F4<(H80QGW`BB&0!3J*PN(A&+&01BXEA"4N)91EQ+&<%*UG%
M:N)9PUK6L9X-;&03"6QF"UO9QG9VL)-=[&8/>TED'_LY0!+)'.00*:221CH9
M9))%-CGDDD<^!1121#$EN"FE#`]>RJF@DBJJJ:&6PQSA*,<XS@E.<HK3G.$L
MYSC/!2YRB3KJ:>`Y$WQBF+<,\HX/?.8+'QGA.U_IYQDO>,\`O_G#3_XRQC]>
M\9J;M-'NO.73S!#?^,4X/WC)';KI<SFX1R\]W.`NCW5-S6J1KZ+E5JFRE*DR
MI2I;A2I0OAP*5+QB%2Z4H"(5*T\9JE*Y2I2B6E6H4AYYE:L<I2E=-:I6B`)T
M55?4J"9=-IV\,2WFB6DS3^DR_:;#7#>WS4,;:09,EXVQ;CJMUWI<3E<4HS:1
1^S:41S;,V<`#M=+Z'T-Z<84`
EOT

); 

# The following taken directly from OT Spec:

@ranges = (
    [ 0,    "Basic Latin",  "0000-007F" ],
    [ 1,    "Latin-1 Supplement",   "0080-00FF" ],
    [ 2,    "Latin Extended-A",     "0100-017F" ],
    [ 3,    "Latin Extended-B",     "0180-024F" ],
    [ 4,    "IPA Extensions",   "0250-02AF" ],
    [ 4,    "Phonetic Extensions",  "1D00-1D7F" ],
    [ 4,    "Phonetic Extensions Supplement",   "1D80-1DBF" ],
    [ 5,    "Spacing Modifier Letters",     "02B0-02FF" ],
    [ 5,    "Modifier Tone Letters",    "A700-A71F" ],
    [ 6,    "Combining Diacritical Marks",  "0300-036F" ],
    [ 6,    "Combining Diacritical Marks Supplement",   "1DC0-1DFF" ],
    [ 7,    "Greek and Coptic",     "0370-03FF" ],
    [ 8,    "Coptic",   "2C80-2CFF" ],
    [ 9,    "Cyrillic",     "0400-04FF" ],
    [ 9,    "Cyrillic Supplement",  "0500-052F" ],
    [ 9,    "Cyrillic Extended-A",  "2DE0-2DFF" ],
    [ 9,    "Cyrillic Extended-B",  "A640-A69F" ],
    [ 10,   "Armenian",     "0530-058F" ],
    [ 11,   "Hebrew",   "0590-05FF" ],
    [ 12,   "Vai",  "A500-A63F" ],
    [ 13,   "Arabic",   "0600-06FF" ],
    [ 13,   "Arabic Supplement",    "0750-077F" ],
    [ 14,   "NKo",  "07C0-07FF" ],
    [ 15,   "Devanagari",   "0900-097F" ],
    [ 16,   "Bengali",  "0980-09FF" ],
    [ 17,   "Gurmukhi",     "0A00-0A7F" ],
    [ 18,   "Gujarati",     "0A80-0AFF" ],
    [ 19,   "Oriya",    "0B00-0B7F" ],
    [ 20,   "Tamil",    "0B80-0BFF" ],
    [ 21,   "Telugu",   "0C00-0C7F" ],
    [ 22,   "Kannada",  "0C80-0CFF" ],
    [ 23,   "Malayalam",    "0D00-0D7F" ],
    [ 24,   "Thai",     "0E00-0E7F" ],
    [ 25,   "Lao",  "0E80-0EFF" ],
    [ 26,   "Georgian",     "10A0-10FF" ],
    [ 26,   "Georgian Supplement",  "2D00-2D2F" ],
    [ 27,   "Balinese",     "1B00-1B7F" ],
    [ 28,   "Hangul Jamo",  "1100-11FF" ],
    [ 29,   "Latin Extended Additional",    "1E00-1EFF" ],
    [ 29,   "Latin Extended-C",     "2C60-2C7F" ],
    [ 29,   "Latin Extended-D",     "A720-A7FF" ],
    [ 30,   "Greek Extended",   "1F00-1FFF" ],
    [ 31,   "General Punctuation",  "2000-206F" ],
    [ 31,   "Supplemental Punctuation",     "2E00-2E7F" ],
    [ 32,   "Superscripts And Subscripts",  "2070-209F" ],
    [ 33,   "Currency Symbols",     "20A0-20CF" ],
    [ 34,   "Combining Diacritical Marks For Symbols",  "20D0-20FF" ],
    [ 35,   "Letterlike Symbols",   "2100-214F" ],
    [ 36,   "Number Forms",     "2150-218F" ],
    [ 37,   "Arrows",   "2190-21FF" ],
    [ 37,   "Supplemental Arrows-A",    "27F0-27FF" ],
    [ 37,   "Supplemental Arrows-B",    "2900-297F" ],
    [ 37,   "Miscellaneous Symbols and Arrows",     "2B00-2BFF" ],
    [ 38,   "Mathematical Operators",   "2200-22FF" ],
    [ 38,   "Supplemental Mathematical Operators",  "2A00-2AFF" ],
    [ 38,   "Miscellaneous Mathematical Symbols-A",     "27C0-27EF" ],
    [ 38,   "Miscellaneous Mathematical Symbols-B",     "2980-29FF" ],
    [ 39,   "Miscellaneous Technical",  "2300-23FF" ],
    [ 40,   "Control Pictures",     "2400-243F" ],
    [ 41,   "Optical Character Recognition",    "2440-245F" ],
    [ 42,   "Enclosed Alphanumerics",   "2460-24FF" ],
    [ 43,   "Box Drawing",  "2500-257F" ],
    [ 44,   "Block Elements",   "2580-259F" ],
    [ 45,   "Geometric Shapes",     "25A0-25FF" ],
    [ 46,   "Miscellaneous Symbols",    "2600-26FF" ],
    [ 47,   "Dingbats",     "2700-27BF" ],
    [ 48,   "CJK Symbols And Punctuation",  "3000-303F" ],
    [ 49,   "Hiragana",     "3040-309F" ],
    [ 50,   "Katakana",     "30A0-30FF" ],
    [ 50,   "Katakana Phonetic Extensions",     "31F0-31FF" ],
    [ 51,   "Bopomofo",     "3100-312F" ],
    [ 51,   "Bopomofo Extended",    "31A0-31BF" ],
    [ 52,   "Hangul Compatibility Jamo",    "3130-318F" ],
    [ 53,   "Phags-pa",     "A840-A87F" ],
    [ 54,   "Enclosed CJK Letters And Months",  "3200-32FF" ],
    [ 55,   "CJK Compatibility",    "3300-33FF" ],
    [ 56,   "Hangul Syllables",     "AC00-D7AF" ],
    [ 57,   "Non-Plane 0 * ",   "D800-DFFF" ],
    [ 58,   "Phoenician",   "10900-1091F" ],
    [ 59,   "CJK Unified Ideographs",   "4E00-9FFF" ],
    [ 59,   "CJK Radicals Supplement",  "2E80-2EFF" ],
    [ 59,   "Kangxi Radicals",  "2F00-2FDF" ],
    [ 59,   "Ideographic Description Characters",   "2FF0-2FFF" ],
    [ 59,   "CJK Unified Ideographs Extension A",   "3400-4DBF" ],
    [ 59,   "CJK Unified Ideographs Extension B",   "20000-2A6DF" ],
    [ 59,   "Kanbun",   "3190-319F" ],
    [ 60,   "Private Use Area (plane 0)",   "E000-F8FF" ],
    [ 61,   "CJK Strokes",  "31C0-31EF" ],
    [ 61,   "CJK Compatibility Ideographs",     "F900-FAFF" ],
    [ 61,   "CJK Compatibility Ideographs Supplement",  "2F800-2FA1F" ],
    [ 62,   "Alphabetic Presentation Forms",    "FB00-FB4F" ],
    [ 63,   "Arabic Presentation Forms-A",  "FB50-FDFF" ],
    [ 64,   "Combining Half Marks",     "FE20-FE2F" ],
    [ 65,   "Vertical Forms",   "FE10-FE1F" ],
    [ 65,   "CJK Compatibility Forms",  "FE30-FE4F" ],
    [ 66,   "Small Form Variants",  "FE50-FE6F" ],
    [ 67,   "Arabic Presentation Forms-B",  "FE70-FEFF" ],
    [ 68,   "Halfwidth And Fullwidth Forms",    "FF00-FFEF" ],
    [ 69,   "Specials",     "FFF0-FFFF" ],
    [ 70,   "Tibetan",  "0F00-0FFF" ],
    [ 71,   "Syriac",   "0700-074F" ],
    [ 72,   "Thaana",   "0780-07BF" ],
    [ 73,   "Sinhala",  "0D80-0DFF" ],
    [ 74,   "Myanmar",  "1000-109F" ],
    [ 75,   "Ethiopic",     "1200-137F" ],
    [ 75,   "Ethiopic Supplement",  "1380-139F" ],
    [ 75,   "Ethiopic Extended",    "2D80-2DDF" ],
    [ 76,   "Cherokee",     "13A0-13FF" ],
    [ 77,   "Unified Canadian Aboriginal Syllabics",    "1400-167F" ],
    [ 78,   "Ogham",    "1680-169F" ],
    [ 79,   "Runic",    "16A0-16FF" ],
    [ 80,   "Khmer",    "1780-17FF" ],
    [ 80,   "Khmer Symbols",    "19E0-19FF" ],
    [ 81,   "Mongolian",    "1800-18AF" ],
    [ 82,   "Braille Patterns",     "2800-28FF" ],
    [ 83,   "Yi Syllables",     "A000-A48F" ],
    [ 83,   "Yi Radicals",  "A490-A4CF" ],
    [ 84,   "Tagalog",  "1700-171F" ],
    [ 85,   "Hanunoo",  "1720-173F" ],
    [ 85,   "Buhid",    "1740-175F" ],
    [ 85,   "Tagbanwa",     "1760-177F" ],
    [ 85,   "Old Italic",   "10300-1032F" ],
    [ 86,   "Gothic",   "10330-1034F" ],
    [ 87,   "Deseret",  "10400-1044F" ],
    [ 88,   "Byzantine Musical Symbols",    "1D000-1D0FF" ],
    [ 88,   "Musical Symbols",  "1D100-1D1FF" ],
    [ 88,   "Ancient Greek Musical Notation",   "1D200-1D24F" ],
    [ 89,   "Mathematical Alphanumeric Symbols",    "1D400-1D7FF" ],
    [ 90,   "Private Use (plane 15)",   "FF000-FFFFD" ],
    [ 90,   "Private Use (plane 16)",   "100000-10FFFD" ],
    [ 91,   "Variation Selectors",  "FE00-FE0F" ],
    [ 91,   "Variation Selectors Supplement",   "E0100-E01EF" ],
    [ 92,   "Tags",     "E0000-E007F" ],
    [ 93,   "Limbu",    "1900-194F" ],
    [ 94,   "Tai Le",   "1950-197F" ],
    [ 95,   "New Tai Lue",  "1980-19DF" ],
    [ 96,   "Buginese",     "1A00-1A1F" ],
    [ 97,   "Glagolitic",   "2C00-2C5F" ],
    [ 98,   "Tifinagh",     "2D30-2D7F" ],
    [ 99,   "Yijing Hexagram Symbols",  "4DC0-4DFF" ],
    [ 100,  "Syloti Nagri",     "A800-A82F" ],
    [ 101,  "Linear B Syllabary",   "10000-1007F" ],
    [ 101,  "Linear B Ideograms",   "10080-100FF" ],
    [ 101,  "Aegean Numbers",   "10100-1013F" ],
    [ 102,  "Ancient Greek Numbers",    "10140-1018F" ],
    [ 103,  "Ugaritic",     "10380-1039F" ],
    [ 104,  "Old Persian",  "103A0-103DF" ],
    [ 105,  "Shavian",  "10450-1047F" ],
    [ 106,  "Osmanya",  "10480-104AF" ],
    [ 107,  "Cypriot Syllabary",    "10800-1083F" ],
    [ 108,  "Kharoshthi",   "10A00-10A5F" ],
    [ 109,  "Tai Xuan Jing Symbols",    "1D300-1D35F" ],
    [ 110,  "Cuneiform",    "12000-123FF" ],
    [ 110,  "Cuneiform Numbers and Punctuation",    "12400-1247F" ],
    [ 111,  "Counting Rod Numerals",    "1D360-1D37F" ],
    [ 112,  "Sundanese",    "1B80-1BBF" ],
    [ 113,  "Lepcha",   "1C00-1C4F" ],
    [ 114,  "Ol Chiki",     "1C50-1C7F" ],
    [ 115,  "Saurashtra",   "A880-A8DF" ],
    [ 116,  "Kayah Li",     "A900-A92F" ],
    [ 117,  "Rejang",   "A930-A95F" ],
    [ 118,  "Cham",     "AA00-AA5F" ],
    [ 119,  "Ancient Symbols",  "10190-101CF" ],
    [ 120,  "Phaistos Disc",    "101D0-101FF" ],
    [ 121,  "Carian",   "102A0-102DF" ],
    [ 121,  "Lycian",   "10280-1029F" ],
    [ 121,  "Lydian",   "10920-1093F" ],
    [ 122,  "Domino Tiles",     "1F030-1F09F" ],
    [ 122,  "Mahjong Tiles",    "1F000-1F02F" ],
    [ 123-127,  "Reserved",     "" ],
);

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

