package LWP::Protocol::https;

use strict;
our $VERSION = "6.04";

require LWP::Protocol::http;
our @ISA = qw(LWP::Protocol::http);

sub socket_type
{
    return "https";
}

sub _extra_sock_opts
{
    my $self = shift;
    my %ssl_opts = %{$self->{ua}{ssl_opts} || {}};
    if (delete $ssl_opts{verify_hostname}) {
	$ssl_opts{SSL_verify_mode} ||= 1;
	$ssl_opts{SSL_verifycn_scheme} = 'www';
    }
    else {
	$ssl_opts{SSL_verify_mode} = 0;
    }
    if ($ssl_opts{SSL_verify_mode}) {
	unless (exists $ssl_opts{SSL_ca_file} || exists $ssl_opts{SSL_ca_path}) {
	    eval {
		require Mozilla::CA;
	    };
	    if ($@) {
		if ($@ =! /^Can't locate Mozilla\/CA\.pm/) {
		    $@ = <<'EOT';
Can't verify SSL peers without knowing which Certificate Authorities to trust

This problem can be fixed by either setting the PERL_LWP_SSL_CA_FILE
envirionment variable or by installing the Mozilla::CA module.

To disable verification of SSL peers set the PERL_LWP_SSL_VERIFY_HOSTNAME
envirionment variable to 0.  If you do this you can't be sure that you
communicate with the expected peer.
EOT
		}
		die $@;
	    }
	    $ssl_opts{SSL_ca_file} = Mozilla::CA::SSL_ca_file();
	}
    }
    $self->{ssl_opts} = \%ssl_opts;
    return (%ssl_opts, $self->SUPER::_extra_sock_opts);
}

sub _check_sock
{
    my($self, $req, $sock) = @_;
    my $check = $req->header("If-SSL-Cert-Subject");
    if (defined $check) {
	my $cert = $sock->get_peer_certificate ||
	    die "Missing SSL certificate";
	my $subject = $cert->subject_name;
	die "Bad SSL certificate subject: '$subject' !~ /$check/"
	    unless $subject =~ /$check/;
	$req->remove_header("If-SSL-Cert-Subject");  # don't pass it on
    }
}

sub _get_sock_info
{
    my $self = shift;
    $self->SUPER::_get_sock_info(@_);
    my($res, $sock) = @_;
    $res->header("Client-SSL-Cipher" => $sock->get_cipher);
    my $cert = $sock->get_peer_certificate;
    if ($cert) {
	$res->header("Client-SSL-Cert-Subject" => $cert->subject_name);
	$res->header("Client-SSL-Cert-Issuer" => $cert->issuer_name);
    }
    if (!$self->{ssl_opts}{SSL_verify_mode}) {
	$res->push_header("Client-SSL-Warning" => "Peer certificate not verified");
    }
    elsif (!$self->{ssl_opts}{SSL_verifycn_scheme}) {
	$res->push_header("Client-SSL-Warning" => "Peer hostname match with certificate not verified");
    }
    $res->header("Client-SSL-Socket-Class" => $Net::HTTPS::SSL_SOCKET_CLASS);
}

#-----------------------------------------------------------
package LWP::Protocol::https::Socket;

require Net::HTTPS;
our @ISA = qw(Net::HTTPS LWP::Protocol::http::SocketMethods);

1;

__END__

=head1 NAME

LWP::Protocol::https - Provide https support for LWP::UserAgent

=head1 SYNOPSIS

  use LWP::UserAgent;

  $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
  $res = $ua->get("https://www.example.com");

=head1 DESCRIPTION

The LWP::Protocol::https module provides support for using https schemed
URLs with LWP.  This module is a plug-in to the LWP protocol handling, so
you don't use it directly.  Once the module is installed LWP is able
to access sites using HTTP over SSL/TLS.

If hostname verification is requested by LWP::UserAgent's C<ssl_opts>, and
neither C<SSL_ca_file> nor C<SSL_ca_path> is set, then C<SSL_ca_file> is
implied to be the one provided by Mozilla::CA.  If the Mozilla::CA module
isn't available SSL requests will fail.  Either install this module, set up an
alternative C<SSL_ca_file> or disable hostname verification.

This module used to be bundled with the libwww-perl, but it was unbundled in
v6.02 in order to be able to declare its dependencies properly for the CPAN
tool-chain.  Applications that need https support can just declare their
dependency on LWP::Protocol::https and will no longer need to know what
underlying modules to install.

=head1 SEE ALSO

L<IO::Socket::SSL>, L<Crypt::SSLeay>, L<Mozilla::CA>

=head1 COPYRIGHT

Copyright 1997-2011 Gisle Aas.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
