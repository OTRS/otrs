# NOTE: Derived from blib/lib/Mail/Internet.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Internet;

#line 725 "blib/lib/Mail/Internet.pm (autosplit into blib/lib/auto/Mail/Internet/unescape_from.al)"
sub unescape_from
{
 my $me = shift;

 my $body = $me->body;
 local $_;

 scalar grep { s/\A>(>*From) /$1 /o } @$body;
}

1; # keep require happy





1;
# end of Mail::Internet::unescape_from
