#
# Crypt::PasswdMD5: Module to provide an interoperable crypt() 
#	function for modern Unix O/S. This is based on the code for
#
# /usr/src/libcrypt/crypt.c
#
# on a FreeBSD 2.2.5-RELEASE system, which included the following
# notice.
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <phk@login.dknet.dk> wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.   Poul-Henning Kamp
# ----------------------------------------------------------------------------
#
# $Id: PasswdMD5.pm,v 1.1 2006-08-27 21:21:24 martin Exp $
#
################

package Crypt::PasswdMD5;
$VERSION='1.3';
require 5.000;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(unix_md5_crypt apache_md5_crypt);

=head1 NAME

Crypt::PasswdMD5 - Provides interoperable MD5-based crypt() functions

=head1 SYNOPSIS

    use Crypt::PasswdMD5;

    $cryptedpassword = unix_md5_crypt($password, $salt);
    $apachepassword = apache_md5_crypt($password, $salt);


=head1 DESCRIPTION

the C<unix_md5_crypt()> provides a crypt()-compatible interface to the
rather new MD5-based crypt() function found in modern operating systems.
It's based on the implementation found on FreeBSD 2.2.[56]-RELEASE and
contains the following license in it:

 "THE BEER-WARE LICENSE" (Revision 42):
 <phk@login.dknet.dk> wrote this file.  As long as you retain this notice you
 can do whatever you want with this stuff. If we meet some day, and you think
 this stuff is worth it, you can buy me a beer in return.   Poul-Henning Kamp

C<apache_md5_crypt()> provides a function compatible with Apache's
C<.htpasswd> files. This was contributed by Bryan Hart <bryan@eai.com>.
As suggested by William A. Rowe, Jr. <wrowe@lnd.com>, it is 
exported by default.

For both functions, if a salt value is not supplied, a random salt will be
generated.  Contributed by John Peacock <jpeacock@cpan.org>.

=cut

$Magic = q/$1$/;			# Magic string
$itoa64 = "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

use Digest::MD5;

sub to64 {
    my ($v, $n) = @_;
    my $ret = '';
    while (--$n >= 0) {
	$ret .= substr($itoa64, $v & 0x3f, 1);
	$v >>= 6;
    }
    $ret;
}

sub apache_md5_crypt {
	# change the Magic string to match the one used by Apache
	local $Magic = q/$apr1$/;
	
	unix_md5_crypt(@_);
}

sub unix_md5_crypt {
    my($pw, $salt) = @_;
    my $passwd;

    if ( defined $salt ) {

	$salt =~ s/^\Q$Magic//;	# Take care of the magic string if
				# if present.

	$salt =~ s/^(.*)\$.*$/$1/;	# Salt can have up to 8 chars...
	$salt = substr($salt, 0, 8);
    }
    else {
	$salt = '';	 	# in case no salt was proffered
	$salt .= substr($itoa64,int(rand(64)+1),1)
			while length($salt) < 8;
    }

    $ctx = new Digest::MD5;		# Here we start the calculation
    $ctx->add($pw);		# Original password...
    $ctx->add($Magic);		# ...our magic string...
    $ctx->add($salt);		# ...the salt...

    my ($final) = new Digest::MD5;
    $final->add($pw);
    $final->add($salt);
    $final->add($pw);
    $final = $final->digest;

    for ($pl = length($pw); $pl > 0; $pl -= 16) {
	$ctx->add(substr($final, 0, $pl > 16 ? 16 : $pl));
    }

				# Now the 'weird' xform

    for ($i = length($pw); $i; $i >>= 1) {
	if ($i & 1) { $ctx->add(pack("C", 0)); }
				# This comes from the original version,
				# where a memset() is done to $final
				# before this loop.
	else { $ctx->add(substr($pw, 0, 1)); }
    }

    $final = $ctx->digest;
				# The following is supposed to make
				# things run slower. In perl, perhaps
				# it'll be *really* slow!

    for ($i = 0; $i < 1000; $i++) {
	$ctx1 = new Digest::MD5;
	if ($i & 1) { $ctx1->add($pw); }
	else { $ctx1->add(substr($final, 0, 16)); }
	if ($i % 3) { $ctx1->add($salt); }
	if ($i % 7) { $ctx1->add($pw); }
	if ($i & 1) { $ctx1->add(substr($final, 0, 16)); }
	else { $ctx1->add($pw); }
	$final = $ctx1->digest;
    }
    
				# Final xform

    $passwd = '';
    $passwd .= to64(int(unpack("C", (substr($final, 0, 1))) << 16)
		    | int(unpack("C", (substr($final, 6, 1))) << 8)
		    | int(unpack("C", (substr($final, 12, 1)))), 4);
    $passwd .= to64(int(unpack("C", (substr($final, 1, 1))) << 16)
		    | int(unpack("C", (substr($final, 7, 1))) << 8)
		    | int(unpack("C", (substr($final, 13, 1)))), 4);
    $passwd .= to64(int(unpack("C", (substr($final, 2, 1))) << 16)
		    | int(unpack("C", (substr($final, 8, 1))) << 8)
		    | int(unpack("C", (substr($final, 14, 1)))), 4);
    $passwd .= to64(int(unpack("C", (substr($final, 3, 1))) << 16)
		    | int(unpack("C", (substr($final, 9, 1))) << 8)
		    | int(unpack("C", (substr($final, 15, 1)))), 4);
    $passwd .= to64(int(unpack("C", (substr($final, 4, 1))) << 16)
		    | int(unpack("C", (substr($final, 10, 1))) << 8)
		    | int(unpack("C", (substr($final, 5, 1)))), 4);
    $passwd .= to64(int(unpack("C", substr($final, 11, 1))), 2);

    $final = '';
    $Magic . $salt . q/$/ . $passwd;
}

1;

__END__

=pod

=head2 EXPORT

None by default.


=head1 HISTORY

$Id: PasswdMD5.pm,v 1.1 2006-08-27 21:21:24 martin Exp $

 19980710 luismunoz@cpan.org: Initial release
 19990402 bryan@eai.com: Added apache_md5_crypt to create a valid hash
                        for use in .htpasswd files
 20001006 wrowe@lnd.com: Requested apache_md5_crypt to be
			exported by default.
 20010706 luismunoz@cpan.org: Use Digest::MD5 instead of the (obsolete) MD5.

$Log: not supported by cvs2svn $
Revision 1.3  2004/02/17 11:21:38  lem
Modified the POD so that ABSTRACT can work
Added usage example for apache_md5_crypt()

Revision 1.2  2004/02/17 11:04:35  lem
Added patch for random salts from John Peacock (Thanks John!)
De-MS-DOS-ified the file
Replaced some '' with q// to make Emacs color highlighting happy
Added CVS docs
Completed the missing sections of the POD documentation
Changed my email address to the Perl-related one for consistency
The file is now encoded in ISO-8859-1


=head1 LICENSE AND WARRANTY

This code and all accompanying software comes with NO WARRANTY. You
use it at your own risk.

This code and all accompanying software can be used freely under the
same terms as Perl itself.

=head1 AUTHOR

Luis E. Muñoz <luismunoz@cpan.org>

=head1 SEE ALSO

perl(1).

=cut
