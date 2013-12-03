package Text::CSV;


use strict;
use Carp ();
use vars qw( $VERSION $DEBUG );

BEGIN {
    $VERSION = '1.32';
    $DEBUG   = 0;
}

# if use CSV_XS, requires version
my $Module_XS  = 'Text::CSV_XS';
my $Module_PP  = 'Text::CSV_PP';
my $XS_Version = '0.99';

my $Is_Dynamic = 0;

# used in _load_xs and _load_pp
my $Install_Dont_Die = 1; # When _load_xs fails to load XS, don't die.
my $Install_Only     = 2; # Don't call _set_methods()


my @PublicMethods = qw/
    version types quote_char escape_char sep_char eol always_quote binary allow_whitespace
    keep_meta_info allow_loose_quotes allow_loose_escapes verbatim meta_info is_quoted is_binary eof
    getline print parse combine fields string error_diag error_input status blank_is_undef empty_is_undef
    getline_hr column_names bind_columns auto_diag quote_space quote_null getline_all getline_hr_all
    is_missing quote_binary record_number print_hr
    PV IV NV
/;
#
my @UndocumentedXSMethods = qw/Combine Parse SetDiag/;

my @UndocumentedPPMethods = qw//; # Currently empty


# Check the environment variable to decide worker module. 

unless ($Text::CSV::Worker) {
    $Text::CSV::DEBUG and  Carp::carp("Check used worker module...");

    if ( exists $ENV{PERL_TEXT_CSV} ) {
        if ($ENV{PERL_TEXT_CSV} eq '0' or $ENV{PERL_TEXT_CSV} eq 'Text::CSV_PP') {
            _load_pp();
        }
        elsif ($ENV{PERL_TEXT_CSV} eq '1' or $ENV{PERL_TEXT_CSV} =~ /Text::CSV_XS\s*,\s*Text::CSV_PP/) {
            _load_xs($Install_Dont_Die) or _load_pp();
        }
        elsif ($ENV{PERL_TEXT_CSV} eq '2' or $ENV{PERL_TEXT_CSV} eq 'Text::CSV_XS') {
            _load_xs();
        }
        else {
            Carp::croak "The value of environmental variable 'PERL_TEXT_CSV' is invalid.";
        }
    }
    else {
        _load_xs($Install_Dont_Die) or _load_pp();
    }

}



sub import {
    my ($class, $option) = @_;
}



sub new { # normal mode
    my $proto = shift;
    my $class = ref($proto) || $proto;

    unless ( $proto ) { # for Text::CSV_XS/PP::new(0);
        return eval qq| $Text::CSV::Worker\::new( \$proto ) |;
    }

    #if (ref $_[0] and $_[0]->{module}) {
    #    Carp::croak("Can't set 'module' in non dynamic mode.");
    #}

    if ( my $obj = $Text::CSV::Worker->new(@_) ) {
        $obj->{_MODULE} = $Text::CSV::Worker;
        bless $obj, $class;
        return $obj;
    }
    else {
        return;
    }


}


sub require_xs_version { $XS_Version; }


sub module {
    my $proto = shift;
    return   !ref($proto)            ? $Text::CSV::Worker
           :  ref($proto->{_MODULE}) ? ref($proto->{_MODULE}) : $proto->{_MODULE};
}

*backend = *module;


sub is_xs {
    return $_[0]->module eq $Module_XS;
}


sub is_pp {
    return $_[0]->module eq $Module_PP;
}


sub is_dynamic { $Is_Dynamic; }


sub AUTOLOAD {
    my $self = $_[0];
    my $attr = $Text::CSV::AUTOLOAD;
    $attr =~ s/.*:://;

    return if $attr =~ /^[A-Z]+$/;
    Carp::croak( "Can't locate method $attr" ) unless $attr =~ /^_/;

    my $pkg = $Text::CSV::Worker;

    my $method = "$pkg\::$attr";

    $Text::CSV::DEBUG and Carp::carp("'$attr' is private method, so try to autoload...");

    local $^W;
    no strict qw(refs);

    *{"Text::CSV::$attr"} = *{"$pkg\::$attr"};

    goto &$attr;
}



sub _load_xs {
    my $opt = shift;

    $Text::CSV::DEBUG and Carp::carp "Load $Module_XS.";

    eval qq| use $Module_XS $XS_Version |;

    if ($@) {
        if (defined $opt and $opt & $Install_Dont_Die) {
            $Text::CSV::DEBUG and Carp::carp "Can't load $Module_XS...($@)";
            return 0;
        }
        Carp::croak $@;
    }

    push @Text::CSV::ISA, 'Text::CSV_XS';

    unless (defined $opt and $opt & $Install_Only) {
        _set_methods( $Text::CSV::Worker = $Module_XS );
    }

    return 1;
};


