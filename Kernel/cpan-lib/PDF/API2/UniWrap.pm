package PDF::API2::UniWrap;

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $VERSION = '2.033'; # VERSION

# Implements UAX#14: Line Breaking Properties
# David Nesting <david@fastolfe.net>

BEGIN {

    use Encode qw(:all);

    use 5.008;
    use base 'Exporter';

    use Unicode::UCD;
    use Carp;

}

our $DEBUG = 0;
our $columns = 75;

my %classified;
my $procedural_self;
my $txt;

use constant PROHIBITED => 0;
use constant INDIRECT   => 1;
use constant DIRECT     => 2;
use constant REQUIRED   => 3;

my @CLASSES =  qw{ OP CL QU GL NS EX SY IS PR PO NU AL ID IN HY BA BB B2 ZW CM };
my %BREAK_TABLE = (
    OP => [qw[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  ]],
    CL => [qw[ 2  0  1  1  0  0  0  0  2  1  2  2  2  2  1  1  2  2  0  1  ]],
    QU => [qw[ 0  0  1  1  1  0  0  0  1  1  1  1  1  1  1  1  1  1  0  1  ]],
    GL => [qw[ 1  0  1  1  1  0  0  0  1  1  1  1  1  1  1  1  1  1  0  1  ]],
    NS => [qw[ 2  0  1  1  1  0  0  0  2  2  2  2  2  2  1  1  2  2  0  1  ]],
    EX => [qw[ 2  0  1  1  1  0  0  0  2  2  2  2  2  2  1  1  2  2  0  1  ]],
    SY => [qw[ 2  0  1  1  1  0  0  0  2  2  1  2  2  2  1  1  2  2  0  1  ]],
    IS => [qw[ 2  0  1  1  1  0  0  0  2  2  1  2  2  2  1  1  2  2  0  1  ]],
    PR => [qw[ 1  0  1  1  1  0  0  0  2  2  1  1  1  2  1  1  2  2  0  1  ]],
    PO => [qw[ 2  0  1  1  1  0  0  0  2  2  2  2  2  2  1  1  2  2  0  1  ]],
    NU => [qw[ 2  0  1  1  1  0  0  0  2  1  1  1  2  1  1  1  2  2  0  1  ]],
    AL => [qw[ 2  0  1  1  1  0  0  0  2  2  1  1  2  1  1  1  2  2  0  1  ]],
    ID => [qw[ 2  0  1  1  1  0  0  0  2  1  2  2  2  1  1  1  2  2  0  1  ]],
    IN => [qw[ 2  0  1  1  1  0  0  0  2  2  2  2  2  1  1  1  2  2  0  1  ]],
    HY => [qw[ 2  0  1  1  1  0  0  0  2  2  0  2  2  2  1  1  2  2  0  1  ]],
    BA => [qw[ 2  0  1  1  1  0  0  0  2  2  2  2  2  2  1  1  2  2  0  1  ]],
    BB => [qw[ 1  0  1  1  1  0  0  0  1  1  1  1  1  1  1  1  1  1  0  1  ]],
    B2 => [qw[ 2  0  1  1  1  0  0  0  2  2  2  2  2  2  1  1  2  0  0  1  ]],
    ZW => [qw[ 2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  0  1  ]],
    CM => [qw[ 2  0  1  1  1  0  0  0  2  2  1  1  2  1  1  1  2  2  0  1  ]],
);

# Convert the table above into a hash that we can use for speedier lookups

foreach (keys %BREAK_TABLE) {
    my @t = @CLASSES;
    $BREAK_TABLE{$_} = { map { shift(@t) => $_ } @{$BREAK_TABLE{$_}} };
}

sub new {
    my $pkg = shift;
    my $self = { @_ };
    $self->{line_length} ||= $columns;
    $self->{break_table} ||= \%BREAK_TABLE;

    $self->{widthfunc} ||= 1;

    bless($self, ref($pkg) || $pkg);
}


# This attempts to identify the on-screen length of a given character.
# For normal displays, you can generally assume the character has a
# length of 1, but some terminals may expand the width of certain
# characters, so that extra space needs to be taken into consideration
# here so the wrapping occurs at the proper place.

sub char_length {
    shift if ref($_[0]);
    my ($c) = @_;

    if ($c eq 'CM' || $c eq 'ZW') {
        return 0;
    }

    return 1;
}

sub lb_class {
    my $self = ref($_[0]) ? shift() : self();
    my $code = Unicode::UCD::_getcode(ord $_[0]);
    my $hex;

    if (defined $code) {
        $hex = sprintf "%04X", $code;
    } else {
        carp("unexpected arg \"$_[1]\" to Text::Wrap::lb_class()");
        return;
    }

    return $classified{$hex} if $classified{$hex};

    $txt = do "unicore/Lbrk.pl" unless $txt;

    if ($txt =~ m/^$hex\t\t(.+)/m) {
        print STDERR "< found direct match for $hex = $1 >\n" if $DEBUG > 1;
        return $classified{$hex} = $1;
    } else {
        print STDERR "< no direct match $hex >\n" if $DEBUG > 1;
        pos($txt) = 0;

        while ($txt =~ m/^([0-9A-F]+)\t([0-9A-F]+)\t(.+)/mg) {
            print STDERR "< examining $1 -> $2 >\n" if $DEBUG > 1;
            if (hex($1) <= $code && hex($2) >= $code) {
                print STDERR "< found range match for $hex = $3 between $1 and $2 >\n" if $DEBUG > 1;
                return $classified{$hex} = $3;
            }
        }
        return 'XX';
    }
}

