package JavaScript::Minifier;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(minify);

our $VERSION = '1.05';

# -----------------------------------------------------------------------------

#return true if the character is allowed in identifier.
sub isAlphanum {
  my $x = shift;
  return ($x =~ /[\w\$\\]/ || ord($x) > 126);
}

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

# New line characters before or after these characters can be removed.
# Not + - / in this list because they require special care.
sub isInfix {
  my $x = shift;
  $x =~ /[,;:=&%*<>\?\|\n]/;
}

# New line characters after these characters can be removed.
sub isPrefix {
  my $x = shift;
  return ($x =~ /[\{\(\[!]/ || isInfix($x));
}

# New line characters before these characters can removed.
sub isPostfix {
  my $x = shift;
  return ($x =~ /[\}\)\]]/ || isInfix($x));
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
# move b to a
# move c to b
# move d to c
# new d
#
# i.e. print a and advance
sub action1 {
  my $s = shift;
  if (!isWhitespace($s->{a})) {
    $s->{lastnws} = $s->{a};    
  }
  $s->{last} = $s->{a};
  action2($s);
}

# sneeky output $s->{a} for comments
sub action2 {
  my $s = shift;
  _put($s, $s->{a});
  action3($s);
}

# move b to a
# move c to b
# move d to c
# new d
#
# i.e. delete a
sub action3 {
  my $s = shift;
  $s->{a} = $s->{b};
  action4($s);
}

# move c to b
# move d to c
# new d
#
# i.e. delete b
sub action4 {
  my $s = shift;
  $s->{b} = $s->{c};
  $s->{c} = $s->{d};
  $s->{d} = _get($s);
}

# -----------------------------------------------------------------------------

# put string and regexp literals
# when this sub is called, $s->{a} is on the opening delimiter character
sub putLiteral {
  my $s = shift;
  my $delimiter = $s->{a}; # ', " or /
  action1($s);
  do {
    while (defined($s->{a}) && $s->{a} eq '\\') { # escape character only escapes only the next one character
      action1($s);       
      action1($s);       
    }
    action1($s);
  } until ($s->{last} eq $delimiter || !defined($s->{a}));
  if ($s->{last} ne $delimiter) { # ran off end of file before printing the closing delimiter
    die 'unterminated ' . ($delimiter eq '\'' ? 'single quoted string' : $delimiter eq '"' ? 'double quoted string' : 'regular expression') . ' literal, stopped';
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
    action4($s); # delete b
  }
}

# Advance $s->{a} to non-whitespace or end of file.
# Doesn't print any of this whitespace.
sub skipWhitespace {
  my $s = shift;
  while (defined($s->{a}) && isWhitespace($s->{a})) {
    action3($s);
  }
}

# Advance $s->{a} to non-whitespace or end of file
# If any of the whitespace is a new line then print one new line.
sub preserveEndspace {
  my $s = shift;
  collapseWhitespace($s);
  if (defined($s->{a}) && isEndspace($s->{a}) && defined($s->{b}) && !isPostfix($s->{b}) ) {
    action1($s);
  }
  skipWhitespace($s);
}

sub onWhitespaceConditionalComment {
  my $s = shift;
  return (defined($s->{a}) && isWhitespace($s->{a}) &&
          defined($s->{b}) && $s->{b} eq '/' &&
          defined($s->{c}) && ($s->{c} eq '/' || $s->{c} eq '*') &&
          defined($s->{d}) && $s->{d} eq '@');
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
  $s->{d} = _get($s);
  $s->{last} = undef; # assign for safety
  $s->{lastnws} = undef; # assign for safety

  # local variables
  my $ccFlag; # marks if a comment is an Internet Explorer conditional comment and should be printed to output

  while (defined($s->{a})) { # on this line $s->{a} should always be a non-whitespace character or undef (i.e. end of file)
    
    if (isWhitespace($s->{a})) { # check that this program is running correctly
      die 'minifier bug: minify while loop starting with whitespace, stopped';
    }
    
    # Each branch handles trailing whitespace and ensures $s->{a} is on non-whitespace or undef when branch finishes
    if ($s->{a} eq '/') { # a division, comment, or regexp literal
      if (defined($s->{b}) && $s->{b} eq '/') { # slash-slash comment
        $ccFlag = defined($s->{c}) && $s->{c} eq '@'; # tests in IE7 show no space allowed between slashes and at symbol
        do {
          $ccFlag ? action2($s) : action3($s);
        } until (!defined($s->{a}) || isEndspace($s->{a}));
        if (defined($s->{a})) { # $s->{a} is a new line
          if ($ccFlag) {
            action1($s); # cannot use preserveEndspace($s) here because it might not print the new line
            skipWhitespace($s);
          }
          elsif (defined($s->{last}) && !isEndspace($s->{last}) && !isPrefix($s->{last})) {
            preserveEndspace($s);
          }
          else {
            skipWhitespace($s);            
          }
        }
      }
      elsif (defined($s->{b}) && $s->{b} eq '*') { # slash-star comment
        $ccFlag = defined($s->{c}) && $s->{c} eq '@'; # test in IE7 shows no space allowed between star and at symbol
        do {
          $ccFlag ? action2($s) : action3($s);
        } until (!defined($s->{b}) || ($s->{a} eq '*' && $s->{b} eq '/'));
        if (defined($s->{b})) { # $s->{a} is asterisk and $s->{b} is foreslash
          if ($ccFlag) {
            action2($s); # the *
            action2($s); # the /
            # inside the conditional comment there may be a missing terminal semi-colon
            preserveEndspace($s);
          }
          else { # the comment is being removed
            action3($s); # the *
            $s->{a} = ' ';  # the /
            collapseWhitespace($s);
            if (defined($s->{last}) && defined($s->{b}) && 
                ((isAlphanum($s->{last}) && (isAlphanum($s->{b})||$s->{b} eq '.')) ||
                 ($s->{last} eq '+' && $s->{b} eq '+') || ($s->{last} eq '-' && $s->{b} eq '-'))) { # for a situation like 5-/**/-2 or a/**/a
              # When entering this block $s->{a} is whitespace.
              # The comment represented whitespace that cannot be removed. Therefore replace the now gone comment with a whitespace.
              action1($s);
            }
            elsif (defined($s->{last}) && !isPrefix($s->{last})) {
              preserveEndspace($s);
            }
            else {
              skipWhitespace($s);
            }
          }
        }
        else {
          die 'unterminated comment, stopped';
        }
      }
      elsif (defined($s->{lastnws}) && ($s->{lastnws} eq ')' || $s->{lastnws} eq ']' ||
                                        $s->{lastnws} eq '.' || isAlphanum($s->{lastnws}))) { # division
        action1($s);
        collapseWhitespace($s);
        # don't want a division to become a slash-slash comment with following conditional comment
        onWhitespaceConditionalComment($s) ? action1($s) : preserveEndspace($s);
      }
      else { # regexp literal
        putLiteral($s);
        collapseWhitespace($s);
        # don't want closing delimiter to become a slash-slash comment with following conditional comment
        onWhitespaceConditionalComment($s) ? action1($s) : preserveEndspace($s);
      }
    }
    elsif ($s->{a} eq '\'' || $s->{a} eq '"' ) { # string literal
      putLiteral($s);
      preserveEndspace($s);
    }
    elsif ($s->{a} eq '+' || $s->{a} eq '-') { # careful with + + and - -
      action1($s);
      collapseWhitespace($s);
      if (defined($s->{a}) && isWhitespace($s->{a})) {
        (defined($s->{b}) && $s->{b} eq $s->{last}) ? action1($s) : preserveEndspace($s);
      }
    }
    elsif (isAlphanum($s->{a})) { # keyword, identifiers, numbers
      action1($s);
      collapseWhitespace($s);
      if (defined($s->{a}) && isWhitespace($s->{a})) {
        # if $s->{b} is '.' could be (12 .toString()) which is property invocation. If space removed becomes decimal point and error.
        (defined($s->{b}) && (isAlphanum($s->{b}) || $s->{b} eq '.')) ? action1($s) : preserveEndspace($s);
      }
    }
    elsif ($s->{a} eq ']' || $s->{a} eq '}' || $s->{a} eq ')') { # no need to be followed by space but maybe needs following new line
      action1($s);
      preserveEndspace($s);
    }
    elsif ($s->{stripDebug} && $s->{a} eq ';' &&
           defined($s->{b}) && $s->{b} eq ';' &&
           defined($s->{c}) && $s->{c} eq ';') {
      action3($s); # delete one of the semi-colons
      $s->{a} = '/'; # replace the other two semi-colons
      $s->{b} = '/'; # so the remainder of line is removed
    }
    else { # anything else just prints and trailing whitespace discarded
      action1($s);
      skipWhitespace($s);
    }
  }
  
  if (!defined($s->{outfile})) {
    return $s->{output};
  }
  
} # minify()

# -----------------------------------------------------------------------------

1;
__END__


=head1 NAME

JavaScript::Minifier - Perl extension for minifying JavaScript code


=head1 SYNOPSIS

To minify a JavaScript file and have the output written directly to another file

  use JavaScript::Minifier qw(minify);
  open(INFILE, 'myScript.js') or die;
  open(OUTFILE, '>myScript-min.js') or die;
  minify(input => *INFILE, outfile => *OUTFILE);
  close(INFILE);
  close(OUTFILE);

To minify a JavaScript string literal. Note that by omitting the outfile parameter a the minified code is returned as a string.

  my minifiedJavaScript = minify(input => 'var x = 2;');
  
To include a copyright comment at the top of the minified code.

  minify(input => 'var x = 2;', copyright => 'BSD License');

To treat ';;;' as '//' so that debugging code can be removed. This is a common JavaScript convention for minification.

  minify(input => 'var x = 2;', stripDebug => 1);

The "input" parameter is manditory. The "output", "copyright", and "stripDebug" parameters are optional and can be used in any combination.


=head1 DESCRIPTION

This module removes unnecessary whitespace from JavaScript code. The primary requirement developing this module is to not break working code: if working JavaScript is in input then working JavaScript is output. It is ok if the input has missing semi-colons, snips like '++ +' or '12 .toString()', for example. Internet Explorer conditional comments are copied to the output but the code inside these comments will not be minified.

The ECMAScript specifications allow for many different whitespace characters: space, horizontal tab, vertical tab, new line, carriage return, form feed, and paragraph separator. This module understands all of these as whitespace except for vertical tab and paragraph separator. These two types of whitespace are not minimized.

For static JavaScript files, it is recommended that you minify during the build stage of web deployment. If you minify on-the-fly then it might be a good idea to cache the minified file. Minifying static files on-the-fly repeatedly is wasteful.


=head2 EXPORT

None by default.

Exportable on demand: minifiy()


=head1 SEE ALSO

This project is developed using an SVN repository. To check out the repository
svn co http://dev.michaux.ca/svn/random/JavaScript-Minifier

This module is inspired by Douglas Crockford's JSMin:
http://www.crockford.com/javascript/jsmin.html

You may also be interested in the CSS::Minifier module also available on CPAN.


=head1 AUTHORS

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>
Eric Herrera, E<lt>herrera@10east.comE<gt>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
