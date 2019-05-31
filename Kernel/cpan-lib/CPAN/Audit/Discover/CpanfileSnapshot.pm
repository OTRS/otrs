package CPAN::Audit::Discover::CpanfileSnapshot;
use strict;
use warnings;
use CPAN::DistnameInfo;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub discover {
    my $self = shift;
    my ($cpanfile_snapshot_path) = @_;

    open my $fh, '<', $cpanfile_snapshot_path or die $!;

    my @deps;
    while ( defined( my $line = <$fh> ) ) {
        if ( $line =~ m/pathname: ([^\s]+)/ ) {
            next unless my $d = CPAN::DistnameInfo->new($1);

            next unless $d->dist && $d->version;

            push @deps,
              {
                dist    => $d->dist,
                version => $d->version,
              };
        }
    }

    close $fh;

    return @deps;
}

1;
