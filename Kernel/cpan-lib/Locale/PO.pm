package Locale::PO;
use strict;
use warnings;
our $VERSION = '0.24';

use Carp;

sub new {
    my $this    = shift;
    my %options = @_;
    my $class   = ref($this) || $this;
    my $self    = {};
    bless $self, $class;
    $self->_flags([]);
    $self->fuzzy_msgid($options{'-fuzzy_msgid'}) if defined($options{'-fuzzy_msgid'});
    $self->fuzzy_msgid_plural($options{'-fuzzy_msgid_plural'})
        if defined($options{'-fuzzy_msgid_plural'});
    $self->msgid($options{'-msgid'}) if defined($options{'-msgid'});
    $self->msgid_plural($options{'-msgid_plural'})
        if defined($options{'-msgid_plural'});
    $self->msgstr($options{'-msgstr'}) if defined($options{'-msgstr'});
    $self->msgstr_n($options{'-msgstr_n'})
        if defined($options{'-msgstr_n'});
    $self->msgctxt($options{'-msgctxt'}) if defined($options{'-msgctxt'});
    $self->fuzzy_msgctxt($options{'-fuzzy_msgctxt'})
        if defined($options{'-fuzzy_msgctxt'});
    $self->comment($options{'-comment'}) if defined($options{'-comment'});
    $self->fuzzy($options{'-fuzzy'})     if defined($options{'-fuzzy'});
    $self->automatic($options{'-automatic'})
        if defined($options{'-automatic'});
    $self->reference($options{'-reference'})
        if defined($options{'-reference'});
    $self->c_format(1) if defined($options{'-c-format'});
    $self->c_format(1) if defined($options{'-c_format'});
    $self->c_format(0) if defined($options{'-no-c-format'});
    $self->c_format(0) if defined($options{'-no_c_format'});
    $self->loaded_line_number($options{'-loaded_line_number'})
        if defined($options{'-loaded_line_number'});
    return $self;
}

sub fuzzy_msgctxt {
    my $self = shift;
    @_ ? $self->{'fuzzy_msgctxt'} = $self->quote(shift) : $self->{'fuzzy_msgctxt'};
}

sub fuzzy_msgid {
    my $self = shift;
    @_ ? $self->{'fuzzy_msgid'} = $self->quote(shift) : $self->{'fuzzy_msgid'};
}

sub fuzzy_msgid_plural {
    my $self = shift;
    @_
        ? $self->{'fuzzy_msgid_plural'} = $self->quote(shift)
        : $self->{'fuzzy_msgid_plural'};
}

sub msgctxt {
    my $self = shift;
    @_ ? $self->{'msgctxt'} = $self->quote(shift) : $self->{'msgctxt'};
}

sub msgid {
    my $self = shift;
    @_ ? $self->{'msgid'} = $self->quote(shift) : $self->{'msgid'};
}

sub msgid_plural {
    my $self = shift;
    @_
        ? $self->{'msgid_plural'} = $self->quote(shift)
        : $self->{'msgid_plural'};
}

sub msgstr {
    my $self = shift;
    @_ ? $self->{'msgstr'} = $self->quote(shift) : $self->{'msgstr'};
}

sub msgstr_n {
    my $self = shift;
    if (@_) {
        my $hashref = shift;

        # check that we have a hashref.
        croak 'Argument to msgstr_n must be a hashref: { n => "string n", ... }.'
            unless ref($hashref) eq 'HASH';

        # Check that the keys are all numbers.
        croak 'Keys to msgstr_n hashref must be numbers'
            if grep {m/\D/} keys %$hashref;

        # Quote all the values in the hashref.
        $self->{'msgstr_n'}{$_} = $self->quote($$hashref{$_}) for keys %$hashref;

    }

    return $self->{'msgstr_n'};
}

sub comment {
    my $self = shift;
    @_ ? $self->{'comment'} = shift : $self->{'comment'};
}

sub automatic {
    my $self = shift;
    @_ ? $self->{'automatic'} = shift : $self->{'automatic'};
}

sub reference {
    my $self = shift;
    @_ ? $self->{'reference'} = shift : $self->{'reference'};
}

