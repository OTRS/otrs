package Module::CPANfile::Requirement;
use strict;

sub new {
    my ($class, %args) = @_;

    $args{version} ||= 0;

    bless +{
        name    => delete $args{name},
        version => delete $args{version},
        options => \%args,
    }, $class;
}

sub name    { $_[0]->{name} }
sub version { $_[0]->{version} }

sub options { $_[0]->{options} }

sub has_options {
    keys %{$_[0]->{options}} > 0;
}

1;
