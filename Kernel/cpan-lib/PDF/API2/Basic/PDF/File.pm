#=======================================================================
#
#   THIS IS A REUSED PERL MODULE, FOR PROPER LICENCING TERMS SEE BELOW:
#
#   Copyright Martin Hosken <Martin_Hosken@sil.org>
#
#   Modified for PDF::API2 by Alfred Reibenschuh <alfredreibenschuh@gmx.net>
#
#   No warranty or expression of effectiveness, least of all regarding
#   anyone's safety, is implied in this software or documentation.
#
#   This specific module is licensed under the Perl Artistic License.
#
#=======================================================================
package PDF::API2::Basic::PDF::File;

use strict;

our $VERSION = '2.033'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::File - Holds the trailers and cross-reference tables for a PDF file

=head1 SYNOPSIS

 $p = PDF::API2::Basic::PDF::File->open("filename.pdf", 1);
 $p->new_obj($obj_ref);
 $p->free_obj($obj_ref);
 $p->append_file;
 $p->close_file;
 $p->release;       # IMPORTANT!

=head1 DESCRIPTION

This class keeps track of the directory aspects of a PDF file. There are two
parts to the directory: the main directory object which is the parent to all
other objects and a chain of cross-reference tables and corresponding trailer
dictionaries starting with the main directory object.

=head1 INSTANCE VARIABLES

Within this class hierarchy, rather than making everything visible via methods,
which would be a lot of work, there are various instance variables which are
accessible via associative array referencing. To distinguish instance variables
from content variables (which may come from the PDF content itself), each such
variable will start with a space.

Variables which do not start with a space directly reflect elements in a PDF
dictionary. In the case of a PDF::API2::Basic::PDF::File, the elements reflect those in the
trailer dictionary.

Since some variables are not designed for class users to access, variables are
marked in the documentation with (R) to indicate that such an entry should only
be used as read-only information. (P) indicates that the information is private
and not designed for user use at all, but is included in the documentation for
completeness and to ensure that nobody else tries to use it.

=over

=item newroot

This variable allows the user to create a new root entry to occur in the trailer
dictionary which is output when the file is written or appended. If you wish to
over-ride the root element in the dictionary you have, use this entry to indicate
that without losing the current Root entry. Notice that newroot should point to
a PDF level object and not just to a dictionary which does not have object status.

=item INFILE (R)

Contains the filehandle used to read this information into this PDF directory. Is
an IO object.

=item fname (R)

This is the filename which is reflected by INFILE, or the original IO object passed
in.

=item update (R)

This indicates that the read file has been opened for update and that at some
point, $p->appendfile() can be called to update the file with the changes that
have been made to the memory representation.

=item maxobj (R)

Contains the first usable object number above any that have already appeared
in the file so far.

=item outlist (P)

This is a list of Objind which are to be output when the next appendfile or outfile
occurs.

=item firstfree (P)

Contains the first free object in the free object list. Free objects are removed
from the front of the list and added to the end.

=item lastfree (P)

Contains the last free object in the free list. It may be the same as the firstfree
if there is only one free object.

=item objcache (P)

All objects are held in the cache to ensure that a system only has one occurrence of
each object. In effect, the objind class acts as a container type class to hold the
PDF object structure and it would be unfortunate if there were two identical
place-holders floating around a system.

=item epos (P)

The end location of the read-file.

=back

Each trailer dictionary contains a number of private instance variables which
hold the chain together.

=over

=item loc (P)

Contains the location of the start of the cross-reference table preceding the
trailer.

=item xref (P)

Contains an anonymous array of each cross-reference table entry.

=item prev (P)

A reference to the previous table. Note this differs from the Prev entry which
is in PDF which contains the location of the previous cross-reference table.

=back

=head1 METHODS

=cut

use Scalar::Util qw(blessed weaken);

use vars qw($cr $irreg_char $reg_char $ws_char $delim_char %types);

$ws_char = '[ \t\r\n\f\0]';
$delim_char = '[][<>{}()/%]';
$reg_char = '[^][<>{}()/% \t\r\n\f\0]';
$irreg_char = '[][<>{}()/% \t\r\n\f\0]';
$cr = '\s*(?:\015|\012|(?:\015\012))';

my $re_comment = qr/(?:\%[^\r\n]*)/;
my $re_whitespace = qr/(?:[ \t\r\n\f\0]|$re_comment)/;

%types = (
    'Page'  => 'PDF::API2::Basic::PDF::Page',
    'Pages' => 'PDF::API2::Basic::PDF::Pages',
);

my $readDebug = 0;

use Carp;
use IO::File;

# Now for the basic PDF types
use PDF::API2::Basic::PDF::Utils;

use PDF::API2::Basic::PDF::Array;
use PDF::API2::Basic::PDF::Bool;
use PDF::API2::Basic::PDF::Dict;
use PDF::API2::Basic::PDF::Name;
use PDF::API2::Basic::PDF::Number;
use PDF::API2::Basic::PDF::Objind;
use PDF::API2::Basic::PDF::String;
use PDF::API2::Basic::PDF::Page;
use PDF::API2::Basic::PDF::Pages;
use PDF::API2::Basic::PDF::Null;
use POSIX qw(ceil floor);

no warnings qw[ deprecated recursion uninitialized ];


=head2 PDF::API2::Basic::PDF::File->new

Creates a new, empty file object which can act as the host to other PDF objects.
Since there is no file associated with this object, it is assumed that the
object is created in readiness for creating a new PDF file.

=cut

sub new {
    my ($class, $root) = @_;
    my $self = $class->_new();

    unless ($root) {
        $root = PDFDict();
        $root->{'Type'} = PDFName('Catalog');
    }
    $self->new_obj($root);
    $self->{'Root'} = $root;
    return $self;
}