sub obsolete {
    my $self = shift;
    @_ ? $self->{'obsolete'} = shift : $self->{'obsolete'};
}

sub fuzzy {
    my $self = shift;

    if (@_) {
        my $value = shift;
        $value ? $self->add_flag('fuzzy') : $self->remove_flag('fuzzy');
    }

    return $self->has_flag('fuzzy');
}

sub c_format {
    my $self = shift;

    return $self->_tri_value_flag('c-format', @_);
}

sub php_format {
    my $self = shift;

    return $self->_tri_value_flag('php-format', @_);
}

sub _flags {
    my $self = shift;
    @_ ? $self->{'_flags'} = shift : $self->{'_flags'};
}

sub _tri_value_flag {
    my $self      = shift;
    my $flag_name = shift;
    if (@_) {    # set or clear the flags
        my $value = shift;
        if (!defined($value) || $value eq "") {
            $self->remove_flag("$flag_name");
            $self->remove_flag("no-$flag_name");
            return undef;
        }
        elsif ($value) {
            $self->add_flag("$flag_name");
            $self->remove_flag("no-$flag_name");
            return 1;
        }
        else {
            $self->add_flag("no-$flag_name");
            $self->remove_flag("$flag_name");
            return 0;
        }
    }
    else {    # check the flags
        return 1 if $self->has_flag("$flag_name");
        return 0 if $self->has_flag("no-$flag_name");
        return undef;
    }
}

sub add_flag {
    my ($self, $flag_name) = @_;
    push @{$self->_flags}, $flag_name;
    return;
}

sub remove_flag {
    my ($self, $flag_name) = @_;
    my @new_flags;
    foreach my $flag (@{$self->_flags}) {
        push @new_flags, $flag unless $flag eq $flag_name;
    }
    $self->_flags(\@new_flags);
    return;
}

sub has_flag {
    my ($self, $flag_name) = @_;
    foreach my $flag (@{$self->_flags}) {
        return 1 if $flag eq $flag_name;
    }
    return;
}

sub loaded_line_number {
    my $self = shift;
    @_ ? $self->{'loaded_line_number'} = shift : $self->{'loaded_line_number'};
}

