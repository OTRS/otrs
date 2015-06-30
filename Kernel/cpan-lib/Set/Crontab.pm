# Copyright 2001 Abhijit Menon-Sen <ams@toroid.org>

package Set::Crontab;

use strict;
use Carp;
use vars qw( $VERSION );

$VERSION = '1.03';

sub _expand
{
    my (@list, @and, @not);
    my ($self, $spec, $range) = @_;

    # 1,2-4,*/3,!13,>9,<15
    foreach (split /,/, $spec) {
        my @pick;
        my $step = $1 if s#/(\d+)$##;

        # 0+"01" == 1
        if    (/^(\d+)$/)       { push @pick, 0+$1;          }
        elsif (/^\*$/)          { push @pick, @$range;       }
        elsif (/^(\d+)-(\d+)$/) { push @pick, 0+$1..0+$2;    } 
        elsif (/^!(\d+)$/)      { push @not,  "\$_ != 0+$1"; }
        elsif (/^([<>])(\d+)$/) { push @and,  "\$_ $1 0+$2"; }

        if ($step) {
            my $i;
            @pick = grep { defined $_ if $i++ % $step == 0 } @pick;
        }

        push @list, @pick;
    }

    if (@and) {
        my $and = join q{ && }, @and;
        push @list, grep { defined $_ if eval $and } @$range;
    }

    if (@not) {
        my $not = join q{ && }, @not;
        @list = grep { defined $_ if eval $not } (@list ? @list : @$range);
    }

    @list = sort { $a <=> $b } @list;
    return \@list;
}

sub _initialise
{
    my ($self, $spec, $range) = @_;
    return undef unless ref($self);

    croak "Usage: ".__PACKAGE__."->new(\$spec, [\@range])"
        unless defined $spec && ref($range) eq "ARRAY";

    $self->{LIST} = $self->_expand($spec, $range);
    $self->{HASH} = {map {$_ => 1} @{$self->{LIST}}};

    return $self;
};

sub new
{
    my $class = shift;
    my $self  = bless {}, ref($class) || $class;
    return $self->_initialise(@_);
}

sub contains
{
    my ($self, $num) = @_;

    croak "Usage: \$set->contains(\$num)" unless ref($self) && defined $num;
    return exists $self->{HASH}{$num};
}

sub list
{
    my $self = shift;

    croak "Usage: \$set->list()" unless ref($self);
    return @{$self->{LIST}};
}

1;
__END__

=head1 NAME

Set::Crontab - Expand crontab(5)-style integer lists

=head1 SYNOPSIS

$s = Set::Crontab->new("1-9/3,>15,>30,!23", [0..30]);

if ($s->contains(3)) { ... }

=head1 DESCRIPTION

Set::Crontab parses crontab-style lists of integers and defines some
utility functions to make it easier to deal with them.

=head2 Syntax

Numbers, ranges, *, and step values all work exactly as described in
L<crontab(5)>. A few extensions to the standard syntax are described
below.

=over 4

=item < and >

<N selects the elements smaller than N from the entire range, and adds
them to the set. >N does likewise for elements larger than N.

=item !

!N excludes N from the set. It applies to the other specified 
range; otherwise it applies to the specified ranges (i.e. "!3" with a
range of "1-10" corresponds to "1-2,4-10", but ">3,!7" in the same range
means "4-6,8-10").

=back

=head2 Functions

=over 4

=item new($spec, [@range])

Creates a new Set::Crontab object and returns a reference to it.

=item contains($num)

Returns true if C<$num> exists in the set.

=item list()

Returns the expanded list corresponding to the set. Elements are in
ascending order.

=back

The functions described above croak if they are called with incorrect
arguments.

=head1 SEE ALSO

L<crontab(5)>

=head1 AUTHOR

Abhijit Menon-Sen <ams@toroid.org>

Copyright 2001 Abhijit Menon-Sen <ams@toroid.org>

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
