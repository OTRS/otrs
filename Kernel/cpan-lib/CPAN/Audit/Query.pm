package CPAN::Audit::Query;
use strict;
use warnings;
use CPAN::Audit::Version;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{db} = $params{db} || {};

    return $self;
}

sub advisories_for {
    my $self = shift;
    my ( $distname, $version_range ) = @_;

    my $dist = $self->{db}->{dists}->{$distname};
    return unless $dist;

    my @advisories = @{ $dist->{advisories} };
    my @versions   = @{ $dist->{versions} };

    if ( !$version_range ) {
        return @advisories;
    }

    my $version_checker = CPAN::Audit::Version->new;

    my @all_versions = map { $_->{version} } @versions;
    my @selected_versions;

    foreach my $version (@all_versions) {
        if ( $version_checker->in_range( $version, $version_range ) ) {
            push @selected_versions, $version;
        }
    }

    if ( !@selected_versions ) {
        return;
    }

    my @matched_advisories;
    foreach my $advisory (@advisories) {
        my @affected_versions = $version_checker->affected_versions( \@all_versions, $advisory->{affected_versions} );
        next unless @affected_versions;

        foreach my $affected_version ( reverse @affected_versions ) {
            if ( $version_checker->in_range( $affected_version, $version_range ) ) {
                push @matched_advisories, $advisory;
                last;
            }
        }
    }

    if ( !@matched_advisories ) {
        return;
    }

    return @matched_advisories;
}

1;
