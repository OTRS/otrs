package CPAN::Audit::Discover;
use strict;
use warnings;
use CPAN::Audit::Discover::Cpanfile;
use CPAN::Audit::Discover::CpanfileSnapshot;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub discover {
    my $self = shift;
    my ($path) = @_;

    if ( -f "$path/cpanfile.snapshot" ) {
        return CPAN::Audit::Discover::CpanfileSnapshot->new->discover("$path/cpanfile.snapshot");
    }
    elsif ( -f "$path/cpanfile" ) {
        return CPAN::Audit::Discover::Cpanfile->new->discover("$path/cpanfile");
    }
    else {
    }

    return;
}

1;
