package PDF::API2::NamedDestination;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
no warnings qw[ recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

use Encode qw(:all);

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::NamedDestination - Add named destination shortcuts to a PDF

=head1 METHODS

=over

=item $dest = PDF::API2::NamedDestination->new $pdf

=cut

sub new
{
    my ($class,$pdf) = @_;
    my ($self);

    $class = ref $class if ref $class;
    $self = $class->SUPER::new($pdf);

    $pdf->new_obj($self) unless($self->is_obj($pdf));

    return($self);
}

# Deprecated (warning added in 2.031)
sub new_api {
    my ($class, $api2, @options) = @_;
    warnings::warnif('deprecated', q{Call to deprecated method "new_api($api2, ...)".  Replace with "new($api2->{'pdf'}, ...)"});

    my $destination = $class->new($api2->{'pdf'}, @options);
    return $destination;
}

=item $dest->link $page, %opts

Defines the destination as launch-page with page $page and
options %opts (-rect, -border or 'dest-options').

=cut

sub link
{
    my ($self,$page,%opts)=@_;

    $self->{S}=PDFName('GoTo');
    $self->dest($page,%opts);

    return($self);
}

=item $dest->url $url, %opts

Defines the destination as launch-url with url $url and
options %opts (-rect and/or -border).

=cut

sub url
{
    my ($self,$url,%opts)=@_;

    $self->{S}=PDFName('URI');
    if(is_utf8($url))
    {
        # URI must be 7-bit ascii
        utf8::downgrade($url);
    }
    $self->{URI}=PDFStr($url);

    # this will come again -- since the utf8 urls are coming !
    # -- fredo
    #if(is_utf8($url) || utf8::valid($url)) {
    #    $self->{URI}=PDFUtf($url);
    #} else {
    #    $self->{URI}=PDFStr($url);
    #}
    return($self);
}

=item $dest->file $file, %opts

Defines the destination as launch-file with filepath $file and
options %opts (-rect and/or -border).

=cut

sub file
{
    my ($self,$url,%opts)=@_;

    $self->{S}=PDFName('Launch');
    if(is_utf8($url))
    {
        # URI must be 7-bit ascii
        utf8::downgrade($url);
    }
    $self->{F}=PDFStr($url);

    # this will come again -- since the utf8 urls are coming !
    # -- fredo
    #if(is_utf8($url) || utf8::valid($url)) {
    #    $self->{F}=PDFUtf($url);
    #} else {
    #    $self->{F}=PDFStr($url);
    #}
    return($self);
}

=item $dest->pdfile $pdfile, $pagenum, %opts

Defines the destination as pdf-file with filepath $pdfile, $pagenum
and options %opts (same as dest).

=cut

sub pdfile
{
    my ($self,$url,$pnum,%opts)=@_;

    $self->{S}=PDFName('GoToR');
    if(is_utf8($url))
    {
        # URI must be 7-bit ascii
        utf8::downgrade($url);
    }
    $self->{F}=PDFStr($url);

    # this will come again -- since the utf8 urls are coming !
    # -- fredo
    #if(is_utf8($url) || utf8::valid($url)) {
    #    $self->{F}=PDFUtf($url);
    #} else {
    #    $self->{F}=PDFStr($url);
    #}

    $self->dest(PDFNum($pnum),%opts);

    return($self);
}

=item $dest->dest( $page, -fit => 1 )

Display the page designated by page, with its contents magnified just enough to
fit the entire page within the window both horizontally and vertically. If the
required horizontal and vertical magnification factors are different, use the
smaller of the two, centering the page within the window in the other dimension.

=item $dest->dest( $page, -fith => $top )

Display the page designated by page, with the vertical coordinate top positioned
at the top edge of the window and the contents of the page magnified just enough
to fit the entire width of the page within the window.

=item $dest->dest( $page, -fitv => $left )

Display the page designated by page, with the horizontal coordinate left positioned
at the left edge of the window and the contents of the page magnified just enough
to fit the entire height of the page within the window.

=item $dest->dest( $page, -fitr => [ $left, $bottom, $right, $top ] )

Display the page designated by page, with its contents magnified just enough to
fit the rectangle specified by the coordinates left, bottom, right, and top
entirely within the window both horizontally and vertically. If the required
horizontal and vertical magnification factors are different, use the smaller of
the two, centering the rectangle within the window in the other dimension.

=item $dest->dest( $page, -fitb => 1 )

(PDF 1.1) Display the page designated by page, with its contents magnified just
enough to fit its bounding box entirely within the window both horizontally and
vertically. If the required horizontal and vertical magnification factors are
different, use the smaller of the two, centering the bounding box within the
window in the other dimension.

=item $dest->dest( $page, -fitbh => $top )

(PDF 1.1) Display the page designated by page, with the vertical coordinate top
positioned at the top edge of the window and the contents of the page magnified
just enough to fit the entire width of its bounding box within the window.

=item $dest->dest( $page, -fitbv => $left )

(PDF 1.1) Display the page designated by page, with the horizontal coordinate
left positioned at the left edge of the window and the contents of the page
magnified just enough to fit the entire height of its bounding box within the
window.

=item $dest->dest( $page, -xyz => [ $left, $top, $zoom ] )

Display the page designated by page, with the coordinates (left, top) positioned
at the top-left corner of the window and the contents of the page magnified by
the factor zoom. A zero (0) value for any of the parameters left, top, or zoom
specifies that the current value of that parameter is to be retained unchanged.

=cut

sub dest
{
    my ($self,$page,%opts)=@_;

    if(ref $page)
    {
        $opts{-xyz}=[undef,undef,undef] if(scalar(keys %opts)<1);

        if(defined $opts{-fit})
        {
            $self->{D}=PDFArray($page,PDFName('Fit'));
        }
        elsif(defined $opts{-fith})
        {
            $self->{D}=PDFArray($page,PDFName('FitH'),PDFNum($opts{-fith}));
        }
        elsif(defined $opts{-fitb})
        {
            $self->{D}=PDFArray($page,PDFName('FitB'));
        }
        elsif(defined $opts{-fitbh})
        {
            $self->{D}=PDFArray($page,PDFName('FitBH'),PDFNum($opts{-fitbh}));
        }
        elsif(defined $opts{-fitv})
        {
            $self->{D}=PDFArray($page,PDFName('FitV'),PDFNum($opts{-fitv}));
        }
        elsif(defined $opts{-fitbv})
        {
            $self->{D}=PDFArray($page,PDFName('FitBV'),PDFNum($opts{-fitbv}));
        }
        elsif(defined $opts{-fitr})
        {
            die "insufficient parameters to ->dest( page, -fitr => [] ) " unless(scalar @{$opts{-fitr}} == 4);
            $self->{D}=PDFArray($page,PDFName('FitR'),map {PDFNum($_)} @{$opts{-fitr}});
        }
        elsif(defined $opts{-xyz})
        {
            die "insufficient parameters to ->dest( page, -xyz => [] ) " unless(scalar @{$opts{-xyz}} == 3);
            $self->{D}=PDFArray($page,PDFName('XYZ'),map {defined $_ ? PDFNum($_) : PDFNull()} @{$opts{-xyz}});
        }
    }

    return($self);
}

=back

=cut

1;
