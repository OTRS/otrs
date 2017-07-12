package PDF::API2::Content;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
no warnings qw( deprecated recursion uninitialized );

our $VERSION = '2.033'; # VERSION

use Carp;
use Compress::Zlib qw();
use Encode;
use Math::Trig;
use PDF::API2::Matrix;

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

=head1 NAME

PDF::API2::Content - Methods for adding graphics and text to a PDF

=head1 SYNOPSIS

    # Start with a PDF page (new or opened)
    my $pdf = PDF::API2->new();
    my $page = $pdf->page();

    # Add a new content object
    my $content = $page->gfx();
    my $content = $page->text();

    # Then call the methods below add graphics and text to the page.

=head1 METHODS

=cut

sub new {
    my ($class)=@_;
    my $self = $class->SUPER::new(@_);
    $self->{' stream'}='';
    $self->{' poststream'}='';
    $self->{' font'}=undef;
    $self->{' fontset'}=0;
    $self->{' fontsize'}=0;
    $self->{' charspace'}=0;
    $self->{' hscale'}=100;
    $self->{' wordspace'}=0;
    $self->{' lead'}=0;
    $self->{' rise'}=0;
    $self->{' render'}=0;
    $self->{' matrix'}=[1,0,0,1,0,0];
    $self->{' textmatrix'}=[1,0,0,1,0,0];
    $self->{' textlinematrix'}=[0,0];
    $self->{' fillcolor'}=[0];
    $self->{' strokecolor'}=[0];
    $self->{' translate'}=[0,0];
    $self->{' scale'}=[1,1];
    $self->{' skew'}=[0,0];
    $self->{' rotate'}=0;
    $self->{' apiistext'}=0;
    return $self;
}

sub outobjdeep {
    my $self = shift @_;
    $self->textend;
    foreach my $k (qw[ api apipdf apiistext apipage font fontset fontsize
                       charspace hscale wordspace lead rise render matrix
                       textmatrix textlinematrix fillcolor strokecolor
                       translate scale skew rotate ]) {
        $self->{" $k"}=undef;
        delete($self->{" $k"});
    }
    if ($self->{-docompress}==1 && $self->{Filter}) {
        $self->{' stream'}=Compress::Zlib::compress($self->{' stream'});
        $self->{' nofilt'}=1;
        delete $self->{-docompress};
    }
    $self->SUPER::outobjdeep(@_);
}

=head2 Coordinate Transformations

The methods in this section change the coordinate system for the
current content object relative to the rest of the document.

If you call more than one of these methods, the PDF specification
recommends calling them in the following order: translate, rotate,
scale, skew.  Each change builds on the last, and you can get
unexpected results when calling them in a different order.

=over

=item $content->translate($x, $y)

Moves the origin along the x and y axes.

=cut

sub _translate {
    my ($x,$y)=@_;
    return(1,0,0,1,$x,$y);
}

sub translate {
    my ($self,$x,$y)=@_;
    $self->transform(-translate=>[$x,$y]);
}

=item $content->rotate($degrees)

Rotates the coordinate system counter-clockwise.

Use a negative argument to rotate clockwise.

=cut

sub _rotate {
    my ($a)=@_;
    return (cos(deg2rad($a)), sin(deg2rad($a)),-sin(deg2rad($a)), cos(deg2rad($a)),0,0);
}

sub rotate {
    my ($self,$a)=@_;
    $self->transform(-rotate=>$a);
}

=item $content->scale($sx, $sy)

Scales (stretches) the coordinate systems along the x and y axes.

=cut

sub _scale {
    my ($x,$y)=@_;
    return ($x,0,0,$y,0,0);
}

sub scale {
    my ($self,$sx,$sy)=@_;
    $self->transform(-scale=>[$sx,$sy]);
}

=item $content->skew($sa, $sb)

Skews the coordinate system by C<$sa> degrees (counter-clockwise) from
the x axis and C<$sb> degrees (clockwise) from the y axis.

=cut

sub _skew {
    my ($a,$b)=@_;
    return (1, tan(deg2rad($a)),tan(deg2rad($b)),1,0,0);
}

sub skew {
    my ($self,$a,$b)=@_;
    $self->transform(-skew=>[$a,$b]);
}

=item $content->transform(%options)

    $content->transform(
        -translate => [$x, $y],
        -rotate    => $degrees,
        -scale     => [$sx, $sy],
        -skew      => [$sa, $sb],
    )

Performs multiple coordinate transformations at once, in the order
recommended by the PDF specification (translate, rotate, scale, then
skew).

This is equivalent to making each transformation separately.

=cut

sub _transform {
    my (%opt)=@_;
    my $mtx=PDF::API2::Matrix->new([1,0,0],[0,1,0],[0,0,1]);
    foreach my $o (qw( -matrix -skew -scale -rotate -translate )) {
        next unless(defined($opt{$o}));
        if ($o eq '-translate') {
            my @mx=_translate(@{$opt{$o}});
            $mtx=$mtx->multiply(PDF::API2::Matrix->new(
                [$mx[0],$mx[1],0],
                [$mx[2],$mx[3],0],
                [$mx[4],$mx[5],1]
            ));
        }
        elsif ($o eq '-rotate') {
            my @mx=_rotate($opt{$o});
            $mtx=$mtx->multiply(PDF::API2::Matrix->new(
                [$mx[0],$mx[1],0],
                [$mx[2],$mx[3],0],
                [$mx[4],$mx[5],1]
            ));
        }
        elsif ($o eq '-scale') {
            my @mx=_scale(@{$opt{$o}});
            $mtx=$mtx->multiply(PDF::API2::Matrix->new(
                [$mx[0],$mx[1],0],
                [$mx[2],$mx[3],0],
                [$mx[4],$mx[5],1]
            ));
        }
        elsif ($o eq '-skew') {
            my @mx=_skew(@{$opt{$o}});
            $mtx=$mtx->multiply(PDF::API2::Matrix->new(
                [$mx[0],$mx[1],0],
                [$mx[2],$mx[3],0],
                [$mx[4],$mx[5],1]
            ));
        }
        elsif ($o eq '-matrix') {
            my @mx=@{$opt{$o}};
            $mtx=$mtx->multiply(PDF::API2::Matrix->new(
                [$mx[0],$mx[1],0],
                [$mx[2],$mx[3],0],
                [$mx[4],$mx[5],1]
            ));
        }
    }
    if ($opt{-point}) {
        my $mp=PDF::API2::Matrix->new([$opt{-point}->[0],$opt{-point}->[1],1]);
        $mp=$mp->multiply($mtx);
        return($mp->[0][0],$mp->[0][1]);
    }
    return (
        $mtx->[0][0],$mtx->[0][1],
        $mtx->[1][0],$mtx->[1][1],
        $mtx->[2][0],$mtx->[2][1]
    );
}

sub transform {
    my ($self,%opt)=@_;
    $self->matrix(_transform(%opt));
    if ($opt{-translate}) {
        @{$self->{' translate'}}=@{$opt{-translate}};
    }
    else {
        @{$self->{' translate'}}=(0,0);
    }
    if ($opt{-rotate}) {
        $self->{' rotate'}=$opt{-rotate};
    }
    else {
        $self->{' rotate'}=0;
    }
    if ($opt{-scale}) {
        @{$self->{' scale'}}=@{$opt{-scale}};
    }
    else {
        @{$self->{' scale'}}=(1,1);
    }
    if ($opt{-skew}) {
        @{$self->{' skew'}}=@{$opt{-skew}};
    }
    else {
        @{$self->{' skew'}}=(0,0);
    }
    return $self;
}

