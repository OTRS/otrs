package Lingua::Translit::Tables;

#
# Copyright (C) 2007-2008 ...
#   Alex Linke <alinke@lingua-systems.com>
#   Rona Linke <rlinke@lingua-systems.com>
# Copyright (C) 2009-2016 Lingua-Systems Software GmbH
# Copyright (C) 2016-2017 Netzum Sorglos, Lingua-Systems Software GmbH
#

use strict;
use warnings;
use utf8;

require 5.008;

our $VERSION = '0.27';

use Carp;

=pod

=encoding utf8

=head1 NAME

Lingua::Translit::Tables - provides transliteration tables

=head1 SYNOPSIS

  use Lingua::Translit::Tables qw/:checks/;

  my $truth;

  $truth = translit_supported("ISO 9");
  $truth = translit_reverse_supported("ISO 9");

  use Lingua::Translit::Tables qw/:list/;

  translit_list_supported();

=head1 DESCRIPTION

This module is primary used to provide transliteration tables for
L<Lingua::Translit> and therefore allows one to separate data and algorithm.

Beyond that, it provides routines to check if a given transliteration is
supported and allows one to print a simple list of supported transliterations
along with some meta information.

=head1 EXPORTS

No symbols are exported by default.

Use either the routine's name or one of the following I<tags> to import
symbols to your namespace.

=over 4

=item B<all>

Import all routines.

=item B<checks>

Import all routines that allow one to check if a given transliteration is
supported: translit_supported() and translit_reverse_supported().

=item B<list>

Import translit_list_supported(). (Convenience tag)

=back

=cut

require Exporter;

our @ISA    = qw/Exporter/;
our @EXPORT = qw//;           # Export nothing by default
our @EXPORT_OK = qw/translit_supported translit_reverse_supported
  translit_list_supported/;

our %EXPORT_TAGS = (
    checks => [qw/translit_supported translit_reverse_supported/],
    list   => [qw/translit_list_supported/],
    all    => [@EXPORT_OK]
);

# For convenience, the tables are initialized at the bottom of this file.
our %tables;

# Used internally to retrieve a reference to a single transliteration table.
sub _get_table_reference {
    my $name = shift();

    return unless $name;

    $name = _get_table_id($name);

    foreach my $table ( keys %tables ) {
        return _handle_perl_unicode_bug( $tables{$table} )
          if $table =~ /^$name$/i;
    }

    return;
}

# Handle the "Unicode Bug" affecting code points in the Latin-1 block.
#
# Have a look at perlunicode (section "The 'Unicode Bug'") for details.
sub _handle_perl_unicode_bug {
    my $tbl = shift();

    foreach my $rule ( @{ $tbl->{rules} } ) {
        utf8::upgrade( $rule->{from} );
        utf8::upgrade( $rule->{to} );

        if ( defined( $rule->{context} ) ) {
            utf8::upgrade( $rule->{context}->{before} )
              if defined $rule->{context}->{before};
            utf8::upgrade( $rule->{context}->{after} )
              if defined $rule->{context}->{after};
        }
    }

    return $tbl;
}

=head1 ROUTINES

=head2 translit_supported(I<translit_name>)

Returns true (1), iff I<translit_name> is supported. False (0) otherwise.

=cut

sub translit_supported {
    return ( _get_table_reference( _get_table_id( $_[0] ) ) ? 1 : 0 );
}

=head2 translit_reverse_supported(I<translit_name>)

Returns true (1), iff I<translit_name> is supported and allows reverse
transliteration. False (0) otherwise.

=cut

sub translit_reverse_supported {
    my $table = _get_table_reference( _get_table_id( $_[0] ) );

    croak("Failed to retrieve table for $_[0].") unless ($table);

    return ( ( $table->{reverse} =~ /^true$/ ) ? 1 : 0 );
}

=head2 B<translit_list_supported()>

Prints a list of all supported transliterations to STDOUT (UTF-8 encoded),
providing the following information:

  * Name
  * Reversibility
  * Description

The same information is provided in this document as well:

=cut

sub translit_list_supported {
    require Encode;

    foreach my $table ( sort keys %tables ) {
        printf(
            "%s, %sreversible, %s\n",
            Encode::encode( 'utf8', $tables{$table}->{name} ),
            ( $tables{$table}->{reverse} eq "false" ? 'not ' : '' ),
            Encode::encode( 'utf8', $tables{$table}->{desc} )
        );
    }
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

=head1 BUGS

None known.

Please report bugs using CPAN's request tracker at
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Lingua-Translit>.

=head1 SEE ALSO

L<Lingua::Translit>

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

# Get a table's identifier (based on the table's name)
#   i.e "Common DEU" -> "common_deu"
sub _get_table_id {
    my $name = shift();

    return "" unless $name;

    $name =~ s/\s/_/g;

    return lc($name);
}

# OTRS: Disable void context warning for line below.
no warnings qw(void);

# For convenience, the next line is automatically substituted with the set
# of transliteration tables at build time.
%tables;    # PLACEHOLDER

1;

# vim: set ft=perl sts=4 sw=4 ts=4 ai et:
