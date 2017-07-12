#=======================================================================
#
#   THIS IS A REUSED PERL MODULE, FOR PROPER LICENCING TERMS SEE BELOW:
#
#   Copyright Martin Hosken <Martin_Hosken@sil.org>
#
#   No warranty or expression of effectiveness, least of all regarding
#   anyone's safety, is implied in this software or documentation.
#
#   This specific module is licensed under the Perl Artistic License.
#
#=======================================================================
package PDF::API2::Basic::PDF::Dict;

use base 'PDF::API2::Basic::PDF::Objind';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

our $mincache = 16 * 1024 * 1024;

use File::Temp;
use PDF::API2::Basic::PDF::Array;
use PDF::API2::Basic::PDF::Filter;
use PDF::API2::Basic::PDF::Name;

=head1 NAME

PDF::API2::Basic::PDF::Dict - PDF Dictionaries and Streams. Inherits from L<PDF::Objind>

=head1 INSTANCE VARIABLES

There are various special instance variables which are used to look after,
particularly, streams. Each begins with a space:

=over

=item stream

Holds the stream contents for output

=item streamfile

Holds the stream contents in an external file rather than in memory. This is
not the same as a PDF file stream. The data is stored in its unfiltered form.

=item streamloc

If both ' stream' and ' streamfile' are empty, this indicates where in the
source PDF the stream starts.

=back

=head1 METHODS

=cut

sub new {
    my ($class) = @_;
    $class = ref($class) if ref($class);

    my $self = $class->SUPER::new(@_);
    $self->{' realised'} = 1;
    return $self;
}

=head2 $type = $d->type($type)

Get/Set the standard Type key.  It can be passed, and will return, a text value rather than a Name object.

=cut

sub type {
    my $self = shift();
    if (scalar @_) {
        my $type = shift();
        $self->{'Type'} = ref($type) ? $type : PDF::API2::Basic::PDF::Name->new($type);
    }
    return unless exists $self->{'Type'};
    return $self->{'Type'}->val();
}

=head2 @filters = $d->filter(@filters)

Get/Set one or more filters being used by the optional stream attached to the dictionary.

=cut

sub filter {
    my ($self, @filters) = @_;

    # Developer's Note: the PDF specification allows Filter to be
    # either a name or an array, but other parts of this codebase
    # expect an array.  If these are updated uncomment the
    # commented-out lines in order to accept both types.

    # if (scalar @filters == 1) {
    #     $self->{'Filter'} = ref($filters[0]) ? $filters[0] : PDF::API2::Basic::PDF::Name->new($filters[0]);
    # }
    # elsif (scalar @filters) {
        @filters = map { ref($_) ? $_ : PDF::API2::Basic::PDF::Name->new($_) } @filters;
        $self->{'Filter'} = PDF::API2::Basic::PDF::Array->new(@filters);
    # }
}

# Undocumented alias, which may be removed in a future release
sub filters { return filter(@_); }

=head2 $d->outobjdeep($fh)

Outputs the contents of the dictionary to a PDF file. This is a recursive call.

It also outputs a stream if the dictionary has a stream element. If this occurs
then this method will calculate the length of the stream and insert it into the
stream's dictionary.

=cut

sub outobjdeep {
    my ($self, $fh, $pdf, %opts) = @_;

    if (defined $self->{' stream'} or defined $self->{' streamfile'} or defined $self->{' streamloc'}) {
        if ($self->{'Filter'} and $self->{' nofilt'}) {
            $self->{'Length'} ||= PDF::API2::Basic::PDF::Number->new(length($self->{' stream'}));
        }
        elsif ($self->{'Filter'} or not defined $self->{' stream'}) {
            $self->{'Length'} = PDF::API2::Basic::PDF::Number->new(0) unless defined $self->{'Length'};
            $pdf->new_obj($self->{'Length'}) unless $self->{'Length'}->is_obj($pdf);
        }
        else {
            $self->{'Length'} = PDF::API2::Basic::PDF::Number->new(length($self->{' stream'}));
            ## $self->{'Length'} = PDF::API2::Basic::PDF::Number->new(length($self->{' stream'}) + 1);
            ## this old code seams to burp acro6, lets see what breaks next -- fredo
        }
    }

    $fh->print('<< ');
    foreach my $key (sort {
                         $a eq 'Type'    ? -1 : $b eq 'Type'    ? 1 :
                         $a eq 'Subtype' ? -1 : $b eq 'Subtype' ? 1 : $a cmp $b
                     } keys %$self) {
        next if $key =~ m/^[\s\-]/o;
        next unless $self->{$key};
        $fh->print('/' . PDF::API2::Basic::PDF::Name::string_to_name($key, $pdf) . ' ');
        $self->{$key}->outobj($fh, $pdf, %opts);
        $fh->print(' ');
    }
    $fh->print('>>');

    # Now handle the stream (if any)
    my (@filters, $loc);

    if (defined $self->{' streamloc'} and not defined $self->{' stream'}) {
        # read a stream if in file
        $loc = $fh->tell();
        $self->read_stream();
        $fh->seek($loc, 0);
    }

    if (not $self->{' nofilt'} and defined $self->{'Filter'} and (defined $self->{' stream'} or defined $self->{' streamfile'})) {
        my $hasflate = -1;
        for my $i (0 .. scalar(@{$self->{'Filter'}{' val'}}) - 1) {
            my $filter = $self->{'Filter'}{' val'}[$i]->val();
            # hack to get around LZW patent
            if ($filter eq 'LZWDecode') {
                if ($hasflate < -1) {
                    $hasflate = $i;
                    next;
                }
                $filter = 'FlateDecode';
                $self->{'Filter'}{' val'}[$i]{'val'} = $filter;      # !!!
            }
            elsif ($filter eq 'FlateDecode') {
                $hasflate = -2;
            }
            my $filter_class = "PDF::API2::Basic::PDF::Filter::$filter";
            push (@filters, $filter_class->new());
        }
        splice(@{$self->{'Filter'}{' val'}}, $hasflate, 1) if $hasflate > -1;
    }

    if (defined $self->{' stream'}) {
        $fh->print(" stream\n");
        $loc = $fh->tell();
        my $stream = $self->{' stream'};
        unless ($self->{' nofilt'}) {
            foreach my $filter (reverse @filters) {
                $stream = $filter->outfilt($stream, 1);
            }
        }
        $fh->print($stream);
        ## $fh->print("\n"); # newline goes into endstream

    }
    elsif (defined $self->{' streamfile'}) {
        open(my $dictfh, "<", $self->{' streamfile'}) || die "Unable to open $self->{' streamfile'}";
        binmode($dictfh, ':raw');

        $fh->print(" stream\n");
        $loc = $fh->tell();
        my $stream;
        while (read($dictfh, $stream, 4096)) {
            unless ($self->{' nofilt'}) {
                foreach my $filter (reverse @filters) {
                    $stream = $filter->outfilt($stream, 0);
                }
            }
            $fh->print($stream);
        }
        close $dictfh;
        unless ($self->{' nofilt'}) {
            $stream = '';
            foreach my $filter (reverse @filters) {
                $stream = $filter->outfilt($stream, 1);
            }
            $fh->print($stream);
        }
        ## $fh->print("\n"); # newline goes into endstream
    }

    if (defined $self->{' stream'} or defined $self->{' streamfile'}) {
        my $length = $fh->tell() - $loc;
        unless ($self->{'Length'}{'val'} == $length) {
            $self->{'Length'}{'val'} = $length;
            $pdf->out_obj($self->{'Length'}) if $self->{'Length'}->is_obj($pdf);
        }

        $fh->print("\nendstream"); # next is endobj which has the final cr
    }
}

=head2 $d->read_stream($force_memory)

Reads in a stream from a PDF file. If the stream is greater than
C<PDF::Dict::mincache> (defaults to 32768) bytes to be stored, then
the default action is to create a file for it somewhere and to use that
file as a data cache. If $force_memory is set, this caching will not
occur and the data will all be stored in the $self->{' stream'}
variable.

=cut

sub read_stream {
    my ($self, $force_memory) = @_;

    my $fh = $self->{' streamsrc'};
    my $len = $self->{'Length'}->val();

    $self->{' stream'} = '';

    my @filters;
    if (defined $self->{'Filter'}) {
        my $i = 0;
        foreach my $filter ($self->{'Filter'}->elementsof()) {
            my $filter_class = "PDF::API2::Basic::PDF::Filter::" . $filter->val();
            unless ($self->{'DecodeParms'}) {
                push(@filters, $filter_class->new());
            }
            elsif ($self->{'Filter'}->isa('PDF::API2::Basic::PDF::Name') and $self->{'DecodeParms'}->isa('PDF::API2::Basic::PDF::Dict')) {
                push(@filters, $filter_class->new($self->{'DecodeParms'}));
            }
            elsif ($self->{'DecodeParms'}->isa('PDF::API2::Basic::PDF::Array')) {
                my $parms = $self->{'DecodeParms'}->val->[$i];
                push(@filters, $filter_class->new($parms));
            }
            else {
                push(@filters, $filter_class->new());
            }
            $i++;
        }
    }

    my $last = 0;
    if (defined $self->{' streamfile'}) {
        unlink ($self->{' streamfile'});
        $self->{' streamfile'} = undef;
    }
    seek $fh, $self->{' streamloc'}, 0;

    my $dictfh;
    my $readlen = 4096;
    for (my $i = 0; $i < $len; $i += $readlen) {
        my $data;
        unless ($i + $readlen > $len) {
            read $fh, $data, $readlen;
        }
        else {
            $last = 1;
            read $fh, $data, $len - $i;
        }

        foreach my $filter (@filters) {
            $data = $filter->infilt($data, $last);
        }

        # Start using a temporary file if the stream gets too big
        if (not $force_memory and not defined $self->{' streamfile'} and (length($self->{' stream'}) + length($data)) > $mincache) {
            $dictfh = File::Temp->new(TEMPLATE => 'pdfXXXXX', SUFFIX => 'dat', TMPDIR => 1);
            $self->{' streamfile'} = $dictfh->filename();
            print $dictfh $self->{' stream'};
            undef $self->{' stream'};
        }

        if (defined $self->{' streamfile'}) {
            print $dictfh $data;
        }
        else {
            $self->{' stream'} .= $data;
        }
    }

    close $dictfh if defined $self->{' streamfile'};
    $self->{' nofilt'} = 0;
    return $self;
}

=head2 $d->val

Returns the dictionary, which is itself.

=cut

sub val {
    return $_[0];
}

1;
