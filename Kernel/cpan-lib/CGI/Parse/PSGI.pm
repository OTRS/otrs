package CGI::Parse::PSGI;
use strict;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_cgi_output );

use IO::File; # perl bug: should be loaded to call ->getline etc. on filehandle/PerlIO
use HTTP::Response;

our %DEFAULT_OPTS = (
    ignore_status_line => 0,
);

sub parse_cgi_output {
    my $output = shift;
    my $options = \%DEFAULT_OPTS;
    if (ref $_[0] eq 'HASH') {
        $options = { %DEFAULT_OPTS, %{ +shift } }; # Use default opts where none supplied
    }

    my $length;
    if (ref $output eq 'SCALAR') {
        $length = length $$output;
        open my $io, "<", $output;
        $output = $io;
    } else {
        open my $tmp, '<&=:perlio:raw', fileno($output) or die $!;
        $output = $tmp;
        $length = -s $output;
    }

    my $headers;
    while ( my $line = $output->getline ) {
        $headers .= $line;
        last if $headers =~ /\x0d?\x0a\x0d?\x0a$/;
    }
    unless ( defined $headers ) {
        $headers = "HTTP/1.1 500 Internal Server Error\x0d\x0a";
    }

    unless ( $headers =~ /^HTTP/ ) {
        $headers = "HTTP/1.1 200 OK\x0d\x0a" . $headers;
    }

    my $response = HTTP::Response->parse($headers);

    # RFC 3875 6.2.3
    if ($response->header('Location') && !$response->header('Status')) {
        $response->header('Status', 302);
    }

    my $status = $options->{ignore_status_line}?
        200 : ($response->code || 200);

    my $status_header = $response->header('Status');
    if ($status_header) {
        # Use the header status preferentially, if present and well formed

        # Extract the code from the header (should be 3 digits, non zero)
        my ($code) = ($status_header =~ /^ \s* (\d+) /x);

        $status = $code || $status;
    }

    $response->remove_header('Status'); # PSGI doesn't allow having Status header in the response

    my $remaining = $length - tell( $output );
    if ( $response->code == 500 && !$remaining ) {
        return [
            500,
            [ 'Content-Type' => 'text/html' ],
            [ $response->error_as_HTML ]
        ];
    }

    # TODO we can pass $output to the response body without buffering all?

    {
        my $length = 0;
        while ( $output->read( my $buffer, 4096 ) ) {
            $length += length($buffer);
            $response->add_content($buffer);
        }

        if ( $length && !$response->content_length ) {
            $response->content_length($length);
        }
    }

    return [
        $status,
        +[
            map {
                my $k = $_;
                map { ( $k => _cleanup_newline($_) ) } $response->headers->header($_);
            } $response->headers->header_field_names
        ],
        [$response->content],
    ];
}

sub _cleanup_newline {
    local $_ = shift;
    s/\r?\n//g;
    return $_;
}

1;

__END__

=head1 NAME

CGI::Parse::PSGI - Parses CGI output and creates PSGI response out of it

=head1 DESCRIPTION

  use CGI::Parse::PSGI qw(parse_cgi_output);

  my $output = YourApp->run;
  my $psgi_res = parse_cgi_output(\$output);

An option hash can also be passed:

  my $psgi_res = parse_cgi_output(\$output, \%options);

=head1 SYNOPSIS

CGI::Parse::PSGI exports one function C<parse_cgi_output> that takes a
filehandle or a reference to a string to read a CGI script output, and
creates a PSGI response (an array reference containing status code,
headers and a body) by reading the output.

Use L<CGI::Emulate::PSGI> if you have a CGI I<code> not the I<output>,
which takes care of automatically parsing the output, using this
module, from your callback code.

=head1 OPTIONS

As mentioned above, C<parse_cgi_output> can accept an options hash as
the second argument.

Currently the options available are:

=over 4

=item C<ignore_status_line>

A boolean value, defaulting to 0 (false). If true, the status in the
HTTP protocol line is not used to set the default status in absence of
a status header.

=back

The options can be supplied to earlier versions, and will be ignored
without error.  Hence you can preserve legacy behaviour like this:

    parse_cgi_output(\$output, {ignore_status_line => 1});

This will ensure that if the script output includes an edge case
like this:

    HTTP/1.1 666 SNAFU
    Content-Type: text/plain

    This should be OK!

then the old behaviour of ignoring the status line and returning 200
is preserved.

=head1 AUTHOR

Tatsuhiko Miyagawa

=head1 SEE ALSO

L<CGI::Emulate::PSGI>

=cut