sub _load_pp {
    my $opt = shift;

    $Text::CSV::DEBUG and Carp::carp "Load $Module_PP.";

    eval qq| require $Module_PP |;
    if ($@) {
        Carp::croak $@;
    }

    push @Text::CSV::ISA, 'Text::CSV_PP';

    unless (defined $opt and $opt & $Install_Only) {
        _set_methods( $Text::CSV::Worker = $Module_PP );
    }
};




sub _set_methods {
    my $class = shift;

    #return;

    local $^W;
    no strict qw(refs);

    for my $method (@PublicMethods) {
        *{"Text::CSV::$method"} = \&{"$class\::$method"};
    }

    if ($Text::CSV::Worker eq $Module_XS) {
        for my $method (@UndocumentedXSMethods) {
            *{"Text::CSV::$method"} = \&{"$Module_XS\::$method"};
        }
    }

    if ($Text::CSV::Worker eq $Module_PP) {
        for my $method (@UndocumentedPPMethods) {
            *{"Text::CSV::$method"} = \&{"$Module_PP\::$method"};
        }
    }

}



1;
__END__

=pod

=head1 NAME

Text::CSV - comma-separated values manipulator (using XS or PurePerl)


=head1 SYNOPSIS

 use Text::CSV;

 my @rows;
 my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                 or die "Cannot use CSV: ".Text::CSV->error_diag ();
 
 open my $fh, "<:encoding(utf8)", "test.csv" or die "test.csv: $!";
 while ( my $row = $csv->getline( $fh ) ) {
     $row->[2] =~ m/pattern/ or next; # 3rd field should match
     push @rows, $row;
 }
 $csv->eof or $csv->error_diag();
 close $fh;

 $csv->eol ("\r\n");
 
 open $fh, ">:encoding(utf8)", "new.csv" or die "new.csv: $!";
 $csv->print ($fh, $_) for @rows;
 close $fh or die "new.csv: $!";
 
 #
 # parse and combine style
 #
 
 $status = $csv->combine(@columns);    # combine columns into a string
 $line   = $csv->string();             # get the combined string
 
 $status  = $csv->parse($line);        # parse a CSV string into fields
 @columns = $csv->fields();            # get the parsed fields
 
 $status       = $csv->status ();      # get the most recent status
 $bad_argument = $csv->error_input (); # get the most recent bad argument
 $diag         = $csv->error_diag ();  # if an error occured, explains WHY
 
 $status = $csv->print ($io, $colref); # Write an array of fields
                                       # immediately to a file $io
 $colref = $csv->getline ($io);        # Read a line from file $io,
                                       # parse it and return an array
                                       # ref of fields
 $csv->column_names (@names);          # Set column names for getline_hr ()
 $ref = $csv->getline_hr ($io);        # getline (), but returns a hashref
 $eof = $csv->eof ();                  # Indicate if last parse or
                                       # getline () hit End Of File
 
 $csv->types(\@t_array);               # Set column types

=head1 DESCRIPTION

Text::CSV provides facilities for the composition and decomposition of
comma-separated values using L<Text::CSV_XS> or its pure Perl version.

An instance of the Text::CSV class can combine fields into a CSV string
and parse a CSV string into fields.

The module accepts either strings or files as input and can utilize any
user-specified characters as delimiters, separators, and escapes so it is
perhaps better called ASV (anything separated values) rather than just CSV.

=head1 VERSION

    1.32

This module is compatible with Text::CSV_XS B<0.99> and later.
(except for diag_verbose and allow_unquoted_escape)

=head2 Embedded newlines

B<Important Note>: The default behavior is to only accept ASCII characters.
This means that fields can not contain newlines. If your data contains
newlines embedded in fields, or characters above 0x7e (tilde), or binary data,
you *must* set C<< binary => 1 >> in the call to C<new ()>.  To cover the widest
range of parsing options, you will always want to set binary.

