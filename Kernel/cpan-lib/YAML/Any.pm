package YAML::Any;

our $VERSION = '0.84';

use strict;
use Exporter ();

@YAML::Any::ISA       = 'Exporter';
@YAML::Any::EXPORT    = qw(Dump Load);
@YAML::Any::EXPORT_OK = qw(DumpFile LoadFile);

my @dump_options = qw(
    UseCode
    DumpCode
    SpecVersion
    Indent
    UseHeader
    UseVersion
    SortKeys
    AnchorPrefix
    UseBlock
    UseFold
    CompressSeries
    InlineSeries
    UseAliases
    Purity
    Stringify
);

my @load_options = qw(
    UseCode
    LoadCode
);

my @implementations = qw(
    YAML::XS
    YAML::Syck
    YAML::Old
    YAML
    YAML::Tiny
);

sub import {
    __PACKAGE__->implementation;
    goto &Exporter::import;
}

sub Dump {
    no strict 'refs';
    my $implementation = __PACKAGE__->implementation;
    for my $option (@dump_options) {
        my $var = "$implementation\::$option";
        my $value = $$var;
        local $$var;
        $$var = defined $value ? $value : ${"YAML::$option"};
    }
    return &{"$implementation\::Dump"}(@_);
}

sub DumpFile {
    no strict 'refs';
    my $implementation = __PACKAGE__->implementation;
    for my $option (@dump_options) {
        my $var = "$implementation\::$option";
        my $value = $$var;
        local $$var;
        $$var = defined $value ? $value : ${"YAML::$option"};
    }
    return &{"$implementation\::DumpFile"}(@_);
}

sub Load {
    no strict 'refs';
    my $implementation = __PACKAGE__->implementation;
    for my $option (@load_options) {
        my $var = "$implementation\::$option";
        my $value = $$var;
        local $$var;
        $$var = defined $value ? $value : ${"YAML::$option"};
    }
    return &{"$implementation\::Load"}(@_);
}

sub LoadFile {
    no strict 'refs';
    my $implementation = __PACKAGE__->implementation;
    for my $option (@load_options) {
        my $var = "$implementation\::$option";
        my $value = $$var;
        local $$var;
        $$var = defined $value ? $value : ${"YAML::$option"};
    }
    return &{"$implementation\::LoadFile"}(@_);
}

sub order {
    return @YAML::Any::_TEST_ORDER
        if @YAML::Any::_TEST_ORDER;
    return @implementations;
}

sub implementation {
    my @order = __PACKAGE__->order;
    for my $module (@order) {
        my $path = $module;
        $path =~ s/::/\//g;
        $path .= '.pm';
        return $module if exists $INC{$path};
        eval "require $module; 1" and return $module;
    }
    croak("YAML::Any couldn't find any of these YAML implementations: @order");
}

sub croak {
    require Carp;
    Carp::Croak(@_);
}

1;

=head1 NAME

YAML::Any - Pick a YAML implementation and use it.

=head1 SYNOPSIS

    use YAML::Any;
    $YAML::Indent = 3;
    my $yaml = Dump(@objects);

=head1 DESCRIPTION

There are several YAML implementations that support the Dump/Load API.
This module selects the best one available and uses it.

=head1 ORDER

Currently, YAML::Any will choose the first one of these YAML
implementations that is installed on your system:

    YAML::XS
    YAML::Syck
    YAML::Old
    YAML
    YAML::Tiny

=head1 OPTIONS

If you specify an option like:

    $YAML::Indent = 4;

And YAML::Any is using YAML::XS, it will use the proper variable:
$YAML::XS::Indent.

=head1 SUBROUTINES

Like all the YAML modules that YAML::Any uses, the following subroutines
are exported by default:

    Dump
    Load

and the following subroutines are exportable by request:

    DumpFile
    LoadFile

=head1 METHODS

YAML::Any provides the following class methods.

=over

=item YAML::Any->order;

This method returns a list of the current possible implementations that
YAML::Any will search for.

=item YAML::Any->implementation;

This method returns the implementation the YAML::Any will use. This
result is obtained by finding the first member of YAML::Any->order that
is either already loaded in C<%INC> or that can be loaded using
C<require>. If no implementation is found, an error will be thrown.

=back

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2008. Ingy döt Net.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
