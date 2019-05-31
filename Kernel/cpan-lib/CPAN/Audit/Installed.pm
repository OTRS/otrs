package CPAN::Audit::Installed;
use strict;
use warnings;
use File::Find ();
use Cwd        ();

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{db} = $params{db};
    $self->{cb} = $params{cb};

    return $self;
}

sub find {
    my $self = shift;
    my (@inc) = @_;

    @inc = @INC unless @inc;
    @inc = grep { defined && -d $_ } map { Cwd::realpath($_) } @inc;

    my %seen;
    my @deps;

    File::Find::find(
        {
            wanted => sub {
                my $path = $File::Find::name;

                if ( $path && -f $path && m/\.pm$/ ) {
                    return unless my $module = module_from_file($path);

                    return unless my $distname = $self->{db}->{module2dist}->{$module};

                    my $dist = $self->{db}->{dists}->{$distname};
                    if ( $dist->{main_module} eq $module ) {
                        return if $seen{$module}++;

                        return unless my $version = module_version($path);

                        push @deps, { dist => $distname, version => $version };

                        if ( $self->{cb} ) {
                            $self->{cb}->(
                                {
                                    path     => $path,
                                    distname => $distname,
                                    version  => $version
                                }
                            );
                        }
                    }
                }
            },
            follow      => 1,
            follow_skip => 2,
        },
        @inc
    );

    return @deps;
}

# https://metacpan.org/source/ABELTJE/V-0.13/V.pm
sub module_version {
    my ($parsefile) = @_;

    open my $mod, '<', $parsefile or die $!;

    my $inpod = 0;
    my $result;
    local $_;
    while (<$mod>) {
        $inpod = /^=(?!cut)/ ? 1 : /^=cut/ ? 0 : $inpod;
        next if $inpod || /^\s*#/;

        chomp;
        next unless m/([\$*])(([\w\:\']*)\bVERSION)\b.*\=/;
        my $eval = qq{
            package CPAN::Audit::_version;
            no strict;

            local $1$2;
            \$$2=undef; do {
                $_
            }; \$$2
        };
        local $^W = 0;
        $result = eval($eval);
        warn "Could not eval '$eval' in $parsefile: $@" if $@;
        $result = "undef" unless defined $result;
        last;
    }
    close $mod;
    return $result;
}

sub module_from_file {
    my ($path) = @_;

    my $module;

    open my $fh, '<', $path or return;
    while ( my $line = <$fh> ) {
        if ( $line =~ m/package\s+(.*?)\s*;/ms ) {
            $module = $1;
            last;
        }
    }
    close $fh;

    return unless $module;
}

1;
