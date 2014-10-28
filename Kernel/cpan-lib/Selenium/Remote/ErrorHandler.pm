package Selenium::Remote::ErrorHandler;
{
  $Selenium::Remote::ErrorHandler::VERSION = '0.17';
}

use strict;
use warnings;

use Carp qw(croak);

# We're going to handle only codes that are errors.
# http://code.google.com/p/selenium/wiki/JsonWireProtocol
use constant STATUS_CODE => {
    7 => {
            'code' => 'NO_SUCH_ELEMENT',
            'msg'  => 'An element could not be located on the page using the given search parameters.',
         },
    8 => {
            'code' => 'NO_SUCH_FRAME',
            'msg'  => 'A request to switch to a frame could not be satisfied because the frame could not be found.',
         },
    9 => {
            'code' => 'UNKNOWN_COMMAND',
            'msg'  => 'The requested resource could not be found, or a request was received using an HTTP method that is not supported by the mapped resource.',
         },
    10 => {
            'code' => 'STALE_ELEMENT_REFERENCE',
            'msg'  => 'An element command failed because the referenced element is no longer attached to the DOM.',
         },
    11 => {
            'code' => 'ELEMENT_NOT_VISIBLE',
            'msg'  => 'An element command could not be completed because the element is not visible on the page.',
         },
    12 => {
            'code' => 'INVALID_ELEMENT_STATE',
            'msg'  => 'An element command could not be completed because the element is in an invalid state (e.g. attempting to click a disabled element).',
         },
    13 => {
            'code' => 'UNKNOWN_ERROR',
            'msg'  => 'An unknown server-side error occurred while processing the command.',
         },
    15 => {
            'code' => 'ELEMENT_IS_NOT_SELECTABLE',
            'msg'  => 'An attempt was made to select an element that cannot be selected.',
         },
    19 => {
            'code' => 'XPATH_LOOKUP_ERROR',
            'msg'  => 'An error occurred while searching for an element by XPath.',
         },
    21 => {
            'code' => 'Timeout',
            'msg'  => 'An operation did not complete before its timeout expired.',
         },
    23 => {
            'code' => 'NO_SUCH_WINDOW',
            'msg'  => 'A request to switch to a different window could not be satisfied because the window could not be found.',
         },
    24 => {
            'code' => 'INVALID_COOKIE_DOMAIN',
            'msg'  => 'An illegal attempt was made to set a cookie under a different domain than the current page.',
         },
    25 => {
            'code' => 'UNABLE_TO_SET_COOKIE',
            'msg'  => 'A request to set a cookie\'s value could not be satisfied.',
         },
    26 => {
            'code' => 'UNEXPECTED_ALERT_OPEN',
            'msg'  => 'A modal dialog was open, blocking this operation',
         },
    27 => {
            'code' => 'NO_ALERT_OPEN_ERROR',
            'msg'  => 'An attempt was made to operate on a modal dialog when one was not open.',
         },
    28 => {
            'code' => 'SCRIPT_TIMEOUT',
            'msg'  => 'A script did not complete before its timeout expired.',
         },
    29 => {
            'code' => 'INVALID_ELEMENT_COORDINATES',
            'msg'  => 'The coordinates provided to an interactions operation are invalid.',
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

sub new {
    my ($class) = @_;
    
    my $self = {};
    bless $self, $class or die "Can't bless $class: $!";
    
    return $self;
}

# Instead of just returning the end user a server returned error code, we will
# put a more human readable & usable error message & that is what this method
# is going to do. 
sub process_error {
    my ($self, $resp) = @_;
    # TODO: Handle screen if it sent back with the response. Either we could
    # let the end user handle it or we can save it an image file at a temp
    # location & return the path. 
    
    my $ret;
    $ret->{'stackTrace'} = $resp->{'value'}->{'stackTrace'};
    $ret->{'error'} = $self->STATUS_CODE->{$resp->{'status'}};
    $ret->{'message'} = $resp->{'value'}->{'message'};

    return $ret;
}


1;

__END__

=pod

=head1 NAME

Selenium::Remote::ErrorHandler - Error handler for Selenium::Remote::Driver

=head1 VERSION

version 0.17

=head1 SEE ALSO

For more information about Selenium , visit the website at
L<http://code.google.com/p/selenium/>.

=head1 BUGS

The Selenium issue tracking system is available online at
L<http://github.com/aivaturi/Selenium-Remote-Driver/issues>.

=head1 CURRENT MAINTAINER

Charles Howes C<< <chowes@cpan.org> >>

=head1 AUTHOR

Perl Bindings for Remote Driver by Aditya Ivaturi C<< <ivaturi@gmail.com> >>

=head1 LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
