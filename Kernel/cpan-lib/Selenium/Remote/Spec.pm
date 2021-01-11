package Selenium::Remote::Spec;
$Selenium::Remote::Spec::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Implement commands for Selenium::Remote::Driver


use Carp qw{croak};
use List::Util qw{any};

use Moo;
extends 'Selenium::Remote::Commands';

#Ripped from the headlines: https://w3c.github.io/webdriver/webdriver-spec.html
#then add 2 params for our use

#Method    URI Template    no_content_success    internal_name    Command
our $spec = qq{
POST    session                                              0 newSession                   New Session
POST    session                                              0 getCapabilities              Get Capabilities (v2->v3 shim)
DELETE  session/:sessionId                                   1 quit                         Delete Session
GET     status                                               0 status                       Status
GET     session/:sessionId/timeouts                          0 getTimeouts                  Get Timeouts
POST    session/:sessionId/timeouts                          1 setTimeout                   Set Page Load timeout (v2->v3 shim)
POST    session/:sessionId/timeouts/async_script             1 setAsyncScriptTimeout        Set Async script timeout (v2->v3 shim)
POST    session/:sessionId/timeouts/implicit_wait            1 setImplicitWaitTimeout       Set Implicit wait timeout (v2->v3 shim)
POST    session/:sessionId/url                               1 get                          Navigate To
GET     session/:sessionId/url                               0 getCurrentUrl                Get Current URL
POST    session/:sessionId/back                              1 goBack                       Back
POST    session/:sessionId/forward                           1 goForward                    Forward
POST    session/:sessionId/refresh                           1 refresh                      Refresh
GET     session/:sessionId/title                             0 getTitle Get                 Title
GET     session/:sessionId/window                            0 getCurrentWindowHandle       Get Currently Focused Window Handle
DELETE  session/:sessionId/window                            1 close                        Close Currently Focused Window
POST    session/:sessionId/window                            1 switchToWindow               Switch To Window
GET     session/:sessionId/window/handles                    0 getWindowHandles             Get Window Handles
POST    session/:sessionId/frame                             1 switchToFrame                Switch To Frame
POST    session/:sessionId/frame/parent                      1 switchToParentFrame          Switch To Parent Frame
GET     session/:sessionId/window/rect                       0 getWindowRect                Get Window Size/Position (v2->v3 shim)
POST    session/:sessionId/window/rect                       1 setWindowRect                Set Window Size/Position (v2->v3 shim)
POST    session/:sessionId/window/maximize                   1 maximizeWindow               Maximize Window
POST    session/:sessionId/window/minimize                   1 minimizeWindow               Minimize Window
POST    session/:sessionId/window/fullscreen                 1 fullscreenWindow             Fullscreen Window
GET     session/:sessionId/element/active                    0 getActiveElement             Get Active Element
POST    session/:sessionId/element                           0 findElement                  Find Element
POST    session/:sessionId/elements                          0 findElements                 Find Elements
POST    session/:sessionId/element/:id/element               0 findChildElement             Find Element From Element
POST    session/:sessionId/element/:id/elements              0 findChildElements            Find Elements From Element
GET     session/:sessionId/element/:id/selected              0 isElementSelected            Is Element Selected
GET     session/:sessionId/element/:id/attribute/:name       0 getElementAttribute          Get Element Attribute
GET     session/:sessionId/element/:id/property/:name        0 getElementProperty           Get Element Property
GET     session/:sessionId/element/:id/css/:propertyName     0 getElementValueOfCssProperty Get Element CSS Value
GET     session/:sessionId/element/:id/text                  0 getElementText               Get Element Text
GET     session/:sessionId/element/:id/name                  0 getElementTagName            Get Element Tag Name
GET     session/:sessionId/element/:id/rect                  0 getElementRect               Get Element Rect
GET     session/:sessionId/element/:id/enabled               0 isElementEnabled             Is Element Enabled
POST    session/:sessionId/element/:id/click                 1 clickElement                 Element Click
POST    session/:sessionId/element/:id/clear                 1 clearElement                 Element Clear
POST    session/:sessionId/element/:id/value                 1 sendKeysToElement            Element Send Keys
GET     session/:sessionId/source                            0 getPageSource                Get Page Source
POST    session/:sessionId/execute/sync                      0 executeScript                Execute Script
POST    session/:sessionId/execute/async                     0 executeAsyncScript           Execute Async Script
GET     session/:sessionId/cookie                            0 getAllCookies                Get All Cookies
GET     session/:sessionId/cookie/:name                      0 getCookieNamed               Get Named Cookie
POST    session/:sessionId/cookie                            1 addCookie                    Add Cookie
DELETE  session/:sessionId/cookie/:name                      1 deleteCookieNamed            Delete Cookie
DELETE  session/:sessionId/cookie                            1 deleteAllCookies             Delete All Cookies
POST    session/:sessionId/actions                           1 generalAction                Perform Actions
DELETE  session/:sessionId/actions                           1 releaseGeneralAction         Release Actions
POST    session/:sessionId/alert/dismiss                     1 dismissAlert                 Dismiss Alert
POST    session/:sessionId/alert/accept                      1 acceptAlert                  Accept Alert
GET     session/:sessionId/alert/text                        0 getAlertText                 Get Alert Text
POST    session/:sessionId/alert/text                        1 sendKeysToPrompt             Send Alert Text
GET     session/:sessionId/screenshot                        0 screenshot                   Take Screenshot
GET     session/:sessionId/moz/screenshot/full               0 mozScreenshotFull            Take Full Screenshot
GET     session/:sessionId/element/:id/screenshot            0 elementScreenshot            Take Element Screenshot
};

