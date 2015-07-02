package PDF::API2;

our $VERSION = '2.023'; # VERSION

use Carp;
use Encode qw(:all);
use FileHandle;

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

use PDF::API2::Basic::PDF::File;
use PDF::API2::Basic::PDF::Pages;
use PDF::API2::Page;

use PDF::API2::Resource::XObject::Form::Hybrid;

use PDF::API2::Resource::ExtGState;
use PDF::API2::Resource::Pattern;
use PDF::API2::Resource::Shading;

use PDF::API2::NamedDestination;

no warnings qw[ deprecated recursion uninitialized ];

our @FontDirs = ( (map { "$_/PDF/API2/fonts" } @INC), 
                  qw[ /usr/share/fonts /usr/local/share/fonts c:/windows/fonts c:/winnt/fonts ] );

=head1 NAME

PDF::API2 - Facilitates the creation and modification of PDF files

=head1 SYNOPSIS

    use PDF::API2;

    # Create a blank PDF file
    $pdf = PDF::API2->new();

    # Open an existing PDF file
    $pdf = PDF::API2->open('some.pdf');

    # Add a blank page
    $page = $pdf->page();

    # Retrieve an existing page
    $page = $pdf->openpage($page_number);

    # Set the page size
    $page->mediabox('Letter');

    # Add a built-in font to the PDF
    $font = $pdf->corefont('Helvetica-Bold');

    # Add an external TTF font to the PDF
    $font = $pdf->ttfont('/path/to/font.ttf');

    # Add some text to the page
    $text = $page->text();
    $text->font($font, 20);
    $text->translate(200, 700);
    $text->text('Hello World!');

    # Save the PDF
    $pdf->saveas('/path/to/new.pdf');

=head1 GENERIC METHODS

=over

=item $pdf = PDF::API2->new(%options)

Creates a new PDF object.  If you will be saving it as a file and
already know the filename, you can give the '-file' option to minimize
possible memory requirements later on.

B<Example:>

    $pdf = PDF::API2->new();
    ...
    print $pdf->stringify();

    $pdf = PDF::API2->new();
    ...
    $pdf->saveas('our/new.pdf');

    $pdf = PDF::API2->new(-file => 'our/new.pdf');
    ...
    $pdf->save();

=cut

sub new {
    my ($class, %options) = @_;

    my $self = {};
    bless $self, $class;
    $self->{'pdf'} = PDF::API2::Basic::PDF::File->new();

    $self->{'pdf'}->{' version'} = 4;
    $self->{'pages'} = PDF::API2::Basic::PDF::Pages->new($self->{'pdf'});
    $self->{'pages'}->proc_set(qw(PDF Text ImageB ImageC ImageI));
    $self->{'pages'}->{'Resources'} ||= PDFDict();
    $self->{'pdf'}->new_obj($self->{'pages'}->{'Resources'}) unless $self->{'pages'}->{'Resources'}->is_obj($self->{'pdf'});
    $self->{'catalog'} = $self->{'pdf'}->{'Root'};
    $self->{'fonts'} = {};
    $self->{'pagestack'} = [];
    $self->{'forcecompress'} = $^O eq 'os390' ? 0 : 1;
    $self->preferences(%options);
    if ($options{'-file'}) {
        $self->{' filed'} = $options{'-file'};
        $self->{'pdf'}->create_file($options{'-file'});
    }
    $self->{'infoMeta'}=[qw(Author CreationDate ModDate Creator Producer Title Subject Keywords)];
    $self->info('Producer' => "PDF::API2 $VERSION [$^O]");

    return $self;
}

=item $pdf = PDF::API2->open($pdf_file)

Opens an existing PDF file.

B<Example:>

    $pdf = PDF::API2->open('our/old.pdf');
    ...
    $pdf->saveas('our/new.pdf');

    $pdf = PDF::API2->open('our/to/be/updated.pdf');
    ...
    $pdf->update();

=cut

sub open {
    my ($class, $file, %options) = @_;
    die "File '$file' does not exist." unless -f $file;
    die "File '$file' is not readable." unless -r $file;

    my $content;
    my $scalar_fh = FileHandle->new();
    CORE::open($scalar_fh, '+<', \$content) or die "Can't begin scalar IO";
    binmode $scalar_fh, ':raw';

    my $disk_fh = FileHandle->new();
    CORE::open($disk_fh, '<', $file);
    binmode $disk_fh, ':raw';
    $disk_fh->seek(0, 0);
    my $data;
    while (not $disk_fh->eof()) {
        $disk_fh->read($data, 512);
        $scalar_fh->print($data);
    }
    $disk_fh->close();
    $scalar_fh->seek(0, 0);

    my $self = $class->open_scalar($content, %options);
    $self->{'pdf'}->{' fname'} = $file;

    return $self;
}

=item $pdf = PDF::API2->open_scalar($pdf_string)

Opens a PDF contained in a string.

B<Example:>

    # Read a PDF into a string, for the purpose of demonstration
    open $fh, 'our/old.pdf' or die $@;
    undef $/;  # Read the whole file at once
    $pdf_string = <$fh>;

    $pdf = PDF::API2->open_scalar($pdf_string);
    ...
    $pdf->saveas('our/new.pdf');

=cut

# Deprecated (renamed)
sub openScalar { return open_scalar(@_); }

sub open_scalar {
    my ($class, $content, %options) = @_;

    my $self = {};
    bless $self, $class;
    foreach my $parameter (keys %options) {
        $self->default($parameter, $options{$parameter});
    }

    $self->{'content_ref'} = \$content;
    my $fh;
    CORE::open($fh, '+<', \$content) or die "Can't begin scalar IO";

    $self->{'pdf'} = PDF::API2::Basic::PDF::File->open($fh, 1);
    $self->{'pdf'}->{'Root'}->realise();
    $self->{'pages'} = $self->{'pdf'}->{'Root'}->{'Pages'}->realise();
    $self->{'pdf'}->{' version'} ||= 3;
    my @pages = proc_pages($self->{'pdf'}, $self->{'pages'});
    $self->{'pagestack'} = [sort { $a->{' pnum'} <=> $b->{' pnum'} } @pages];
    $self->{'catalog'} = $self->{'pdf'}->{'Root'};
    $self->{'reopened'} = 1;
    $self->{'forcecompress'} = $^O eq 'os390' ? 0 : 1;
    $self->{'fonts'} = {};
    $self->{'infoMeta'} = [qw(Author CreationDate ModDate Creator Producer Title Subject Keywords)];

    return $self;
}

=item $pdf->preferences(%options)

Controls viewing preferences for the PDF.

B<Page Mode Options:>

=over

=item -fullscreen

Full-screen mode, with no menu bar, window controls, or any other window visible.

=item -thumbs

Thumbnail images visible.

=item -outlines

Document outline visible.

=back

B<Page Layout Options:>

=over

=item -singlepage

Display one page at a time.

=item -onecolumn

Display the pages in one column.

=item -twocolumnleft

Display the pages in two columns, with oddnumbered pages on the left.

=item -twocolumnright

Display the pages in two columns, with oddnumbered pages on the right.

=back

B<Viewer Options:>

=over

=item -hidetoolbar

Specifying whether to hide tool bars.

=item -hidemenubar

Specifying whether to hide menu bars.

=item -hidewindowui

Specifying whether to hide user interface elements.

=item -fitwindow

Specifying whether to resize the document's window to the size of the displayed page.

=item -centerwindow

Specifying whether to position the document's window in the center of the screen.

=item -displaytitle

Specifying whether the window's title bar should display the
document title taken from the Title entry of the document information
dictionary.

=item -afterfullscreenthumbs

Thumbnail images visible after Full-screen mode.

=item -afterfullscreenoutlines

Document outline visible after Full-screen mode.

=item -printscalingnone

Set the default print setting for page scaling to none.

=back

B<Initial Page Options>:

=over

=item -firstpage => [ $page, %options ]

Specifying the page (either a page number or a page object) to be
displayed, plus one of the following options:

=over

=item -fit => 1

Display the page designated by page, with its contents magnified just
enough to fit the entire page within the window both horizontally and
vertically. If the required horizontal and vertical magnification
factors are different, use the smaller of the two, centering the page
within the window in the other dimension.

=item -fith => $top

Display the page designated by page, with the vertical coordinate top
positioned at the top edge of the window and the contents of the page
magnified just enough to fit the entire width of the page within the
window.

=item -fitv => $left

