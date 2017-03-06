package Text::vFile::asData;
use strict;
use warnings;
no warnings 'uninitialized';
use base qw( Class::Accessor::Chained::Fast );
__PACKAGE__->mk_accessors(qw( preserve_params ));
our $VERSION = '0.08';

=head1 NAME

Text::vFile::asData - parse vFile formatted files into data structures

=head1 SYNOPSIS

  use Text::vFile::asData;
  open my $fh, "foo.ics"
    or die "couldn't open ics: $!";
  my $data = Text::vFile::asData->new->parse( $fh );

=head1 DESCRIPTION

Text::vFile::asData reads vFile format files, such as vCard (RFC 2426) and
vCalendar (RFC 2445).

=cut

sub _unwrap_lines {
    my $self = shift;
    my @lines;
    for (@_) {
        my $line = $_; # $_ may be readonly
        $line =~ s{[\r\n]+$}{}; # lines SHOULD end CRLF
        if ($line =~ /^[ \t](.*)/) { # Continuation line (RFC Sect. 4.1)
            die "Continuation line, but no preceding line" unless @lines;
            $lines[-1] .= $1;
            next;
        }
        push @lines, $line;
    }
    return @lines;
}

sub parse {
    my $self = shift;
    my $fh = shift;
    return $self->parse_lines( <$fh> );
}

# like Text::ParseWords' parse_line, only C-style so the regex engine doesn't
# blow its stack, and it's also got a $limit like split

# this only took a trainride, so I'm pretty sure there are lurking
# corner cases - when I get a tuit I'll take the Text::ParseWords
# tests and run them through it

sub parse_line {
    my ($delim, $keep, $text, $limit) = @_;

    my ($current, @parts);
    my ($quote, $escaped);
    while (length $text) {
        if ($text =~ s{^(\\)}{}) {
            $current .= $1 if $escaped || $keep;
            $escaped = !$escaped;
            next;
        }
        if (!$quote && !$escaped && $text =~ s{^$delim}{}) {
            push @parts, $current;
            $current = undef;
            if (defined $limit && @parts == $limit -1) {
                return @parts, $text;
            }
        }
        else {
            # pull the character off to take a looksee
            $text =~ s{(.)}{};
            my $char = $1;
            if ($char eq '"' && !$escaped) {
                # either it's defined and matches, in which case we
                # clear the quote variable, or it's undefined which
                # makes this quote an opening quote
                $quote = !$quote;
                $current .= $char if $keep;
            }
            else {
                $current .= $char;
            }
        }
        $escaped = 0;
    }

    return @parts, $current;
}

sub parse_lines {
    my $self = shift;

    my @path;
    my $current;
    for ($self->_unwrap_lines( @_ )) {
        # Ignore leading or trailing blank lines at the top/bottom of the
        # input.  Not sure about completely blank lines within the input
        next if scalar @path == 0 and $_ =~ /^\s*$/;

        if (/^BEGIN:(.*)/i) {
            push @path, $current;
            $current = { type => $1 };
            push @{ $path[-1]{objects} }, $current;
            next;
        }
        if (/^END:(.*)/i) {
            die "END $1 in $current->{type}"
              unless lc $current->{type} eq lc $1;
            $current = pop @path;
            next;
        }

        # we'd use Text::ParseWords here, but it likes to segfault.
        my ($name, $value) = parse_line( ':', 1, $_, 2);
        $value = '' unless defined $value;
        my @params = parse_line( ';', 0, $name );
        $name = shift @params;

        $value = { value => $value };

        foreach my $param (@params) {
            my ($p_name, $p_value) = split /=/, $param;
            push @{ $value->{params} }, { $p_name => $p_value }
              if $self->preserve_params;
            $value->{param}{ $p_name } = $p_value;
        }
        push @{ $current->{properties}{ $name } }, $value;
    }

    # something did a BEGIN but no END - TODO, unwind this nicely as
    # it may be more than one level
    die "BEGIN $current->{type} without matching END"
      if @path;

    return $current;
}

