# NOTE: Derived from blib/lib/Mail/Util.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Util;

#line 131 "blib/lib/Mail/Util.pm (autosplit into blib/lib/auto/Mail/Util/maildomain.al)"
sub maildomain {

    ##
    ## return imediately if already found
    ##

    return $domain
	if(defined $domain);

    ##
    ## Get mail domain from environment
    ##

    $domain = $ENV{MAILDOMAIN};

    return $domain
       if(defined $domain);

    ##
    ## Try sendmail config file if exists
    ##

    local *CF;
    local $_;
    my @sendmailcf = qw(/etc
			/etc/sendmail
			/etc/ucblib
			/etc/mail
			/usr/lib
			/var/adm/sendmail);

    my $config = (grep(-r, map("$_/sendmail.cf", @sendmailcf)))[0];

    if(defined $config && open(CF,$config)) {
	my %var;
	while(<CF>) {
	    if(my ($v, $arg) = /^D([a-zA-Z])([\w.\$\-]+)/) {
		$arg =~ s/\$([a-zA-Z])/exists $var{$1} ? $var{$1} : '$'.$1/eg;
		$var{$v} = $arg;
	    }
	}
	close(CF);
	$domain = $var{j} if defined $var{j};
	$domain = $var{M} if defined $var{M};

        $domain = $1
            if($domain && $domain =~ m/([A-Za-z0-9](?:[\.\-A-Za-z0-9]+))/ );

	return $domain
	    if(defined $domain && $domain !~ /\$/);
    }

    ##
    ## Try smail config file if exists
    ##

    if(open(CF,"/usr/lib/smail/config")) {
	while(<CF>) {
	    if(/\A\s*hostnames?\s*=\s*(\S+)/) {
		$domain = (split(/:/,$1))[0];
		last;
	    }
	}
	close(CF);

	return $domain
	    if(defined $domain);
    }

    ##
    ## Try a SMTP connection to 'mailhost'
    ##

    if(eval { require Net::SMTP }) {
	my $host;

	foreach $host (qw(mailhost localhost)) {
	    my $smtp = eval { Net::SMTP->new($host) };

	    if(defined $smtp) {
		$domain = $smtp->domain;
		$smtp->quit;
		last;
	    }
	}
    }

    ##
    ## Use internet(DNS) domain name, if it can be found
    ##

    unless(defined $domain) {
	if(eval { require Net::Domain } ) {
	    $domain = Net::Domain::domainname();
	}
    }

    $domain = "localhost"
	unless(defined $domain);

    return $domain;
}

# end of Mail::Util::maildomain
1;