Display the page designated by page, with the horizontal coordinate
left positioned at the left edge of the window and the contents of the
page magnified just enough to fit the entire height of the page within
the window.

=item -fitr => [ $left, $bottom, $right, $top ]

Display the page designated by page, with its contents magnified just
enough to fit the rectangle specified by the coordinates left, bottom,
right, and top entirely within the window both horizontally and
vertically. If the required horizontal and vertical magnification
factors are different, use the smaller of the two, centering the
rectangle within the window in the other dimension.

=item -fitb => 1

Display the page designated by page, with its contents magnified just
enough to fit its bounding box entirely within the window both
horizontally and vertically. If the required horizontal and vertical
magnification factors are different, use the smaller of the two,
centering the bounding box within the window in the other dimension.

=item -fitbh => $top

Display the page designated by page, with the vertical coordinate top
positioned at the top edge of the window and the contents of the page
magnified just enough to fit the entire width of its bounding box
within the window.

=item -fitbv => $left

Display the page designated by page, with the horizontal coordinate
left positioned at the left edge of the window and the contents of the
page magnified just enough to fit the entire height of its bounding
box within the window.

=item -xyz => [ $left, $top, $zoom ]

Display the page designated by page, with the coordinates (left, top)
positioned at the top-left corner of the window and the contents of
the page magnified by the factor zoom. A zero (0) value for any of the
parameters left, top, or zoom specifies that the current value of that
parameter is to be retained unchanged.

=back

=back

B<Example:>

    $pdf->preferences(
        -fullscreen => 1,
        -onecolumn => 1,
        -afterfullscreenoutlines => 1,
        -firstpage => [$page, -fit => 1],
    );

=cut

sub preferences {
    my ($self, %options) = @_;

    # Page Mode Options
    if ($options{'-fullscreen'}) {
        $self->{'catalog'}->{'PageMode'} = PDFName('FullScreen');
    }
    elsif ($options{'-thumbs'}) {
        $self->{'catalog'}->{'PageMode'} = PDFName('UseThumbs');
    }
    elsif ($options{'-outlines'}) {
        $self->{'catalog'}->{'PageMode'} = PDFName('UseOutlines');
    }
    else {
        $self->{'catalog'}->{'PageMode'} = PDFName('UseNone');
    }

    # Page Layout Options
    if ($options{'-singlepage'}) {
        $self->{'catalog'}->{'PageLayout'} = PDFName('SinglePage');
    }
    elsif ($options{'-onecolumn'}) {
        $self->{'catalog'}->{'PageLayout'} = PDFName('OneColumn');
    }
    elsif ($options{'-twocolumnleft'}) {
        $self->{'catalog'}->{'PageLayout'} = PDFName('TwoColumnLeft');
    }
    elsif ($options{'-twocolumnright'}) {
        $self->{'catalog'}->{'PageLayout'} = PDFName('TwoColumnRight');
    }
    else {
        $self->{'catalog'}->{'PageLayout'} = PDFName('SinglePage');
    }

    # Viewer Preferences
    $self->{'catalog'}->{'ViewerPreferences'} ||= PDFDict();
    $self->{'catalog'}->{'ViewerPreferences'}->realise();

    if ($options{'-hidetoolbar'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'HideToolbar'} = PDFBool(1);
    }
    if ($options{'-hidemenubar'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'HideMenubar'} = PDFBool(1);
    }
    if ($options{'-hidewindowui'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'HideWindowUI'} = PDFBool(1);
    }
    if ($options{'-fitwindow'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'FitWindow'} = PDFBool(1);
    }
    if ($options{'-centerwindow'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'CenterWindow'} = PDFBool(1);
    }
    if ($options{'-displaytitle'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'DisplayDocTitle'} = PDFBool(1);
    }
    if ($options{'-righttoleft'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'Direction'} = PDFName('R2L');
    }

    if ($options{'-afterfullscreenthumbs'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'NonFullScreenPageMode'} = PDFName('UseThumbs');
    }
    elsif ($options{'-afterfullscreenoutlines'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'NonFullScreenPageMode'} = PDFName('UseOutlines');
    }
    else {
        $self->{'catalog'}->{'ViewerPreferences'}->{'NonFullScreenPageMode'} = PDFName('UseNone');
    }

    if ($options{'-printscalingnone'}) {
        $self->{'catalog'}->{'ViewerPreferences'}->{'PrintScaling'} = PDFName('None');
    }

    # Open Action
    if ($options{'-firstpage'}) {
        my ($page, %args) = @{$options{-firstpage}};
        $args{'-fit'} = 1 unless scalar keys %args;

        # $page can be either a page number (which needs to be wrapped
        # in PDFNum) or a page object (which doesn't).
        $page = PDFNum($page) unless ref($page);

        if (defined $args{'-fit'}) {
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('Fit'));
        }
        elsif (defined $args{'-fith'}) {
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('FitH'), PDFNum($args{'-fith'}));
        }
        elsif (defined $args{'-fitb'}) {
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('FitB'));
        }
        elsif (defined $args{'-fitbh'}) {
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('FitBH'), PDFNum($args{'-fitbh'}));
        }
        elsif (defined $args{'-fitv'}) {
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('FitV'), PDFNum($args{'-fitv'}));
        }
        elsif (defined $args{'-fitbv'}) {
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('FitBV'), PDFNum($args{'-fitbv'}));
        }
        elsif (defined $args{'-fitr'}) {
            croak 'insufficient parameters to -fitr => []' unless scalar @{$args{'-fitr'}} == 4;
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('FitR'), map { PDFNum($_) } @{$args{'-fitr'}});
        }
        elsif (defined $args{'-xyz'}) {
            croak 'insufficient parameters to -xyz => []' unless scalar @{$args{'-xyz'}} == 3;
            $self->{'catalog'}->{'OpenAction'} = PDFArray($page, PDFName('XYZ'), map { PDFNum($_) } @{$args{'-xyz'}});
        }
    }
    $self->{'pdf'}->out_obj($self->{'catalog'});

    return $self;
}

=item $val = $pdf->default($parameter)

=item $pdf->default($parameter, $value)

Gets/sets the default value for a behaviour of PDF::API2.

B<Supported Parameters:>

=over

=item nounrotate

prohibits API2 from rotating imported/opened page to re-create a
default pdf-context.

=item pageencaps

enables than API2 will add save/restore commands upon imported/opened
pages to preserve graphics-state for modification.

=item copyannots

enables importing of annotations (B<*EXPERIMENTAL*>).

=back

=cut

sub default {
    my ($self, $parameter, $value) = @_;

    # Parameter names may consist of lowercase letters, numbers, and underscores
    $parameter = lc $parameter;
    $parameter =~ s/[^a-z\d_]//g;

    my $previous_value = $self->{$parameter};
    if (defined $value) {
        $self->{$parameter} = $value;
    }
    return $previous_value;
}

=item $version = $pdf->version([$new_version])

Get/set the PDF version (e.g. 1.4)

=cut

sub version {
    my $self = shift();
    if (scalar @_) {
        my $version = shift();
        croak "Invalid version $version" unless $version =~ /^(?:1\.)?([0-9]+)$/;
        $self->{'pdf'}->{' version'} = $1;
    }
    return '1.' . $self->{'pdf'}->{' version'};
}

=item $bool = $pdf->isEncrypted()

Checks if the previously opened PDF is encrypted.

=cut

sub isEncrypted {
    my $self=shift @_;
    return(defined($self->{pdf}->{'Encrypt'}) ? 1 : 0);
}
    
=item %infohash = $pdf->info(%infohash)

Gets/sets the info structure of the document.

B<Example:>

    %h = $pdf->info(
        'Author'       => "Alfred Reibenschuh",
        'CreationDate' => "D:20020911000000+01'00'",
        'ModDate'      => "D:YYYYMMDDhhmmssOHH'mm'",
        'Creator'      => "fredos-script.pl",
        'Producer'     => "PDF::API2",
        'Title'        => "some Publication",
        'Subject'      => "perl ?",
        'Keywords'     => "all good things are pdf"
    );
    print "Author: $h{Author}\n";

=cut

