package Module::Refresh;

use strict;
use vars qw( $VERSION %CACHE );

$VERSION = "0.17";

BEGIN {

    # Turn on the debugger's symbol source tracing
    $^P |= 0x10;

    # Work around bug in pre-5.8.7 perl where turning on $^P
    # causes caller() to be confused about eval {}'s in the stack.
    # (See http://rt.perl.org/rt3/Ticket/Display.html?id=35059 for more info.)
    eval 'sub DB::sub' if $] < 5.008007;
}

=head1 NAME

Module::Refresh - Refresh %INC files when updated on disk

=head1 SYNOPSIS

    # During each request, call this once to refresh changed modules:

    Module::Refresh->refresh;

    # Each night at midnight, you automatically download the latest
    # Acme::Current from CPAN.  Use this snippet to make your running
    # program pick it up off disk:

    $refresher->refresh_module('Acme/Current.pm');

=head1 DESCRIPTION

This module is a generalization of the functionality provided by
L<Apache::StatINC> and L<Apache::Reload>.  It's designed to make it
easy to do simple iterative development when working in a persistent
environment.

It does not require mod_perl.

=cut

=head2 new

Initialize the module refresher.

=cut

sub new {
    my $proto = shift;
    my $self = ref($proto) || $proto;
    $self->update_cache($_) for keys %INC;
    return ($self);
}

=head2 refresh

Refresh all modules that have mtimes on disk newer than the newest ones we've got.
Calls C<new> to initialize the cache if it had not yet been called.

Specifically, it will renew any module that was loaded before the previous call
to C<refresh> (or C<new>) and has changed on disk since then.  If a module was
both loaded for the first time B<and> changed on disk between the previous call 
and this one, it will B<not> be reloaded by this call (or any future one); you
will need to update the modification time again (by using the Unix C<touch> command or
making a change to it) in order for it to be reloaded.

=cut

sub refresh {
    my $self = shift;

    return $self->new if !%CACHE;

    foreach my $mod ( sort keys %INC ) {
        $self->refresh_module_if_modified($mod);
    }
    return ($self);
}

=head2 refresh_module_if_modified $module

If $module has been modified on disk, refresh it. Otherwise, do nothing


=cut

sub refresh_module_if_modified {
    my $self = shift;
    return $self->new if !%CACHE;
    my $mod = shift;

    if (!$INC{$mod}) {
        return;
    } elsif ( !$CACHE{$mod} ) {
        $self->update_cache($mod);
    } elsif ( $self->mtime( $INC{$mod} ) ne $CACHE{$mod} ) {
        $self->refresh_module($mod);
    }

}

=head2 refresh_module $module

Refresh a module.  It doesn't matter if it's already up to date.  Just do it.

Note that it only accepts module names like C<Foo/Bar.pm>, not C<Foo::Bar>.

=cut

sub refresh_module {
    my $self = shift;
    my $mod  = shift;

    $self->unload_module($mod);

    local $@;
    eval { require $mod; 1 } or warn $@;

    $self->update_cache($mod);

    return ($self);
}

=head2 unload_module $module

Remove a module from C<%INC>, and remove all subroutines defined in it.

=cut

sub unload_module {
    my $self = shift;
    my $mod  = shift;
    my $file = $INC{$mod};

    delete $INC{$mod};
    delete $CACHE{$mod};
    $self->unload_subs($file);

    return ($self);
}

=head2 mtime $file

Get the last modified time of $file in seconds since the epoch;

=cut

sub mtime {
    return join ' ', ( stat( $_[1] ) )[ 1, 7, 9 ];
}

=head2 update_cache $file

Updates the cached "last modified" time for $file.

=cut

sub update_cache {
    my $self      = shift;
    my $module_pm = shift;

    $CACHE{$module_pm} = $self->mtime( $INC{$module_pm} );
}

=head2 unload_subs $file

Wipe out subs defined in $file.

=cut

sub unload_subs {
    my $self = shift;
    my $file = shift;

    foreach my $sym ( grep { index( $DB::sub{$_}, "$file:" ) == 0 }
        keys %DB::sub )
    {

        warn "Deleting $sym from $file" if ( $sym =~ /freeze/ );
        eval { undef &$sym };
        warn "$sym: $@" if $@;
        delete $DB::sub{$sym};
        { no strict 'refs';
            if ($sym =~ /^(.*::)(.*?)$/) {
                delete *{$1}->{$2};
            }
        } 
    }

    return $self;
}

# "Anonymize" all our subroutines into unnamed closures; so we can safely
# refresh this very package.
BEGIN {
    no strict 'refs';
    foreach my $sym ( sort keys %{ __PACKAGE__ . '::' } ) {
        next
            if $sym eq
            'VERSION';    # Skip the version sub, inherited from UNIVERSAL
        my $code = __PACKAGE__->can($sym) or next;
        delete ${ __PACKAGE__ . '::' }{$sym};
        *$sym = sub { goto &$code };
    }

}

1;

=head1 BUGS

When we walk the symbol table to whack reloaded subroutines, we don't
have a good way to invalidate the symbol table properly, so we mess up
on things like global variables that were previously set.

=head1 SEE ALSO

L<Apache::StatINC>, L<Module::Reload>

=head1 COPYRIGHT

Copyright 2004,2011 by Jesse Vincent E<lt>jesse@bestpractical.comE<gt>,
Audrey Tang E<lt>audreyt@audreyt.orgE<gt>

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