# this might not strictly comply
sub generate_lines {
    my $self = shift;
    my $this = shift;

    my @lines;
    # XXX all the existence checks are to prevent auto-vivification
    # breaking if_diff tests - do we mind, or should the fields have been
    # there anyway?

    push @lines, "BEGIN:$this->{type}" if exists $this->{type};
    if (exists $this->{properties}) {
        while (my ($name, $v) = each %{ $this->{properties} } ) {
            for my $value (@$v) {
                # XXX so we're taking params in preference to param,
                # let's be sure to document that when we document this
                # method
                my $param = join ';', '', map {
                    my $hash = $_;
                    map {
                        "$_" . (defined $hash->{$_} ?  "=" . $hash->{$_} : "")
                    } keys %$hash
                } @{ $value->{params} || [ $value->{param} ] };
                my $line = "$name$param:$value->{value}";
                # wrapping, but done ugly
                my @chunks = $line =~ m/(.{1,72})/g;
                push @lines, shift @chunks;
                push @lines, map { " $_" } @chunks;
            }
        }
    }

    if (exists $this->{objects}) {
        push @lines, $self->generate_lines( $_ ) for @{ $this->{objects} }
    }
    push @lines, "END:$this->{type}" if exists $this->{type};
    return @lines;
}


1;
__END__

=head1 DATA STRUCTURE

A vFile contains one or more objects, delimited by BEGIN and END tags.

  BEGIN:VCARD
  ...
  END:VCARD

Objects may contain sub-objects;

  BEGIN:VCALENDAR
  ...
  BEGIN:VEVENT
  ...
  END:VEVENT
  ...
  ENV:VCALENDAR

Each object consists of one or more properties.  Each property
consists of a name, zero or more optional parameters, and then a
value.  This fragment:

  DTSTART;VALUE=DATE:19970317

identifies a property with the name, C<DSTART>, the parameter
C<VALUE>, which has the value C<DATE>, and the property's value is
C<19970317>.  Those of you with an XML bent might find this more
recognisable as:

  <dtstart value="date">19970317</dtstart>

The return value from the C<parse()> method is a hash ref.

The top level key, C<objects>, refers to an array ref.  Each entry in the
array ref is a hash ref with two or three keys.

The value of the first key, C<type>, is a string corresponding to the
type of the object.  E.g., C<VCARD>, C<VEVENT>, and so on.

The value of the second key, C<properties>, is a hash ref, with property
names as keys, and an array ref of those property values.  It's an array
ref, because some properties may appear within an object multiple times
with different values.  For example;

  BEGIN:VEVENT
  ATTENDEE;CN="Nik Clayton":mailto:nik@FreeBSD.org
  ATTENDEE;CN="Richard Clamp":mailto:richardc@unixbeard.net
  ...
  END:VEVENT

Each entry in the array ref is a hash ref with one or two keys.

The first key, C<value>, corresponds to the property's value.

The second key, C<param>, contains a hash ref of the property's
parameters.  Keys in this hash ref are the parameter's name, the value
is the parameter's value.  (If you enable the C<preserve_params>
option there is an additional key populated, called C<params>.  It is
an array ref of hash refs, each hash ref is the parameter's name and
the parameter's value - these are collected in the order they are
encountered to prevent hash collisions as seen in some vCard files)
line.)

The third key in the top level C<objects> hash ref is C<objects>.  If
it exists, it indicates that sub-objects were found.  The value of
this key is an array ref of sub-objects, with identical keys and
behaviour to that of the top level C<objects> key.  This recursive
structure continues, nesting as deeply as there were sub-objects in
the input file.

The C<bin/v2yaml> script that comes with this distribution displays the
format of a vFile as YAML.  C<t/03usage.t> has examples of picking out
the relevant information from the data structure.

=head1 AUTHORS

Richard Clamp <richardc@unixbeard.net> and Nik Clayton <nik@FreeBSD.org>

=head1 COPYRIGHT

Copyright 2004, 2010, 2013 Richard Clamp and Nik Clayton.  All Rights Reserved.

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 CAVEATS

We don't do any decoding of property values, including descaping
C<\,>, we're still undecided as to whether this is a bug.

=head1 BUGS

Aside from the TODO list items, none known.

=head1 SEE ALSO

Text::vFile - parses to objects, doesn't handle nested items

RFC 2426 - vCard specification

RFC 2445 - vCalendar specification

=cut

# Emacs local variables to keep the style consistent

  Local Variables:
  cperl-indent-level: 4
  End:
