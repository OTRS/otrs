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
package PDF::API2::Basic::PDF::Filter;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Filter::ASCII85Decode;
use PDF::API2::Basic::PDF::Filter::ASCIIHexDecode;
use PDF::API2::Basic::PDF::Filter::FlateDecode;
use PDF::API2::Basic::PDF::Filter::LZWDecode;
use PDF::API2::Basic::PDF::Filter::RunLengthDecode;
use Scalar::Util qw(blessed reftype);

=head1 NAME

PDF::API2::Basic::PDF::Filter - Abstract superclass for PDF stream filters

=head1 SYNOPSIS

    $f = PDF::API2::Basic::PDF::Filter->new;
    $str = $f->outfilt($str, 1);
    print OUTFILE $str;

    while (read(INFILE, $dat, 4096))
    { $store .= $f->infilt($dat, 0); }
    $store .= $f->infilt("", 1);

=head1 DESCRIPTION

A Filter object contains state information for the process of outputting
and inputting data through the filter. The precise state information stored
is up to the particular filter and may range from nothing to whole objects
created and destroyed.

Each filter stores different state information for input and output and thus
may handle one input filtering process and one output filtering process at
the same time.

=head1 METHODS

=head2 PDF::API2::Basic::PDF::Filter->new

Creates a new filter object with empty state information ready for processing
data both input and output.

=head2 $dat = $f->infilt($str, $isend)

Filters from output to input the data. Notice that $isend == 0 implies that there
is more data to come and so following it $f may contain state information
(usually due to the break-off point of $str not being tidy). Subsequent calls
will incorporate this stored state information.

$isend == 1 implies that there is no more data to follow. The
final state of $f will be that the state information is empty. Error messages
are most likely to occur here since if there is required state information to
be stored following this data, then that would imply an error in the data.

=head2 $str = $f->outfilt($dat, $isend)

Filter stored data ready for output. Parallels C<infilt>.

=cut

sub new {
    my $class = shift();
    my $self = {};

    bless $self, $class;

    return $self;
}

sub release {
    my $self = shift();
    return $self unless ref($self);

    # delete stuff that we know we can, here
    my @tofree = map { delete $self->{$_} } keys %$self;

    while (my $item = shift @tofree) {
        my $ref = ref($item);
        if (blessed($item) and $item->can('release')) {
            $item->release();
        }
        elsif ($ref eq 'ARRAY') {
            push @tofree, @$item;
        }
        elsif (defined(reftype($ref)) and reftype($ref) eq 'HASH') {
            release($item);
        }
    }

    # check that everything has gone
    foreach my $key (keys %$self) {
        # warn ref($self) . " still has '$key' key left after release.\n";
        $self->{$key} = undef;
        delete $self->{$key};
    }
}

1;
