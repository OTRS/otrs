package Selenium::Waiter;
$Selenium::Waiter::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Provides a utility wait_until function
use Try::Tiny;
require Exporter;
our @ISA    = qw/Exporter/;
our @EXPORT = qw/wait_until/;


sub wait_until (&%) {
    my $assert = shift;
    my $args   = {
        timeout  => 30,
        interval => 1,
        debug    => 0,
        die      => 0,
        @_
    };

    my $start               = time;
    my $timeout_not_elapsed = sub {
        my $elapsed = time - $start;
        return $elapsed < $args->{timeout};
    };

    my $exception = '';
    while ( $timeout_not_elapsed->() ) {
        my $assert_ret;
        my $try_ret = try {
            $assert_ret = $assert->();
            return $assert_ret if $assert_ret;
        }
        catch {
            $exception = $_;
            die $_  if $args->{die};
            warn $_ if $args->{debug};
            return '';
        }
        finally {
            if ( !$assert_ret ) {
                sleep( $args->{interval} );
            }
        };

        return $try_ret if $try_ret;
    }

    # No need to repeat ourselves if we're already debugging.
    warn $exception if $exception && !$args->{debug};
    return '';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Waiter - Provides a utility wait_until function

=head1 VERSION

version 1.39

=head1 SYNOPSIS

    use Selenium::Waiter qw/wait_until/;
    my $d = Selenium::Remote::Driver->new;

    my $div = wait_until { $d->find_element('div', 'css') };

=head1 FUNCTIONS

=head2 wait_until

Exported by default, it takes a BLOCK (required) and optionally a
hash of configuration params. It uses a prototype to take its
arguments, so usage looks look like:

    use Selenium::Waiter;
    my $div = wait_until { $driver->find_element('div', 'css') };

The above snippet will search for C<css=div> for thirty seconds; if it
ever finds the element, it will immediately return. More generally,
Once the BLOCK returns anything truthy, the C<wait_until> will stop
evaluating and the return of the BLOCK will be returned to you. If the
BLOCK never returns a truthy value, we'll wait until the elapsed time
has increased past the timeout and then return an empty string C<''>.

B<Achtung!> Please make sure that the BLOCK you pass in can be
executed in a timely fashion. For Webdriver, that means that you
should set the appropriate C<implicit_wait> timeout low (a second or
less!)  so that we can rerun the assert sub repeatedly. We don't do
anything fancy behind the scenes: we just execute the BLOCK you pass
in and sleep between iterations. If your BLOCK actively blocks for
thirty seconds, like a C<find_element> would do with an
C<implicit_wait> of 30 seconds, we won't be able to help you at all -
that blocking behavior is on the webdriver server side, and is out of
our control. We'd run one iteration, get blocked for thirty seconds,
and return control to you at that point.

=head4 Dying

PLEASE check the return value before proceeding, as we unwisely
suppress any attempts your BLOCK may make to die or croak. The BLOCK
you pass is called in a L<Try::Tiny/try>, and if any of the
invocations of your function throw and the BLOCK never becomes true,
we'll carp exactly once at the end immediately before returning
false. We overwrite the death message from each iteration, so at the
end, you'll only see the most recent death message.

    # warns once after thirty seconds: "kept from dying";
    wait_until { die 'kept from dying' };

The output of C<die>s from each iteration can be exposed if you wish
to see the massacre:

    # carps: "kept from dying" once a second for thirty seconds
    wait_until { die 'kept from dying' } debug => 1;

If you want to die anyways, just pass die => 1 to wait_until instead:

    # Dies on the first failure, do your own error handling:
    wait_until { die 'oops' } die => 1;

=head4 Timeouts and Intervals

You can also customize the timeout, and/or the retry interval between
iterations.

    # prints hi three four times at 0, 3, 6, and 9 seconds
    wait_until { print 'hi'; '' } timeout => 10, interval => 3;

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
