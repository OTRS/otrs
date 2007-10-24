# NOTE: Derived from blib/lib/Mail/Internet.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Internet;

#line 321 "blib/lib/Mail/Internet.pm (autosplit into blib/lib/auto/Mail/Internet/reply.al)"
sub reply;


use Mail::Address;

 sub reply
{
 my $me = shift;
 my %arg = @_;
 my $pkg = ref $me;
 my @reply = ();

 local *MAILHDR;
 if(open(MAILHDR,"$ENV{HOME}/.mailhdr")) 
  {
   # User has defined a mail header template
   @reply = <MAILHDR>;
   close(MAILHDR);
  }

 my $reply = $pkg->new(\@reply);

 my($to,$cc,$name,$body,$id);

 # The Subject line

 my $subject = $me->get('Subject') || "";

 $subject = "Re: " . $subject if($subject =~ /\S+/ && $subject !~ /Re:/i);

 $reply->replace('Subject',$subject);

 # Locate who we are sending to
 $to = $me->get('Reply-To')
       || $me->get('From')
       || $me->get('Return-Path')
       || "";

 # Mail::Address->parse returns a list of refs to a 2 element array
 my $sender = (Mail::Address->parse($to))[0];

 $name = $sender->name;
 $id = $sender->address;

 unless(defined $name)
  {
   my $fr = $me->get('From');

   $fr = (Mail::Address->parse($fr))[0] if(defined $fr);
   $name = $fr->name if(defined $fr);
  }

 my $indent = $arg{Indent} || ">";

 if($indent =~ /%/) 
  {
   my %hash = ( '%' => '%');
   my @name = grep(do { length > 0 }, split(/[\n\s]+/,$name || ""));
   my @tmp;

   @name = "" unless(@name);

   $hash{f} = $name[0];
   $hash{F} = $#name ? substr($hash{f},0,1) : $hash{f};

   $hash{l} = $#name ? $name[$#name] : "";
   $hash{L} = substr($hash{l},0,1) || "";

   $hash{n} = $name || "";
   $hash{I} = join("",grep($_ = substr($_,0,1), @tmp = @name));

   $indent =~ s/%(.)/defined $hash{$1} ? $hash{$1} : $1/eg;
  }

 $reply->replace('To', $id);

 # Find addresses not to include
 my %nocc = ();
 my $mailaddresses = $ENV{MAILADDRESSES} || "";
 my $addr;

 $nocc{lc $id} = 1;

 foreach $addr (Mail::Address->parse($reply->get('Bcc'),$mailaddresses)) 
  {
   my $lc = lc $addr->address;
   $nocc{$lc} = 1;
  }

 if($arg{ReplyAll} || 0)
  {
   # Who shall we copy this to
   my %cc = ();

   foreach $addr (Mail::Address->parse($me->get('To'),$me->get('Cc'))) 
    {
     my $lc = lc $addr->address;
     $cc{$lc} = $addr->format unless(defined $nocc{$lc});
    }
   $cc = join(', ',values %cc);

   $reply->replace('Cc', $cc);
  }

 # References
 my $refs = $me->get('References') || "";
 my $mid = $me->get('Message-Id');

 $refs .= " " . $mid if(defined $mid);
 $reply->replace('References',$refs);

 # In-Reply-To
 my $date = $me->get('Date');
 my $inreply = "";

 if(defined $mid)
  {
   $inreply  = $mid;
   $inreply .= " from " . $name if(defined $name);
   $inreply .= " on " . $date if(defined $date);
  }
 elsif(defined $name)
  {
   $inreply = $name . "'s message";
   $inreply .= "of " . $date if(defined $date);
  }

 $reply->replace('In-Reply-To', $inreply);

 # Quote the body
 $body  = $reply->body;

 @$body = @{$me->body};		# copy body
 $reply->remove_sig;		# remove signature, if any
 $reply->tidy_body;		# tidy up
 map { s/\A/$indent/ } @$body;	# indent

 # Add references
 unshift @{$body}, (defined $name ? $name . " " : "") . "<$id> writes:\n";

 if(defined $arg{Keep} && 'ARRAY' eq ref($arg{Keep})) 
  {
   # Copy lines from the original
   my $keep;

   foreach $keep (@{$arg{Keep}}) 
    {
     my $ln = $me->get($keep);
     $reply->replace($keep,$ln) if(defined $ln);
    }
  }

 if(defined $arg{Exclude} && 'ARRAY' eq ref($arg{Exclude}))
  {
   # Exclude lines
   $reply->delete(@{$arg{Exclude}});
  }

 # remove empty header lins
 $reply->head->cleanup;

 $reply;
}

# end of Mail::Internet::reply
1;
