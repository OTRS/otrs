package Selenium::Remote::Commands;
$Selenium::Remote::Commands::VERSION = '1.39';
use strict;
use warnings;

use Carp qw{croak};

# ABSTRACT: Implement commands for Selenium::Remote::Driver for use with webdriver 2


use Moo;

has '_cmds' => (
    is      => 'lazy',
    reader  => 'get_cmds',
    builder => sub {
        return {
            'status' => {
                'method'             => 'GET',
                'url'                => 'status',
                'no_content_success' => 0
            },
            'newSession' => {
                'method'             => 'POST',
                'url'                => 'session',
                'no_content_success' => 0
            },
            'getSessions' => {
                'method'             => 'GET',
                'url'                => 'sessions',
                'no_content_success' => 0
            },
            'getCapabilities' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId',
                'no_content_success' => 0
            },
            'setTimeout' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/timeouts',
                'no_content_success' => 1
            },
            'setAsyncScriptTimeout' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/timeouts/async_script',
                'no_content_success' => 1
            },
            'setImplicitWaitTimeout' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/timeouts/implicit_wait',
                'no_content_success' => 1
            },
            'quit' => {
                'method'             => 'DELETE',
                'url'                => 'session/:sessionId',
                'no_content_success' => 1
            },
            'getCurrentWindowHandle' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/window_handle',
                'no_content_success' => 0
            },
            'getWindowHandles' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/window_handles',
                'no_content_success' => 0
            },
            'getWindowSize' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/window/:windowHandle/size',
                'no_content_success' => 0
            },
            'getWindowPosition' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/window/:windowHandle/position',
                'no_content_success' => 0
            },
            'maximizeWindow' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/window/:windowHandle/maximize',
                'no_content_success' => 1
            },
            'setWindowSize' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/window/:windowHandle/size',
                'no_content_success' => 1
            },
            'setWindowPosition' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/window/:windowHandle/position',
                'no_content_success' => 1
            },
            'getCurrentUrl' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/url',
                'no_content_success' => 0
            },
            'get' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/url',
                'no_content_success' => 1
            },
            'goForward' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/forward',
                'no_content_success' => 1
            },
            'goBack' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/back',
                'no_content_success' => 1
            },
            'refresh' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/refresh',
                'no_content_success' => 1
            },
            'executeScript' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/execute',
                'no_content_success' => 0
            },
            'executeAsyncScript' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/execute_async',
                'no_content_success' => 0
            },
            'screenshot' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/screenshot',
                'no_content_success' => 0
            },
            'availableEngines' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/ime/available_engines',
                'no_content_success' => 0
            },
            'switchToFrame' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/frame',
                'no_content_success' => 1
            },
            'switchToWindow' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/window',
                'no_content_success' => 1
            },
            'getAllCookies' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/cookie',
                'no_content_success' => 0
            },
            'addCookie' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/cookie',
                'no_content_success' => 1
            },
            'deleteAllCookies' => {
                'method'             => 'DELETE',
                'url'                => 'session/:sessionId/cookie',
                'no_content_success' => 1
            },
            'deleteCookieNamed' => {
                'method'             => 'DELETE',
                'url'                => 'session/:sessionId/cookie/:name',
                'no_content_success' => 1
            },
            'getPageSource' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/source',
                'no_content_success' => 0
            },
            'getTitle' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/title',
                'no_content_success' => 0
            },
            'findElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/element',
                'no_content_success' => 0
            },
            'findElements' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/elements',
                'no_content_success' => 0
            },
            'getActiveElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/element/active',
                'no_content_success' => 0
            },
            'describeElement' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/element/:id',
                'no_content_success' => 0
            },
            'findChildElement' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/element/:id/element',
                'no_content_success' => 0
            },
            'findChildElements' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/element/:id/elements',
                'no_content_success' => 0
            },
            'clickElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/element/:id/click',
                'no_content_success' => 1
            },
            'submitElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/element/:id/submit',
                'no_content_success' => 1
            },
            'sendKeysToElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/element/:id/value',
                'no_content_success' => 1
            },
            'sendKeysToActiveElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/keys',
                'no_content_success' => 1
            },
            'sendModifier' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/modifier',
                'no_content_success' => 1
            },
            'isElementSelected' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/selected',
                'no_content_success' => 0
            },
            'setElementSelected' => {
                'method' => 'POST',
                'url'    => 'session/:sessionId/element/:id/selected',
                'no_content_success' => 0
            },
            'toggleElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/element/:id/toggle',
                'no_content_success' => 0
            },
            'isElementEnabled' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/enabled',
                'no_content_success' => 0
            },
            'getElementLocation' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/location',
                'no_content_success' => 0
            },
            'getElementLocationInView' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/location_in_view',
                'no_content_success' => 0
            },
            'getElementTagName' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/element/:id/name',
                'no_content_success' => 0
            },
            'clearElement' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/element/:id/clear',
                'no_content_success' => 1
            },
            'getElementAttribute' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/attribute/:name',
                'no_content_success' => 0
            },
            'elementEquals' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/equals/:other',
                'no_content_success' => 0
            },
            'isElementDisplayed' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/displayed',
                'no_content_success' => 0
            },
            'close' => {
                'method'             => 'DELETE',
                'url'                => 'session/:sessionId/window',
                'no_content_success' => 1
            },
            'getElementSize' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/element/:id/size',
                'no_content_success' => 0
            },
            'getElementText' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/element/:id/text',
                'no_content_success' => 0
            },
            'getElementValueOfCssProperty' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/element/:id/css/:propertyName',
                'no_content_success' => 0
            },
            'mouseMoveToLocation' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/moveto',
                'no_content_success' => 1
            },
            'getAlertText' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/alert_text',
                'no_content_success' => 0
            },
            'sendKeysToPrompt' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/alert_text',
                'no_content_success' => 1
            },
            'acceptAlert' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/accept_alert',
                'no_content_success' => 1
            },
            'dismissAlert' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/dismiss_alert',
                'no_content_success' => 1
            },
            'click' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/click',
                'no_content_success' => 1
            },
            'doubleClick' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/doubleclick',
                'no_content_success' => 1
            },
            'buttonDown' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/buttondown',
                'no_content_success' => 1
            },
            'buttonUp' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/buttonup',
                'no_content_success' => 1
            },
            'uploadFile' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/file',
                'no_content_success' => 0
            },
            'getLocalStorageItem' => {
                'method' => 'GET',
                'url'    => '/session/:sessionId/local_storage/key/:key',
                'no_content_success' => 0
            },
            'deleteLocalStorageItem' => {
                'method' => 'DELETE',
                'url'    => '/session/:sessionId/local_storage/key/:key',
                'no_content_success' => 1
            },
            'cacheStatus' => {
                'method' => 'GET',
                'url'    => 'session/:sessionId/application_cache/status',
                'no_content_success' => 0
            },
            'setGeolocation' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/location',
                'no_content_success' => 1
            },
            'getGeolocation' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/location',
                'no_content_success' => 0
            },
            'getLog' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/log',
                'no_content_success' => 0
            },
            'getLogTypes' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/log/types',
                'no_content_success' => 0
            },
            'setOrientation' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/orientation',
                'no_content_success' => 1
            },
            'getOrientation' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/orientation',
                'no_content_success' => 0
            },

            # firefox extension
            'setContext' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/moz/context',
                'no_content_success' => 1
            },
            'getContext' => {
                'method'             => 'GET',
                'url'                => 'session/:sessionId/moz/context',
                'no_content_success' => 0
            },

            # geckodriver workarounds
            'executeScriptGecko' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/execute/sync',
                'no_content_success' => 0
            },
            'executeAsyncScriptGecko' => {
                'method'             => 'POST',
                'url'                => 'session/:sessionId/execute/async',
                'no_content_success' => 0
            },

            # /session/:sessionId/local_storage
            # /session/:sessionId/local_storage/key/:key
            # /session/:sessionId/local_storage/size
            # /session/:sessionId/session_storage
            # /session/:sessionId/session_storage/key/:key
            # /session/:sessionId/session_storage/size

        };
    }
);

# helper methods to manipulate the _cmds hash
sub get_url {
    my ( $self, $command ) = @_;
    return $self->get_cmds->{$command}->{url};
}

sub get_method {
    my ( $self, $command ) = @_;
    return $self->get_cmds->{$command}->{method};
}

sub get_no_content_success {
    my ( $self, $command ) = @_;
    return $self->get_cmds->{$command}->{no_content_success};
}

# This method will replace the template & return
sub get_params {
    my ( $self, $args ) = @_;
    if ( !( defined $args->{'session_id'} ) ) {
        return;
    }
    my $data    = {};
    my $command = $args->{'command'};

    #Allow fall-back in the event the command passed doesn't exist
    return unless $self->get_cmds()->{$command};

    my $url = $self->get_url($command);

    # Do the var substitutions.
    $url =~ s/:sessionId/$args->{'session_id'}/;
    $url =~ s/:id/$args->{'id'}/;
    $url =~ s/:name/$args->{'name'}/;
    $url =~ s/:propertyName/$args->{'property_name'}/;
    $url =~ s/:other/$args->{'other'}/;
    $url =~ s/:windowHandle/$args->{'window_handle'}/;

    $data->{'method'}             = $self->get_method($command);
    $data->{'no_content_success'} = $self->get_no_content_success($command);
    $data->{'url'}                = $url;

    return $data;
}

sub parse_response {
    my ( $self, $res, $resp ) = @_;
    if ( ref($resp) eq 'HASH' ) {
        if ( $resp->{cmd_status} && $resp->{cmd_status} eq 'OK' ) {
            return $resp->{cmd_return};
        }
        my $msg = "Error while executing command";
        $msg .= ": $resp->{cmd_error}" if $resp->{cmd_error};
        if ( $resp->{cmd_return} ) {
            if ( ref( $resp->{cmd_return} ) eq 'HASH' ) {
                $msg .= ": $res->{command}"
                  if $res->{command};
                $msg .= ": $resp->{cmd_return}->{error}->{msg}"
                  if $resp->{cmd_return}->{error}->{msg};
                $msg .= ": $resp->{cmd_return}->{message}"
                  if $resp->{cmd_return}->{message};
            }
            else {
                $msg .= ": $resp->{cmd_return}";
            }
        }
        croak $msg;
    }
    return $resp;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Commands - Implement commands for Selenium::Remote::Driver for use with webdriver 2

=head1 VERSION

version 1.39

=head1 DESCRIPTION

Defines all the HTTP endpoints available to execute on a selenium v2 server.

If you have either a customized Selenium Server, or want new features
you should update the _cmds hash.

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