=item $content->transform_rel(%options)

Makes transformations similarly to C<transform>, except that it adds
to the previously set values.

=cut

sub transform_rel {
    my ($self,%opt)=@_;
    my ($sa1,$sb1)=@{$opt{-skew} ? $opt{-skew} : [0,0]};
    my ($sa0,$sb0)=@{$self->{" skew"}};

    my ($sx1,$sy1)=@{$opt{-scale} ? $opt{-scale} : [1,1]};
    my ($sx0,$sy0)=@{$self->{" scale"}};

    my $rot1=$opt{"-rotate"} || 0;
    my $rot0=$self->{" rotate"};

    my ($tx1,$ty1)=@{$opt{-translate} ? $opt{-translate} : [0,0]};
    my ($tx0,$ty0)=@{$self->{" translate"}};

    $self->transform(
        -skew=>[$sa0+$sa1,$sb0+$sb1],
        -scale=>[$sx0*$sx1,$sy0*$sy1],
        -rotate=>$rot0+$rot1,
        -translate=>[$tx0+$tx1,$ty0+$ty1],
    );
    return $self;
}

=item $content->matrix($a, $b, $c, $d, $e, $f)

(Advanced) Sets the current transformation matrix manually.  Unless
you have a particular need to enter transformations manually, you
should use the C<transform> method instead.

=cut

sub _matrix_text {
    my ($a,$b,$c,$d,$e,$f)=@_;
    return (floats($a,$b,$c,$d,$e,$f),'Tm');
}

sub _matrix_gfx {
    my ($a,$b,$c,$d,$e,$f)=@_;
    return (floats($a,$b,$c,$d,$e,$f),'cm');
}

sub matrix {
    my $self=shift @_;
    my ($a,$b,$c,$d,$e,$f)=@_;
    if (defined $a) {
        if ($self->_in_text_object()) {
            $self->add(_matrix_text($a,$b,$c,$d,$e,$f));
            @{$self->{' textmatrix'}}=($a,$b,$c,$d,$e,$f);
            @{$self->{' textlinematrix'}}=(0,0);
        }
        else {
            $self->add(_matrix_gfx($a,$b,$c,$d,$e,$f));
        }
    }
    if ($self->_in_text_object()) {
        return @{$self->{' textmatrix'}};
    }
    else {
        return $self;
    }
}

sub matrix_update {
    my ($self,$tx,$ty)=@_;
    $self->{' textlinematrix'}->[0]+=$tx;
    $self->{' textlinematrix'}->[1]+=$ty;
    return $self;
}

=back

=head2 Graphics State Parameters

=over

=item $content->save

Saves the current graphics state and text state on a stack.

=cut

sub _save {
    return 'q';
}

sub save {
    my $self = shift;
    unless ($self->_in_text_object()) {
        $self->add(_save());
    }
}

=item $content->restore

Restores the most recently saved graphics state and text state,
removing it from the stack.

=cut

sub _restore {
    return 'Q';
}

sub restore {
    my $self = shift;
    unless ($self->_in_text_object()) {
        $self->add(_restore());
    }
}

=item $content->linewidth($width)

Sets the width of the stroke.

=cut

sub _linewidth {
    my ($linewidth)=@_;
    return ($linewidth, 'w');
}
sub linewidth {
    my ($this,$linewidth)=@_;
    $this->add(_linewidth($linewidth));
}

=item $content->linecap($style)

Sets the style to be used at the end of a stroke.

=over

=item 0 = Butt Cap

The stroke ends at the end of the path, with no projection.

=item 1 = Round Cap

An arc is drawn around the end of the path with a diameter equal to
the line width, and is filled in.

=item 2 = Projecting Square Cap

The stroke continues past the end of the path for half the line width.

=back

=cut

sub _linecap {
    my ($linecap)=@_;
    return ($linecap, 'J');
}

sub linecap {
    my ($self,$linecap)=@_;
    $self->add(_linecap($linecap));
}

=item $content->linejoin($style)

Sets the style of join to be used at corners of a path.

=over

=item 0 = Miter Join

The outer edges of the stroke extend until they meet, up to the limit
specified below.  If the limit would be surpassed, a bevel join is
used instead.

=item 1 = Round Join

A circle with a diameter equal to the linewidth is drawn around the
corner point, producing a rounded corner.

=item 2 = Bevel Join

A triangle is drawn to fill in the notch between the two strokes.

=back

=cut

sub _linejoin {
    my ($linejoin)=@_;
    return ($linejoin, 'j');
}
sub linejoin {
    my ($this,$linejoin)=@_;
    $this->add(_linejoin($linejoin));
}

=item $content->miterlimit($ratio)

Sets the miter limit when the line join style is a miter join.

The C<$ratio> is the maximum length of the miter (inner to outer
corner) divided by the line width. Any miter above this ratio will be
converted to a bevel join. The practical effect is that lines meeting
at shallow angles are chopped off instead of producing long pointed
corners.

There is no documented default miter limit.

=cut

sub miterlimit {
    my ($self, $limit) = @_;
    $self->add(_miterlimit($limit));
}

sub _miterlimit {
    my ($limit) = @_;
    return ($limit, 'M');
}

# Deprecated: miterlimit was originally named incorrectly
sub  meterlimit { return  miterlimit(@_) }
sub _meterlimit { return _miterlimit(@_) }

=item $content->linedash()

=item $content->linedash($length)

=item $content->linedash($dash_length, $gap_length, ...)

=item $content->linedash(-pattern => [$dash_length, $gap_length, ...], -shift => $offset)

Sets the line dash pattern.

If called without any arguments, a solid line will be drawn.

If called with one argument, the dashes and gaps will have equal
lengths.

If called with two or more arguments, the arguments represent
alternating dash and gap lengths.

If called with a hash of arguments, a dash phase may be set, which
specifies the distance into the pattern at which to start the dash.

=cut

sub _linedash {
    my @a = @_;
    unless (scalar @a) {
        return ('[', ']', '0', 'd');
    }
    else {
        if ($a[0] =~ /^\-/) {
            my %a = @a;

            # Deprecated: the -full and -clear options will be removed in a future release
            $a{'-pattern'} = [$a{'-full'} || 0, $a{'-clear'} || 0] unless exists $a{'-pattern'};

            return ('[', floats(@{$a{'-pattern'}}), ']', ($a{'-shift'} || 0), 'd');
        }
        else {
            return ('[', floats(@a), '] 0 d');
        }
    }
}

sub linedash {
    my ($self,@a)=@_;
    $self->add(_linedash(@a));
}

=item $content->flatness($tolerance)

(Advanced) Sets the maximum variation in output pixels when drawing
curves.

=cut

sub _flatness {
    my ($flatness)=@_;
    return ($flatness, 'i');
}

sub flatness {
    my ($self,$flatness)=@_;
    $self->add(_flatness($flatness));
}

=item $content->egstate($object)

(Advanced) Adds an Extended Graphic State object containing additional
state parameters.

=cut

sub egstate {
    my $self = shift;
    my $egs = shift;
    $self->add('/'.$egs->name,'gs');
    $self->resource('ExtGState',$egs->name,$egs);
    return $self;
}

=back

=head2 Path Construction (Drawing)

=over

=item $content->move($x, $y)

Starts a new path at the specified coordinates.

=cut

sub _move {
    my($x,$y)=@_;
    return (floats($x,$y), 'm');
}
sub move {
    my $self=shift @_;
    my ($x,$y);
    while(defined($x = shift)) {
        $y = shift;
        $self->{' x'}=$x;
        $self->{' y'}=$y;
        $self->{' mx'}=$x;
        $self->{' my'}=$y;
        if ($self->_in_text_object()) {
            $self->add_post(floats($x,$y), 'm');
        }
        else {
            $self->add(floats($x,$y), 'm');
        }
    }
    return $self;
}

=item $content->line($x, $y)

Extends the path in a line from the current coordinates to the
specified coordinates, and updates the current position to be the new
coordinates.

Note: The line will not appear until you call C<stroke>.

=cut

sub _line {
    my ($x,$y) = @_;
    return (floats($x,$y), 'l');
}

sub line {
    my $self = shift;
    my ($x,$y);
    while(defined($x = shift)) {
        $y = shift;
        $self->{' x'}=$x;
        $self->{' y'}=$y;
        if ($self->_in_text_object()) {
            $self->add_post(floats($x,$y), 'l');
        }
        else {
            $self->add(floats($x,$y), 'l');
        }
    }
    return $self;
}

=item $content->hline($x)

=item $content->vline($y)

Shortcut for drawing horizontal and vertical lines from the current
position.

=cut

sub hline {
    my ($self, $x) = @_;
    if ($self->_in_text_object()) {
        $self->add_post(floats($x,$self->{' y'}),'l');
    }
    else {
        $self->add(floats($x,$self->{' y'}),'l');
    }
    $self->{' x'}=$x;
    return $self;
}

sub vline {
    my ($self, $y) = @_;
    if ($self->_in_text_object()) {
        $self->add_post(floats($self->{' x'},$y),'l');
    }
    else {
        $self->add(floats($self->{' x'},$y),'l');
    }
    $self->{' y'}=$y;
    return $self;
}

=item $content->poly($x1, $y1, ..., $xn, $yn)

Shortcut for creating a polyline path.  Moves to C<[$x1, $y1]>, and
then extends the path in lines along the specified coordinates.

=cut

sub poly {
    my $self = shift;
    my $x = shift;
    my $y = shift;
    $self->move($x,$y);
    $self->line(@_);
    return $self;
}

=item $content->curve($cx1, $cy1, $cx2, $cy2, $x, $y)

Extends the path in a curve from the current point to C<($x, $y)>,
using the two specified points to create a cubic Bezier curve, and
updates the current position to be the new point.

Note: The curve will not appear until you call C<stroke>.

=cut

sub curve {
    my $self = shift;
    my($x1,$y1,$x2,$y2,$x3,$y3);
    while (defined($x1 = shift)) {
        $y1 = shift;
        $x2 = shift;
        $y2 = shift;
        $x3 = shift;
        $y3 = shift;
        if ($self->_in_text_object()) {
            $self->add_post(floats($x1,$y1,$x2,$y2,$x3,$y3),'c');
        }
        else {
            $self->add(floats($x1,$y1,$x2,$y2,$x3,$y3),'c');
        }
        $self->{' x'}=$x3;
        $self->{' y'}=$y3;
    }
    return $self;
}

=item $content->spline($cx1, $cy1, $x, $y)

Extends the path in a curve from the current point to C<($x, $y)>,
using the two specified points to create a spline, and updates the
current position to be the new point.

Note: The curve will not appear until you call C<stroke>.

=cut

sub spline {
    my $self = shift;

    while(scalar @_ >= 4) {
        my $cx = shift;
        my $cy = shift;
        my $x = shift;
        my $y = shift;
        my $c1x = (2*$cx+$self->{' x'})/3;
        my $c1y = (2*$cy+$self->{' y'})/3;
        my $c2x = (2*$cx+$x)/3;
        my $c2y = (2*$cy+$y)/3;
        $self->curve($c1x,$c1y,$c2x,$c2y,$x,$y);
    }
}

=item $content->arc($x, $y, $a, $b, $alpha, $beta, $move)

Extends the path along an arc of an ellipse centered at C<[x, y]>.
The major and minor axes of the ellipse are C<$a> and C<$b>,
respectively, and the arc moves from C<$alpha> degrees to C<$beta>
degrees.  The current position is then set to the endpoint of the arc.

Set C<$move> to a true value if this arc is the beginning of a new
path instead of the continuation of an existing path.

=cut

# Private
sub arctocurve {
    my ($a,$b,$alpha,$beta) = @_;
    if (abs($beta-$alpha) > 30) {
        return (
            arctocurve($a,$b,$alpha,($beta+$alpha)/2),
            arctocurve($a,$b,($beta+$alpha)/2,$beta)
        );
    }
    else {
        $alpha = ($alpha * pi / 180);
        $beta  = ($beta * pi / 180);

        my $bcp = (4.0/3 * (1 - cos(($beta - $alpha)/2)) / sin(($beta - $alpha)/2));
        my $sin_alpha = sin($alpha);
        my $sin_beta =  sin($beta);
        my $cos_alpha = cos($alpha);
        my $cos_beta =  cos($beta);

        my $p0_x = $a * $cos_alpha;
        my $p0_y = $b * $sin_alpha;
        my $p1_x = $a * ($cos_alpha - $bcp * $sin_alpha);
        my $p1_y = $b * ($sin_alpha + $bcp * $cos_alpha);
        my $p2_x = $a * ($cos_beta + $bcp * $sin_beta);
        my $p2_y = $b * ($sin_beta - $bcp * $cos_beta);
        my $p3_x = $a * $cos_beta;
        my $p3_y = $b * $sin_beta;

        return ($p0_x,$p0_y,$p1_x,$p1_y,$p2_x,$p2_y,$p3_x,$p3_y);
    }
}

sub arc {
    my ($self,$x,$y,$a,$b,$alpha,$beta,$move) = @_;
    my @points = arctocurve($a,$b,$alpha,$beta);
    my ($p0_x,$p0_y,$p1_x,$p1_y,$p2_x,$p2_y,$p3_x,$p3_y);

    $p0_x= $x + shift @points;
    $p0_y= $y + shift @points;

    $self->move($p0_x,$p0_y) if($move);

    while (scalar @points > 0) {
        $p1_x = $x + shift @points;
        $p1_y = $y + shift @points;
        $p2_x = $x + shift @points;
        $p2_y = $y + shift @points;
        $p3_x = $x + shift @points;
        $p3_y = $y + shift @points;
        $self->curve($p1_x,$p1_y,$p2_x,$p2_y,$p3_x,$p3_y);
        shift @points;
        shift @points;
        $self->{' x'}=$p3_x;
        $self->{' y'}=$p3_y;
    }
    return $self;
}

=item $content->bogen($x1, $y1, $x2, $y2, $radius, $move, $outer, $reverse)

Extends the path along an arc of a circle of the specified radius
between C<[x1, y1]> to C<[x2, y2]>.  The current position is then set
to the endpoint of the arc.

Set C<$move> to a true value if this arc is the beginning of a new
path instead of the continuation of an existing path.

Set C<$outer> to a true value to draw the larger arc between the two
points instead of the smaller one.

Set C<$reverse> to a true value to draw the mirror image of the
specified arc.

C<$radius * 2> cannot be smaller than the distance from C<[x1, y1]> to
C<[x2, y2]>.

Note: The curve will not appear until you call C<stroke>.

=cut

