use strict;
use warnings;

package Net::SSLGlue::SMTP;
use IO::Socket::SSL 1.19;
use Net::SMTP;
our $VERSION = 1.001;

my $DONT;
BEGIN {
    if (defined &Net::SMTP::starttls) {
	warn "using SSL support of Net::SMTP $Net::SMTP::VERSION instead of SSLGlue";
	$DONT = 1;
	goto DONE;
    }

    ##############################################################################
    # mix starttls method into Net::SMTP which on SSL handshake success
    # upgrades the class to Net::SSLGlue::SMTP::_SSLified
    ##############################################################################
    *Net::SMTP::starttls = sub {
	my $self = shift;
	$self->_STARTTLS or return;
	my $host = $self->host;
	# for name verification strip port from domain:port, ipv4:port, [ipv6]:port
	$host =~s{(?<!:):\d+$}{};

	Net::SSLGlue::SMTP::_SSLified->start_SSL( $self,
	    SSL_verify_mode => 1,
	    SSL_verifycn_scheme => 'smtp',
	    SSL_verifycn_name => $host,
	    @_
	) or return;

	# another hello after starttls to read new ESMTP capabilities
	return $self->hello(${*$self}{net_smtp_hello_domain});
    };

    *Net::SMTP::_STARTTLS = sub {
	shift->command("STARTTLS")->response() == Net::SMTP::CMD_OK
    };

    no warnings 'redefine';
    my $old_new = \&Net::SMTP::new;
    *Net::SMTP::new = sub {
	my $class = shift;
	my %arg = @_ % 2 == 0 ? @_ : ( Host => shift,@_ );
	if ( delete $arg{SSL} ) {
	    $arg{Port} ||= 465;
	    return Net::SSLGlue::SMTP::_SSLified->new(%arg);
	} else {
	    return $old_new->($class,%arg);
	}
    };

    my $old_hello = \&Net::SMTP::hello;
    *Net::SMTP::hello = sub {
	my ($self,$domain) = @_;
	${*$self}{net_smtp_hello_domain} = $domain if $domain;
	goto &$old_hello;
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
    package Net::SSLGlue::SMTP::_SSL_Socket;
    goto DONE if $DONT;
    our @ISA = 'IO::Socket::SSL';
    *configure_SSL = sub {
	my ($self,$arg_hash) = @_;

	# set per default strict certificate verification
	$arg_hash->{SSL_verify_mode} = 1
	    if ! exists $arg_hash->{SSL_verify_mode};
	$arg_hash->{SSL_verifycn_scheme} = 'smtp'
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
# Net::SMTP derived from Net::SSLGlue::SMTP::_SSL_Socket instead of IO::Socket::INET
# this talks SSL to the peer
##############################################################################
{
    package Net::SSLGlue::SMTP::_SSLified;
    use Carp 'croak';
    goto DONE if $DONT;

    # deriving does not work because we need to replace a superclass
    # from Net::SMTP, so just copy the class into the new one and then
    # change it

    # copy subs
    for ( keys %{Net::SMTP::} ) {
	no strict 'refs';
	*{$_} = \&{ "Net::SMTP::$_" } if defined &{ "Net::SMTP::$_" };
    }

    # copy + fix @ISA
    our @ISA = @Net::SMTP::ISA;
    grep { s{^IO::Socket::INET$}{Net::SSLGlue::SMTP::_SSL_Socket} } @ISA
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

    DONE:
    1;
}

1;

=head1 NAME

Net::SSLGlue::SMTP - make Net::SMTP able to use SSL

=head1 SYNOPSIS

    use Net::SSLGlue::SMTP;
    my $smtp_ssl = Net::SMTP->new( $host,
	SSL => 1,
	SSL_ca_path => ...
    );

    my $smtp_plain = Net::SMTP->new( $host );
    $smtp_plain->starttls( SSL_ca_path => ... );

=head1 DESCRIPTION

L<Net::SSLGlue::SMTP> extends L<Net::SMTP> so one can either start directly with SSL
or switch later to SSL using the STARTTLS command.

By default it will take care to verify the certificate according to the rules
for SMTP implemented in L<IO::Socket::SSL>.

=head1 METHODS

=over 4

=item new

The method C<new> of L<Net::SMTP> is now able to start directly with SSL when
the argument C<<SSL => 1>> is given. In this case it will not create an
L<IO::Socket::INET> object but an L<IO::Socket::SSL> object. One can give the
usual C<SSL_*> parameter of L<IO::Socket::SSL> to C<Net::SMTP::new>.

=item starttls

If the connection is not yet SSLified it will issue the STARTTLS command and
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

IO::Socket::SSL, Net::SMTP

=head1 COPYRIGHT

This module is copyright (c) 2008, Steffen Ullrich.
All Rights Reserved.
This module is free software. It may be used, redistributed and/or modified
under the same terms as Perl itself.