But you still have the problem that you have to pass a correct line to the
C<parse ()> method, which is more complicated from the usual point of
usage:

 my $csv = Text::CSV->new ({ binary => 1, eol => $/ });
 while (<>) {		#  WRONG!
     $csv->parse ($_);
     my @fields = $csv->fields ();

will break, as the while might read broken lines, as that does not care
about the quoting. If you need to support embedded newlines, the way to go
is either

 my $csv = Text::CSV->new ({ binary => 1, eol => $/ });
 while (my $row = $csv->getline (*ARGV)) {
     my @fields = @$row;

or, more safely in perl 5.6 and up

 my $csv = Text::CSV->new ({ binary => 1, eol => $/ });
 open my $io, "<", $file or die "$file: $!";
 while (my $row = $csv->getline ($io)) {
     my @fields = @$row;

=head2 Unicode (UTF8)

On parsing (both for C<getline ()> and C<parse ()>), if the source is
marked being UTF8, then all fields that are marked binary will also be
be marked UTF8.

For complete control over encoding, please use L<Text::CSV::Encoded>:

    use Text::CSV::Encoded;
    my $csv = Text::CSV::Encoded->new ({
        encoding_in  => "iso-8859-1", # the encoding comes into   Perl
        encoding_out => "cp1252",     # the encoding comes out of Perl
    });

    $csv = Text::CSV::Encoded->new ({ encoding  => "utf8" });
    # combine () and print () accept *literally* utf8 encoded data
    # parse () and getline () return *literally* utf8 encoded data

    $csv = Text::CSV::Encoded->new ({ encoding  => undef }); # default
    # combine () and print () accept UTF8 marked data
    # parse () and getline () return UTF8 marked data

On combining (C<print ()> and C<combine ()>), if any of the combining
fields was marked UTF8, the resulting string will be marked UTF8.

Note however if the backend module is Text::CSV_XS,
that all fields C<before> the first field that was marked UTF8
and contained 8-bit characters that were not upgraded to UTF8, these
will be bytes in the resulting string too, causing errors. If you pass
data of different encoding, or you don't know if there is different
encoding, force it to be upgraded before you pass them on:

    # backend = Text::CSV_XS
    $csv->print ($fh, [ map { utf8::upgrade (my $x = $_); $x } @data ]);

=head1 SPECIFICATION

See to L<Text::CSV_XS/SPECIFICATION>.

=head1 FUNCTIONS

These methods are common between XS and puer Perl version.
Most of the document was shamelessly copied and replaced from Text::CSV_XS.

=head2 version ()

(Class method) Returns the current backend module version.
If you want the module version, you can use the C<VERSION> method,

 print Text::CSV->VERSION;      # This module version
 print Text::CSV->version;      # The version of the worker module
                                # same as Text::CSV->backend->version

=head2 new (\%attr)

(Class method) Returns a new instance of Text::CSV_XS. The objects
attributes are described by the (optional) hash ref C<\%attr>.
Currently the following attributes are available:

=over 4

=item eol

An end-of-line string to add to rows. C<undef> is replaced with an
empty string. The default is C<$\>. Common values for C<eol> are
C<"\012"> (Line Feed) or C<"\015\012"> (Carriage Return, Line Feed).
Cannot be longer than 7 (ASCII) characters.

If both C<$/> and C<eol> equal C<"\015">, parsing lines that end on
only a Carriage Return without Line Feed, will be C<parse>d correct.
Line endings, whether in C<$/> or C<eol>, other than C<undef>,
C<"\n">, C<"\r\n">, or C<"\r"> are not (yet) supported for parsing.

=item sep_char

The char used for separating fields, by default a comma. (C<,>).
Limited to a single-byte character, usually in the range from 0x20
(space) to 0x7e (tilde).

The separation character can not be equal to the quote character.
The separation character can not be equal to the escape character.

See also L<Text::CSV_XS/CAVEATS>

=item allow_whitespace

When this option is set to true, whitespace (TAB's and SPACE's)
surrounding the separation character is removed when parsing. If
either TAB or SPACE is one of the three major characters C<sep_char>,
C<quote_char>, or C<escape_char> it will not be considered whitespace.

So lines like:

  1 , "foo" , bar , 3 , zapp

are now correctly parsed, even though it violates the CSV specs.

Note that B<all> whitespace is stripped from start and end of each
field. That would make it more a I<feature> than a way to be able
to parse bad CSV lines, as

 1,   2.0,  3,   ape  , monkey

will now be parsed as

 ("1", "2.0", "3", "ape", "monkey")

even if the original line was perfectly sane CSV.

=item blank_is_undef

Under normal circumstances, CSV data makes no distinction between
quoted- and unquoted empty fields. They both end up in an empty
string field once read, so

 1,"",," ",2

is read as

 ("1", "", "", " ", "2")

When I<writing> CSV files with C<always_quote> set, the unquoted empty
field is the result of an undefined value. To make it possible to also
make this distinction when reading CSV data, the C<blank_is_undef> option
will cause unquoted empty fields to be set to undef, causing the above to
be parsed as

 ("1", "", undef, " ", "2")

=item empty_is_undef

Going one step further than C<blank_is_undef>, this attribute converts
all empty fields to undef, so

 1,"",," ",2

is read as

 (1, undef, undef, " ", 2)

Note that this only effects fields that are I<really> empty, not fields
that are empty after stripping allowed whitespace. YMMV.

=item quote_char

The char used for quoting fields containing blanks, by default the
double quote character (C<">). A value of undef suppresses
quote chars. (For simple cases only).
Limited to a single-byte character, usually in the range from 0x20
(space) to 0x7e (tilde).

The quote character can not be equal to the separation character.

=item allow_loose_quotes

By default, parsing fields that have C<quote_char> characters inside
an unquoted field, like

 1,foo "bar" baz,42

would result in a parse error. Though it is still bad practice to
allow this format, we cannot help there are some vendors that make
their applications spit out lines styled like this.

In case there is B<really> bad CSV data, like

 1,"foo "bar" baz",42

or

 1,""foo bar baz"",42

there is a way to get that parsed, and leave the quotes inside the quoted
field as-is. This can be achieved by setting C<allow_loose_quotes> B<AND>
making sure that the C<escape_char> is I<not> equal to C<quote_char>.

=item escape_char

The character used for escaping certain characters inside quoted fields.
Limited to a single-byte character, usually in the range from 0x20
(space) to 0x7e (tilde).

The C<escape_char> defaults to being the literal double-quote mark (C<">)
in other words, the same as the default C<quote_char>. This means that
doubling the quote mark in a field escapes it:

  "foo","bar","Escape ""quote mark"" with two ""quote marks""","baz"

If you change the default quote_char without changing the default
escape_char, the escape_char will still be the quote mark.  If instead
you want to escape the quote_char by doubling it, you will need to change
the escape_char to be the same as what you changed the quote_char to.

The escape character can not be equal to the separation character.

=item allow_loose_escapes

By default, parsing fields that have C<escape_char> characters that
escape characters that do not need to be escaped, like:

 my $csv = Text::CSV->new ({ escape_char => "\\" });
 $csv->parse (qq{1,"my bar\'s",baz,42});

would result in a parse error. Though it is still bad practice to
allow this format, this option enables you to treat all escape character
sequences equal.

=item binary

If this attribute is TRUE, you may use binary characters in quoted fields,
including line feeds, carriage returns and NULL bytes. (The latter must
be escaped as C<"0>.) By default this feature is off.

If a string is marked UTF8, binary will be turned on automatically when
binary characters other than CR or NL are encountered. Note that a simple
string like C<"\x{00a0}"> might still be binary, but not marked UTF8, so
setting C<{ binary =E<gt> 1 }> is still a wise option.

=item types

A set of column types; this attribute is immediately passed to the
I<types> method below. You must not set this attribute otherwise,
except for using the I<types> method. For details see the description
of the I<types> method below.

=item always_quote

By default the generated fields are quoted only, if they need to, for
example, if they contain the separator. If you set this attribute to
a TRUE value, then all defined fields will be quoted. This is typically
easier to handle in external applications.

=item quote_space

By default, a space in a field would trigger quotation. As no rule
exists this to be forced in CSV, nor any for the opposite, the default
is true for safety. You can exclude the space from this trigger by
setting this option to 0.

=item quote_null

By default, a NULL byte in a field would be escaped. This attribute
enables you to treat the NULL byte as a simple binary character in
binary mode (the C<{ binary =E<gt> 1 }> is set). The default is true.
You can prevent NULL escapes by setting this attribute to 0.

=item quote_binary

By default,  all "unsafe" bytes inside a string cause the combined field to
be quoted. By setting this attribute to 0, you can disable that trigger for
bytes >= 0x7f.

=item keep_meta_info

By default, the parsing of input lines is as simple and fast as
possible. However, some parsing information - like quotation of
the original field - is lost in that process. Set this flag to
true to be able to retrieve that information after parsing with
the methods C<meta_info ()>, C<is_quoted ()>, and C<is_binary ()>
described below.  Default is false.

=item verbatim

This is a quite controversial attribute to set, but it makes hard
things possible.

The basic thought behind this is to tell the parser that the normally
special characters newline (NL) and Carriage Return (CR) will not be
special when this flag is set, and be dealt with as being ordinary
binary characters. This will ease working with data with embedded
newlines.

When C<verbatim> is used with C<getline ()>, C<getline ()>
auto-chomp's every line.

Imagine a file format like

  M^^Hans^Janssen^Klas 2\n2A^Ja^11-06-2007#\r\n

where, the line ending is a very specific "#\r\n", and the sep_char
is a ^ (caret). None of the fields is quoted, but embedded binary
data is likely to be present. With the specific line ending, that
shouldn not be too hard to detect.

By default, Text::CSV' parse function however is instructed to only
know about "\n" and "\r" to be legal line endings, and so has to deal
with the embedded newline as a real end-of-line, so it can scan the next
line if binary is true, and the newline is inside a quoted field.
With this attribute however, we can tell parse () to parse the line
as if \n is just nothing more than a binary character.

For parse () this means that the parser has no idea about line ending
anymore, and getline () chomps line endings on reading.

=item auto_diag

Set to true will cause C<error_diag ()> to be automatically be called
in void context upon errors.

If set to a value greater than 1, it will die on errors instead of
warn.

To check future plans and a difference in XS version,
please see to L<Text::CSV_XS/auto_diag>.

=back

To sum it up,

 $csv = Text::CSV->new ();

is equivalent to

 $csv = Text::CSV->new ({
     quote_char          => '"',
     escape_char         => '"',
     sep_char            => ',',
     eol                 => $\,
     always_quote        => 0,
     quote_space         => 1,
     quote_null          => 1,
     binary              => 0,
     keep_meta_info      => 0,
     allow_loose_quotes  => 0,
     allow_loose_escapes => 0,
     allow_whitespace    => 0,
     blank_is_undef      => 0,
     empty_is_undef      => 0,
     verbatim            => 0,
     auto_diag           => 0,
     });

For all of the above mentioned flags, there is an accessor method
available where you can inquire for the current value, or change
the value

 my $quote = $csv->quote_char;
 $csv->binary (1);

It is unwise to change these settings halfway through writing CSV
data to a stream. If however, you want to create a new stream using
the available CSV object, there is no harm in changing them.

If the C<new ()> constructor call fails, it returns C<undef>, and makes
the fail reason available through the C<error_diag ()> method.

 $csv = Text::CSV->new ({ ecs_char => 1 }) or
     die "" . Text::CSV->error_diag ();

C<error_diag ()> will return a string like

 "INI - Unknown attribute 'ecs_char'"

=head2 print

 $status = $csv->print ($io, $colref);

Similar to C<combine () + string () + print>, but more efficient. It
expects an array ref as input (not an array!) and the resulting string is
not really created (XS version), but immediately written to the I<$io> object, typically
an IO handle or any other object that offers a I<print> method. Note, this
implies that the following is wrong in perl 5.005_xx and older:

 open FILE, ">", "whatever";
 $status = $csv->print (\*FILE, $colref);

as in perl 5.005 and older, the glob C<\*FILE> is not an object, thus it
does not have a print method. The solution is to use an IO::File object or
to hide the glob behind an IO::Wrap object. See L<IO::File> and L<IO::Wrap>
for details.

For performance reasons the print method doesn't create a result string.
(If its backend is PP version, result strings are created internally.)
In particular the I<$csv-E<gt>string ()>, I<$csv-E<gt>status ()>,
I<$csv->fields ()> and I<$csv-E<gt>error_input ()> methods are meaningless
after executing this method.

=head2 combine

 $status = $csv->combine (@columns);

This object function constructs a CSV string from the arguments, returning
success or failure.  Failure can result from lack of arguments or an argument
containing an invalid character.  Upon success, C<string ()> can be called to
retrieve the resultant CSV string.  Upon failure, the value returned by
C<string ()> is undefined and C<error_input ()> can be called to retrieve an
invalid argument.

=head2 string

 $line = $csv->string ();

This object function returns the input to C<parse ()> or the resultant CSV
string of C<combine ()>, whichever was called more recently.

=head2 getline

 $colref = $csv->getline ($io);

This is the counterpart to print, like parse is the counterpart to
combine: It reads a row from the IO object $io using $io->getline ()
and parses this row into an array ref. This array ref is returned
by the function or undef for failure.

When fields are bound with C<bind_columns ()>, the return value is a
reference to an empty list.

The I<$csv-E<gt>string ()>, I<$csv-E<gt>fields ()> and I<$csv-E<gt>status ()>
methods are meaningless, again.

=head2 getline_all

 $arrayref = $csv->getline_all ($io);
 $arrayref = $csv->getline_all ($io, $offset);
 $arrayref = $csv->getline_all ($io, $offset, $length);

This will return a reference to a list of C<getline ($io)> results.
In this call, C<keep_meta_info> is disabled. If C<$offset> is negative,
as with C<splice ()>, only the last C<abs ($offset)> records of C<$io>
are taken into consideration.

Given a CSV file with 10 lines:

 lines call
 ----- ---------------------------------------------------------
 0..9  $csv->getline_all ($io)         # all
 0..9  $csv->getline_all ($io,  0)     # all
 8..9  $csv->getline_all ($io,  8)     # start at 8
 -     $csv->getline_all ($io,  0,  0) # start at 0 first 0 rows
 0..4  $csv->getline_all ($io,  0,  5) # start at 0 first 5 rows
 4..5  $csv->getline_all ($io,  4,  2) # start at 4 first 2 rows
 8..9  $csv->getline_all ($io, -2)     # last 2 rows
 6..7  $csv->getline_all ($io, -4,  2) # first 2 of last  4 rows

=head2 parse

 $status = $csv->parse ($line);

This object function decomposes a CSV string into fields, returning
success or failure.  Failure can result from a lack of argument or the
given CSV string is improperly formatted.  Upon success, C<fields ()> can
be called to retrieve the decomposed fields .  Upon failure, the value
returned by C<fields ()> is undefined and C<error_input ()> can be called
to retrieve the invalid argument.

You may use the I<types ()> method for setting column types. See the
description below.

=head2 getline_hr

The C<getline_hr ()> and C<column_names ()> methods work together to allow
you to have rows returned as hashrefs. You must call C<column_names ()>
first to declare your column names.

 $csv->column_names (qw( code name price description ));
 $hr = $csv->getline_hr ($io);
 print "Price for $hr->{name} is $hr->{price} EUR\n";

C<getline_hr ()> will croak if called before C<column_names ()>.

=head2 getline_hr_all

 $arrayref = $csv->getline_hr_all ($io);
 $arrayref = $csv->getline_hr_all ($io, $offset);
 $arrayref = $csv->getline_hr_all ($io, $offset, $length);

This will return a reference to a list of C<getline_hr ($io)> results.
In this call, C<keep_meta_info> is disabled.

=head2 column_names

Set the keys that will be used in the C<getline_hr ()> calls. If no keys
(column names) are passed, it'll return the current setting.

C<column_names ()> accepts a list of scalars (the column names) or a
single array_ref, so you can pass C<getline ()>

  $csv->column_names ($csv->getline ($io));

C<column_names ()> does B<no> checking on duplicates at all, which might
lead to unwanted results. Undefined entries will be replaced with the
string C<"\cAUNDEF\cA">, so

  $csv->column_names (undef, "", "name", "name");
  $hr = $csv->getline_hr ($io);

Will set C<$hr->{"\cAUNDEF\cA"}> to the 1st field, C<$hr->{""}> to the
2nd field, and C<$hr->{name}> to the 4th field, discarding the 3rd field.

C<column_names ()> croaks on invalid arguments.

=head2 bind_columns

Takes a list of references to scalars to store the fields fetched
C<getline ()> in. When you don't pass enough references to store the
fetched fields in, C<getline ()> will fail. If you pass more than there are
fields to return, the remaining references are left untouched.

  $csv->bind_columns (\$code, \$name, \$price, \$description);
  while ($csv->getline ($io)) {
      print "The price of a $name is \x{20ac} $price\n";
      }

=head2 eof

 $eof = $csv->eof ();

If C<parse ()> or C<getline ()> was used with an IO stream, this
method will return true (1) if the last call hit end of file, otherwise
it will return false (''). This is useful to see the difference between
a failure and end of file.

=head2 types

 $csv->types (\@tref);

This method is used to force that columns are of a given type. For
example, if you have an integer column, two double columns and a
string column, then you might do a

 $csv->types ([Text::CSV::IV (),
               Text::CSV::NV (),
               Text::CSV::NV (),
               Text::CSV::PV ()]);

Column types are used only for decoding columns, in other words
by the I<parse ()> and I<getline ()> methods.

You can unset column types by doing a

 $csv->types (undef);

or fetch the current type settings with

 $types = $csv->types ();

=over 4

=item IV

Set field type to integer.

=item NV

Set field type to numeric/float.

=item PV

Set field type to string.

=back

=head2 fields

 @columns = $csv->fields ();

This object function returns the input to C<combine ()> or the resultant
decomposed fields of C successful <parse ()>, whichever was called more
recently.

Note that the return value is undefined after using C<getline ()>, which
does not fill the data structures returned by C<parse ()>.

=head2 meta_info

 @flags = $csv->meta_info ();

This object function returns the flags of the input to C<combine ()> or
the flags of the resultant decomposed fields of C<parse ()>, whichever
was called more recently.

For each field, a meta_info field will hold flags that tell something about
the field returned by the C<fields ()> method or passed to the C<combine ()>
method. The flags are bit-wise-or'd like:

=over 4

=item 0x0001

The field was quoted.

=item 0x0002

The field was binary.

=back

See the C<is_*** ()> methods below.

=head2 is_quoted

  my $quoted = $csv->is_quoted ($column_idx);

Where C<$column_idx> is the (zero-based) index of the column in the
last result of C<parse ()>.

This returns a true value if the data in the indicated column was
enclosed in C<quote_char> quotes. This might be important for data
where C<,20070108,> is to be treated as a numeric value, and where
C<,"20070108",> is explicitly marked as character string data.

=head2 is_binary

  my $binary = $csv->is_binary ($column_idx);

Where C<$column_idx> is the (zero-based) index of the column in the
last result of C<parse ()>.

This returns a true value if the data in the indicated column
contained any byte in the range [\x00-\x08,\x10-\x1F,\x7F-\xFF]

=head2 is_missing

  my $missing = $csv->is_missing ($column_idx);

Where C<$column_idx> is the (zero-based) index of the column in the last
result of L</getline_hr>.

 while (my $hr = $csv->getline_hr ($fh)) {
     $csv->is_missing (0) and next; # This was an empty line
 }

When using L</getline_hr> for parsing, it is impossible to tell if the
fields are C<undef> because they where not filled in the CSV stream or
because they were not read at all, as B<all> the fields defined by
L</column_names> are set in the hash-ref. If you still need to know if all
fields in each row are provided, you should enable C<keep_meta_info> so you
can check the flags.

=head2 status

 $status = $csv->status ();

This object function returns success (or failure) of C<combine ()> or
C<parse ()>, whichever was called more recently.

=head2 error_input

 $bad_argument = $csv->error_input ();

This object function returns the erroneous argument (if it exists) of
C<combine ()> or C<parse ()>, whichever was called more recently.

=head2 error_diag

 Text::CSV->error_diag ();
 $csv->error_diag ();
 $error_code   = 0  + $csv->error_diag ();
 $error_str    = "" . $csv->error_diag ();
 ($cde, $str, $pos) = $csv->error_diag ();

If (and only if) an error occured, this function returns the diagnostics
of that error.

If called in void context, it will print the internal error code and the
associated error message to STDERR.

If called in list context, it will return the error code and the error
message in that order. If the last error was from parsing, the third
value returned is the best guess at the location within the line that was
being parsed. It's value is 1-based.

Note: C<$pos> returned by the backend Text::CSV_PP does not show
the error point in many cases (see to the below line).
It is for conscience's sake in using Text::CSV_PP.

If called in scalar context, it will return the diagnostics in a single
scalar, a-la $!. It will contain the error code in numeric context, and
the diagnostics message in string context.

Depending on the used worker module, returned diagnostics is diffferent.

Text::CSV_XS parses csv strings by dividing one character while Text::CSV_PP
by using the regular expressions. That difference makes the different cause
of the failure.

When called as a class method or a direct function call, the error diag
is that of the last C<new ()> call.

=head2 record_number

  $recno = $csv->record_number ();

Returns the records parsed by this csv instance. This value should be more
accurate than C<$.> when embedded newlines come in play. Records written by
this instance are not counted.

=head2 SetDiag

 $csv->SetDiag (0);

Use to reset the diagnostics if you are dealing with errors.

=head2 Some methods are Text::CSV only.

=over

=item backend

Returns the backend module name called by Text::CSV.
C<module> is an alias.


=item is_xs

Returns true value if Text::CSV or the object uses XS module as worker.

=item is_pp

Returns true value if Text::CSV or the object uses pure-Perl module as worker.


=back


=head1 DIAGNOSTICS

If an error occured, $csv->error_diag () can be used to get more information
on the cause of the failure. Note that for speed reasons, the internal value
is never cleared on success, so using the value returned by error_diag () in
normal cases - when no error occured - may cause unexpected results.

This function changes depending on the used module (XS or PurePerl).

See to L<Text::CSV_XS/DIAGNOSTICS> and L<Text::CSV_PP/DIAGNOSTICS>.



=head2 HISTORY AND WORKER MODULES

This module, L<Text::CSV> was firstly written by Alan Citterman which could deal with
B<only ascii characters>. Then, Jochen Wiedmann wrote L<Text::CSV_XS> which has
the B<binary mode>. This XS version is maintained by H.Merijn Brand and L<Text::CSV_PP>
written by Makamaka was pure-Perl version of Text::CSV_XS.

Now, Text::CSV was rewritten by Makamaka and become a wrapper to Text::CSV_XS or Text::CSV_PP.
Text::CSV_PP will be bundled in this distribution.

When you use Text::CSV, it calls a backend worker module - L<Text::CSV_XS> or L<Text::CSV_PP>.
By default, Text::CSV tries to use Text::CSV_XS which must be complied and installed properly.
If this call is fail, Text::CSV uses L<Text::CSV_PP>.

The required Text::CSV_XS version is I<0.41> in Text::CSV version 1.03.

If you set an enviornment variable C<PERL_TEXT_CSV>, The calling action will be changed.

=over

=item PERL_TEXT_CSV = 0

=item PERL_TEXT_CSV = 'Text::CSV_PP'

Always use Text::CSV_PP

=item PERL_TEXT_CSV = 1

=item PERL_TEXT_CSV = 'Text::CSV_XS,Text::CSV_PP'

(The default) Use compiled Text::CSV_XS if it is properly compiled & installed,
otherwise use Text::CSV_PP

=item PERL_TEXT_CSV = 2

=item PERL_TEXT_CSV = 'Text::CSV_XS'

Always use compiled Text::CSV_XS, die if it isn't properly compiled & installed.

=back

These ideas come from L<DBI::PurePerl> mechanism.

example:

  BEGIN { $ENV{PERL_TEXT_CSV} = 0 }
  use Text::CSV; # always uses Text::CSV_PP


In future, it may be able to specify another module.

=head1 TODO

=over

=item Wrapper mechanism

Currently the wrapper mechanism is to change symbolic table for speed.

 for my $method (@PublicMethods) {
     *{"Text::CSV::$method"} = \&{"$class\::$method"};
 }

But how about it - calling worker module object?

 sub parse {
     my $self = shift;
     $self->{_WORKER_OBJECT}->parse(@_); # XS or PP CSV object
 }


=back

See to L<Text::CSV_XS/TODO> and L<Text::CSV_PP/TODO>.


=head1 SEE ALSO

L<Text::CSV_PP>, L<Text::CSV_XS> and L<Text::CSV::Encoded>.


=head1 AUTHORS and MAINTAINERS

Alan Citterman F<E<lt>alan[at]mfgrtl.comE<gt>> wrote the original Perl
module. Please don't send mail concerning Text::CSV to Alan, as
he's not a present maintainer.

Jochen Wiedmann F<E<lt>joe[at]ispsoft.deE<gt>> rewrote the encoding and
decoding in C by implementing a simple finite-state machine and added
the variable quote, escape and separator characters, the binary mode
and the print and getline methods. See ChangeLog releases 0.10 through
0.23.

H.Merijn Brand F<E<lt>h.m.brand[at]xs4all.nlE<gt>> cleaned up the code,
added the field flags methods, wrote the major part of the test suite,
completed the documentation, fixed some RT bugs. See ChangeLog releases
0.25 and on.

Makamaka Hannyaharamitu, E<lt>makamaka[at]cpan.orgE<gt> wrote Text::CSV_PP
which is the pure-Perl version of Text::CSV_XS.

New Text::CSV (since 0.99) is maintained by Makamaka.


=head1 COPYRIGHT AND LICENSE

Text::CSV

Copyright (C) 1997 Alan Citterman. All rights reserved.
Copyright (C) 2007-2009 Makamaka Hannyaharamitu.


Text::CSV_PP:

Copyright (C) 2005-2013 Makamaka Hannyaharamitu.


Text:CSV_XS:

Copyright (C) 2007-2013 H.Merijn Brand for PROCURA B.V.
Copyright (C) 1998-2001 Jochen Wiedmann. All rights reserved.
Portions Copyright (C) 1997 Alan Citterman. All rights reserved.


This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
