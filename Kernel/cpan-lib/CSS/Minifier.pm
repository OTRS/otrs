package CSS::Minifier;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(minify);

our $VERSION = '0.01';

# -----------------------------------------------------------------------------

sub isSpace {
  my $x = shift;
  return ($x eq ' ' || $x eq "\t");
}

sub isEndspace {
  my $x = shift;
  return ($x eq "\n" || $x eq "\r" || $x eq "\f");
}

sub isWhitespace {
  my $x = shift;
  return (isSpace($x) || isEndspace($x));
}

# whitespace characters before or after these characters can be removed.
sub isInfix {
  my $x = shift;
  return ($x eq '{' || $x eq '}' || $x eq ';' || $x eq ':');  
}

# whitespace characters after these characters can be removed.
sub isPrefix {
  my $x = shift;
  return (isInfix($x));
}

# whitespace characters before these characters can removed.
sub isPostfix {
  my $x = shift;
  return (isInfix($x));
}

# -----------------------------------------------------------------------------

sub _get {
  my $s = shift;
  if ($s->{inputType} eq 'file') {
    return getc($s->{input});
  }
  elsif ($s->{inputType} eq 'string') {
    if ($s->{'inputPos'} < length($s->{input})) {
      return substr($s->{input}, $s->{inputPos}++, 1);
    }
    else { # Simulate getc() when off the end of the input string.
      return undef;
    }
  }
  else {
   die "no input";
  }
}

sub _put {
  my $s = shift;
  my $x = shift;
  my $outfile = ($s->{outfile});
  if (defined($s->{outfile})) {
    print $outfile $x;
  }
  else {
    $s->{output} .= $x;
  }
}

# -----------------------------------------------------------------------------
# print a
# new b
#
# i.e. print a and advance
sub action1 {
  my $s = shift;
  $s->{last} = $s->{a};
  _put($s, $s->{a});
  action2($s);
}

# move b to a
# new b
#
# i.e. delete a and advance
sub action2 {
  my $s = shift;
  $s->{a} = $s->{b};
  $s->{b} = $s->{c};
  $s->{c} = _get($s);
}

# -----------------------------------------------------------------------------

# put string literals
# when this sub is called, $s->{a} is on the opening delimiter character
sub putLiteral {
  my $s = shift;
  my $delimiter = $s->{a}; # ' or "

  action1($s);
  do {
    while (defined($s->{a}) && $s->{a} eq '\\') { # escape character escapes only the next one character
      action1($s);       
      action1($s);       
    }
    action1($s);
  } until ($s->{last} eq $delimiter || !defined($s->{a}));
  if ($s->{last} ne $delimiter) { # ran off end of file before printing the closing delimiter
    die 'unterminated ' . ($delimiter eq '\'' ? 'single quoted string' : 'double quoted string') . ' literal, stopped';
  }
}

# -----------------------------------------------------------------------------

# If $s->{a} is a whitespace then collapse all following whitespace.
# If any of the whitespace is a new line then ensure $s->{a} is a new line
# when this function ends.
sub collapseWhitespace {
  my $s = shift;
  while (defined($s->{a}) && isWhitespace($s->{a}) &&
         defined($s->{b}) && isWhitespace($s->{b})) {
    if (isEndspace($s->{a}) || isEndspace($s->{b})) {
      $s->{a} = "\n";
    }
    action2($s); # delete b
  }
}

# Advance $s->{a} to non-whitespace or end of file.
# Doesn't print any of this whitespace.
sub skipWhitespace {
  my $s = shift;
  while (defined($s->{a}) && isWhitespace($s->{a})) {
    action2($s);
  }
}

# #s->{a} should be on whitespace when this function is called
sub preserveWhitespace {
  my $s = shift;
  collapseWhitespace($s);
  if (defined($s->{a}) && defined($s->{b}) && !isPostfix($s->{b})) {
    action1($s); # print the whitespace character
  }
  skipWhitespace($s);
}

# -----------------------------------------------------------------------------

sub minify {
  my %h = @_;
  # Immediately turn hash into a hash reference so that notation is the same in this function
  # as others. Easier refactoring.
  my $s = \%h; # hash reference for "state". This module is functional programming and the state is passed between functions.
  
  # determine if the the input is a string or a file handle.
  my $ref = \$s->{input};
  if (defined($ref) && ref($ref) eq 'SCALAR'){
    $s->{inputPos} = 0;
    $s->{inputType} = 'string';
  }
  else {
    $s->{inputType} = 'file';
  }
  
  # Determine if the output is to a string or a file.
  if (!defined($s->{outfile})) {
    $s->{output} = '';
  }
  
  # Print the copyright notice first
  if ($s->{copyright}) {
    _put($s, '/* ' . $s->{copyright} . ' */');
  }
  
  # Initialize the buffer.
  do {
    $s->{a} = _get($s);
  } while (defined($s->{a}) && isWhitespace($s->{a}));
  $s->{b} = _get($s);
  $s->{c} = _get($s);
  $s->{last} = undef;

  # local variables
  my $macIeCommentHackFlag = 0; # marks if a have recently seen a comment with an escaped  close like this /* foo \*/
                                # and have not yet seen a regular comment to close this like /* bar */

  while (defined($s->{a})) { # on this line $s->{a} should always be a non-whitespace character or undef (i.e. end of file)
  
    if (isWhitespace($s->{a})) { # check that this program is running correctly
      die 'minifier bug: minify while loop starting with whitespace, stopped';
    }
    
    # Each branch handles trailing whitespace and ensures $s->{a} is on non-whitespace or undef when branch finishes
    if ($s->{a} eq '/' && defined($s->{b}) && $s->{b} eq '*') { # a comment
      do {
        action2($s); # advance buffer by one
        # if a is \, b is *, c is /, hack flag false
           # Mac/IE hack start
           # set hack flag true
           # print /*\*/
        if ($s->{a} eq '\\' &&
            defined($s->{b}) && $s->{b} eq '*' && 
            defined($s->{c}) && $s->{c} eq '/' && 
            !$macIeCommentHackFlag) {
            $macIeCommentHackFlag = 1;
            _put($s, '/*\\*/');
            $s->{last} = '/';
        }
        # if a is not \, b is *, c is /, hack flag true
           # Mac/IE hack end
           # set hack flag false
           # print /**/
        if ($s->{a} ne '\\' &&
            defined($s->{b}) && $s->{b} eq '*' && 
            defined($s->{c}) && $s->{c} eq '/' && 
            $macIeCommentHackFlag) {
            $macIeCommentHackFlag = 0;
            _put($s, '/**/');
            $s->{last} = '/';
        }
           
      } until (!defined($s->{b}) || ($s->{a} eq '*' && $s->{b} eq '/'));
      if (defined($s->{b})) { # $s->{a} is asterisk and $s->{b} is forward slash
        action2($s); # the *
        $s->{a} = ' ';  # the /
        skipWhitespace($s);
      }
      else {
        die 'unterminated comment, stopped';
      }
    }
    elsif ($s->{a} eq '\'' || $s->{a} eq '"') {
      putLiteral($s);
      if (defined($s->{a}) && isWhitespace($s->{a})) {
        preserveWhitespace($s); # can this be skipWhitespace?
      }
    }
    elsif (isPrefix($s->{a})) {
      action1($s);
      skipWhitespace($s);
    }
    else { # anything else just prints
      action1($s);
      if (defined($s->{a}) && isWhitespace($s->{a})) {
          preserveWhitespace($s);
      }
    }
  }
  
  if (!defined($s->{outfile})) {
    return $s->{output};
  }
  
}

# -----------------------------------------------------------------------------

1;
__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

CSS::Minifier - Perl extension for minifying CSS

=head1 SYNOPSIS

To minify a CSS file and have the output written directly to another file

  use CSS::Minifier qw(minify);
  open(INFILE, 'myStylesheet.css') or die;
  open(OUTFILE, 'myStylesheet.css') or die;
  minify(input => *INFILE, outfile => *OUTFILE);
  close(INFILE);
  close(OUTFILE);

To minify a CSS string literal. Note that by omitting the outfile parameter a the minified code is returned as a string.

  my minifiedCSS = minify(input => 'div {font-family: serif;}');
  
To include a copyright comment at the top of the minified code.

  minify(input => 'div {font-family: serif;}', copyright => 'BSD License');

The "input" parameter is manditory. The "output" and "copyright" parameters are optional and can be used in any combination.

=head1 DESCRIPTION

This module removes unnecessary whitespace from CSS. The primary requirement developing this module is to not break working stylesheets: if working CSS is in input then working CSS is output. The Mac/Internet Explorer comment hack will be minimized but not stripped and so will continue to function.

This module understands space, horizontal tab, new line, carriage return, and form feed characters to be whitespace. Any other characters that may be considered whitespace are not minimized. These other characters include paragraph separator and vertical tab.

For static CSS files, it is recommended that you minify during the build stage of web deployment. If you minify on-the-fly then it might be a good idea to cache the minified file. Minifying static files on-the-fly repeatedly is wasteful.

=head2 EXPORT

None by default.

Exportable on demand: minifiy()


=head1 SEE ALSO

This project is developed using an SVN repository. To check out the repository
svn co http://dev.michaux.ca/svn/random/CSS-Minifier

You may also be interested in the JavaScript::Minifier module also available on CPAN.


=head1 AUTHORS

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
