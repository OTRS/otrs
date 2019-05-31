package Module::CPANfile;
use strict;
use warnings;
use Cwd;
use Carp ();
use Module::CPANfile::Environment;
use Module::CPANfile::Requirement;

our $VERSION = '1.1004';

BEGIN {
    if (${^TAINT}) {
        *untaint = sub {
            my $str = shift;
            ($str) = $str =~ /^(.+)$/s;
            $str;
        };
    } else {
        *untaint = sub { $_[0] };
    }
}

sub new {
    my($class, $file) = @_;
    bless {}, $class;
}

sub load {
    my($proto, $file) = @_;

    my $self = ref $proto ? $proto : $proto->new;
    $self->parse($file || _default_cpanfile());
    $self;
}

sub save {
    my($self, $path) = @_;

    open my $out, ">", $path or die "$path: $!";
    print {$out} $self->to_string;
}

sub parse {
    my($self, $file) = @_;

    my $code = do {
        open my $fh, "<", $file or die "$file: $!";
        join '', <$fh>;
    };

    $code = untaint $code;

    my $env = Module::CPANfile::Environment->new($file);
    $env->parse($code) or die $@;

    $self->{_mirrors} = $env->mirrors;
    $self->{_prereqs} = $env->prereqs;
}

sub from_prereqs {
    my($proto, $prereqs) = @_;

    my $self = $proto->new;
    $self->{_prereqs} = Module::CPANfile::Prereqs->from_cpan_meta($prereqs);

    $self;
}

sub mirrors {
    my $self = shift;
    $self->{_mirrors} || [];
}

sub features {
    my $self = shift;
    map $self->feature($_), $self->{_prereqs}->identifiers;
}

sub feature {
    my($self, $identifier) = @_;
    $self->{_prereqs}->feature($identifier);
}

sub prereq { shift->prereqs }

sub prereqs {
    my $self = shift;
    $self->{_prereqs}->as_cpan_meta;
}

sub merged_requirements {
    my $self = shift;
    $self->{_prereqs}->merged_requirements;
}

sub effective_prereqs {
    my($self, $features) = @_;
    $self->prereqs_with(@{$features || []});
}

sub prereqs_with {
    my($self, @feature_identifiers) = @_;

    my @others = map { $self->feature($_)->prereqs } @feature_identifiers;
    $self->prereqs->with_merged_prereqs(\@others);
}

sub prereq_specs {
    my $self = shift;
    $self->prereqs->as_string_hash;
}

sub prereq_for_module {
    my($self, $module) = @_;
    $self->{_prereqs}->find($module);
}

sub options_for_module {
    my($self, $module) = @_;
    my $prereq = $self->prereq_for_module($module) or return;
    $prereq->requirement->options;
}

sub merge_meta {
    my($self, $file, $version) = @_;

    require CPAN::Meta;

    $version ||= $file =~ /\.yml$/ ? '1.4' : '2';

    my $prereq = $self->prereqs;

    my $meta = CPAN::Meta->load_file($file);
    my $prereqs_hash = $prereq->with_merged_prereqs($meta->effective_prereqs)->as_string_hash;
    my $struct = { %{$meta->as_struct}, prereqs => $prereqs_hash };

    CPAN::Meta->new($struct)->save($file, { version => $version });
}

sub _d($) {
    require Data::Dumper;
    chomp(my $value = Data::Dumper->new([$_[0]])->Terse(1)->Dump);
    $value;
}

sub _default_cpanfile {
    my $file = Cwd::abs_path('cpanfile');
    untaint $file;
}

sub to_string {
    my($self, $include_empty) = @_;

    my $mirrors = $self->mirrors;
    my $prereqs = $self->prereq_specs;

    my $code = '';
    $code .= $self->_dump_mirrors($mirrors);
    $code .= $self->_dump_prereqs($prereqs, $include_empty);

    for my $feature ($self->features) {
        $code .= "feature @{[ _d $feature->{identifier} ]}, @{[ _d $feature->{description} ]} => sub {\n";
        $code .= $self->_dump_prereqs($feature->{prereqs}->as_string_hash, $include_empty, 4);
        $code .= "};\n\n";
    }

    $code =~ s/\n+$/\n/s;
    $code;
}

sub _dump_mirrors {
    my($self, $mirrors) = @_;

    my $code = "";

    for my $url (@$mirrors) {
        $code .= "mirror @{[ _d $url ]};\n";
    }

    $code =~ s/\n+$/\n/s;
    $code;
}

