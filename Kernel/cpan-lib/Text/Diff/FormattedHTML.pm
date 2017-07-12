package Text::Diff::FormattedHTML;

use 5.006;
use strict;
use warnings;

use File::Slurp;
use Algorithm::Diff 'traverse_balanced';
use String::Diff 'diff';

use base 'Exporter';

our @EXPORT = (qw'diff_files diff_strings diff_css');

=head1 NAME

Text::Diff::FormattedHTML - Generate a colorful HTML diff of strings/files.

=head1 VERSION

Version 0.08

=cut

our $VERSION = '0.08';


=head1 SYNOPSIS

    use Text::Diff::FormattedHTML;

    my $output = diff_files($file1, $file2);

    # for strings

    my $output = diff_strings( { vertical => 1 }, $file1, $file2);


    # as you might want some CSS:
    open OUT, ">diff.html";
    print OUT "<style type='text/css'>\n", diff_css(), "</style>\n";
    print OUT diff_files('fileA', 'fileB');
    close OUT;


=head1 DESCRIPTION

Presents in a (nice?) HTML table the difference between two files or strings.
Inspired on GitHub diff view.

=head1 SUBROUTINES

=head2 diff_files

   my $html = diff_files("filename1", "filename2");

C<diff_files> and C<diff_strings> support a first optional argument
(an hash reference) where options can be set.

Valid options are:

=over 4

=item C<vertical>

Can be set to a true value, for a more compact table.

=item C<limit_onesided>

Makes tables look nicer when there is a side with too many new lines.

=back

=cut

sub diff_files {
    my $settings = {};
    $settings = shift if ref($_[0]) eq "HASH";

    my ($f1, $f2) = @_;

    die "$f1 not available" unless -f $f1;
    die "$f2 not available" unless -f $f2;

    my @f1 = read_file $f1;
    my @f2 = read_file $f2;

    _internal_diff($settings, \@f1, \@f2);
}

=head2 diff_strings

   my $html = diff_strings("string1", "string2");

Compare strings. First split by newline, and then treat them as file
content (see function above).

=cut

sub diff_strings {
    my $settings = {};
    $settings = shift if ref($_[0]) eq "HASH";

    my ($s1, $s2) = @_;
    my @f1 = split /\n/, $s1;
    my @f2 = split /\n/, $s2;
    _internal_diff($settings, \@f1, \@f2);
}

=head2 diff_css

   my $css = diff_css;

Return the default css. You are invited to override it.

=cut

sub diff_css {
    return <<'EOCSS';
table.diff {
   border-collapse: collapse;
   border-top: solid 1px #999999;
   border-left: solid 1px #999999;
}

table.diff td {
   padding: 2px;
   padding-left: 5px;
   padding-right: 5px;
   border-right: solid 1px #999999;
   border-bottom: solid 1px #999999;
}

table.diff td:nth-child(1),
table.diff td:nth-child(2) {
   background-color: #deedff;
}

table.diff tr.change,
table.diff tr.disc_a,
table.diff tr.disc_b {
   background-color: #ffffdd;
}

table.diff tr.del {
  background-color: #ffeeee;
}

table.diff tr.ins {
  background-color: #eeffee;
}


table.diff td:nth-child(3),
table.diff td:nth-child(4) {
   font-family: monospace;
   white-space: pre;
}

table.diff td ins {
   padding: 2px;
   color: #009900;
   background-color: #ccffcc;
   text-decoration: none;
   font-weight: bold;
}

table.diff td del {
   padding: 2px;
   color: #990000;
   background-color: #ffcccc;
   text-decoration: none;
   font-weight: bold;
}

EOCSS
}

sub _protect {
    my $x = shift;
    if ($x) {
        $x =~ s/&/&amp;/g;
        $x =~ s/</&lt;/g;
        $x =~ s/>/&gt;/g;
    }
    return $x;
}

sub _internal_diff {
    my ($settings, $sq1, $sq2) = @_;

    my $get = sub {
        my ($l, $r) = @_;
        $l = $sq1->[$l];
        $r = $sq2->[$r];
        chomp($l) if $l;
        chomp($r) if $r;
        return ($l,$r);
    };

    my ($ll, $rl);

    my $line = sub {
        sprintf("<tr class='%s'><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", @_);
    };

     if ($settings->{limit_onesided}) {
         # Prevent really long lists where we just go on showing
         # all of the values that one side does not have
         if($settings->{vertical}){
             die "Option: [vertical] is incompatible with [limit_empty]";
         }
         my ($am_skipping, $num_since_lc, $num_since_rc) = (0, 0, 0);
         $line = sub {
             my ($class, $ln, $rn, $l, $r) = @_;
 
             my $out = '';
             if(
                 ($class ne 'disc_a') &&
                 ($class ne 'disc_b')
             ){
                 if($am_skipping){
                     $out .= "($num_since_lc, $num_since_rc)</td></tr>\n";
                 }
                 ($am_skipping, $num_since_lc, $num_since_rc) = (0, 0, 0);
             }elsif($class ne 'disc_a'){
                 $num_since_lc++;
             }elsif($class ne 'disc_b'){
                 $num_since_rc++;
             }
             if(
                 ($num_since_lc > $settings->{limit_onesided}) ||
                 ($num_since_rc > $settings->{limit_onesided})
             ){
                 if(!$am_skipping){
                     $out = '<tr><td colspan=4>';
                     $am_skipping = 1;
                 }
                 $out .= '. ';
                 return $out;
             }
 
             $out .= sprintf("<tr class='%s'><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", @_);
             return $out;
         };
     }

    
    if ($settings->{vertical}) {
        $line = sub {
            my $out = "";
            my ($class, $ln, $rn, $l, $r) = @_;
            if ($l eq $r) {
                $out .= sprintf("<tr class='%s'><td>%s</td><td>%s</td><td>%s</td></tr>\n",
                                $class, $ln, $rn, $l);
            } else {
                $class eq "disc_a" && ($class = "disc_a del");
                $class eq "disc_b" && ($class = "disc_b ins");

                $class eq "change" && ($class = "change del");
                $l and $out .= sprintf("<tr class='%s'><td>%s</td><td></td><td>%s</td></tr>\n",
                                       $class, $ln, $l);
                $class eq "change del" && ($class = "change ins");
                $r and $out .= sprintf("<tr class='%s'><td></td><td>%s</td><td>%s</td></tr>\n",
                                       $class, $rn, $r);
            }
            $out
        }
    }

    my $out = "<table class='diff'>\n";

    traverse_balanced $sq1, $sq2,
      {
       MATCH     => sub {
           my ($l, $r) = $get->(@_);
           ++$ll; ++$rl;
           $out .= $line->('match', $ll, $rl, _protect($l), _protect($r));
       },
       DISCARD_A => sub {
           my ($l, $r) = $get->(@_);
           ++$ll;
           $out .= $line->('disc_a', $ll, '', _protect($l), '');
       },
       DISCARD_B => sub {
           my ($l, $r) = $get->(@_);
           ++$rl;
           $out .= $line->('disc_b', '', $rl, '', _protect($r));
       },
       CHANGE    => sub {
           my ($l, $r) = $get->(@_);
           my $diff = diff($l, $r,
                           remove_open => '#del#',
                           remove_close => '#/del#',
                           append_open => '#ins#',
                           append_close => '#/ins#',
                          );
           ++$ll; ++$rl;
           $out .= $line->('change', $ll, $rl,
                           _retag(_protect($diff->[0])), _retag(_protect($diff->[1])));
       },
      };
    $out .= "</table>\n";
}

sub _retag {
    my $x = shift;
    $x =~ s/#(.?(?:del|ins))#/<$1>/g;
    return $x;
}

=head1 AUTHOR

Alberto Simoes, C<< <ambs at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-text-diff-formattedhtml at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Diff-FormattedHTML>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Text::Diff::FormattedHTML


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Diff-FormattedHTML>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Text-Diff-FormattedHTML>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Text-Diff-FormattedHTML>

=item * Search CPAN

L<http://search.cpan.org/dist/Text-Diff-FormattedHTML/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Alberto Simoes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Text::Diff::FormattedHTML
