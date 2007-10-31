# NOTE: Derived from blib/lib/Mail/Internet.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Internet;

#line 715 "blib/lib/Mail/Internet.pm (autosplit into blib/lib/auto/Mail/Internet/escape_from.al)"
sub escape_from
{
 my $me = shift;

 my $body = $me->body;
 local $_;

 scalar grep { s/\A(>*From) />$1 /o } @$body;
}

# end of Mail::Internet::escape_from
1;
