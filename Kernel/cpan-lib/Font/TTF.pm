package Font::TTF;

$VERSION = '1.06';   # RMH     02-Aug-2016      Bug fixes; updated OT tags;
# $VERSION = '1.05';   # MJPH    19-Jan-2015      Bug fixes; updated OT tags; GSUB Lookup Type 8 support
# $VERSION = '1.04';    # MJPH     8-Jan-2014      License, POD, and perl -w tidying; bug fixes
# $VERSION = '1.03';    # MJPH     5-Sep-2013      Add $t->minsize()
# $VERSION = '1.02';    # MJPH    30-Aug-2012      Fix case typo in Useall
# $VERSION = '1.01';    # MJPH    30-Aug-2012      add IO::String prerequisite
# $VERSION = '1.00';    # MJPH    21-Aug-2012      OS/2, OT & Graphite improvements; bug fixes
# $VERSION = '0.48';    # MJPH    15-DEC-2010      Bug fixes
# $VERSION = '0.47';    # MJPH     7-AUG-2009      Minor bug fix in Name.pm
# $VERSION = '0.46';    # MJPH    26-JAN-2009      Various bug fixes, add Sill table
# $VERSION = '0.45';    # MJPH    11-JUN-2008      Packaging tidying
# $VERSION = '0.44';    # MJPH     9-JUN-2008      Various bug fixes
# $VERSION = '0.43';    # MJPH    20-NOV-2007      Add a test!
# $VERSION = '0.42';    # MJPH    11-OCT-2007      Add Volt2ttf support
# $VERSION = '0.41';    # MJPH    27-MAR-2007      Remove warnings from font copy
#                                                  Bug fixes in Ttopen, GDEF
#                                                  Remove redundant head and maxp ->reads
# $VERSION = '0.40';    # MJPH    31-JUL-2006      Add EBDT, EBLC tables
# $VERSION = 0.39;

1;

=head1 NAME

Font::TTF - Perl module for TrueType Font hacking

=head1 DESCRIPTION

This module allows you to do almost anything to a TrueType/OpenType Font
including modify and inspect nearly all tables.

=head1 AUTHOR

Martin Hosken L<http://scripts.sil.org/FontUtils>.
(see CONTRIBUTORS for other authors).

Repository available at L<https://github.com/silnrsi/font-ttf.git>

=head1 HISTORY

See F<Changes> file for a change log.

=head1 LICENSING

Copyright (c) 1998-2016, SIL International (http://www.sil.org) 

This module is released under the terms of the Artistic License 2.0. 
For details, see the full text of the license in the file LICENSE.

The fonts in the test suite are released under the Open Font License 1.1, see F<t/OFL.txt>.


=head1 SEE ALSO

L<Font::TTF::Font>

=cut