=head2 $p = PDF::API2::Basic::PDF::File->open($filename, $update)

Opens the file and reads all the trailers and cross reference tables to build
a complete directory of objects.

$update specifies whether this file is being opened for updating and editing,
or simply to be read.

$filename may be an IO object

=cut

sub open {
    my ($class, $filename, $update) = @_;
    my ($fh, $buffer);

    my $self = $class->_new();
    if (ref $filename) {
        $self->{' INFILE'} = $filename;
        if ($update) {
            $self->{' update'} = 1;
            $self->{' OUTFILE'} = $filename;
        }
        $fh = $filename;
    }
    else {
        die "File '$filename' does not exist !" unless -f $filename;
        $fh = IO::File->new(($update ? '+' : '') . "<$filename") || return;
        $self->{' INFILE'} = $fh;
        if ($update) {
            $self->{' update'} = 1;
            $self->{' OUTFILE'} = $fh;
            $self->{' fname'} = $filename;
        }
    }
    binmode $fh, ':raw';
    $fh->seek(0, 0);            # go to start of file
    $fh->read($buffer, 255);
    unless ($buffer =~ m/^\%PDF\-1\.(\d)+\s*$cr/mo) {
        die "$filename not a PDF file version 1.x";
    }
    $self->{' version'} = $1;

    $fh->seek(0, 2);            # go to end of file
    my $end = $fh->tell();
    $self->{' epos'} = $end;
    foreach my $offset (1..64) {
    	$fh->seek($end - 16 * $offset, 0);
    	$fh->read($buffer, 16 * $offset);
    	last if $buffer =~ m/startxref($cr|\s*)\d+($cr|\s*)\%\%eof.*?/i;
    }
    unless ($buffer =~ m/startxref[^\d]+([0-9]+)($cr|\s*)\%\%eof.*?/i) {
        die "Malformed PDF file $filename";
    }
    my $xpos = $1;
    $self->{' xref_position'} = $xpos;

    my $tdict = $self->readxrtr($xpos, $self);
    foreach my $key (keys %$tdict) {
        $self->{$key} = $tdict->{$key};
    }
    return $self;
}

=head2 $p->release()

Releases ALL of the memory used by the PDF document and all of its
component objects.  After calling this method, do B<NOT> expect to
have anything left in the C<PDF::API2::Basic::PDF::File> object (so if
you need to save, be sure to do it before calling this method).

B<NOTE>, that it is important that you call this method on any
C<PDF::API2::Basic::PDF::File> object when you wish to destruct it and
free up its memory.  Internally, PDF files have an enormous number of
cross-references and this causes circular references within the
internal data structures.  Calling 'C<release()>' forces a brute-force
cleanup of the data structures, freeing up all of the memory.  Once
you've called this method, though, don't expect to be able to do
anything else with the C<PDF::API2::Basic::PDF::File> object; it'll
have B<no> internal state whatsoever.

=cut

# Maintainer's Question: Couldn't this be handled by a DESTROY method
# instead of requiring an explicit call to release()?
sub release {
    my $self = shift();

    return $self unless ref($self);
    my @tofree = values %$self;

    foreach my $key (keys %$self) {
        $self->{$key} = undef;
        delete $self->{$key};
    }

    while (my $item = shift @tofree) {
        if (blessed($item) and $item->can('release')) {
            $item->release(1);
        }
        elsif (ref($item) eq 'ARRAY') {
            push @tofree, @$item;
        }
        elsif (ref($item) eq 'HASH') {
            push @tofree, values %$item;
            foreach my $key (keys %$item) {
                $item->{$key} = undef;
                delete $item->{$key};
            }
        }
        else {
            $item = undef;
        }
    }
}

=head2 $p->append_file()

Appends the objects for output to the read file and then appends the appropriate table.

=cut

sub append_file {
    my $self = shift();
    return unless $self->{' update'};

    my $fh = $self->{' INFILE'};

    # hack to upgrade pdf-version number to support
    # requested features in higher versions than
    # the pdf was originally created.
    my $version = $self->{' version'} || 4;
    $fh->seek(0, 0);
    $fh->print("%PDF-1.$version\n");

    my $tdict = PDFDict();
    $tdict->{'Prev'} = PDFNum($self->{' loc'});
    $tdict->{'Info'} = $self->{'Info'};
    if (defined $self->{' newroot'}) {
        $tdict->{'Root'} = $self->{' newroot'};
    }
    else {
        $tdict->{'Root'} = $self->{'Root'};
    }
    $tdict->{'Size'} = $self->{'Size'};

    foreach my $key (grep { $_ !~ m/^\s/ } keys %$self) {
        $tdict->{$key} = $self->{$key} unless defined $tdict->{$key};
    }

    $fh->seek($self->{' epos'}, 0);
    $self->out_trailer($tdict, $self->{' update'});
    close $self->{' OUTFILE'};
}


=head2 $p->out_file($fname)

Writes a PDF file to a file of the given filename based on the current list of
objects to be output. It creates the trailer dictionary based on information
in $self.

$fname may be an IO object;

=cut

sub out_file {
    my ($self, $fname) = @_;

    $self->create_file($fname);
    $self->close_file();
    return $self;
}


=head2 $p->create_file($fname)

Creates a new output file (no check is made of an existing open file) of
the given filename or IO object. Note, make sure that $p->{' version'} is set
correctly before calling this function.

=cut

