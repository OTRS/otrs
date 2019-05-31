package CPAN::Audit::Discover::Cpanfile;
use strict;
use warnings;
use Module::CPANfile;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub discover {
    my $self = shift;
    my ($cpanfile_path) = @_;

    my $cpanfile = Module::CPANfile->load($cpanfile_path);

    my $prereqs = $cpanfile->prereqs->as_string_hash;

    my @deps;
    foreach my $phase ( keys %$prereqs ) {
        foreach my $type ( keys %{ $prereqs->{$phase} } ) {
            foreach my $module ( keys %{ $prereqs->{$phase}->{$type} } ) {
                my $version = $prereqs->{$phase}->{$type}->{$module};

                next if $module eq 'perl';

                push @deps,
                  {
                    module  => $module,
                    version => $version,
                  };
            }
        }
    }

    return @deps;
}

1;
