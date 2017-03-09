package Text::Diff::HTML;

use strict;
use vars qw(@ISA $VERSION);
use HTML::Entities;
use Text::Diff (); # Just to be safe.

$VERSION = '0.07';
@ISA = qw(Text::Diff::Unified);

sub file_header {
    return '<div class="file"><span class="fileheader">'
           . encode_entities(shift->SUPER::file_header(@_))
           . '</span>';
}

sub hunk_header {
    return '<div class="hunk"><span class="hunkheader">'
           . encode_entities(shift->SUPER::hunk_header(@_))
           . '</span>';
}

sub hunk_footer {
    return '<span class="hunkfooter">'
           . encode_entities(shift->SUPER::hunk_footer(@_))
           . '</span></div>';
}

sub file_footer {
    return '<span class="filefooter">'
           . encode_entities(shift->SUPER::file_footer(@_))
           . '</span></div>';
}

# Each of the items in $seqs is an array reference. The first one has the
# contents of the first file and the second has the contents of the second
# file, all broken into hunks. $ops is an array reference of array references,
# one corresponding to each of the hunks in the sequences.
#
# The contents of each op in $ops tell us what to do with each hunk. Each op
# can have up to four items:
#
# 0: The index of the relevant hunk in the first file sequence.
# 1: The index of the relevant hunk in the second file sequence.
# 2: The opcode for the hunk, either '+', '-', or ' '.
# 3: A flag; not sure what this is, doesn't seem to apply to unified diffs.
#
# So what we do is figure out which op we have and output the relevant span
# element if it is different from the last op. Then we select the hunk from
# second sequence (SEQ_B_IDX) if it's '+' and the first sequence (SEQ_A_IDX)
# otherwise, and then output the opcode and the hunk.

use constant OPCODE    => 2; # "-", " ", "+"
use constant SEQ_A_IDX => 0;
use constant SEQ_B_IDX => 1;

my %code_map = (
    '+' => [ 'ins'              => 'ins' ],
    '-' => [ 'del'              => 'del' ],
    ' ' => [ 'span class="ctx"' => 'span' ]
);

sub hunk {
    shift;
    my $seqs = [ shift, shift ];
    my $ops  = shift;
    return unless @$ops;

    # Start the span element for the first opcode.
    my $last = $ops->[0][ OPCODE ];
    my $hunk = qq{<$code_map{ $last }->[0]>};

    # Output each line of the hunk.
    while (my $op = shift @$ops) {
        my $opcode = $op->[OPCODE];
        my $elem   = $code_map{ $opcode } or next;

        # Close the last span and start a new one for a new opcode.
        if ($opcode ne $last) {
            $hunk .= "</$code_map{ $last }->[1]><$elem->[0]>";
            $last  = $opcode;
        }

        # Output the appropriate line.
        my $idx = $opcode ne '+' ? SEQ_A_IDX : SEQ_B_IDX;
        $hunk  .= encode_entities("$opcode $seqs->[$idx][$op->[$idx]]");
    }

    return $hunk . "</$code_map{ $last }->[1]>";
}

1;
__END__

##############################################################################

=head1 Name

Text::Diff::HTML - XHTML format for Text::Diff::Unified

=head1 Synopsis

    use Text::Diff;

    my $diff = diff "file1.txt", "file2.txt", { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \$string1,   \$string2,   { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \*FH1,       \*FH2,       { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \&reader1,   \&reader2,   { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \@records1,  \@records2,  { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \@records1,  "file.txt",  { STYLE => 'Text::Diff::HTML' };

=head1 Description

This class subclasses Text::Diff::Unified, a formatting class provided by the
L<Text::Diff> module, to add XHTML markup to the unified diff format. For
details on the interface of the C<diff()> function, see the L<Text::Diff>
documentation.

In the XHTML formatted by this module, the contents of the diff returned by
C<diff()> are wrapped in a C<< <div> >> element, as is each hunk of the diff.
Within each hunk, all content is properly HTML encoded using
L<HTML::Entities>, and the various sections of the diff are marked up with the
appropriate XHTML elements. The elements used are as follows:

=over

=item * C<< <div class="file"> >>

This element contains the entire contents of the diff "file" returned by
C<diff()>. All of the following elements are subsumed by this one.

=over

=item * C<< <span class="fileheader"> >>

The header section for the files being C<diff>ed, usually something like:

  --- in.txt	Thu Sep  1 12:51:03 2005
  +++ out.txt	Thu Sep  1 12:52:12 2005

This element immediately follows the opening "file" C<< <div> >> element.

=item * C<< <div class="hunk"> >>

This element contains a single diff "hunk". Each hunk may contain the
following elements:

=over

=item * C<< <span class="hunkheader"> >>

Header for a diff hunk. The hunk header is usually something like:

  @@ -1,5 +1,7 @@

This element immediately follows the opening "hunk" C<< <div> >> element.

=item * C<< <span class="ctx"> >>

Context around the important part of a C<diff> hunk. These are contents that
have I<not> changed between the files being C<diff>ed.

=item * C<< <ins> >>

Inserted content, each line starting with C<+>.

=item * C<< <del> >>

Deleted content, each line starting with C<->.

=item * C<< <span class="hunkfooter"> >>

The footer section of a hunk; contains no contents.

=back

=item * C<< <span class="filefooter"> >>

The footer section of a file; contains no contents.

=back

=back

You may do whatever you like with these elements and classes; I highly
recommend that you style them using CSS. You'll find an example CSS file in
the F<eg> directory in the Text-Diff-HTML distribution. You will also likely
want to wrap the output of your diff in its own element (a C<< <div> >> will
do) styled with "white-space: pre".

=head1 See Also

=over

=item L<Text::Diff>

=item L<Algorithm::Diff>

=back

=head1 Support

This module is stored in an open L<GitHub
repository|http://github.com/theory/text-diff-html/>. Feel free to fork and
contribute!

Please file bug reports via L<GitHub
Issues|http://github.com/theory/text-diff-html/issues/> or by sending mail to
L<bug-Text-Diff-HTML@rt.cpan.org|mailto:bug-Text-Diff-HTML@rt.cpan.org>.

=head1 Author

David E. Wheeler <david@justatheory.com>

=head1 Copyright and License

Copyright (c) 2005-2011 David E. Wheeler. Some Rights Reserved.

This module is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut
