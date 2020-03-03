package Crypt::Random::Source::Base::Proc;
# ABSTRACT: Base class for helper processes (e.g. C<openssl>)

our $VERSION = '0.14';

use Moo;

extends qw(Crypt::Random::Source::Base::Handle);

use Capture::Tiny 0.08 qw(capture);
use File::Spec;
use IO::File 1.14;
use Types::Standard qw(Str);
use namespace::clean;

use 5.008;

has command => ( is => "rw", required => 1 );
has search_path => ( is => 'rw', isa => Str, lazy => 1, builder => 1);

# This is a scalar so that people can customize it (which they would
# particularly need to do on Windows).
our $TAINT_PATH =
    '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin';

sub _build_search_path {
    # In taint mode it's not safe to use $ENV{PATH}.
    if (${^TAINT}) {
        return $TAINT_PATH;
    }
    return $ENV{PATH};
}

sub open_handle {
    my $self = shift;

    my $cmd = $self->command;
    my @cmd = ref $cmd ? @$cmd : $cmd;
    my $retval;
    local $ENV{PATH} = $self->search_path;
    my ($stdout, $stderr) = capture { $retval = system(@cmd) };
    chomp($stderr);
    if ($retval) {
        my $err = join(' ', @cmd) . ": $! ($?)";
        if ($stderr) {
            $err .= "\n$stderr";
        }
        die $err;
    }
    warn $stderr if $stderr;

    my $fh = IO::File->new(\$stdout, '<');

    return $fh;
}

1;

=pod

=encoding UTF-8

=head1 NAME

Crypt::Random::Source::Base::Proc - Base class for helper processes (e.g. C<openssl>)

=head1 VERSION

version 0.14

=head1 SYNOPSIS

    use Moo;
    extends qw(Crypt::Random::Source::Base::Proc);

    has '+command' => ( default => ... );

=head1 DESCRIPTION

This is a base class for using command line utilities which output random data
on STDOUT as L<Crypt::Random::Source> objects.

=head1 ATTRIBUTES

=head2 command

An array reference or string that is the command to run.

=head1 METHODS

=head2 open_handle

Opens a pipe for reading using C<command>.

=head1 SUPPORT

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Crypt-Random-Source>
(or L<bug-Crypt-Random-Source@rt.cpan.org|mailto:bug-Crypt-Random-Source@rt.cpan.org>).

=head1 AUTHOR

יובל קוג'מן (Yuval Kogman) <nothingmuch@woobling.org>

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2008 by Yuval Kogman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__


# ex: set sw=4 et:
