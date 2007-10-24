# NOTE: Derived from blib/lib/Mail/Internet.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Internet;

#line 561 "blib/lib/Mail/Internet.pm (autosplit into blib/lib/auto/Mail/Internet/smtpsend.al)"
sub smtpsend;

use Carp;
use Mail::Util qw(mailaddress);
use Mail::Address;
use Net::Domain qw(hostname);
use Net::SMTP;
use strict;

 sub smtpsend 
{
    my $src  = shift;
    my %opt = @_;
    my $host = $opt{Host};
    my $envelope = $opt{MailFrom} || mailaddress();
    my $noquit = 0;
    my $smtp;
    my @hello = defined $opt{Hello} ? (Hello => $opt{Hello}) : ();

    push(@hello, 'Port', $opt{'Port'})
	if exists $opt{'Port'};

    push(@hello, 'Debug', $opt{'Debug'})
	if exists $opt{'Debug'};

    unless(defined($host)) {
	local $SIG{__DIE__};
	my @hosts = qw(mailhost localhost);
	unshift(@hosts, split(/:/, $ENV{SMTPHOSTS})) if(defined $ENV{SMTPHOSTS});

	foreach $host (@hosts) {
	    $smtp = eval { Net::SMTP->new($host, @hello) };
	    last if(defined $smtp);
	}
    }
    elsif(ref($host) && UNIVERSAL::isa($host,'Net::SMTP')) {
	$smtp = $host;
	$noquit = 1;
    }
    else {
	local $SIG{__DIE__};
	$smtp = eval { Net::SMTP->new($host, @hello) };
    }

    return ()
	unless(defined $smtp);

    my $hdr = $src->head->dup;

    _prephdr($hdr);

    # Who is it to

    my @rcpt = map { ref($_) ? @$_ : $_ } grep { defined } @opt{'To','Cc','Bcc'};
    @rcpt = map { $hdr->get($_) } qw(To Cc Bcc)
	unless @rcpt;
    my @addr = map($_->address, Mail::Address->parse(@rcpt));

    return ()
	unless(@addr);

    $hdr->delete('Bcc'); # Remove blind Cc's

    # Send it

    my $ok = $smtp->mail( $envelope ) &&
		$smtp->to(@addr) &&
		$smtp->data(join("", @{$hdr->header},"\n",@{$src->body}));

    $smtp->quit
	unless $noquit;

    $ok ? @addr : ();
}

# end of Mail::Internet::smtpsend
1;