sub _dump_prereqs {
    my($self, $prereqs, $include_empty, $base_indent) = @_;

    my $code = '';
    for my $phase (qw(runtime configure build test develop)) {
        my $indent = $phase eq 'runtime' ? '' : '    ';
        $indent .= (' ' x ($base_indent || 0));

        my($phase_code, $requirements);
        $phase_code .= "on $phase => sub {\n" unless $phase eq 'runtime';

        for my $type (qw(requires recommends suggests conflicts)) {
            for my $mod (sort keys %{$prereqs->{$phase}{$type}}) {
                my $ver = $prereqs->{$phase}{$type}{$mod};
                $phase_code .= $ver eq '0'
                             ? "${indent}$type @{[ _d $mod ]}"
                             : "${indent}$type @{[ _d $mod ]}, @{[ _d $ver ]}";

                my $options = $self->options_for_module($mod) || {};
                if (%$options) {
                    my @opts;
                    for my $key (keys %$options) {
                        my $k = $key =~ /^[a-zA-Z0-9_]+$/ ? $key : _d $key;
                        push @opts, "$k => @{[ _d $options->{$k} ]}";
                    }

                    $phase_code .= ",\n" . join(",\n", map "  $indent$_", @opts);
                }

                $phase_code .= ";\n";
                $requirements++;
            }
        }

        $phase_code .= "\n" unless $requirements;
        $phase_code .= "};\n" unless $phase eq 'runtime';

        $code .= $phase_code . "\n" if $requirements or $include_empty;
    }

    $code =~ s/\n+$/\n/s;
    $code;
}

1;

__END__

=head1 NAME

Module::CPANfile - Parse cpanfile

=head1 SYNOPSIS

  use Module::CPANfile;

  my $file = Module::CPANfile->load("cpanfile");
  my $prereqs = $file->prereqs; # CPAN::Meta::Prereqs object

  my @features = $file->features; # CPAN::Meta::Feature objects
  my $merged_prereqs = $file->prereqs_with(@identifiers); # CPAN::Meta::Prereqs

  $file->merge_meta('MYMETA.json');

=head1 DESCRIPTION

Module::CPANfile is a tool to handle L<cpanfile> format to load application
specific dependencies, not just for CPAN distributions.

=head1 METHODS

=over 4

=item load

  $file = Module::CPANfile->load;
  $file = Module::CPANfile->load('cpanfile');

Load and parse a cpanfile. By default it tries to load C<cpanfile> in
the current directory, unless you pass the path to its argument.

=item from_prereqs

  $file = Module::CPANfile->from_prereqs({
    runtime => { requires => { DBI => '1.000' } },
  });

Creates a new Module::CPANfile object from prereqs hash you can get
via L<CPAN::Meta>'s C<prereqs>, or L<CPAN::Meta::Prereqs>'
C<as_string_hash>.

  # read MYMETA, then feed the prereqs to create Module::CPANfile
  my $meta = CPAN::Meta->load_file('MYMETA.json');
  my $file = Module::CPANfile->from_prereqs($meta->prereqs);

  # load cpanfile, then recreate it with round-trip
  my $file = Module::CPANfile->load('cpanfile');
  $file = Module::CPANfile->from_prereqs($file->prereq_specs);
                                    # or $file->prereqs->as_string_hash

=item prereqs

Returns L<CPAN::Meta::Prereqs> object out of the parsed cpanfile.

=item prereq_specs

Returns a hash reference that should be passed to C<< CPAN::Meta::Prereqs->new >>.

=item features

Returns a list of features available in the cpanfile as L<CPAN::Meta::Feature>.

=item prereqs_with(@identifiers), effective_prereqs(\@identifiers)

Returns L<CPAN::Meta::Prereqs> object, with merged prereqs for
features identified with the C<@identifiers>.

=item to_string($include_empty)

  $file->to_string;
  $file->to_string(1);

Returns a canonical string (code) representation for cpanfile. Useful
if you want to convert L<CPAN::Meta::Prereqs> to a new cpanfile.

  # read MYMETA's prereqs and print cpanfile representation of it
  my $meta = CPAN::Meta->load_file('MYMETA.json');
  my $file = Module::CPANfile->from_prereqs($meta->prereqs);
  print $file->to_string;

By default, it omits the phase where there're no modules
registered. If you pass the argument of a true value, it will print
them as well.

=item save

  $file->save('cpanfile');

Saves the currently loaded prereqs as a new C<cpanfile> by calling
C<to_string>. Beware B<this method will overwrite the existing
cpanfile without any warning or backup>. Taking a backup or giving
warnings to users is a caller's responsibility.

  # Read MYMETA.json and creates a new cpanfile
  my $meta = CPAN::Meta->load_file('MYMETA.json');
  my $file = Module::CPANfile->from_prereqs($meta->prereqs);
  $file->save('cpanfile');

=item merge_meta

  $file->merge_meta('META.yml');
  $file->merge_meta('MYMETA.json', '2.0');

Merge the effective prereqs with Meta specification loaded from the
given META file, using CPAN::Meta. You can specify the META spec
version in the second argument, which defaults to 1.4 in case the
given file is YAML, and 2 if it is JSON.

=item options_for_module

  my $options = $file->options_for_module($module);

Returns the extra options specified for a given module as a hash
reference. Returns C<undef> when the given module is not specified in
the C<cpanfile>.

For example,

  # cpanfile
  requires 'Plack', '1.000',
    dist => "MIYAGAWA/Plack-1.000.tar.gz";

  # ...
  my $file = Module::CPANfile->load;
  my $options = $file->options_for_module('Plack');
  # => { dist => "MIYAGAWA/Plack-1.000.tar.gz" }

=back

=head1 AUTHOR

Tatsuhiko Miyagawa

=head1 SEE ALSO

L<cpanfile>, L<CPAN::Meta>, L<CPAN::Meta::Spec>

=cut