# Returns a list of breaking properties for the given text
sub text_properties {
    my $self = ref($_[0]) ? shift() : self();
    my ($text) = @_;

    my @characters = split(//, $text);
    my @classifications = map { $self->lb_class($_) } @characters;

    class_properties(@classifications);
}

# Returns a list of breaking properties for the provided breaking classes
sub class_properties {
    my $self = ref($_[0]) ? shift() : self();
    no warnings 'uninitialized';

    my @breaks;
    my $last_class = $_[0];

    $last_class = 'ID' if $last_class eq 'CM';  # broken combining mark

    print STDERR "find_breaks: first class=$last_class\n" if $DEBUG;

    for (my $i = 1; $i <= $#_; $i++) {
        print STDERR "find_breaks: i=$i class=$_[$i] prev=$last_class breaks[i-1]=$breaks[$i-1]\n" if $DEBUG;
        $breaks[$i-1] ||= 0;

        $_[$i] = 'ID' if $_[$i] eq 'XX';    # we want as few of these as possible!

        if ($_[$i] eq 'SA') {
            # TODO: Need a classifiation system for complex characters
        }

        elsif ($_[$i] eq 'CR') {
            $breaks[$i] = REQUIRED;
        }

        elsif ($_[$i] eq 'LF') {
            if ($_[$i-1] eq 'CR') {
                $breaks[$i-1] = PROHIBITED;
            }
            $breaks[$i] = REQUIRED;
        }

        elsif ($_[$i] eq 'BK') {
            $breaks[$i] = REQUIRED;
        }

        elsif ($_[$i] eq 'SP') {
            $breaks[$i-1] = PROHIBITED;
            next;
        }

        elsif ($_[$i] eq 'CM') {
            if ($_[$i-1] eq 'SP') {
                $last_class = 'ID';
                if ($i > 1) {
                    $breaks[$i-2] = $self->{break_table}->{$_[$i-2]}->{ID} ==
                        DIRECT ? DIRECT : PROHIBITED;
                }
            }
        }

        elsif ($last_class ne 'SP') {
            if ($breaks[$i-1] != REQUIRED) {
                my $this_break = $self->{break_table}->{$last_class}->{$_[$i]};

                if ($this_break == INDIRECT) {
                    $breaks[$i-1] = $_[$i-1] eq 'SP' ? INDIRECT : PROHIBITED;
                } else {
                   # die "internal error: no table mapping between '$last_class' and '$_[$i]'\n"
                   #     unless defined $this_break;
                   if(defined $this_break)
                   {
                    $breaks[$i-1] = $this_break;
                   }
                   else
                   {
                    $breaks[$i-1] = DIRECT;
                   }
                }
            }
        }

        $last_class = $_[$i];
    }

    # $breaks[$#breaks] = DIRECT;
    push(@breaks, REQUIRED);

    print STDERR "find_breaks: returning " . join(":", @breaks) . "\n" if $DEBUG;
    return @breaks;
}

# Returns a list of break points in the provided text, based on
# the line length
sub find_breaks {
    my $self = ref($_[0]) ? shift() : self();
    my $text = shift;

    no warnings 'uninitialized';    # since we do a lot of subscript +/- 1 checks

    my @characters = split //, $text;

    my @classifications = map { $self->lb_class($_) } @characters;
    my @lengths = map { $self->char_length($_) } @characters;

    my @breaks  = $self->class_properties(@classifications);
    my @breakpoints;

    my $last_start = 0;
    my $last_break;
    my $last_length;
    my $pos = 0;

    for (my $i = 0; $i <= $#lengths; $i++) {

        print STDERR "[i=$i '$characters[$i]' $classifications[$i] $breaks[$i]] " if $DEBUG;
        if ($breaks[$i] == REQUIRED) {
            print STDERR "required breakpoint\n" if $DEBUG;
            push(@breakpoints, $i+1);
            $last_start = $i+1;
            $pos = 0;
            next;
        }

        my $c = $pos + $lengths[$i];

        if ($c > $self->{line_length}) {
            print STDERR "want to break " if $DEBUG;
            if (defined $last_break) {
                print STDERR "at $last_break\n" if $DEBUG;
                push(@breakpoints, $last_break + 1);
                $last_start = $last_break + 1;
                undef $last_break;
                $pos -= $last_length - 1;
                print STDERR "[pos now $pos]\n" if $DEBUG;
                next;
            } elsif (defined $self->{emergency_break} && $c > $self->{emergency_break}) {
                print STDERR "NOW\n" if $DEBUG;
                push(@breakpoints, $i+1);
                $pos = 0;
            } else {
                print STDERR "but can't" if $DEBUG;
            }
        }
        print STDERR "\n" if $DEBUG;

        $last_break = $i if $breaks[$i];
        $last_length = $pos if $breaks[$i];

        $pos += $lengths[$i];
    }

    push(@breakpoints, $#lengths) if $breakpoints[$#breakpoints] < $#lengths;

    print STDERR "find_breaks: returning breakpoints " . join(":", @breakpoints) . "\n" if $DEBUG;

    return @breakpoints;
}

# Returns a list of lines, broken up with find_breaks
sub break_lines {
    my $self = ref($_[0]) ? shift() : self();
    my $text = shift;

    my @breaks = $self->find_breaks($text);
    my @lines;

    my $last = 0;
    foreach (@breaks) {
        push(@lines, substr($text, $last, $_-$last));
        $last = $_;
    }

    return @lines;
}

1;

__END__
