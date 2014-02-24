package Crypt::PasswdMD5;

use strict;
use warnings;

use Digest::MD5;

use Exporter 'import';

our @EXPORT    = qw/unix_md5_crypt apache_md5_crypt/;
our @EXPORT_OK = (@EXPORT, 'random_md5_salt');
our $VERSION   ='1.40';

# ------------------------------------------------

my($itoa64)          = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
our($Magic)          = q/$1$/; # Magic strings. Need 'our' because of local just below.
my($max_salt_length) = 8;

# ------------------------------------------------

sub apache_md5_crypt
{
	# Change the Magic string to match the one used by Apache.

	local $Magic = q/$apr1$/;

	return unix_md5_crypt(@_);

} # End of apache_md5_crypt.

# ------------------------------------------------

sub random_md5_salt
{
	my($len)  = shift || $max_salt_length;
	my($salt) = '';

	# Sanity check.

	$len  = $max_salt_length unless ( ($len >= 1) and ($len <= $max_salt_length) );
	$salt .= substr($itoa64,int(rand(64)),1) for (1..$len);

	return $salt;

} # End of random_md5_salt.

# ------------------------------------------------

sub to64
{
	my($v, $n) = @_;
	my($ret)   = '';

	while (--$n >= 0)
	{
		$ret .= substr($itoa64, $v & 0x3f, 1);

		$v >>= 6;
	}

	return $ret;

} # End of to64.

# ------------------------------------------------

sub unix_md5_crypt
{
	my($pw, $salt) = @_;

	my($passwd);

    if (defined $salt)
	{
		$salt =~ s/^\Q$Magic//;	# Take care of the magic string if present.
		$salt =~ s/^(.*)\$.*$/$1/;	# Salt can have up to 8 chars...
		$salt = substr($salt, 0, 8);
	}
	else
	{
		$salt = random_md5_salt();	 	# In case no salt was proffered.
    }

	my($ctx) = Digest::MD5 -> new;	# Here we start the calculation.

	$ctx -> add($pw);			# Original password...
	$ctx -> add($Magic);		# ...our magic string...
	$ctx -> add($salt);			# ...the salt...

	my($final) = Digest::MD5 -> new;

	$final -> add($pw);
	$final -> add($salt);
	$final -> add($pw);

	$final = $final -> digest;

	for (my $pl = length($pw); $pl > 0; $pl -= 16)
	{
		$ctx -> add(substr($final, 0, $pl > 16 ? 16 : $pl) );
	}

	# Now the 'weird' xform.

	for (my $i = length($pw); $i; $i >>= 1)
	{
		if ($i & 1)
		{
			$ctx -> add(pack('C', 0) );
		}

		# This comes from the original version, where a
		# memset() is done to $final before this loop.

		else
		{
			$ctx -> add(substr($pw, 0, 1) );
		}
	}

	$final = $ctx -> digest;

	# The following is supposed to make things run slower.
	# In perl, perhaps it'll be *really* slow!

	for (my $i = 0; $i < 1000; $i++)
	{
		my($ctx1) = Digest::MD5 -> new;

		if ($i & 1)
		{
			$ctx1 -> add($pw);
		}
		else
		{
			$ctx1 -> add(substr($final, 0, 16) );
		}

		if ($i % 3)
		{
			$ctx1 -> add($salt);
		}

		if ($i % 7)
		{
			$ctx1 -> add($pw);
		}

		if ($i & 1)
		{
			$ctx1 -> add(substr($final, 0, 16) );
		}
		else
		{
			$ctx1 -> add($pw);
		}

		$final = $ctx1 -> digest;
	}

	# Final xform

	$passwd = '';
	$passwd .= to64(int(unpack('C', (substr($final, 0, 1) ) ) << 16)
				| int(unpack('C', (substr($final, 6, 1) ) ) << 8)
				| int(unpack('C', (substr($final, 12, 1) ) ) ), 4);
	$passwd .= to64(int(unpack('C', (substr($final, 1, 1) ) ) << 16)
				| int(unpack('C', (substr($final, 7, 1) ) ) << 8)
				| int(unpack('C', (substr($final, 13, 1) ) ) ), 4);
	$passwd .= to64(int(unpack('C', (substr($final, 2, 1) ) ) << 16)
				| int(unpack('C', (substr($final, 8, 1) ) ) << 8)
				| int(unpack('C', (substr($final, 14, 1) ) ) ), 4);
	$passwd .= to64(int(unpack('C', (substr($final, 3, 1) ) ) << 16)
				| int(unpack('C', (substr($final, 9, 1) ) ) << 8)
				| int(unpack('C', (substr($final, 15, 1) ) ) ), 4);
	$passwd .= to64(int(unpack('C', (substr($final, 4, 1) ) ) << 16)
				| int(unpack('C', (substr($final, 10, 1) ) ) << 8)
				| int(unpack('C', (substr($final, 5, 1) ) ) ), 4);
	$passwd .= to64(int(unpack('C', substr($final, 11, 1) ) ), 2);

	return $Magic . $salt . q/$/ . $passwd;

} # End of unix_md5_crypt.

# ------------------------------------------------

1;

=pod

=encoding utf-8

=head1 NAME

Crypt::PasswdMD5 - Provide interoperable MD5-based crypt() functions

=head1 SYNOPSIS

	use strict;
	use warnings;

	use Crypt::PasswdMD5;

	my($password)       = 'seekrit';
	my($salt)           = 'pepperoni';
	my($unix_crypted)   = unix_md5_crypt($password, $salt);
	my($apache_crypted) = apache_md5_crypt($password, $salt);

	Or:

	use strict;
	use warnings;

	use Crypt::PasswdMD5 'random_md5_salt';

	my($length) = 7;
	my($salt_1) = random_md5_salt($length);
	my($salt_2) = random_md5_salt(); # Default to $length == 8.


=head1 DESCRIPTION

C<apache_md5_crypt()> provides a function compatible with Apache's C<.htpasswd> files.
This was contributed by Bryan Hart <bryan@eai.com>.
This function is exported by default.

The C<unix_md5_crypt()> provides a crypt()-compatible interface to the rather new MD5-based crypt() function
found in modern operating systems. It's based on the implementation found on FreeBSD 2.2.[56]-RELEASE.
This function is also exported by default.

For both functions, if a salt value is not supplied, a random salt will be
generated, using the function random_md5_salt().
This function is not exported by default.

=head1 LICENSE AND WARRANTY

This code and all accompanying software comes with NO WARRANTY. You
use it at your own risk.

This code and all accompanying software can be used freely under the
same terms as Perl itself.

=head1 METHODS

=head2 apache_md5_crypt($password, $salt)

This sets a magic variable, and then passes all the calling parameters to L</unix_md5_crypt($password, $salt)>.

Returns an encrypted version of the given password.

Basically, it's a very poor choice for anything other than password authentication.

=head2 random_md5_salt([$length])

Here, [] indicate an optional parameter.

Returns a random salt of the given length.

The maximum length is 8.

If C<$length> is omitted, it defaults to 8.

=head2 unix_md5_crypt($password, $salt)

Returns an encrypted version of the given password.

Basically, it's a very poor choice for anything other than password authentication.

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Crypt-PasswdMD5>

=head1 AUTHOR

Luis E. Muñoz <luismunoz@cpan.org>.

Maintenance by Ron Savage <rsavage@cpan.org> as of V 1.40.

=cut
