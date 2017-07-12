package Lingua::Translit;

#
# Copyright (C) 2007-2008 ...
#   Alex Linke <alinke@lingua-systems.com>
#   Rona Linke <rlinke@lingua-systems.com>
# Copyright (C) 2009-2016 Lingua-Systems Software GmbH
# Copyright (C) 2016-2017 Netzum Sorglos, Lingua-Systems Software GmbH
#

use strict;
use warnings;

require 5.008;

use Carp qw/croak/;
use Encode qw/encode decode/;

use Lingua::Translit::Tables;

our $VERSION = '0.27';

=pod

=encoding utf8

=head1 NAME

Lingua::Translit - transliterates text between writing systems

=head1 SYNOPSIS

  use Lingua::Translit;

  my $tr = new Lingua::Translit("ISO 843");

  my $text_tr = $tr->translit("character oriented string");

  if ($tr->can_reverse()) {
    $text_tr = $tr->translit_reverse("character oriented string");
  }

=head1 DESCRIPTION

Lingua::Translit can be used to convert text from one writing system to
another, based on national or international transliteration tables.
Where possible a reverse transliteration is supported.

The term C<transliteration> describes the conversion of text from one
writing system or alphabet to another one.
The conversion is ideally unique, mapping one character to exactly one
character, so the original spelling can be reconstructed.
Practically this is not always the case and one single letter of the
original alphabet can be transcribed as two, three or even more letters.

Furthermore there is more than one transliteration scheme for one writing
system.
Therefore it is an important and necessary information, which scheme will be
or has been used to transliterate a text, to work integrative and be able to
reconstruct the original data.

Reconstruction is a problem though for non-unique transliterations, if no
language specific knowledge is available as the resulting clusters of
letters may be ambiguous.
For example, the Greek character "PSI" maps to "ps", but "ps" could also
result from the sequence "PI", "SIGMA" since "PI" maps to "p" and "SIGMA"
maps to s.
If a transliteration table leads to ambiguous conversions, the provided
table cannot be used reverse.

Otherwise the table can be used in both directions, if appreciated.
So if ISO 9 is originally created to convert Cyrillic letters to
the Latin alphabet, the reverse transliteration will transform Latin
letters to Cyrillic.

=head1 METHODS

=head2 new(I<"name of table">)

Initializes an object with the specific transliteration table, e.g. "ISO 9".

=cut

sub new {
    my $class = shift();
    my $name  = shift();

    my $self;

    # Assure that a table name was set
    croak("No transliteration name given.") unless $name;

    # Stay compatible with programs that use Lingua::Translit < 0.05
    if ( $name =~ /^DIN 5008$/i ) {
        $name = "Common DEU";
    }

    my $table = Lingua::Translit::Tables::_get_table_reference($name);

    # Check that a table reference was assigned to the object
    croak("No table found for $name.") unless $table;

    # Assure the table's data is complete
    croak("$name table: missing 'name'")    unless defined $table->{name};
    croak("$name table: missing 'desc'")    unless defined $table->{desc};
    croak("$name table: missing 'reverse'") unless defined $table->{reverse};
    croak("$name table: missing 'rules'")   unless defined $table->{rules};

    # Copy over the table's data
    $self->{name}  = $table->{name};
    $self->{desc}  = $table->{desc};
    $self->{rules} = $table->{rules};

    # Set a truth value of the transliteration's reversibility according to
    # the natural language string in the original transliteration table
    $self->{reverse} = ( $table->{reverse} =~ /^true$/i ) ? 1 : 0;

    undef($table);

    return bless $self, $class;
}

=head2 translit(I<"character oriented string">)

Transliterates the given text according to the object's transliteration
table.
Returns the transliterated text.

=cut

