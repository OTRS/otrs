package Net::SSLGlue;
our $VERSION = '1.058';

=head1 NAME

Net::SSLGlue - add/extend SSL support for common perl modules

=head1 DESCRIPTION

Some commonly used perl modules don't have SSL support at all, even if the
protocol supports it. Others have SSL support, but most of them don't do
proper checking of the server's certificate.

The C<Net::SSLGlue::*> modules try to add SSL support or proper certificate
checking to these modules. Currently support for the following modules is
available:

=over 4

=item Net::SMTP - add SSL from beginning or using STARTTLS

=item Net::POP3 - add SSL from beginning or using STLS

=item Net::FTP  - add SSL and IPv6 support to Net::FTP

=item Net::LDAP - add proper certificate checking

=item LWP - add proper certificate checking for older LWP versions

=back

There is also a Net::SSLGlue::Socket package which combines ssl and non-ssl
and ipv6 capabilities to make it easier to enhance modules based on
IO::Socket::INET.

=head1 COPYRIGHT

This module and the modules in the Net::SSLGlue Hierarchy distributed together
with this module are copyright (c) 2008-2015, Steffen Ullrich.
All Rights Reserved.
These modules are free software. They may be used, redistributed and/or modified
under the same terms as Perl itself.
