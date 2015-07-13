package Selenium::Remote::Driver;
$Selenium::Remote::Driver::VERSION = '0.26';
# ABSTRACT: Perl Client for Selenium Remote Driver

use Moo;
use Try::Tiny;

use 5.006;
use v5.10.0;    # Before 5.006, v5.10.0 would not be understood.

# See http://perldoc.perl.org/5.10.0/functions/use.html#use-VERSION
# and http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
# for details.

use Carp;
our @CARP_NOT;

use IO::String;
use Archive::Zip qw( :ERROR_CODES );
use Scalar::Util;
use Selenium::Remote::RemoteConnection;
use Selenium::Remote::Commands;
use Selenium::Remote::WebElement;
use File::Spec::Functions ();
use File::Basename qw(basename);
use Sub::Install ();
use MIME::Base64 ();

use constant FINDERS => {
    class             => 'class name',
    class_name        => 'class name',
    css               => 'css selector',
    id                => 'id',
    link              => 'link text',
    link_text         => 'link text',
    name              => 'name',
    partial_link_text => 'partial link text',
    tag_name          => 'tag name',
    xpath             => 'xpath',
};





has 'remote_server_addr' => (
    is      => 'rw',
    coerce  => sub { ( defined($_[0]) ? $_[0] : 'localhost' )},
    default => sub {'localhost'},
    predicate => 1
);

has 'browser_name' => (
    is      => 'rw',
    coerce  => sub { ( defined($_[0]) ? $_[0] : 'firefox' )},
    default => sub {'firefox'},
);

has 'base_url' => (
    is      => 'lazy',
    coerce  => sub {
        my $base_url = shift;
        $base_url =~ s|/$||;
        return $base_url;
    },
    predicate => 'has_base_url',
);

has 'platform' => (
    is      => 'rw',
    coerce  => sub { ( defined($_[0]) ? $_[0] : 'ANY' )},
    default => sub {'ANY'},
);

has 'port' => (
    is      => 'rw',
    coerce  => sub { ( defined($_[0]) ? $_[0] : '4444' )},
    default => sub {'4444'},
    predicate => 1
);

has 'version' => (
    is      => 'rw',
    default => sub {''},
);

has 'webelement_class' => (
    is      => 'rw',
    default => sub {'Selenium::Remote::WebElement'},
);


has 'default_finder' => (
    is      => 'rw',
    coerce  => sub { __PACKAGE__->FINDERS->{ $_[0] } },
    default => sub {'xpath'},
);

has 'session_id' => (
    is      => 'rw',
    default => sub {undef},
);

has 'remote_conn' => (
    is      => 'lazy',
    builder => sub {
            my $self = shift;
            return Selenium::Remote::RemoteConnection->new(
                remote_server_addr => $self->remote_server_addr,
                port               => $self->port,
                ua                 => $self->ua
            );
    },
);

has 'error_handler' => (
    is => 'rw',
    coerce => sub {
        my ($maybe_coderef) = @_;

        if ( ref($maybe_coderef) eq 'CODE' ) {
            return $maybe_coderef;
        }
        else {
            croak 'The error handler must be a code ref.';
        }
    },
    clearer => 1,
    predicate => 1
);

has 'ua' => (
    is      => 'lazy',
    builder => sub { return LWP::UserAgent->new }
);

has 'commands' => (
    is      => 'lazy',
    builder => sub {
        return Selenium::Remote::Commands->new;
    },
);

has 'auto_close' => (
    is      => 'rw',
    coerce  => sub { ( defined($_[0]) ? $_[0] : 1 )},
    default => sub {1},
);

has 'pid' => (
    is      => 'lazy',
    builder => sub { return $$ }
);

has 'javascript' => (
    is     => 'rw',
    coerce => sub { $_[0] ? JSON::true : JSON::false },
    default => sub { return JSON::true }
);

has 'accept_ssl_certs' => (
    is     => 'rw',
    coerce => sub { $_[0] ? JSON::true : JSON::false },
    default => sub { return JSON::true }
);

has 'proxy' => (
    is     => 'rw',
    coerce => sub {
        my $proxy = $_[0];
        if ( $proxy->{proxyType} eq 'pac' ) {
            if ( not defined $proxy->{proxyAutoconfigUrl} ) {
                croak "proxyAutoconfigUrl not provided\n";
            }
            elsif ( not( $proxy->{proxyAutoconfigUrl} =~ /^http/g ) ) {
                croak "proxyAutoconfigUrl should be of format http://";
            }
        }
        $proxy;
    },
);

has 'extra_capabilities' => (
    is      => 'rw',
    default => sub { {} }
);

has 'firefox_profile' => (
    is        => 'rw',
    coerce    => sub {
        my $profile = shift;
        unless (Scalar::Util::blessed($profile)
          && $profile->isa('Selenium::Firefox::Profile')) {
            croak "firefox_profile should be a Selenium::Firefox::Profile\n";
        }

        return $profile;
    },
    predicate => 'has_firefox_profile'
);

has 'desired_capabilities' => (
    is        => 'lazy',
    predicate => 'has_desired_capabilities'
);

has 'inner_window_size' => (
    is        => 'lazy',
    predicate => 1,
    coerce    => sub {
        my $size = shift;

        croak "inner_window_size must have two elements: [ height, width ]"
          unless scalar @$size == 2;

        foreach my $dim (@$size) {
            croak 'inner_window_size only accepts integers, not: ' . $dim
              unless Scalar::Util::looks_like_number($dim);
        }

        return $size;
    },

);

with 'Selenium::Remote::Finders';

sub BUILD {
    my $self = shift;

    if ($self->has_desired_capabilities) {
        $self->new_desired_session( $self->desired_capabilities );
    }
    else {
        # Connect to remote server & establish a new session
        $self->new_session( $self->extra_capabilities );
    }

    if ( !( defined $self->session_id ) ) {
        croak "Could not establish a session with the remote server\n";
    }
    elsif ($self->has_inner_window_size) {
        my $size = $self->inner_window_size;
        $self->set_inner_window_size(@$size);
    }

    # Setup non-croaking, parameter versions of finders
    foreach my $by (keys %{ $self->FINDERS }) {
        my $finder_name = 'find_element_by_' . $by;
        # In case we get instantiated multiple times, we don't want to
        # install into the name space every time.
        unless ($self->can($finder_name)) {
            my $find_sub = $self->_build_find_by($by);

            Sub::Install::install_sub({
                code => $find_sub,
                into => __PACKAGE__,
                as   => $finder_name,
            });
        }
    }
}

sub new_from_caps {
    my ($self, %args) = @_;

    if (not exists $args{desired_capabilities}) {
        $args{desired_capabilities} = {};
    }

    return $self->new(%args);
}

sub DEMOLISH {
    my ($self, $in_global_destruction) = @_;
    return if $$ != $self->pid;
    return if $in_global_destruction;
    $self->quit() if ( $self->auto_close && defined $self->session_id );
}

# We install an 'around' because we can catch more exceptions this way
# than simply wrapping the explicit croaks in _execute_command.

around '_execute_command' => sub {
    my $orig = shift;
    my $self = shift;
    # copy @_ because it gets lost in the way
    my @args = @_;
    my $return_value;
    try {
        $return_value = $orig->($self,@args);
    }
    catch {
        if ($self->has_error_handler) {
            $self->error_handler->($self,$_);
        }
        else {
            croak $_;
        }
    };
    return $return_value;
};

# This is an internal method used the Driver & is not supposed to be used by
# end user. This method is used by Driver to set up all the parameters
# (url & JSON), send commands & receive processed response from the server.
sub _execute_command {
    my ( $self, $res, $params ) = @_;
    $res->{'session_id'} = $self->session_id;
    my $resource = $self->commands->get_params($res);

    if ($resource) {
        $params = {} unless $params;
        my $resp = $self->remote_conn->request( $resource, $params);
        if ( ref($resp) eq 'HASH' ) {
            if ( $resp->{cmd_status} && $resp->{cmd_status} eq 'OK' ) {
                return $resp->{cmd_return};
            }
            else {
                my $msg = "Error while executing command";
                if ( $resp->{cmd_error} ) {
                    $msg .= ": $resp->{cmd_error}" if $resp->{cmd_error};
                }
                elsif ( $resp->{cmd_return} ) {
                    if ( ref( $resp->{cmd_return} ) eq 'HASH' ) {
                        $msg .= ": $res->{command}"
                          if $res->{command};
                        $msg .= ": $resp->{cmd_return}->{error}->{msg}"
                          if $resp->{cmd_return}->{error}->{msg};
                        $msg .= ": $resp->{cmd_return}->{message}"
                          if $resp->{cmd_return}->{message};
                    }
                    else {
                        $msg .= ": $resp->{cmd_return}";
                    }
                }
                croak $msg;
            }
        }
        return $resp;
    }
    else {
        croak "Couldn't retrieve command settings properly\n";
    }
}

# A method that is used by the Driver itself. It'll be called to set the
# desired capabilities on the server.
sub new_session {
    my ( $self, $extra_capabilities ) = @_;
    $extra_capabilities ||= {};
    my $args = {
        'desiredCapabilities' => {
            'browserName'       => $self->browser_name,
            'platform'          => $self->platform,
            'javascriptEnabled' => $self->javascript,
            'version'           => $self->version,
            'acceptSslCerts'    => $self->accept_ssl_certs,
            %$extra_capabilities,
        },
    };

    if ( defined $self->proxy ) {
        $args->{desiredCapabilities}->{proxy} = $self->proxy;
    }

    if ($args->{desiredCapabilities}->{browserName} =~ /firefox/i
          && $self->has_firefox_profile) {
        $args->{desiredCapabilities}->{firefox_profile} = $self->firefox_profile->_encode;
    }

    $self->_request_new_session($args);
}

sub new_desired_session {
    my ( $self, $caps ) = @_;

    $self->_request_new_session({
        desiredCapabilities => $caps
    });
}

sub _request_new_session {
    my ( $self, $args ) = @_;
    $self->remote_conn->check_status();
    # command => 'newSession' to fool the tests of commands implemented
    # TODO: rewrite the testing better, this is so fragile.
    my $resource_new_session = {
        method => $self->commands->get_method('newSession'),
        url => $self->commands->get_url('newSession'),
        no_content_success => $self->commands->get_no_content_success('newSession'),
    };
    my $rc = $self->remote_conn;
    my $resp = $rc->request(
        $resource_new_session,
        $args,
    );
    if ( ( defined $resp->{'sessionId'} ) && $resp->{'sessionId'} ne '' ) {
        $self->session_id( $resp->{'sessionId'} );
    }
    else {
        my $error = 'Could not create new session';

        if (ref $resp->{cmd_return} eq 'HASH') {
            $error .= ': ' . $resp->{cmd_return}->{message};
        }
        else {
            $error .= ': ' . $resp->{cmd_return};
        }
        croak $error;
    }
}


sub debug_on {
    my ($self) = @_;
    $self->remote_conn->debug(1);
}


sub debug_off {
    my ($self) = @_;
    $self->remote_conn->debug(0);
}


sub get_sessions {
    my ($self) = @_;
    my $res = { 'command' => 'getSessions' };
    return $self->_execute_command($res);
}


sub status {
    my ($self) = @_;
    my $res = { 'command' => 'status' };
    return $self->_execute_command($res);
}


sub get_alert_text {
    my ($self) = @_;
    my $res = { 'command' => 'getAlertText' };
    return $self->_execute_command($res);
}


sub send_keys_to_active_element {
    my ( $self, @strings ) = @_;
    my $res = { 'command' => 'sendKeysToActiveElement' };
    my $params = {
        'value' => \@strings,
    };
    return $self->_execute_command( $res, $params );
}


sub send_keys_to_alert {
    return shift->send_keys_to_prompt(@_);
}


sub send_keys_to_prompt {
    my ( $self, $keys ) = @_;
    my $res    = { 'command' => 'sendKeysToPrompt' };
    my $params = { 'text'    => $keys };
    return $self->_execute_command( $res, $params );
}


sub accept_alert {
    my ($self) = @_;
    my $res = { 'command' => 'acceptAlert' };
    return $self->_execute_command($res);
}


sub dismiss_alert {
    my ($self) = @_;
    my $res = { 'command' => 'dismissAlert' };
    return $self->_execute_command($res);
}


sub mouse_move_to_location {
    my ( $self, %params ) = @_;
    $params{element} = $params{element}{id} if exists $params{element};
    my $res = { 'command' => 'mouseMoveToLocation' };
    return $self->_execute_command( $res, \%params );
}


sub move_to {
    return shift->mouse_move_to_location(@_);
}


sub get_capabilities {
    my $self = shift;
    my $res = { 'command' => 'getCapabilities' };
    return $self->_execute_command($res);
}


sub set_timeout {
    my ( $self, $type, $ms ) = @_;
    if ( not defined $type or not defined $ms ) {
        croak "Expecting type & timeout in ms";
    }
    my $res = { 'command' => 'setTimeout' };
    my $params = { 'type' => $type, 'ms' => $ms };
    return $self->_execute_command( $res, $params );
}


sub set_async_script_timeout {
    my ( $self, $ms ) = @_;
    if ( not defined $ms ) {
        croak "Expecting timeout in ms";
    }
    my $res    = { 'command' => 'setAsyncScriptTimeout' };
    my $params = { 'ms'      => $ms };
    return $self->_execute_command( $res, $params );
}


sub set_implicit_wait_timeout {
    my ( $self, $ms ) = @_;
    my $res    = { 'command' => 'setImplicitWaitTimeout' };
    my $params = { 'ms'      => $ms };
    return $self->_execute_command( $res, $params );
}


sub pause {
    my $self = shift;
    my $timeout = ( shift // 1000 ) / 1000;
    select( undef, undef, undef, $timeout );    # Fractional-second sleep
}


sub close {
    my $self = shift;
    my $res = { 'command' => 'close' };
    $self->_execute_command($res);
}


sub quit {
    my $self = shift;
    my $res = { 'command' => 'quit' };
    $self->_execute_command($res);
    $self->session_id(undef);
}


sub get_current_window_handle {
    my $self = shift;
    my $res = { 'command' => 'getCurrentWindowHandle' };
    return $self->_execute_command($res);
}


sub get_window_handles {
    my $self = shift;
    my $res = { 'command' => 'getWindowHandles' };
    return $self->_execute_command($res);
}


sub get_window_size {
    my ( $self, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    my $res = { 'command' => 'getWindowSize', 'window_handle' => $window };
    return $self->_execute_command($res);
}


sub get_window_position {
    my ( $self, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    my $res = { 'command' => 'getWindowPosition', 'window_handle' => $window };
    return $self->_execute_command($res);
}


sub get_current_url {
    my $self = shift;
    my $res = { 'command' => 'getCurrentUrl' };
    return $self->_execute_command($res);
}


sub navigate {
    my ( $self, $url ) = @_;
    $self->get($url);
}


sub get {
    my ( $self, $url ) = @_;

    if ($self->has_base_url && $url !~ m|://|) {
        $url =~ s|^/||;
        $url = $self->base_url . "/" . $url;
    }

    my $res    = { 'command' => 'get' };
    my $params = { 'url'     => $url  };
    return $self->_execute_command( $res, $params );
}


sub get_title {
    my $self = shift;
    my $res = { 'command' => 'getTitle' };
    return $self->_execute_command($res);
}


sub go_back {
    my $self = shift;
    my $res = { 'command' => 'goBack' };
    return $self->_execute_command($res);
}


sub go_forward {
    my $self = shift;
    my $res = { 'command' => 'goForward' };
    return $self->_execute_command($res);
}


sub refresh {
    my $self = shift;
    my $res = { 'command' => 'refresh' };
    return $self->_execute_command($res);
}


sub has_javascript {
    my $self = shift;
    return int($self->javascript);
}


sub execute_async_script {
    my ( $self, $script, @args ) = @_;
    if ( $self->has_javascript ) {
        if ( not defined $script ) {
            croak 'No script provided';
        }
        my $res = { 'command' => 'executeAsyncScript' };

        # Check the args array if the elem obj is provided & replace it with
        # JSON representation
        for ( my $i = 0; $i < @args; $i++ ) {
            if ( Scalar::Util::blessed( $args[$i] )
                and $args[$i]->isa('Selenium::Remote::WebElement') )
            {
                $args[$i] = { 'ELEMENT' => ( $args[$i] )->{id} };
            }
        }

        my $params = { 'script' => $script, 'args' => \@args };
        my $ret = $self->_execute_command( $res, $params );

        # replace any ELEMENTS with WebElement
        if (    ref($ret)
            and ( ref($ret) eq 'HASH' )
            and exists $ret->{'ELEMENT'} )
        {
            $ret = $self->webelement_class->new( id => $ret->{ELEMENT},
                driver => $self );
        }
        return $ret;
    }
    else {
        croak 'Javascript is not enabled on remote driver instance.';
    }
}


sub execute_script {
    my ( $self, $script, @args ) = @_;
    if ( $self->has_javascript ) {
        if ( not defined $script ) {
            croak 'No script provided';
        }
        my $res = { 'command' => 'executeScript' };

        # Check the args array if the elem obj is provided & replace it with
        # JSON representation
        for ( my $i = 0; $i < @args; $i++ ) {
            if ( Scalar::Util::blessed( $args[$i] )
                and $args[$i]->isa('Selenium::Remote::WebElement') )
            {
                $args[$i] = { 'ELEMENT' => ( $args[$i] )->{id} };
            }
        }

        my $params = { 'script' => $script, 'args' => [@args] };
        my $ret = $self->_execute_command( $res, $params );

        return $self->_convert_to_webelement($ret);
    }
    else {
        croak 'Javascript is not enabled on remote driver instance.';
    }
}

# _convert_to_webelement
# An internal method used to traverse a data structure
# and convert any ELEMENTS with WebElements

sub _convert_to_webelement {
    my ( $self, $ret ) = @_;

    if ( ref($ret) and ( ref($ret) eq 'HASH' ) ) {
        if ( ( keys %$ret == 1 ) and exists $ret->{'ELEMENT'} ) {

            # replace an ELEMENT with WebElement
            return $self->webelement_class->new( id => $ret->{ELEMENT},
                driver => $self );
        }

        my %hash;
        foreach my $key ( keys %$ret ) {
            $hash{$key} = $self->_convert_to_webelement( $ret->{$key} );
        }
        return \%hash;
    }

    if ( ref($ret) and ( ref($ret) eq 'ARRAY' ) ) {
        my @array = map { $self->_convert_to_webelement($_) } @$ret;
        return \@array;
    }

    return $ret;
}


sub screenshot {
    my ($self) = @_;
    my $res = { 'command' => 'screenshot' };
    return $self->_execute_command($res);
}


sub capture_screenshot {
    my ( $self, $filename ) = @_;
    croak '$filename is required' unless $filename;

    open( my $fh, '>', $filename );
    binmode $fh;
    print $fh MIME::Base64::decode_base64( $self->screenshot() );
    CORE::close $fh;
    return 1;
}



sub available_engines {
    my ($self) = @_;
    my $res = { 'command' => 'availableEngines' };
    return $self->_execute_command($res);
}


sub switch_to_frame {
    my ( $self, $id ) = @_;
    my $json_null = JSON::null;
    my $params;
    $id = ( defined $id ) ? $id : $json_null;

    my $res = { 'command' => 'switchToFrame' };
    if ( ref $id eq $self->webelement_class ) {
        $params = { 'id' => { 'ELEMENT' => $id->{'id'} } };
    }
    else {
        $params = { 'id' => $id };
    }
    return $self->_execute_command( $res, $params );
}


sub switch_to_window {
    my ( $self, $name ) = @_;
    if ( not defined $name ) {
        return 'Window name not provided';
    }
    my $res    = { 'command' => 'switchToWindow' };
    my $params = { 'name'    => $name };
    return $self->_execute_command( $res, $params );
}


sub get_speed {
    carp 'get_speed is deprecated and will be removed in the upcoming version of this module';
}


sub set_speed {
    carp 'set_speed is deprecated and will be removed in the upcoming version of this module';
}


sub set_window_position {
    my ( $self, $x, $y, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    if ( not defined $x and not defined $y ) {
        croak "X & Y co-ordinates are required";
    }
    my $res = { 'command' => 'setWindowPosition', 'window_handle' => $window };
    my $params = { 'x' => $x, 'y' => $y };
    my $ret = $self->_execute_command( $res, $params );
    return $ret ? 1 : 0;
}


sub set_window_size {
    my ( $self, $height, $width, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    if ( not defined $height and not defined $width ) {
        croak "height & width of browser are required";
    }
    $height += 0;
    $width += 0;
    my $res = { 'command' => 'setWindowSize', 'window_handle' => $window };
    my $params = { 'height' => $height, 'width' => $width };
    my $ret = $self->_execute_command( $res, $params );
    return $ret ? 1 : 0;
}


sub maximize_window {
    my ( $self, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    my $res = { 'command' => 'maximizeWindow', 'window_handle' => $window };
    my $ret = $self->_execute_command( $res );
    return $ret ? 1 : 0;
}


sub get_all_cookies {
    my ($self) = @_;
    my $res = { 'command' => 'getAllCookies' };
    return $self->_execute_command($res);
}


sub add_cookie {
    my ( $self, $name, $value, $path, $domain, $secure ) = @_;

    if (   ( not defined $name )
        || ( not defined $value )
        || ( not defined $path )
        || ( not defined $domain ) )
    {
        croak "Missing parameters";
    }

    my $res        = { 'command' => 'addCookie' };
    my $json_false = JSON::false;
    my $json_true  = JSON::true;
    $secure = ( defined $secure && $secure ) ? $json_true : $json_false;

    my $params = {
        'cookie' => {
            'name'   => $name,
            'value'  => $value,
            'path'   => $path,
            'domain' => $domain,
            'secure' => $secure,
        }
    };

    return $self->_execute_command( $res, $params );
}


sub delete_all_cookies {
    my ($self) = @_;
    my $res = { 'command' => 'deleteAllCookies' };
    return $self->_execute_command($res);
}


sub delete_cookie_named {
    my ( $self, $cookie_name ) = @_;
    if ( not defined $cookie_name ) {
        croak "Cookie name not provided";
    }
    my $res = { 'command' => 'deleteCookieNamed', 'name' => $cookie_name };
    return $self->_execute_command($res);
}


sub get_page_source {
    my ($self) = @_;
    my $res = { 'command' => 'getPageSource' };
    return $self->_execute_command($res);
}


sub find_element {
    my ( $self, $query, $method ) = @_;
    if ( not defined $query ) {
        croak 'Search string to find element not provided.';
    }
    my $using =
      ( defined $method ) ? $self->FINDERS->{$method} : $self->default_finder;
    if ( defined $using ) {
        my $res = { 'command' => 'findElement' };
        my $params = { 'using' => $using, 'value' => $query };
        my $ret_data = eval { $self->_execute_command( $res, $params ); };
        if ($@) {
            if ( $@
                =~ /(An element could not be located on the page using the given search parameters)/
              )
            {
                # give details on what element wasn't found
                $@ = "$1: $query,$using";
                local @CARP_NOT = ( "Selenium::Remote::Driver", @CARP_NOT );
                croak $@;
            }
            else {
                # re throw if the exception wasn't what we expected
                die $@;
            }
        }
        return $self->webelement_class->new( id => $ret_data->{ELEMENT},
            driver => $self );
    }
    else {
        croak "Bad method, expected: " . join(', ', keys %{ $self->FINDERS });
    }
}


sub find_elements {
    my ( $self, $query, $method ) = @_;
    if ( not defined $query ) {
        croak 'Search string to find element not provided.';
    }

    my $using =
      ( defined $method ) ? $self->FINDERS->{$method} : $self->default_finder;

    if ( defined $using ) {
        my $res = { 'command' => 'findElements' };
        my $params = { 'using' => $using, 'value' => $query };
        my $ret_data = eval { $self->_execute_command( $res, $params ); };
        if ($@) {
            if ( $@
                =~ /(An element could not be located on the page using the given search parameters)/
              )
            {
                # give details on what element wasn't found
                $@ = "$1: $query,$using";
                local @CARP_NOT = ( "Selenium::Remote::Driver", @CARP_NOT );
                croak $@;
            }
            else {
                # re throw if the exception wasn't what we expected
                die $@;
            }
        }
        my $elem_obj_arr = [];
        foreach (@$ret_data) {
            push(
                @$elem_obj_arr,
                $self->webelement_class->new(
                    id => $_->{ELEMENT}, driver => $self
                )
            );
        }
        return wantarray? @{$elem_obj_arr} : $elem_obj_arr ;
    }
    else {
        croak "Bad method, expected: " . join(', ', keys %{ $self->FINDERS });
    }
}


sub find_child_element {
    my ( $self, $elem, $query, $method ) = @_;
    if ( ( not defined $elem ) || ( not defined $query ) ) {
        croak "Missing parameters";
    }
    my $using = ( defined $method ) ? $method : $self->default_finder;
    if ( exists $self->FINDERS->{$using} ) {
        my $res = { 'command' => 'findChildElement', 'id' => $elem->{id} };
        my $params = { 'using' => $self->FINDERS->{$using}, 'value' => $query };
        my $ret_data = eval { $self->_execute_command( $res, $params ); };
        if ($@) {
            if ( $@
                =~ /(An element could not be located on the page using the given search parameters)/
              )
            {
                # give details on what element wasn't found
                $@ = "$1: $query,$using";
                local @CARP_NOT = ( "Selenium::Remote::Driver", @CARP_NOT );
                croak $@;
            }
            else {
                # re throw if the exception wasn't what we expected
                die $@;
            }
        }
        return $self->webelement_class->new( id => $ret_data->{ELEMENT},
            driver => $self );
    }
    else {
        croak "Bad method, expected: " . join(', ', keys %{ $self->FINDERS });
    }
}


sub find_child_elements {
    my ( $self, $elem, $query, $method ) = @_;
    if ( ( not defined $elem ) || ( not defined $query ) ) {
        croak "Missing parameters";
    }
    my $using = ( defined $method ) ? $method : $self->default_finder;
    if ( exists $self->FINDERS->{$using} ) {
        my $res = { 'command' => 'findChildElements', 'id' => $elem->{id} };
        my $params = { 'using' => $self->FINDERS->{$using}, 'value' => $query };
        my $ret_data = eval { $self->_execute_command( $res, $params ); };
        if ($@) {
            if ( $@
                =~ /(An element could not be located on the page using the given search parameters)/
              )
            {
                # give details on what element wasn't found
                $@ = "$1: $query,$using";
                local @CARP_NOT = ( "Selenium::Remote::Driver", @CARP_NOT );
                croak $@;
            }
            else {
                # re throw if the exception wasn't what we expected
                die $@;
            }
        }
        my $elem_obj_arr = [];
        my $i = 0;
        foreach (@$ret_data) {
            $elem_obj_arr->[$i] =
              $self->webelement_class->new( id => $_->{ELEMENT},
                driver => $self );
            $i++;
        }
        return wantarray ? @{$elem_obj_arr} : $elem_obj_arr;
    }
    else {
        croak "Bad method, expected: " . join(', ', keys %{ $self->FINDERS });
    }
}


sub get_active_element {
    my ($self) = @_;
    my $res = { 'command' => 'getActiveElement' };
    my $ret_data = eval { $self->_execute_command($res) };
    if ($@) {
        croak $@;
    }
    else {
        return $self->webelement_class->new( id => $ret_data->{ELEMENT},
            driver => $self );
    }
}


sub cache_status {
    my ($self) = @_;
    my $res = { 'command' => 'cacheStatus' };
    return $self->_execute_command($res);
}


sub set_geolocation {
    my ( $self, %params ) = @_;
    my $res = { 'command' => 'setGeolocation' };
    return $self->_execute_command( $res, \%params );
}


sub get_geolocation {
    my ($self) = @_;
    my $res = { 'command' => 'getGeolocation' };
    return $self->_execute_command($res);
}


sub get_log {
    my ( $self, $type ) = @_;
    my $res = { 'command' => 'getLog' };
    return $self->_execute_command( $res, { type => $type });
}


sub get_log_types {
    my ($self) = @_;
    my $res = { 'command' => 'getLogTypes' };
    return $self->_execute_command($res);
}



sub set_orientation {
    my ( $self, $orientation ) = @_;
    my $res = { 'command' => 'setOrientation' };
    return $self->_execute_command( $res, { orientation => $orientation } );
}


sub get_orientation {
    my ($self) = @_;
    my $res = { 'command' => 'getOrientation' };
    return $self->_execute_command($res);
}


sub send_modifier {
    my ( $self, $modifier, $isdown ) = @_;
    if ( $isdown =~ /(down|up)/ ) {
        $isdown = $isdown =~ /down/ ? 1 : 0;
    }
    my $res = { 'command' => 'sendModifier' };
    my $params = {
        value  => $modifier,
        isdown => $isdown
    };
    return $self->_execute_command( $res, $params );
}


sub compare_elements {
    my ( $self, $elem1, $elem2 ) = @_;
    my $res = {
        'command' => 'elementEquals',
        'id'      => $elem1->{id},
        'other'   => $elem2->{id}
    };
    return $self->_execute_command($res);
}


sub click {
    my ( $self, $button ) = @_;
    my $button_enum = { LEFT => 0, MIDDLE => 1, RIGHT => 2 };
    if ( defined $button && $button =~ /(LEFT|MIDDLE|RIGHT)/i ) {
        $button = $button_enum->{ uc $1 };
    }
    elsif ( defined $button && $button =~ /(0|1|2)/ ) {
        $button = $1;
    }
    else {
        $button = 0;
    }
    my $res    = { 'command' => 'click' };
    my $params = { 'button'  => $button };
    return $self->_execute_command( $res, $params );
}


sub double_click {
    my ($self) = @_;
    my $res = { 'command' => 'doubleClick' };
    return $self->_execute_command($res);
}


sub button_down {
    my ($self) = @_;
    my $res = { 'command' => 'buttonDown' };
    return $self->_execute_command($res);
}


sub button_up {
    my ($self) = @_;
    my $res = { 'command' => 'buttonUp' };
    return $self->_execute_command($res);
}


# this method duplicates upload() method in the
# org.openqa.selenium.remote.RemoteWebElement java class.

sub upload_file {
    my ( $self, $filename, $raw_content ) = @_;

    my $params;
    if (defined $raw_content) {
        #If no processing is passed, send the argument raw
        $params = {
            file => $raw_content
        };
    }
    else {
        #Otherwise, zip/base64 it.
        $params = $self->_prepare_file($filename);
    }

    my $res = { 'command' => 'uploadFile' };    # /session/:SessionId/file
    my $ret = $self->_execute_command( $res, $params );

    return $ret;
}

sub _prepare_file {
    my ($self,$filename) = @_;

    if ( not -r $filename ) { die "upload_file: no such file: $filename"; }
    my $string = "";    # buffer
    my $zip = Archive::Zip->new();
    $zip->addFile($filename, basename($filename));
    if ($zip->writeToFileHandle(IO::String->new($string)) != AZ_OK) {
        die 'zip failed';
    }

    return {
        file => MIME::Base64::encode_base64($string)          # base64-encoded string
    };
}


sub get_text {
    my $self = shift;
    return $self->find_element(@_)->get_text();
}


sub get_body {
    my $self = shift;
    return $self->get_text('//body', 'xpath');
}


sub get_path {
    my $self     = shift;
    my $location = $self->get_current_url;
    $location =~ s/\?.*//;               # strip of query params
    $location =~ s/#.*//;                # strip of anchors
    $location =~ s#^https?://[^/]+##;    # strip off host
    return $location;
}


sub get_user_agent {
    my $self = shift;
    return $self->execute_script('return window.navigator.userAgent;');
}



sub set_inner_window_size {
    my $self = shift;
    my $height = shift;
    my $width = shift;
    my $location = $self->get_current_url;

    $self->execute_script('window.open("' . $location . '", "_blank")');
    $self->close;
    my @handles = @{ $self->get_window_handles };
    $self->switch_to_window(pop @handles);

    my @resize = (
        'window.innerHeight = ' . $height,
        'window.innerWidth  = ' . $width,
        'return 1'
    );

    return $self->execute_script(join(';', @resize)) ? 1 : 0;
}


sub get_local_storage_item {
    my ($self, $key) = @_;
    my $res = { 'command' => 'getLocalStorageItem' };
    my $params = { 'key' => $key };
    return $self->_execute_command($res, $params);
}


sub delete_local_storage_item {
    my ($self, $key) = @_;
    my $res = { 'command' => 'deleteLocalStorageItem' };
    my $params = { 'key' => $key };
    return $self->_execute_command($res, $params);
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Driver - Perl Client for Selenium Remote Driver

=head1 VERSION

version 0.26

=head1 SYNOPSIS

    use Selenium::Remote::Driver;

    my $driver = Selenium::Remote::Driver->new;
    $driver->get('http://www.google.com');
    print $driver->get_title();
    $driver->quit();

=head1 DESCRIPTION

Selenium is a test tool that allows you to write
automated web application UI tests in any programming language against
any HTTP website using any mainstream JavaScript-enabled browser. This module is
an implementation of the client for the Remote driver that Selenium provides.
You can find bindings for other languages at this location:

L<http://code.google.com/p/selenium/>

This module sends commands directly to the Server using HTTP. Using this module
together with the Selenium Server, you can automatically control any supported
browser. To use this module, you need to have already downloaded and started
the Selenium Server (Selenium Server is a Java application).

=head1 USAGE

=head2 Without Standalone Server

As of v0.25, it's possible to use this module without a standalone
server - that is, you would not need the JRE or the JDK to run your
Selenium tests. See L<Selenium::Chrome>, L<Selenium::PhantomJS>, and
L<Selenium::Firefox> for details. If you'd like additional browsers
besides these, give us a holler over in
L<Github|https://github.com/gempesaw/Selenium-Remote-Driver/issues>.

=head2 Remote Driver Response

Selenium::Remote::Driver uses the L<JsonWireProtocol|http://code.google.com/p/selenium/wiki/JsonWireProtocol> to communicate with the
Selenium Server. If an error occurs while executing the command then the server
sends back an HTTP error code with a JSON encoded reponse that indicates the
precise L<Response Error Code|http://code.google.com/p/selenium/wiki/JsonWireProtocol#Response_Status_Codes>. The module will then croak with the error message
associated with this code. If no error occurred, then the subroutine called will
return the value sent back from the server (if a return value was sent).

So a rule of thumb while invoking methods on the driver is if the method did not
croak when called, then you can safely assume the command was successful even if
nothing was returned by the method.

=head2 WebElement

Selenium Webdriver represents all the HTML elements as WebElement, which is
in turn represented by L<Selenium::Remote::WebElement> module. So any method that
deals with WebElements will return and/or expect WebElement object. The POD for
that module describes all the methods that perform various actions on the
WebElements like click, submit etc.

To interact with any WebElement you have to first "find" it, read the POD for
find_element or find_elements for further info. Once you find the required element
then you can perform various actions. If you don't call find_* method first, all
your further actions will fail for that element. Finally, just remember that you
don't have to instantiate WebElement objects at all - they will be automatically
created when you use the find_* methods.

A sub-class of Selenium::Remote::WebElement may be used instead of Selenium::Remote::WebElement,
by providing that class name as an option the constructor:

   my $driver = Selenium::Remote::Driver->new( webelement_class => ... );

For example, a testing-subclass may extend the web-element object with testing methods.

=head1 TESTING

If are writing automated tests using this module, you may be
interested in L<Test::Selenium::Remote::Driver> which is also included
in this distribution. It includes convenience testing methods for many
of the selenum methods available here.

Your other option is to use this module in conjunction with your
choice of testing modules, like L<Test::Spec> or L<Test::More> as
you please.

=head1 FUNCTIONS

=head2 new

 Description:
    Constructor for Driver. It'll instantiate the object if it can communicate
    with the Selenium Webdriver server.

 Input: (all optional)
    Desired capabilities - HASH - Following options are accepted:
      Optional:
        'remote_server_addr'   - <string>   - IP or FQDN of the Webdriver server machine
        'port'                 - <string>   - Port on which the Webdriver server is listening
        'browser_name'         - <string>   - desired browser string: {phantomjs|firefox|internet explorer|htmlunit|iphone|chrome}
        'version'              - <string>   - desired browser version number
        'platform'             - <string>   - desired platform: {WINDOWS|XP|VISTA|MAC|LINUX|UNIX|ANY}
        'javascript'           - <boolean>  - whether javascript should be supported
        'accept_ssl_certs'     - <boolean>  - whether SSL certs should be accepted, default is true.
        'firefox_profile'      - Profile    - Use Selenium::Firefox::Profile to create a Firefox profile for the browser to use
        'proxy'                - HASH       - Proxy configuration with the following keys:
            'proxyType' - <string> - REQUIRED, Possible values are:
                direct     - A direct connection - no proxy in use,
                manual     - Manual proxy settings configured, e.g. setting a proxy for HTTP, a proxy for FTP, etc,
                pac        - Proxy autoconfiguration from a URL,
                autodetect - proxy autodetection, probably with WPAD,
                system     - Use system settings
            'proxyAutoconfigUrl' - <string> - REQUIRED if proxyType is 'pac', ignored otherwise. Expected format: http://hostname.com:1234/pacfile.
            'ftpProxy'           - <string> - OPTIONAL, ignored if proxyType is not 'manual'. Expected format: hostname.com:1234
            'httpProxy'          - <string> - OPTIONAL, ignored if proxyType is not 'manual'. Expected format: hostname.com:1234
            'sslProxy'           - <string> - OPTIONAL, ignored if proxyType is not 'manual'. Expected format: hostname.com:1234
        'extra_capabilities'   - HASH       - Any other extra capabilities

    You can also specify some options in the constructor hash that are
    not part of the browser-related desired capabilities. These items
    are also optional.

        'auto_close'           - <boolean>   - whether driver should end session on remote server on close.
        'base_url'             - <string>    - OPTIONAL, base url for the website Selenium acts on. This can save you from repeating the domain in every call to $driver->get()
        'default_finder'       - <string>    - choose default finder used for find_element* {class|class_name|css|id|link|link_text|name|partial_link_text|tag_name|xpath}
        'inner_window_size'    - <aref[Int]> - An array ref [ height, width ] that the browser window should use as its initial size immediately after instantiation
        'error_handler'        - CODEREF     - A CODEREF that we will call in event of any exceptions. See L</error_handler> for more details.
        'webelement_class'     - <string>    - sub-class of Selenium::Remote::WebElement if you wish to use an alternate WebElement class.
        'ua'                   - LWP::UserAgent instance - if you wish to use a specific $ua, like from Test::LWP::UserAgent

    If no values are provided, then these defaults will be assumed:
        'remote_server_addr' => 'localhost'
        'port'               => '4444'
        'browser_name'       => 'firefox'
        'version'            => ''
        'platform'           => 'ANY'
        'javascript'         => 1
        'auto_close'         => 1
        'default_finder'     => 'xpath'

 Output:
    Remote Driver object

 Usage:
    my $driver = Selenium::Remote::Driver->new;
    or
    my $driver = Selenium::Remote::Driver->new('browser_name' => 'firefox',
                                               'platform'     => 'MAC');
    or
    my $driver = Selenium::Remote::Driver->new('remote_server_addr' => '10.10.1.1',
                                               'port'               => '2222',
                                               'auto_close'         => 0);
    or
    my $driver = Selenium::Remote::Driver->new('browser_name' =>'chrome'
                                               'extra_capabilities' => {
                                                   'chromeOptions' => {
                                                       'args'  => [
                                                           'window-size=1260,960',
                                                           'incognito'
                                                       ],
                                                       'prefs' => {
                                                           'session' => {
                                                               'restore_on_startup' => 4,
                                                               'urls_to_restore_on_startup' => [
                                                                   'http://www.google.com',
                                                                   'http://docs.seleniumhq.org'
                                                               ]},
                                                           'first_run_tabs' => [
                                                               'http://www.google.com',
                                                               'http://docs.seleniumhq.org'
                                                           ]
                                                       }
                                                   }
                                               });
    or
    my $driver = Selenium::Remote::Driver->new('proxy' => {'proxyType' => 'manual', 'httpProxy' => 'myproxy.com:1234'});
    or
    my $driver = Selenium::Remote::Driver->new('default_finder' => 'css');

=head3 error_handler

=head3 clear_error_handler

OPTIONAL constructor arg & associated setter/clearer: if you wish to
install your own error handler, you may pass a code ref in to
C<error_handler> during instantiation like follows:

    my $driver = Selenium::Remote::Driver->new(
        error_handler => sub { print $_[1]; croak 'goodbye'; }
    );

Additionally, you can set and/or clear it at any time on an
already-instantiated driver:

    # later, change the error handler to something else
    $driver->error_handler( sub { print $_[1]; croak 'hello'; } );

    # stop handling errors manually and use the default S:R:D behavior
    # (we will croak about the exception)
    $driver->clear_error_handler;

Your error handler will receive two arguments: the first argument is
the C<$driver> object itself, and the second argument is the exception
message and stack trace in one multiline string.

B<N.B.>: If you set your own error handler, you are entirely
responsible for handling webdriver exceptions, _including_ croaking
behavior. That is, when you set an error handler, we will no longer
croak on Webdriver exceptions - it's up to you to do so. For
consistency with the standard S:R:D behavior, we recommend your error
handler also croak when it's done, especially since your test
shouldn't be running into unexpected errors. Catching specific or
desired errors in your error handler makes sense, but not croaking at
all can leave you in unfamiliar territory. Reaching an unexpected
exception might mean your test has gone off the rails, and the further
your test gets from the source of the of the exception, the harder it
will be to debug.

B<N.B.>: Four methods will still croak on their own: L</find_element>,
L</find_elements>, L</find_child_element>, and
L</find_child_elements>. If these methods throw a Webdriver Exception,
your error handler _will still be_ invoked inside an C<eval>, and then
they'll croak with their own error message that indicates the locator
and strategy used. So, your strategies for avoiding exceptions when
finding elements do not change (either use find_elements and check
the returned array size, wrap your calls to find_element* in an
C<eval>, or use the parameterized versions find_element_*).

=head2 new_from_caps

 Description:
    For experienced users who want complete control over the desired
    capabilities, use this alternative constructor along with the
    C<desired_capabilities> hash key in the init hash. Unlike "new",
    this constructor will not assume any defaults for your desired
    capabilities.

    This alternate constructor IGNORES all other browser-related
    desiredCapability options; the only options that will be respected
    are those that are NOT part of the Capabilities JSON Object as
    described in the Json Wire Protocol.

 Input:
    The only respected keys in the input hash are:

        desired_capabilities - HASHREF - defaults to {}
        remote_server_addr   - STRING  - defaults to localhost
        port                 - INTEGER - defaults to 4444
        default_finder       - STRING  - defaults to xpath
        webelement_class     - STRING  - defaults to Selenium::Remote::WebElement
        auto_close           - BOOLEAN - defaults to 1
        error_handler        - CODEREF - defaults to croaking on exceptions

    Except for C<desired_capabilities>, these keys perform exactly the
    same as listed in the regular "new" constructor.

    The hashref you pass in as desired_capabilities only gets json
    encoded before being passed to the Selenium server; no default
    options of any sort will be added.

    This means you must handle normalization and casing of the input
    options (like "browser_name" vs "browserName") and take care of
    things like encoding the firefox profile if applicable. More
    information about the desired capabilities object is available on
    the Selenium wiki:

    https://code.google.com/p/selenium/wiki/JsonWireProtocol#Capabilities_JSON_Object

 Output:
    Remote Driver object

 Usage:
    my $driver = Selenium::Remote::Driver->new_from_caps(
        'desired_capabilities' => {'browserName' => 'firefox'}
    );

    The above would generate a POST to the webdriver server at
    localhost:4444 with the exact payload of '{"desiredCapabilities":
    {"browserName": "firefox" }}'.

=head2 debug_on

  Description:
    Turns on debugging mode and the driver will print extra info like request
    and response to stdout. Useful, when you want to see what is being sent to
    the server & what response you are getting back.

  Usage:
    $driver->debug_on;

=head2 debug_off

  Description:
    Turns off the debugging mode.

  Usage:
    $driver->debug_off;

=head2 get_sessions

  Description:
    Returns a list of the currently active sessions. Each session will be
    returned as an array of Hashes with the following keys:

    'id' : The session ID
    'capabilities: An object describing session's capabilities

  Output:
    Array of Hashes

  Usage:
    print Dumper $driver->get_sessions();

=head2 status

  Description:
    Query the server's current status. All server implementations
    should return two basic objects describing the server's current
    platform and when the server was built.

  Output:
    Hash ref

  Usage:
    print Dumper $driver->status;

=head2 get_alert_text

 Description:
    Gets the text of the currently displayed JavaScript alert(), confirm()
    or prompt() dialog.

 Example
    my $string = $driver->get_alert_text;

=head2 send_keys_to_active_element

 Description:
    Send a sequence of key strokes to the active element. This command is
    similar to the send keys command in every aspect except the implicit
    termination: The modifiers are not released at the end of the call.
    Rather, the state of the modifier keys is kept between calls, so mouse
    interactions can be performed while modifier keys are depressed.

 Input: 1
    Required:
        {ARRAY | STRING} - Array of strings or a string.

 Usage:
    $driver->send_keys_to_active_element('abcd', 'efg');
    $driver->send_keys_to_active_element('hijk');

    or

    # include the WDKeys module
    use Selenium::Remote::WDKeys;
    .
    .
    $driver->send_keys_to_active_element(KEYS->{'space'}, KEYS->{'enter'});

=head2 send_keys_to_alert

Synonymous with send_keys_to_prompt

=head2 send_keys_to_prompt

 Description:
    Sends keystrokes to a JavaScript prompt() dialog.

 Input:
    {string} keys to send

 Example:
    $driver->send_keys_to_prompt('hello world');
  or
    ok($driver->get_alert_text eq 'Please Input your name','prompt appears');
    $driver->send_keys_to_alert("Larry Wall");
    $driver->accept_alert;

=head2 accept_alert

 Description:
    Accepts the currently displayed alert dialog.  Usually, this is
    equivalent to clicking the 'OK' button in the dialog.

 Example:
    $driver->accept_alert;

=head2 dismiss_alert

 Description:
    Dismisses the currently displayed alert dialog. For comfirm()
    and prompt() dialogs, this is equivalent to clicking the
    'Cancel' button. For alert() dialogs, this is equivalent to
    clicking the 'OK' button.

 Example:
    $driver->dismiss_alert;

=head2 mouse_move_to_location

 Description:
    Move the mouse by an offset of the specificed element. If no
    element is specified, the move is relative to the current mouse
    cursor. If an element is provided but no offset, the mouse will be
    moved to the center of the element. If the element is not visible,
    it will be scrolled into view.

 Output:
    STRING -

 Usage:
    # element - the element to move to. If not specified or is null, the offset is relative to current position of the mouse.
    # xoffset - X offset to move to, relative to the top-left corner of the element. If not specified, the mouse will move to the middle of the element.
    # yoffset - Y offset to move to, relative to the top-left corner of the element. If not specified, the mouse will move to the middle of the element.

    print $driver->mouse_move_to_location(element => e, xoffset => x, yoffset => y);

=head2 move_to

Synonymous with mouse_move_to_location

=head2 get_capabilities

 Description:
    Retrieve the capabilities of the specified session.

 Output:
    HASH of all the capabilities.

 Usage:
    my $capab = $driver->get_capabilities();
    print Dumper($capab);

=head2 set_timeout

 Description:
    Configure the amount of time that a particular type of operation can execute
    for before they are aborted and a |Timeout| error is returned to the client.

 Input:
    type - <STRING> - The type of operation to set the timeout for.
                      Valid values are:
                      "script"    : for script timeouts,
                      "implicit"  : for modifying the implicit wait timeout
                      "page load" : for setting a page load timeout.
    ms - <NUMBER> - The amount of time, in milliseconds, that time-limited
            commands are permitted to run.

 Usage:
    $driver->set_timeout('script', 1000);

=head2 set_async_script_timeout

 Description:
    Set the amount of time, in milliseconds, that asynchronous scripts executed
    by execute_async_script() are permitted to run before they are
    aborted and a |Timeout| error is returned to the client.

 Input:
    ms - <NUMBER> - The amount of time, in milliseconds, that time-limited
            commands are permitted to run.

 Usage:
    $driver->set_async_script_timeout(1000);

=head2 set_implicit_wait_timeout

 Description:
    Set the amount of time the driver should wait when searching for elements.
    When searching for a single element, the driver will poll the page until
    an element is found or the timeout expires, whichever occurs first.
    When searching for multiple elements, the driver should poll the page until
    at least one element is found or the timeout expires, at which point it
    will return an empty list. If this method is never called, the driver will
    default to an implicit wait of 0ms.

 Input:
    Time in milliseconds.

 Output:
    Server Response Hash with no data returned back from the server.

 Usage:
    $driver->set_implicit_wait_timeout(10);

=head2 pause

 Description:
    Pause execution for a specified interval of milliseconds.

 Usage:
    $driver->pause(10000);  # 10 second delay
    $driver->pause();       #  1 second delay default

=head2 close

 Description:
    Close the current window.

 Usage:
    $driver->close();
 or
    #close a popup window
    my $handles = $driver->get_window_handles;
    $driver->switch_to_window($handles->[1]);
    $driver->close();
    $driver->switch_to_window($handles->[0]);

=head2 quit

 Description:
    Delete the session & close open browsers. We will try to call this
    on our down when we get DEMOLISHed, but in the event that we are
    only demolished during global destruction, we will not be able to
    close the browser. For your own unattended and/or complicated tests,
    we recommend explicitly calling quit to make sure you're not leaving
    orphan browsers around.

 Usage:
    $driver->quit();

=head2 get_current_window_handle

 Description:
    Retrieve the current window handle.

 Output:
    STRING - the window handle

 Usage:
    print $driver->get_current_window_handle();

=head2 get_window_handles

 Description:
    Retrieve the list of window handles used in the session.

 Output:
    ARRAY of STRING - list of the window handles

 Usage:
    print Dumper $driver->get_window_handles;
 or
    # get popup, close, then back
    my $handles = $driver->get_window_handles;
    $driver->switch_to_window($handles->[1]);
    $driver->close;
    $driver->switch_to_window($handles->[0]);

=head2 get_window_size

 Description:
    Retrieve the window size

 Input:
    STRING - <optional> - window handle (default is 'current' window)

 Output:
    HASH - containing keys 'height' & 'width'

 Usage:
    my $window_size = $driver->get_window_size();
    print $window_size->{'height'}, $window_size->('width');

=head2 get_window_position

 Description:
    Retrieve the window position

 Input:
    STRING - <optional> - window handle (default is 'current' window)

 Output:
    HASH - containing keys 'x' & 'y'

 Usage:
    my $window_size = $driver->get_window_position();
    print $window_size->{'x'}, $window_size->('y');

=head2 get_current_url

 Description:
    Retrieve the url of the current page

 Output:
    STRING - url

 Usage:
    print $driver->get_current_url();

=head2 navigate

 Description:
    Navigate to a given url. This is same as get() method.

 Input:
    STRING - url

 Usage:
    $driver->navigate('http://www.google.com');

=head2 get

 Description:
    Navigate to a given url

 Input:
    STRING - url

 Usage:
    $driver->get('http://www.google.com');

=head2 get_title

 Description:
    Get the current page title

 Output:
    STRING - Page title

 Usage:
    print $driver->get_title();

=head2 go_back

 Description:
    Equivalent to hitting the back button on the browser.

 Usage:
    $driver->go_back();

=head2 go_forward

 Description:
    Equivalent to hitting the forward button on the browser.

 Usage:
    $driver->go_forward();

=head2 refresh

 Description:
    Reload the current page.

 Usage:
    $driver->refresh();

=head2 javascript

 Description:
    returns true if javascript is enabled in the driver.

 Usage:
    if ($driver->has_javascript) { ...; }

=head2 execute_async_script

 Description:
    Inject a snippet of JavaScript into the page for execution in the context
    of the currently selected frame. The executed script is assumed to be
    asynchronous and must signal that is done by invoking the provided
    callback, which is always provided as the final argument to the function.
    The value to this callback will be returned to the client.

    Asynchronous script commands may not span page loads. If an unload event
    is fired while waiting for a script result, an error should be returned
    to the client.

 Input: 2 (1 optional)
    Required:
        STRING - Javascript to execute on the page
    Optional:
        ARRAY - list of arguments that need to be passed to the script.

 Output:
    {*} - Varied, depending on the type of result expected back from the script.

 Usage:
    my $script = q{
        var arg1 = arguments[0];
        var callback = arguments[arguments.length-1];
        var elem = window.document.findElementById(arg1);
        callback(elem);
    };
    my $elem = $driver->execute_async_script($script,'myid');
    $elem->click;

=head2 execute_script

 Description:
    Inject a snippet of JavaScript into the page and return its result.
    WebElements that should be passed to the script as an argument should be
    specified in the arguments array as WebElement object. Likewise,
    any WebElements in the script result will be returned as WebElement object.

 Input: 2 (1 optional)
    Required:
        STRING - Javascript to execute on the page
    Optional:
        ARRAY - list of arguments that need to be passed to the script.

 Output:
    {*} - Varied, depending on the type of result expected back from the script.

 Usage:
    my $script = q{
        var arg1 = arguments[0];
        var elem = window.document.findElementById(arg1);
        return elem;
    };
    my $elem = $driver->execute_script($script,'myid');
    $elem->click;

=head2 screenshot

 Description:
    Get a screenshot of the current page as a base64 encoded image.

 Output:
    STRING - base64 encoded image

 Usage:
    print $driver->screenshot();

To conveniently write the screenshot to a file, see L<capture_screenshot()>.

=head2 capture_screenshot

 Description:
    Capture a screenshot and save as a PNG to provided file name.
    (The method is compatible with the WWW::Selenium method fo the same name)

 Output:
    TRUE - (Screenshot is written to file)

 Usage:
    $driver->capture_screenshot($filename);

=head2 available_engines

 Description:
    List all available engines on the machine. To use an engine, it has to be present in this list.

 Output:
    {Array.<string>} A list of available engines

 Usage:
    print Dumper $driver->available_engines;

=head2 switch_to_frame

 Description:
    Change focus to another frame on the page. If the frame ID is null, the
    server will switch to the page's default content. You can also switch to a
    WebElement, for e.g. you can find an iframe using find_element & then
    provide that as an input to this method. Also see e.g.

 Input: 1
    Required:
        {STRING | NUMBER | NULL | WebElement} - ID of the frame which can be one of the three
                                   mentioned.

 Usage:
    $driver->switch_to_frame('frame_1');
    or
    $driver->switch_to_frame($driver->find_element('iframe', 'tag_name'));

=head2 switch_to_window

 Description:
    Change focus to another window. The window to change focus to may
    be specified by its server assigned window handle, or by the value
    of the page's window.name attribute.

    If you wish to use the window name as the target, you'll need to
    have set C<window.name> on the page either in app code or via
    L</execute_script>, or pass a name as the second argument to the
    C<window.open()> function when opening the new window. Note that
    the window name used here has nothing to do with the window title,
    or the C<< <title> >> element on the page.

    Otherwise, use L</get_window_handles> and select a
    Webdriver-generated handle from the output of that function.

 Input: 1
    Required:
        STRING - Window handle or the Window name

 Usage:
    $driver->switch_to_window('MY Homepage');
 or
    # close a popup window and switch back
    my $handles = $driver->get_window_handles;
    $driver->switch_to_window($handles->[1]);
    $driver->close;
    $driver->switch_to_window($handles->[0]);

=head2 get_speed

 Description:
    DEPRECATED - this function is a no-op in Webdriver, and will be
    removed in the upcoming version of this module. See
    https://groups.google.com/d/topic/selenium-users/oX0ZnYFPuSA/discussion
    and
    http://code.google.com/p/selenium/source/browse/trunk/java/client/src/org/openqa/selenium/WebDriverCommandProcessor.java

=head2 set_speed

 Description:
    DEPRECATED - this function is a no-op in Webdriver, and will be
    removed in the upcoming version of this module. See
    https://groups.google.com/d/topic/selenium-users/oX0ZnYFPuSA/discussion
    and
    http://code.google.com/p/selenium/source/browse/trunk/java/client/src/org/openqa/selenium/WebDriverCommandProcessor.java

=head2 set_window_position

 Description:
    Set the position (on screen) where you want your browser to be displayed.

 Input:
    INT - x co-ordinate
    INT - y co-ordinate
    STRING - <optional> - window handle (default is 'current' window)

 Output:
    BOOLEAN - Success or failure

 Usage:
    $driver->set_window_position(50, 50);

=head2 set_window_size

 Description:
    Set the size of the browser window

 Input:
    INT - height of the window
    INT - width of the window
    STRING - <optional> - window handle (default is 'current' window)

 Output:
    BOOLEAN - Success or failure

 Usage:
    $driver->set_window_size(640, 480);

=head2 maximize_window

 Description:
    Maximizes the browser window

 Input:
    STRING - <optional> - window handle (default is 'current' window)

 Output:
    BOOLEAN - Success or failure

 Usage:
    $driver->maximize_window();

=head2 get_all_cookies

 Description:
    Retrieve all cookies visible to the current page. Each cookie will be
    returned as a HASH reference with the following keys & their value types:

    'name' - STRING
    'value' - STRING
    'path' - STRING
    'domain' - STRING
    'secure' - BOOLEAN

 Output:
    ARRAY of HASHES - list of all the cookie hashes

 Usage:
    print Dumper($driver->get_all_cookies());

=head2 add_cookie

 Description:
    Set a cookie on the domain.

 Input: 5 (1 optional)
    Required:
        'name' - STRING
        'value' - STRING
        'path' - STRING
        'domain' - STRING
    Optional:
        'secure' - BOOLEAN - default is false.

 Usage:
    $driver->add_cookie('foo', 'bar', '/', '.google.com', 0)

=head2 delete_all_cookies

 Description:
    Delete all cookies visible to the current page.

 Usage:
    $driver->delete_all_cookies();

=head2 delete_cookie_named

 Description:
    Delete the cookie with the given name. This command will be a no-op if there
    is no such cookie visible to the current page.

 Input: 1
    Required:
        STRING - name of cookie to delete

 Usage:
    $driver->delete_cookie_named('foo');

=head2 get_page_source

 Description:
    Get the current page source.

 Output:
    STRING - The page source.

 Usage:
    print $driver->get_page_source();

=head2 find_element

 Description:
    Search for an element on the page, starting from the document
    root. The located element will be returned as a WebElement
    object. If the element cannot be found, we will CROAK, killing
    your script. If you wish for a warning instead, use the
    parameterized version of the finders:

        find_element_by_class
        find_element_by_class_name
        find_element_by_css
        find_element_by_id
        find_element_by_link
        find_element_by_link_text
        find_element_by_name
        find_element_by_partial_link_text
        find_element_by_tag_name
        find_element_by_xpath

    These functions all take a single STRING argument: the locator
    search target of the element you want. If the element is found, we
    will receive a WebElement. Otherwise, we will return 0. Note that
    invoking methods on 0 will of course kill your script.

 Input: 2 (1 optional)
    Required:
        STRING - The search target.
    Optional:
        STRING - Locator scheme to use to search the element, available schemes:
                 {class, class_name, css, id, link, link_text, partial_link_text,
                  tag_name, name, xpath}
                 Defaults to 'xpath' if not configured global during instantiation.

 Output:
    Selenium::Remote::WebElement - WebElement Object
        (This could be a subclass of L<Selenium::Remote::WebElement> if C<webelement_class> was set.

 Usage:
    $driver->find_element("//input[\@name='q']");

=head2 find_elements

 Description:
    Search for multiple elements on the page, starting from the document root.
    The located elements will be returned as an array of WebElement object.

 Input: 2 (1 optional)
    Required:
        STRING - The search target.
    Optional:
        STRING - Locator scheme to use to search the element, available schemes:
                 {class, class_name, css, id, link, link_text, partial_link_text,
                  tag_name, name, xpath}
                 Defaults to 'xpath' if not configured global during instantiation.

 Output:
    ARRAY or ARRAYREF of WebElement Objects

 Usage:
    $driver->find_elements("//input");

=head2 find_child_element

 Description:
    Search for an element on the page, starting from the identified element. The
    located element will be returned as a WebElement object.

 Input: 3 (1 optional)
    Required:
        Selenium::Remote::WebElement - WebElement object from where you want to
                                       start searching.
        STRING - The search target. (Do not use a double whack('//')
                 in an xpath to search for a child element
                 ex: '//option[@id="something"]'
                 instead use a dot whack ('./')
                 ex: './option[@id="something"]')
    Optional:
        STRING - Locator scheme to use to search the element, available schemes:
                 {class, class_name, css, id, link, link_text, partial_link_text,
                  tag_name, name, xpath}
                 Defaults to 'xpath' if not configured global during instantiation.

 Output:
    WebElement Object

 Usage:
    my $elem1 = $driver->find_element("//select[\@name='ned']");
    # note the usage of ./ when searching for a child element instead of //
    my $child = $driver->find_child_element($elem1, "./option[\@value='es_ar']");

=head2 find_child_elements

 Description:
    Search for multiple element on the page, starting from the identified
    element. The located elements will be returned as an array of WebElement
    objects.

 Input: 3 (1 optional)
    Required:
        Selenium::Remote::WebElement - WebElement object from where you want to
                                       start searching.
        STRING - The search target.
    Optional:
        STRING - Locator scheme to use to search the element, available schemes:
                 {class, class_name, css, id, link, link_text, partial_link_text,
                  tag_name, name, xpath}
                 Defaults to 'xpath' if not configured global during instantiation.

 Output:
    ARRAY of WebElement Objects.

 Usage:
    my $elem1 = $driver->find_element("//select[\@name='ned']");
    my $child = $driver->find_child_elements($elem1, "//option");

=head2 find_element_by_class

See L</find_element>.

=head2 find_element_by_class_name

See L</find_element>.

=head2 find_element_by_css

See L</find_element>.

=head2 find_element_by_id

See L</find_element>.

=head2 find_element_by_link

See L</find_element>.

=head2 find_element_by_link_text

See L</find_element>.

=head2 find_element_by_name

See L</find_element>.

=head2 find_element_by_partial_link_text

See L</find_element>.

=head2 find_element_by_tag_name

See L</find_element>.

=head2 find_element_by_xpath

See L</find_element>.

=head2 get_active_element

 Description:
    Get the element on the page that currently has focus.. The located element
    will be returned as a WebElement object.

 Output:
    WebElement Object

 Usage:
    $driver->get_active_element();

=head2 cache_status

 Description:
    Get the status of the html5 application cache.

 Usage:
    print $driver->cache_status;

 Output:
    <number> - Status code for application cache: {UNCACHED = 0, IDLE = 1, CHECKING = 2, DOWNLOADING = 3, UPDATE_READY = 4, OBSOLETE = 5}

=head2 set_geolocation

 Description:
    Set the current geographic location - note that your driver must
    implement this endpoint, or else it will crash your session. At the
    very least, it works in v2.12 of Chromedriver.

 Input:
    Required:
        HASH: A hash with key C<location> whose value is a Location hashref. See
        usage section for example.

 Usage:
    $driver->set_geolocation( location => {
        latitude  => 40.714353,
        longitude => -74.005973,
        altitude  => 0.056747
    });

 Output:
    BOOLEAN - success or failure

=head2 get_geolocation

 Description:
    Get the current geographic location. Note that your webdriver must
    implement this endpoint - otherwise, it will crash your session. At
    the time of release, we couldn't get this to work on the desktop
    FirefoxDriver or desktop Chromedriver.

 Usage:
    print $driver->get_geolocation;

 Output:
    { latitude: number, longitude: number, altitude: number } - The current geo location.

=head2 get_log

 Description:
    Get the log for a given log type. Log buffer is reset after each request.

 Input:
    Required:
        <STRING> - Type of log to retrieve:
        {client|driver|browser|server}. There may be others available; see
        get_log_types for a full list for your driver.

 Usage:
    $driver->get_log( $log_type );

 Output:
    <ARRAY|ARRAYREF> - An array of log entries since the most recent request.

=head2 get_log_types

 Description:
    Get available log types. By default, every driver should have client,
    driver, browser, and server types, but there may be more available,
    depending on your driver.

 Usage:
    my @types = $driver->get_log_types;
    $driver->get_log($types[0]);

 Output:
    <ARRAYREF> - The list of log types.

=head2 set_orientation

 Description:
    Set the browser orientation.

 Input:
    Required:
        <STRING> - Orientation {LANDSCAPE|PORTRAIT}

 Usage:
    $driver->set_orientation( $orientation  );

 Output:
    BOOLEAN - success or failure

=head2 get_orientation

 Description:
    Get the current browser orientation. Returns either LANDSCAPE|PORTRAIT.

 Usage:
    print $driver->get_orientation;

 Output:
    <STRING> - your orientation.

=head2 send_modifier

 Description:
    Send an event to the active element to depress or release a modifier key.

 Input: 2
    Required:
      value - String - The modifier key event to be sent. This key must be one 'Ctrl','Shift','Alt',' or 'Command'/'Meta' as defined by the send keys command
      isdown - Boolean/String - Whether to generate a key down or key up

 Usage:
    $driver->send_modifier('Alt','down');
    $elem->send_keys('c');
    $driver->send_modifier('Alt','up');

    or

    $driver->send_modifier('Alt',1);
    $elem->send_keys('c');
    $driver->send_modifier('Alt',0);

=head2 compare_elements

 Description:
    Test if two element IDs refer to the same DOM element.

 Input: 2
    Required:
        Selenium::Remote::WebElement - WebElement Object
        Selenium::Remote::WebElement - WebElement Object

 Output:
    BOOLEAN

 Usage:
    $driver->compare_elements($elem_obj1, $elem_obj2);

=head2 click

 Description:
    Click any mouse button (at the coordinates set by the last moveto command).

 Input:
    button - any one of 'LEFT'/0 'MIDDLE'/1 'RIGHT'/2
             defaults to 'LEFT'

 Usage:
    $driver->click('LEFT');
    $driver->click(1); #MIDDLE
    $driver->click('RIGHT');
    $driver->click;  #Defaults to left

=head2 double_click

 Description:
    Double-clicks at the current mouse coordinates (set by moveto).

 Usage:
    $driver->double_click;

=head2 button_down

 Description:
    Click and hold the left mouse button (at the coordinates set by the
    last moveto command). Note that the next mouse-related command that
    should follow is buttonup . Any other mouse command (such as click
    or another call to buttondown) will yield undefined behaviour.

 Usage:
    $self->button_down;

=head2 button_up

 Description:
    Releases the mouse button previously held (where the mouse is
    currently at). Must be called once for every buttondown command
    issued. See the note in click and buttondown about implications of
    out-of-order commands.

 Usage:
    $self->button_up;

=head2 upload_file

 Description:
    Upload a file from the local machine to the selenium server
    machine. That file then can be used for testing file upload on web
    forms. Returns the remote-server's path to the file.

    Passing raw data as an argument past the filename will upload
    that rather than the file's contents.

    When passing raw data, be advised that it expects a zipped
    and then base64 encoded version of a single file.
    Multiple files and/or directories are not supported by the remote server.

 Usage:
    my $remote_fname = $driver->upload_file( $fname );
    my $element = $driver->find_element( '//input[@id="file"]' );
    $element->send_keys( $remote_fname );

=head2 get_text

 Description:
    Get the text of a particular element. Wrapper around L<find_element()>

 Usage:
    $text = $driver->get_text("//div[\@name='q']");

=head2 get_body

 Description:
    Get the current text for the whole body. If you want the entire raw HTML instead,
    See L<get_page_source>.

 Usage:
    $body_text = $driver->get_body();

=head2 get_path

 Description:
     Get the path part of the current browser location.

 Usage:
     $path = $driver->get_path();

=head2 get_user_agent

 Description:
    Convenience method to get the user agent string, according to the
    browser's value for window.navigator.userAgent.

 Usage:
    $user_agent = $driver->get_user_agent()

=head2 set_inner_window_size

 Description:
     Set the inner window size by closing the current window and
     reopening the current page in a new window. This can be useful
     when using browsers to mock as mobile devices.

     This sub will be fired automatically if you set the
     C<inner_window_size> hash key option during instantiation.

 Input:
     INT - height of the window
     INT - width of the window

 Output:
     BOOLEAN - Success or failure

 Usage:
     $driver->set_inner_window_size(640, 480)

=head2 get_local_storage_item

 Description:
     Get the value of a local storage item specified by the given key.

 Input: 1
    Required:
        STRING - name of the key to be retrieved

 Output:
     STRING - value of the local storage item

 Usage:
     $driver->get_local_storage_item('key')

=head2 delete_local_storage_item

 Description:
     Get the value of a local storage item specified by the given key.

 Input: 1
    Required
        STRING - name of the key to be deleted

 Usage:
     $driver->delete_local_storage_item('key')

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<http://code.google.com/p/selenium/|http://code.google.com/p/selenium/>

=item *

L<https://code.google.com/p/selenium/wiki/JsonWireProtocol#Capabilities_JSON_Object|https://code.google.com/p/selenium/wiki/JsonWireProtocol#Capabilities_JSON_Object>

=item *

L<https://github.com/gempesaw/Selenium-Remote-Driver/wiki|https://github.com/gempesaw/Selenium-Remote-Driver/wiki>

=item *

L<Brownie|Brownie>

=item *

L<Wight|Wight>

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

=head1 CONTRIBUTORS

=for stopwords Allen Lew Gordon Child GreatFlamingFoo Ivan Kurmanov Joe Higton Jon Hermansen Keita Sugama Ken Swanson Phil Kania Mitchell Robert Utter Bas Bloemsaat Tom Hukins Vishwanath Janmanchi amacleay jamadam Brian Horakh Charles Howes Daniel Fackrell Dave Rolsky Dmitry Karasik Eric Johnson Gabor Szabo George S. Baugh

=over 4

=item *

Allen Lew <allen@alew.org>

=item *

Gordon Child <gordon@gordonchild.com>

=item *

GreatFlamingFoo <greatflamingfoo@gmail.com>

=item *

Ivan Kurmanov <duraley@gmail.com>

=item *

Joe Higton <draxil@gmail.com>

=item *

Jon Hermansen <jon.hermansen@gmail.com>

=item *

Keita Sugama <sugama@jamadam.com>

=item *

Ken Swanson <kswanson@genome.wustl.edu>

=item *

Phil Kania <phil@vivox.com>

=item *

Phil Mitchell <phil.mitchell@pobox.com>

=item *

Robert Utter <utter.robert@gmail.com>

=item *

Bas Bloemsaat <bas@bloemsaat.com>

=item *

Tom Hukins <tom@eborcom.com>

=item *

Vishwanath Janmanchi <jvishwanath@gmail.com>

=item *

amacleay <a.macleay@gmail.com>

=item *

jamadam <sugama@jamadam.com>

=item *

Brian Horakh <brianh@zoovy.com>

=item *

Charles Howes <charles.howes@globalrelay.net>

=item *

Daniel Fackrell <dfackrell@bluehost.com>

=item *

Dave Rolsky <autarch@urth.org>

=item *

Dmitry Karasik <dmitry@karasik.eu.org>

=item *

Eric Johnson <eric.git@iijo.org>

=item *

Gabor Szabo <gabor@szabgab.com>

=item *

George S. Baugh <george@troglodyne.net>

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