sub create_file {
    my ($self, $filename) = @_;
    my $fh;

    $self->{' fname'} = $filename;
    if (ref $filename) {
        $fh = $filename;
    }
    else {
        $fh = IO::File->new(">$filename") || die "Unable to open $filename for writing";
        binmode($fh,':raw');
    }

    $self->{' OUTFILE'} = $fh;
    $fh->print('%PDF-1.' . ($self->{' version'} || '2') . "\n");
    $fh->print("%\xC6\xCD\xCD\xB5\n");   # and some binary stuff in a comment
    return $self;
}


=head2 $p->close_file

Closes up the open file for output by outputting the trailer etc.

=cut

sub close_file {
    my $self = shift();

    my $tdict = PDFDict();
    $tdict->{'Info'} = $self->{'Info'} if defined $self->{'Info'};
    $tdict->{'Root'} = (defined $self->{' newroot'} and $self->{' newroot'} ne '') ? $self->{' newroot'} : $self->{'Root'};

    # remove all freed objects from the outlist, AND the outlist_cache if not updating
    # NO! Don't do that thing! In fact, let out_trailer do the opposite!

    $tdict->{'Size'} = $self->{'Size'} || PDFNum(1);
    $tdict->{'Prev'} = PDFNum($self->{' loc'}) if $self->{' loc'};
    if ($self->{' update'}) {
        foreach my $key (grep ($_ !~ m/^[\s\-]/, keys %$self)) {
            $tdict->{$key} = $self->{$key} unless defined $tdict->{$key};
        }

        my $fh = $self->{' INFILE'};
        $fh->seek($self->{' epos'}, 0);
    }

    $self->out_trailer($tdict, $self->{' update'});
    close($self->{' OUTFILE'});
    if ($^O eq 'MacOS' and not ref($self->{' fname'})) {
        MacPerl::SetFileInfo('CARO', 'TEXT', $self->{' fname'});
    }

    return $self;
}

=head2 ($value, $str) = $p->readval($str, %opts)

Reads a PDF value from the current position in the file. If $str is too short
then read some more from the current location in the file until the whole object
is read. This is a recursive call which may slurp in a whole big stream (unprocessed).

Returns the recursive data structure read and also the current $str that has been
read from the file.

=cut

