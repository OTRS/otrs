package Selenium::Remote::RemoteConnection;
$Selenium::Remote::RemoteConnection::VERSION = '0.26';
#ABSTRACT: Connect to a selenium server

use Moo;
use Try::Tiny;
use LWP::UserAgent;
use HTTP::Headers;
use HTTP::Request;
use Net::Ping;
use Carp qw(croak);
use JSON;
use Data::Dumper;
use Selenium::Remote::ErrorHandler;

has 'remote_server_addr' => (
    is => 'rw',
);

has 'port' => (
    is => 'rw',
);

has 'debug' => (
    is => 'rw',
    default => sub { 0 }
);

has 'ua' => (
    is => 'lazy',
    builder => sub { return LWP::UserAgent->new; }
);

has 'error_handler' => (
    is => 'lazy',
    builder => sub { return Selenium::Remote::ErrorHandler->new; }
);



sub check_status {
    my $self = shift;
    my $status;
    try {
        $status = $self->request({method => 'GET', url => 'status'});
    }
    catch {
        croak "Could not connect to SeleniumWebDriver: $_" ;
    };

    if($status->{cmd_status} ne 'OK') {
        # Could be grid, see if we can talk to it
        $status = undef;
        $status = $self->request({method => 'GET', url => 'grid/api/hub/status'});
    }

    unless ($status->{cmd_status} eq 'OK') {
        croak "Selenium server did not return proper status";
    }
}



# This request method is tailored for Selenium RC server
sub request {
    my ($self,$resource,$params,$dont_process_response) = @_;
    my $method =        $resource->{method};
    my $url =        $resource->{url};
    my $no_content_success =        $resource->{no_content_success} // 0;

    my $content = '';
    my $fullurl = '';

    # Construct full url.
    if ($url =~ m/^http/g) {
        $fullurl = $url;
    }
    elsif ($url =~ m/grid/g) {
        $fullurl =
            "http://"
          . $self->remote_server_addr . ":"
          . $self->port
          . "/$url";
    }
    else {
        $fullurl =
            "http://"
          . $self->remote_server_addr . ":"
          . $self->port
          . "/wd/hub/$url";
    }

    if ((defined $params) && $params ne '') {
        my $json = JSON->new;
        $json->allow_blessed;
        $content = $json->allow_nonref->utf8->encode($params);
    }

    print "REQ: $method, $url, $content\n" if $self->debug;

    # HTTP request
    my $header =
      HTTP::Headers->new(Content_Type => 'application/json; charset=utf-8');
    $header->header('Accept' => 'application/json');
    my $request = HTTP::Request->new($method, $fullurl, $header, $content);
    my $response = $self->ua->request($request);
    if ($dont_process_response) {
        return $response;
    }
    return $self->_process_response($response, $no_content_success);
}

sub _process_response {
    my ($self, $response, $no_content_success) = @_;
    my $data; # server response 'value' that'll be returned to the user
    my $json = JSON->new;

    if ($response->is_redirect) {
        my $redirect = {
            method => 'GET',
            url    => $response->header('location')
        };
        return $self->request($redirect);
    }
    else {
        my $decoded_json = undef;
        print "RES: ".$response->decoded_content."\n\n" if $self->debug;

        if (($response->message ne 'No Content') && ($response->content ne '')) {
            if ($response->content_type !~ m/json/i) {
                $data->{'cmd_status'} = 'NOTOK';
                $data->{'cmd_return'}->{message} = 'Server returned error message '.$response->content.' instead of data';
                return $data;
            }
            $decoded_json = $json->allow_nonref(1)->utf8(1)->decode($response->content);
            $data->{'sessionId'} = $decoded_json->{'sessionId'};
        }

        if ($response->is_error) {
            $data->{'cmd_status'} = 'NOTOK';
            if (defined $decoded_json) {
                $data->{'cmd_return'} = $self->error_handler->process_error($decoded_json);
            }
            else {
                $data->{'cmd_return'} = 'Server returned error code '.$response->code.' and no data';
            }
            return $data;
        }
        elsif ($response->is_success) {
            $data->{'cmd_status'} = 'OK';
            if (defined $decoded_json) {
                if ($no_content_success) {
                    $data->{'cmd_return'} = 1
                }
                else {
                    $data->{'cmd_return'} = $decoded_json->{'value'};
                }
            }
            else {
                $data->{'cmd_return'} = 'Server returned status code '.$response->code.' but no data';
            }
            return $data;
        }
        else {
            # No idea what the server is telling me, must be high
            $data->{'cmd_status'} = 'NOTOK';
            $data->{'cmd_return'} = 'Server returned status code '.$response->code.' which I don\'t understand';
            return $data;
        }
    }
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::RemoteConnection - Connect to a selenium server

=head1 VERSION

version 0.26

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/gempesaw/Selenium-Remote-Driver/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHORS

Current Maintainers:

=over 4

=item *

Daniel Gempesaw <gempesaw@gmail.com>

=item *

Emmanuel Peroumalnaïk <peroumalnaik.emmanuel@gmail.com>

=back

Previous maintainers:

=over 4

=item *

Luke Closs <cpan@5thplane.com>

=item *

Mark Stosberg <mark@stosberg.com>

=back

Original authors:

=over 4

=item *

Aditya Ivaturi <ivaturi@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Copyright (c) 2014-2015 Daniel Gempesaw

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut
