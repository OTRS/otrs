package PDF::API2::Resource::ExtGState;

use base 'PDF::API2::Resource';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

=head1 NAME

PDF::API2::Resource::ExtGState - Graphics state dictionary support

=head1 METHODS

=over

=item $egs = PDF::API2::Resource::ExtGState->new @parameters

Returns a new extgstate object (called from $pdf->egstate).

=cut

sub new {
    my ($class,$pdf,$key)=@_;
    my $self = $class->SUPER::new($pdf,$key);
    $self->{Type}=PDFName('ExtGState');
    return($self);
}

=item $egs->strokeadjust $boolean

=cut

sub strokeadjust {
    my ($self,$var)=@_;
    $self->{SA}=PDFBool($var);
    return($self);
}

=item $egs->strokeoverprint $boolean

=cut

sub strokeoverprint {
    my ($self,$var)=@_;
    $self->{OP}=PDFBool($var);
    return($self);
}

=item $egs->filloverprint $boolean

=cut

sub filloverprint {
    my ($self,$var)=@_;
    $self->{op}=PDFBool($var);
    return($self);
}

=item $egs->overprintmode $num

=cut

sub overprintmode {
    my ($self,$var)=@_;
    $self->{OPM}=PDFNum($var);
    return($self);
}

=item $egs->blackgeneration $obj

=cut

sub blackgeneration {
    my ($self,$obj)=@_;
    $self->{BG}=$obj;
    return($self);
}

=item $egs->blackgeneration2 $obj

=cut

sub blackgeneration2 {
    my ($self,$obj)=@_;
    $self->{BG2}=$obj;
    return($self);
}

=item $egs->undercolorremoval $obj

=cut

sub undercolorremoval {
    my ($self,$obj)=@_;
    $self->{UCR}=$obj;
    return($self);
}

=item $egs->undercolorremoval2 $obj

=cut

sub undercolorremoval2 {
    my ($self,$obj)=@_;
    $self->{UCR2}=$obj;
    return($self);
}

=item $egs->transfer $obj

=cut

sub transfer {
    my ($self,$obj)=@_;
    $self->{TR}=$obj;
    return($self);
}

=item $egs->transfer2 $obj

=cut

sub transfer2 {
    my ($self,$obj)=@_;
    $self->{TR2}=$obj;
    return($self);
}

=item $egs->halftone $obj

=cut

sub halftone {
    my ($self,$obj)=@_;
    $self->{HT}=$obj;
    return($self);
}

=item $egs->halftonephase $obj

=cut

# Per RT #113514, this was last present in version 1.2 of the PDF
# spec, so it can probably be removed.
sub halftonephase {
    my ($self,$obj)=@_;
    $self->{HTP}=$obj;
    return($self);
}

=item $egs->smoothness $num

=cut

sub smoothness {
    my ($self,$var)=@_;
    $self->{SM}=PDFNum($var);
    return($self);
}

=item $egs->font $font, $size

=cut

sub font {
    my ($self,$font,$size)=@_;
    $self->{Font}=PDFArray(PDFName($font->{' apiname'}),PDFNum($size));
    return($self);
}

=item $egs->linewidth $size

=cut

sub linewidth {
    my ($self,$var)=@_;
    $self->{LW}=PDFNum($var);
    return($self);
}

=item $egs->linecap $cap

=cut

sub linecap {
    my ($self,$var)=@_;
    $self->{LC}=PDFNum($var);
    return($self);
}

=item $egs->linejoin $join

=cut

sub linejoin {
    my ($self,$var)=@_;
    $self->{LJ}=PDFNum($var);
    return($self);
}

=item $egs->miterlimit $limit

=cut

sub miterlimit {
    my ($self,$var)=@_;
    $self->{ML}=PDFNum($var);
    return($self);
}

# Deprecated: miterlimit was originally named incorrectly
sub meterlimit { return miterlimit(@_) }

=item $egs->dash @dash

=cut

sub dash {
    my ($self,@dash)=@_;
    $self->{D}=PDFArray(PDFArray( map { PDFNum($_); } @dash), PDFNum(0));
    return($self);
}

=item $egs->flatness $flat

=cut

sub flatness {
    my ($self,$var)=@_;
    $self->{FL}=PDFNum($var);
    return($self);
}

=item $egs->renderingintent $intentName

=cut

sub renderingintent {
    my ($self,$var)=@_;
    $self->{RI}=PDFName($var);
    return($self);
}

=item $egs->strokealpha $alpha

The current stroking alpha constant, specifying the
constant shape or constant opacity value to be used
for stroking operations in the transparent imaging model.

=cut

sub strokealpha {
    my ($self,$var)=@_;
    $self->{CA}=PDFNum($var);
    return($self);
}

=item $egs->fillalpha $alpha

Same as strokealpha, but for nonstroking operations.

=cut

sub fillalpha {
    my ($self,$var)=@_;
    $self->{ca}=PDFNum($var);
    return($self);
}

=item $egs->blendmode $blendname

=item $egs->blendmode $blendfunctionobj

The current blend mode to be used in the transparent
imaging model.

=cut

sub blendmode {
    my ($self,$var)=@_;
    if(ref($var)) {
        $self->{BM}=$var;
    } else {
        $self->{BM}=PDFName($var);
    }
    return($self);
}

=item $egs->alphaisshape $boolean

The alpha source flag (alpha is shape), specifying
whether the current soft mask and alpha constant
are to be interpreted as shape values (true) or
opacity values (false).

=cut

sub alphaisshape {
    my ($self,$var)=@_;
    $self->{AIS}=PDFBool($var);
    return($self);
}

=item $egs->textknockout $boolean

The text knockout flag, which determines the behavior
of overlapping glyphs within a text object in the
transparent imaging model.

=cut

sub textknockout {
    my ($self,$var)=@_;
    $self->{TK}=PDFBool($var);
    return($self);
}

=item $egs->transparency $t

The graphics transparency, with 0 being fully opaque and 1 being fully transparent.
This is a convenience method setting proper values for strokealpha and fillalpha.

=cut

sub transparency {
    my ($self,$var)=@_;
    $self->strokealpha(1-$var);
    $self->fillalpha(1-$var);
    return($self);
}

=item $egs->opacity $op

The graphics opacity , with 1 being fully opaque and 0 being fully transparent.
This is a convenience method setting proper values for strokealpha and fillalpha.

=cut

sub opacity {
    my ($self,$var)=@_;
    $self->strokealpha($var);
    $self->fillalpha($var);
    return($self);
}

sub outobjdeep {
    my ($self, @opts) = @_;
    foreach my $k (qw/ api apipdf /) {
        $self->{" $k"}=undef;
        delete($self->{" $k"});
    }
    $self->SUPER::outobjdeep(@opts);
}

=back

=cut

1;
