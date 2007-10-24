# NOTE: Derived from blib/lib/Mail/Internet.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Internet;

#line 492 "blib/lib/Mail/Internet.pm (autosplit into blib/lib/auto/Mail/Internet/sign.al)"
sub sign
{
 my $me = shift;
 my %arg = @_;
 my $sig;
 my @sig;

 if($sig = delete $arg{File})
  {
   local *SIG;

   if(open(SIG,$sig))
    {
     local $_;
     while(<SIG>) { last unless /\A(--)?\s*\Z/; }

     @sig = ($_,<SIG>,"\n");

     close(SIG);
    }
  }
 elsif($sig = delete $arg{Signature})
  {
   @sig = ref($sig) ? @$sig : split(/\n/, $sig);
  }

 if(@sig)
  {
   $me->remove_sig;
   map(s/\n?\Z/\n/,@sig);
   push(@{$me->body}, "-- \n",@sig);
  }
}

# end of Mail::Internet::sign
1;
