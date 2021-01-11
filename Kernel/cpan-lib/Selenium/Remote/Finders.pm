package Selenium::Remote::Finders;
$Selenium::Remote::Finders::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Handle construction of generic parameter finders
use Try::Tiny;
use Carp qw/carp/;
use Moo::Role;
use namespace::clean;


sub _build_find_by {
    my ( $self, $by ) = @_;

    return sub {
        my ( $driver, $locator ) = @_;
        my $strategy = $by;

        return try {
            return $driver->find_element( $locator, $strategy );
        }
        catch {
            carp $_;
            return 0;
        };
      }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Finders - Handle construction of generic parameter finders

=head1 VERSION

version 1.39

=head1 DESCRIPTION

This package just takes care of setting up parameter finders - that
is, the C<find_element_by_.*> versions of the find element
functions. You probably don't need to do anything with this package;
instead, see L<Selenium::Remote::Driver/find_element> documentation
for the specific finder functions.

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