sub _normalize_str {
    my $self     = shift;
    my $string   = shift;
    my $dequoted = $self->dequote($string);

    # This isn't quite perfect, but it's fast and easy
    if ($dequoted =~ /\n/) {

        # Multiline
        my $output;
        my @lines;
        @lines = split(/\n/, $dequoted, -1);
        my $lastline = pop @lines;    # special treatment for this one
        $output = qq{""\n} if ($#lines != 0);
        foreach (@lines) {
            $output .= $self->quote("$_\n") . "\n";
        }
        $output .= $self->quote($lastline) . "\n" if $lastline ne "";
        return $output;
    }
    else {

        # Single line
        return "$string\n";
    }
}

sub _fuzzy_normalize_str {
    my $self   = shift;
    my $string = shift;
    my $prefix = shift;

    my $normalized = $self->_normalize_str($string);

    # on newlines, start them with "#| " or "#~| "
    $normalized =~ s/\n"/\n$prefix"/g;

    return $normalized;
}

sub dump {
    my $self         = shift;
    my $obsolete     = $self->obsolete ? '#~ ' : '';
    my $fuzzy_prefix = $self->obsolete ? '#~| ' : '#| ';
    my $dump;

    $dump = $self->_dump_multi_comment($self->comment, "# ")
        if ($self->comment);
    $dump .= $self->_dump_multi_comment($self->automatic, "#. ")
        if ($self->automatic);
    $dump .= $self->_dump_multi_comment($self->reference, "#: ")
        if ($self->reference);

    my $flags = '';

    foreach my $flag (@{$self->_flags}) {
        $flags .= ", $flag";
    }

    $dump .= "#$flags\n"
        if length $flags;

    $dump
        .= "${fuzzy_prefix}msgctxt "
        . $self->_fuzzy_normalize_str($self->fuzzy_msgctxt, $fuzzy_prefix)
        if $self->fuzzy_msgctxt;
    $dump
        .= "${fuzzy_prefix}msgid "
        . $self->_fuzzy_normalize_str($self->fuzzy_msgid, $fuzzy_prefix)
        if $self->fuzzy_msgid;
    $dump
        .= "${fuzzy_prefix}msgid_plural "
        . $self->_fuzzy_normalize_str($self->fuzzy_msgid_plural, $fuzzy_prefix)
        if $self->fuzzy_msgid_plural;

    $dump .= "${obsolete}msgctxt " . $self->_normalize_str($self->msgctxt)
        if $self->msgctxt;
    $dump .= "${obsolete}msgid " . $self->_normalize_str($self->msgid);
    $dump .= "${obsolete}msgid_plural " . $self->_normalize_str($self->msgid_plural)
        if $self->msgid_plural;

    $dump .= "${obsolete}msgstr " . $self->_normalize_str($self->msgstr) if $self->msgstr;

    if (my $msgstr_n = $self->msgstr_n) {
        $dump .= "${obsolete}msgstr[$_] " . $self->_normalize_str($$msgstr_n{$_})
            for sort { $a <=> $b } keys %$msgstr_n;
    }

    $dump .= "\n";
    return $dump;
}

sub _dump_multi_comment {
    my $self    = shift;
    my $comment = shift;
    my $leader  = shift;
    my $chopped = $leader;
    chop($chopped);
    my $result = $leader . $comment;
    $result =~ s/\n/\n$leader/g;
    $result =~ s/^$leader$/$chopped/gm;
    $result .= "\n";
    return $result;
}

# Quote a string properly
sub quote {
    my $self   = shift;
    my $string = shift;

    return undef
        unless defined $string;

    $string =~ s/"/\\"/g;
    $string =~ s/(?<!(\\))\\n/\\\\n/g;
    $string =~ s/\n/\\n/g;
    return "\"$string\"";
}

sub dequote {
    my $self   = shift;
    my $string = shift;

    return undef
        unless defined $string;

    $string =~ s/^"(.*)"/$1/;
    $string =~ s/\\"/"/g;
    $string =~ s/(?<!(\\))\\n/\n/g;
    $string =~ s/\\\\n/\\n/g;

    return $string;
}

sub save_file_fromarray {
    my $self = shift;
    $self->_save_file(0, @_);
}

sub save_file_fromhash {
    my $self = shift;
    $self->_save_file(1, @_);
}

sub _save_file {
    my $self     = shift;
    my $ashash   = shift;
    my $file     = shift;
    my $entries  = shift;
    my $encoding = shift;

    open(OUT, defined($encoding) ? ">:encoding($encoding)" : ">", $file) or return undef;
    if ($ashash) {
        foreach (sort keys %$entries) {
            print OUT $entries->{$_}->dump;
        }
    }
    else {
        foreach (@$entries) {
            print OUT $_->dump;
        }
    }

    close OUT;
}

sub load_file_asarray {
    my $self = shift;
    $self->_load_file(0, @_);
}

sub load_file_ashash {
    my $self = shift;
    $self->_load_file(1, @_);
}

sub _load_file {
    my $self     = shift;
    my $ashash   = shift;
    my $file     = shift;
    my $encoding = shift;
    my $class    = ref $self || $self;
    my (@entries, %entries);
    my $line_number = 0;
    my $po;
    my %buffer;
    my $last_buffer;

    open(IN, defined($encoding) ? "<:encoding($encoding)" : "<", $file)
        or return undef;

    while (<IN>) {
        chop;
        $line_number++;
        if (/^$/) {

            # Empty line. End of an entry.

            if (defined($po)) {
                $po->fuzzy_msgctxt($buffer{fuzzy_msgctxt})
                    if defined $buffer{fuzzy_msgctxt};
                $po->fuzzy_msgid($buffer{fuzzy_msgid}) if defined $buffer{fuzzy_msgid};
                $po->fuzzy_msgid_plural($buffer{fuzzy_msgid_plural})
                    if defined $buffer{fuzzy_msgid_plural};
                $po->msgctxt($buffer{msgctxt})           if defined $buffer{msgctxt};
                $po->msgid($buffer{msgid})               if defined $buffer{msgid};
                $po->msgid_plural($buffer{msgid_plural}) if defined $buffer{msgid_plural};
                $po->msgstr($buffer{msgstr})             if defined $buffer{msgstr};
                $po->msgstr_n($buffer{msgstr_n})         if defined $buffer{msgstr_n};


                # ashash
                if ($ashash) {
                    $entries{$po->msgid} = $po
                        if ($po->_hash_key_ok(\%entries));
                }

                # asarray
                else {
                    push(@entries, $po);
                }

                undef $po;
                undef $last_buffer;
                %buffer = ();
            }
        }
        elsif (/^#\s+(.*)/ or /^#()$/) {

            # Translator comments
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            if (defined($po->comment)) {
                $po->comment($po->comment . "\n$1");
            }
            else {
                $po->comment($1);
            }
        }
        elsif (/^#\.\s*(.*)/) {

            # Automatic comments
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            if (defined($po->automatic)) {
                $po->automatic($po->automatic . "\n$1");
            }
            else {
                $po->automatic($1);
            }
        }
        elsif (/^#:\s+(.*)/) {

            # reference
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            if (defined($po->reference)) {
                $po->reference($po->reference . "\n$1");
            }
            else {
                $po->reference($1);
            }
        }
        elsif (/^#,\s+(.*)/) {

            # flags
            my @flags = split /\s*[,]\s*/, $1;
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            foreach my $flag (@flags) {
                $po->add_flag($flag);
            }
        }
        elsif (/^#(~)?\|\s+msgctxt\s+(.*)/) {
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            $buffer{fuzzy_msgctxt} = $self->dequote($2);
            $last_buffer = \$buffer{fuzzy_msgctxt};
            $po->obsolete(1) if $1;
        }
        elsif (/^#(~)?\|\s+msgid\s+(.*)/) {
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            $buffer{fuzzy_msgid} = $self->dequote($2);
            $last_buffer = \$buffer{fuzzy_msgid};
            $po->obsolete(1) if $1;
        }
        elsif (/^#(~)?\|\s+msgid_plural\s+(.*)/) {
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            $buffer{fuzzy_msgid_plural} = $self->dequote($2);
            $last_buffer = \$buffer{fuzzy_msgid_plural};
            $po->obsolete(1) if $1;
        }
        elsif (/^(#~\s+)?msgctxt\s+(.*)/) {
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            $buffer{msgctxt} = $self->dequote($2);
            $last_buffer = \$buffer{msgctxt};
            $po->obsolete(1) if $1;
        }
        elsif (/^(#~\s+)?msgid\s+(.*)/) {
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            $buffer{msgid} = $self->dequote($2);
            $last_buffer = \$buffer{msgid};
            $po->obsolete(1) if $1;
        }
        elsif (/^(#~\s+)?msgid_plural\s+(.*)/) {
            $po = $class->new(-loaded_line_number => $line_number) unless defined($po);
            $buffer{msgid_plural} = $self->dequote($2);
            $last_buffer = \$buffer{msgid_plural};
            $po->obsolete(1) if $1;
        }
        elsif (/^(?:#~\s+)?msgstr\s+(.*)/) {

            # translated string
            $buffer{msgstr} = $self->dequote($1);
            $last_buffer = \$buffer{msgstr};
        }
        elsif (/^(?:#~\s+)?msgstr\[(\d+)\]\s+(.*)/) {

            # translated string
            $buffer{msgstr_n}{$1} = $self->dequote($2);
            $last_buffer = \$buffer{msgstr_n}{$1};
        }
        elsif (/^(?:#(?:~|~\||\|)\s+)?(".*)/) {

            # continued string. Accounts for:
            #   normal          : "string"
            #   obsolete        : #~ "string"
            #   fuzzy           : #| "string"
            #   fuzzy+obsolete  : #~| "string"
            $$last_buffer .= $self->dequote($1);
        }
        else {
            warn "Strange line at $file line $line_number: $_\n";
        }
    }
    if (defined($po)) {

        $po->msgctxt($buffer{msgctxt})
            if defined $buffer{msgctxt};
        $po->msgid($buffer{msgid})
            if defined $buffer{msgid};
        $po->msgid_plural($buffer{msgid_plural})
            if defined $buffer{msgid_plural};
        $po->msgstr($buffer{msgstr})
            if defined $buffer{msgstr};
        $po->msgstr_n($buffer{msgstr_n})
            if defined $buffer{msgstr_n};

        # ashash
        if ($ashash) {
            if ($po->_hash_key_ok(\%entries)) {
                $entries{$po->msgid} = $po;
            }
        }

        # asarray
        else {
            push(@entries, $po);
        }
    }
    close IN;
    return ($ashash ? \%entries : \@entries);
}

sub _hash_key_ok {
    my ($self, $entries) = @_;

    my $key = $self->msgid;

    if ($entries->{$key}) {

        # don't overwrite non-obsolete entries with obsolete ones
        return if (($self->obsolete) && (not $entries->{$key}->obsolete));

        # don't overwrite translated entries with untranslated ones
        return if (($self->msgstr !~ /\w/) && ($entries->{$key}->msgstr =~ /\w/));
    }

    return 1;
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Locale::PO - Perl module for manipulating .po entries from GNU gettext

=head1 SYNOPSIS

    use Locale::PO;

    $po = new Locale::PO([-option=>value,...])
    [$string =] $po->msgid([new string]);
    [$string =] $po->msgstr([new string]);
    [$string =] $po->comment([new string]);
    [$string =] $po->automatic([new string]);
    [$string =] $po->reference([new string]);
    [$value =] $po->fuzzy([value]);
    [$value =] $po->add_flag('c-format');
    print $po->dump;

    $quoted_string = $po->quote($string);
    $string = $po->dequote($quoted_string);

    $aref = Locale::PO->load_file_asarray(<filename>,[encoding]);
    $href = Locale::PO->load_file_ashash(<filename>,[encoding]);
    Locale::PO->save_file_fromarray(<filename>,$aref,[encoding]);
    Locale::PO->save_file_fromhash(<filename>,$href,[encoding]);

=head1 DESCRIPTION

This module simplifies management of GNU gettext .po files and is an
alternative to using emacs po-mode. It provides an object-oriented
interface in which each entry in a .po file is a Locale::PO object.

=head1 METHODS

=over 4

=item new

    my Locale::PO $po = new Locale::PO;
    my Locale::PO $po = new Locale::PO(%options);

Create a new Locale::PO object to represent a po entry.
You can optionally set the attributes of the entry by passing
a list/hash of the form:

    -option=>value, -option=>value, etc.

Where options are msgid, msgid_plural, msgstr, msgctxt, comment, automatic,
reference, fuzzy_msgctxt, fuzzy_msgid, fuzzy_msgid_plural,
fuzzy, and c-format. See accessor methods below.

To generate a po file header, add an entry with an empty
msgid, like this:

    $po = new Locale::PO(-msgid=>'', -msgstr=>
	    "Project-Id-Version: PACKAGE VERSION\\n" .
	    "PO-Revision-Date: YEAR-MO-DA HO:MI +ZONE\\n" .
	    "Last-Translator: FULL NAME <EMAIL@ADDRESS>\\n" .
	    "Language-Team: LANGUAGE <LL@li.org>\\n" .
	    "MIME-Version: 1.0\\n" .
	    "Content-Type: text/plain; charset=CHARSET\\n" .
	    "Content-Transfer-Encoding: ENCODING\\n");

=item msgid

Set or get the untranslated string from the object.

This method expects the new string in unquoted form but returns the current string in quoted form.

=item msgid_plural

Set or get the untranslated plural string from the object.

This method expects the new string in unquoted form but returns the current string in quoted form.

=item msgstr

Set or get the translated string from the object.

This method expects the new string in unquoted form but returns the current string in quoted form.

=item msgstr_n

Get or set the translations if there are purals involved. Takes and
returns a hashref where the keys are the 'N' case and the values are
the strings. eg:

    $po->msgstr_n(
	{
	    0 => 'found %d plural translations',
	    1 => 'found %d singular translation',
	}
    );

This method expects the new strings in unquoted form but returns the current strings in quoted form.

=item msgctxt

Set or get the translation context string from the object.

This method expects the new string in unquoted form but returns the current string in quoted form.

=item fuzzy_msgid

Set or get the outdated untranslated string from the object.

This method expects the new string in unquoted form but returns the current string in quoted form.

=item fuzzy_msgid_plural

Set or get the outdated untranslated plural string from the object.

This method expects the new string in unquoted form but returns the current string in quoted form.

=item fuzzy_msgctxt

Set or get the outdated translation context string from the object.

This method expects the new string in unquoted form but returns the current string in quoted form.

=item obsolete

Returns 1 if the entry is obsolete.
Obsolete entries have their msgid, msgid_plural, msgstr, msgstr_n and msgctxt lines commented out with "#~"

When using load_file_ashash, non-obsolete entries will always replace obsolete entries with the same msgid.

=item comment

Set or get translator comments from the object.

If there are no such comments, then the value is undef.  Otherwise,
the value is a string that contains the comment lines delimited with
"\n".  The string includes neither the S<"# "> at the beginning of
each comment line nor the newline at the end of the last comment line.

=item automatic

Set or get automatic comments from the object (inserted by
emacs po-mode or xgettext).

If there are no such comments, then the value is undef.  Otherwise,
the value is a string that contains the comment lines delimited with
"\n".  The string includes neither the S<"#. "> at the beginning of
each comment line nor the newline at the end of the last comment line.

=item reference

Set or get reference marking comments from the object (inserted
by emacs po-mode or gettext).

=item fuzzy

Set or get the fuzzy flag on the object ("check this translation").
When setting, use 1 to turn on fuzzy, and 0 to turn it off.

=item c_format

Set or get the c-format or no-c-format flag on the object.

This can take 3 values:
1 implies c-format, 0 implies no-c-format, and undefined implies neither.

=item php_format

Set or get the php-format or no-php-format flag on the object.

This can take 3 values:
1 implies php-format, 0 implies no-php-format, and undefined implies neither.

=item has_flag

    if ($po->has_flag('perl-format')) {
	    ...
    }

Returns true if the flag exists in the entry's #~ comment

=item add_flag

    $po->add_flag('perl-format');

Adds the flag to the #~ comment

=item remove_flag

    $po->remove_flag('perl-format');

Removes the flag from the #~ comment

=item loaded_line_number

When using one of the load_file_as* methods,
this will return the line number that the entry started at in the file.

=item dump

Returns the entry as a string, suitable for output to a po file.

=item quote

Applies po quotation rules to a string, and returns the quoted
string. The quoted string will have all existing double-quote
characters escaped by backslashes, and will be enclosed in double
quotes.

=item dequote

Returns a quoted po string to its natural form.

=item load_file_asarray

Given the filename of a po-file, reads the file and returns a
reference to a list of Locale::PO objects corresponding to the contents of
the file, in the same order.  Accepts an optional encoding parameter (e.g.
"utf8") which defines how the po-file's input stream will be configured.

=item load_file_ashash

Given the filename of a po-file, reads the file and returns a
reference to a hash of Locale::PO objects corresponding to the contents of
the file. The hash keys are the untranslated strings, so this is a cheap
way to remove duplicates. The method will prefer to keep entries that
have been translated.  Accepts an optional encoding parameter (e.g.
"utf8") which defines how the po-file's input stream will be configured.

=item save_file_fromarray

Given a filename and a reference to a list of Locale::PO objects,
saves those objects to the file, creating a po-file.  Accepts an optional
encoding parameter (e.g. "utf8") which defines how the po-file's output
stream will be configured.

=item save_file_fromhash

Given a filename and a reference to a hash of Locale::PO objects,
saves those objects to the file, creating a po-file. The entries
are sorted alphabetically by untranslated string.  Accepts an optional
encoding parameter (e.g. "utf8") which defines how the po-file's output
stream will be configured.

=back

=head1 AUTHOR

Maintainer: Ken Prows, perl@xev.net

Original version by: Alan Schwartz, alansz@pennmush.org

=head1 BUGS

If you load_file_as* then save_file_from*, the output file may have slight
cosmetic differences from the input file (an extra blank line here or there).

msgid, msgid_plural, msgstr, msgstr_n and msgctxt expect a non-quoted string as input, but return quoted strings.
I'm hesitant to change this in fear of breaking the modules/scripts of people already using Locale::PO.

Locale::PO requires blank lines between entries, but Uniforum style PO
files don't have any.

Please submit all bug requests using CPAN's ticketing system.

=head1 SEE ALSO

xgettext(1).

=cut
