package PDF::API2::Annotation;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use Encode qw(:all);

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

=head1 NAME

PDF::API2::Annotation - Add annotations to a PDF

=head1 METHODS

=over

=item $ant = PDF::API2::Annotation->new

Returns an annotation object (called from $page->annotation).

=cut

sub new
{
    my ($class,%opts)=@_;
    my $self=$class->SUPER::new;
    $self->{Type}=PDFName('Annot');
    $self->{Border}=PDFArray(PDFNum(0),PDFNum(0),PDFNum(0));
    return($self);
}

sub outobjdeep
{
    my ($self, @opts) = @_;
    foreach my $k (qw[ api apipdf apipage ])
    {
        $self->{" $k"}=undef;
        delete($self->{" $k"});
    }
    $self->SUPER::outobjdeep(@opts);
}

=item $ant->link $page, %opts

Defines the annotation as launch-page with page $page and
options %opts (-rect, -border or 'dest-options').

=cut

sub link
{
    my ($self,$page,%opts)=@_;
    $self->{Subtype}=PDFName('Link');
    if(ref $page)
    {
        $self->{A}=PDFDict();
        $self->{A}->{S}=PDFName('GoTo');
    }
    $self->dest($page,%opts);
    $self->rect(@{$opts{-rect}}) if(defined $opts{-rect});
    $self->border(@{$opts{-border}}) if(defined $opts{-border});
    return($self);
}

=item $ant->url $url, %opts

Defines the annotation as launch-url with url $url and
options %opts (-rect and/or -border).

=cut

sub url
{
    my ($self,$url,%opts)=@_;
    $self->{Subtype}=PDFName('Link');
    $self->{A}=PDFDict();
    $self->{A}->{S}=PDFName('URI');
    if(is_utf8($url))
    {
        # URI must be 7-bit ascii
        utf8::downgrade($url);
    }
    $self->{A}->{URI}=PDFStr($url);
    # this will come again -- since the utf8 urls are coming !
    # -- fredo
    #if(is_utf8($url) || utf8::valid($url)) {
    #    $self->{A}->{URI}=PDFUtf($url);
    #} else {
    #    $self->{A}->{URI}=PDFStr($url);
    #}
    $self->rect(@{$opts{-rect}}) if(defined $opts{-rect});
    $self->border(@{$opts{-border}}) if(defined $opts{-border});
    return($self);
}

=item $ant->file $file, %opts

Defines the annotation as launch-file with filepath $file and
options %opts (-rect and/or -border).

=cut

sub file
{
    my ($self,$url,%opts)=@_;
    $self->{Subtype}=PDFName('Link');
    $self->{A}=PDFDict();
    $self->{A}->{S}=PDFName('Launch');
    if(is_utf8($url))
    {
        # URI must be 7-bit ascii
        utf8::downgrade($url);
    }
    $self->{A}->{F}=PDFStr($url);
    # this will come again -- since the utf8 urls are coming !
    # -- fredo
    #if(is_utf8($url) || utf8::valid($url)) {
    #    $self->{A}->{F}=PDFUtf($url);
    #} else {
    #    $self->{A}->{F}=PDFStr($url);
    #}
    $self->rect(@{$opts{-rect}}) if(defined $opts{-rect});
    $self->border(@{$opts{-border}}) if(defined $opts{-border});
    return($self);
}

=item $ant->pdfile $pdfile, $pagenum, %opts

Defines the annotation as pdf-file with filepath $pdfile, $pagenum
and options %opts (same as dest).

=cut

sub pdfile
{
    my ($self,$url,$pnum,%opts)=@_;
    $self->{Subtype}=PDFName('Link');
    $self->{A}=PDFDict();
    $self->{A}->{S}=PDFName('GoToR');
    if(is_utf8($url))
    {
        # URI must be 7-bit ascii
        utf8::downgrade($url);
    }
    $self->{A}->{F}=PDFStr($url);
    # this will come again -- since the utf8 urls are coming !
    # -- fredo
    #if(is_utf8($url) || utf8::valid($url)) {
    #    $self->{A}->{F}=PDFUtf($url);
    #} else {
    #    $self->{A}->{F}=PDFStr($url);
    #}

    $self->dest(PDFNum($pnum),%opts);

    $self->rect(@{$opts{-rect}}) if(defined $opts{-rect});
    $self->border(@{$opts{-border}}) if(defined $opts{-border});

    return($self);
}

=item $ant->text $text, %opts

Defines the annotation as textnote with content $text and
options %opts (-rect and/or -open).

=cut

sub text
{
    my ($self,$text,%opts)=@_;
    $self->{Subtype}=PDFName('Text');
    $self->content($text);
    $self->rect(@{$opts{-rect}}) if(defined $opts{-rect});
    $self->open($opts{-open}) if(defined $opts{-open});
    return($self);
}

=item $ant->movie $file, $contentype, %opts

Defines the annotation as a movie from $file with $contentype and
options %opts (-rect).

=cut

sub movie
{
    my ($self,$file,$contentype,%opts)=@_;
    $self->{Subtype}=PDFName('Movie');
    $self->{A}=PDFBool(1);
    $self->{Movie}=PDFDict();
    $self->{Movie}->{F}=PDFDict();
    $self->{' apipdf'}->new_obj($self->{Movie}->{F});
    my $f=$self->{Movie}->{F};
    $f->{Type}=PDFName('EmbeddedFile');
    $f->{Subtype}=PDFName($contentype);
    $f->{' streamfile'}=$file;
    $self->rect(@{$opts{-rect}}) if(defined $opts{-rect});
    return($self);
}

=item $ant->rect $llx, $lly, $urx, $ury

Sets the rectangle of the annotation.

=cut

sub rect
{
    my ($self,@r)=@_;
    die "insufficient parameters to annotation->rect( ) " unless(scalar @r == 4);
    $self->{Rect}=PDFArray( map { PDFNum($_) } $r[0],$r[1],$r[2],$r[3], );
    return($self);
}

=item $ant->border @b

Sets the border-styles of the annotation, if applicable.

=cut

sub border
{
    my ($self,@r)=@_;
    die "insufficient parameters to annotation->border( ) " unless(scalar @r == 3);
    $self->{Border}=PDFArray( map { PDFNum($_) } $r[0],$r[1],$r[2] );
    return($self);
}

=item $ant->content @lines

Sets the text-content of the annotation, if applicable.

=cut

sub content
{
    my ($self,@t)=@_;
    my $t=join("\n",@t);
    if(is_utf8($t) || utf8::valid($t))
    {
        $self->{Contents}=PDFUtf($t);
    }
    else
    {
        $self->{Contents}=PDFStr($t);
    }
    return($self);
}

sub name
{
    my ($self,$n)=@_;
    $self->{Name}=PDFName($n);
    return($self);
}

=item $ant->open $bool

Display the annotation either open or closed, if applicable.

=cut

sub open
{
    my ($self,$n)=@_;
    $self->{Open}=PDFBool( $n ? 1 : 0 );
    return($self);
}

=item $ant->dest( $page, -fit => 1 )

Display the page designated by page, with its contents magnified just enough to
fit the entire page within the window both horizontally and vertically. If the
required horizontal and vertical magnification factors are different, use the
smaller of the two, centering the page within the window in the other dimension.

=item $ant->dest( $page, -fith => $top )

Display the page designated by page, with the vertical coordinate top positioned
at the top edge of the window and the contents of the page magnified just enough
to fit the entire width of the page within the window.

=item $ant->dest( $page, -fitv => $left )

Display the page designated by page, with the horizontal coordinate left positioned
at the left edge of the window and the contents of the page magnified just enough
to fit the entire height of the page within the window.

=item $ant->dest( $page, -fitr => [ $left, $bottom, $right, $top ] )

Display the page designated by page, with its contents magnified just enough to
fit the rectangle specified by the coordinates left, bottom, right, and top
entirely within the window both horizontally and vertically. If the required
horizontal and vertical magnification factors are different, use the smaller of
the two, centering the rectangle within the window in the other dimension.

=item $ant->dest( $page, -fitb => 1 )

(PDF 1.1) Display the page designated by page, with its contents magnified just
enough to fit its bounding box entirely within the window both horizontally and
vertically. If the required horizontal and vertical magnification factors are
different, use the smaller of the two, centering the bounding box within the
window in the other dimension.

=item $ant->dest( $page, -fitbh => $top )

(PDF 1.1) Display the page designated by page, with the vertical coordinate top
positioned at the top edge of the window and the contents of the page magnified
just enough to fit the entire width of its bounding box within the window.

=item $ant->dest( $page, -fitbv => $left )

(PDF 1.1) Display the page designated by page, with the horizontal coordinate
left positioned at the left edge of the window and the contents of the page
magnified just enough to fit the entire height of its bounding box within the
window.

=item $ant->dest( $page, -xyz => [ $left, $top, $zoom ] )

Display the page designated by page, with the coordinates (left, top) positioned
at the top-left corner of the window and the contents of the page magnified by
the factor zoom. A zero (0) value for any of the parameters left, top, or zoom
specifies that the current value of that parameter is to be retained unchanged.

=item $ant->dest( $name )

(PDF 1.2) Connect the Annotation to a "Named Destination" defined elsewhere.

=cut

sub dest
{
    my ($self,$page,%opts)=@_;

    if(ref $page)
    {
        $opts{-xyz}=[undef,undef,undef] if(scalar(keys %opts)<1);

        $self->{A}||=PDFDict();

        if(defined $opts{-fit})
        {
            $self->{A}->{D}=PDFArray($page,PDFName('Fit'));
        }
        elsif(defined $opts{-fith})
        {
            $self->{A}->{D}=PDFArray($page,PDFName('FitH'),PDFNum($opts{-fith}));
        }
        elsif(defined $opts{-fitb})
        {
            $self->{A}->{D}=PDFArray($page,PDFName('FitB'));
        }
        elsif(defined $opts{-fitbh})
        {
            $self->{A}->{D}=PDFArray($page,PDFName('FitBH'),PDFNum($opts{-fitbh}));
        }
        elsif(defined $opts{-fitv})
        {
            $self->{A}->{D}=PDFArray($page,PDFName('FitV'),PDFNum($opts{-fitv}));
        }
        elsif(defined $opts{-fitbv})
        {
            $self->{A}->{D}=PDFArray($page,PDFName('FitBV'),PDFNum($opts{-fitbv}));
        }
        elsif(defined $opts{-fitr})
        {
            die "insufficient parameters to ->dest( page, -fitr => [] ) " unless(scalar @{$opts{-fitr}} == 4);
            $self->{A}->{D}=PDFArray($page,PDFName('FitR'),map {PDFNum($_)} @{$opts{-fitr}});
        }
        elsif(defined $opts{-xyz})
        {
            die "insufficient parameters to ->dest( page, -xyz => [] ) " unless(scalar @{$opts{-xyz}} == 3);
            $self->{A}->{D}=PDFArray($page,PDFName('XYZ'),map {defined $_ ? PDFNum($_) : PDFNull()} @{$opts{-xyz}});
        }
    }
    else
    {
        $self->{Dest}=PDFStr($page);
    }

    return($self);
}

=back

=cut

1;
