package REST::Client;

=head1 NAME

REST::Client - A simple client for interacting with RESTful http/https resources

=head1 SYNOPSIS

 use REST::Client;
 
 #The basic use case
 my $client = REST::Client->new();
 $client->GET('http://example.com/dir/file.xml');
 print $client->responseContent();
  
 #A host can be set for convienience
 $client->setHost('http://example.com');
 $client->PUT('/dir/file.xml', '<example>new content</example>');
 if( $client->responseCode() eq '200' ){
     print "Updated\n";
 }
  
 #custom request headers may be added
 $client->addHeader('CustomHeader', 'Value');
  
 #response headers may be gathered
 print $client->responseHeader('ResponseHeader');
  
 #X509 client authentication
 $client->setCert('/path/to/ssl.crt');
 $client->setKey('/path/to/ssl.key');
  
 #add a CA to verify server certificates
 $client->setCa('/path/to/ca.file');
  
 #you may set a timeout on requests, in seconds
 $client->setTimeout(10);
  
 #options may be passed as well as set
 $client = REST::Client->new({
         host    => 'https://example.com',
         cert    => '/path/to/ssl.crt',
         key     => '/path/to/ssl.key',
         ca      => '/path/to/ca.file',
         timeout => 10,
     });
 $client->GET('/dir/file', {CustomHeader => 'Value'});
  
 # Requests can be specificed directly as well
 $client->request('GET', '/dir/file', 'request body content', {CustomHeader => 'Value'});

 # Requests can optionally automatically follow redirects and auth, defaults to
 # false 
 $client->setFollow(1);

 #It is possible to access the L<LWP::UserAgent> object REST::Client is using to
 #make requests, and set advanced options on it, for instance:
 $client->getUseragent()->proxy(['http'], 'http://proxy.example.com/');
  
 # request responses can be written directly to a file 
 $client->setContentFile( "FileName" );

 # or call back method
 $client->setContentFile( \&callback_method );
 # see LWP::UserAgent for how to define callback methods

=head1 DESCRIPTION

REST::Client provides a simple way to interact with HTTP RESTful resources.

=cut

=head1 METHODS

=cut

use strict;
use warnings;
use 5.008_000;

use constant TRUE => 1;
use constant FALSE => 0;

our ($VERSION) = ('$Rev: 273 $' =~ /(\d+)/);

use URI;
use LWP::UserAgent;
use Carp qw(croak carp);

=head2 Construction and setup

=head3 new ( [%$config] )

Construct a new REST::Client. Takes an optional hash or hash reference or
config flags.  Each config flag also has get/set accessors of the form
getHost/setHost, getUseragent/setUseragent, etc.  These can be called on the
instantiated object to change or check values.

The config flags are:

=over 4

=item host

A default host that will be prepended to all requests.  Allows you to just
specify the path when making requests.

The default is undef - you must include the host in your requests.

=item timeout

A timeout in seconds for requests made with the client.  After the timeout the
client will return a 500.

The default is 5 minutes.

=item cert

The path to a X509 certificate file to be used for client authentication.

The default is to not use a certificate/key pair.

=item key

The path to a X509 key file to be used for client authentication.

The default is to not use a certificate/key pair.

=item ca

The path to a certificate authority file to be used to verify host
certificates.

The default is to not use a certificates authority.

=item pkcs12

The path to a PKCS12 certificate to be used for client authentication.

=item pkcs12password

The password for the PKCS12 certificate specified with 'pkcs12'.

=item follow

Boolean that determins whether REST::Client attempts to automatically follow
redirects/authentication.  

The default is false.

=item useragent

An L<LWP::UserAgent> object, ready to make http requests.  

REST::Client will provide a default for you if you do not set this.

=back

=cut

sub new {
    my $class = shift;
    my $config;

    $class->_buildAccessors();

    if(ref $_[0] eq 'HASH'){
        $config = shift;
    }elsif(scalar @_ && scalar @_ % 2 == 0){
        $config = {@_};
    }else{
        $config = {};
    }

    my $self = bless({}, $class);
    $self->{'_config'} = $config;

    $self->_buildUseragent();

    return $self;
}

=head3 addHeader ( $header_name, $value )

Add a custom header to any requests made by this client.

=cut

sub addHeader {
    my $self = shift;
    my $header = shift;
    my $value = shift;
    
    my $headers = $self->{'_headers'} || {};
    $headers->{$header} = $value;
    $self->{'_headers'} = $headers;
    return;
}

=head3 buildQuery ( [...] )

A convienience wrapper around URI::query_form for building query strings from a
variety of data structures. See L<URI>

Returns a scalar query string for use in URLs.

=cut

sub buildQuery {
    my $self = shift;

    my $uri = URI->new();
    $uri->query_form(@_);
    return $uri->as_string();
}



=head2 Request Methods

Each of these methods makes an HTTP request, sets the internal state of the
object, and returns the object.

They can be combined with the response methods, such as:

 print $client->GET('/search/?q=foobar')->responseContent();

=head3 GET ( $url, [%$headers] )

Preform an HTTP GET to the resource specified. Takes an optional hashref of custom request headers.

=cut

sub GET {
    my $self = shift;
    my $url = shift;
    my $headers = shift;
    return $self->request('GET', $url, undef, $headers);
}

=head3 PUT ($url, [$body_content, %$headers] )

Preform an HTTP PUT to the resource specified. Takes an optional body content and hashref of custom request headers.

=cut

sub PUT {
    my $self = shift;
    return $self->request('PUT', @_);
}

=head3 PATCH ( $url, [$body_content, %$headers] )

Preform an HTTP PATCH to the resource specified. Takes an optional body content and hashref of custom request headers.

=cut

sub PATCH {
    my $self = shift;
    return $self->request('PATCH', @_);
}

=head3 POST ( $url, [$body_content, %$headers] )

Preform an HTTP POST to the resource specified. Takes an optional body content and hashref of custom request headers.

=cut

sub POST {
    my $self = shift;
    return $self->request('POST', @_);
}

=head3 DELETE ( $url, [%$headers] )

Preform an HTTP DELETE to the resource specified. Takes an optional hashref of custom request headers.

=cut

sub DELETE {
    my $self = shift;
    my $url = shift;
    my $headers = shift;
    return $self->request('DELETE', $url, undef, $headers);
}

=head3 OPTIONS ( $url, [%$headers] )

Preform an HTTP OPTIONS to the resource specified. Takes an optional hashref of custom request headers.

=cut

sub OPTIONS {
    my $self = shift;
    my $url = shift;
    my $headers = shift;
    return $self->request('OPTIONS', $url, undef, $headers);
}

=head3 HEAD ( $url, [%$headers] )

Preform an HTTP HEAD to the resource specified. Takes an optional hashref of custom request headers.

=cut

sub HEAD {
    my $self = shift;
    my $url = shift;
    my $headers = shift;
    return $self->request('HEAD', $url, undef, $headers);
}

=head3 request ( $method, $url, [$body_content, %$headers] )

Issue a custom request, providing all possible values.

=cut

sub request {
    my $self = shift;
    my $method  = shift;
    my $url     = shift;
    my $content = shift;
    my $headers = shift;

    $self->{'_res'} = undef;
    $self->_buildUseragent();


    #error check
    croak "REST::Client exception: First argument to request must be one of GET, PATCH, PUT, POST, DELETE, OPTIONS, HEAD" unless $method =~ /^(get|patch|put|post|delete|options|head)$/i;
    croak "REST::Client exception: Must provide a url to $method" unless $url;
    croak "REST::Client exception: headers must be presented as a hashref" if $headers && ref $headers ne 'HASH';


    $url = $self->_prepareURL($url);

    my $ua = $self->getUseragent();
    if(defined $self->getTimeout()){
        $ua->timeout($self->getTimeout);
    }else{
        $ua->timeout(300);
    }
    my $req = HTTP::Request->new( $method => $url );

    #build headers
    if(defined $content && length($content)){
        $req->content($content);
        $req->header('Content-Length', length($content));
    }else{
        $req->header('Content-Length', 0);
    }

    my $custom_headers = $self->{'_headers'} || {};
    for my $header (keys %$custom_headers){
        $req->header($header, $custom_headers->{$header});
    }

    for my $header (keys %$headers){
        $req->header($header, $headers->{$header});
    }


    #prime LWP with ssl certfile if we have values
    if($self->getCert){
        carp "REST::Client exception: Certs defined but not using https" unless $url =~ /^https/;
        croak "REST::Client exception: Cannot read cert and key file" unless -f $self->getCert && -f $self->getKey;

        $ua->ssl_opts(SSL_cert_file => $self->getCert);
        $ua->ssl_opts(SSL_key_file => $self->getKey); 
    }
   
    #prime LWP with CA file if we have one     
    if(my $ca = $self->getCa){
        croak "REST::Client exception: Cannot read CA file" unless -f $ca;
        $ua->ssl_opts(SSL_ca_file => $ca);
    }

    #prime LWP with PKCS12 certificate if we have one
    if($self->getPkcs12){
        carp "REST::Client exception: PKCS12 cert defined but not using https" unless $url =~ /^https/;
        croak "REST::Client exception: Cannot read PKCS12 cert" unless -f $self->getPkcs12;

        $ENV{HTTPS_PKCS12_FILE}     = $self->getPkcs12;
        if($self->getPkcs12password){
            $ENV{HTTPS_PKCS12_PASSWORD} = $self->getPkcs12password;
        }
    }

    my $res = $self->getFollow ? 
        $ua->request( $req, $self->getContentFile ) : 
        $ua->simple_request( $req, $self->getContentFile );

    $self->{_res} = $res;

    return $self;
}