sub info {
    my $self=shift @_;
    my %opt=@_;

    if(!defined($self->{pdf}->{'Info'})) {
            $self->{pdf}->{'Info'}=PDFDict();
            $self->{pdf}->new_obj($self->{'pdf'}->{'Info'});
    } else {
        $self->{pdf}->{'Info'}->realise;
    }

    if(scalar @_) {
      foreach my $k (@{$self->{infoMeta}}) {
        next unless(defined $opt{$k});
        if(is_utf8($opt{$k})) {
            $self->{pdf}->{'Info'}->{$k}=PDFUtf($opt{$k}||'NONE');
        #} elsif(is_utf8($opt{$k}) || utf8::valid($opt{$k})) {
        #    $self->{pdf}->{'Info'}->{$k}=PDFUtf($opt{$k}||'NONE');
        } else {
            $self->{pdf}->{'Info'}->{$k}=PDFStr($opt{$k}||'NONE');
        }
      }
      $self->{pdf}->out_obj($self->{pdf}->{'Info'});
    }


    if(defined $self->{pdf}->{'Info'}) {
      %opt=();
      foreach my $k (@{$self->{infoMeta}}) {
        next unless(defined $self->{pdf}->{'Info'}->{$k});
        $opt{$k}=$self->{pdf}->{'Info'}->{$k}->val;
        if ((unpack('n',$opt{$k})==0xfffe) or (unpack('n',$opt{$k})==0xfeff)) 
        {
            $opt{$k} = decode('UTF-16', $self->{pdf}->{'Info'}->{$k}->val);
        }
      }
  }
  return(%opt);
}

=item @metadata_attributes = $pdf->infoMetaAttributes(@metadata_attributes)

Gets/sets the supported info-structure tags.

B<Example:>

    @attributes = $pdf->infoMetaAttributes;
    print "Supported Attributes: @attr\n";

    @attributes = $pdf->infoMetaAttributes('CustomField1');
    print "Supported Attributes: @attributes\n";

=cut

sub infoMetaAttributes 
{
    my ($self,@attr) = @_;
    if(scalar @attr > 0) {
        my %at = map { $_ => $_ } (@{$self->{infoMeta}},@attr);
        @{$self->{infoMeta}}=(keys %at);
    }
    return(@{$self->{infoMeta}});
}

=item $xml = $pdf->xmpMetadata($xml)

Gets/sets the XMP XML data stream.

B<Example:>

    $xml = $pdf->xmpMetadata();
    print "PDFs Metadata reads: $xml\n";
    $xml=<<EOT;
    <?xpacket begin='' id='W5M0MpCehiHzreSzNTczkc9d'?>
    <?adobe-xap-filters esc="CRLF"?>
    <x:xmpmeta
      xmlns:x='adobe:ns:meta/'
      x:xmptk='XMP toolkit 2.9.1-14, framework 1.6'>
        <rdf:RDF
          xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
          xmlns:iX='http://ns.adobe.com/iX/1.0/'>
            <rdf:Description
              rdf:about='uuid:b8659d3a-369e-11d9-b951-000393c97fd8'
              xmlns:pdf='http://ns.adobe.com/pdf/1.3/'
              pdf:Producer='Acrobat Distiller 6.0.1 for Macintosh'></rdf:Description>
            <rdf:Description
              rdf:about='uuid:b8659d3a-369e-11d9-b951-000393c97fd8'
              xmlns:xap='http://ns.adobe.com/xap/1.0/'
              xap:CreateDate='2004-11-14T08:41:16Z'
              xap:ModifyDate='2004-11-14T16:38:50-08:00'
              xap:CreatorTool='FrameMaker 7.0'
              xap:MetadataDate='2004-11-14T16:38:50-08:00'></rdf:Description>
            <rdf:Description
              rdf:about='uuid:b8659d3a-369e-11d9-b951-000393c97fd8'
              xmlns:xapMM='http://ns.adobe.com/xap/1.0/mm/'
              xapMM:DocumentID='uuid:919b9378-369c-11d9-a2b5-000393c97fd8'/></rdf:Description>
            <rdf:Description
              rdf:about='uuid:b8659d3a-369e-11d9-b951-000393c97fd8'
              xmlns:dc='http://purl.org/dc/elements/1.1/'
              dc:format='application/pdf'>
                <dc:description>
                  <rdf:Alt>
                    <rdf:li xml:lang='x-default'>Adobe Portable Document Format (PDF)</rdf:li>
                  </rdf:Alt>
                </dc:description>
                <dc:creator>
                  <rdf:Seq>
                    <rdf:li>Adobe Systems Incorporated</rdf:li>
                  </rdf:Seq>
                </dc:creator>
                <dc:title>
                  <rdf:Alt>
                    <rdf:li xml:lang='x-default'>PDF Reference, version 1.6</rdf:li>
                  </rdf:Alt>
                </dc:title>
            </rdf:Description>
        </rdf:RDF>
    </x:xmpmeta>
    <?xpacket end='w'?>
    EOT

    $xml = $pdf->xmpMetadata($xml);
    print "PDF metadata now reads: $xml\n";

=cut

sub xmpMetadata {
    my $self=shift @_;

    if(!defined($self->{catalog}->{Metadata})) 
    {
            $self->{catalog}->{Metadata}=PDFDict();
            $self->{catalog}->{Metadata}->{Type}=PDFName('Metadata');
            $self->{catalog}->{Metadata}->{Subtype}=PDFName('XML');
            $self->{pdf}->new_obj($self->{catalog}->{Metadata});
    } 
    else 
    {
        $self->{catalog}->{Metadata}->realise;
        $self->{catalog}->{Metadata}->{' stream'}=unfilter($self->{catalog}->{Metadata}->{Filter}, $self->{catalog}->{Metadata}->{' stream'});
        delete $self->{catalog}->{Metadata}->{' nofilt'};
        delete $self->{catalog}->{Metadata}->{Filter};
    }
    
    my $md=$self->{catalog}->{Metadata};
    
    if(defined $_[0])
    {
        $md->{' stream'}=$_[0];
        delete $md->{Filter};
        delete $md->{' nofilt'};
        $self->{pdf}->out_obj($md);
        $self->{pdf}->out_obj($self->{catalog});
    }
    return($md->{' stream'});
}

=item $pdf->pageLabel($index, $options)

Sets page label options.

B<Supported Options:>

=over

=item -style

Roman, roman, decimal, Alpha or alpha.

=item -start

Restart numbering at given number.

=item -prefix

Text prefix for numbering.

=back

B<Example:>

    # Start with Roman Numerals
    $pdf->pageLabel(0, {
        -style => 'roman',
    });

    # Switch to Arabic
    $pdf->pageLabel(4, {
        -style => 'decimal',
    });

    # Numbering for Appendix A
    $pdf->pageLabel(32, {
        -start => 1,
        -prefix => 'A-'
    });
    
    # Numbering for Appendix B
    $pdf->pageLabel( 36, {
        -start => 1,
        -prefix => 'B-'
    });
    
    # Numbering for the Index
    $pdf->pageLabel(40, {
        -style => 'Roman'
        -start => 1,
        -prefix => 'Index '
    });

=cut

sub pageLabel {
    my $self = shift();

    $self->{'catalog'}->{'PageLabels'} ||= PDFDict();
    $self->{'catalog'}->{'PageLabels'}->{'Nums'} ||= PDFArray();

    my $nums = $self->{'catalog'}->{'PageLabels'}->{'Nums'};
    while (scalar @_) {
        my $index = shift();
        my $opts = shift();

        $nums->add_elements(PDFNum($index));

        my $d = PDFDict();
        $d->{'S'} = PDFName($opts->{'-style'} eq 'Roman' ? 'R' :
                            $opts->{'-style'} eq 'roman' ? 'r' :
                            $opts->{'-style'} eq 'Alpha' ? 'A' :
                            $opts->{'-style'} eq 'alpha' ? 'a' : 'D');
                          
        if (defined $opts->{'-prefix'}) {
            $d->{'P'} = PDFStr($opts->{'-prefix'});
        }

        if (defined $opts->{'-start'}) {
            $d->{'St'} = PDFNum($opts->{'-start'});
        }

        $nums->add_elements($d);
    }
}

=item $pdf->finishobjects(@objects)

Force objects to be written to file if possible.

B<Example:>

    $pdf = PDF::API2->new(-file => 'our/new.pdf');
    ...
    $pdf->finishobjects($page, $gfx, $txt);
    ...
    $pdf->save();

=cut

sub finishobjects {
    my ($self,@objs)=@_;
    if($self->{reopened}) {
        die "invalid method invokation: no file, use 'saveas' instead.";
    } elsif($self->{' filed'}) {
        $self->{pdf}->ship_out(@objs);
    } else {
        die "invalid method invokation: no file, use 'saveas' instead.";
    }
}

