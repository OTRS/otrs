package Module::CPANfile::Prereqs;
use strict;
use Carp ();
use CPAN::Meta::Feature;
use Module::CPANfile::Prereq;

sub from_cpan_meta {
    my($class, $prereqs) = @_;

    my $self = $class->new;

    for my $phase (keys %$prereqs) {
        for my $type (keys %{ $prereqs->{$phase} }) {
            while (my($module, $requirement) = each %{ $prereqs->{$phase}{$type} }) {
                $self->add(
                    phase => $phase,
                    type  => $type,
                    module => $module,
                    requirement => Module::CPANfile::Requirement->new(name => $module, version => $requirement),
                );
            }
        }
    }

    $self;
}

sub new {
    my $class = shift;
    bless {
        prereqs => {},
        features => {},
    }, $class;
}

sub add_feature {
    my($self, $identifier, $description) = @_;
    $self->{features}{$identifier} = { description => $description };
}

sub add {
    my($self, %args) = @_;

    my $feature = $args{feature} || '';
    push @{$self->{prereqs}{$feature}},
      Module::CPANfile::Prereq->new(%args);
}

sub as_cpan_meta {
    my $self = shift;
    $self->{cpanmeta} ||= $self->build_cpan_meta;
}

sub build_cpan_meta {
    my($self, $feature) = @_;
    CPAN::Meta::Prereqs->new($self->specs($feature));
}

sub specs {
    my($self, $feature) = @_;

    $feature = ''
      unless defined $feature;

    my $prereqs = $self->{prereqs}{$feature} || [];
    my $specs = {};

    for my $prereq (@$prereqs) {
         $specs->{$prereq->phase}{$prereq->type}{$prereq->module} =
           $prereq->requirement->version;
    }

    return $specs;
}

sub merged_requirements {
    my $self = shift;

    my $reqs = CPAN::Meta::Requirements->new;
    for my $prereq (@{$self->{prereqs}}) {
        $reqs->add_string_requirement($prereq->module, $prereq->requirement->version);
    }

    $reqs;
}

sub find {
    my($self, $module) = @_;

    for my $feature ('', keys %{$self->{features}}) {
        for my $prereq (@{$self->{prereqs}{$feature}}) {
            return $prereq if $prereq->module eq $module;
        }
    }

    return;
}

sub identifiers {
    my $self = shift;
    keys %{$self->{features}};
}

sub feature {
    my($self, $identifier) = @_;

    my $data = $self->{features}{$identifier}
      or Carp::croak("Unknown feature '$identifier'");

    my $prereqs = $self->build_cpan_meta($identifier);

    CPAN::Meta::Feature->new($identifier, {
        description => $data->{description},
        prereqs => $prereqs->as_string_hash,
    });
}

1;
