package YAML::Loader::Base;
$YAML::Loader::Base::VERSION = '0.90';
use YAML::Mo;

has load_code     => default => sub {0};
has stream        => default => sub {''};
has document      => default => sub {0};
has line          => default => sub {0};
has documents     => default => sub {[]};
has lines         => default => sub {[]};
has eos           => default => sub {0};
has done          => default => sub {0};
has anchor2node   => default => sub {{}};
has level         => default => sub {0};
has offset        => default => sub {[]};
has preface       => default => sub {''};
has content       => default => sub {''};
has indent        => default => sub {0};
has major_version => default => sub {0};
has minor_version => default => sub {0};
has inline        => default => sub {''};

sub set_global_options {
    my $self = shift;
    $self->load_code($YAML::LoadCode || $YAML::UseCode)
      if defined $YAML::LoadCode or defined $YAML::UseCode;
}

sub load {
    die 'load() not implemented in this class.';
}

1;

=encoding UTF-8

=head1 NAME

YAML::Loader::Base - Base class for YAML Loader classes

=head1 SYNOPSIS

    package YAML::Loader::Something;
    use YAML::Loader::Base -base;

=head1 DESCRIPTION

YAML::Loader::Base is a base class for creating YAML loader classes.

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2006, 2011-2014. Ingy döt Net. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
