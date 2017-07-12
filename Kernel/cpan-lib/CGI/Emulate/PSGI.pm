package CGI::Emulate::PSGI;
use strict;
use warnings;
use CGI::Parse::PSGI;
use POSIX 'SEEK_SET';
use IO::File ();
use SelectSaver;
use Carp qw(croak);
use 5.008001;

our $VERSION = '0.23';

sub handler {
    my ($class, $code, ) = @_;

    return sub {
        my $env = shift;

        my $stdout  = IO::File->new_tmpfile;

        {
            my $saver = SelectSaver->new("::STDOUT");
            {
                local %ENV = (%ENV, $class->emulate_environment($env));

                local *STDIN  = $env->{'psgi.input'};
                local *STDOUT = $stdout;
                local *STDERR = $env->{'psgi.errors'};

                $code->();
            }
        }

        seek( $stdout, 0, SEEK_SET )
            or croak("Can't seek stdout handle: $!");

        return CGI::Parse::PSGI::parse_cgi_output($stdout);
    };
}

sub emulate_environment {
    my($class, $env) = @_;

    no warnings;
    my $environment = {
        GATEWAY_INTERFACE => 'CGI/1.1',
        HTTPS => ( ( $env->{'psgi.url_scheme'} eq 'https' ) ? 'ON' : 'OFF' ),
        SERVER_SOFTWARE => "CGI-Emulate-PSGI",
        REMOTE_ADDR     => '127.0.0.1',
        REMOTE_HOST     => 'localhost',
        REMOTE_PORT     => int( rand(64000) + 1000 ),    # not in RFC 3875
        # REQUEST_URI     => $uri->path_query,                 # not in RFC 3875
        ( map { $_ => $env->{$_} } grep { !/^psgix?\./ && $_ ne "HTTP_PROXY" } keys %$env )
    };

    return wantarray ? %$environment : $environment;
}

1;
__END__

=head1 NAME

CGI::Emulate::PSGI - PSGI adapter for CGI

=head1 SYNOPSIS

    my $app = CGI::Emulate::PSGI->handler(sub {
        # Existing CGI code
    });

=head1 DESCRIPTION

This module allows an application designed for the CGI environment to
run in a PSGI environment, and thus on any of the backends that PSGI
supports.

It works by translating the environment provided by the PSGI
specification to one expected by the CGI specification. Likewise, it
captures output as it would be prepared for the CGI standard, and
translates it to the format expected for the PSGI standard using
L<CGI::Parse::PSGI> module.

=head1 CGI.pm

If your application uses L<CGI>, be sure to cleanup the global
variables in the handler loop yourself, so:

    my $app = CGI::Emulate::PSGI->handler(sub {
        use CGI;
        CGI::initialize_globals();
        my $q = CGI->new;
        # ...
    });

Otherwise previous request variables will be reused in the new
requests.

Alternatively, you can install and use L<CGI::Compile> from CPAN and
compiles your existing CGI scripts into a sub that is perfectly ready
to be converted to PSGI application using this module.

  my $sub = CGI::Compile->compile("/path/to/script.cgi");
  my $app = CGI::Emulate::PSGI->handler($sub);

This will take care of assigning a unique namespace for each script
etc. See L<CGI::Compile> for details.

You can also consider using L<CGI::PSGI> but that would require you to
slightly change your code from:

  my $q = CGI->new;
  # ...
  print $q->header, $output;

into:

  use CGI::PSGI;

  my $app = sub {
      my $env = shift;
      my $q = CGI::PSGI->new($env);
      # ...
      return [ $q->psgi_header, [ $output ] ];
  };

See L<CGI::PSGI> for details.

=head1 METHODS

=over 4

=item handler

  my $app = CGI::Emulate::PSGI->handler($code);

Creates a PSGI application code reference out of CGI code reference.

=item emulate_environment

  my %env = CGI::Emulate::PSGI->emulate_environment($env);

Creates an environment hash out of PSGI environment hash. If your code
or framework just needs an environment variable emulation, use this
method like:

  local %ENV = (%ENV, CGI::Emulate::PSGI->emulate_environment($env));
  # run your application

If you use C<handler> method to create a PSGI environment hash, this
is automatically called in the created application.

=back

=head1 AUTHOR

Tokuhiro Matsuno <tokuhirom@cpan.org>

Tatsuhiko Miyagawa

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009-2010 by tokuhirom.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

L<PSGI> L<CGI::Compile> L<CGI::PSGI> L<Plack> L<CGI::Parse::PSGI>

=cut

