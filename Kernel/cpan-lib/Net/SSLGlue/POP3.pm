use strict;
use warnings;

package Net::SSLGlue::POP3;
use IO::Socket::SSL 1.19;
use Net::POP3;
our $VERSION = 0.911;

my $DONT;
BEGIN {
    if (defined &Net::POP3::starttls) {
	warn "using SSL support of Net::POP3 $Net::POP3::VERSION instead of SSLGlue";
	$DONT = 1;
	goto DONE;
    }

    ##############################################################################
    # mix starttls method into Net::POP3 which on SSL handshake success
    # upgrades the class to Net::SSLGlue::POP3::_SSLified
    ##############################################################################
    *Net::POP3::starttls = sub {
	my $self = shift;
	$self->_STLS or return;
	my $host = $self->host;
	# for name verification strip port from domain:port, ipv4:port, [ipv6]:port
	$host =~s{(?<!:):\d+$}{};

	Net::SSLGlue::POP3::_SSLified->start_SSL( $self,
	    SSL_verify_mode => 1,
	    SSL_verifycn_scheme => 'pop3',
	    SSL_verifycn_name => $host,
	    @_
	) or return;
    };

    *Net::POP3::_STLS = sub {
	shift->command("STLS")->response() == Net::POP3::CMD_OK
    };

    no warnings 'redefine';
    my $old_new = \&Net::POP3::new;
    *Net::POP3::new = sub {
	my $class = shift;
	my %arg = @_ % 2 == 0 ? @_ : ( Host => shift,@_ );
	if ( delete $arg{SSL} ) {
	    $arg{Port} ||= 995;
	    return Net::SSLGlue::POP3::_SSLified->new(%arg);
	} else {
	    return $old_new->($class,%arg);
	}
    };

    DONE:
    1;
}

##############################################################################
# Socket class derived from IO::Socket::SSL
# strict certificate verification per default
##############################################################################
our %SSLopts;
{
    package Net::SSLGlue::POP3::_SSL_Socket;
    goto DONE if $DONT;
    our @ISA = 'IO::Socket::SSL';
    *configure_SSL = sub {
	my ($self,$arg_hash) = @_;

	# set per default strict certificate verification
	$arg_hash->{SSL_verify_mode} = 1
	    if ! exists $arg_hash->{SSL_verify_mode};
	$arg_hash->{SSL_verifycn_scheme} = 'pop3'
	    if ! exists $arg_hash->{SSL_verifycn_scheme};
	$arg_hash->{SSL_verifycn_name} = $self->host
	    if ! exists $arg_hash->{SSL_verifycn_name};

	# force keys from %SSLopts
	while ( my ($k,$v) = each %SSLopts ) {
	    $arg_hash->{$k} = $v;
	}
	return $self->SUPER::configure_SSL($arg_hash)
    };

    DONE:
    1;
}


##############################################################################
# Net::POP3 derived from Net::POP3::_SSL_Socket instead of IO::Socket::INET
# this talks SSL to the peer
##############################################################################
{
    package Net::SSLGlue::POP3::_SSLified;
    use Carp 'croak';
    goto DONE if $DONT;

    # deriving does not work because we need to replace a superclass
    # from Net::POP3, so just copy the class into the new one and then
    # change it

    # copy subs
    for ( keys %{Net::POP3::} ) {
	no strict 'refs';
	*{$_} = \&{ "Net::POP3::$_" } if defined &{ "Net::POP3::$_" };
    }

    # copy + fix @ISA
    our @ISA = @Net::POP3::ISA;
    grep { s{^IO::Socket::INET$}{Net::SSLGlue::POP3::_SSL_Socket} } @ISA
	or die "cannot find and replace IO::Socket::INET superclass";

    # we are already sslified
    no warnings 'redefine';
    *starttls = sub { croak "have already TLS\n" };

    my $old_new = \&new;
    *new = sub {
	my $class = shift;
	my %arg = @_ % 2 == 0 ? @_ : ( Host => shift,@_ );
	local %SSLopts;
	$SSLopts{$_} = delete $arg{$_} for ( grep { /^SSL_/ } keys %arg );
	return $old_new->($class,%arg);
    };

    # Net::Cmd getline uses select, but this is not sufficient with SSL
    # note that this does no EBCDIC etc conversions
    *getline = sub {
	my $self = shift;
	# skip Net::POP3 getline and go directly to IO::Socket::SSL
	return $self->IO::Socket::SSL::getline(@_);
    };

    DONE:
    1;
}

1;

=head1 NAME

Net::SSLGlue::POP3 - make Net::POP3 able to use SSL

=head1 SYNOPSIS

    use Net::SSLGlue::POP3;
    my $pop3s = Net::POP3->new( $host,
	SSL => 1,
	SSL_ca_path => ...
    );

    my $pop3 = Net::POP3->new( $host );
    $pop3->starttls( SSL_ca_path => ... );

=head1 DESCRIPTION

L<Net::SSLGlue::POP3> extends L<Net::POP3> so one can either start directly with SSL
or switch later to SSL using the STLS command.

By default it will take care to verify the certificate according to the rules
for POP3 implemented in L<IO::Socket::SSL>.

=head1 METHODS

=over 4

=item new

The method C<new> of L<Net::POP3> is now able to start directly with SSL when
the argument C<<SSL => 1>> is given. In this case it will not create an
L<IO::Socket::INET> object but an L<IO::Socket::SSL> object. One can give the
usual C<SSL_*> parameter of L<IO::Socket::SSL> to C<Net::POP3::new>.

=item starttls

If the connection is not yet SSLified it will issue the STLS command and
change the object, so that SSL will now be used. The usual C<SSL_*> parameter of
L<IO::Socket::SSL> will be given.

=item peer_certificate ...

Once the SSL connection is established the object is derived from
L<IO::Socket::SSL> so that you can use this method to get information about the
certificate. See the L<IO::Socket::SSL> documentation.

=back

All of these methods can take the C<SSL_*> parameter from L<IO::Socket::SSL> to
change the behavior of the SSL connection. The following parameters are
especially useful:

=over 4

=item SSL_ca_path, SSL_ca_file

Specifies the path or a file where the CAs used for checking the certificates
are located. This is typically L</etc/ssl/certs> on UNIX systems.

=item SSL_verify_mode

If set to 0, verification of the certificate will be disabled. By default
it is set to 1 which means that the peer certificate is checked.

=item SSL_verifycn_name

Usually the name given as the hostname in the constructor is used to verify the
identity of the certificate. If you want to check the certificate against
another name you can specify it with this parameter.

=back

=head1 SEE ALSO

IO::Socket::SSL, Net::POP3

=head1 COPYRIGHT

This module is copyright (c) 2013, Steffen Ullrich.
All Rights Reserved.
This module is free software. It may be used, redistributed and/or modified
under the same terms as Perl itself.

