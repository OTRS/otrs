package IO::Interactive;

use strict;
use warnings;

$IO::Interactive::VERSION = '1.022';

sub is_interactive {
    my ($out_handle) = (@_, select);    # Default to default output handle

    # Not interactive if output is not to terminal...
    return 0 if not -t $out_handle;

    # If *ARGV is opened, we're interactive if...
    if ( tied(*ARGV) or defined(fileno(ARGV)) ) { # this is what 'Scalar::Util::openhandle *ARGV' boils down to

        # ...it's currently opened to the magic '-' file
        return -t *STDIN if defined $ARGV && $ARGV eq '-';

        # ...it's at end-of-file and the next file is the magic '-' file
        return @ARGV>0 && $ARGV[0] eq '-' && -t *STDIN if eof *ARGV;

        # ...it's directly attached to the terminal
        return -t *ARGV;
    }

    # If *ARGV isn't opened, it will be interactive if *STDIN is attached
    # to a terminal.
    else {
        return -t *STDIN;
    }
}

local (*DEV_NULL, *DEV_NULL2);
my $dev_null;
BEGIN {
    pipe *DEV_NULL, *DEV_NULL2
        or die "Internal error: can't create null filehandle";
    $dev_null = \*DEV_NULL;
}

sub interactive {
    my ($out_handle) = (@_, \*STDOUT);      # Default to STDOUT
    return &is_interactive ? $out_handle : $dev_null;
}

sub _input_pending_on {
    my ($fh) = @_;
    my $read_bits = "";
    my $bit = fileno($fh);
    return if $bit < 0;
    vec($read_bits, fileno($fh), 1) = 1;
    select $read_bits, undef, undef, 0.1;
    return $read_bits;
}

sub busy (&) {
    my ($block_ref) = @_;

    # Non-interactive busy-ness is easy...just do it
    if (!is_interactive()) {
        $block_ref->();
        open my $fh, '<', \ "";
        return $fh;
    }

    # Otherwise fork off an interceptor process...
    my ($read, $write);
    pipe $read, $write;
    my $child = fork;

    # Within that interceptor process...
    if (!$child) {
        # Prepare to send back any intercepted input...
        use IO::Handle;
        close $read;
        $write->autoflush(1);

        # Intercept that input...
        while (1) {
            if (_input_pending_on(\*ARGV)) {
                # Read it...
                my $res = <ARGV>;

                # Send it back to the parent...
                print {$write} $res;

                # Admonish them for not waiting...
                print {*STDERR} "That input was ignored. ",
                                "Please don't press any keys yet.\n";
            }
        }
        exit;
    }

    # Meanwhile, back in the parent...
    close $write;

    # Temporarily close the input...
    local *ARGV;
    open *ARGV, '<', \ "";

    # Do the job...
    $block_ref->();

    # Take down the interceptor...
    kill 9, $child;
    wait;

    # Return whatever the interceptor caught...
    return $read;
}

sub import {
    my ($package) = shift;
    my $caller = caller;

    # Export each sub if it's requested...
    for my $request ( @_ ) {
        no strict 'refs';
        my $impl = *{$package.'::'.$request}{CODE};
        if(!$impl || $request =~ m/\A _/xms) {
            require Carp;
            Carp::croak("Unknown subroutine ($request()) requested");
        }
        *{$caller.'::'.$request} = $impl;
    }
}

1; # Magic true value required at end of module
__END__

=encoding utf8

=head1 NAME

IO::Interactive - Utilities for interactive I/O

=head1 VERSION

This document describes IO::Interactive version 1.02

=head1 SYNOPSIS

    use IO::Interactive qw(is_interactive interactive busy);

    if ( is_interactive() ) {
        print "Running interactively\n";
    }

    # or...

    print {interactive} "Running interactively\n";


    $fh = busy {
        do_noninteractive_stuff();
    }


=head1 DESCRIPTION

This module provides three utility subroutines that make it easier to
develop interactive applications...

=over

=item C<is_interactive()>

This subroutine returns true if C<*ARGV> and the currently selected
filehandle (usually C<*STDOUT>) are connected to the terminal. The
test is considerably more sophisticated than:

    -t *ARGV && -t *STDOUT

as it takes into account the magic behaviour of C<*ARGV>.

You can also pass C<is_interactive> a writable filehandle, in which case it
requires that filehandle be connected to a terminal (instead of the
currently selected).  The usual suspect here is C<*STDERR>:

    if ( is_interactive(*STDERR) ) {
        carp $warning;
    }


=item C<interactive()>

This subroutine returns C<*STDOUT> if C<is_interactive> is true. If
C<is_interactive()> is false, C<interactive> returns a filehandle that
does not print.

This makes it easy to create applications that print out only when the
application is interactive:

    print {interactive} "Please enter a value: ";
    my $value = <>;

You can also pass C<interactive> a writable filehandle, in which case it
writes to that filehandle if it is connected to a terminal (instead of
writing to C<*STDOUT>). Once again, the usual suspect is C<*STDERR>:

    print {interactive(*STDERR)} $warning;

=item C<busy {...}>

This subroutine takes a block as its single argument and executes that block.
Whilst the block is executed, C<*ARGV> is temporarily replaced by a closed
filehandle. That is, no input from C<*ARGV> is possible in a C<busy> block.
Furthermore, any attempts to send input into the C<busy> block through
C<*ARGV> is intercepted and a warning message is printed to C<*STDERR>.
The C<busy> call returns a filehandle that contains the intercepted input.

A C<busy> block is therefore useful to prevent attempts at input when the
program is busy at some non-interactive task.

=back

=head1 DIAGNOSTICS

=over

=item Unknown subroutine (%s) requested

This module only exports the three subroutines described above.
You asked for something else. Maybe you misspelled the subroutine you wanted.

=back

=head1 CONFIGURATION AND ENVIRONMENT

IO::Interactive requires no configuration files or environment variables.

=head1 DEPENDENCIES

This module requires the C<openhandle()> subroutine from the
Scalar::Util module.


=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to Github
L<https://github.com/briandfoy/io-interactive/issues>.

=head1 SOURCE AVAILABILITY

This code is in GitHub:

	https://github.com/briandfoy/io-interactive

=head1 AUTHOR

Damian Conway  C<< <DCONWAY@cpan.org> >>

Currently maintained by brian d foy C<< <bdfoy@cpan.org> >>.

1.01 patch DMUEY C<< dmuey@cpan.org >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005, Damian Conway C<< <DCONWAY@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