sub bogen {
    my ($self,$x1,$y1,$x2,$y2,$r,$move,$larc,$spf) = @_;
    my ($p0_x,$p0_y,$p1_x,$p1_y,$p2_x,$p2_y,$p3_x,$p3_y);
    my $x = $x2-$x1;
    my $y = $y2-$y1;
    my $z = sqrt($x**2+$y**2);
    my $alpha_rad = asin($y/$z);

    $alpha_rad+=pi/2 if($x<0 and $y>0);
    $alpha_rad-=pi/2 if($x<0 and $y<0);

    my $alpha=rad2deg($alpha_rad);
    # use the complement angle for span
    $alpha -= 180 if($spf>0);

    my $d=2*$r;
    my ($beta,$beta_rad,@points);

    $beta=rad2deg(2*asin($z/$d));
    $beta=360-$beta if($larc>0);

    $beta_rad=deg2rad($beta);

    @points=arctocurve($r,$r,90+$alpha+$beta/2,90+$alpha-$beta/2);

    if ($spf>0) {
        my @pts=@points;
        @points=();
        while ($y=pop @pts) {
            $x=pop @pts;
            push(@points,$x,$y);
        }
    }

    $p0_x=shift @points;
    $p0_y=shift @points;
    $x=$x1-$p0_x;
    $y=$y1-$p0_y;

    $self->move($x1,$y1) if($move);

    while(scalar @points > 0) {
        $p1_x= $x + shift @points;
        $p1_y= $y + shift @points;
        $p2_x= $x + shift @points;
        $p2_y= $y + shift @points;
        # if we run out of data points, use the end point instead
        if (scalar @points == 0) {
            $p3_x = $x2;
            $p3_y = $y2;
        }
        else {
            $p3_x= $x + shift @points;
            $p3_y= $y + shift @points;
        }
        $self->curve($p1_x,$p1_y,$p2_x,$p2_y,$p3_x,$p3_y);
        shift @points;
        shift @points;
    }
    return $self;
}

=item $content->close

Closes and ends the current path by extending a line from the current
position to the starting position.

=cut

sub close {
    my $self = shift;
    $self->add('h');
    $self->{' x'}=$self->{' mx'};
    $self->{' y'}=$self->{' my'};
    return $self;
}

=item $content->endpath

Ends the current path without explicitly enclosing it.

=cut

sub endpath {
    my $self = shift;
    $self->add('n');
    return $self;
}

=item $content->ellipse($x, $y, $a, $b)

Creates an elliptical path centered on C<[$x, $y]>, with major and
minor axes specified by C<$a> and C<$b>, respectively.

Note: The ellipse will not appear until you call C<stroke> or C<fill>.

=cut

sub ellipse {
    my ($self,$x,$y,$a,$b) = @_;
    $self->arc($x,$y,$a,$b,0,360,1);
    $self->close;
    return $self;
}

=item $content->circle($x, $y, $radius)

Creates a circular path centered on C<[$x, $y]> with the specified
radius.

Note: The circle will not appear until you call C<stroke> or C<fill>.

=cut

sub circle {
    my ($self,$x,$y,$r) = @_;
    $self->arc($x,$y,$r,$r,0,360,1);
    $self->close;
    return $self;
}

=item $content->pie($x, $y, $a, $b, $alpha, $beta)

Creates a pie-shaped path from an ellipse centered on C<[$x, $y]>.
The major and minor axes of the ellipse are C<$a> and C<$b>,
respectively, and the arc moves from C<$alpha> degrees to C<$beta>
degrees.

Note: The pie will not appear until you call C<stroke> or C<fill>.

=cut

sub pie {
    my $self = shift;
    my ($x,$y,$a,$b,$alpha,$beta)=@_;
    my ($p0_x,$p0_y)=arctocurve($a,$b,$alpha,$beta);
    $self->move($x,$y);
    $self->line($p0_x+$x,$p0_y+$y);
    $self->arc($x,$y,$a,$b,$alpha,$beta);
    $self->close;
}

=item $content->rect($x1, $y1, $w1, $h1, ..., $xn, $yn, $wn, $hn)

Creates paths for one or more rectangles, with their lower left points
at C<[$x, $y]> and with the specified widths and heights.

Note: The rectangle will not appear until you call C<stroke> or C<fill>.

=cut

sub rect {
    my $self = shift;
    my ($x,$y,$w,$h);
    while (defined($x = shift)) {
        $y = shift;
        $w = shift;
        $h = shift;
        $self->add(floats($x,$y,$w,$h),'re');
    }
    $self->{' x'}=$x;
    $self->{' y'}=$y;
    return $self;
}

=item $content->rectxy($x1, $y1, $x2, $y2)

Creates a rectangular path, with C<[$x1, $y1]> and and C<[$x2, $y2]>
specifying opposite corners.

Note: The rectangle will not appear until you call C<stroke> or C<fill>.

=cut

sub rectxy {
    my ($self,$x,$y,$x2,$y2)=@_;
    $self->rect($x,$y,($x2-$x),($y2-$y));
    return $self;
}

=back

=head2 Path Painting (Drawing)

=over

=item $content->stroke

Strokes the current path.

=cut

sub _stroke {
    return 'S';
}

sub stroke {
    my $self = shift;
    $self->add(_stroke);
    return $self;
}

=item $content->fill($use_even_odd_fill)

Fills the current path.

If the path intersects with itself, the nonzero winding rule will be
used to determine which part of the path is filled in.  If you would
prefer to use the even-odd rule, pass a true argument.

See the PDF Specification, section 8.5.3.3, for more details on
filling.

=cut

sub fill {
    my $self = shift;
    $self->add(shift() ? 'f*' : 'f');
    return $self;
}

=item $content->fillstroke($use_even_odd_fill)

Fills and then strokes the current path.

=cut

sub fillstroke {
    my $self = shift;
    $self->add(shift() ? 'B*' : 'B');
    return $self;
}

=item $content->clip($use_even_odd_fill)

Modifies the current clipping path by intersecting it with the current
path.

=cut

sub clip {
    my $self = shift;
    $self->add(shift() ? 'W*' : 'W');
    return $self;
}

=back

=head2 Colors

=over

=item $content->fillcolor($color)

=item $content->strokecolor($color)

Sets the fill or stroke color.

    # Use a named color
    $content->fillcolor('blue');

    # Use an RGB color (start with '#')
    $content->fillcolor('#FF0000');

    # Use a CMYK color (start with '%')
    $content->fillcolor('%FF000000');

RGB and CMYK colors can have one-byte, two-byte, three-byte, or
four-byte values for each color.  For instance, cyan can be given as
C<%F000> or C<%FFFF000000000000>.

=cut

# default colorspaces: rgb/hsv/named cmyk/hsl lab
#   ... only one text string
#
# pattern or shading space
#   ... only one object
#
# legacy greylevel
#   ... only one value
#
#

sub _makecolor {
    my ($self, $sf, @clr) = @_;

    if ($clr[0] =~ /^[a-z\#\!]+/) {
        # colorname or #! specifier
        # with rgb target colorspace
        # namecolor returns always a RGB
        return namecolor($clr[0]), ($sf ? 'rg' : 'RG');
    }
    elsif ($clr[0] =~ /^[\%]+/) {
        # % specifier
        # with cmyk target colorspace
        return namecolor_cmyk($clr[0]), ($sf ? 'k' : 'K');
    }
    elsif ($clr[0] =~ /^[\$\&]/) {
        # &$ specifier
        # with L*a*b target colorspace
        if (!defined $self->resource('ColorSpace', 'LabS')) {
            my $dc = PDFDict();
            my $cs = PDFArray(PDFName('Lab'), $dc);
            $dc->{'WhitePoint'} = PDFArray(map { PDFNum($_) } qw(1 1 1));
            $dc->{'Range'} = PDFArray(map { PDFNum($_) } qw(-128 127 -128 127));
            $dc->{'Gamma'} = PDFArray(map { PDFNum($_) } qw(2.2 2.2 2.2));
            $self->resource('ColorSpace', 'LabS', $cs);
        }
        return '/LabS', ($sf ? 'cs' : 'CS'), namecolor_lab($clr[0]), ($sf ? 'sc' : 'SC');
    }
    elsif (scalar @clr == 1 and ref($clr[0])) {
        # pattern or shading space
        return '/Pattern', ($sf ? 'cs' : 'CS'), '/' . ($clr[0]->name()), ($sf ? 'scn' : 'SCN');
    }
    elsif (scalar @clr == 1) {
        # grey color spec.
        return $clr[0], $sf ? 'g' : 'G';
    }
    elsif (scalar @clr > 1 and ref($clr[0])) {
        # indexed colorspace plus color-index
        # or custom colorspace plus param
        my $cs = shift(@clr);
        return '/' . $cs->name(), ($sf ? 'cs' : 'CS'), $cs->param(@clr), ($sf ? 'sc' : 'SC');
    }
    elsif (scalar @clr == 2) {
        # indexed colorspace plus color-index
        # or custom colorspace plus param
        return '/' . $clr[0]->name(), ($sf ? 'cs' : 'CS'), $clr[0]->param($clr[1]), ($sf ? 'sc' : 'SC');
    }
    elsif (scalar @clr == 3) {
        # legacy rgb color-spec (0 <= x <= 1)
        return floats($clr[0], $clr[1], $clr[2]), ($sf ? 'rg' : 'RG');
    }
    elsif (scalar @clr == 4) {
        # legacy cmyk color-spec (0 <= x <= 1)
        return floats($clr[0], $clr[1], $clr[2], $clr[3]), ($sf ? 'k' : 'K');
    }
    else {
        die 'invalid color specification.';
    }
}

sub _fillcolor {
    my ($self,@clrs)=@_;
    if (ref($clrs[0]) =~ m|^PDF::API2::Resource::ColorSpace|) {
        $self->resource('ColorSpace',$clrs[0]->name,$clrs[0]);
    }
    elsif (ref($clrs[0]) =~ m|^PDF::API2::Resource::Pattern|) {
        $self->resource('Pattern',$clrs[0]->name,$clrs[0]);
    }

    return $self->_makecolor(1,@clrs);
}

sub fillcolor {
    my $self = shift;
    if (scalar @_) {
        @{$self->{' fillcolor'}}=@_;
        $self->add($self->_fillcolor(@_));
    }
    return @{$self->{' fillcolor'}};
}

sub _strokecolor {
    my ($self,@clrs)=@_;
    if (ref($clrs[0]) =~ m|^PDF::API2::Resource::ColorSpace|) {
        $self->resource('ColorSpace',$clrs[0]->name,$clrs[0]);
    }
    elsif (ref($clrs[0]) =~ m|^PDF::API2::Resource::Pattern|) {
        $self->resource('Pattern',$clrs[0]->name,$clrs[0]);
    }
    return $self->_makecolor(0,@clrs);
}

sub strokecolor {
    my $self = shift;
    if (scalar @_) {
        @{$self->{' strokecolor'}}=@_;
        $self->add($self->_strokecolor(@_));
    }
    return @{$self->{' strokecolor'}};
}


sub shade {
    my $self = shift;
    my $shade = shift;
    my @cord = @_;
    my @tm = (
        $cord[2]-$cord[0] , 0,
        0                 , $cord[3]-$cord[1],
        $cord[0]          , $cord[1]
    );
    $self->save;
    $self->matrix(@tm);
    $self->add('/'.$shade->name,'sh');

    $self->resource('Shading',$shade->name,$shade);

    $self->restore;
    return $self;
}

=back

=head2 External Objects

=over

=item $content->image($image_object, $x, $y, $width, $height)

=item $content->image($image_object, $x, $y, $scale)

=item $content->image($image_object, $x, $y)

    # Example
    my $image_object = $pdf->image_jpeg($my_image_file);
    $content->image($image_object, 100, 200);

Places an image on the page in the specified location.

If coordinate transformations have been made (see Coordinate
Transformations above), the position and scale will be relative to the
updated coordinates.  Otherwise, [0,0] will represent the bottom left
corner of the page, and C<$width> and C<$height> will be measured at
72dpi.

For example, if you have a 600x600 image that you would like to be
shown at 600dpi (i.e. one inch square), set the width and height to 72.

=cut

sub image {
    my $self = shift;
    my $img = shift;
    my ($x,$y,$w,$h) = @_;
    if (defined $img->{Metadata}) {
        $self->metaStart('PPAM:PlacedImage',$img->{Metadata});
    }
    $self->save;
    if (!defined $w) {
        $h=$img->height;
        $w=$img->width;
    }
    elsif (!defined $h) {
        $h=$img->height*$w;
        $w=$img->width*$w;
    }
    $self->matrix($w,0,0,$h,$x,$y);
    $self->add("/".$img->name,'Do');
    $self->restore;
    $self->{' x'}=$x;
    $self->{' y'}=$y;
    $self->resource('XObject',$img->name,$img);
    if(defined $img->{Metadata}) {
        $self->metaEnd;
    }
    return $self;
}

=item $content->formimage($form_object, $x, $y, $scale)

=item $content->formimage($form_object, $x, $y)

Places an XObject on the page in the specified location.

=cut

sub formimage {
    my $self = shift;
    my $img = shift;
    my ($x,$y,$s) = @_;
    $self->save;
    if (!defined $s) {
        $self->matrix(1,0,0,1,$x,$y);
    }
    else {
        $self->matrix($s,0,0,$s,$x,$y);
    }
    $self->add('/'.$img->name,'Do');
    $self->restore;
    $self->resource('XObject',$img->name,$img);
    return $self;
}

=back

=head2 Text State Parameters

All of the following parameters that take a size are applied before
any scaling takes place, so you don't need to adjust values to
counteract scaling.

=over

=item $spacing = $content->charspace($spacing)

Sets the spacing between characters.  This is initially zero.

=cut

sub _charspace {
    my ($para) = @_;
    return float($para, 6) . ' Tc';
}
sub charspace {
    my ($self, $para) = @_;
    if (defined $para) {
        $self->{' charspace'}=$para;
        $self->add(_charspace($para));
    }
    return $self->{' charspace'};
}

=item $spacing = $content->wordspace($spacing)

Sets the spacing between words.  This is initially zero (or, in other
words, just the width of the space).

Word spacing might only affect simple fonts and composite fonts where
the space character is a single-byte code.  This is a limitation of
the PDF specification at least as of version 1.7 (see section 9.3.3).
It's possible that a later version of the specification will support
word spacing in fonts that use multi-byte codes.

=cut

sub _wordspace {
    my ($para) = @_;
    return float($para, 6) . ' Tw';
}

sub wordspace {
    my ($self, $para) = @_;
    if (defined $para) {
        $self->{' wordspace'}=$para;
        $self->add(_wordspace($para));
    }
    return $self->{' wordspace'};
}

=item $scale = $content->hscale($scale)

Sets and returns the percentage of horizontal text scaling.  Enter a
scale greater than 100 to stretch text, less than 100 to squeeze
text, or 100 to disable any existing scaling.

=cut

sub _hscale {
    my ($scale) = @_;
    return float($scale, 6) . ' Tz';
}

sub hscale {
    my ($self, $scale) = @_;
    if (defined $scale) {
        $self->{' hscale'} = $scale;
        $self->add(_hscale($scale));
    }
    return $self->{' hscale'};
}

# Deprecated: hscale was originally named incorrectly (as hspace)
sub  hspace { return  hscale(@_) }
sub _hspace { return _hscale(@_) }

=item $leading = $content->lead($leading)

Sets the text leading, which is the distance between baselines.  This
is initially zero (i.e. the lines will be printed on top of each
other).

=cut

sub _lead {
    my ($para) = @_;
    return float($para) . ' TL';
}
sub lead {
    my ($self,$para) = @_;
    if (defined ($para)) {
        $self->{' lead'} = $para;
        $self->add(_lead($para));
    }
    return $self->{' lead'};
}

=item $mode = $content->render($mode)

Sets the text rendering mode.

=over

=item 0 = Fill text

=item 1 = Stroke text (outline)

=item 2 = Fill, then stroke text

=item 3 = Neither fill nor stroke text (invisible)

=item 4 = Fill text and add to path for clipping

=item 5 = Stroke text and add to path for clipping

=item 6 = Fill, then stroke text and add to path for clipping

=item 7 = Add text to path for clipping

=back

=cut

sub _render {
    my ($para) = @_;
    return intg($para) . ' Tr';
}

sub render {
    my ($self, $para) = @_;
    if (defined ($para)) {
        $self->{' render'} = $para;
        $self->add(_render($para));
    }
    return $self->{' render'};
}

=item $distance = $content->rise($distance)

Adjusts the baseline up or down from its current location.  This is
initially zero.

Use this for creating superscripts or subscripts (usually with an
adjustment to the font size as well).

=cut

sub _rise {
    my ($para) = @_;
    return float($para) . ' Ts';
}

sub rise {
    my ($self, $para) = @_;
    if (defined ($para)) {
        $self->{' rise'} = $para;
        $self->add(_rise($para));
    }
    return $self->{' rise'};
}

=item %state = $content->textstate(charspace => $value, wordspace => $value, ...)

Shortcut for setting multiple text state parameters at once.

This can also be used without arguments to retrieve the current text
state settings.

Note: This does not currently work with the C<save> and C<restore> commands.

=cut

sub textstate {
    my $self = shift;
    my %state;
    if (scalar @_) {
        %state = @_;
        foreach my $k (qw( charspace hscale wordspace lead rise render )) {
            next unless($state{$k});
            $self->can($k)->($self, $state{$k});
        }
        if ($state{font} && $state{fontsize}) {
            $self->font($state{font},$state{fontsize});
        }
        if ($state{textmatrix}) {
            $self->matrix(@{$state{textmatrix}});
            @{$self->{' translate'}}=@{$state{translate}};
            $self->{' rotate'}=$state{rotate};
            @{$self->{' scale'}}=@{$state{scale}};
            @{$self->{' skew'}}=@{$state{skew}};
        }
        if ($state{fillcolor}) {
            $self->fillcolor(@{$state{fillcolor}});
        }
        if ($state{strokecolor}) {
            $self->strokecolor(@{$state{strokecolor}});
        }
        %state = ();
    }
    else {
        foreach my $k (qw( font fontsize charspace hscale wordspace lead rise render )) {
            $state{$k}=$self->{" $k"};
        }
        $state{matrix}=[@{$self->{" matrix"}}];
        $state{textmatrix}=[@{$self->{" textmatrix"}}];
        $state{textlinematrix}=[@{$self->{" textlinematrix"}}];
        $state{rotate}=$self->{" rotate"};
        $state{scale}=[@{$self->{" scale"}}];
        $state{skew}=[@{$self->{" skew"}}];
        $state{translate}=[@{$self->{" translate"}}];
        $state{fillcolor}=[@{$self->{" fillcolor"}}];
        $state{strokecolor}=[@{$self->{" strokecolor"}}];
    }
    return %state;
}

=item $content->font($font_object, $size)

    # Example
    my $pdf = PDF::API2->new();
    my $font = $pdf->corefont('Helvetica');
    $content->font($font, 12);

Sets the font and font size.

=cut

sub _font {
    my ($font, $size) = @_;
    if ($font->isvirtual == 1) {
        return('/'.$font->fontlist->[0]->name.' '.float($size).' Tf');
    }
    else {
        return('/'.$font->name.' '.float($size).' Tf');
    }
}
sub font {
    my ($self, $font, $size) = @_;
    unless ($size) {
        croak q{A font size is required};
    }
    $self->fontset($font, $size);
    $self->add(_font($font, $size));
    $self->{' fontset'} = 1;
    return $self;
}

sub fontset {
    my ($self,$font,$size)=@_;
    $self->{' font'}=$font;
    $self->{' fontsize'}=$size;
    $self->{' fontset'}=0;

    if ($font->isvirtual == 1) {
        foreach my $f (@{$font->fontlist}) {
            $self->resource('Font', $f->name, $f);
        }
    }
    else {
        $self->resource('Font', $font->name, $font);
    }

    return $self;
}

=back

=head2 Text-Positioning

Note: There is a very good chance that these commands will be replaced
in a future release.

=over

=item $content->distance($dx, $dy)

Moves to the start of the next line, offset by the given amounts,
which are both required.

=cut

sub distance {
    my ($self,$dx,$dy)=@_;
    $self->add(float($dx),float($dy),'Td');
    $self->matrix_update($dx,$dy);
    $self->{' textlinematrix'}->[0]=$dx;
}

=item $content->cr()

=item $content->cr($vertical_offset)

Moves the cursor to the start of the line when called without an
argument.  If leading has been set, the cursor will move to the next
line instead.

An offset can be passed as an argument to override the leading value.
A positive offset will move the cursor up, and a negative offset will
move the cursor down.

Pass zero as the argument to ignore the leading and get just a
carriage return.

=cut

sub cr {
    my ($self, $offset) = @_;
    if (defined $offset) {
        $self->add(0, float($offset), 'Td');
        $self->matrix_update(0, $offset);
    }
    else {
        $self->add('T*');
        $self->matrix_update(0, $self->lead() * -1);
    }
    $self->{' textlinematrix'}->[0] = 0;
}

=item $content->nl()

Moves to the start of the next line.

=cut

sub nl {
    my $self = shift();
    $self->add('T*');
    $self->matrix_update(0, $self->lead() * -1);
    $self->{' textlinematrix'}->[0] = 0;
}

=item ($tx, $ty) = $content->textpos()

Gets the current estimated text position.

Note: This does not affect the PDF in any way.

=cut

sub _textpos {
    my ($self,@xy)=@_;
    my ($x,$y)=(0,0);
    while (scalar @xy > 0) {
        $x+=shift @xy;
        $y+=shift @xy;
    }
    my (@m)=_transform(
        -matrix=>$self->{" textmatrix"},
        -point=>[$x,$y]
    );
    return($m[0],$m[1]);
}
sub textpos {
    my $self=shift @_;
    return($self->_textpos(@{$self->{" textlinematrix"}}));
}
sub textpos2 {
    my $self=shift @_;
    return(@{$self->{" textlinematrix"}});
}

=back

=head2 Text-Showing

=over

=item $width = $content->text($text, %options)

Adds text to the page.

Options:

=over

=item -indent

Indents the text by the number of points.

=item -underline => 'auto'

=item -underline => $distance

=item -underline => [$distance, $thickness, ...]

Underlines the text.  C<$distance> is the number of units beneath the
baseline, and C<$thickness> is the width of the line.

Multiple underlines can be made by passing several distances and
thicknesses.

=back

=cut

sub _text_underline {
    my ($self,$xy1,$xy2,$underline,$color) = @_;
    $color||='black';
    my @underline=();
    if (ref($underline) eq 'ARRAY') {
        @underline=@{$underline};
    }
    else {
        @underline=($underline,1);
    }
    push @underline,1 if(@underline%2);

    my $underlineposition=(-$self->{' font'}->underlineposition()*$self->{' fontsize'}/1000||1);
    my $underlinethickness=($self->{' font'}->underlinethickness()*$self->{' fontsize'}/1000||1);
    my $pos=1;

    while(@underline) {
        $self->add_post(_save);

        my $distance=shift @underline;
        my $thickness=shift @underline;
        my $scolor=$color;
        if (ref $thickness) {
            ($thickness,$scolor)=@{$thickness};
        }

        if ($distance eq 'auto') {
            $distance=$pos*$underlineposition;
        }
        if ($thickness eq 'auto') {
            $thickness=$underlinethickness;
        }

        my ($x1,$y1)=$self->_textpos(@{$xy1},0,-($distance+($thickness/2)));
        my ($x2,$y2)=$self->_textpos(@{$xy2},0,-($distance+($thickness/2)));

        $self->add_post($self->_strokecolor($scolor));
        $self->add_post(_linewidth($thickness));
        $self->add_post(_move($x1,$y1));
        $self->add_post(_line($x2,$y2));
        $self->add_post(_stroke);

        $self->add_post(_restore);
        $pos++;
    }
}

sub text {
    my ($self, $text, %opt) = @_;
    my $wd = 0;
    if ($self->{' fontset'}==0) {
        unless (defined $self->{' font'} and $self->{' fontsize'}) {
            croak q{Can't add text without first setting a font and font size};
        }
        $self->font($self->{' font'},$self->{' fontsize'});
        $self->{' fontset'}=1;
    }
    if (defined $opt{-indent}) {
        $wd+=$opt{-indent};
        $self->matrix_update($wd,0);
    }
    my $ulxy1=[$self->textpos2];

    if (defined $opt{-indent}) {
    # changed fot acrobat 8 and possible others
    #    $self->add('[',(-$opt{-indent}*(1000/$self->{' fontsize'})*(100/$self->hscale())),']','TJ');
        $self->add($self->{' font'}->text($text, $self->{' fontsize'}, (-$opt{-indent}*(1000/$self->{' fontsize'})*(100/$self->hscale()))));
    }
    else {
        $self->add($self->{' font'}->text($text,$self->{' fontsize'}));
    }

    $wd = $self->advancewidth($text);
    $self->matrix_update($wd,0);

    my $ulxy2 = [$self->textpos2];

    if (defined $opt{-underline}) {
        $self->_text_underline($ulxy1,$ulxy2,$opt{-underline},$opt{-strokecolor});
    }

    return $wd;
}

=item $content->text_center($text)

As C<text>, but centered on the current point.

=cut

sub text_center {
    my ($self,$text,@opts)=@_;
    my $width=$self->advancewidth($text);
    return $self->text($text,-indent=>-($width/2),@opts);
}

=item $txt->text_right $text, %options

As C<text>, but right-aligned to the current point.

=cut

sub text_right {
    my ($self,$text,@opts) = @_;
    my $width=$self->advancewidth($text);
    return $self->text($text,-indent=>-$width,@opts);
}

=item $width = $txt->advancewidth($string, %text_state)

Returns the width of the string based on all currently set text-state
attributes.  These can optionally be overridden.

=cut

sub advancewidth {
    my ($self,$text,@opts) = @_;
    return 0 unless defined($text) and length($text);
    if(scalar @opts > 1) {
        my %opts=@opts;
        foreach my $k (qw[ font fontsize wordspace charspace hscale]) {
            $opts{$k}=$self->{" $k"} unless(defined $opts{$k});
        }
        my $glyph_width = $opts{font}->width($text)*$opts{fontsize};
        my $num_space = $text =~ y/\x20/\x20/;
        my $num_char = length($text);
        my $word_spaces = $opts{wordspace}*$num_space;
        my $char_spaces = $opts{charspace}*($num_char - 1);
        my $advance = ($glyph_width+$word_spaces+$char_spaces)*$opts{hscale}/100;
        return $advance;
    }
    else {
        my $glyph_width = $self->{' font'}->width($text)*$self->{' fontsize'};
        my $num_space = $text =~ y/\x20/\x20/;
        my $num_char = length($text);
        my $word_spaces = $self->wordspace*$num_space;
        my $char_spaces = $self->charspace*($num_char - 1);
        my $advance = ($glyph_width+$word_spaces+$char_spaces)*$self->hscale()/100;
        return $advance;
    }
}

=back

=cut

sub text_justified {
    my ($self,$text,$width,%opts) = @_;
    my $initial_width = $self->advancewidth($text);
    my $space_count = scalar split /\s/, $text;
    my $ws = $self->wordspace();
    $self->wordspace(($width - $initial_width) / $space_count) if $space_count > 0;
    $self->text($text,%opts);
    $self->wordspace($ws);
    return $width;
}

sub _text_fill_line {
    my ($self,$text,$width,$over) = @_;
    my @txt = split(/\x20/,$text);
    my @line = ();
    local $";
    $"=' ';
    while (@txt) {
         push @line,(shift @txt);
         last if($self->advancewidth("@line")>$width);
    }
    if (!$over && (scalar @line > 1) && ($self->advancewidth("@line") > $width)) {
        unshift @txt,pop @line;
    }
    my $ret = "@txt";
    my $line = "@line";
    return ($line,$ret);
}

sub text_fill_left {
    my ($self,$text,$width,%opts) = @_;
    my $over=(not(defined($opts{-spillover}) and $opts{-spillover} == 0));
    my ($line,$ret)=$self->_text_fill_line($text,$width,$over);
    $width=$self->text($line,%opts);
    return ($width,$ret);
}

sub text_fill_center {
    my ($self,$text,$width,%opts) = @_;
    my $over=(not(defined($opts{-spillover}) and $opts{-spillover} == 0));
    my ($line,$ret)=$self->_text_fill_line($text,$width,$over);
    $width=$self->text_center($line,%opts);
    return ($width,$ret);
}

sub text_fill_right {
    my ($self,$text,$width,%opts) = @_;
    my $over=(not(defined($opts{-spillover}) and $opts{-spillover} == 0));
    my ($line,$ret)=$self->_text_fill_line($text,$width,$over);
    $width=$self->text_right($line,%opts);
    return ($width,$ret);
}

sub text_fill_justified {
    my ($self,$text,$width,%opts) = @_;
    my $over=(not(defined($opts{-spillover}) and $opts{-spillover} == 0));
    my ($line,$ret)=$self->_text_fill_line($text,$width,$over);
    my $ws=$self->wordspace();
    my $w=$self->advancewidth($line);
    my $space_count = scalar split /\s/, $line;
    if (($ret||$w>=$width) and $space_count) {
        $self->wordspace(($width - $w) / $space_count);
    }
    $width=$self->text($line,%opts);
    $self->wordspace($ws);
    return($width,$ret);
}

# =item $overflow_text = $txt->paragraph $text, $width, $height, %options
#
# ** DEVELOPER METHOD **
#
# Apply the text within the rectangle and return any leftover text.
#
# B<Options>
#
# =over 4
#
# =item -align => $choice
#
# Choice is 'justified', 'right', 'center', 'left'
# Default is 'left'
#
# =item -underline => $distance
#
# =item -underline => [ $distance, $thickness, ... ]
#
# If a scalar, distance below baseline,
# else array reference with pairs of distance and line thickness.
#
# =item -spillover => $over
#
# Controls if words in a line which exceed the given width should be "spilled over" the bounds or if a new line should be used for this word.
#
# Over is 1 or 0
# Default is 1
#
# =back
#
# B<Example:>
#
#     $txt->font($font,$fontsize);
#     $txt->lead($lead);
#     $txt->translate($x,$y);
#     $overflow = $txt->paragraph( 'long paragraph here ...',
#                                  $width,
#                                  $y+$lead-$bottom_margin );
#
# =cut

sub paragraph {
    my ($self,$text,$width,$height,%opts) = @_;
    my @line=();
    my $nwidth=0;
    my $lead=$self->lead();
    while (length($text)>0) {
        last if ($height -= $lead) < 0;
        if ($opts{-align}=~/^j/i) {
            ($nwidth,$text)=$self->text_fill_justified($text,$width,%opts);
        }
        elsif ($opts{-align}=~/^r/i) {
            ($nwidth,$text)=$self->text_fill_right($text,$width,%opts);
        }
        elsif ($opts{-align}=~/^c/i) {
            ($nwidth,$text)=$self->text_fill_center($text,$width,%opts);
        }
        else {
            ($nwidth,$text)=$self->text_fill_left($text,$width,%opts);
        }
        $self->nl;
    }
    if (wantarray) {
        return ($text,$height);
    }
    return $text;
}

# =item $overflow_text = $txt->section $text, $width, $height, %options
#
# ** DEVELOPER METHOD **
#
# Split paragraphs by newline and loop over them, reassemble leftovers
# when box is full and apply the text within the rectangle and return
# any leftover text.
#
# =cut

sub section {
    my ($self,$text,$width,$height,%opts)=@_;
    my $overflow = '';

    foreach my $para (split(/\n/,$text)) {
        if(length($overflow) > 0) {
            $overflow .= "\n" . $para;
            next;
        }
        ($para,$height) = $self->paragraph($para,$width,$height,%opts);
        $overflow .= $para if (length($para) > 0);
    }
    if (wantarray) {
        return ($overflow,$height);
    }
    return $overflow;
}

sub textlabel {
    my ($self,$x,$y,$font,$size,$text,%opts,$wht) = @_;
    my %trans_opts=( -translate => [$x,$y] );
    my %text_state=();
    $trans_opts{-rotate} = $opts{-rotate} if($opts{-rotate});

    my $wastext = $self->_in_text_object;
    if ($wastext) {
        %text_state=$self->textstate;
        $self->textend;
    }
    $self->save;
    $self->textstart;

    $self->transform(%trans_opts);

    $self->fillcolor(ref($opts{-color}) ? @{$opts{-color}} : $opts{-color}) if($opts{-color});
    $self->strokecolor(ref($opts{-strokecolor}) ? @{$opts{-strokecolor}} : $opts{-strokecolor}) if($opts{-strokecolor});

    $self->font($font,$size);

    $self->charspace($opts{-charspace})     if($opts{-charspace});
    $self->hscale($opts{-hscale})           if($opts{-hscale});
    $self->wordspace($opts{-wordspace})     if($opts{-wordspace});
    $self->render($opts{-render})           if($opts{-render});

    if ($opts{-right} || $opts{-align}=~/^r/i) {
        $wht = $self->text_right($text,%opts);
    }
    elsif ($opts{-center} || $opts{-align}=~/^c/i) {
        $wht = $self->text_center($text,%opts);
    }
    else {
        $wht = $self->text($text,%opts);
    }

    $self->textend;
    $self->restore;

    if ($wastext) {
        $self->textstart;
        $self->textstate(%text_state);
    }
    return $wht;
}

sub metaStart {
    my $self=shift @_;
    my $tag=shift @_;
    my $obj=shift @_;
    $self->add("/$tag");
    if (defined $obj) {
        my $dict=PDFDict();
        $dict->{Metadata}=$obj;
        $self->resource('Properties',$obj->name,$dict);
        $self->add('/'.($obj->name));
        $self->add('BDC');
    }
    else {
        $self->add('BMC');
    }
    return $self;
}

sub metaEnd {
    my $self=shift @_;
    $self->add('EMC');
    return $self;
}

=head2 Advanced Methods

=over

=item $content->add @content

Add raw content to the PDF stream.  You will generally want to use the
other methods in this class instead.

=cut

sub add_post {
    my $self = shift;
    if (scalar @_) {
        $self->{' poststream'} .= ($self->{' poststream'} =~ m|\s$|o ? '' : ' ') . join(' ', @_) . ' ';
    }
    return $self;
}
sub add {
    my $self = shift;
    if (scalar @_) {
        $self->{' stream'} .= encode('iso-8859-1', ($self->{' stream'} =~ m|\s$|o ? '' : ' ') . join(' ', @_) . ' ');
    }
    return $self;
}

# Shortcut method for determining if we're inside a text object
# (i.e. between BT and ET).  See textstart and textend.
sub _in_text_object {
    my $self = shift();
    return defined($self->{' apiistext'}) && $self->{' apiistext'} == 1;
}

=item $content->compressFlate

Marks content for compression on output.  This is done automatically
in nearly all cases, so you shouldn't need to call this yourself.

=cut

sub compressFlate {
    my $self=shift @_;
    $self->{'Filter'}=PDFArray(PDFName('FlateDecode'));
    $self->{-docompress}=1;
    return $self;
}

=item $content->textstart

Starts a text object.  You will likely want to use the C<text> method
instead.

=cut

sub textstart {
    my ($self) = @_;
    unless ($self->_in_text_object()) {
        $self->add(' BT ');
        $self->{' apiistext'}=1;
        $self->{' font'}=undef;
        $self->{' fontset'}=0;
        $self->{' fontsize'}=0;
        $self->{' charspace'}=0;
        $self->{' hscale'}=100;
        $self->{' wordspace'}=0;
        $self->{' lead'}=0;
        $self->{' rise'}=0;
        $self->{' render'}=0;
        @{$self->{' matrix'}}=(1,0,0,1,0,0);
        @{$self->{' textmatrix'}}=(1,0,0,1,0,0);
        @{$self->{' textlinematrix'}}=(0,0);
        @{$self->{' fillcolor'}}=(0);
        @{$self->{' strokecolor'}}=(0);
        @{$self->{' translate'}}=(0,0);
        @{$self->{' scale'}}=(1,1);
        @{$self->{' skew'}}=(0,0);
        $self->{' rotate'}=0;
    }
    return $self;
}

=item $content->textend

Ends a text object.

=cut

sub textend {
    my ($self) = @_;
    if ($self->_in_text_object()) {
        $self->add(' ET ', $self->{' poststream'});
        $self->{' apiistext'} = 0;
        $self->{' poststream'} = '';
    }
    return $self;
}

=back

=cut

sub resource {
    my ($self, $type, $key, $obj, $force) = @_;
    if ($self->{' apipage'}) {
        # we are a content stream on a page.
        return $self->{' apipage'}->resource($type, $key, $obj, $force);
    }
    else {
        # we are a self-contained content stream.
        $self->{Resources}||=PDFDict();

        my $dict=$self->{Resources};
        $dict->realise if(ref($dict)=~/Objind$/);

        $dict->{$type}||= PDFDict();
        $dict->{$type}->realise if(ref($dict->{$type})=~/Objind$/);
        unless (defined $obj) {
            return($dict->{$type}->{$key} || undef);
        }
        else {
            if ($force) {
                $dict->{$type}->{$key}=$obj;
            }
            else {
                $dict->{$type}->{$key}||=$obj;
            }
            return $dict;
        }
    }
}

1;