=head2 Response Methods

Use these methods to gather information about the last requset
performed.

=head3 responseCode ()

Return the HTTP response code of the last request

=cut

sub responseCode {
    my $self = shift;
    return $self->{_res}->code;
}

=head3 responseContent ()

Return the response body content of the last request

=cut

sub responseContent {
    my $self = shift;
    return $self->{_res}->content;
}

=head3 responseHeaders()

Returns a list of HTTP header names from the last response

=cut

sub responseHeaders {
    my $self = shift;
    return $self->{_res}->headers()->header_field_names();
}



=head3 responseHeader ( $header )

Return a HTTP header from the last response

=cut

sub responseHeader {
    my $self = shift;
    my $header = shift;
    croak "REST::Client exception: no header provided to responseHeader" unless $header;
    return $self->{_res}->header($header);
}

=head3 responseXpath ()

A convienience wrapper that returns a L<XML::LibXML> xpath context for the body content.  Assumes the content is XML.

=cut

sub responseXpath {
    my $self = shift;

    require XML::LibXML;

    my $xml= XML::LibXML->new();
    $xml->load_ext_dtd(0);

    if($self->responseHeader('Content-type') =~ /html/){
        return XML::LibXML::XPathContext->new($xml->parse_html_string( $self->responseContent() ));
    }else{
        return XML::LibXML::XPathContext->new($xml->parse_string( $self->responseContent() ));
    }
}

# Private methods

sub _prepareURL {
    my $self = shift;
    my $url = shift;

    my $host = $self->getHost;
    if($host){
        $url = '/'.$url unless $url =~ /^\//;
        $url = $host . $url;
    }
    unless($url =~ /^\w+:\/\//){
        $url = ($self->getCert ? 'https://' : 'http://') . $url;
    }

    return $url;
}

sub _buildUseragent {
    my $self = shift;

    return if $self->getUseragent();

    my $ua = LWP::UserAgent->new;
    $ua->agent("REST::Client/$VERSION");
    $self->setUseragent($ua);

    return;
}

sub _buildAccessors {
    my $self = shift;

    return if $self->can('setHost');

    my @attributes = qw(Host Key Cert Ca Timeout Follow Useragent Pkcs12 Pkcs12password ContentFile);

    for my $attribute (@attributes){
        my $set_method = "
        sub {
        my \$self = shift;
        \$self->{'_config'}{lc('$attribute')} = shift;
        return \$self->{'_config'}{lc('$attribute')};
        }";

        my $get_method = "
        sub {
        my \$self = shift;
        return \$self->{'_config'}{lc('$attribute')};
        }";


        {
            no strict 'refs';
            *{'REST::Client::set'.$attribute} = eval $set_method ;
            *{'REST::Client::get'.$attribute} = eval $get_method ;
        }

    }

    return;
}

1;


=head1 TODO

Caching, content-type negotiation, readable handles for body content.

=head1 AUTHOR

Miles Crawford, E<lt>mcrawfor@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2008 - 2010 by Miles Crawford

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
