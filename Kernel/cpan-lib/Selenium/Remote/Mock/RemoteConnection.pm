package Selenium::Remote::Mock::RemoteConnection;
$Selenium::Remote::Mock::RemoteConnection::VERSION = '1.39';
# ABSTRACT: utility class to mock the responses from Selenium server

use strict;
use warnings;

use Moo;
use JSON;
use Carp;
use Try::Tiny;
use HTTP::Response;
use Data::Dumper;

extends 'Selenium::Remote::RemoteConnection';

has 'spec' => (
    is      => 'ro',
    default => sub { {} },
);

has 'mock_cmds' => ( is => 'ro', );

has 'fake_session_id' => (
    is      => 'lazy',
    builder => sub {
        my $id = join '',
          map +( 0 .. 9, 'a' .. 'z', 'A' .. 'Z' )[ rand( 10 + 26 * 2 ) ],
          1 .. 50;
        return $id;
    },
);

has 'record' => (
    is      => 'ro',
    default => sub { 0 }
);

has 'replay' => ( is => 'ro', );

has 'replay_file' => ( is => 'ro', );

has 'session_store' => (
    is      => 'rw',
    default => sub { {} }
);

has 'session_id' => (
    is      => 'rw',
    default => sub { undef },
);

has 'remote_server_addr' => (
    is      => 'lazy',
    default => sub { 'localhost' }
);


sub BUILD {
    my $self = shift;
    croak 'Cannot define replay and record attributes at the same time'
      if ( ( $self->replay ) && ( $self->record ) );
    croak 'replay_file attribute needs to be defined'
      if ( ( $self->replay ) && !( $self->replay_file ) );
    croak 'replay attribute needs to be defined'
      if ( !( $self->replay ) && ( $self->replay_file ) );
    $self->port('4444');
    if ( $self->replay ) {
        $self->load_session_store( $self->replay_file );
    }
}

sub check_status {
    return;
}

sub load_session_store {
    my $self = shift;
    my $file = shift;
    croak "'$file' is not a valid file" unless ( -f $file );
    open( my $fh, '<', $file ) or croak "Opening '$file' failed";

    # here we use a fake session id since we have no way of figuring out
    # which session is good or not
    local $/ = undef;

    my $json = JSON->new;
    $json->allow_blessed;
    my $decoded_json = $json->allow_nonref(1)->utf8(1)->decode(<$fh>);
    close($fh);
    $self->session_store($decoded_json);
}

sub dump_session_store {
    my $self = shift;
    my ($file) = @_;
    open( my $fh, '>', $file ) or croak "Opening '$file' failed";
    my $session_store = $self->session_store;
    my $dump          = {};
    foreach my $path ( keys %{$session_store} ) {
        $dump->{$path} = $session_store->{$path};
    }
    my $json = JSON->new;
    $json->allow_blessed;
    my $json_session = $json->allow_nonref->utf8->pretty->encode($dump);
    print $fh $json_session;
    close($fh);
}

sub request {
    my $self = shift;
    my ( $resource, $params ) = @_;
    my $method             = $resource->{method};
    my $url                = $resource->{url};
    my $no_content_success = $resource->{no_content_success} // 0;
    my $content            = '';
    my $json               = JSON->new;
    $json->allow_blessed;

    if ($params) {
        $content = $json->allow_nonref->utf8->canonical(1)->encode($params);
    }
    my $url_params = $resource->{url_params};

    print "REQ: $method, $url, $content\n" if $self->debug;

    if ( $self->record ) {
        my $response = $self->SUPER::request( $resource, $params, 1 );
        push @{ $self->session_store->{"$method $url $content"} },
          $response->as_string;
        return $self->_process_response( $response, $no_content_success );
    }
    if ( $self->replay ) {
        my $resp;
        my $arr_of_resps = $self->session_store->{"$method $url $content"}
          // [];
        if ( scalar(@$arr_of_resps) ) {
            $resp = shift @$arr_of_resps;
            $resp = HTTP::Response->parse($resp);
        }
        else {
            $resp = HTTP::Response->new( '501', "Failed to find a response" );
        }
        return $self->_process_response( $resp, $no_content_success );
    }
    my $mock_cmds = $self->mock_cmds;
    my $spec      = $self->spec;
    my $cmd       = $mock_cmds->get_method_name_from_parameters(
        { method => $method, url => $url } );
    my $ret = { cmd_status => 'OK', cmd_return => 1 };
    if ( defined( $spec->{$cmd} ) ) {
        my $return_sub = $spec->{$cmd};
        my $mock_return = $return_sub->( $url_params, $params );
        if ( ref($mock_return) eq 'HASH' ) {
            $ret->{cmd_status} = $mock_return->{status};
            $ret->{cmd_return} = $mock_return->{return};
            $ret->{cmd_error}  = $mock_return->{error} // '';
        }
        else {
            $ret = $mock_return;
        }
        $ret->{session_id} = $self->fake_session_id if ( ref($ret) eq 'HASH' );
    }
    else {
        $ret->{sessionId} = $self->fake_session_id;
    }
    return $ret;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Mock::RemoteConnection - utility class to mock the responses from Selenium server

=head1 VERSION

version 1.39

=head1 SYNOPSIS

=head2 Record interactions

    use strict;
    use warnings;
    use Selenium::Remote::Driver;
    use Selenium::Remote::Mock::RemoteConnection;

    # create a new Mock object to record the interactions with Selenium
    # Server
    my $mock_connection = Selenium::Remote::Mock::RemoteConnection->new( record => 1 );

    # the Mock object is passed to the driver in place of what would be
    # a regular Selenium::Remote::RemoteConnection object
    my $driver = Selenium::Remote::Driver->new( remote_conn => $mock_connection );

    # always store the session id, as it will become undef once
    # $driver->quit is called
    my $session_id = $driver->session_id;

    # do all the selenium things and quit
    $driver->get('http://www.google.com');
    $driver->get('http://www.wikipedia.com');
    $driver->quit;

    # dump the session to a file
    $mock_connection->dump_session_store( 'my_record.json' );

This code, above doing some basic Selenium interactions, will end up generating a JSON file containing all the requests and their responses for your Selenium session.
The JSON file looks like this :

    '{
        "HTTP_REQUEST_URL {request_parameters}":[response1,response2,...],
        ...
    }'

The reason why we store array of responses is that the exact same request can be made more than once during a session, so we have to store every response to the same requests.

=head2 Replay interactions

    #!perl
    use strict;
    use warnings;
    use Test::More;
    use Test::Selenium::Remote::Driver;
    use Selenium::Remote::Mock::RemoteConnection;
    my $mock_connection_2 =
      Selenium::Remote::Mock::RemoteConnection->new( replay => 1,
        replay_file => 'my_record.json' );
    # javascript + version parameters added or else it will not work
    my $driver =
      Test::Selenium::Remote::Driver->new( remote_conn => $mock_connection_2, javascript => 1, version => '' );
    $driver->get_ok('http://www.google.com');
    $driver->get_ok('http://www.wikipedia.com');
    $driver->quit;
    done_testing;

Using the file generated with the recording snippet from the section before, we are able to mock the responses.

Note that there is one small limitation (that I hope to remove in future versions), is that a record generated with L<Selenium::Remote::Driver> is not directly useable with L<Test::Selenium::Remote::Driver>.
This is mainly because the way the two instances are created are a bit different, which leads to different requests made, for creating a session for instance.
For now, what works for sure is recording and replaying from the same class.

=head2 Mock responses

    #!perl
    use Test::More;
    use Test::Selenium::Remote::Driver;
    use Selenium::Remote::WebElement;
    use Selenium::Remote::Mock::Commands;
    use Selenium::Remote::Mock::RemoteConnection;

    my $spec = {
        findElement => sub {
            my (undef,$searched_item) = @_;
            return { status => 'OK', return => { ELEMENT => '123456' } }
              if ( $searched_item->{value} eq 'q' );
            return { status => 'NOK', return => 0, error => 'element not found' };
        },
        getPageSource => sub { return 'this output matches regex'},
    };
    my $mock_commands = Selenium::Remote::Mock::Commands->new;

    my $successful_driver =
      Test::Selenium::Remote::Driver->new(
        remote_conn => Selenium::Remote::Mock::RemoteConnection->new( spec => $spec, mock_cmds => $mock_commands ),
        commands => $mock_commands,
    );
    $successful_driver->find_element_ok('q','find_element_ok works');
    dies_ok { $successful_driver->find_element_ok('notq') } 'find_element_ok dies if element not found';
    $successful_driver->find_no_element_ok('notq','find_no_element_ok works');
    $successful_driver->content_like( qr/matches/, 'content_like works');
    $successful_driver->content_unlike( qr/nomatch/, 'content_unlike works');

    done_testing();

Mocking responses by hand requires a more advanced knowledge of the underlying implementation of L<Selenium::Remote::Driver>.
What we mock here is the processed response that will be returned by L<Selenium::Remote::RemoteConnection> to '_execute_command' call.
To accomplish this we need :

=over

=item *
a spec: a HASHREF which keys are the name of the methods we want to mock. Note that those keys should also be valid keys from the _cmds attribute in L<Selenium::Remote::Commands>.
The value of each key is a sub which will be given two parameters:

=over

=item *
$url_params : the values that should have been replaced in the URL
For instance, on the example above, it would have been:
    { session_id => 'some_session_id'}

=item *
$params : the original parameters of the request.
On the example above it would have been:
    { value => 'q', using => 'xpath'}

=back

The sub used as a value in the spec is not expected to return anything, so you have to craft very carefully what you return so that it will produce the expected result.

=item *
a mock_cmd: a L<Selenium::Remote::Mock::Commands> object. This is used mainly to hijack the normal commands so that placeholders do not get replaced in the URLs.

=back

=head1 DESCRIPTION

Selenium::Remote::Mock::RemoteConnection is a class to act as a short-circuit or a pass through to the connection to a Selenium Server.
Using this class in place of L<Selenium::Remote::RemoteConnection> allows to:

=over

=item *
record interactions with the Selenium Server into a JSON file

=item *
replay recorded interactions from a JSON file to mock answers from the Selenium Server

=item *
mock responses to specific functions

=back

=for Pod::Coverage *EVERYTHING*

=head1 BUGS

This code is really early alpha, so its API might change. Use with caution !

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://github.com/teodesian/Selenium-Remote-Driver/issues>

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

Copyright (c) 2014-2017 Daniel Gempesaw

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
