package Selenium::Remote::Driver::CanSetWebdriverContext;
$Selenium::Remote::Driver::CanSetWebdriverContext::VERSION = '1.39';
# ABSTRACT: Customize the webdriver context prefix for various drivers

use strict;
use warnings;

use Moo::Role;


has 'wd_context_prefix' => (
    is      => 'lazy',
    default => sub { '/wd/hub' }
);

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Driver::CanSetWebdriverContext - Customize the webdriver context prefix for various drivers

=head1 VERSION

version 1.39

=head1 DESCRIPTION

Some drivers don't use the typical C</wd/hub> context prefix for the
webdriver HTTP communication. For example, the newer versions of the
Firefox driver extension use the context C</hub> instead. This role
just has the one attribute with a default webdriver context prefix,
and is consumed in L<Selenium::Remote::Driver> and
L<Selenium::Remote::RemoteConnection>.

If you're new to webdriver, you probably want to head over to
L<Selenium::Remote::Driver>'s docs; this package is more of an
internal-facing concern.

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