sub proc_pages {
    my ($pdf, $object) = @_;

    if (defined $object->{'Resources'}) {
        eval {
            $object->{'Resources'}->realise();
        };
    }

    my @pages;
    $pdf->{' apipagecount'} ||= 0;
    foreach my $page ($object->{'Kids'}->elementsof()) {
        $page->realise();
        if ($page->{'Type'}->val() eq 'Pages') {
            push @pages, proc_pages($pdf, $page);
        }
        else {
            $pdf->{' apipagecount'}++;
            $page->{' pnum'} = $pdf->{' apipagecount'};
            if (defined $page->{'Resources'}) {
                eval {
                    $page->{'Resources'}->realise();
                };
            }
            push @pages, $page;
        }
    }

    return @pages;
}

=item $pdf->update()

Saves a previously opened document.

B<Example:>

    $pdf = PDF::API2->open('our/to/be/updated.pdf');
    ...
    $pdf->update();

=cut

sub update {
    my $self=shift @_;
    $self->saveas($self->{pdf}->{' fname'});
}

=item $pdf->saveas($file)

Save the document to $file and remove the object structure from memory.

B<Example:>

    $pdf = PDF::API2->new();
    ...
    $pdf->saveas('our/new.pdf');

=cut

sub saveas {
    my ($self,$file)=@_;
    if($self->{reopened}) {
        $self->{pdf}->append_file;
        CORE::open(OUTF,">$file");
        binmode(OUTF,':raw');
        print OUTF ${$self->{content_ref}};
        CORE::close(OUTF);
    } elsif($self->{' filed'}) {
        $self->{pdf}->close_file;
    } else {
        $self->{pdf}->out_file($file);
    }
    $self->end;
}

sub save {
    my ($self,$file)=@_;
    if($self->{reopened}) {
        die "invalid method invokation: use 'saveas' instead.";
    } elsif($self->{' filed'}) {
        $self->{pdf}->close_file;
    } else {
        die "invalid method invokation: use 'saveas' instead.";
    }
    $self->end;
}

=item $string = $pdf->stringify()

Return the document as a string and remove the object structure from memory.

B<Example:>

    $pdf = PDF::API2->new();
    ...
    print $pdf->stringify();

=cut

# Maintainer's note: The object is being destroyed because it contains
# circular references that would otherwise result in memory not being
# freed if the object merely goes out of scope.  If possible, the
# circular references should be eliminated so that stringify doesn't
# need to be destructive.
#
# I've opted not to just require a separate call to release() because
# it would likely introduce memory leaks in many existing programs
# that use this module.

sub stringify {
    my ($self)=@_;
    my $str;
    if((defined $self->{reopened}) && ($self->{reopened}==1)) {
        $self->{pdf}->append_file;
        $str=${$self->{content_ref}};
    } else {
        my $fh = new FileHandle;
        CORE::open($fh, ">", \$str) || die "Can't begin scalar IO";
        $self->{pdf}->out_file($fh);
        $fh->close;
    }
    $self->end;
    return($str);
}

sub release { $_[0]->end; return(undef);}

=item $pdf->end()

Remove the object structure from memory.  PDF::API2 contains circular
references, so this call is necessary in long-running processes to
keep from running out of memory.

This will be called automatically when you save or stringify a PDF.
You should only need to call it explicitly if you are reading PDF
files and not writing them.

=cut

sub end {
    my $self=shift(@_);
    $self->{pdf}->release if(defined($self->{pdf}));

        foreach my $key (keys %{$self})
        {
            $self->{$key}=undef;
            delete ($self->{$key});
        }

    undef;
}

=back

=head1 PAGE METHODS

=over

=item $page = $pdf->page()

=item $page = $pdf->page($page_number)

Returns a new page object.  By default, the page is added to the end
of the document.  If you include an existing page number, the new page
will be inserted in that position, pushing existing pages back.

$page_number can also have one of the following values:

=over

=item -1 inserts the new page as the second-last page

=item 0 inserts the page as the last page

=back

B<Example:>

    $pdf = PDF::API2->new();

    # Add a page.  This becomes page 1.
    $page = $pdf->page();

    # Add a new first page.  $page becomes page 2.
    $another_page = $pdf->page(1);

=cut

sub page {
    my $self=shift;
    my $index=shift || 0;
    my $page;
    if($index==0) {
        $page=PDF::API2::Page->new($self->{pdf},$self->{pages});
    } else {
        $page=PDF::API2::Page->new($self->{pdf},$self->{pages},$index-1);
    }
    $page->{' apipdf'}=$self->{pdf};
    $page->{' api'}=$self;
    $self->{pdf}->out_obj($page);
    $self->{pdf}->out_obj($self->{pages});
    if($index==0) {
        push(@{$self->{pagestack}},$page);
    } elsif($index<0) {
        splice(@{$self->{pagestack}},$index,0,$page);
    } else {
        splice(@{$self->{pagestack}},$index-1,0,$page);
    }
 #   $page->{Resources}=$self->{pages}->{Resources};
    return $page;
}

=item $page = $pdf->openpage($page_number)

Returns the L<PDF::API2::Page> object of page $page_number.

If $page_number is 0 or -1, it will return the last page in the
document.

B<Example:>

    $pdf = PDF::API2->open('our/99page.pdf');
    $page = $pdf->openpage(1);   # returns the first page
    $page = $pdf->openpage(99);  # returns the last page
    $page = $pdf->openpage(-1);  # returns the last page
    $page = $pdf->openpage(999); # returns undef

=cut

sub openpage {
    my $self=shift @_;
    my $index=shift @_||0;
    my ($page,$rotate,$media,$trans);

    if($index==0) 
    {
        $page=$self->{pagestack}->[-1];
    } 
    elsif($index<0) 
    {
        $page=$self->{pagestack}->[$index];
    } 
    else 
    {
        $page=$self->{pagestack}->[$index-1];
    }
    return undef unless(ref $page);
    
    if(ref($page) ne 'PDF::API2::Page') 
    {
        bless($page,'PDF::API2::Page');
        $page->{' apipdf'}=$self->{pdf};
        $page->{' api'}=$self;
        $self->{pdf}->out_obj($page);
        if(($rotate=$page->find_prop('Rotate')) && (!defined($page->{' fixed'}) || $page->{' fixed'}<1)) 
        {
            $rotate=($rotate->val+360)%360;

            if($rotate!=0 && !$self->default('nounrotate')) {
                $page->{Rotate}=PDFNum(0);
                foreach my $mediatype (qw( MediaBox CropBox BleedBox TrimBox ArtBox )) {
                    if($media=$page->find_prop($mediatype)) {
                        $media=[ map{ $_->val } $media->elementsof ];
                    } else {
                        $media=[0,0,612,792];
                        next if($mediatype ne 'MediaBox');
                    }
                    if($rotate==90) {
                        $trans="0 -1 1 0 0 $media->[2] cm" if($mediatype eq 'MediaBox');
                        $media=[$media->[1],$media->[0],$media->[3],$media->[2]];
                    } elsif($rotate==180) {
                        $trans="-1 0 0 -1 $media->[2] $media->[3] cm" if($mediatype eq 'MediaBox');
                    } elsif($rotate==270) {
                        $trans="0 1 -1 0 $media->[3] 0 cm" if($mediatype eq 'MediaBox');
                        $media=[$media->[1],$media->[0],$media->[3],$media->[2]];
                    }
                    $page->{$mediatype}=PDFArray(map { PDFNum($_) } @{$media});
                }
            } else {
                $trans="";
            }
        } else {
            $trans="";
        }

        if(defined $page->{Contents} && (!defined($page->{' fixed'}) || $page->{' fixed'}<1) ) {
            $page->fixcontents;
            my $uncontent=$page->{Contents};
            delete $page->{Contents};
            my $content=$page->gfx();
            $content->add(" $trans ");

            if($self->default('pageencaps'))
            {
                $content->{' stream'}.=" q ";
            }
            foreach my $k ($uncontent->elementsof) 
            {
                $k->realise;
                    $content->{' stream'}.=" ".unfilter($k->{Filter}, $k->{' stream'})." ";
            }
            if($self->default('pageencaps'))
            {
                $content->{' stream'}.=" Q ";
            }

            ## $content->{Length}=PDFNum(length($content->{' stream'}));
            # this  will be fixed by the following code or content or filters

            ## if we like compress we will do it now to do quicker saves
            if($self->{forcecompress}>0){
            ##    $content->compressFlate;
                $content->{' stream'}=dofilter($content->{Filter}, $content->{' stream'});
                $content->{' nofilt'}=1;
                delete $content->{-docompress};
                $content->{Length}=PDFNum(length($content->{' stream'}));
            }
            $page->{' fixed'}=1;
        }
    }

    $self->{pdf}->out_obj($page);
    $self->{pdf}->out_obj($self->{pages});
    $page->{' apipdf'}=$self->{pdf};
    $page->{' api'}=$self;
    $page->{' reopened'}=1;
    return($page);
}


# $target_object = walk_obj $obj_cache, $source_pdf, $target_pdf, $source_object [, @keys_to_copy ]

sub walk_obj {
    my ($objs,$spdf,$tpdf,$obj,@keys)=@_;

    my $tobj;


    if(ref($obj)=~/Objind$/) {
        $obj->realise;
    }

    return($objs->{scalar $obj}) if(defined $objs->{scalar $obj});
####die "infinite loop while copying objects" if($obj->{' copied'});

    $tobj=$obj->copy($spdf); ## thanks to: yaheath // Fri, 17 Sep 2004
    
####$obj->{' copied'}=1;
    $tpdf->new_obj($tobj) if($obj->is_obj($spdf));

    $objs->{scalar $obj}=$tobj;

    if(ref($obj)=~/Array$/) {
        $tobj->{' val'}=[];
        foreach my $k ($obj->elementsof) {
            $k->realise if(ref($k)=~/Objind$/);
            $tobj->add_elements(walk_obj($objs,$spdf,$tpdf,$k));
        }
    } elsif(ref($obj)=~/Dict$/) {
        @keys=keys(%{$tobj}) if(scalar @keys <1);
        foreach my $k (@keys) {
            next if($k=~/^ /);
            next unless(defined($obj->{$k}));
            $tobj->{$k}=walk_obj($objs,$spdf,$tpdf,$obj->{$k});
        }
        if($obj->{' stream'}) {
            if($tobj->{Filter}) {
                $tobj->{' nofilt'}=1;
            } else {
                delete $tobj->{' nofilt'};
                $tobj->{Filter}=PDFArray(PDFName('FlateDecode'));
            }
            $tobj->{' stream'}=$obj->{' stream'};
        }
    }
    delete $tobj->{' streamloc'};
    delete $tobj->{' streamsrc'};
    return($tobj);
}

=item $xoform = $pdf->importPageIntoForm($source_pdf, $source_page_number)

Returns a Form XObject created by extracting the specified page from $source_pdf.

This is useful if you want to transpose the imported page somewhat
differently onto a page (e.g. two-up, four-up, etc.).

If $source_page_number is 0 or -1, it will return the last page in the
document.

B<Example:>

    $pdf = PDF::API2->new();
    $old = PDF::API2->open('our/old.pdf');
    $page = $pdf->page();
    $gfx = $page->gfx();

    # Import Page 2 from the old PDF
    $xo = $pdf->importPageIntoForm($old, 2);

    # Add it to the new PDF's first page at 1/2 scale
    $gfx->formimage($xo, 0, 0, 0.5); 

    $pdf->saveas('our/new.pdf');

B<Note:> You can only import a page from an existing PDF file.

=cut

sub importPageIntoForm {
    my $self=shift @_;
    my $s_pdf=shift @_;
    my $s_idx=shift @_||0;

    unless (ref($s_pdf) and $s_pdf->isa('PDF::API2')) {
        die "Invalid usage: 1st argument must be PDF::API2 instance, not: " . ref($s_pdf);
    }

    my ($s_page,$xo);

    $xo=$self->xo_form;

    if(ref($s_idx) eq 'PDF::API2::Page') {
        $s_page=$s_idx;
    } else {
        $s_page=$s_pdf->openpage($s_idx);
    }

    $self->{apiimportcache}||={};
    $self->{apiimportcache}->{$s_pdf}||={};

    foreach my $k (qw( MediaBox ArtBox TrimBox BleedBox CropBox )) {
        #next unless(defined $s_page->{$k});
        #my $box = walk_obj($self->{apiimportcache}->{$s_pdf},$s_pdf->{pdf},$self->{pdf},$s_page->{$k});
        next unless(defined $s_page->find_prop($k));
        my $box = walk_obj($self->{apiimportcache}->{$s_pdf},$s_pdf->{pdf},$self->{pdf},$s_page->find_prop($k));
        $xo->bbox(map { $_->val } $box->elementsof);
        last;
    }
    $xo->bbox( 0, 0, 612, 792) unless(defined $xo->{BBox});

    foreach my $k (qw( Resources )) {
        $s_page->{$k}=$s_page->find_prop($k);
        next unless(defined $s_page->{$k});
        $s_page->{$k}->realise if(ref($s_page->{$k})=~/Objind$/);

        foreach my $sk (qw( XObject ExtGState Font ProcSet Properties ColorSpace Pattern Shading )) {
            next unless(defined $s_page->{$k}->{$sk});
            $s_page->{$k}->{$sk}->realise if(ref($s_page->{$k}->{$sk})=~/Objind$/);
            foreach my $ssk (keys %{$s_page->{$k}->{$sk}}) {
                next if($ssk=~/^ /);
                $xo->resource($sk,$ssk,walk_obj($self->{apiimportcache}->{$s_pdf},$s_pdf->{pdf},$self->{pdf},$s_page->{$k}->{$sk}->{$ssk}));
            }
        }
    }

    # create a whole content stream
    ## technically it is possible to submit an unfinished
    ## (eg. newly created) source-page, but thats non-sense,
    ## so we expect a page fixed by openpage and die otherwise
    die "page not processed via openpage ... " unless($s_page->{' fixed'}==1);

    # since the source page comes from openpage it may already
    # contain the required starting 'q' without the final 'Q'
    # if forcecompress is in effect
    if(defined $s_page->{Contents}) {
        $s_page->fixcontents;

        $xo->{' stream'}="";
        # openpage pages only contain one stream
        my ($k)=$s_page->{Contents}->elementsof;
        $k->realise;
        if($k->{' nofilt'}) {
          # we have a finished stream here
          # so we unfilter
          $xo->add('q',unfilter($k->{Filter}, $k->{' stream'}),'Q');
        } else {
          # stream is an unfinished/unfiltered content
          # so we just copy it and add the required "qQ"
            $xo->add('q',$k->{' stream'},'Q');
        }
        $xo->compressFlate if($self->{forcecompress}>0);
    }

    return($xo);
}

=item $page = $pdf->import_page($source_pdf, $source_page_number, $target_page_number)

Imports a page from $source_pdf and adds it to the specified position
in $pdf.

If $source_page_number or $target_page_number is 0 or -1, the last
page in the document is used.

B<Note:> If you pass a page object instead of a page number for
$target_page_number, the contents of the page will be merged into the
existing page.

B<Example:>

    $pdf = PDF::API2->new();
    $old = PDF::API2->open('our/old.pdf');

    # Add page 2 from the old PDF as page 1 of the new PDF
    $page = $pdf->import_page($old, 2);

    $pdf->saveas('our/new.pdf');

B<Note:> You can only import a page from an existing PDF file.

=cut

# Deprecated (renamed)
sub importpage { import_page(@_); }

