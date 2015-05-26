package HTML::Truncate;

use 5.008;
use strict;
use warnings;
no warnings "uninitialized";

use HTML::TokeParser;
use HTML::Tagset ();
use HTML::Entities ();
use Carp;
use List::Util qw( first );

=head1 NAME

HTML::Truncate - (beta software) truncate HTML by percentage or character count while preserving well-formedness.

=head1 VERSION

0.20

=cut

our $VERSION = "0.20";

=head1 ABSTRACT

When working with text it is common to want to truncate strings to make them fit a desired context. E.g., you might have a menu that is only 100px wide and prefer text doesn't wrap so you'd truncate it around 15-30 characters, depending on preference and typeface size. This is trivial with plain text using L<substr> but with HTML it is somewhat difficult because whitespace has fluid significance and open tags that are not properly closed destroy well-formedness and can wreck an entire layout.

L<HTML::Truncate> attempts to account for those two problems by padding truncation for spacing and entities and closing any tags that remain open at the point of truncation.

=head1 SYNOPSIS

 use strict;
 use HTML::Truncate;

 my $html = '<p><i>We</i> have to test <b>something</b>.</p>';
 my $readmore = '... <a href="/full-article">[readmore]</a>';

 my $html_truncate = HTML::Truncate->new();
 $html_truncate->chars(20);
 $html_truncate->ellipsis($readmore);
 print $html_truncate->truncate($html);

 # or

 use Encode;
 my $ht = HTML::Truncate->new( utf8_mode => 1,
                               chars => 1_000,
                              );
 print Encode::encode_utf8( $ht->truncate($html) );

=head1 XHTML

This module is designed to work with XHTML-style nested tags. More
below.

=head1 WHITESPACE AND ENTITIES

Repeated natural whitespace (i.e., "\s+" and not " &nbsp; ") in HTML
-- with rare exception (pre tags or user defined styles) -- is not
meaningful. Therefore it is normalized when truncating. Entities are
also normalized. The following is only counted 14 chars long.

  \n<p>\nthis     is   &#8216;text&#8217;\n\n</p>
  ^^^^^^^12345----678--9------01234------^^^^^^^^

=head1 METHODS

=over 4

=item B<new>

Can take all the methods as hash style args. "percent" and "chars" are
incompatible so don't use them both. Whichever is set most recently
will erase the other.

 my $ht = HTML::Truncate->new(utf8_mode => 1,
                              chars => 500, # default is 100
                              );

=cut

our %skip = ( head => 1,
              script => 1,
              form => 1,
              iframe => 1,
              object => 1,
              embed => 1,
              title => 1,
              style => 1,
              base => 1,
              link => 1,
              meta => 1,
            );


sub new {
    my $class = shift;

    my $self = bless
    {
        _chars     => 100,
        _percent   => undef,
        _cleanly   => qr/[\s[:punct:]]+\z/,
        _on_space  => undef,
        _utf8_mode => undef,
        _ellipsis  => '&#8230;',
        _raw_html  => '',
        _repair    => undef,
        _skip_tags => \%skip,
    }, $class;

    while ( my ( $k, $v ) = splice(@_, 0, 2) )
    {
        croak "No such method or attribute '$k'" unless exists $self->{"_$k"};
        $self->$k($v);
    }
    return $self;
}

=item B<utf8_mode>

Set/get, true/false. If C<utf8_mode> is set, C<utf8_mode(1)> is also
set in the underlying L<HTML::Parser>, entities will be transformed
with L<decode|HTML::Entity/decode> and the default ellipsis will be a
literal ellipsis and not the default of C<&#8230;>.

=cut

sub utf8_mode {
    my $self = shift;
    if ( @_ )
    {
        $self->{_utf8_mode} = shift;
        return 1; # say we did it, even if setting untrue value
    }
    else
    {
        return $self->{_utf8_mode};
    }
}

=item B<chars>

Set/get. The number of characters remaining after truncation,
B<excluding> the L</ellipsis>.

Entities are counted as single characters. E.g., C<&copy;> is one
character for truncation counts.

Default is "100." Side-effect: clears any L</percent> that has been
set.

=cut

sub chars {
    my ( $self, $chars ) = @_;
    return $self->{_chars} unless defined $chars;
    $chars > 0 or croak "You must truncate to at least 1 character";
    $chars =~ /^(?:[1-9][_\d]*|0)$/
        or croak "Specified chars must be a number";
    $self->{_percent} = undef; # no conflict allowed
    $self->{_chars} = $chars;
}

=item B<percent>

Set/get. A percentage to keep while truncating the rest. For a
document of 1,000 chars, percent('15%') and chars(150) would be
equivalent. The actual amount of character that the percent represents
cannot be known until the given HTML is parsed.

Side-effect: clears any L</chars> that has been set.

=cut

sub percent {
    my ( $self, $percent ) = @_;

    return unless $self->{_percent} or $percent;

    return sprintf("%d%%", 100 * $self->{_percent})
        unless $percent;

    my ( $temp_percent ) = $percent =~ /^(100|[1-9]?[0-9])\%$/;

    $temp_percent and $temp_percent != 0
        or croak "Specified percent is invalid '$percent' -- 1\% - 100\%";

    $self->{_chars} = undef; # no conflict allowed
    $self->{_percent} = $1 / 100;
}

=item B<ellipsis>

Set/get. Ellipsis in this case means --

    The omission of a word or phrase necessary for a complete
    syntactical construction but not necessary for understanding.
                         http://www.answers.com/topic/ellipsis

What it will probably mean in most real applications is "read more."
The default is C<&#8230;> which if the utf8 flag is true will render
as a literal ellipsis, C<chr(8230)>.

The reason the default is C<&#8230;> and not "..." is this is meant
for use in HTML environments, not plain text, and "..." (dot-dot-dot)
is not typographically correct or equivalent to a real horizontal
ellipsis character.

=cut

sub ellipsis {
    my $self = shift;
    if ( @_ )
    {
        $self->{_ellipsis} = shift;
    }
    elsif ( $self->utf8_mode() )
    {
        return HTML::Entities::decode($self->{_ellipsis});
    }
    else
    {
        return $self->{_ellipsis};
    }
}

=item B<truncate>

It returns the truncated XHTML if asked for a return value.

 my $truncated = $ht->truncate($html);

It will truncate the string in place if no return value is expected
(L<wantarray> is not defined).

   $ht->truncate($html);
   print $html;

Also can be called with inline arguments-

   print $ht->truncate( $html,
                        $chars_or_percent,
                        $ellipsis );

No arguments are strictly required. Without HTML to operate upon it
returns undef. The two optional arguments may be preset with the
methods L</chars> (or L</percent>) and L</ellipsis>.

Valid nesting of tags is required (alla XHTML). Therefore some old
HTML habits like E<lt>pE<gt> without a E<lt>/pE<gt> are not supported
and may cause a fatal error. See L</repair> for help with badly formed
HTML.

Certain tags are omitted by default from the truncated output.

=over 4

=item * Skipped tags

These will not be included in truncated output by default.

   <head>...</head> <script>...</script> <form>...</form>
   <iframe></iframe> <title>...</title> <style>...</style>
   <base/> <link/> <meta/>

=item * Tags allowed to self-close

See L<emptyElement|HTML::Tagset/emptyElement> in L<HTML::Tagset>.

=back

=cut

sub _chars_or_percent {
    my ( $self, $which ) = @_;
    if ( $which =~ /\%\z/ )
    {
        $self->percent($which);
    }
    else
    {
        $self->chars($which);
    }
}

sub truncate {
    my $self = shift;
    $self->{_raw_html} = \$_[0];
    shift || return;

    $self->_chars_or_percent(+shift) if @_;
    $self->ellipsis(+shift) if @_;

    my @tag_q;
    my $renew = "";
    my $total = 0;
    my $previous_token;
    my $next_token;

#    my $tmp_ellipsis = $self->ellipsis;
#    $tmp_ellipsis =~ s/<\w[^>]+>//g; # Naive html strip.
#    HTML::Entities::encode($tmp_ellipsis);
    my $chars = $self->{_chars};# + length $tmp_ellipsis;

    my $p = HTML::TokeParser->new( $self->{_raw_html} );
    $p->unbroken_text(1);
    $p->utf8_mode( $self->utf8_mode );

  TOKEN:
    while ( my $token = $p->get_token() )
    {
        my @nexttoken;
        NEXT_TOKEN:
        while ( my $next = $p->get_token() )
        {
            push @nexttoken, $next;
            if ( $next->[0] eq 'S' )
            {
                $next_token = $next;
                last NEXT_TOKEN;
            }
        }
        $p->unget_token(@nexttoken);
        $previous_token = $token if $token->[0] eq 'E';

#        print "   Queue: ", join ":", @tag_q;        print $/;
#        print "Previous: $previous_token->[1]\n";
#        print "      IN: $token->[1]\n";
#        print "    Next: $next_token->[1]\n\n";

        if ( $token->[0] eq 'S' )
        {
            # _callback_for...? 321
            ( my $real_tag = $token->[1] ) =~ s,/\z,,;
            next TOKEN if $self->{_skip_tags}{$real_tag};
            push @tag_q, $token->[1] unless $HTML::Tagset::emptyElement{$real_tag};
            $renew .= $token->[-1];
        }
        elsif ( $token->[0] eq 'E' )
        {
            next TOKEN if $self->{_skip_tags}{$token->[1]};
            my $open  = pop @tag_q;
            my $close = $token->[1];
            unless ( $open eq $close )
            {
                if ( $self->{_repair} )
                {
                    my @unmatched;
                    push @unmatched, $open if $open;
                    while ( my $temp = pop @tag_q )
                    {
                        if ( $temp eq $close )
                        {
                            while ( my $add = shift @unmatched )
                            {
                                $renew .= "</$add>";
                            }
                            $renew .= "</$temp>";
                            next TOKEN;
                        }
                        else
                        {
                            push @unmatched, $temp;
                        }
                    }
                    push @tag_q, reverse @unmatched;
                    next TOKEN;        # silently drop unmatched close tags
                }
                else
                {
                    my $nearby = substr($renew,
                                        length($renew) - 15,
                                        15);
                    croak qq|<$open> closed by </$close> near "$nearby"|;
                }
            }
            $renew .= $token->[-1];
        }
        elsif ( $token->[0] eq 'T' )
        {
            next TOKEN if $token->[2]; # DATA
#            my $txt = HTML::Entities::decode($token->[1]);
# ---
# Patched by OTRS
            # my $txt = $token->[1];
            my $txt = HTML::Entities::decode($token->[1]);
# ---
            my $current_length = 0;
            unless ( first { $_ eq 'pre' } @tag_q ) # We're not somewhere inside a <pre/>
            {
                $txt =~ s/\s+/ /g;

                if ( ! $HTML::Tagset::isPhraseMarkup{$tag_q[-1]} # in flow
                     and
                     ! $HTML::Tagset::isPhraseMarkup{$previous_token->[1]}
                     )
                {
                    $txt =~ s/\A +//;
                }

                if ( ! $HTML::Tagset::isPhraseMarkup{$tag_q[-1]} # in flow
                     and
                     ! $HTML::Tagset::isPhraseMarkup{$next_token->[1]}
                     )
                {
                    $txt =~ s/ +\z//;
                }
                $current_length = _count_visual_chars($txt);
            }
            else
            {
                $current_length = length($txt);
            }

            $total += $current_length;

            if ( $total >= $chars )
            {
                $total -= $current_length;

                my $chars_to_keep = $chars - $total;
                my $keep = "";
                if ( $self->on_space )
                {
                    ( $keep ) = $txt =~ /\A(.{0,$chars_to_keep}\s?)(?=\s|\z)/;
                    $keep =~ s/\s+\z//;
                }
                else
                {
                    $keep = substr($txt, 0, $chars_to_keep);
# ---
# Patched by OTRS

                    $keep = $self->utf8_mode ? $keep : HTML::Entities::encode($keep);
# ---
                }

                if ( my $cleaner = $self->cleanly )
                {
                    $keep =~ s/$cleaner//;
                }

                if ( $keep )
                {
#                    $renew .= $self->utf8_mode ?
#                        $keep : HTML::Entities::encode($keep);
                    $renew .= $keep;
                }

                $renew .= $self->ellipsis();
                last TOKEN;
            }
            else
            {
                $renew .= $token->[1];
            }
        }
    } #  TOKEN block ends

    $renew .= join('', map {"</$_>"} reverse @tag_q);

    if ( defined wantarray )
    {
        return $renew;
    }
    else
    {
        ${$self->{_raw_html}} = $renew;
    }
}

=item B<add_skip_tags( qw( tag list ) )>

Put one or more new tags into the list of those to be omitted from
truncated output. An example of when you might like to use this is if
you're thumb-nailing articles and they start with C<< <h1>title</h1> >>
or such before the article body. The heading level would be absurd
with a list of excerpts so you could drop it completely this way--

 $ht->add_skip_tags( 'h1' );

=cut

sub add_skip_tags {
    my $self = shift;
    for ( @_ )
    {
        croak "Args to add_skip_tags must be scalar tag names, not references"
            if ref $_;
        $self->{_skip_tags}{$_} = 1;
    }
}

=item B<dont_skip_tags( qw( tag list ) )>

Takes tags out of the current list to be omitted from truncated output.

=cut

sub dont_skip_tags {
    my $self = shift;
    for ( @_ )
    {
        croak "Args to dont_skip_tags must be scalar tag names, not references"
            if ref $_;
        carp "$_ was not set to be skipped"
            unless delete $self->{_skip_tags}{$_};
    }
}

=item B<repair>

Set/get, true/false. If true, will attempt to repair unclosed HTML
tags by adding close-tags as late as possible (eg. C<<
<i><b>foobar</i> >> becomes C<< <i><b>foobar</b></i> >>). Unmatched
close tags are dropped (C<< foobar</b> >> becomes C<< foobar >>).

=cut

sub repair {
    my $self = shift;
    if ( @_ )
    {
        $self->{_repair} = shift;
        return 1; # say we did it, even if untrue value
    }
    else
    {
        return $self->{_repair};
    }
}

sub _load_chars_from_percent {
    my $self = shift;
    my $p = HTML::TokeParser->new( $self->{_raw_html} );
    my $txt_length = 0;

  CHARS:
    while ( my $token = $p->get_token )
    {
    # don't check padding b/c we're going by a document average
        next unless $token->[0] eq 'T' and not $token->[2]; # Not data.
        $txt_length += _count_visual_chars( $token->[1] );
    }
    $self->chars( int( $txt_length * $self->{_percent} ) );
}

sub _count_visual_chars { # private function
    my $to_count = HTML::Entities::decode_entities(+shift);
    $to_count =~ s/\s\s+/ /g;
    $to_count =~ s/[^[:print:]]+//g;
#    my $count = () =
#        $to_count =~
#        /\&\#\d+;|\&[[:alpha:]]{2,5};|\S|\s+/g;
#   return $count;
    return length($to_count);
}

# Need to put hooks for these or not? 321
#sub _default_image_callback {
#    sub {
#        '[image]'
#    }
#}

=item B<on_space>

This will make the truncation back up to the first space it finds so
it doesn't truncate in the the middle of a word. L</on_space> runs
before L</cleanly> if both are set.

=cut

sub on_space {
    my $self = shift;
    if ( @_ )
    {
        $self->{_on_space} = shift;
        return 1; # say we did it, even if setting untrue value
    }
    else
    {
        return $self->{_on_space};
    }
}


=item B<cleanly>

Set/get -- a regular expression. This is on by default and the default
cleaning regular expression is C<cleanly(qr/[\s[:punct:]]+\z/)>. It
will make the truncation strip any trailing spacing and punctuation so
you don't get things like "The End...." or "What? ..." You can cancel
it with C<$ht-E<gt>cleanly(undef)> or provide your own regular
expression.

=cut

sub cleanly {
    my $self = shift;
    if ( @_ )
    {
        $self->{_cleanly} = shift;
        return 1; # say we did it, even if setting untrue value
    }
    else
    {
        return $self->{_cleanly};
    }
}

=back

=head1 COOKBOOK (well, a recipe)

=head2 Template Toolkit filter

For excerpting HTML in your Templates. Note the L</add_skip_tags> which
is set to drop any images from the truncated output.

 use Template;
 use HTML::Truncate;

 my %config =
    (
     FILTERS => {
         truncate_html => [ \&truncate_html_filter_factory, 1 ],
     },
     );

 my $tt = Template->new(\%config) or die $Template::ERROR;

 # ... etc ...

 sub truncate_html_filter_factory {
     my ( $context, $len, $ellipsis ) = @_;
     $len = 32 unless $len;
     $ellipsis = chr(8230) unless defined $ellipsis;
     my $ht = HTML::Truncate->new();
     $ht->add_skip_tags(qw( img ));
     return sub {
         my $html = shift || return '';
         return $ht->truncate( $html, $len, $ellipsis );
     }
 }

Then in your templates you can do things like this:

 [% FOR item IN search_results %]
   <div class="searchResult">
     <a href="[% item.uri %]">[% item.title %]</a><br />
     [% item.body | truncate_html(200) %]
   </div>
 [% END %]

See also L<Template::Filters>.

=head1 AUTHOR

Ashley Pond V, C<< <ashley@cpan.org> >>.

=head1 LIMITATIONS

There may be places where this will break down right now. I'll pad out possible edge cases as I find them or they are sent to me via the CPAN bug ticket system.

=head2 This is not an HTML filter

Although this happens to do some crude HTML filtering to achieve its end, it is not a fully featured filter. If you are looking for one, check out L<HTML::Scrubber> and L<HTML::Sanitizer>.

=head1 BUGS, FEEDBACK, PATCHES

Please report any bugs or feature requests to
C<bug-html-truncate@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-Truncate>. I
will get the ticket, and then you'll automatically be notified of
progress as I make changes.

=head2 TO DO

Write a couple more tests (percent and skip stuff) then take out beta notice. Try to make the 5.6 stuff work without decode...? Try a C<drop_tags> method?

Write an L<XML::LibXML> based version to load when possible...? Or make that part of L<XHTML::Util>?

=head1 THANKS TO

Kevin Riggle for the L</repair> functionality; patch, Pod, and tests.

Lorenzo Iannuzzi for the L</on_space> functionality.

=head1 SEE ALSO

L<HTML::Entities>, L<HTML::TokeParser>, the "truncate" filter in L<Template>, and L<Text::Truncate>.

L<HTML::Scrubber> and L<HTML::Sanitizer>.

=head1 COPYRIGHT & LICENSE

Copyright (E<copy>) 2005-2009 Ashley Pond V.

This program is free software; you can redistribute it or modify it or both under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

Because this software is licensed free of charge, there is no warranty
for the software, to the extent permitted by applicable law. Except
when otherwise stated in writing the copyright holders or other
parties provide the software "as is" without warranty of any kind,
either expressed or implied, including, but not limited to, the
implied warranties of merchantability and fitness for a particular
purpose. The entire risk as to the quality and performance of the
software is with you. Should the software prove defective, you assume
the cost of all necessary servicing, repair, or correction.

In no event unless required by applicable law or agreed to in writing
will any copyright holder, or any other party who may modify and/or
redistribute the software as permitted by the above licence, be liable
to you for damages, including any general, special, incidental, or
consequential damages arising out of the use or inability to use the
software (including but not limited to loss of data or data being
rendered inaccurate or losses sustained by you or third parties or a
failure of the software to operate with any other software), even if
such holder or other party has been advised of the possibility of such
damages.

=cut

1;