our $spec_parsed;

sub get_spec {
    return $spec_parsed if $spec_parsed;
    my @split = split( /\n/, $spec );
    foreach my $line (@split) {
        next unless $line;
        my ( $method, $uri, $nc_success, $key, @description ) =
          split( / +/, $line );
        $spec_parsed->{$key} = {
            method             => $method,
            url                => $uri,
            no_content_success => int($nc_success)
            ,    #XXX this *should* always be 0, but specs lie
            description => join( ' ', @description ),
        };
    }
    return $spec_parsed;
}

has '_cmds' => (
    is      => 'lazy',
    reader  => 'get_cmds',
    builder => \&get_spec,
);


has '_caps' => (
    is      => 'lazy',
    reader  => 'get_caps',
    builder => sub {
        return [
            'browserName',             'acceptInsecureCerts',
            'browserVersion',          'platformName',
            'proxy',                   'pageLoadStrategy',
            'setWindowRect',           'timeouts',
            'unhandledPromptBehavior', 'moz:firefoxOptions',
            'goog:chromeOptions',      'goog:loggingPrefs',
        ];
    }
);

has '_caps_map' => (
    is      => 'lazy',
    reader  => 'get_caps_map',
    builder => sub {
        return {
            browserName    => 'browserName',
            acceptSslCerts => 'acceptInsecureCerts',
            version        => 'browserVersion',
            platform       => 'platformName',
            proxy          => 'proxy',
        };
    }
);

sub get_params {
    my ( $self, $args ) = @_;
    if ( !( defined $args->{'session_id'} ) ) {
        return;
    }

    #Allow fall-back in the event the command passed doesn't exist
    return unless $self->get_cmds()->{ $args->{command} };

    my $url = $self->get_url( $args->{command} );

    my $data = {};

    # Do the var substitutions.
    $url =~ s/:sessionId/$args->{'session_id'}/;
    $url =~ s/:id/$args->{'id'}/;
    $url =~ s/:name/$args->{'name'}/;
    $url =~ s/:propertyName/$args->{'property_name'}/;
    $url =~ s/:other/$args->{'other'}/;
    $url =~ s/:windowHandle/$args->{'window_handle'}/;

    $data->{'method'} = $self->get_method( $args->{command} );
    $data->{'no_content_success'} =
      $self->get_no_content_success( $args->{command} );
    $data->{'url'} = $url;

    #URL & data polyfills for the way selenium2 used to do things, etc
    $data->{payload} = {};
    if ( $args->{type} ) {
        $data->{payload}->{pageLoad} = $args->{ms}
          if $data->{url} =~ m/timeouts$/ && $args->{type} eq 'page load';
        $data->{payload}->{script} = $args->{ms}
          if $data->{url} =~ m/timeouts$/ && $args->{type} eq 'script';
        $data->{payload}->{implicit} = $args->{ms}
          if $data->{url} =~ m/timeouts$/ && $args->{type} eq 'implicit';
    }

#finder polyfills
#orig: class, class_name, css, id, link, link_text, partial_link_text, tag_name, name, xpath
#new:  "css selector", "link text", "partial link text", "tag name", "xpath"
#map: class, class_name, id, name, link = 'css selector'
    if ( $args->{using} && $args->{value} ) {
        $data->{payload}->{using} = 'css selector'
          if grep { $args->{using} eq $_ } ( 'id', 'class name', 'name' );
        $data->{payload}->{value} = "[id='$args->{value}']"
          if $args->{using} eq 'id';
        $data->{payload}->{value} = ".$args->{value}"
          if $args->{using} eq 'class name';
        $data->{payload}->{value} = "[name='$args->{value}']"
          if $args->{using} eq 'name';
    }
    if ( $data->{url} =~ s/timeouts\/async_script$/timeouts/g ) {
        $data->{payload}->{script} = $args->{ms};
        $data->{payload}->{type} = 'script'; #XXX chrome doesn't follow the spec
    }
    if ( $data->{url} =~ s/timeouts\/implicit_wait$/timeouts/g ) {
        $data->{payload}->{implicit} = $args->{ms};
        $data->{payload}->{type} =
          'implicit';                        #XXX chrome doesn't follow the spec
    }
    $data->{payload}->{value} = $args->{text}
      if $args->{text} && $args->{command} ne 'sendKeysToElement';
    $data->{payload}->{handle} = $args->{window_handle}
      if grep { $args->{command} eq $_ }
      qw{fullscreenWindow minimizeWindow maximizeWindow};
    return $data;
}

sub parse_response {
    my ( $self, undef, $resp ) = @_;

    if ( ref($resp) eq 'HASH' ) {
        if ( $resp->{cmd_status} && $resp->{cmd_status} eq 'OK' ) {
            return $resp->{cmd_return};
        }
        my $msg = "Error while executing command";
        if ( ref $resp->{cmd_return} eq 'HASH' ) {
            $msg .= ": $resp->{cmd_return}{error}"
              if $resp->{cmd_return}{error};
            $msg .= ": $resp->{cmd_return}{message}"
              if $resp->{cmd_return}{message};
        }
        else {
            $msg .= ": $resp->{cmd_return}";
        }
        croak $msg;
    }

    return $resp;
}

#Utility

sub get_spec_differences {
    my $v2_spec = Selenium::Remote::Commands->new()->get_cmds();
    my $v3_spec = Selenium::Remote::Spec->new()->get_cmds();

    foreach my $key ( keys(%$v2_spec) ) {
        print "v2 $key NOT present in v3 spec!!!\n"
          unless any { $_ eq $key } keys(%$v3_spec);
    }
    foreach my $key ( keys(%$v3_spec) ) {
        print "v3 $key NOT present in v2 spec!!!\n"
          unless any { $_ eq $key } keys(%$v2_spec);
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Spec - Implement commands for Selenium::Remote::Driver

=head1 VERSION

version 1.39

=head1 DESCRIPTION

Defines all the HTTP endpoints available to execute on a selenium server.

If you have either a customized Selenium Server, or want new features
you should update the _cmds hash.

=for Pod::Coverage *EVERYTHING*

=head1 Webdriver 3 capabilities

WD3 giveth and taketh away some caps.  Here's all you get:

    Browser name:                     "browserName"             string  Identifies the user agent.
    Browser version:                  "browserVersion"          string  Identifies the version of the user agent.
    Platform name:                    "platformName"            string  Identifies the operating system of the endpoint node.
    Accept insecure TLS certificates: "acceptInsecureCerts"     boolean Indicates whether untrusted and self-signed TLS certificates are implicitly trusted on navigation for the duration of the session.
    Proxy configuration:              "proxy"                   JSON    Defines the current session’s proxy configuration.

New Stuff:

    Page load strategy:               "pageLoadStrategy"        string  Defines the current session’s page load strategy.
    Window dimensioning/positioning:  "setWindowRect"           boolean Indicates whether the remote end supports all of the commands in Resizing and Positioning Windows.
    Session timeouts configuration:   "timeouts"                JSON    Describes the timeouts imposed on certain session operations.
    Unhandled prompt behavior:        "unhandledPromptBehavior" string  Describes the current session’s user prompt handler.

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