sub import_page {
    my $self=shift @_;
    my $s_pdf=shift @_;
    my $s_idx=shift @_||0;
    my $t_idx=shift @_||0;
    my ($s_page,$t_page);

    unless (ref($s_pdf) and $s_pdf->isa('PDF::API2')) {
        die "Invalid usage: 1st argument must be PDF::API2 instance, not: " . ref($s_pdf);
    }
	
    if(ref($s_idx) eq 'PDF::API2::Page') {
        $s_page=$s_idx;
    } else {
        $s_page=$s_pdf->openpage($s_idx);
    }

    if(ref($t_idx) eq 'PDF::API2::Page') {
        $t_page=$t_idx;
    } else {
        if($self->pages<$t_idx) {
            $t_page=$self->page;
        } else {
            $t_page=$self->page($t_idx);
        }
    }

    $self->{apiimportcache}=$self->{apiimportcache}||{};
    $self->{apiimportcache}->{$s_pdf}=$self->{apiimportcache}->{$s_pdf}||{};

    # we now import into a form to keep
    # all that nasty resources from polluting
    # our very own resource naming space.
    my $xo = $self->importPageIntoForm($s_pdf,$s_page);
    $t_page->mediabox( map { $_->val } $xo->{BBox}->elementsof) if(defined $xo->{BBox});
    $t_page->gfx->formimage($xo,0,0,1);

    # copy annotations and/or form elements as well
    if (exists $s_page->{Annots} and $s_page->{Annots} and $self->{copyannots}) {

            # first set up the AcroForm, if required
            my $AcroForm;
            if (my $a = $s_pdf->{pdf}->{Root}->realise->{AcroForm}) {
                    $a->realise;

                    $AcroForm = walk_obj({},$s_pdf->{pdf},$self->{pdf},$a,qw( NeedAppearances SigFlags CO DR DA Q ));
            }
            my @Fields = ();
            my @Annots = ();
            foreach my $a ($s_page->{Annots}->elementsof) {
                    $a->realise;
                    my $t_a = PDFDict();
                    $self->{pdf}->new_obj($t_a);
                    # these objects are likely to be both annotations and Acroform fields
                    # key names are copied from PDF Reference 1.4 (Tables)
                    my @k = (
                            qw( Type Subtype Contents P Rect NM M F BS Border AP AS C CA T Popup A AA StructParent Rotate
                            ),                                      # Annotations - Common (8.10)
                            qw( Subtype Contents Open Name ),       # Text Annotations (8.15)
                            qw( Subtype Contents Dest H PA ),       # Link Annotations (8.16)
                            qw( Subtype Contents DA Q ),            # Free Text Annotations (8.17)
                            qw( Subtype Contents L BS LE IC ) ,     # Line Annotations (8.18)
                            qw( Subtype Contents BS IC ),           # Square and Circle Annotations (8.20)
                            qw( Subtype Contents QuadPoints ),      # Markup Annotations (8.21)
                            qw( Subtype Contents Name ),            # Rubber Stamp Annotations (8.22)
                            qw( Subtype Contents InkList BS ),      # Ink Annotations (8.23)
                            qw( Subtype Contents Parent Open ),     # Popup Annotations (8.24)
                            qw( Subtype FS Contents Name ),         # File Attachment Annotations (8.25)
                            qw( Subtype Sound Contents Name ),      # Sound Annotations (8.26)
                            qw( Subtype Movie Contents A ),         # Movie Annotations (8.27)
                            qw( Subtype Contents H MK ),            # Widget Annotations (8.28)
                                                                    # Printers Mark Annotations (none)
                                                                    # Trap Network Annotations (none)
                    );
                    push @k, (
                            qw( Subtype FT Parent Kids T TU TM Ff V DV AA
                            ),                                      # Fields - Common (8.49)
                            qw( DR DA Q ),                          # Fields containing variable text (8.51)
                            qw( Opt ),                              # Checkbox field (8.54)
                            qw( Opt ),                              # Radio field (8.55)
                            qw( MaxLen ),                           # Text field (8.57)
                            qw( Opt TI I ),                         # Choice field (8.59)
                    ) if $AcroForm;
                    # sorting out dups
                    my %ky=map { $_ => 1 } @k;
                    # we do P separately, as it points to the page the Annotation is on
                    delete $ky{P};
                    # copy everything else
                    foreach my $k (keys %ky) {
                            next unless defined $a->{$k};
                            $a->{$k}->realise;
                            $t_a->{$k} = walk_obj({},$s_pdf->{pdf},$self->{pdf},$a->{$k});
                    }
                    $t_a->{P} = $t_page;
                    push @Annots, $t_a;
                    push @Fields, $t_a if ($AcroForm and $t_a->{Subtype}->val eq 'Widget');
            }
            $t_page->{Annots} = PDFArray(@Annots);
            $AcroForm->{Fields} = PDFArray(@Fields) if $AcroForm;
            $self->{pdf}->{Root}->{AcroForm} = $AcroForm;
    }
    $t_page->{' imported'} = 1;

    $self->{pdf}->out_obj($t_page);
    $self->{pdf}->out_obj($self->{pages});

    return($t_page);
}

=item $count = $pdf->pages()

Returns the number of pages in the document.

=cut

sub pages {
    my $self=shift @_;
    return scalar @{$self->{pagestack}};
}

=item $pdf->mediabox($name)

=item $pdf->mediabox($w, $h)

=item $pdf->mediabox($llx, $lly, $urx, $ury)

Sets the global mediabox.

B<Example:>

    $pdf = PDF::API2->new();
    $pdf->mediabox('A4');
    ...
    $pdf->saveas('our/new.pdf');

    $pdf = PDF::API2->new();
    $pdf->mediabox(595, 842);
    ...
    $pdf->saveas('our/new.pdf');

    $pdf = PDF::API2->new;
    $pdf->mediabox(0, 0, 595, 842);
    ...
    $pdf->saveas('our/new.pdf');

=cut

sub mediabox {
    my ($self,$x1,$y1,$x2,$y2) = @_;
    $self->{pages}->{'MediaBox'}=PDFArray( map { PDFNum(float($_)) } page_size($x1,$y1,$x2,$y2) );
    $self;
}

=item $pdf->cropbox($name)

=item $pdf->cropbox($w, $h)

=item $pdf->cropbox($llx, $lly, $urx, $ury)

Sets the global cropbox.

=cut

sub cropbox {
    my ($self,$x1,$y1,$x2,$y2) = @_;
    $self->{pages}->{'CropBox'}=PDFArray( map { PDFNum(float($_)) } page_size($x1,$y1,$x2,$y2) );
    $self;
}

=item $pdf->bleedbox($name)

=item $pdf->bleedbox($w, $h)

=item $pdf->bleedbox($llx, $lly, $urx, $ury)

Sets the global bleedbox.

=cut

sub bleedbox {
    my ($self,$x1,$y1,$x2,$y2) = @_;
    $self->{pages}->{'BleedBox'}=PDFArray( map { PDFNum(float($_)) } page_size($x1,$y1,$x2,$y2) );
    $self;
}

=item $pdf->trimbox($name)

=item $pdf->trimbox($w, $h)

=item $pdf->trimbox($llx, $lly, $urx, $ury)

Sets the global trimbox.

=cut

sub trimbox {
    my ($self,$x1,$y1,$x2,$y2) = @_;
    $self->{pages}->{'TrimBox'}=PDFArray( map { PDFNum(float($_)) } page_size($x1,$y1,$x2,$y2) );
    $self;
}

=item $pdf->artbox($name)

=item $pdf->artbox($w, $h)

=item $pdf->artbox($llx, $lly, $urx, $ury)

Sets the global artbox.

=cut

sub artbox {
    my ($self,$x1,$y1,$x2,$y2) = @_;
    $self->{pages}->{'ArtBox'}=PDFArray( map { PDFNum(float($_)) } page_size($x1,$y1,$x2,$y2) );
    $self;
}

=back

=head1 FONT METHODS

=over

=item @directories = PDF::API2::addFontDirs($dir1, $dir2, ...)

Adds one or more directories to the search path for finding font
files.

Returns the list of searched directories.

=cut

sub addFontDirs {
    push( @FontDirs, @_ );
    return( @FontDirs );
}

sub _findFont {
    my $font=shift @_;
    my @fonts=($font,map { "$_/$font" } @FontDirs);
    while((scalar @fonts > 0) && (! -f $fonts[0])) { shift @fonts; }
    return($fonts[0]);
}

=item $font = $pdf->corefont($fontname, [%options])

Returns a new Adobe core font object.

B<Examples:>

    $font = $pdf->corefont('Times-Roman');
    $font = $pdf->corefont('Times-Bold');
    $font = $pdf->corefont('Helvetica');
    $font = $pdf->corefont('ZapfDingbats');

Valid %options are:

=over

=item -encode

Changes the encoding of the font from its default.

=item -dokern

Enables kerning if data is available.

=back

See Also: L<PDF::API2::Resource::Font::CoreFont>.

=cut

sub corefont {
    my ($self,$name,@opts)=@_;
    require PDF::API2::Resource::Font::CoreFont;
    my $obj=PDF::API2::Resource::Font::CoreFont->new_api($self,$name,@opts);
    $self->resource('Font',$obj->name,$obj);
    $self->{pdf}->out_obj($self->{pages});
    $obj->tounicodemap if($opts{-unicodemap}==1);
    return($obj);
}

=item $font = $pdf->psfont($ps_file, [%options])

Returns a new Adobe Type1 font object.

B<Examples:>

    $font = $pdf->psfont('Times-Book.pfa', -afmfile => 'Times-Book.afm');
    $font = $pdf->psfont('/fonts/Synest-FB.pfb', -pfmfile => '/fonts/Synest-FB.pfm');

