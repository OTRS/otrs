# NOTE: Derived from blib/lib/Mail/Internet.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Internet;

#line 485 "blib/lib/Mail/Internet.pm (autosplit into blib/lib/auto/Mail/Internet/add_signature.al)"
sub add_signature
{
 my $me = shift;
 carp "add_signature depriciated, use ->sign" if $^W;
 $me->sign(File => shift || "$ENV{HOME}/.signature");
}

# end of Mail::Internet::add_signature
1;
