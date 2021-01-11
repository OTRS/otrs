package Selenium::Firefox;
$Selenium::Firefox::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Use FirefoxDriver without a Selenium server
use Moo;
use Carp;
use Selenium::Firefox::Binary qw/firefox_path/;
use Selenium::CanStartBinary::FindBinary
  qw/coerce_simple_binary coerce_firefox_binary/;
extends 'Selenium::Remote::Driver';


has '+browser_name' => (
    is      => 'ro',
    default => sub { 'firefox' }
);


has 'binary' => (
    is        => 'lazy',
    coerce    => \&coerce_simple_binary,
    default   => sub { 'geckodriver' },
    predicate => 1
);


has 'binary_port' => (
    is      => 'lazy',
    default => sub { 9090 }
);


has '_binary_args' => (
    is      => 'lazy',
    builder => sub {
        my ($self) = @_;

        if ( $self->marionette_enabled ) {
            my $args =
                ' --port '
              . $self->port
              . ' --marionette-port '
              . $self->marionette_port
              . ' --binary "'
              . $self->firefox_binary . '"';

            return $args;
        }
        else {
            return ' -no-remote';
        }
    }
);

has '+wd_context_prefix' => (
    is      => 'ro',
    default => sub {
        my ($self) = @_;

        if ( $self->marionette_enabled ) {
            return '';
        }
        else {
            return '/hub';
        }

    }
);


has 'marionette_binary_port' => (
    is      => 'lazy',
    default => sub { 2828 }
);


has 'marionette_enabled' => (
    is      => 'lazy',
    default => 1
);


has 'firefox_binary' => (
    is        => 'lazy',
    coerce    => \&coerce_firefox_binary,
    predicate => 1,
    builder   => 'firefox_path'
);

has '_execute_script_suffix' => (
    is      => 'lazy',
    default => 'Gecko'
);


sub get_context {
    my $self = shift;

    if ( $self->_is_old_ff ) {
        return 0;
    }
    my $res = { 'command' => 'getContext' };
    return $self->_execute_command($res);
}


sub set_context {
    my ( $self, $context ) = @_;

    if ( $self->_is_old_ff ) {
        return 0;
    }
    if ( not defined $context ) {
        croak "Expecting context";
    }
    if ( $context !~ m/chrome|content/i ) {
        croak "Expecting context value: chrome or content";
    }
    my $res = { 'command' => 'setContext' };
    return $self->_execute_command( $res, { context => $context } );
}

with 'Selenium::CanStartBinary';


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Firefox - Use FirefoxDriver without a Selenium server

=head1 VERSION

version 1.39

=head1 SYNOPSIS

    # These two are the same, and will only work with Firefox 48+
    my $driver = Selenium::Firefox->new;
    $driver = Selenium::Firefox->new( marionette_enabled => 1 );

    #Do stuff...

    $driver->shutdown_binary;

    # For Firefox 47 and older, disable marionette:
    $driver = Selenium::Firefox->new( marionette_enabled => 0 );
    $driver->shutdown_binary;

=head1 DESCRIPTION

B<Breaking Changes:> There are breaking changes in v1.0+ of this
module if you're using it to start FF47; please see L</"BREAKING
CHANGES">. You can ignore this if you're using v1.0+ of this module to
start FF48.

This class allows you to use the FirefoxDriver without needing the JRE
or a selenium server running. Unlike starting up an instance of
S::R::D, do not pass the C<remote_server_addr> and C<port> arguments,
and we will search for the Firefox executable in your C<$PATH>. We'll
try to start the binary, connect to it, and shut it down at the end of
the test.

If the Firefox application is not found in the expected places, we'll
fall back to the default L<Selenium::Remote::Driver> behavior of
assuming defaults of 127.0.0.1:4444 after waiting a few seconds.

If you specify a remote server address, or a port, our assumption is
that you are doing standard S::R::D behavior and we will not attempt
any binary startup.

If you're curious whether your Selenium::Firefox instance is using a
separate Firefox binary, or through the selenium server, you can check
the value of the C<binary_mode> attr after instantiation.

=head1 ATTRIBUTES

=head2 binary

Optional: specify the path to the C<geckodriver> binary - this is NOT
the path to the Firefox browser. To specify the path to your Firefox
browser binary, see the L</firefox_binary> attr.

For Firefox 48 and greater, this is the path to your C<geckodriver>
executable. If you don't specify anything, we'll search for
C<geckodriver> in your C<$PATH>.

For Firefox 47 and older, this attribute does not apply, because the
older FF browsers do not use the separate driver binary startup.

=head2 binary_port

Optional: specify the port that we should bind to. If you don't
specify anything, we'll default to the driver's default port. Since
there's no a priori guarantee that this will be an open port, this is
_not_ necessarily the port that we end up using - if the port here is
already bound, we'll search above it until we find an open one.

See L<Selenium::CanStartBinary/port> for more details, and
L<Selenium::Remote::Driver/port> after instantiation to see what the
actual port turned out to be.

=head2 firefox_profile

