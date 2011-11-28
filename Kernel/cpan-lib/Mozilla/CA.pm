package Mozilla::CA;

use strict;
our $VERSION = '20111025';

use Cwd ();
use File::Spec ();
use File::Basename qw(dirname);

sub SSL_ca_file {
    my $file = File::Spec->catfile(dirname(__FILE__), "CA", "cacert.pem");
    if (!File::Spec->file_name_is_absolute($file)) {
	$file = File::Spec->catfile(Cwd::cwd(), $file);
    }
    return $file;
}

1;

__END__

=head1 NAME

Mozilla::CA - Mozilla's CA cert bundle in PEM format

=head1 SYNOPSIS

    use IO::Socket::SSL;
    use Mozilla::CA;

    my $host = "www.paypal.com";
    my $client = IO::Socket::SSL->new(
	PeerHost => "$host:443",
	SSL_verify_mode => 0x02,
	SSL_ca_file => Mozilla::CA::SSL_ca_file(),
    )
	|| die "Can't connect: $@";

    $client->verify_hostname($host, "http")
	|| die "hostname verification failure";

=head1 DESCRIPTION

Mozilla::CA provides a copy of Mozilla's bundle of Certificate Authority
certificates in a form that can be consumed by modules and libraries
based on OpenSSL.

The module provide a single function:

=over

=item SSL_ca_file()

Returns the absolute path to the Mozilla's CA cert bundle PEM file.

=back

=head1 SEE ALSO

L<http://curl.haxx.se/docs/caextract.html>

=head1 LICENSE

For the bundled Mozilla CA PEM file the following applies:

=over

The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is the Netscape security libraries.

The Initial Developer of the Original Code is
Netscape Communications Corporation.
Portions created by the Initial Developer are Copyright (C) 1994-2000
the Initial Developer. All Rights Reserved.

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 or later (the "GPL"), or
the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
in which case the provisions of the GPL or the LGPL are applicable instead
of those above. If you wish to allow use of your version of this file only
under the terms of either the GPL or the LGPL, and not to allow others to
use your version of this file under the terms of the MPL, indicate your
decision by deleting the provisions above and replace them with the notice
and other provisions required by the GPL or the LGPL. If you do not delete
the provisions above, a recipient may use your version of this file under
the terms of any one of the MPL, the GPL or the LGPL.

=back

The Mozilla::CA distribution itself is available under the same license.
