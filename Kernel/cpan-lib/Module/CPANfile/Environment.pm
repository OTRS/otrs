package Module::CPANfile::Environment;
use strict;
use warnings;
use Module::CPANfile::Prereqs;
use Carp ();

my @bindings = qw(
    on requires recommends suggests conflicts
    feature
    osname
    mirror
    configure_requires build_requires test_requires author_requires
);

my $file_id = 1;

sub new {
    my($class, $file) = @_;
    bless {
        file     => $file,
        phase    => 'runtime', # default phase
        feature  => undef,
        features => {},
        prereqs  => Module::CPANfile::Prereqs->new,
        mirrors  => [],
    }, $class;
}

sub bind {
    my $self = shift;
    my $pkg = caller;

    for my $binding (@bindings) {
        no strict 'refs';
        *{"$pkg\::$binding"} = sub { $self->$binding(@_) };
    }
}

sub parse {
    my($self, $code) = @_;

    my $err;
    {
        local $@;
        $file_id++;
        $self->_evaluate(<<EVAL);
package Module::CPANfile::Sandbox$file_id;
no warnings;
BEGIN { \$_environment->bind }

# line 1 "$self->{file}"
$code;
EVAL
        $err = $@;
    }

    if ($err) { die "Parsing $self->{file} failed: $err" };

    return 1;
}

sub _evaluate {
    my $_environment = $_[0];
    eval $_[1];
}

sub prereqs { $_[0]->{prereqs} }

sub mirrors { $_[0]->{mirrors} }

# DSL goes from here

sub on {
    my($self, $phase, $code) = @_;
    local $self->{phase} = $phase;
    $code->();
}

sub feature {
    my($self, $identifier, $description, $code) = @_;

    # shortcut: feature identifier => sub { ... }
    if (@_ == 3 && ref($description) eq 'CODE') {
        $code = $description;
        $description = $identifier;
    }

    unless (ref $description eq '' && ref $code eq 'CODE') {
        Carp::croak("Usage: feature 'identifier', 'Description' => sub { ... }");
    }

    local $self->{feature} = $identifier;
    $self->prereqs->add_feature($identifier, $description);

    $code->();
}

sub osname { die "TODO" }

sub mirror {
    my($self, $url) = @_;
    push @{$self->{mirrors}}, $url;
}

sub requirement_for {
    my($self, $module, @args) = @_;

    my $requirement = 0;
    $requirement = shift @args if @args % 2;

    return Module::CPANfile::Requirement->new(
        name    => $module,
        version => $requirement,
        @args,
    );
}

sub requires {
    my $self = shift;
    $self->add_prereq(requires => @_);
}

sub recommends {
    my $self = shift;
    $self->add_prereq(recommends => @_);
}

sub suggests {
    my $self = shift;
    $self->add_prereq(suggests => @_);
}

sub conflicts {
    my $self = shift;
    $self->add_prereq(conflicts => @_);
}

sub add_prereq {
    my($self, $type, $module, @args) = @_;

    $self->prereqs->add(
        feature => $self->{feature},
        phase   => $self->{phase},
        type    => $type,
        module  => $module,
        requirement => $self->requirement_for($module, @args),
    );
}

# Module::Install compatible shortcuts

sub configure_requires {
    my($self, @args) = @_;
    $self->on(configure => sub { $self->requires(@args) });
}

sub build_requires {
    my($self, @args) = @_;
    $self->on(build => sub { $self->requires(@args) });
}

sub test_requires {
    my($self, @args) = @_;
    $self->on(test => sub { $self->requires(@args) });
}

sub author_requires {
    my($self, @args) = @_;
    $self->on(develop => sub { $self->requires(@args) });
}

1;