Optional: Pass in an instance of L<Selenium::Firefox::Profile>
pre-configured as you please. The preferences you specify will be
merged with the ones necessary for setting up webdriver, and as a
result some options may be overwritten or ignored.

    my $profile = Selenium::Firefox::Profile->new;
    my $firefox = Selenium::Firefox->new(
        firefox_profile => $profile
    );

=head2 marionette_binary_port

Optional: specify the port that we should bind marionette to. If you don't
specify anything, we'll default to the marionette's default port. Since
there's no a priori guarantee that this will be an open port, this is
_not_ necessarily the port that we end up using - if the port here is
already bound, we'll search above it until we find an open one.

    Selenium::Firefox->new(
        marionette_enabled     => 1,
        marionette_binary_port => 12345,
    );

Attempting to specify a C<marionette_binary_port> in conjunction with
setting C<marionette_enabled> does not make sense and will most likely
not do anything useful.

=head2 marionette_enabled

Optional: specify whether
L<marionette|https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette>
should be enabled or not. By default, marionette is enabled, which
assumes you are running with Firefox 48 or newer. To use this module to
start Firefox 47 or older, you must pass C<< marionette_enabled => 0 >>.

    my $ff48 = Selenium::Firefox->new( marionette_enabled => 1 ); # defaults to 1
    my $ff47 = Selenium::Firefox->new( marionette_enabled => 0 );

=head2 firefox_binary

Optional: specify the path to the Firefox browser executable. Although
we will attempt to locate this in your C<$PATH>, you may specify it
explicitly here. Note that path here must point to a file that exists
and is executable, or we will croak.

For Firefox 48 and newer, this will be passed to C<geckodriver> such
that it will attempt to start up the Firefox at the specified path. If
you do not specify anything, we will look for the Firefox browser on
our own in the normal places, but if the browser cannot be found,
we'll probably C<die> during instantiation.

For Firefox 47 and older, this browser path should be the file that we
directly start up.

=head2 custom_args

Optional: specify any additional command line arguments you'd like
invoked during the binary startup. See
L<Selenium::CanStartBinary/custom_args> for more information.

For Firefox 48 and newer, these arguments will be passed to
geckodriver during start up.

For Firefox 47 and older, these arguments will be passed to the
Firefox browser during start up.

=head2 startup_timeout

Optional: specify how long to wait for the binary to start itself and
listen on its port. The default duration is arbitrarily 10 seconds. It
accepts an integer number of seconds to wait: the following will wait
up to 20 seconds:

    Selenium::Firefox->new( startup_timeout => 20 );

See L<Selenium::CanStartBinary/startup_timeout> for more information.

=head2 fixed_ports

Optional: Throw instead of searching for additional ports; see
L<Selenium::CanStartBinary/fixed_ports> for more info.

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

=for Pod::Coverage has_binary

=for Pod::Coverage has_firefox_binary

=head1 BREAKING CHANGES

In version v1.0+ and newer, the default behavior is to enable
marionette & geckodriver mode. This means that an existing script that
works with v0.2701 and Firefox v47 will require modification if you
upgrade Selenium::Firefox to v1.0+. That is,

    # v0.2701 of Selenium::Firefox works with FF47 like such; this will not
    # work for FF47 after upgrade:
    my $fx47_old = Selenium::Firefox->new;
    ...
    $fx47_old->shutdown_binary;

    # v1.0 of Selenium::Firefox works with FF47 like this
    my $fx47_new = Selenium::Firefox->new( marionette_enabled => 0);
    ...
    $fx47_new->shutdown_binary;

We default to assuming FF48 and geckodriver mode because all
forthcoming versions of the Firefox browser will be using the
geckodriver architecture, and also because that's consistent with the
rest of the driver setups, which all have separate driver binaries
apart from the browser itself. This means that:

    # v0.2701 of Selenium::Firefox cannot start up FF48 at all

    # v1.0+ of Selenium::Firefox works with FF48+ like this:
    my $fx48 = Selenium::Firefox->new;

As with the other drivers, Selenium::Firefox in marionette/geckodriver
mode requires a C<geckodriver> executable in the path or provided
during startup, and it will also attempt to find the path to your
Firefox browser. During testing, we found that it was necessary for us
to pass the Firefox browser file path to the C<geckodriver> executable
during start up, or else C<geckodriver> would have trouble finding
Firefox.

=head2 get_context

 Description:
    Firefox extension: Retrieve browser's scope (chrome or content).
    Chrome is a privileged scope where you can access things like the
    Firefox UI itself. Content scope is where things like webpages live.

 Output:
    STRING - context {CHROME|CONTENT}

 Usage:
    print $firefox_driver->get_context();

=head2 set_context

 Description:
    Firefox extension: Set browser's scope (chrome or content).
    Chrome is a privileged scope where you can access things like the
    Firefox UI itself. Content scope is where things like webpages live.

 Input:
    Required:
        <STRING> - context {CHROME|CONTENT}

 Usage:
    $firefox_driver->set_context( $context );

 Output:
    BOOLEAN - success or failure

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
