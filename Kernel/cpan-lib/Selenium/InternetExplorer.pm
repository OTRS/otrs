package Selenium::InternetExplorer;
$Selenium::InternetExplorer::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: A convenience package for creating a IE instance
use Moo;
extends 'Selenium::Remote::Driver';


has '+browser_name' => (
    is      => 'ro',
    default => sub { 'internet_explorer' }
);

has '+platform' => (
    is      => 'ro',
    default => sub { 'WINDOWS' }
);


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::InternetExplorer - A convenience package for creating a IE instance

=head1 VERSION

version 1.39

=head1 SYNOPSIS

    my $driver = Selenium::InternetExplorer->new;
    # when you're done
    $driver->shutdown_binary;

=head1 METHODS

=head2 shutdown_binary

Call this method instead of L<Selenium::Remote::Driver/quit> to ensure
that the binary executable is also closed, instead of simply closing
the browser itself. If the browser is still around, it will call
C<quit> for you. After that, it will try to shutdown the browser
binary by making a GET to /shutdown and on Windows, it will attempt to
do a C<taskkill> on the binary CMD window.

    $self->shutdown_binary;

It doesn't take any arguments, and it doesn't return anything.

We do our best to call this when the C<$driver> option goes out of
scope, but if that happens during global destruction, there's nothing
we can do.

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
