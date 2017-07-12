package String::Diff;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( diff_fully diff diff_merge diff_regexp );

BEGIN {
    local $@;
    if ($ENV{STRING_DIFF_PP}) {
        $@ = 1;
    } else {
        eval "use Algorithm::Diff::XS qw( sdiff );"; ## no critic
    }
    if ($@) {
        eval "use Algorithm::Diff qw( sdiff );"; ## no critic
        die $@ if $@;
    }
}

our $VERSION = '0.07';

our %DEFAULT_MARKS = (
    remove_open  => '[',
    remove_close => ']',
    append_open  => '{',
    append_close => '}',
    separator    => '', # for diff_merge
);

sub diff_fully {
    my($old, $new, %opts) = @_;
    my $old_diff = [];
    my $new_diff = [];

    if ($opts{linebreak}) {
        my @diff = sdiff( map{ my @l = map { ( $_, "\n") } split /\n/, $_; pop @l; [ @l ]} $old, $new);
        for my $line (@diff) {
            if ($line->[0] eq 'c') {
                # change
                my($old_diff_tmp, $new_diff_tmp) = _fully($line->[1], $line->[2]);
                push @{ $old_diff }, @{ $old_diff_tmp };
                push @{ $new_diff }, @{ $new_diff_tmp };
            } elsif ($line->[0] eq '-') {
                # remove
                push @{ $old_diff }, ['-', $line->[1]];
            } elsif ($line->[0] eq '+') {
                # append
                push @{ $new_diff }, ['+', $line->[2]];
            } else {
                # unchage
                push @{ $old_diff }, ['u', $line->[1]];
                push @{ $new_diff }, ['u', $line->[2]];
            }
        }
    } else {
        ($old_diff, $new_diff) = _fully($old, $new);
    }
    wantarray ? ($old_diff, $new_diff) : [ $old_diff, $new_diff];
}