sub translit {
    my $self = shift();
    my $text = shift();

    # Return if no input was given
    return unless $text;

    my $utf8_flag_on = Encode::is_utf8($text);

    unless ($utf8_flag_on) {
        $text = decode( "UTF-8", $text );
    }

    foreach my $rule ( @{ $self->{rules} } ) {
        if ( defined $rule->{context} ) {
            my $c = $rule->{context};

            # single context rules
            if ( defined $c->{before} && !defined $c->{after} ) {
                $text =~ s/$rule->{from}(?=$c->{before})/$rule->{to}/g;
            }
            elsif ( defined $c->{after} && !defined $c->{before} ) {
                $text =~ s/(?<=$c->{after})$rule->{from}/$rule->{to}/g;
            }

            # double context rules: logical "inbetween"
            elsif ( defined $c->{before} && defined $c->{after} ) {
                $text =~ s/
                (?<=$c->{after})$rule->{from}(?=$c->{before})
                /$rule->{to}/gx;
            }

            else {
                croak("incomplete rule context");
            }
        }
        else {
            $text =~ s/$rule->{from}/$rule->{to}/g;
        }
    }

    unless ($utf8_flag_on) {
        return encode( "UTF-8", $text );
    }
    else {
        return $text;
    }
}

=head2 translit_reverse(I<"character oriented string">)

Transliterates the given text according to the object's transliteration
table, but uses it the other way round. For example table ISO 9 is a
transliteration scheme for the converion of Cyrillic letters to the Latin
alphabet. So if used reverse, Latin letters will be mapped to Cyrillic ones.

Returns the transliterated text.

=cut

sub translit_reverse {
    my $self = shift();
    my $text = shift();

    # Return if no input was given
    return unless $text;

    # Is this transliteration reversible?
    croak("$self->{name} cannot be reversed") unless $self->{reverse};

    my $utf8_flag_on = Encode::is_utf8($text);

    unless ($utf8_flag_on) {
        $text = decode( "UTF-8", $text );
    }

    foreach my $rule ( @{ $self->{rules} } ) {
        if ( defined $rule->{context} ) {
            my $c = $rule->{context};

            # single context rules
            if ( defined $c->{before} && !defined $c->{after} ) {
                $text =~ s/$rule->{to}(?=$c->{before})/$rule->{from}/g;
            }
            elsif ( defined $c->{after} && !defined $c->{before} ) {
                $text =~ s/(?<=$c->{after})$rule->{to}/$rule->{from}/g;
            }

            # double context rules: logical "inbetween"
            elsif ( defined $c->{before} && defined $c->{after} ) {
                $text =~ s/
                    (?<=$c->{after})$rule->{to}(?=$c->{before})
                    /$rule->{from}/gx;
            }

            else {
                croak("incomplete rule context");
            }
        }
        else {
            $text =~ s/$rule->{to}/$rule->{from}/g;
        }
    }

    unless ($utf8_flag_on) {
        return encode( "UTF-8", $text );
    }
    else {
        return $text;
    }
}

=head2 can_reverse()

Returns true (1), iff reverse transliteration is possible.
False (0) otherwise.

=cut

sub can_reverse {
    return $_[0]->{reverse};
}

=head2 name()

Returns the name of the chosen transliteration table, e.g. "ISO 9".

=cut

sub name {
    return $_[0]->{name};
}

=head2 desc()

Returns a description for the transliteration,
e.g. "ISO 9:1995, Cyrillic to Latin".

=cut

sub desc {
    return $_[0]->{desc};
}

=head1 SUPPORTED TRANSLITERATIONS

=over 4

=item Cyrillic

I<ALA-LC RUS>, not reversible, ALA-LC:1997, Cyrillic to Latin, Russian

I<ISO 9>, reversible, ISO 9:1995, Cyrillic to Latin

I<ISO/R 9>, reversible, ISO 9:1954, Cyrillic to Latin

I<DIN 1460 RUS>, reversible, DIN 1460:1982, Cyrillic to Latin, Russian

I<DIN 1460 UKR>, reversible, DIN 1460:1982, Cyrillic to Latin, Ukrainian

I<DIN 1460 BUL>, reversible, DIN 1460:1982, Cyrillic to Latin, Bulgarian

I<Streamlined System BUL>, not reversible, The Streamlined System: 2006,
Cyrillic to Latin, Bulgarian

I<GOST 7.79 RUS>, reversible, GOST 7.79:2000 (table B), Cyrillic to Latin,
Russian

I<GOST 7.79 RUS OLD>, not reversible, GOST 7.79:2000 (table B), Cyrillic to
Latin with support for Old Russian (pre 1918), Russian

I<GOST 7.79 UKR>, reversible, GOST 7.79:2000 (table B), Cyrillic to Latin,
Ukrainian

I<BGN/PCGN RUS Standard>, not reversible, BGN/PCGN:1947 (Standard Variant),
Cyrillic to Latin, Russian

I<BGN/PCGN RUS Strict>, not reversible, BGN/PCGN:1947 (Strict Variant),
Cyrillic to Latin, Russian

=item Greek

I<ISO 843>, not reversible, ISO 843:1997, Greek to Latin

I<DIN 31634>, not reversible, DIN 31634:1982, Greek to Latin

I<Greeklish>, not reversible, Greeklish (Phonetic), Greek to Latin

=item Latin

I<Common CES>, not reversible, Czech without diacritics

I<Common DEU>, not reversible, German without umlauts

I<Common POL>, not reversible, Unaccented Polish

I<Common RON>, not reversible, Romanian without diacritics as commonly used

I<Common SLK>, not reversible, Slovak without diacritics

I<Common SLV>, not reversible, Slovenian without diacritics

I<ISO 8859-16 RON>, reversible, Romanian with appropriate diacritics

=item Arabic

I<Common ARA>, not reversible, Common Romanization of Arabic

=item Sanskrit

I<IAST Devanagari>, not reversible, IAST Romanization to Devanāgarī

I<Devanagari IAST>, not reversible, Devanāgarī to IAST Romanization

=back

=head1 ADDING NEW TRANSLITERATIONS

In case you want to add your own transliteration tables to
L<Lingua::Translit>, have a look at the developer documentation at
L<http://www.netzum-sorglos.de/software/lingua-translit/developer-documentation.html>.

A template of a transliteration table is provided as well
(F<xml/template.xml>) so you can easily start developing.


=head1 RESTRICTIONS

L<Lingua::Translit> is suited to handle B<Unicode> and utilizes comparisons
and regular expressions that rely on B<code points>.
Therefore, any input is supposed to be B<character oriented>
(C<use utf8;>, ...) instead of byte oriented.

However, if your data is byte oriented, be sure to pass it
B<UTF-8 encoded> to translit() and/or translit_reverse() - it will be
converted internally.

=head1 BUGS

None known.

Please report bugs using CPAN's request tracker at
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Lingua-Translit>.

=head1 SEE ALSO

L<Lingua::Translit::Tables>, L<Encode>, L<perlunicode>

C<translit>'s manpage

L<http://www.netzum-sorglos.de/software/lingua-translit/>

=head1 CREDITS

Thanks to Dr. Daniel Eiwen, Romanisches Seminar, Universitaet Koeln for his
help on Romanian transliteration.

Thanks to Dmitry Smal and Rusar Publishing for contributing the "ALA-LC RUS"
transliteration table.

Thanks to Ahmed Elsheshtawy for his help implementing the "Common ARA" Arabic
transliteration.

Thanks to Dusan Vuckovic for contributing the "ISO/R 9" transliteration table.

Thanks to Ștefan Suciu for contributing the "ISO 8859-16 RON" transliteration
table.

Thanks to Philip Kime for contributing the "IAST Devanagari" and "Devanagari
IAST" transliteration tables.

Thanks to Nikola Lečić for contributing the "BGN/PCGN RUS Standard" and
"BGN/PCGN RUS Strict" transliteration tables.

=head1 AUTHORS

Alex Linke <alinke@netzum-sorglos.de>

Rona Linke <rlinke@netzum-sorglos.de>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2007-2008 Alex Linke and Rona Linke

Copyright (C) 2009-2016 Lingua-Systems Software GmbH

Copyright (C) 2016-2017 Netzum Sorglos, Lingua-Systems Software GmbH

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;

# vim: set ft=perl sts=4 sw=4 ts=4 ai et:
