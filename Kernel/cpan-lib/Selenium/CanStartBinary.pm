package Selenium::CanStartBinary;
$Selenium::CanStartBinary::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Teach a WebDriver how to start its own binary aka no JRE!
use File::Spec;
use Selenium::CanStartBinary::ProbePort
  qw/find_open_port_above find_open_port probe_port/;
use Selenium::Firefox::Binary qw/setup_firefox_binary_env/;
use Selenium::Waiter qw/wait_until/;
use Moo::Role;

use constant IS_WIN => $^O eq 'MSWin32';


requires 'binary';


requires 'binary_port';


requires '_binary_args';


has '_real_binary' => (
    is      => 'lazy',
    builder => sub {
        my ($self) = @_;

        if ( $self->_is_old_ff ) {
            return $self->firefox_binary;
        }
        else {
            return $self->binary;
        }
    }
);

has '_is_old_ff' => (
    is      => 'lazy',
    builder => sub {
        my ($self) = @_;

        return $self->isa('Selenium::Firefox') && !$self->marionette_enabled;
    }
);

has '+port' => (
    is      => 'lazy',
    builder => sub {
        my ($self) = @_;

        if ( $self->_real_binary ) {
            if ( $self->fixed_ports ) {
                return find_open_port( $self->binary_port );
            }
            else {
                return find_open_port_above( $self->binary_port );
            }
        }
        else {
            return 4444;
        }
    }
);


has 'fixed_ports' => (
    is      => 'lazy',
    default => sub { 0 }
);


has custom_args => (
    is        => 'lazy',
    predicate => 1,
    default   => sub { '' }
);

has 'marionette_port' => (
    is      => 'lazy',
    builder => sub {
        my ($self) = @_;

        if ( $self->_is_old_ff ) {
            return 0;
        }
        else {
            if ( $self->fixed_ports ) {
                return find_open_port( $self->marionette_binary_port );
            }
            else {
                return find_open_port_above( $self->marionette_binary_port );
            }
        }
    }
);


has startup_timeout => (
    is      => 'lazy',
    default => sub { 10 }
);


has 'binary_mode' => (
    is        => 'lazy',
    init_arg  => undef,
    builder   => 1,
    predicate => 1
);

has 'try_binary' => (
    is      => 'lazy',
    default => sub { 0 },
    trigger => sub {
        my ($self) = @_;
        $self->binary_mode if $self->try_binary;
    }
);


has 'window_title' => (
    is       => 'lazy',
    init_arg => undef,
    builder  => sub {
        my ($self) = @_;
        my ( undef, undef, $file ) =
          File::Spec->splitpath( $self->_real_binary );
        my $port = $self->port;

        return $file . ':' . $port;
    }
);


has '_command' => (
    is       => 'lazy',
    init_arg => undef,
    builder  => sub {
        my ($self) = @_;
        return $self->_construct_command;
    }
);


has 'logfile' => (
    is      => 'lazy',
    default => sub {
        return '/nul' if IS_WIN;
        return '/dev/null';
    }
);

sub BUILDARGS {

    # There's a bit of finagling to do to since we can't ensure the
    # attribute instantiation order. To decide whether we're going into
    # binary mode, we need the remote_server_addr and port. But, they're
    # both lazy and only instantiated immediately before S:R:D's
    # remote_conn attribute. Once remote_conn is set, we can't change it,
    # so we need the following order:
    #
    #     parent: remote_server_addr, port
    #     role:   binary_mode (aka _build_binary_mode)
    #     parent: remote_conn
    #
    # Since we can't force an order, we introduced try_binary which gets
    # decided during BUILDARGS to tip us off as to whether we should try
    # binary mode or not.
    my ( undef, %args ) = @_;

    if ( !exists $args{remote_server_addr} && !exists $args{port} ) {
        $args{try_binary} = 1;

        # Windows may throw a fit about invalid pointers if we try to
        # connect to localhost instead of 127.1
        $args{remote_server_addr} = '127.0.0.1';
    }
    else {
        $args{try_binary}  = 0;
        $args{binary_mode} = 0;
    }

    return {%args};
}

sub _build_binary_mode {
    my ($self) = @_;

    # We don't know what to do without a binary driver to start up
    return unless $self->_real_binary;

    # Either the user asked for 4444, or we couldn't find an open port
    my $port = $self->port + 0;
    return if $port == 4444;
    if ( $self->fixed_ports && $port == 0 ) {
        die 'port '
          . $self->binary_port
          . ' is not free and have requested fixed ports';
    }

    $self->_handle_firefox_setup($port);

    system( $self->_command );

    my $success =
      wait_until { probe_port($port) } timeout => $self->startup_timeout;
    if ($success) {
        return 1;
    }
    else {
        die 'Unable to connect to the '
          . $self->_real_binary
          . ' binary on port '
          . $port;
    }
}

sub _handle_firefox_setup {
    my ( $self, $port ) = @_;

    # This is a no-op for other browsers
    return unless $self->isa('Selenium::Firefox');

    my $user_profile =
        $self->has_firefox_profile
      ? $self->firefox_profile
      : 0;

    my $profile =
      setup_firefox_binary_env( $port, $self->marionette_port, $user_profile );

    if ( $self->_is_old_ff ) {

        # For non-geckodriver/non-marionette, we want to get rid of
        # the profile so that we don't accidentally zip it and encode
        # it down the line while Firefox is trying to read from it.
        $self->clear_firefox_profile if $self->has_firefox_profile;
    }
    else {
       # For geckodriver/marionette, we keep the enhanced profile around because
       # we need to send it to geckodriver as a zipped b64-encoded
       # directory.
        $self->firefox_profile($profile);
    }
}

sub shutdown_binary {
    my ($self) = @_;

    return unless $self->auto_close();
    if ( defined $self->session_id ) {
        $self->quit();
    }
    if ( $self->has_binary_mode && $self->binary_mode ) {

        # Tell the binary itself to shutdown
        my $port = $self->port;
        my $ua   = $self->ua;
        $ua->get( 'http://127.0.0.1:' . $port . '/wd/hub/shutdown' );

        # Close the orphaned command windows on windows
        $self->shutdown_windows_binary;
        $self->shutdown_unix_binary;
    }

}

sub shutdown_unix_binary {
    my ($self) = @_;
    if (!IS_WIN) {
        my $cmd = "lsof -t -i :".$self->port();
        my ( $pid ) = grep { $_ && $_ ne $$ } split( /\s+/, scalar `$cmd` );
        if ($pid) {
            print "Killing Driver PID $pid listening on port "
              . $self->port . "...\n";
            eval { kill 'KILL', $pid };
            warn
"Could not kill driver process! you may have to clean up manually."
              if $@;
        }
    }
}

sub shutdown_windows_binary {
    my ($self) = @_;

    if (IS_WIN) {
        if ( $self->_is_old_ff ) {

            # FIXME: Blech, handle a race condition that kills the
            # driver before it's finished cleaning up its sessions. In
            # particular, when the perl process ends, it wants to
            # clean up the temp directory it created for the Firefox
            # profile. But, if the Firefox process is still running,
            # it will have a lock on the temp profile directory, and
            # perl will get upset. This "solution" is _very_ bad.
            sleep(2);

            # Firefox doesn't have a Driver/Session architecture - the
            # only thing running is Firefox itself, so there's no
            # other task to kill.
            return;
        }
        system( 'taskkill /FI "WINDOWTITLE eq '
              . $self->window_title
              . '" > nul 2>&1' );
    }
}

sub DEMOLISH {
    my ( $self, $in_gd ) = @_;

    # if we're in global destruction, all bets are off.
    return if $in_gd;
    $self->shutdown_binary;
}

sub _construct_command {
    my ($self) = @_;
    my $executable = $self->_real_binary;

    # Executable path names may have spaces
    $executable = '"' . $executable . '"';

    # The different binaries take different arguments for proper setup
    $executable .= $self->_binary_args;
    if ( $self->has_custom_args ) {
        $executable .= ' ' . $self->custom_args;
    }

    # Handle Windows vs Unix discrepancies for invoking shell commands
    my ( $prefix, $suffix ) = ( $self->_cmd_prefix, $self->_cmd_suffix );
    return join( ' ', ( $prefix, $executable, $suffix ) );
}

sub _cmd_prefix {
    my ($self) = @_;

    my $prefix = '';
    if (IS_WIN) {
        $prefix = 'start "' . $self->window_title . '"';

        if ( $self->_is_old_ff ) {

            # For older versions of Firefox that run without
            # marionette, the command we're running actually starts up
            # the browser itself, so we don't want to minimize it.
            return $prefix;
        }
        else {
            # If we're firefox with marionette, or any other browser,
            # the command we're running is the driver, and we don't
            # need want the command window in the foreground.
            return $prefix . ' /MIN ';
        }
    }
    return $prefix;
}

