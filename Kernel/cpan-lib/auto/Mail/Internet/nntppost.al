# NOTE: Derived from blib/lib/Mail/Internet.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Internet;

#line 658 "blib/lib/Mail/Internet.pm (autosplit into blib/lib/auto/Mail/Internet/nntppost.al)"
sub nntppost;

use Mail::Util qw(mailaddress);
use Net::NNTP;
use strict;

 sub nntppost
{
    my $mail = shift;
    my %opt = @_;

    my $groups = $mail->get('Newsgroups') || "";
    my @groups = split(/[\s,]+/,$groups);

    return ()
	unless @groups;

    my $hdr = $mail->head->dup;

    _prephdr($hdr);

    # Remove these incase the NNTP host decides to mail as well as me
    $hdr->delete(qw(To Cc Bcc)); 

    my $news;
    my $noquit = 0;
    my $host = $opt{Host};

    if(ref($host) && UNIVERSAL::isa($host,'Net::NNTP')) {
	$news = $host;
	$noquit = 1;
    }
    else {
	my @opt = ();

	push(@opt, $opt{'Host'});

	push(@opt, 'Port', $opt{'Port'})
	    if exists $opt{'Port'};

	push(@opt, 'Debug', $opt{'Debug'})
	    if exists $opt{'Debug'};

	$news = new Net::NNTP(@opt)
	    or return ();
    }

    $news->post(@{$hdr->header},"\n",@{$mail->body});

    my $code = $news->code;

    $news->quit
	unless $noquit;

    return 240 == $code ? @groups : ();
}

# end of Mail::Internet::nntppost
1;
