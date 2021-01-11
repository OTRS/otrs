package Selenium::CanStartBinary::ProbePort;
$Selenium::CanStartBinary::ProbePort::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Utility functions for finding open ports to eventually bind to

use IO::Socket::INET;
use Selenium::Waiter qw/wait_until/;

require Exporter;
our @ISA       = qw/Exporter/;
our @EXPORT_OK = qw/find_open_port_above find_open_port probe_port/;


sub find_open_port_above {
    socket(SOCK, PF_INET, SOCK_STREAM, getprotobyname("tcp"));
    bind(SOCK, sockaddr_in(0, INADDR_ANY));
    my $port = (sockaddr_in(getsockname(SOCK)))[0];
    close(SOCK);
    return $port;
}

sub find_open_port {
    my ($port) = @_;

    probe_port($port) ? return 0 : return $port;
}

sub probe_port {
    my ($port) = @_;

    return IO::Socket::INET->new(
        PeerAddr => '127.0.0.1',
        PeerPort => $port,
        Timeout  => 3
    );
}

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::CanStartBinary::ProbePort - Utility functions for finding open ports to eventually bind to

=head1 VERSION

version 1.39

=for Pod::Coverage *EVERYTHING*

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://github.com/teodesian/Selenium-Remote-Driver/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHORS

Current Maintainers:

=over 4

=item *

Daniel Gempesaw <gempesaw@gmail.com>

=item *

Emmanuel Peroumalnaïk <peroumalnaik.emmanuel@gmail.com>

=back

Previous maintainers:

=over 4

=item *

Luke Closs <cpan@5thplane.com>

=item *

Mark Stosberg <mark@stosberg.com>

=back

Original authors:

=over 4

=item *

Aditya Ivaturi <ivaturi@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Copyright (c) 2014-2017 Daniel Gempesaw

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut
