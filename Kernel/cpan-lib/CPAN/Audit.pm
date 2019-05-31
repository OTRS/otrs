package CPAN::Audit;
use 5.008001;
use strict;
use warnings;
use version;
use CPAN::Audit::Installed;
use CPAN::Audit::Discover;
use CPAN::Audit::Version;
use CPAN::Audit::Query;
use CPAN::Audit::DB;
use Module::CoreList;

our $VERSION = "0.15";

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{ascii}       = $params{ascii};
    $self->{verbose}     = $params{verbose};
    $self->{quiet}       = $params{quiet};
    $self->{no_color}    = $params{no_color};
    $self->{no_corelist} = $params{no_corelist};
    $self->{interactive} = $params{interactive};

    if ( !$self->{interactive} ) {
        $self->{ascii}    = 1;
        $self->{no_color} = 1;
    }

    $self->{db}       = CPAN::Audit::DB->db;
    $self->{query}    = CPAN::Audit::Query->new( db => $self->{db} );
    $self->{discover} = CPAN::Audit::Discover->new( db => $self->{db} );

    return $self;
}

sub command {
    my $self = shift;
    my ( $command, @args ) = @_;

    my %dists;

    if (!$self->{no_corelist}
        && (   $command eq 'dependencies'
            || $command eq 'deps'
            || $command eq 'installed' )
        )
    {
        # Find core modules for this perl version first.
        # This way explictly installed versions will overwrite.
        if ( my $core = $Module::CoreList::version{$]} ) {
            while ( my ( $mod, $ver ) = each %$core ) {
                my $dist = $self->{db}{module2dist}{$mod} or next;

                $dists{$dist} = $ver if version->parse($ver) > $dists{$dist};
            }
        }
    }

    if ( $command eq 'module' ) {
        my ( $module, $version_range ) = @args;
        $self->fatal("Usage: module <module> [version-range]") unless $module;

        my $distname = $self->{db}->{module2dist}->{$module};

        if ( !$distname ) {
            $self->message("__GREEN__Module '$module' is not in database");
            return 0;
        }

        $dists{$distname} = $version_range || '';
    }
    elsif ( $command eq 'release' || $command eq 'dist' ) {
        my ( $distname, $version_range ) = @args;
        $self->fatal("Usage: dist|release <module> [version-range]")
          unless $distname;

        if ( !$self->{db}->{dists}->{$distname} ) {
            $self->message("__GREEN__Distribution '$distname' is not in database");
            return 0;
        }

        $dists{$distname} = $version_range || '';
    }
    elsif ( $command eq 'show' ) {
        my ($advisory_id) = @args;
        $self->fatal("Usage: show <advisory-id>") unless $advisory_id;

        my ($release) = $advisory_id =~ m/^CPANSA-(.*?)-(\d+)-(\d+)$/;
        $self->fatal("Invalid advisory id") unless $release;

        my $dist = $self->{db}->{dists}->{$release};
        $self->fatal("Unknown advisory id") unless $dist;

        my ($advisory) =
          grep { $_->{id} eq $advisory_id } @{ $dist->{advisories} };
        $self->fatal("Unknown advisory id") unless $advisory;

        $self->print_advisory($advisory);

        return 0;
    }
    elsif ( $command eq 'dependencies' || $command eq 'deps' ) {
        my ($path) = @args;
        $path = '.' unless defined $path;

        $self->fatal("Usage: deps <path>") unless -d $path;

        my @deps = $self->{discover}->discover($path);

        $self->message( 'Discovered %d dependencies', scalar(@deps) );

        foreach my $dep (@deps) {
            my $dist = $dep->{dist}
              || $self->{db}->{module2dist}->{ $dep->{module} };
            next unless $dist;

            $dists{$dist} = $dep->{version};
        }
    }
    elsif ( $command eq 'installed' ) {
        $self->message_info('Collecting all installed modules. This can take a while...');

        my @deps = CPAN::Audit::Installed->new(
            db => $self->{db},
            $self->{verbose}
            ? (
                cb => sub {
                    my ($info) = @_;

                    $self->message( '%s: %s-%s', $info->{path}, $info->{distname}, $info->{version} );
                }
              )
            : ()
        )->find(@ARGV);

        foreach my $dep (@deps) {
            my $dist = $dep->{dist}
              || $self->{db}->{module2dist}->{ $dep->{module} };
            next unless $dist;

            $dists{ $dep->{dist} } = $dep->{version};
        }
    }
    else {
        $self->fatal("Error: unknown command: $command. See -h");
    }

    my $total_advisories = 0;

    if (%dists) {
        my $query = $self->{query};

        foreach my $distname ( sort keys %dists ) {
            my $version_range = $dists{$distname};

            my @advisories = $query->advisories_for( $distname, $version_range );

            $version_range = 'Any'
              if $version_range eq '' || $version_range eq '0';

            if (@advisories) {
                $self->message( '__RED__%s (requires %s) has %d advisories__RESET__',
                    $distname, $version_range, scalar(@advisories) );

                foreach my $advisory (@advisories) {
                    $self->print_advisory($advisory);
                }
            }

            $total_advisories += @advisories;
        }
    }

    if ($total_advisories) {
        $self->message( '__RED__Total advisories found: %d__RESET__', $total_advisories );

        return $total_advisories;
    }
    else {
        $self->message_info('__GREEN__No advisories found__RESET__');

        return 0;
    }
}

sub message_info {
    my $self = shift;

    return if $self->{quiet};

    $self->message(@_);
}

sub message {
    my $self = shift;

    $self->_print( *STDOUT, @_ );
}

sub fatal {
    my $self = shift;
    my ( $msg, @args ) = @_;

    $self->_print( *STDERR, "Error: $msg", @args );
    exit 255;
}

sub print_advisory {
    my $self = shift;
    my ($advisory) = @_;

    $self->message("  __BOLD__* $advisory->{id}");

    print "    $advisory->{description}\n";

    if ( $advisory->{affected_versions} ) {
        print "    Affected range: $advisory->{affected_versions}\n";
    }

    if ( $advisory->{fixed_versions} ) {
        print "    Fixed range: $advisory->{fixed_versions}\n";
    }

    if ( $advisory->{cves} ) {
        print "\n    CVEs: ";
        print join ', ', @{ $advisory->{cves} };
        print "\n";
    }

    if ( $advisory->{references} ) {
        print "\n    References:\n";
        foreach my $reference ( @{ $advisory->{references} || [] } ) {
            print "    $reference\n";
        }
    }

    print "\n";
}

sub _print {
    my $self = shift;
    my ( $fh, $format, @params ) = @_;

    my $msg = @params ? ( sprintf( $format, @params ) ) : ($format);

    if ( $self->{no_color} ) {
        $msg =~ s{__BOLD__}{}g;
        $msg =~ s{__GREEN__}{}g;
        $msg =~ s{__RED__}{}g;
        $msg =~ s{__RESET__}{}g;
    }
    else {
        $msg =~ s{__BOLD__}{\e[39;1m}g;
        $msg =~ s{__GREEN__}{\e[32m}g;
        $msg =~ s{__RED__}{\e[31m}g;
        $msg =~ s{__RESET__}{\e[0m}g;

        $msg .= "\e[0m";
    }

    print $fh "$msg\n";
}

1;
__END__

=encoding utf-8

=head1 NAME

CPAN::Audit - Audit CPAN distributions for known vulnerabilities

=head1 SYNOPSIS

    use CPAN::Audit;

=head1 DESCRIPTION

CPAN::Audit is a module and a database at the same time. It is used by L<cpan-audit> command line application to query
for vulnerabilities.

=head1 LICENSE

Copyright (C) Viacheslav Tykhanovskyi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Viacheslav Tykhanovskyi E<lt>viacheslav.t@gmail.comE<gt>

=head1 CREDITS

Takumi Akiyama (github.com/akiym)

James Raspass (github.com/JRaspass)

MCRayRay (github.com/MCRayRay)

=cut