sub _cmd_suffix {
    my ($self) = @_;
    return " > " . $self->logfile . " 2>&1 " if IS_WIN;
    return " > " . $self->logfile . " 2>&1 &";
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::CanStartBinary - Teach a WebDriver how to start its own binary aka no JRE!

=head1 VERSION

version 1.39

=head1 DESCRIPTION

This role takes care of the details for starting up a Webdriver
instance. It does not do any downloading or installation of any sort -
you're still responsible for obtaining and installing the necessary
binaries into your C<$PATH> for this role to find. You may be
interested in L<Selenium::Chrome>, L<Selenium::Firefox>, or
L<Selenium::PhantomJS> if you're looking for classes that already
consume this role.

The role determines whether or not it should try to do its own magic
based on whether the consuming class is instantiated with a
C<remote_server_addr> and/or C<port>.

    # We'll start up the Chrome binary for you
    my $chrome_via_binary = Selenium::Chrome->new;

    # Look for a selenium server running on 4444.
    my $chrome_via_server = Selenium::Chrome->new( port => 4444 );

If they're missing, we assume the user wants to use a webdriver
directly and act accordingly. We handle finding the proper associated
binary (or you can specify it with L</binary>), figuring out what
arguments it wants, setting up any necessary environments, and
starting up the binary.

There's a number of TODOs left over - namely Windows support is
severely lacking, and we're pretty naive when we attempt to locate the
executables on our own.

In the following documentation, C<required> refers to when you're
consuming the role, not the C<required> when you're instantiating a
class that has already consumed the role.

=head1 ATTRIBUTES

=head2 binary

Required: Specify the path to the executable in question, or the name
of the executable for us to find via L<File::Which/which>.

=head2 binary_port

Required: Specify a default port that for the webdriver binary to try
to bind to. If that port is unavailable, we'll probe above that port
until we find a valid one.

=head2 _binary_args

Required: Specify the arguments that the particular binary needs in
order to start up correctly. In particular, you may need to tell the
binary about the proper port when we start it up, or that it should
use a particular prefix to match up with the behavior of the Remote
Driver server.

If your binary doesn't need any arguments, just have the default be an
empty string.

=head2 port

The role will attempt to determine the proper port for us. Consuming
roles should set a default port in L</binary_port> at which we will
begin searching for an open port.

Note that if we cannot locate a suitable L</binary>, port will be set
to 4444 so we can attempt to look for a Selenium server at
C<127.0.0.1:4444>.

=head2 fixed_ports

Optional: By default, if binary_port and marionette_port are not free
a higher free port is probed and acquired if possible, until a free one
if found or a timeout is exceeded.

    my $driver1 = Selenium::Chrome->new;
    my $driver2 = Selenium::Chrome->new( port => 1234 );

The default behavior can be overridden. In this case, only the default
or given binary_port and marionette_port are probed, without probing
higher ports. This ensures that either the default or given port will be
assigned, or no port will be assigned at all.

    my $driver1 = Selenium::Chrome->new( fixed_ports => 1 );
    my $driver2 = Selenium::Chrome->new( port => 1234, fixed_ports => 1);

=head2 custom_args

Optional: If you want to pass additional options to the binary when it
starts up, you can add that here. For example, if your binary accepts
an argument on the command line like C<--log-path=/path/to/log>, and
you'd like to specify that the binary uses that option, you could do:

    my $chrome = Selenium::Chrome->new(
        custom_args => '--log-path=/path/to/log'
    );

To specify multiple arguments, just include them all in the string.

=head2 startup_timeout

Optional: you can modify how long we will wait for the binary to start
up. By default, we will start the binary and check the intended
destination port for 10 seconds before giving up. If the machine
you're using to run your browsers is slower or smaller, you may need
to increase this timeout.

The following:

    my $f = Selenium::Firefox->new(
        startup_timeout => 60
    );

will wait up to 60 seconds for the firefox binary to respond on the
proper port. To use this constructor option, you should specify a time
in seconds as an integer, and it will be passed to the arguments
section of a L<Selenium::Waiter/wait_until> subroutine call.

=head2 binary_mode

Mostly intended for internal use, its builder coordinates all the side
effects of interacting with the binary: locating the executable,
finding an open port, setting up the environment, shelling out to
start the binary, and ensuring that the webdriver is listening on the
correct port.

If all of the above steps pass, it will return truthy after
instantiation. If any of them fail, it should return falsy and the
class should attempt normal L<Selenium::Remote::Driver> behavior.

=head2 window_title

Intended for internal use: this will build us a unique title for the
background binary process of the Webdriver. Then, when we're cleaning
up, we know what the window title is that we're going to C<taskkill>.

=head2 command

Intended for internal use: this read-only attribute is built by us,
but it can be useful after instantiation to see exactly what command
was run to start the webdriver server.

    my $f = Selenium::Firefox->new;
    say $f->_command;

=head2 logfile

Normally we log what occurs in the driver to /dev/null (or /nul on windows).
Setting this will redirect it to the provided file.

=for Pod::Coverage *EVERYTHING*

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=item *

L<Selenium::Chrome|Selenium::Chrome>

=item *

L<Selenium::Firefox|Selenium::Firefox>

=item *

L<Selenium::PhantomJS|Selenium::PhantomJS>

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