sub readval {
    my ($self, $str, %opts) = @_;
    my $fh = $self->{' INFILE'};
    my ($result, $value);

    my $update = defined($opts{update}) ? $opts{update} : 1;
    $str = update($fh, $str) if $update;

    $str =~ s/^$ws_char+//;               # Ignore initial white space
    $str =~ s/^\%[^\015\012]*$ws_char+//; # Ignore comments

    # Dictionary
    if ($str =~ m/^<</s) {
        $str = substr ($str, 2);
        $str = update($fh, $str) if $update;
        $result = PDFDict();

        while ($str !~ m/^>>/) {
            $str =~ s/^$ws_char+//;               # Ignore initial white space
            $str =~ s/^\%[^\015\012]*$ws_char+//; # Ignore comments

            if ($str =~ s|^/($reg_char+)||) {
                my $key = PDF::API2::Basic::PDF::Name::name_to_string($1, $self);
                ($value, $str) = $self->readval($str, %opts);
                $result->{$key} = $value;
            }
            elsif ($str =~ s|^/$ws_char+||) {
                # fixes a broken key problem of acrobat. -- fredo
                ($value, $str) = $self->readval($str, %opts);
                $result->{'null'} = $value;
            }
            elsif ($str =~ s|^//|/|) {
                # fixes again a broken key problem of illustrator/enfocus. -- fredo
                ($value, $str) = $self->readval($str, %opts);
                $result->{'null'} = $value;
            }
            else {
                die "Invalid dictionary key";
            }
            $str = update($fh, $str) if $update; # thanks gareth.jones@stud.man.ac.uk
        }
        $str =~ s/^>>//;
        $str = update($fh, $str) if $update;
        # streams can't be followed by a lone carriage-return.
        # fredo: yes they can !!! -- use the MacOS Luke.
        if (($str =~ s/^stream(?:(?:\015\012)|\012|\015)//) and ($result->{'Length'}->val != 0)) {   # stream
            my $length = $result->{'Length'}->val;
            $result->{' streamsrc'} = $fh;
            $result->{' streamloc'} = $fh->tell - length($str);

            unless ($opts{'nostreams'}) {
                if ($length > length($str)) {
                    $value = $str;
                    $length -= length($str);
                    read $fh, $str, $length + 11; # slurp the whole stream!
                }
                else {
                    $value = '';
                }
                $value .= substr($str, 0, $length);
                $result->{' stream'} = $value;
                $result->{' nofilt'} = 1;
                $str = update($fh, $str, 1) if $update;  # tell update we are in-stream and only need an endstream
                $str = substr($str, index($str, 'endstream') + 9);
            }
        }

        if (defined $result->{'Type'} and defined $types{$result->{'Type'}->val}) {
            bless $result, $types{$result->{'Type'}->val};
        }
        # gdj: FIXME: if any of the ws chars were crs, then the whole
        # string might not have been read.
    }

    # Indirect Object
    elsif ($str =~ m/^([0-9]+)(?:$ws_char|$re_comment)+([0-9]+)(?:$ws_char|$re_comment)+R/s) {
        my $num = $1;
        $value = $2;
        $str =~ s/^([0-9]+)(?:$ws_char|$re_comment)+([0-9]+)(?:$ws_char|$re_comment)+R//s;
        unless ($result = $self->test_obj($num, $value)) {
            $result = PDF::API2::Basic::PDF::Objind->new();
            $result->{' objnum'} = $num;
            $result->{' objgen'} = $value;
            $self->add_obj($result, $num, $value);
        }
        $result->{' parent'} = $self;
        weaken $result->{' parent'};
        $result->{' realised'} = 0;
        # gdj: FIXME: if any of the ws chars were crs, then the whole
        # string might not have been read.
    }

    # Object
    elsif ($str =~ m/^([0-9]+)(?:$ws_char|$re_comment)+([0-9]+)(?:$ws_char|$re_comment)+obj/s) {
        my $obj;
        my $num = $1;
        $value = $2;
        $str =~ s/^([0-9]+)(?:$ws_char|$re_comment)+([0-9]+)(?:$ws_char|$re_comment)+obj//s;
        ($obj, $str) = $self->readval($str, %opts);
        if ($result = $self->test_obj($num, $value)) {
            $result->merge($obj);
        }
        else {
            $result = $obj;
            $self->add_obj($result, $num, $value);
            $result->{' realised'} = 1;
        }
        $str = update($fh, $str) if $update;       # thanks to kundrat@kundrat.sk
        $str =~ s/^endobj//;
    }

    # Name
    elsif ($str =~ m|^/($reg_char*)|s) {
        $value = $1;
        $str =~ s|^/($reg_char*)||s;
        $result = PDF::API2::Basic::PDF::Name->from_pdf($value, $self);
    }

    # Literal String
    elsif ($str =~ m/^\(/) {
        # We now need to find an unbalanced, unescaped right-paren.
        # This can't be done with a regex.
        my $value = '(';
        $str = substr($str, 1);

        my $nested_level = 1;
        while (1) {
            # Ignore everything up to the first escaped or parenthesis character
            if ($str =~ /^([^\\()]+)(.*)/s) {
                $value .= $1;
                $str = $2;
            }

            # Ignore escaped parentheses
            if ($str =~ /^(\\[()])/) {
                $value .= $1;
                $str = substr($str, 2);
            }

            # Left parenthesis: increase nesting
            elsif ($str =~ /^\(/) {
                $value .= '(';
                $str = substr($str, 1);
                $nested_level++;
            }

            # Right parenthesis: decrease nesting
            elsif ($str =~ /^\)/) {
                $value .= ')';
                $str = substr($str, 1);
                $nested_level--;
                last unless $nested_level;
            }

            # Other escaped character
            elsif ($str =~ /^(\\[^()])/) {
                $value .= $1;
                $str = substr($str, 2);
            }

            # If there wasn't an escaped or parenthesis character,
            # read some more.
            else {
                # We don't use update because we don't want to remove
                # whitespace or comments.
                $fh->read($str, 255, length($str)) or die 'Unterminated string.';
            }
        }

        $result = PDF::API2::Basic::PDF::String->from_pdf($value);
    }

    # Hex String
    elsif ($str =~ m/^</) {
        $str =~ s/^<//;
        $fh->read($str, 255, length($str)) while (0 > index($str, '>'));
        ($value, $str) = ($str =~ /^(.*?)>(.*)/s);
        $result = PDF::API2::Basic::PDF::String->from_pdf('<' . $value . '>');
    }

    # Array
    elsif ($str =~ m/^\[/) {
        $str =~ s/^\[//;
        $str = update($fh, $str) if $update;
        $result = PDFArray();
        while ($str !~ m/^\]/) {
            $str =~ s/^$ws_char+//;               # Ignore initial white space
            $str =~ s/^\%[^\015\012]*$ws_char+//; # Ignore comments

            ($value, $str) = $self->readval($str, %opts);
            $result->add_elements($value);
            $str = update($fh, $str) if $update;   # str might just be exhausted!
        }
        $str =~ s/^\]//;
    }

    # Boolean
    elsif ($str =~ m/^(true|false)($irreg_char|$)/) {
        $value = $1;
        $str =~ s/^(?:true|false)//;
        $result = PDF::API2::Basic::PDF::Bool->from_pdf($value);
    }

    # Number
    elsif ($str =~ m/^([+-.0-9]+)($irreg_char|$)/) {
        $value = $1;
        $str =~ s/^([+-.0-9]+)//;

        # If $str only consists of whitespace (or is empty), call update to
        # see if this is the beginning of an indirect object or reference
        if ($update and ($str =~ /^$re_whitespace*$/s or $str =~ /^$re_whitespace+[0-9]+$re_whitespace*$/s)) {
            $str =~ s/^$re_whitespace+/ /s;
            $str =~ s/$re_whitespace+$/ /s;
            $str = update($fh, $str);
            if ($str =~ m/^$re_whitespace*([0-9]+)$re_whitespace+(?:R|obj)/s) {
                return $self->readval("$value $str", %opts);
            }
        }

        $result = PDF::API2::Basic::PDF::Number->from_pdf($value);
    }

    # Null
    elsif ($str =~ m/^null($irreg_char|$)/) {
        $str =~ s/^null//;
        $result = PDF::API2::Basic::PDF::Null->new;
    }

    else {
        die "Can't parse `$str' near " . ($fh->tell()) . " length " . length($str) . ".";
    }

    $str =~ s/^$ws_char+//s;
    return ($result, $str);
}


=head2 $ref = $p->read_obj($objind, %opts)

Given an indirect object reference, locate it and read the object returning
the read in object.

=cut

sub read_obj {
    my ($self, $objind, %opts) = @_;

    my $res = $self->read_objnum($objind->{' objnum'}, $objind->{' objgen'}, %opts) || return;
    $objind->merge($res) unless $objind eq $res;
    return $objind;
}


=head2 $ref = $p->read_objnum($num, $gen, %opts)

Returns a fully read object of given number and generation in this file

=cut

sub read_objnum {
    my ($self, $num, $gen, %opts) = @_;
    croak 'Undefined object number in call to read_objnum($num, $gen)' unless defined $num;
    croak 'Undefined object generation in call to read_objnum($num, $gen)' unless defined $gen;
    croak "Invalid object number '$num' in call to read_objnum" unless $num =~ /^[0-9]+$/;
    croak "Invalid object generation '$gen' in call to read_objnum" unless $gen =~ /^[0-9]+$/;

    my $object_location = $self->locate_obj($num, $gen) || return;
    my $object;

    # Compressed object
    if (ref($object_location)) {
        my ($object_stream_num, $object_stream_pos) = @{$object_location};

        my $object_stream = $self->read_objnum($object_stream_num, 0, %opts);
        die 'Cannot find the compressed object stream' unless $object_stream;

        $object_stream->read_stream() if $object_stream->{' nofilt'};

        # An object stream starts with pairs of integers containing object numbers and
        # stream offsets relative to the First key
        my $fh;
        my $pairs;
        unless ($object_stream->{' streamfile'}) {
            $pairs = substr($object_stream->{' stream'}, 0, $object_stream->{'First'}->val);
        }
        else {
            CORE::open($fh, '<', $object_stream->{' streamfile'});
            read($fh, $pairs, $object_stream->{'First'}->val());
        }
        my @map = split /\s+/, $pairs;

        # Find the offset of the object in the stream
        my $index = $object_stream_pos * 2;
        die "Objind $num does not exist at index $index" unless $map[$index] == $num;
        my $start = $map[$index + 1];

        # Unless this is the last object in the stream, its length is determined by the
        # offset of the next object
        my $last_object_in_stream = $map[-2];
        my $length;
        if ($last_object_in_stream == $num) {
            if ($object_stream->{' stream'}) {
                $length = length($object_stream->{' stream'}) - $object_stream->{'First'}->val() - $start;
            }
            else {
                $length = (-s $object_stream->{' streamfile'}) - $object_stream->{'First'}->val() - $start;
            }
        }
        else {
            my $next_start = $map[$index + 3];
            $length = $next_start - $start;
        }

        # Read the object from the stream
        my $stream = "$num 0 obj ";
        unless ($object_stream->{' streamfile'}) {
            $stream .= substr($object_stream->{' stream'}, $object_stream->{'First'}->val() + $start, $length);
        }
        else {
            seek($fh, $object_stream->{'First'}->val() + $start, 0);
            read($fh, $stream, $length, length($stream));
            close $fh;
        }

        ($object) = $self->readval($stream, %opts, update => 0);
        return $object;
    }

    my $current_location = $self->{' INFILE'}->tell;
    $self->{' INFILE'}->seek($object_location, 0);
    ($object) = $self->readval('', %opts);
    $self->{' INFILE'}->seek($current_location, 0);
    return $object;
}


=head2 $objind = $p->new_obj($obj)

Creates a new, free object reference based on free space in the cross reference chain.
If nothing free then thinks up a new number. If $obj then turns that object into this
new object rather than returning a new object.

=cut

sub new_obj {
    my ($self, $base) = @_;
    my $res;

    if (defined $self->{' free'} and scalar @{$self->{' free'}} > 0) {
        $res = shift(@{$self->{' free'}});
        if (defined $base) {
            my ($num, $gen) = @{$self->{' objects'}{$res->uid}};
            $self->remove_obj($res);
            $self->add_obj($base, $num, $gen);
            return $self->out_obj($base);
        }
        else {
            $self->{' objects'}{$res->uid}[2] = 0;
            return $res;
        }
    }

    my $tdict = $self;
    my $i;
    while (defined $tdict) {
        $i = $tdict->{' xref'}{defined($i) ? $i : ''}[0];
        while (defined $i and $i != 0) {
            my ($ni, $ng) = @{$tdict->{' xref'}{$i}};
            unless (defined $self->locate_obj($i, $ng)) {
                if (defined $base) {
                    $self->add_obj($base, $i, $ng);
                    return $base;
                }
                else {
                    $res = $self->test_obj($i, $ng) || $self->add_obj(PDF::API2::Basic::PDF::Objind->new(), $i, $ng);
                    $self->out_obj($res);
                    return $res;
                }
            }
            $i = $ni;
        }
        $tdict = $tdict->{' prev'};
    }

    $i = $self->{' maxobj'}++;
    if (defined $base) {
        $self->add_obj($base, $i, 0);
        $self->out_obj($base);
        return $base;
    }
    else {
        $res = $self->add_obj(PDF::API2::Basic::PDF::Objind->new(), $i, 0);
        $self->out_obj($res);
        return $res;
    }
}


=head2 $p->out_obj($objind)

Indicates that the given object reference should appear in the output xref
table whether with data or freed.

=cut

sub out_obj {
    my ($self, $obj) = @_;

    # This is why we've been keeping the outlist CACHE around; to speed
    # up this method by orders of magnitude (it saves up from having to
    # grep the full outlist each time through as we'll just do a lookup
    # in the hash) (which is super-fast).
    unless (exists $self->{' outlist_cache'}{$obj}) {
        push @{$self->{' outlist'}}, $obj;
        # weaken $self->{' outlist'}->[-1];
        $self->{' outlist_cache'}{$obj} = 1;
    }
    return $obj;
}


=head2 $p->free_obj($objind)

Marks an object reference for output as being freed.

=cut

sub free_obj {
    my ($self, $obj) = @_;

    push @{$self->{' free'}}, $obj;
    $self->{' objects'}{$obj->uid()}[2] = 1;
    $self->out_obj($obj);
}


=head2 $p->remove_obj($objind)

Removes the object from all places where we might remember it

=cut

sub remove_obj {
    my ($self, $objind) = @_;

    # who says it has to be fast
    delete $self->{' objects'}{$objind->uid()};
    delete $self->{' outlist_cache'}{$objind};
    delete $self->{' printed_cache'}{$objind};
    @{$self->{' outlist'}} = grep($_ ne $objind, @{$self->{' outlist'}});
    @{$self->{' printed'}} = grep($_ ne $objind, @{$self->{' printed'}});
    $self->{' objcache'}{$objind->{' objnum'}, $objind->{' objgen'}} = undef
        if $self->{' objcache'}{$objind->{' objnum'}, $objind->{' objgen'}} eq $objind;
    return $self;
}


=head2 $p->ship_out(@objects)

Ships the given objects (or all objects for output if @objects is empty) to
the currently open output file (assuming there is one). Freed objects are not
shipped, and once an object is shipped it is switched such that this file
becomes its source and it will not be shipped again unless out_obj is called
again. Notice that a shipped out object can be re-output or even freed, but
that it will not cause the data already output to be changed.

=cut

sub ship_out {
    my ($self, @objs) = @_;

    return unless defined $self->{' OUTFILE'};
    my $fh = $self->{' OUTFILE'};
    seek($fh, 0, 2); # go to the end of the file

    @objs = @{$self->{' outlist'}} unless scalar @objs > 0;
    foreach my $objind (@objs) {
        next unless $objind->is_obj($self);
        my $j = -1;
        for (my $i = 0; $i < scalar @{$self->{' outlist'}}; $i++) {
            if ($self->{' outlist'}[$i] eq $objind) {
                $j = $i;
                last;
            }
        }
        next if $j < 0;
        splice(@{$self->{' outlist'}}, $j, 1);
        delete $self->{' outlist_cache'}{$objind};
        next if grep { $_ eq $objind } @{$self->{' free'}};

        map { $fh->print("\%   $_ \n") } split(/$cr/, $objind->{' comments'}) if $objind->{' comments'};
        $self->{' locs'}{$objind->uid()} = $fh->tell();
        my ($objnum, $objgen) = @{$self->{' objects'}{$objind->uid()}}[0..1];
        $fh->printf('%d %d obj ', $objnum, $objgen);
        $objind->outobjdeep($fh, $self, 'objnum' => $objnum, 'objgen' => $objgen);
        $fh->print(" endobj\n");

        # Note that we've output this obj, not forgetting to update
        # the cache of whats printed.
        unless (exists $self->{' printed_cache'}{$objind}) {
            push @{$self->{' printed'}}, $objind;
            $self->{' printed_cache'}{$objind}++;
        }
    }
    return $self;
}

=head2 $p->copy($outpdf, \&filter)

Iterates over every object in the file reading the object, calling filter with the object
and outputting the result. if filter is not defined, then just copies input to output.

=cut

sub copy {
    my ($self, $out, $filter) = @_;
    my ($obj, $minl, $mini, $ming);

    foreach my $key (grep { not m/^[\s\-]/ } keys %$self) {
        $out->{$key} = $self->{$key} unless defined $out->{$key};
    }

    my $tdict = $self;
    while (defined $tdict) {
        foreach my $i (sort {$a <=> $b} keys %{$tdict->{' xref'}}) {
            my ($nl, $ng, $nt) = @{$tdict->{' xref'}{$i}};
            next unless $nt eq 'n';

            if ($nl < $minl or $mini == 0) {
                $mini = $i;
                $ming = $ng;
                $minl = $nl;
            }
            unless ($obj = $self->test_obj($i, $ng)) {
                $obj = PDF::API2::Basic::PDF::Objind->new();
                $obj->{' objnum'} = $i;
                $obj->{' objgen'} = $ng;
                $self->add_obj($obj, $i, $ng);
                $obj->{' parent'} = $self;
                weaken $obj->{' parent'};
                $obj->{' realised'} = 0;
            }
            $obj->realise;
            my $res = defined $filter ? &{$filter}($obj) : $obj;
            $out->new_obj($res) unless (!$res || $res->is_obj($out));
        }
        $tdict = $tdict->{' prev'};
    }

    # test for linearized and remove it from output
    $obj = $self->test_obj($mini, $ming);
    if ($obj->isa('PDF::API2::Basic::PDF::Dict') && $obj->{'Linearized'}) {
        $out->free_obj($obj);
    }

    return $self;
}


=head1 PRIVATE METHODS & FUNCTIONS

The following methods and functions are considered private to this class. This
does not mean you cannot use them if you have a need, just that they aren't really
designed for users of this class.

=head2 $offset = $p->locate_obj($num, $gen)

Returns a file offset to the object asked for by following the chain of cross
reference tables until it finds the one you want.

=cut

sub locate_obj {
    my ($self, $num, $gen) = @_;

    my $tdict = $self;
    while (defined $tdict) {
        if (ref $tdict->{' xref'}{$num}) {
            my $ref = $tdict->{' xref'}{$num};
            return $ref unless scalar(@$ref) == 3;

            if ($ref->[1] == $gen) {
                return $ref->[0] if $ref->[2] eq 'n';
                return;        # if $ref->[2] eq 'f';
            }
        }
        $tdict = $tdict->{' prev'};
    }
    return;
}


=head2 update($fh, $str, $instream)

Keeps reading $fh for more data to ensure that $str has at least a line full
for C<readval> to work on. At this point we also take the opportunity to ignore
comments.

=cut

sub update {
    my ($fh, $str, $instream) = @_;
    print STDERR 'fpos=' . tell($fh) . ' strlen=' . length($str) . "\n" if $readDebug;
    if ($instream) {
        # we are inside a (possible binary) stream
        # so we fetch data till we see an 'endstream'
        # -- fredo/2004-09-03
        while ($str !~ m/endstream/ and not $fh->eof()) {
            print STDERR 'fpos=' . tell($fh) . ' strlen=' . length($str) . "\n" if $readDebug;
            $fh->read($str, 314, length($str));
        }
    }
    else {
        $str =~ s/^$ws_char*//;
        while ($str !~ m/$cr/ and not $fh->eof()) {
            print STDERR 'fpos=' . tell($fh) . ' strlen=' . length($str) . "\n" if $readDebug;
            $fh->read($str, 314, length($str));
            $str =~ s/^$ws_char*//so;
        }
        while ($str =~ m/^\%/) { # restructured by fredo/2003-03-23
            print STDERR 'fpos=' . tell($fh) . ' strlen=' . length($str) . "\n" if $readDebug;
            $fh->read($str, 314, length($str)) while ($str !~ m/$cr/ and not $fh->eof());
            $str =~ s/^\%[^\015\012]*$ws_char*//so; # fixed for reportlab -- fredo
        }
    }

    return $str;
}

=head2 $objind = $p->test_obj($num, $gen)

Tests the cache to see whether an object reference (which may or may not have
been getobj()ed) has been cached. Returns it if it has.

=cut

sub test_obj {
    my ($self, $num, $gen) = @_;
    return $self->{' objcache'}{$num, $gen};
}


=head2 $p->add_obj($objind)

Adds the given object to the internal object cache.

=cut

sub add_obj {
    my ($self, $obj, $num, $gen) = @_;

    $self->{' objcache'}{$num, $gen} = $obj;
    $self->{' objects'}{$obj->uid()} = [$num, $gen];
    # weaken $self->{' objcache'}{$num, $gen};
    return $obj;
}


=head2 $tdict = $p->readxrtr($xpos)

Recursive function which reads each of the cross-reference and trailer tables
in turn until there are no more.

Returns a dictionary corresponding to the trailer chain. Each trailer also
includes the corresponding cross-reference table.

The structure of the xref private element in a trailer dictionary is of an
anonymous hash of cross reference elements by object number. Each element
consists of an array of 3 elements corresponding to the three elements read
in [location, generation number, free or used]. See the PDF specification
for details.

=cut

sub _unpack_xref_stream {
    my ($self, $width, $data) = @_;

    return unpack('C', $data)       if $width == 1;
    return unpack('n', $data)       if $width == 2;
    return unpack('N', "\x00$data") if $width == 3;
    return unpack('N', $data)       if $width == 4;

    die "Invalid column width: $width";
}

sub readxrtr {
    my ($self, $xpos) = @_;
    my ($tdict, $buf, $xmin, $xnum, $xdiff);

    my $fh = $self->{' INFILE'};
    $fh->seek($xpos, 0);
    $fh->read($buf, 22);
    $buf = update($fh, $buf); # fix for broken JAWS xref calculation.

    my $xlist = {};

    ## seams that some products calculate wrong prev entries (short)
    ## so we seek ahead to find one -- fredo; save for now
    #while($buf !~ m/^xref$cr/i && !eof($fh))
    #{
    #    $buf =~ s/^(\s+|\S+|.)//i;
    #    $buf=update($fh,$buf);
    #}

    if ($buf =~ s/^xref$cr//i) {
        # Plain XRef tables.
        while ($buf =~ m/^$ws_char*([0-9]+)$ws_char+([0-9]+)$ws_char*$cr(.*?)$/s) {
            my $old_buf = $buf;
            $xmin = $1;
            $xnum = $2;
            $buf  = $3;
            unless ($old_buf =~ /^[0-9]+ [0-9]+$cr/) {
                # See PDF 1.7 section 7.5.4: Cross-Reference Table
                warn q{Malformed xref in PDF file: subsection shall begin with a line containing two numbers separated by a SPACE (20h)};
            }
            $xdiff = length($buf);

            $fh->read($buf, 20 * $xnum - $xdiff + 15, $xdiff);
            while ($xnum-- > 0 and $buf =~ s/^0*([0-9]*)$ws_char+0*([0-9]+)$ws_char+([nf])$cr//) {
                $xlist->{$xmin} = [$1, $2, $3] unless exists $xlist->{$xmin};
                $xmin++;
            }
        }

        if ($buf !~ /^\s*trailer\b/i) {
            die "Malformed trailer in PDF file $self->{' fname'} at " . ($fh->tell - length($buf));
        }

        $buf =~ s/^\s*trailer\b//i;

        ($tdict, $buf) = $self->readval($buf);
    }
    elsif ($buf =~ m/^(\d+)\s+(\d+)\s+obj/i) {
        my ($xref_obj, $xref_gen) = ($1, $2);

        # XRef streams.
        ($tdict, $buf) = $self->readval($buf);

        unless ($tdict->{' stream'}) {
            die "Malformed XRefStm at $xref_obj $xref_gen obj in PDF file $self->{' fname'}";
        }
        $tdict->read_stream(1);

        my $stream = $tdict->{' stream'};
        my @widths = map { $_->val } @{$tdict->{W}->val};

        my $start = 0;
        my $last;

        my @index;
        if (defined $tdict->{Index}) {
            @index = map { $_->val() } @{$tdict->{Index}->val};
        }
        else {
            @index = (0, $tdict->{Size}->val);
        }

        while (scalar @index) {
            $start = shift(@index);
            $last = $start + shift(@index) - 1;

            for my $i ($start...$last) {
                # Replaced "for $xmin" because it creates a loop-specific local variable, and we
                # need $xmin to be correct for maxobj below.
                $xmin = $i;

                my @cols;

                for my $w (@widths) {
                    my $data;
                    $data = $self->_unpack_xref_stream($w, substr($stream, 0, $w, '')) if $w;

                    push @cols, $data;
                }

                $cols[0] = 1 unless defined $cols[0];
                if ($cols[0] > 2) {
                    die "Invalid XRefStm entry type ($cols[0]) at $xref_obj $xref_gen obj";
                }

                next if exists $xlist->{$xmin};

                my @objind = ($cols[1], defined($cols[2]) ? $cols[2] : ($xmin ? 0 : 65535));
                push @objind, ($cols[0] == 0 ? 'f' : 'n') if $cols[0] < 2;

                $xlist->{$xmin} = \@objind;
            }
        }
    }
    else {
        die "Malformed xref in PDF file $self->{' fname'}";
    }

    $tdict->{' loc'} = $xpos;
    $tdict->{' xref'} = $xlist;
    $self->{' maxobj'} = $xmin + 1 if $xmin + 1 > $self->{' maxobj'};
    $tdict->{' prev'} = $self->readxrtr($tdict->{'Prev'}->val)
        if (defined $tdict->{'Prev'} and $tdict->{'Prev'}->val != 0);
    delete $tdict->{' prev'} unless defined $tdict->{' prev'};
    return $tdict;
}


=head2 $p->out_trailer($tdict)

Outputs the body and trailer for a PDF file by outputting all the objects in
the ' outlist' and then outputting a xref table for those objects and any
freed ones. It then outputs the trailing dictionary and the trailer code.

=cut

sub out_trailer {
    my ($self, $tdict, $update) = @_;
    my $fh = $self->{' OUTFILE'};

    while (@{$self->{' outlist'}}) {
        $self->ship_out();
    }

    #    $size = @{$self->{' printed'}} + @{$self->{' free'}};
    #    $tdict->{'Size'} = PDFNum($tdict->{'Size'}->val + $size);
    # PDFSpec 1.3 says for /Size: (Required) Total number of entries in the file's
    # cross-reference table, including the original table and all updates. Which
    # is what the previous two lines implement.
    # But this seems to make Acrobat croak on saving so we try the following from
    # basil.duval@epfl.ch
    $tdict->{'Size'} = PDFNum($self->{' maxobj'});

    my $tloc = $fh->tell();
    $fh->print("xref\n");

    my @xreflist = sort { $self->{' objects'}{$a->uid}[0] <=> $self->{' objects'}{$b->uid}[0] } (@{$self->{' printed'} || []}, @{$self->{' free'} || []});

    my ($i, $j, $k);
    unless ($update) {
        $i = 1;
        for ($j = 0; $j < @xreflist; $j++) {
            my @inserts;
            $k = $xreflist[$j];
            while ($i < $self->{' objects'}{$k->uid}[0]) {
                my ($n) = PDF::API2::Basic::PDF::Objind->new();
                $self->add_obj($n, $i, 0);
                $self->free_obj($n);
                push(@inserts, $n);
                $i++;
            }
            splice(@xreflist, $j, 0, @inserts);
            $j += @inserts;
            $i++;
        }
    }

    my @freelist = sort { $self->{' objects'}{$a->uid}[0] <=> $self->{' objects'}{$b->uid}[0] } @{$self->{' free'} || []};

    $j = 0; my $first = -1; $k = 0;
    for ($i = 0; $i <= $#xreflist + 1; $i++) {
#        if ($i == 0) {
#            $first = $i; $j = $xreflist[0]->{' objnum'};
#            $fh->printf("0 1\n%010d 65535 f \n", $ff);
#        }
        if ($i > $#xreflist || $self->{' objects'}{$xreflist[$i]->uid}[0] != $j + 1) {
            $fh->print(($first == -1 ? "0 " : "$self->{' objects'}{$xreflist[$first]->uid}[0] ") . ($i - $first) . "\n");
            if ($first == -1) {
                $fh->printf("%010d 65535 f \n", defined $freelist[$k] ? $self->{' objects'}{$freelist[$k]->uid}[0] : 0);
                $first = 0;
            }
            for ($j = $first; $j < $i; $j++) {
                my $xref = $xreflist[$j];
                if (defined $freelist[$k] && defined $xref && "$freelist[$k]" eq "$xref") {
                    $k++;
                    $fh->print(pack("A10AA5A4",
                                    sprintf("%010d", (defined $freelist[$k] ?
                                                      $self->{' objects'}{$freelist[$k]->uid}[0] : 0)), " ",
                                    sprintf("%05d", $self->{' objects'}{$xref->uid}[1] + 1),
                                    " f \n"));
                }
                else {
                    $fh->print(pack("A10AA5A4", sprintf("%010d", $self->{' locs'}{$xref->uid}), " ",
                            sprintf("%05d", $self->{' objects'}{$xref->uid}[1]),
                            " n \n"));
                }
            }
            $first = $i;
            $j = $self->{' objects'}{$xreflist[$i]->uid}[0] if ($i < scalar @xreflist);
        }
        else {
            $j++;
        }
    }
    $fh->print("trailer\n");
    $tdict->outobjdeep($fh, $self);
    $fh->print("\nstartxref\n$tloc\n%%EOF\n");
}


=head2 PDF::API2::Basic::PDF::File->_new

Creates a very empty PDF file object (used by new and open)

=cut

sub _new {
    my $class = shift();
    my $self = {};

    bless $self, $class;
    $self->{' outlist'} = [];
    $self->{' outlist_cache'} = {};     # A cache of whats in the 'outlist'
    $self->{' maxobj'} = 1;
    $self->{' objcache'} = {};
    $self->{' objects'} = {};

    return $self;
}

1;

=head1 AUTHOR

Martin Hosken Martin_Hosken@sil.org

Copyright Martin Hosken 1999 and onwards

No warranty or expression of effectiveness, least of all regarding anyone's
safety, is implied in this software or documentation.
