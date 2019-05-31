package CPAN::Audit::Version;
use strict;
use warnings;
use version;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub in_range {
    my $self = shift;
    my ( $version, $range ) = @_;

    return unless defined $version && defined $range;

    my @ands = split /\s*,\s*/, $range;

    return unless defined( $version = eval { version->parse($version) } );

    foreach my $and (@ands) {
        my ( $op, $range_version ) = $and =~ m/^(<=|<|>=|>|==|!=)?\s*([^\s]+)$/;

        return
          unless defined( $range_version = eval { version->parse($range_version) } );

        $op = '>=' unless defined $op;

        if ( $op eq '<' ) {
            return unless $version < $range_version;
        }
        elsif ( $op eq '<=' ) {
            return unless $version <= $range_version;
        }
        elsif ( $op eq '>' ) {
            return unless $version > $range_version;
        }
        elsif ( $op eq '>=' ) {
            return unless $version >= $range_version;
        }
        elsif ( $op eq '==' ) {
            return unless $version == $range_version;
        }
        elsif ( $op eq '!=' ) {
            return unless $version != $range_version;
        }
        else {
            return 0;
        }
    }

    return 1;
}

sub affected_versions {
    my $self = shift;
    my ( $available_versions, $range ) = @_;

    my @affected_versions;
    foreach my $version (@$available_versions) {
        if ( $self->in_range( $version, $range ) ) {
            push @affected_versions, $version;
        }
    }

    return @affected_versions;
}

1;
