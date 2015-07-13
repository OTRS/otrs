# ======================================================================
#
# Copyright (C) 2000-2007 Paul Kulchenko (paulclinger@yahoo.com)
# Copyright (C) 2008 Martin Kutter (martin.kutter@fen-net.de)
# XML::Parser::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# ======================================================================

package XML::Parser::Lite;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.721';

sub new {
    my $class = shift;

    return $class if ref $class;
    my $self = bless {} => $class;

    my %parameters = @_;
    $self->setHandlers(); # clear first
    $self->setHandlers(%{$parameters{Handlers} || {}});

    return $self;
}

sub setHandlers {
    my $self = shift;

    # allow symbolic refs, avoid "subroutine redefined" warnings
    no strict 'refs';
    no warnings qw(redefine);
    # clear all handlers if called without parameters
    if (not @_) {
        for (qw(Start End Char Final Init Comment Doctype XMLDecl)) {
            *$_ = sub {}
        }
    }

    # we could use each here, too...
    while (@_) {
        my($name, $func) = splice(@_, 0, 2);
        *$name = defined $func
            ? $func
            : sub {}
    }
    return $self;
}

sub _regexp {
    my $patch = shift || '';
    my $package = __PACKAGE__;

    # This parser is based on "shallow parser" http://www.cs.sfu.ca/~cameron/REX.html

    # Robert D. Cameron "REX: XML Shallow Parsing with Regular Expressions",
    # Technical Report TR 1998-17, School of Computing Science, Simon Fraser University, November, 1998.
    # Copyright (c) 1998, Robert D. Cameron.
    # The following code may be freely used and distributed provided that
    # this copyright and citation notice remains intact and that modifications
    # or additions are clearly identified.

    # Modifications may be tracked on SOAP::Lite's SVN at
    # https://soaplite.svn.sourceforge.net/svnroot/soaplite/
    #
    use re 'eval';
    my $TextSE = "[^<]+";
    my $UntilHyphen = "[^-]*-";
    my $Until2Hyphens = "([^-]*)-(?:[^-]$[^-]*-)*-";
    #my $CommentCE = "$Until2Hyphens(?{${package}::comment(\$2)})>?";
    my $CommentCE = "(.+)--(?{${package}::comment(\$2)})>?";
#    my $Until2Hyphens = "$UntilHyphen(?:[^-]$UntilHyphen)*-";
#    my $CommentCE = "$Until2Hyphens>?";
    my $UntilRSBs = "[^\\]]*](?:[^\\]]+])*]+";
    my $CDATA_CE = "$UntilRSBs(?:[^\\]>]$UntilRSBs)*>";
    my $S = "[ \\n\\t\\r]+";
    my $NameStrt = "[A-Za-z_:]|[^\\x00-\\x7F]";
    my $NameChar = "[A-Za-z0-9_:.-]|[^\\x00-\\x7F]";
    my $Name = "(?:$NameStrt)(?:$NameChar)*";
    my $QuoteSE = "\"[^\"]*\"|'[^']*'";
    my $DT_IdentSE = "$Name(?:$S(?:$Name|$QuoteSE))*";
#    my $DT_IdentSE = "$S$Name(?:$S(?:$Name|$QuoteSE))*";
    my $MarkupDeclCE = "(?:[^\\]\"'><]+|$QuoteSE)*>";
    my $S1 = "[\\n\\r\\t ]";
    my $UntilQMs = "[^?]*\\?";
    my $PI_Tail = "\\?>|$S1$UntilQMs(?:[^>?]$UntilQMs)*";
    my $DT_ItemSE = "<(?:!(?:--$Until2Hyphens>|[^-]$MarkupDeclCE)|\\?$Name(?:$PI_Tail>))|%$Name;|$S";
    my $DocTypeCE = "$S($DT_IdentSE(?:$S)?(?:\\[(?:$DT_ItemSE)*](?:$S)?)?)>(?{${package}::_doctype(\$3)})";
#    my $PI_Tail = "\\?>|$S1$UntilQMs(?:[^>?]$UntilQMs)*>";
#    my $DT_ItemSE = "<(?:!(?:--$Until2Hyphens>|[^-]$MarkupDeclCE)|\\?$Name(?:$PI_Tail))|%$Name;|$S";
#    my $DocTypeCE = "$DT_IdentSE(?:$S)?(?:\\[(?:$DT_ItemSE)*](?:$S)?)?>?";
    my $DeclCE = "--(?:$CommentCE)?|\\[CDATA\\[(?:$CDATA_CE)?|DOCTYPE(?:$DocTypeCE)?";
#    my $PI_CE = "$Name(?:$PI_Tail)?";
    my $PI_CE = "($Name(?:$PI_Tail))>(?{${package}::_xmldecl(\$5)})";
    # these expressions were modified for backtracking and events
#    my $EndTagCE = "($Name)(?{${package}::_end(\$2)})(?:$S)?>";
    my $EndTagCE = "($Name)(?{${package}::_end(\$6)})(?:$S)?>";
    my $AttValSE = "\"([^<\"]*)\"|'([^<']*)'";
#    my $ElemTagCE = "($Name)(?:$S($Name)(?:$S)?=(?:$S)?(?:$AttValSE)(?{[\@{\$^R||[]},\$4=>defined\$5?\$5:\$6]}))*(?:$S)?(/)?>(?{${package}::_start( \$3,\@{\$^R||[]})})(?{\${7} and ${package}::_end(\$3)})";
    my $ElemTagCE = "($Name)"
        . "(?:$S($Name)(?:$S)?=(?:$S)?(?:$AttValSE)"
        . "(?{[\@{\$^R||[]},\$8=>defined\$9?\$9:\$10]}))*(?:$S)?(/)?>"
        . "(?{${package}::_start(\$7,\@{\$^R||[]})})(?{\$11 and ${package}::_end(\$7)})";

    my $MarkupSPE = "<(?:!(?:$DeclCE)?|\\?(?:$PI_CE)?|/(?:$EndTagCE)?|(?:$ElemTagCE)?)";

    # Next expression is under "black magic".
    # Ideally it should be '($TextSE)(?{${package}::char(\$1)})|$MarkupSPE',
    # but it doesn't work under Perl 5.005 and only magic with
    # (?:....)?? solved the problem.
    # I would appreciate if someone let me know what is the right thing to do
    # and what's the reason for all this magic.
    # Seems like a problem related to (?:....)? rather than to ?{} feature.
    # Tests are in t/31-xmlparserlite.t if you decide to play with it.
    #"(?{[]})(?:($TextSE)(?{${package}::_char(\$1)}))$patch|$MarkupSPE";
    "(?:($TextSE)(?{${package}::_char(\$1)}))$patch|$MarkupSPE";
}

setHandlers();

# Try 5.6 and 5.10 regex first
my $REGEXP = _regexp('??');

sub _parse_re {
    use re "eval";
    undef $^R;
    no strict 'refs';
    1 while $_[0] =~ m{$REGEXP}go
};

# fixup regex if it does not work...
{
    if (not eval { _parse_re('<soap:foo xmlns:soap="foo">bar</soap:foo>'); 1; } ) {
        $REGEXP = _regexp();
        local $^W;
        *_parse_re = sub {
                use re "eval";
                undef $^R;
                1 while $_[0] =~ m{$REGEXP}go
            };
    }
}

sub parse {
    _init();
    _parse_re($_[1]);
    _final();
}

my(@stack, $level);

sub _init {
    @stack = ();
    $level = 0;
    Init(__PACKAGE__, @_);
}

sub _final {
    die "not properly closed tag '$stack[-1]'\n" if @stack;
    die "no element found\n" unless $level;
    Final(__PACKAGE__, @_)
}

sub _start {
    die "multiple roots, wrong element '$_[0]'\n" if $level++ && !@stack;
    push(@stack, $_[0]);
    my $r=Start(__PACKAGE__, @_);
    return ref($r) eq 'ARRAY' ? $r : undef;
}

sub _char {
    Char(__PACKAGE__, $_[0]), return if @stack;

    # check for junk before or after element
    # can't use split or regexp due to limitations in ?{} implementation,
    # will iterate with loop, but we'll do it no more than two times, so
    # it shouldn't affect performance
    for (my $i=0; $i < length $_[0]; $i++) {
        die "junk '$_[0]' @{[$level ? 'after' : 'before']} XML element\n"
        if index("\n\r\t ", substr($_[0],$i,1)) < 0; # or should '< $[' be there
    }
}

sub _end {
    no warnings qw(uninitialized);
    pop(@stack) eq $_[0] or die "mismatched tag '$_[0]'\n";
    my $r=End(__PACKAGE__, $_[0]);
    return ref($r) eq 'ARRAY' ? $r : undef;
}

sub comment {
    my $r=Comment(__PACKAGE__, $_[0]);
    return ref($r) eq 'ARRAY' ? $r : undef;
}

sub end {
    pop(@stack) eq $_[0] or die "mismatched tag '$_[0]'\n";
    my $r=End(__PACKAGE__, $_[0]);
    return ref($r) eq 'ARRAY' ? $r : undef;
}

sub _doctype {
    my $r=Doctype(__PACKAGE__, $_[0]);
    return ref($r) eq 'ARRAY' ? $r : undef;
}

sub _xmldecl {
    XMLDecl(__PACKAGE__, $_[0]);
}



# ======================================================================
1;

__END__

=head1 NAME

XML::Parser::Lite - Lightweight pure-perl XML Parser (based on regexps)

=head1 SYNOPSIS

  use XML::Parser::Lite;

  $p1 = new XML::Parser::Lite;
  $p1->setHandlers(
    Start => sub { shift; print "start: @_\n" },
    Char => sub { shift; print "char: @_\n" },
    End => sub { shift; print "end: @_\n" },
  );
  $p1->parse('<foo id="me">Hello World!</foo>');

  $p2 = new XML::Parser::Lite
    Handlers => {
      Start => sub { shift; print "start: @_\n" },
      Char => sub { shift; print "char: @_\n" },
      End => sub { shift; print "end: @_\n" },
    }
  ;
  $p2->parse('<foo id="me">Hello <bar>cruel</bar> World!</foo>');

=head1 DESCRIPTION

This module implements an XML parser with a interface similar to
L<XML::Parser>. Though not all callbacks are supported, you should be able to
use it in the same way you use XML::Parser. Due to using experimental regexp
features it'll work only on Perl 5.6 and above and may behave differently on
different platforms.

Note that you cannot use regular expressions or split in callbacks. This is
due to a limitation of perl's regular expression implementation (which is
not re-entrant).

=head1 SUBROUTINES/METHODS

=head2 new

Constructor.

The new() method returns the object called on when called as object method.
This behaviour was inherited from L<SOAP::Lite>,
which XML::Parser::Lite was split out from.
This means that the following effectively is
a no-op if $obj is a object:

 $obj = $obj->new();

New accepts a single named parameter, C<Handlers> with a hash ref as value:

 my $parser = XML::Parser::Lite->new(
    Handlers => {
        Start => sub { shift; print "start: @_\n" },
        Char => sub { shift; print "char: @_\n" },
        End => sub { shift; print "end: @_\n" },
    }
 );

The handlers given will be passed to setHandlers.

=head2 setHandlers

Sets (or resets) the parsing handlers. Accepts a hash with the handler names
and handler code references as parameters. Passing C<undef> instead of a
code reference replaces the handler by a no-op.

The following handlers can be set:

 Init
 Start
 Char
 End
 Final

All other handlers are ignored.

Calling setHandlers without parameters resets all handlers to no-ops.

=head2 parse

Parses the XML given. In contrast to L<XML::Parser|XML::Parser>'s parse
method, parse() only parses strings.

=head1 Handler methods

=head2 Init

Called before parsing starts. You should perform any necessary initializations
in Init.

=head2 Start

Called at the start of each XML node. See L<XML::Parser> for details.

=head2 Char

Called for each character sequence. May be called multiple times for the
characters contained in an XML node (even for every single character).
Your implementation has to make sure that it captures all characters.

=head2 End

Called at the end of each XML node. See L<XML::Parser> for details

=head2 Comment

See L<XML::Parser> for details

=head2 XMLDecl

See L<XML::Parser> for details

=head2 Doctype

See L<XML::Parser> for details

=head2 Final

Called at the end of the parsing process. You should perform any necessary
cleanup here.

=head1 SEE ALSO

L<XML::Parser> - a full-blown XML Parser, on which XML::Parser::Lite is based.
Requires a C compiler and the I<expat> XML parser.

L<XML::Parser::LiteCopy> - a fork in L<XML::Parser::Lite::Tree>.

L<YAX> - another pure-perl module for XML parsing.

L<XML::Parser::REX> - another module that parses XML with regular expressions.

=head1 COPYRIGHT

Copyright (C) 2000-2007 Paul Kulchenko. All rights reserved.

Copyright (C) 2008- Martin Kutter. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

This parser is based on "shallow parser"
L<http://www.cs.sfu.ca/~cameron/REX.html>
Copyright (c) 1998, Robert D. Cameron.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

Martin Kutter (martin.kutter@fen-net.de)

Additional handlers supplied by Adam Leggett.

=cut




