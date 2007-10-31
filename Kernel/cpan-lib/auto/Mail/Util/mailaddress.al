# NOTE: Derived from blib/lib/Mail/Util.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Mail::Util;

#line 235 "blib/lib/Mail/Util.pm (autosplit into blib/lib/auto/Mail/Util/mailaddress.al)"
sub mailaddress {

    ##
    ## Return imediately if already found
    ##

    return $mailaddress
	if(defined $mailaddress);

    ##
    ## Get user name from environment
    ##

    $mailaddress = $ENV{MAILADDRESS};

    unless ($mailaddress || $^O ne 'MacOS') {
	require Mac::InternetConfig;
	Mac::InternetConfig->import();

	$mailaddress = $InternetConfig{kICEmail()};
    }

    $mailaddress ||= $ENV{USER}    ||
                     $ENV{LOGNAME} ||
                     eval {getpwuid($>)} ||
                     "postmaster";

    ##
    ## Add domain if it does not exist
    ##

    $mailaddress .= '@' . maildomain()
	unless($mailaddress =~ /\@/);

    $mailaddress =~ s/(^.*<|>.*$)//g;

    $mailaddress;
}

1;
# end of Mail::Util::mailaddress