Valid %options are:

=over

=item -encode

Changes the encoding of the font from its default.

=item -afmfile

Specifies the location of the font metrics file.

=item -pfmfile

Specifies the location of the printer font metrics file.  This option
overrides the -encode option.

=item -dokern

Enables kerning if data is available.

=back

=cut

sub psfont {
    my ($self,$psf,%opts)=@_;

    foreach my $o (qw(-afmfile -pfmfile)) {
        next unless(defined $opts{$o});
        $opts{$o}=_findFont($opts{$o});
    }
    $psf=_findFont($psf);
    require PDF::API2::Resource::Font::Postscript;
    my $obj=PDF::API2::Resource::Font::Postscript->new_api($self,$psf,%opts);

    $self->resource('Font',$obj->name,$obj,$self->{reopened});

    $self->{pdf}->out_obj($self->{pages});
    $obj->tounicodemap if($opts{-unicodemap}==1);
    return($obj);
}

=item $font = $pdf->ttfont($ttf_file, [%options])

Returns a new TrueType or OpenType font object.

B<Examples:>

    $font = $pdf->ttfont('Times.ttf');
    $font = $pdf->ttfont('Georgia.otf');

Valid %options are:

=over

=item -encode

Changes the encoding of the font from its default.

=item -isocmap

Use the ISO Unicode Map instead of the default MS Unicode Map.

=item -dokern

Enables kerning if data is available.

=item -noembed

Disables embedding of the font file.

=back

=cut

sub ttfont {
    my ($self, $file, %opts) = @_;

    # PDF::API2 doesn't set BaseEncoding for TrueType fonts, so text
    # isn't searchable unless a ToUnicode CMap is included.  Include
    # the ToUnicode CMap by default, but allow it to be disabled (for
    # performance and file size reasons) by setting -unicodemap to 0.
    $opts{-unicodemap} = 1 unless exists $opts{-unicodemap};

    $file = _findFont($file);
    require PDF::API2::Resource::CIDFont::TrueType;
    my $obj = PDF::API2::Resource::CIDFont::TrueType->new_api($self, $file, %opts);

    $self->resource('Font', $obj->name, $obj, $self->{reopened});

    $self->{pdf}->out_obj($self->{pages});
    $obj->tounicodemap if $opts{-unicodemap};
    return $obj;
}

=item $font = $pdf->cjkfont($cjkname, [%options])

Returns a new CJK font object.

B<Examples:>

    $font = $pdf->cjkfont('korean');
    $font = $pdf->cjkfont('traditional');

Valid %options are:

=over

=item -encode

Changes the encoding of the font from its default.

=back

See Also: L<PDF::API2::Resource::CIDFont::CJKFont>

=cut

sub cjkfont {
    my ($self,$name,%opts)=@_;

    require PDF::API2::Resource::CIDFont::CJKFont;
    my $obj=PDF::API2::Resource::CIDFont::CJKFont->new_api($self,$name,%opts);

    $self->resource('Font',$obj->name,$obj,$self->{reopened});

    $self->{pdf}->out_obj($self->{pages});
    $obj->tounicodemap if($opts{-unicodemap}==1);
    return($obj);
}

=item $font = $pdf->synfont($basefont, [%options])

Returns a new synthetic font object.

B<Examples:>

    $cf  = $pdf->corefont('Times-Roman', -encode => 'latin1');
    $sf  = $pdf->synfont($cf, -slant => 0.85);  # compressed 85%
    $sfb = $pdf->synfont($cf, -bold => 1);      # embolden by 10em
    $sfi = $pdf->synfont($cf, -oblique => -12); # italic at -12 degrees

Valid %options are:

=over

=item -slant

Slant/expansion factor (0.1-0.9 = slant, 1.1+ = expansion).

=item -oblique

Italic angle (+/-)

=item -bold

Emboldening factor (0.1+, bold = 1, heavy = 2, ...)

=item -space

Additional character spacing in ems (0-1000)

=back

See Also: L<PDF::API2::Resource::Font::SynFont>

=cut

sub synfont {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::Font::SynFont;
    my $obj=PDF::API2::Resource::Font::SynFont->new_api($self,@opts);

    $self->resource('Font',$obj->name,$obj,$self->{reopened});

    $self->{pdf}->out_obj($self->{pages});
    $obj->tounicodemap if($opts{-unicodemap}==1);
    return($obj);
}

=item $font = $pdf->bdfont($bdf_file)

Returns a new BDF font object, based on the specified Adobe BDF file.

See Also: L<PDF::API2::Resource::Font::BdFont>

=cut

sub bdfont {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::Font::BdFont;
    my $obj=PDF::API2::Resource::Font::BdFont->new_api($self,@opts);

    $self->resource('Font',$obj->name,$obj,$self->{reopened});

    $self->{pdf}->out_obj($self->{pages});
    ## $obj->tounicodemap; # does not support unicode!
    return($obj);
}

=item $font = $pdf->unifont(@fontspecs, %options)

Returns a new uni-font object, based on the specified fonts and options.

B<BEWARE:> This is not a true pdf-object, but a virtual/abstract font definition!

See Also: L<PDF::API2::Resource::UniFont>.

Valid %options are:

=over

=item -encode

Changes the encoding of the font from its default.

=back

=cut

sub unifont {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::UniFont;
    my $obj=PDF::API2::Resource::UniFont->new_api($self,@opts);

    return($obj);
}

=back

=head1 IMAGE METHODS

=over

=item $jpeg = $pdf->image_jpeg($file)

Imports and returns a new JPEG image object.

=cut

sub image_jpeg {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::XObject::Image::JPEG;
    my $obj=PDF::API2::Resource::XObject::Image::JPEG->new_api($self,$file);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $tiff = $pdf->image_tiff($file)

Imports and returns a new TIFF image object.

=cut

sub image_tiff {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::XObject::Image::TIFF;
    my $obj=PDF::API2::Resource::XObject::Image::TIFF->new_api($self,$file);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $pnm = $pdf->image_pnm($file)

Imports and returns a new PNM image object.

=cut

sub image_pnm {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::XObject::Image::PNM;
    my $obj=PDF::API2::Resource::XObject::Image::PNM->new_api($self,$file);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $png = $pdf->image_png($file)

Imports and returns a new PNG image object.

=cut

sub image_png {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::XObject::Image::PNG;
    my $obj=PDF::API2::Resource::XObject::Image::PNG->new_api($self,$file);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $gif = $pdf->image_gif($file)

Imports and returns a new GIF image object.

=cut

sub image_gif {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::XObject::Image::GIF;
    my $obj=PDF::API2::Resource::XObject::Image::GIF->new_api($self,$file);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $gdf = $pdf->image_gd($gd_object, %options)

Imports and returns a new image object from GD::Image.

B<Options:> The only option currently supported is C<< -lossless => 1 >>.

=cut

sub image_gd {
    my ($self,$gd,%opts)=@_;

    require PDF::API2::Resource::XObject::Image::GD;
    my $obj=PDF::API2::Resource::XObject::Image::GD->new_api($self,$gd,undef,%opts);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=back

=head1 COLORSPACE METHODS

=over

=item $cs = $pdf->colorspace_act($file)

Returns a new colorspace object based on an Adobe Color Table file.

See L<PDF::API2::Resource::ColorSpace::Indexed::ACTFile> for a
reference to the file format's specification.

=cut

sub colorspace_act {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::ColorSpace::Indexed::ACTFile;
    my $obj=PDF::API2::Resource::ColorSpace::Indexed::ACTFile->new_api($self,$file);

    $self->resource('ColorSpace',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $cs = $pdf->colorspace_web()

Returns a new colorspace-object based on the web color palette.

=cut

sub colorspace_web {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::ColorSpace::Indexed::WebColor;
    my $obj=PDF::API2::Resource::ColorSpace::Indexed::WebColor->new_api($self);

    $self->resource('ColorSpace',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $cs = $pdf->colorspace_hue()

Returns a new colorspace-object based on the hue color palette.

See L<PDF::API2::Resource::ColorSpace::Indexed::Hue> for an explanation.

=cut

sub colorspace_hue {
    my ($self,$file,%opts)=@_;

    require PDF::API2::Resource::ColorSpace::Indexed::Hue;
    my $obj=PDF::API2::Resource::ColorSpace::Indexed::Hue->new_api($self);

    $self->resource('ColorSpace',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $cs = $pdf->colorspace_separation($tint, $color)

Returns a new separation colorspace object based on the parameters.

I<$tint> can be any valid ink identifier, including but not limited
to: 'Cyan', 'Magenta', 'Yellow', 'Black', 'Red', 'Green', 'Blue' or
'Orange'.

I<$color> must be a valid color specification limited to: '#rrggbb',
'!hhssvv', '%ccmmyykk' or a "named color" (rgb).

The colorspace model will automatically be chosen based on the
specified color.

=cut

sub colorspace_separation {
    my ($self,$name,@clr)=@_;

    require PDF::API2::Resource::ColorSpace::Separation;
    my $obj=PDF::API2::Resource::ColorSpace::Separation->new_api($self,$name,@clr);

    $self->resource('ColorSpace',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $cs = $pdf->colorspace_devicen(\@tintCSx, [$samples])

Returns a new DeviceN colorspace object based on the parameters.

B<Example:> 

    $cy = $pdf->colorspace_separation('Cyan',    '%f000');
    $ma = $pdf->colorspace_separation('Magenta', '%0f00');
    $ye = $pdf->colorspace_separation('Yellow',  '%00f0');
    $bk = $pdf->colorspace_separation('Black',   '%000f');

    $pms023 = $pdf->colorspace_separation('PANTONE 032CV', '%0ff0');

    $dncs = $pdf->colorspace_devicen( [ $cy,$ma,$ye,$bk,$pms023 ] );

The colorspace model will automatically be chosen based on the first
colorspace specified.

=cut

sub colorspace_devicen {
    my ($self,$clrs,$samples)=@_;
    $samples||=2;
    
    require PDF::API2::Resource::ColorSpace::DeviceN;
    my $obj=PDF::API2::Resource::ColorSpace::DeviceN->new_api($self,$clrs,$samples);

    $self->resource('ColorSpace',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=back

=head1 BARCODE METHODS

=over

=item $bc = $pdf->xo_codabar(%options)

=item $bc = $pdf->xo_code128(%options)

=item $bc = $pdf->xo_2of5int(%options)

=item $bc = $pdf->xo_3of9(%options)

=item $bc = $pdf->xo_ean13(%options)

Creates the specified barcode object as a form XObject.

=cut

sub xo_code128 {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::XObject::Form::BarCode::code128;
    my $obj=PDF::API2::Resource::XObject::Form::BarCode::code128->new_api($self,@opts);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

sub xo_codabar {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::XObject::Form::BarCode::codabar;
    my $obj=PDF::API2::Resource::XObject::Form::BarCode::codabar->new_api($self,@opts);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

sub xo_2of5int {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::XObject::Form::BarCode::int2of5;
    my $obj=PDF::API2::Resource::XObject::Form::BarCode::int2of5->new_api($self,@opts);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

sub xo_3of9 {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::XObject::Form::BarCode::code3of9;
    my $obj=PDF::API2::Resource::XObject::Form::BarCode::code3of9->new_api($self,@opts);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

sub xo_ean13 {
    my ($self,@opts)=@_;

    require PDF::API2::Resource::XObject::Form::BarCode::ean13;
    my $obj=PDF::API2::Resource::XObject::Form::BarCode::ean13->new_api($self,@opts);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=back

=head1 OTHER METHODS

=over

=item $xo = $pdf->xo_form()

Returns a new form XObject.

=cut

sub xo_form {
    my ($self)=@_;

    my $obj=PDF::API2::Resource::XObject::Form::Hybrid->new_api($self);

    $self->resource('XObject',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $egs = $pdf->egstate()

Returns a new extended graphics state object.

=cut

sub egstate {
    my ($self)=@_;

    my $obj=PDF::API2::Resource::ExtGState->new_api($self,pdfkey());

    $self->resource('ExtGState',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $obj = $pdf->pattern()

Returns a new pattern object.

=cut

sub pattern {
    my ($self,%opts)=@_;

    my $obj=PDF::API2::Resource::Pattern->new_api($self,undef,%opts);

    $self->resource('Pattern',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $obj = $pdf->shading()

Returns a new shading object.

=cut

sub shading {
    my ($self,%opts)=@_;

    my $obj=PDF::API2::Resource::Shading->new_api($self,undef,%opts);

    $self->resource('Shading',$obj->name,$obj);

    $self->{pdf}->out_obj($self->{pages});
    return($obj);
}

=item $otls = $pdf->outlines()

Returns a new or existing outlines object.

=cut

sub outlines {
    my $self = shift();

    require PDF::API2::Outlines;
    $self->{pdf}->{Root}->{Outlines} ||= PDF::API2::Outlines->new($self);

    my $obj = $self->{pdf}->{Root}->{Outlines};

    $self->{pdf}->new_obj($obj) unless $obj->is_obj($self->{pdf});
    $self->{pdf}->out_obj($obj);
    $self->{pdf}->out_obj($self->{pdf}->{Root});

    return $obj;

}

sub named_destination
{
    my ($self,$cat,$name,$obj)=@_;
    my $root=$self->{catalog};

    $root->{Names}||=PDFDict();
    $root->{Names}->{$cat}||=PDFDict();
    $root->{Names}->{$cat}->{-vals}||={};
    $root->{Names}->{$cat}->{Limits}||=PDFArray();
    $root->{Names}->{$cat}->{Names}||=PDFArray();
    
    unless(defined $obj)
    {
        $obj=PDF::API2::NamedDestination->new_api($self);
    }
    $root->{Names}->{$cat}->{-vals}->{$name}=$obj;
    
    my @names=sort {$a cmp $b} keys %{$root->{Names}->{$cat}->{-vals}};
    
    $root->{Names}->{$cat}->{Limits}->{' val'}->[0]=PDFStr($names[0]);
    $root->{Names}->{$cat}->{Limits}->{' val'}->[1]=PDFStr($names[-1]);
    
    @{$root->{Names}->{$cat}->{Names}->{' val'}}=();
    
    foreach my $k (@names)
    {
        push @{$root->{Names}->{$cat}->{Names}->{' val'}},
            PDFStr($k),$root->{Names}->{$cat}->{-vals}->{$k};
    }

    return($obj);
}

=back

=head1 RESOURCE METHODS

=over

=item $pdf->resource($type, $key, $obj, $force)

Adds a resource to the global PDF tree.

B<Example:>

    $pdf->resource('Font', $fontkey, $fontobj);
    $pdf->resource('XObject', $imagekey, $imageobj);
    $pdf->resource('Shading', $shadekey, $shadeobj);
    $pdf->resource('ColorSpace', $spacekey, $speceobj);

B<Note:> You only have to add the required resources if they are NOT
handled by the font, image, shade or space methods.

=cut

sub resource 
{
    return(undef);
    my ($self, $type, $key, $obj, $force) = @_;

    $self->{pages}->{Resources}||=PDFDict();

    my $dict=$self->{pages}->{Resources};
    $dict->realise if(ref($dict)=~/Objind$/);

    $self->{pdf}->new_obj($dict) unless($dict->is_obj($self->{pdf}));

    $dict->{$type}=$dict->{$type} || PDFDict();
    $dict->{$type}->realise if(ref($dict->{$type})=~/Objind$/);

    if(defined($obj)) 
    {
        if($force) 
        {
            $dict->{$type}->{$key}=$obj;
        } 
        else 
        {
            $dict->{$type}->{$key}=$dict->{$type}->{$key} || $obj;
        }

        $self->{pdf}->out_obj($dict)
            if($dict->is_obj($self->{pdf}));

        $self->{pdf}->out_obj($dict->{$type})
            if($dict->{$type}->is_obj($self->{pdf}));

        $self->{pdf}->out_obj($obj)
            if($obj->is_obj($self->{pdf}));

        $self->{pdf}->out_obj($self->{pages});

        return($dict);
    }
    return($dict->{$type}->{$key} || undef);
}

1;

__END__

=back

=head1 KNOWN ISSUES

This module does not work with perl's -l command-line switch.

PDFs using cross-reference streams instead of cross-reference tables
are not yet supported.  Cross-reference streams were added as an
option in version 1.5 of the PDF spec, but were only used infrequently
until Adobe Acrobat 9 started using them by default.  A patch would be
welcome -- see the PDF 1.7 specification, sections 7.5.4 and 7.5.8 for
implementation details.

=head1 AUTHOR

PDF::API2 was originally written by Alfred Reibenschuh.

It is currently being maintained by Steve Simms.

=cut
