package Selenium::Remote::ErrorHandler;
$Selenium::Remote::ErrorHandler::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Error handler for Selenium::Remote::Driver

use Moo;
use Carp qw(croak);

# We're going to handle only codes that are errors.
# http://code.google.com/p/selenium/wiki/JsonWireProtocol
has STATUS_CODE => (
    is      => 'lazy',
    builder => sub {
        return {
            7 => {
                'code' => 'NO_SUCH_ELEMENT',
                'msg' =>
'An element could not be located on the page using the given search parameters.',
            },
            8 => {
                'code' => 'NO_SUCH_FRAME',
                'msg' =>
'A request to switch to a frame could not be satisfied because the frame could not be found.',
            },
            9 => {
                'code' => 'UNKNOWN_COMMAND',
                'msg' =>
'The requested resource could not be found, or a request was received using an HTTP method that is not supported by the mapped resource.',
            },
            10 => {
                'code' => 'STALE_ELEMENT_REFERENCE',
                'msg' =>
'An element command failed because the referenced element is no longer attached to the DOM.',
            },
            11 => {
                'code' => 'ELEMENT_NOT_VISIBLE',
                'msg' =>
'An element command could not be completed because the element is not visible on the page.',
            },
            12 => {
                'code' => 'INVALID_ELEMENT_STATE',
                'msg' =>
'An element command could not be completed because the element is in an invalid state (e.g. attempting to click a disabled element).',
            },
            13 => {
                'code' => 'UNKNOWN_ERROR',
                'msg' =>
'An unknown server-side error occurred while processing the command.',
            },
            15 => {
                'code' => 'ELEMENT_IS_NOT_SELECTABLE',
                'msg' =>
'An attempt was made to select an element that cannot be selected.',
            },
            19 => {
                'code' => 'XPATH_LOOKUP_ERROR',
                'msg' =>
                  'An error occurred while searching for an element by XPath.',
            },
            21 => {
                'code' => 'Timeout',
                'msg' =>
                  'An operation did not complete before its timeout expired.',
            },
            23 => {
                'code' => 'NO_SUCH_WINDOW',
                'msg' =>
'A request to switch to a different window could not be satisfied because the window could not be found.',
            },
            24 => {
                'code' => 'INVALID_COOKIE_DOMAIN',
                'msg' =>
'An illegal attempt was made to set a cookie under a different domain than the current page.',
            },
            25 => {
                'code' => 'UNABLE_TO_SET_COOKIE',
                'msg' =>
                  'A request to set a cookie\'s value could not be satisfied.',
            },
            26 => {
                'code' => 'UNEXPECTED_ALERT_OPEN',
                'msg'  => 'A modal dialog was open, blocking this operation',
            },
            27 => {
                'code' => 'NO_ALERT_OPEN_ERROR',
                'msg' =>
'An attempt was made to operate on a modal dialog when one was not open.',
            },
            28 => {
                'code' => 'SCRIPT_TIMEOUT',
                'msg' =>
                  'A script did not complete before its timeout expired.',
            },
            29 => {
                'code' => 'INVALID_ELEMENT_COORDINATES',
                'msg' =>
'The coordinates provided to an interactions operation are invalid.',
            },
            30 => {
                'code' => 'IME_NOT_AVAILABLE',
                'msg'  => 'IME was not available.',
            },
            31 => {
                'code' => 'IME_ENGINE_ACTIVATION_FAILED',
                'msg'  => 'An IME engine could not be started.',
            },
            32 => {
                'code' => 'INVALID_SELECTOR',
                'msg'  => 'Argument was an invalid selector (e.g. XPath/CSS).',
            },
        };
    }
);


sub process_error {
    my ( $self, $resp ) = @_;

    # TODO: Handle screen if it sent back with the response. Either we could
    # let the end user handle it or we can save it an image file at a temp
    # location & return the path.

    # handle stacktrace-only responses by assuming unknown error
    my $is_stacktrace = !$resp->{status};
    $resp->{status} = 13 unless $resp->{status};

    my $ret;

    #XXX capitalization is inconsistent among geckodriver versions
    $ret->{'stackTrace'} = $resp->{'value'}->{'stacktrace'}
      // $resp->{'value'}->{'stackTrace'};
    $ret->{'error'} =
        $is_stacktrace
      ? $resp->{value}->{error}
      : $self->STATUS_CODE->{ $resp->{'status'} };
    $ret->{'message'} = $resp->{'value'}->{'message'};

    return $ret;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::ErrorHandler - Error handler for Selenium::Remote::Driver

=head1 VERSION

version 1.39

=head1 SUBROUTINES

=head2 process_error (Selenium::Remote::Driver $driver, HTTP::Response $response)

Instead of just returning the end user a server returned error code, this returns a more human readable & usable error message.

Used internally in Selenium::Remote::Driver, but overriding this might be useful in some situations.
You could additionally alter the STATUS_CODE parameter of this module to add extra handlers if the situation warrants it.

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