sub _fully {
    my($old, $new) = @_;
    return ([], []) unless $old || $new;
    my @old_diff = ();
    my @new_diff = ();
    my $old_str;
    my $new_str;

    my @diff = sdiff( map{ $_ ? [ split //, $_ ] : [] } $old, $new);
    my $last_mode = $diff[0]->[0];
    for my $line (@diff) {
        if ($last_mode ne $line->[0]) {
            push @old_diff, [$last_mode, $old_str] if defined $old_str;
            push @new_diff, [$last_mode, $new_str] if defined $new_str;

            # skip concut ## i forget s mark
            push @old_diff, ['s', ''] unless defined $old_str;
            push @new_diff, ['s', ''] unless defined $new_str;

            $old_str = $new_str = undef;
        }
 
        $old_str .= $line->[1];
        $new_str .= $line->[2];
        $last_mode = $line->[0];
    }
    push @old_diff, [$last_mode, $old_str] if defined $old_str;
    push @new_diff, [$last_mode, $new_str] if defined $new_str;

    @old_diff = _fully_filter('-', @old_diff);
    @new_diff = _fully_filter('+', @new_diff);

    return (\@old_diff, \@new_diff);
}

sub _fully_filter {
    my($c_mode, @diff) = @_;
    my @filter = ();
    my $last_line = ['', ''];

    for my $line (@diff) {
        $line->[0] = $c_mode if $line->[0] eq 'c';
        if ($last_line->[0] eq $line->[0]) {
            $last_line->[1] .= $line->[1];
            next;
        }
        push @filter, $last_line if length $last_line->[1];
        $last_line = $line;
    }
    push @filter, $last_line if length $last_line->[1];
    
    @filter;
}

sub diff {
    my($old, $new, %opts) = @_;
    my($old_diff, $new_diff) = diff_fully($old, $new, %opts);
    %opts = (%DEFAULT_MARKS, %opts);

    my $old_str = _str($old_diff, %opts);
    my $new_str = _str($new_diff, %opts);

    wantarray ? ($old_str, $new_str) : [ $old_str, $new_str];
}

sub _str {
    my($diff, %opts) = @_;
    my $str = '';

    my $escape;
    if ($opts{escape} && ref($opts{escape}) eq 'CODE') {
        $escape = $opts{escape};
    }
    for my $parts (@{ $diff }) {
        my $word = $escape ? $escape->($parts->[1]) : $parts->[1];
        if ($parts->[0] eq '-') {
            $str .= "$opts{remove_open}$word$opts{remove_close}";
        } elsif ($parts->[0] eq '+') {
            $str .= "$opts{append_open}$word$opts{append_close}";
        } else {
            $str .= $word;
        }
    }
    $str;
}

sub diff_merge {
    my($old, $new, %opts) = @_;
    my($old_diff, $new_diff) = diff_fully($old, $new, %opts);
    %opts = (%DEFAULT_MARKS, %opts);

    my $old_c = 0;
    my $new_c = 0;
    my $str = '';

    my $escape;
    if ($opts{regexp}) {
        $escape = sub { quotemeta($_[0]) };
    } elsif ($opts{escape} && ref($opts{escape}) eq 'CODE') {
        $escape = $opts{escape};
    }
    LOOP:
    while (scalar(@{ $old_diff }) > $old_c && scalar(@{ $new_diff }) > $new_c) {
        my $old_str = $escape ? $escape->($old_diff->[$old_c]->[1]) : $old_diff->[$old_c]->[1];
        my $new_str = $escape ? $escape->($new_diff->[$new_c]->[1]) : $new_diff->[$new_c]->[1];

        if ($old_diff->[$old_c]->[0] eq 'u' && $new_diff->[$new_c]->[0] eq 'u') {
            $str .= $old_str;
            $old_c++;
            $new_c++;
        } elsif ($old_diff->[$old_c]->[0] eq '-' && $new_diff->[$new_c]->[0] eq '+') {
            $str .= "$opts{remove_open}$old_str";
            $str .= "$opts{remove_close}$opts{separator}$opts{append_open}" unless $opts{regexp};
            $str .= $opts{separator} if $opts{regexp};
            $str .= "$new_str$opts{append_close}";
            $old_c++;
            $new_c++;
        } elsif ($old_diff->[$old_c]->[0] eq 'u' && $new_diff->[$new_c]->[0] eq '+') {
            $str .= "$opts{append_open}$new_str$opts{append_close}";
            $new_c++;
        } elsif ($old_diff->[$old_c]->[0] eq '-' && $new_diff->[$new_c]->[0] eq 'u') {
            $str .= "$opts{remove_open}$old_str$opts{remove_close}";
            $old_c++;
        }
    }

    $str .= _list_gc($old_diff, $old_c, %opts);
    $str .= _list_gc($new_diff, $new_c, %opts);

    $str;
}

sub _list_gc {
    my($diff, $c, %opts) = @_;
    my $str = '';

    my $escape;
    if ($opts{regexp}) {
        $escape = sub { quotemeta($_[0]) };
    } elsif ($opts{escape} && ref($opts{escape}) eq 'CODE') {
        $escape = $opts{escape};
    }
    while (scalar(@{ $diff }) > $c) {
        my $_str = $escape ? $escape->($diff->[$c]->[1]) : $diff->[$c]->[1];
        if ($diff->[$c]->[0] eq '-') {
            $str .= "$opts{remove_open}$_str$opts{remove_close}";
        } elsif ($diff->[$c]->[0] eq '+') {
            $str .= "$opts{append_open}$_str$opts{append_close}";
        } else {
            $str .= $_str;
        }
        $c++;
    }
    $str;
}

my %regexp_opts = (
    remove_open  => '(?:',
    remove_close => ')',
    append_open  => '(?:',
    append_close => ')',
    separator    => '|',
    regexp       => 1,
    escape       => undef,
);

sub diff_regexp {
    my($old, $new, %opts) = @_;
    diff_merge($old, $new, %opts, %regexp_opts);
}

1;
__END__

=head1 NAME

String::Diff - Simple diff to String

=head1 SYNOPSIS

  use String::Diff;
  use String::Diff qw( diff_fully diff diff_merge diff_regexp );# export functions

  # simple diff
  my($old, $new) = String::Diff::diff('this is Perl', 'this is Ruby');
  print "$old\n";# this is [Perl]
  print "$new\n";# this is {Ruby}

  my $diff = String::Diff::diff('this is Perl', 'this is Ruby');
  print "$diff->[0]\n";# this is [Perl]
  print "$diff->[1]\n";# this is {Ruby}

  my $diff = String::Diff::diff('this is Perl', 'this is Ruby',
      remove_open => '<del>',
      remove_close => '</del>',
      append_open => '<ins>',
      append_close => '</ins>',
  );
  print "$diff->[0]\n";# this is <del>Perl</del>
  print "$diff->[1]\n";# this is <ins>Ruby</ins>

  # merged
  my $diff = String::Diff::diff_merge('this is Perl', 'this is Ruby');
  print "$diff\n";# this is [Perl]{Ruby}

  my $diff = String::Diff::diff_merge('this is Perl', 'this is Ruby',
      remove_open => '<del>',
      remove_close => '</del>',
      append_open => '<ins>',
      append_close => '</ins>',
  );
  print "$diff\n";# this is <del>Perl</del><ins>Ruby</ins>

  # change to default marks
  %String::Diff::DEFAULT_MARKS = (
      remove_open  => '<del>',
      remove_close => '</del>',
      append_open  => '<ins>',
      append_close => '</ins>',
      separator    => '&lt;-OLD|NEW-&gt;', # for diff_merge
  );

  # generated for regexp
  my $diff = String::Diff::diff_regexp('this is Perl', 'this is Ruby');
  print "$diff\n";# this\ is\ (?:Perl|Ruby)

  # detailed list
  my $diff = String::Diff::diff_fully('this is Perl', 'this is Ruby');
  for my $line (@{ $diff->[0] }) {
      print "$line->[0]: '$line->[1]'\n";
  }
  # u: 'this is '
  # -: 'Perl'

  for my $line (@{ $diff->[1] }) {
      print "$line->[0]: '$line->[1]'\n";
  }
  # u: 'this is '
  # +: 'Ruby'

=head1 DESCRIPTION

String::Diff is the difference of a consecutive string is made.
after general diff is done, the difference in the line is searchable.

the mark of the addition and the deletion can be freely changed.
the color is colored to the terminal with ANSI, using the HTML display it.

after the line is divided, diff is taken when 'linebreak' option is specified.

  my($old_string, $new_string) = String::Diff::diff_fully('this is Perl', 'this is Ruby', linebreak => 1);
  my($old_string, $new_string) = String::Diff::diff('this is Perl', 'this is Ruby', linebreak => 1);
  my $string = String::Diff::diff_merge('this is Perl', 'this is Ruby', linebreak => 1);
  my $string = String::Diff::diff_regexp('this is Perl', 'this is Ruby', linebreak => 1);

In diff and diff_merge methods the mark of the difference can be changed.

  my $diff = String::Diff::diff('this is Perl', 'this is Ruby',
      remove_open => '<del>',
      remove_close => '</del>',
      append_open => '<ins>',
      append_close => '</ins>',
  );

You can escape callback set to diff function and diff_merge function.

  use HTML::Entities
  my($diff_old, $diff_new) = String::Diff::diff(
      'this is <b>Perl</b>',
      'this is <b><BIG>R</BIG>uby</b>',
      remove_open => '<del>',
      remove_close => '</del>',
      append_open => '<ins>',
      append_close => '</ins>',
      escape       => sub { encode_entities($_[0]) },
  });
  is($diff_old, 'this is &lt;b&gt;<del>Perl</del>&lt;/b&gt;');
  is($diff_new, 'this is &lt;b&gt;<ins>&lt;BIG&gt;R&lt;/BIG&gt;uby</ins>&lt;/b&gt;');


=head1 METHODS

=over 4

=item diff_fully

  the list that divides diff according to the mark is returnd.

    my($old_string, $new_string) = String::Diff::diff_fully('this is Perl', 'this is Ruby');

=item diff

  abd the mark of the deletion and the addition is given to the string.

=item diff_merge

  old and new string is merged with diff.

=item diff_regexp

  the regular expression to which old string and new string are matched with regexp is returned.

=back

=head1 AUTHOR

Kazuhiro Osawa E<lt>yappo {@} shibuya {dot} plE<gt>

=head1 SEE ALSO

L<Algorithm::Diff>

=head1 LICENSE

Copyright 2008 (C) Kazuhiro Osawa

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
