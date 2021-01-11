package Selenium::Remote::Driver;
$Selenium::Remote::Driver::VERSION = '1.39';
use strict;
use warnings;

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
use Selenium::Remote::Spec;
use Selenium::Remote::WebElement;
use Selenium::Remote::WDKeys;
use File::Spec::Functions ();
use File::Basename qw(basename);
use Sub::Install ();
use MIME::Base64 ();
use Time::HiRes qw(usleep);
use Clone qw{clone};
use List::Util qw{any};

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

our $FORCE_WD2            = 0;
our $FORCE_WD3            = 0;
our %CURRENT_ACTION_CHAIN = ( actions => [] );




has 'remote_server_addr' => (
    is     => 'rw',
    coerce => sub { ( defined( $_[0] ) ? $_[0] : 'localhost' ) },
    default   => sub { 'localhost' },
    predicate => 1
);

has 'browser_name' => (
    is     => 'rw',
    coerce => sub { ( defined( $_[0] ) ? $_[0] : 'firefox' ) },
    default => sub { 'firefox' },
);

has 'base_url' => (
    is     => 'lazy',
    coerce => sub {
        my $base_url = shift;
        $base_url =~ s|/$||;
        return $base_url;
    },
    predicate => 'has_base_url',
);

has 'platform' => (
    is     => 'rw',
    coerce => sub { ( defined( $_[0] ) ? $_[0] : 'ANY' ) },
    default => sub { 'ANY' },
);

has 'port' => (
    is     => 'rw',
    coerce => sub { ( defined( $_[0] ) ? $_[0] : '4444' ) },
    default   => sub { '4444' },
    predicate => 1
);

has 'version' => (
    is      => 'rw',
    default => sub { '' },
);

has 'webelement_class' => (
    is      => 'rw',
    default => sub { 'Selenium::Remote::WebElement' },
);

has 'default_finder' => (
    is      => 'rw',
    coerce  => sub { __PACKAGE__->FINDERS->{ $_[0] } },
    default => sub { 'xpath' },
);

has 'session_id' => (
    is      => 'rw',
    default => sub { undef },
);

has 'remote_conn' => (
    is      => 'lazy',
    builder => sub {
        my $self = shift;
        return Selenium::Remote::RemoteConnection->new(
            remote_server_addr => $self->remote_server_addr,
            port               => $self->port,
            ua                 => $self->ua,
            wd_context_prefix  => $self->wd_context_prefix
        );
    },
);

has 'error_handler' => (
    is     => 'rw',
    coerce => sub {
        my ($maybe_coderef) = @_;

        if ( ref($maybe_coderef) eq 'CODE' ) {
            return $maybe_coderef;
        }
        else {
            croak 'The error handler must be a code ref.';
        }
    },
    clearer   => 1,
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

has 'commands_v3' => (
    is      => 'lazy',
    builder => sub {
        return Selenium::Remote::Spec->new;
    },
);

has 'auto_close' => (
    is     => 'rw',
    coerce => sub { ( defined( $_[0] ) ? $_[0] : 1 ) },
    default => sub { 1 },
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
        if ( $proxy->{proxyType} =~ /^pac$/i ) {
            if ( not defined $proxy->{proxyAutoconfigUrl} ) {
                croak "proxyAutoconfigUrl not provided\n";
            }
            elsif ( not( $proxy->{proxyAutoconfigUrl} =~ /^(http|file)/g ) ) {
                croak
                  "proxyAutoconfigUrl should be of format http:// or file://";
            }

            if ( $proxy->{proxyAutoconfigUrl} =~ /^file/ ) {
                my $pac_url = $proxy->{proxyAutoconfigUrl};
                my $file    = $pac_url;
                $file =~ s{^file://}{};

                if ( !-e $file ) {
                    warn "proxyAutoConfigUrl file does not exist: '$pac_url'";
                }
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
    is     => 'rw',
    coerce => sub {
        my $profile = shift;
        unless ( Scalar::Util::blessed($profile)
            && $profile->isa('Selenium::Firefox::Profile') )
        {
            croak "firefox_profile should be a Selenium::Firefox::Profile\n";
        }

        return $profile;
    },
    predicate => 'has_firefox_profile',
    clearer   => 1
);

has debug => (
    is => 'lazy',
    default => sub { 0 },
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

# At the time of writing, Geckodriver uses a different endpoint than
# the java bindings for executing synchronous and asynchronous
# scripts. As a matter of fact, Geckodriver does conform to the W3C
# spec, but as are bound to support both while the java bindings
# transition to full spec support, we need some way to handle the
# difference.

has '_execute_script_suffix' => (
    is      => 'lazy',
    default => ''
);

with 'Selenium::Remote::Finders';
with 'Selenium::Remote::Driver::CanSetWebdriverContext';

sub BUILD {
    my $self = shift;

    if ( !( defined $self->session_id ) ) {
        if ( $self->has_desired_capabilities ) {
            $self->new_desired_session( $self->desired_capabilities );
        }
        else {
            # Connect to remote server & establish a new session
            $self->new_session( $self->extra_capabilities );
        }
    }

    if ( !( defined $self->session_id ) ) {
        croak "Could not establish a session with the remote server\n";
    }
    elsif ( $self->has_inner_window_size ) {
        my $size = $self->inner_window_size;
        $self->set_inner_window_size(@$size);
    }

    #Set debug if needed
    $self->debug_on() if $self->debug;

    # Setup non-croaking, parameter versions of finders
    foreach my $by ( keys %{ $self->FINDERS } ) {
        my $finder_name = 'find_element_by_' . $by;

        # In case we get instantiated multiple times, we don't want to
        # install into the name space every time.
        unless ( $self->can($finder_name) ) {
            my $find_sub = $self->_build_find_by($by);

            Sub::Install::install_sub(
                {
                    code => $find_sub,
                    into => __PACKAGE__,
                    as   => $finder_name,
                }
            );
        }
    }
}

sub new_from_caps {
    my ( $self, %args ) = @_;

    if ( not exists $args{desired_capabilities} ) {
        $args{desired_capabilities} = {};
    }

    return $self->new(%args);
}

sub DEMOLISH {
    my ( $self, $in_global_destruction ) = @_;
    return if $$ != $self->pid;
    return if $in_global_destruction;
    $self->quit() if ( $self->auto_close && defined $self->session_id );
}

# We install an 'around' because we can catch more exceptions this way
# than simply wrapping the explicit croaks in _execute_command.
# @args should be fed to the handler to provide context
# return_value could be assigned from the handler if we want to allow the
# error_handler to handle the errors

around '_execute_command' => sub {
    my $orig = shift;
    my $self = shift;

    # copy @_ because it gets lost in the way
    my @args = @_;
    my $return_value;
    try {
        $return_value = $orig->( $self, @args );
    }
    catch {
        if ( $self->has_error_handler ) {
            $return_value = $self->error_handler->( $self, $_, @args );
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

    print "Prepping $res->{command}\n" if $self->{debug};

    #webdriver 3 shims
    return $self->{capabilities}
      if $res->{command} eq 'getCapabilities' && $self->{capabilities};
    $res->{ms}    = $params->{ms}    if $params->{ms};
    $res->{type}  = $params->{type}  if $params->{type};
    $res->{text}  = $params->{text}  if $params->{text};
    $res->{using} = $params->{using} if $params->{using};
    $res->{value} = $params->{value} if $params->{value};

    print "Executing $res->{command}\n" if $self->{debug};
    my $resource =
        $self->{is_wd3}
      ? $self->commands_v3->get_params($res)
      : $self->commands->get_params($res);

    #Fall-back to legacy if wd3 command doesn't exist
    if ( !$resource && $self->{is_wd3} ) {
        print "Falling back to legacy selenium method for $res->{command}\n"
          if $self->{debug};
        $resource = $self->commands->get_params($res);
    }

    #XXX InternetExplorerDriver quirks
    if ( $self->{is_wd3} && $self->browser_name eq 'internet explorer' ) {
        delete $params->{ms};
        delete $params->{type};
        delete $resource->{payload}->{type};
        my $oldvalue = delete $params->{'page load'};
        $params->{pageLoad} = $oldvalue if $oldvalue;
    }

    if ($resource) {
        $params = {} unless $params;
        my $resp = $self->remote_conn->request( $resource, $params );

#In general, the parse_response for v3 is better, which is why we use it *even if* we are falling back.
        return $self->commands_v3->parse_response( $res, $resp )
          if $self->{is_wd3};
        return $self->commands->parse_response( $res, $resp );
    }
    else {
        #Tell the use about the offending setting.
        croak "Couldn't retrieve command settings properly ".$res->{command}."\n";
    }
}


sub new_session {
    my ( $self, $extra_capabilities ) = @_;
    $extra_capabilities ||= {};

    my $args = {
        'desiredCapabilities' => {
            'browserName'       => $self->browser_name,
            'platform'          => $self->platform,
            'javascriptEnabled' => $self->javascript,
            'version'           => $self->version // '',
            'acceptSslCerts'    => $self->accept_ssl_certs,
            %$extra_capabilities,
        },
    };
    $args->{'extra_capabilities'} = \%$extra_capabilities unless $FORCE_WD2;

    if ( defined $self->proxy ) {
        $args->{desiredCapabilities}->{proxy} = $self->proxy;
    }

    if (   $args->{desiredCapabilities}->{browserName} =~ /firefox/i
        && $self->has_firefox_profile )
    {
        $args->{desiredCapabilities}->{firefox_profile} =
          $self->firefox_profile->_encode;
    }

    $self->_request_new_session($args);
}


sub new_desired_session {
    my ( $self, $caps ) = @_;

    $self->_request_new_session(
        {
            desiredCapabilities => $caps
        }
    );
}

sub _request_new_session {
    my ( $self, $args ) = @_;

    #XXX UGLY shim for webdriver3
    $args->{capabilities}->{alwaysMatch} =
      clone( $args->{desiredCapabilities} );
    my $cmap = $self->commands_v3->get_caps_map();
    my $caps = $self->commands_v3->get_caps();
    foreach my $cap ( keys( %{ $args->{capabilities}->{alwaysMatch} } ) ) {

        #Handle browser specific capabilities
        if ( exists( $args->{desiredCapabilities}->{browserName} )
            && $cap eq 'extra_capabilities' )
        {

            if (
                exists $args->{capabilities}->{alwaysMatch}
                ->{'moz:firefoxOptions'}->{args} )
            {
                $args->{capabilities}->{alwaysMatch}->{$cap}->{args} =
                  $args->{capabilities}->{alwaysMatch}->{'moz:firefoxOptions'}
                  ->{args};
            }
            $args->{capabilities}->{alwaysMatch}->{'moz:firefoxOptions'} =
              $args->{capabilities}->{alwaysMatch}->{$cap}
              if $args->{desiredCapabilities}->{browserName} eq 'firefox';

#XXX the chrome documentation is lies, you can't do this yet
#$args->{capabilities}->{alwaysMatch}->{'goog:chromeOptions'}      = $args->{capabilities}->{alwaysMatch}->{$cap} if $args->{desiredCapabilities}->{browserName} eq 'chrome';
#Does not appear there are any MSIE based options, so let's just let that be
        }
        if (   exists( $args->{desiredCapabilities}->{browserName} )
            && $args->{desiredCapabilities}->{browserName} eq 'firefox'
            && $cap eq 'firefox_profile' )
        {
            if (
                ref $args->{capabilities}->{alwaysMatch}->{$cap} eq
                'Selenium::Firefox::Profile' )
            {
#XXX not sure if I need to keep a ref to the File::Temp::Tempdir object to prevent reaping
                $args->{capabilities}->{alwaysMatch}->{'moz:firefoxOptions'}
                  ->{args} = [
                    '-profile',
                    $args->{capabilities}->{alwaysMatch}->{$cap}->{profile_dir}
                      ->dirname()
                  ];
            }
            else {
           #previously undocumented feature that we can pass the encoded profile
                $args->{capabilities}->{alwaysMatch}->{'moz:firefoxOptions'}
                  ->{profile} = $args->{capabilities}->{alwaysMatch}->{$cap};
            }
        }
        foreach my $newkey ( keys(%$cmap) ) {
            if ( $newkey eq $cap ) {
                last if $cmap->{$newkey} eq $cap;
                $args->{capabilities}->{alwaysMatch}->{ $cmap->{$newkey} } =
                  $args->{capabilities}->{alwaysMatch}->{$cap};
                delete $args->{capabilities}->{alwaysMatch}->{$cap};
                last;
            }
        }
        delete $args->{capabilities}->{alwaysMatch}->{$cap}
          if !any { $_ eq $cap } @$caps;
    }
    delete $args->{desiredCapabilities}
      if $FORCE_WD3;    #XXX fork working-around busted fallback in firefox
    delete $args->{capabilities}
      if $FORCE_WD2; #XXX 'secret' feature to help the legacy unit tests to work

    #Delete compatibility layer when using drivers directly
    if ( $self->isa('Selenium::Firefox') || $self->isa('Selenium::Chrome') ) {
        if (   exists $args->{capabilities}
            && exists $args->{capabilities}->{alwaysMatch} )
        {
            delete $args->{capabilities}->{alwaysMatch}->{browserName};
            delete $args->{capabilities}->{alwaysMatch}->{browserVersion};
            delete $args->{capabilities}->{alwaysMatch}->{platformName};
        }
    }

    #Fix broken out of the box chrome because they hate the maintainers of their interfaces
    if ( $self->isa('Selenium::Chrome') ) {
        if ( exists $args->{desiredCapabilities} ) {
            $args->{desiredCapabilities}{'goog:chromeOptions'}{args} //= [];
            push(@{$args->{desiredCapabilities}{'goog:chromeOptions'}{args}}, qw{no-sandbox disable-dev-shm-usage});
        }
    }

    # Get actual status
    $self->remote_conn->check_status();

    # command => 'newSession' to fool the tests of commands implemented
    # TODO: rewrite the testing better, this is so fragile.
    my $resource_new_session = {
        method => $self->commands->get_method('newSession'),
        url    => $self->commands->get_url('newSession'),
        no_content_success =>
          $self->commands->get_no_content_success('newSession'),
    };
    my $rc = $self->remote_conn;
    my $resp = $rc->request( $resource_new_session, $args, );

    if ( $resp->{cmd_status} && $resp->{cmd_status} eq 'NOT OK' ) {
        croak "Could not obtain new session: ". $resp->{cmd_return}{message};
    }

    if ( ( defined $resp->{'sessionId'} ) && $resp->{'sessionId'} ne '' ) {
        $self->session_id( $resp->{'sessionId'} );
    }
    else {
        my $error = 'Could not create new session';

        if ( ref $resp->{cmd_return} eq 'HASH' ) {
            $error .= ': ' . $resp->{cmd_return}->{message};
        }
        else {
            $error .= ': ' . $resp->{cmd_return};
        }
        croak $error;
    }

    #Webdriver 3 - best guess that this is 'whats goin on'
    if ( ref $resp->{cmd_return} eq 'HASH'
        && $resp->{cmd_return}->{capabilities} )
    {
        $self->{is_wd3}           = 1;
        $self->{emulate_jsonwire} = 1;
        $self->{capabilities}     = $resp->{cmd_return}->{capabilities};
    }

    #XXX chromedriver DOES NOT FOLLOW SPEC!
    if ( ref $resp->{cmd_return} eq 'HASH' && $resp->{cmd_return}->{chrome} ) {
        if ( defined $resp->{cmd_return}->{setWindowRect} )
        {    #XXX i'm inferring we are wd3 based on the presence of this
            $self->{is_wd3}           = 1;
            $self->{emulate_jsonwire} = 1;
            $self->{capabilities}     = $resp->{cmd_return};
        }
    }

    #XXX unsurprisingly, neither does microsoft
    if (   ref $resp->{cmd_return} eq 'HASH'
        && $resp->{cmd_return}->{pageLoadStrategy}
        && $self->browser_name eq 'MicrosoftEdge' )
    {
        $self->{is_wd3}           = 1;
        $self->{emulate_jsonwire} = 1;
        $self->{capabilities}     = $resp->{cmd_return};
    }

    return ( $args, $resp );
}


sub is_webdriver_3 {
    my $self = shift;
    return $self->{is_wd3};
}


sub debug_on {
    my ($self) = @_;
    $self->{debug} = 1;
    $self->remote_conn->debug(1);
}


sub debug_off {
    my ($self) = @_;
    $self->{debug} = 0;
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

    if ( $self->{is_wd3}
        && !( grep { $self->browser_name eq $_ } qw{MicrosoftEdge} ) )
    {
        @strings = map { split( '', $_ ) } @strings;
        my @acts = map {
            (
                {
                    type  => 'keyDown',
                    value => $_,
                },
                {
                    type  => 'keyUp',
                    value => $_,
                }
              )
        } @strings;

        my $action = {
            actions => [
                {
                    id      => 'key',
                    type    => 'key',
                    actions => \@acts,
                }
            ]
        };
        return $self->general_action(%$action);
    }

    my $res    = { 'command' => 'sendKeysToActiveElement' };
    my $params = { 'value'   => \@strings, };
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


sub general_action {
    my ( $self, %action ) = @_;

    _queue_action(%action);
    my $res = { 'command' => 'generalAction' };
    my $out = $self->_execute_command( $res, \%CURRENT_ACTION_CHAIN );
    %CURRENT_ACTION_CHAIN = ( actions => [] );
    return $out;
}

sub _queue_action {
    my (%action) = @_;
    if ( ref $action{actions} eq 'ARRAY' ) {
        foreach my $live_action ( @{ $action{actions} } ) {
            my $existing_action;
            foreach my $global_action ( @{ $CURRENT_ACTION_CHAIN{actions} } ) {
                if ( $global_action->{id} eq $live_action->{id} ) {
                    $existing_action = $global_action;
                    last;
                }
            }
            if ($existing_action) {
                push(
                    @{ $existing_action->{actions} },
                    @{ $live_action->{actions} }
                );
            }
            else {
                push( @{ $CURRENT_ACTION_CHAIN{actions} }, $live_action );
            }
        }
    }
}


sub release_general_action {
    my ($self) = @_;
    my $res = { 'command' => 'releaseGeneralAction' };
    %CURRENT_ACTION_CHAIN = ( actions => [] );
    return $self->_execute_command($res);
}


sub mouse_move_to_location {
    my ( $self, %params ) = @_;
    $params{element} = $params{element}{id} if exists $params{element};

    if ( $self->{is_wd3}
        && !( grep { $self->browser_name eq $_ } qw{MicrosoftEdge} ) )
    {
        my $origin      = $params{element};
        my $move_action = {
            type     => "pointerMove",
            duration => 0,
            x        => $params{xoffset} // 0,
            y        => $params{yoffset} // 0,
        };
        $move_action->{origin} =
          { 'element-6066-11e4-a52e-4f735466cecf' => $origin }
          if $origin;

        _queue_action(
            actions => [
                {
                    type         => "pointer",
                    id           => 'mouse',
                    "parameters" => { "pointerType" => "mouse" },
                    actions      => [$move_action],
                }
            ]
        );
        return 1;
    }

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


sub get_timeouts {
    my $self = shift;
    my $res = { 'command' => 'getTimeouts' };
    return $self->_execute_command( $res, {} );
}


sub set_timeout {
    my ( $self, $type, $ms ) = @_;
    if ( not defined $type ) {
        croak "Expecting type";
    }
    $ms   = _coerce_timeout_ms($ms);
    $type = 'pageLoad'
      if $type eq 'page load'
      && $self->browser_name ne
      'MicrosoftEdge';    #XXX SHIM they changed the WC3 standard mid stream

    my $res    = { 'command' => 'setTimeout' };
    my $params = { $type     => $ms };

    #XXX edge still follows earlier versions of the WC3 standard
    if ( $self->browser_name eq 'MicrosoftEdge' ) {
        $params->{ms}   = $ms;
        $params->{type} = $type;
    }
    return $self->_execute_command( $res, $params );
}


sub set_async_script_timeout {
    my ( $self, $ms ) = @_;

    return $self->set_timeout( 'script', $ms ) if $self->{is_wd3};

    $ms = _coerce_timeout_ms($ms);
    my $res    = { 'command' => 'setAsyncScriptTimeout' };
    my $params = { 'ms'      => $ms };
    return $self->_execute_command( $res, $params );
}


sub set_implicit_wait_timeout {
    my ( $self, $ms ) = @_;
    return $self->set_timeout( 'implicit', $ms ) if $self->{is_wd3};

    $ms = _coerce_timeout_ms($ms);
    my $res    = { 'command' => 'setImplicitWaitTimeout' };
    my $params = { 'ms'      => $ms };
    return $self->_execute_command( $res, $params );
}


sub pause {
    my $self = shift;
    my $timeout = ( shift // 1000 ) * 1000;
    usleep($timeout);
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
    $res = { 'command' => 'getWindowRect', handle => $window }
      if $self->{is_wd3};
    return $self->_execute_command($res);
}


sub get_window_position {
    my ( $self, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    my $res = { 'command' => 'getWindowPosition', 'window_handle' => $window };
    $res = { 'command' => 'getWindowRect', handle => $window }
      if $self->{is_wd3};
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

    if ( $self->has_base_url && $url !~ m|://| ) {
        $url =~ s|^/||;
        $url = $self->base_url . "/" . $url;
    }

    my $res    = { 'command' => 'get' };
    my $params = { 'url'     => $url };
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
    return int( $self->javascript );
}


sub execute_async_script {
    my ( $self, $script, @args ) = @_;
    if ( $self->has_javascript ) {
        if ( not defined $script ) {
            croak 'No script provided';
        }
        my $res =
          { 'command' => 'executeAsyncScript' . $self->_execute_script_suffix };

        # Check the args array if the elem obj is provided & replace it with
        # JSON representation
        for ( my $i = 0 ; $i < @args ; $i++ ) {
            if ( Scalar::Util::blessed( $args[$i] )
                and $args[$i]->isa('Selenium::Remote::WebElement') )
            {
                if ( $self->{is_wd3} ) {
                    $args[$i] =
                      { 'element-6066-11e4-a52e-4f735466cecf' =>
                          ( $args[$i] )->{id} };
                }
                else {
                    $args[$i] = { 'ELEMENT' => ( $args[$i] )->{id} };
                }
            }
        }

        my $params = { 'script' => $script, 'args' => \@args };
        my $ret = $self->_execute_command( $res, $params );

        # replace any ELEMENTS with WebElement
        if (    ref($ret)
            and ( ref($ret) eq 'HASH' )
            and $self->_looks_like_element($ret) )
        {
            $ret = $self->webelement_class->new(
                id     => $ret,
                driver => $self
            );
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
        my $res =
          { 'command' => 'executeScript' . $self->_execute_script_suffix };

        # Check the args array if the elem obj is provided & replace it with
        # JSON representation
        for ( my $i = 0 ; $i < @args ; $i++ ) {
            if ( Scalar::Util::blessed( $args[$i] )
                and $args[$i]->isa('Selenium::Remote::WebElement') )
            {
                if ( $self->{is_wd3} ) {
                    $args[$i] =
                      { 'element-6066-11e4-a52e-4f735466cecf' =>
                          ( $args[$i] )->{id} };
                }
                else {
                    $args[$i] = { 'ELEMENT' => ( $args[$i] )->{id} };
                }
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

# _looks_like_element
# An internal method to check if a return value might be an element

sub _looks_like_element {
    my ( $self, $maybe_element ) = @_;

    return (
             exists $maybe_element->{ELEMENT}
          or exists $maybe_element->{'element-6066-11e4-a52e-4f735466cecf'}
    );
}

# _convert_to_webelement
# An internal method used to traverse a data structure
# and convert any ELEMENTS with WebElements

sub _convert_to_webelement {
    my ( $self, $ret ) = @_;

    if ( ref($ret) and ( ref($ret) eq 'HASH' ) ) {
        if ( $self->_looks_like_element($ret) ) {

            # replace an ELEMENT with WebElement
            return $self->webelement_class->new(
                id     => $ret,
                driver => $self
            );
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
    my ($self, $params) = @_;
    $params //= { full => 0 };

    croak "Full page screenshot only supported on geckodriver" if $params->{full} && ( $self->{browser_name} ne 'firefox' );

    my $res = { 'command' => $params->{'full'} == 1 ? 'mozScreenshotFull' : 'screenshot' };
    return $self->_execute_command($res);
}


sub capture_screenshot {
    my ( $self, $filename, $params ) = @_;
    croak '$filename is required' unless $filename;

    open( my $fh, '>', $filename );
    binmode $fh;
    print $fh MIME::Base64::decode_base64( $self->screenshot($params) );
    CORE::close $fh;
    return 1;
}


#TODO emulate behavior on wd3?
#grep { eval { Selenium::Remote::Driver->new( browser => $_ ) } } (qw{firefox MicrosoftEdge chrome opera safari htmlunit iphone phantomjs},'internet_explorer');
#might do the trick
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
        if ( $self->{is_wd3} ) {
            $params =
              { 'id' =>
                  { 'element-6066-11e4-a52e-4f735466cecf' => $id->{'id'} } };
        }
        else {
            $params = { 'id' => { 'ELEMENT' => $id->{'id'} } };
        }
    }
    else {
        $params = { 'id' => $id };
    }
    return $self->_execute_command( $res, $params );
}


sub switch_to_parent_frame {
    my ($self) = @_;
    my $res = { 'command' => 'switchToParentFrame' };
    return $self->_execute_command($res);
}


sub switch_to_window {
    my ( $self, $name ) = @_;
    if ( not defined $name ) {
        return 'Window name not provided';
    }
    my $res = { 'command' => 'switchToWindow' };
    my $params = { 'name' => $name, 'handle' => $name };
    return $self->_execute_command( $res, $params );
}


sub set_window_position {
    my ( $self, $x, $y, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    if ( not defined $x and not defined $y ) {
        croak "X & Y co-ordinates are required";
    }
    croak qq{Error: In set_window_size, argument x "$x" isn't numeric}
      unless Scalar::Util::looks_like_number($x);
    croak qq{Error: In set_window_size, argument y "$y" isn't numeric}
      unless Scalar::Util::looks_like_number($y);
    $x +=
      0;  # convert to numeric if a string, otherwise they'll be sent as strings
    $y += 0;
    my $res = { 'command' => 'setWindowPosition', 'window_handle' => $window };
    my $params = { 'x' => $x, 'y' => $y };
    if ( $self->{is_wd3} ) {
        $res = { 'command' => 'setWindowRect', handle => $window };
    }
    my $ret = $self->_execute_command( $res, $params );
    return $ret ? 1 : 0;
}


sub set_window_size {
    my ( $self, $height, $width, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    if ( not defined $height and not defined $width ) {
        croak "height & width of browser are required";
    }
    croak qq{Error: In set_window_size, argument height "$height" isn't numeric}
      unless Scalar::Util::looks_like_number($height);
    croak qq{Error: In set_window_size, argument width "$width" isn't numeric}
      unless Scalar::Util::looks_like_number($width);
    $height +=
      0;  # convert to numeric if a string, otherwise they'll be sent as strings
    $width += 0;
    my $res = { 'command' => 'setWindowSize', 'window_handle' => $window };
    my $params = { 'height' => $height, 'width' => $width };
    if ( $self->{is_wd3} ) {
        $res = { 'command' => 'setWindowRect', handle => $window };
    }
    my $ret = $self->_execute_command( $res, $params );
    return $ret ? 1 : 0;
}


sub maximize_window {
    my ( $self, $window ) = @_;

    $window = ( defined $window ) ? $window : 'current';
    my $res = { 'command' => 'maximizeWindow', 'window_handle' => $window };
    my $ret = $self->_execute_command($res);
    return $ret ? 1 : 0;
}


sub minimize_window {
    my ( $self, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    my $res = { 'command' => 'minimizeWindow', 'window_handle' => $window };
    my $ret = $self->_execute_command($res);
    return $ret ? 1 : 0;
}


sub fullscreen_window {
    my ( $self, $window ) = @_;
    $window = ( defined $window ) ? $window : 'current';
    my $res = { 'command' => 'fullscreenWindow', 'window_handle' => $window };
    my $ret = $self->_execute_command($res);
    return $ret ? 1 : 0;
}


sub get_all_cookies {
    my ($self) = @_;
    my $res = { 'command' => 'getAllCookies' };
    return $self->_execute_command($res);
}


sub add_cookie {
    my ( $self, $name, $value, $path, $domain, $secure, $httponly, $expiry ) =
      @_;

    if (   ( not defined $name )
        || ( not defined $value ) )
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
            'secure' => $secure,
        }
    };
    $params->{cookie}->{domain}     = $domain   if $domain;
    $params->{cookie}->{'httponly'} = $httponly if $httponly;
    $params->{cookie}->{'expiry'}   = $expiry   if $expiry;

    return $self->_execute_command( $res, $params );
}


sub delete_all_cookies {
    my ($self) = @_;
    my $res = { 'command' => 'deleteAllCookies' };
    return $self->_execute_command($res);
}


sub get_cookie_named {
    my ( $self, $cookie_name ) = @_;
    my $res = { 'command' => 'getCookieNamed', 'name' => $cookie_name };
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

    my $res = { 'command' => 'findElement' };
    my $params = $self->_build_find_params( $method, $query );
    my $ret_data = eval { $self->_execute_command( $res, $params ); };
    if ($@) {
        if ( $@ =~
/(An element could not be located on the page using the given search parameters)/
          )
        {
            # give details on what element wasn't found
            $@ = "$1: $query,$params->{using}";
            local @CARP_NOT = ( "Selenium::Remote::Driver", @CARP_NOT );
            croak $@;
        }
        else {
            # re throw if the exception wasn't what we expected
            die $@;
        }
    }
    return $self->webelement_class->new(
        id     => $ret_data,
        driver => $self
    );
}


sub find_elements {
    my ( $self, $query, $method ) = @_;
    if ( not defined $query ) {
        croak 'Search string to find element not provided.';
    }

    my $res = { 'command' => 'findElements' };
    my $params = $self->_build_find_params( $method, $query );
    my $ret_data = eval { $self->_execute_command( $res, $params ); };
    if ($@) {
        if ( $@ =~
/(An element could not be located on the page using the given search parameters)/
          )
        {
            # give details on what element wasn't found
            $@ = "$1: $query,$params->{using}";
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
                id     => $_,
                driver => $self
            )
        );
    }
    return wantarray ? @{$elem_obj_arr} : $elem_obj_arr;
}


sub find_child_element {
    my ( $self, $elem, $query, $method ) = @_;
    if ( ( not defined $elem ) || ( not defined $query ) ) {
        croak "Missing parameters";
    }
    my $res = { 'command' => 'findChildElement', 'id' => $elem->{id} };
    my $params = $self->_build_find_params( $method, $query );
    my $ret_data = eval { $self->_execute_command( $res, $params ); };
    if ($@) {
        if ( $@ =~
/(An element could not be located on the page using the given search parameters)/
          )
        {
            # give details on what element wasn't found
            $@ = "$1: $query,$params->{using}";
            local @CARP_NOT = ( "Selenium::Remote::Driver", @CARP_NOT );
            croak $@;
        }
        else {
            # re throw if the exception wasn't what we expected
            die $@;
        }
    }
    return $self->webelement_class->new(
        id     => $ret_data,
        driver => $self
    );
}


sub find_child_elements {
    my ( $self, $elem, $query, $method ) = @_;
    if ( ( not defined $elem ) || ( not defined $query ) ) {
        croak "Missing parameters";
    }

    my $res = { 'command' => 'findChildElements', 'id' => $elem->{id} };
    my $params = $self->_build_find_params( $method, $query );
    my $ret_data = eval { $self->_execute_command( $res, $params ); };
    if ($@) {
        if ( $@ =~
/(An element could not be located on the page using the given search parameters)/
          )
        {
            # give details on what element wasn't found
            $@ = "$1: $query,$params->{using}";
            local @CARP_NOT = ( "Selenium::Remote::Driver", @CARP_NOT );
            croak $@;
        }
        else {
            # re throw if the exception wasn't what we expected
            die $@;
        }
    }
    my $elem_obj_arr = [];
    my $i            = 0;
    foreach (@$ret_data) {
        $elem_obj_arr->[$i] = $self->webelement_class->new(
            id     => $_,
            driver => $self
        );
        $i++;
    }
    return wantarray ? @{$elem_obj_arr} : $elem_obj_arr;
}


sub _build_find_params {
    my ( $self, $method, $query ) = @_;

    my $using = $self->_build_using($method);

    # geckodriver doesn't accept name as a valid selector
    if ( $self->isa('Selenium::Firefox') && $using eq 'name' ) {
        return {
            using => 'css selector',
            value => qq{[name="$query"]}
        };
    }
    else {
        return {
            using => $using,
            value => $query
        };
    }
}

sub _build_using {
    my ( $self, $method ) = @_;

    if ($method) {
        if ( $self->FINDERS->{$method} ) {
            return $self->FINDERS->{$method};
        }
        else {
            croak 'Bad method, expected: '
              . join( ', ', keys %{ $self->FINDERS } )
              . ", got $method";
        }
    }
    else {
        return $self->default_finder;
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
        return $self->webelement_class->new(
            id     => $ret_data,
            driver => $self
        );
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
    return $self->_execute_command( $res, { type => $type } );
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

    if ( $self->{is_wd3}
        && !( grep { $self->browser_name eq $_ } qw{MicrosoftEdge} ) )
    {
        my $acts = [
            {
                type => $isdown ? 'keyDown' : 'keyUp',
                value => KEYS->{ lc($modifier) },
            },
        ];

        my $action = {
            actions => [
                {
                    id      => 'key',
                    type    => 'key',
                    actions => $acts,
                }
            ]
        };
        _queue_action(%$action);
        return 1;
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
    my ( $self, $button, $append ) = @_;
    $button = _get_button($button);

    my $res    = { 'command' => 'click' };
    my $params = { 'button'  => $button };

    if ( $self->{is_wd3}
        && !( grep { $self->browser_name eq $_ } qw{MicrosoftEdge} ) )
    {
        $params = {
            actions => [
                {
                    type       => "pointer",
                    id         => 'mouse',
                    parameters => { "pointerType" => "mouse" },
                    actions    => [
                        {
                            type     => "pointerDown",
                            duration => 0,
                            button   => $button,
                        },
                        {
                            type     => "pointerUp",
                            duration => 0,
                            button   => $button,
                        },
                    ],
                }
            ],
        };
        if ($append) {
            _queue_action(%$params);
            return 1;
        }
        return $self->general_action(%$params);
    }

    return $self->_execute_command( $res, $params );
}

sub _get_button {
    my $button = shift;
    my $button_enum = { LEFT => 0, MIDDLE => 1, RIGHT => 2 };
    if ( defined $button && $button =~ /(LEFT|MIDDLE|RIGHT)/i ) {
        return $button_enum->{ uc $1 };
    }
    if ( defined $button && $button =~ /(0|1|2)/ ) {
        #Handle user error sending in "1"
        return int($1);
    }
    return 0;
}


sub double_click {
    my ( $self, $button ) = @_;

    $button = _get_button($button);

    if ( $self->{is_wd3}
        && !( grep { $self->browser_name eq $_ } qw{MicrosoftEdge} ) )
    {
        $self->click( $button, 1 );
        $self->click( $button, 1 );
        return $self->general_action();
    }

    my $res = { 'command' => 'doubleClick' };
    return $self->_execute_command($res);
}


sub button_down {
    my ($self) = @_;

    if ( $self->{is_wd3}
        && !( grep { $self->browser_name eq $_ } qw{MicrosoftEdge} ) )
    {
        my $params = {
            actions => [
                {
                    type       => "pointer",
                    id         => 'mouse',
                    parameters => { "pointerType" => "mouse" },
                    actions    => [
                        {
                            type     => "pointerDown",
                            duration => 0,
                            button   => 0,
                        },
                    ],
                }
            ],
        };
        _queue_action(%$params);
        return 1;
    }

    my $res = { 'command' => 'buttonDown' };
    return $self->_execute_command($res);
}


sub button_up {
    my ($self) = @_;

    if ( $self->{is_wd3}
        && !( grep { $self->browser_name eq $_ } qw{MicrosoftEdge} ) )
    {
        my $params = {
            actions => [
                {
                    type       => "pointer",
                    id         => 'mouse',
                    parameters => { "pointerType" => "mouse" },
                    actions    => [
                        {
                            type     => "pointerDown",
                            duration => 0,
                            button   => 0,
                        },
                    ],
                }
            ],
        };
        _queue_action(%$params);
        return 1;
    }

    my $res = { 'command' => 'buttonUp' };
    return $self->_execute_command($res);
}


# this method duplicates upload() method in the
# org.openqa.selenium.remote.RemoteWebElement java class.

sub upload_file {
    my ( $self, $filename, $raw_content ) = @_;

    my $params;
    if ( defined $raw_content ) {

        #If no processing is passed, send the argument raw
        $params = { file => $raw_content };
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
    my ( $self, $filename ) = @_;

    if ( not -r $filename ) { croak "upload_file: no such file: $filename"; }
    my $string = "";                            # buffer
    my $zip    = Archive::Zip->new();
    $zip->addFile( $filename, basename($filename) );
    if ( $zip->writeToFileHandle( IO::String->new($string) ) != AZ_OK ) {
        die 'zip failed';
    }

    return { file => MIME::Base64::encode_base64( $string, '' ) };
}


sub get_text {
    my $self = shift;
    return $self->find_element(@_)->get_text();
}


sub get_body {
    my $self = shift;
    return $self->get_text( '//body', 'xpath' );
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
    my $self     = shift;
    my $height   = shift;
    my $width    = shift;
    my $location = $self->get_current_url;

    $self->execute_script( 'window.open("' . $location . '", "_blank")' );
    $self->close;
    my @handles = @{ $self->get_window_handles };
    $self->switch_to_window( pop @handles );

    my @resize = (
        'window.innerHeight = ' . $height,
        'window.innerWidth  = ' . $width,
        'return 1'
    );

    return $self->execute_script( join( ';', @resize ) ) ? 1 : 0;
}


sub get_local_storage_item {
    my ( $self, $key ) = @_;
    my $res    = { 'command' => 'getLocalStorageItem' };
    my $params = { 'key'     => $key };
    return $self->_execute_command( $res, $params );
}


sub delete_local_storage_item {
    my ( $self, $key ) = @_;
    my $res    = { 'command' => 'deleteLocalStorageItem' };
    my $params = { 'key'     => $key };
    return $self->_execute_command( $res, $params );
}

sub _coerce_timeout_ms {
    my ($ms) = @_;

    if ( defined $ms ) {
        return _coerce_number($ms);
    }
    else {
        croak 'Expecting a timeout in ms';
    }
}

sub _coerce_number {
    my ($maybe_number) = @_;

    if ( Scalar::Util::looks_like_number($maybe_number) ) {
        return $maybe_number + 0;
    }
    else {
        croak "Expecting a number, not: $maybe_number";
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Driver - Perl Client for Selenium Remote Driver

=head1 VERSION

version 1.39

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

L<https://www.seleniumhq.org/download/>

This module sends commands directly to the Server using HTTP. Using this module
together with the Selenium Server, you can automatically control any supported
browser. To use this module, you need to have already downloaded and started
the Selenium Server (Selenium Server is a Java application).

=for Pod::Coverage BUILD

=for Pod::Coverage DEMOLISH

=head1 USAGE

=head2 Without Standalone Server

As of v0.25, it's possible to use this module without a standalone
server - that is, you would not need the JRE or the JDK to run your
Selenium tests. See L<Selenium::Chrome>, L<Selenium::PhantomJS>,
L<Selenium::Edge>, L<Selenium::InternetExplorer>,and L<Selenium::Firefox>
for details. If you'd like additional browsers besides these,
give us a holler over in
L<Github|https://github.com/teodesian/Selenium-Remote-Driver/issues>.

=head2 Remote Driver Response

Selenium::Remote::Driver uses the
L<JsonWireProtocol|https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol>
And the
L<WC3 WebDriver Protocol|https://www.w3.org/TR/webdriver/>
to communicate with the Selenium Server. If an error occurs while
executing the command then the server sends back an HTTP error code
with a JSON encoded reponse that indicates the precise
L<Response Error Code|https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol#response-status-codes>.
The module will then croak with the error message associated with this
code. If no error occurred, then the subroutine called will return the
value sent back from the server (if a return value was sent).

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

=head2 LWP Read Timeout errors

It's possible to make Selenium calls that take longer than the default
L<LWP::UserAgent> timeout. For example, setting the asynchronous
script timeout greater than the LWP::UserAgent timeout and then
executing a long running asynchronous snippet of javascript will
immediately trigger an error like:

    Error while executing command: executeAsyncScript: Server returned
    error message read timeout at...

You can get around this by configuring LWP's timeout value, either by
constructing your own LWP and passing it in to ::Driver during
instantiation

    my $timeout_ua = LWP::UserAgent->new;
    $timeout_ua->timeout(360); # this value is in seconds!
    my $d = Selenium::Remote::Driver->new( ua => $timeout_ua );

or by configuring the timeout on the fly as necessary:

    use feature qw/say/;
    use Selenium::Remote::Driver;

    my $d = Selenium::Remote::Driver->new;
    say $d->ua->timeout; # 180 seconds is the default

    $d->ua->timeout(2); # LWP wants seconds, not milliseconds!
    $d->set_timeout('script', 1000); # S::R::D wants milliseconds!

    # Async scripts only return when the callback is invoked. Since there
    # is no callback here, Selenium will block for the entire duration of
    # the async timeout script. This will hit Selenium's async script
    # timeout before hitting LWP::UserAgent's read timeout
    $d->execute_async_script('return "hello"');

    $d->quit;

=head1 TESTING

If are writing automated tests using this module, you may be
interested in L<Test::Selenium::Remote::Driver> which is also included
in this distribution. It includes convenience testing methods for many
of the selenum methods available here.

Your other option is to use this module in conjunction with your
choice of testing modules, like L<Test::Spec> or L<Test::More> as
you please.

=head1 WC3 WEBDRIVER COMPATIBILITY

WC3 Webdriver is a constantly evolving standard, so some things may or may not work at any given time.

Furthermore, out of date drivers probably identify as WD3, while only implementing a few methods and retaining JSONWire functionality.
One way of dealing with this is setting:

    $driver->{is_wd3} = 0

Of course, this will prevent access of any new WC3 methods, but will probably make your tests pass until your browser's driver gets it's act together.

There are also some JSONWire behaviors that we emulate in methods, such as Selenium::Remote::WebElement::get_attribute.
You can get around that by passing an extra flag to the sub, or setting:

    $driver->{emulate_jsonwire} = 0;

When in WC3 Webdriver mode.

=head2 FINDERS

This constant is a hashref map of the old element finder aliases from wd2 to wd3.

    use Data::Dumper;
    print Dumper($Selenium::Remote::Driver::FINDERS);

=head2 WC3 WEBDRIVER CURRENT STATUS

That said, the following 'sanity tests' in the at/ (acceptance test) directory of the module passed on the following versions:

=over 4

=item Selenium Server: 3.8.1 - all tests

=item geckodriver: 0.19.1 - at/sanity.test, at/firefox.test (Selenium::Firefox)

=item chromedriver: 2.35 - at/sanity-chrome.test, at/chrome.test (Selenium::Chrome)

=item edgedriver: 5.16299 - at/sanity-edge.test

=item InternetExplorerDriver : 3.8.1 - at/sanity-ie.test (be sure to enable 'allow local files to run active content in your 'advanced settings' pane)

=item safaridriver : 11.0.2 - at/sanity-safari.test (be sure to enable 'allow automated testing' in the developer menu) -- it appears WC3 spec is *unimplemented*

=back

These tests are intended to be run directly against a working selenium server on the local host with said drivers configured.

If you are curious as to what 'works and does not' on your driver versions (and a few other quirks),
it is strongly encouraged you look at where the test calls the methods you are interested in.

While other browsers/drivers (especially legacy ones) likely work fine as well,
any new browser/driver will likely have problems if it's not listed above.

There is also a 'legacy.test' file available to run against old browsers/selenium (2.x servers, pre geckodriver).
This should only be used to verify backwards-compatibility has not been broken.

=head2 Firefox Notes

If you are intending to pass extra_capabilities to firefox on a WD3 enabled server with geckodriver, you MUST do the following:

   $Selenium::Remote::Driver::FORCE_WD3=1;

This is because the gecko driver prefers legacy capabilities, both of which are normally passed for compatibility reasons.

=head2 Chrome Notes

Use the option goog:chromeOptions instead of chromeOptions, if you are intending to pass extra_capabilities on a
WD3 enabled server with chromedriver enabled.

    https://sites.google.com/a/chromium.org/chromedriver/capabilities

Also, if you instantiate the object in WC3 mode (which is the default), the remote driver will throw exceptions you have no choice but to catch,
rather than falling back to JSONWire methods where applicable like geckodriver does.

As of chrome 75 (and it's appropriate driver versions), the WC3 spec has finally been implemented.
As such, to use chrome older than this, you will have to manually force on JSONWire mode:

    $Selenium::Remote::Driver::FORCE_WD2=1;

=head2 Notes on Running Selenium at Scale via selenium.jar

When running many, many tests in parallel you can eventually reach resource exhaustion.
You have to instruct the Selenium JAR to do some cleanup to avoid explosions:

Inside of your selenium server's node.json (running a grid), you would put in the following:

"configuration" :
{
"cleanUpCycle":2000
}
Or run the selenium jar with the -cleanupCycle parameter. Of course use whatever # of seconds is appropriate to your situation.

=head1 CONSTRUCTOR

=head2 new

Dies if communication with the selenium server cannot be established.

Input: (all optional)

Desired capabilities - HASH - Following options are accepted:

=over 4

=item B<remote_server_addr> - <string>   - IP or FQDN of the Webdriver server machine. Default: 'localhost'

=item B<port>               - <string>   - Port on which the Webdriver server is listening. Default: 4444

=item B<browser_name>       - <string>   - desired browser string: {phantomjs|firefox|internet explorer|MicrosoftEdge|safari|htmlunit|iphone|chrome}

=item B<version>            - <string>   - desired browser version number

=item B<platform>           - <string>   - desired platform: {WINDOWS|XP|VISTA|MAC|LINUX|UNIX|ANY}

=item B<accept_ssl_certs>   - <boolean>  - whether SSL certs should be accepted, default is true.

=item B<firefox_profile>    - Profile    - Use Selenium::Firefox::Profile to create a Firefox profile for the browser to use.

=item B<javascript>         - <boolean> - Whether or not to use Javascript.  You probably won't disable this, as you would be using L<WWW::Mechanize> instead.  Default: True

=item B<auto_close>         - <boolean> - Whether to automatically close the browser session on the server when the object goes out of scope. Default: False.

=item B<default_finder>     - <string> - Default method by which to evaluate selectors.  Default: 'xpath'

=item B<session_id>         - <string> - Provide a Session ID to highjack a browser session on the remote server.  Useful for micro-optimizers.  Default: undef

=item B<pageLoadStrategy>   - STRING   - OPTIONAL, 'normal|eager|none'. default 'normal'. WebDriver3 only.

=item B<extra_capabilities> - HASH     - Any other extra capabilities.  Accepted keys will vary by browser.  If firefox_profile is passed, the args (or profile) key will be overwritten, depending on how it was passed.

=item B<debug>              - BOOL     - Turn Debug mode on from the start if true, rather than having to call debug_on().

=back

On WebDriver3 the 'extra_capabilities' will be automatically converted into the parameter needed by your browser.
For example, extra_capabilities is passed to the server as the moz:firefoxOptions parameter.

You can also specify some options in the constructor hash that are
not part of the browser-related desired capabilities.

=over 4

=item B<auto_close>        - <boolean>   - whether driver should end session on remote server on close.

=item B<base_url>          - <string>    - OPTIONAL, base url for the website Selenium acts on. This can save you from repeating the domain in every call to $driver->get()

=item B<default_finder>    - <string>    - choose default finder used for find_element* {class|class_name|css|id|link|link_text|name|partial_link_text|tag_name|xpath}

=item B<inner_window_size> - <aref[Int]> - An array ref [ height, width ] that the browser window should use as its initial size immediately after instantiation

=item B<error_handler>     - CODEREF     - A CODEREF that we will call in event of any exceptions. See L</error_handler> for more details.

=item B<webelement_class>  - <string>    - sub-class of Selenium::Remote::WebElement if you wish to use an alternate WebElement class.

=item B<ua>                - LWP::UserAgent instance - if you wish to use a specific $ua, like from Test::LWP::UserAgent

=item B<proxy>              - HASH       - Proxy configuration with the following keys:

=over 4

=item B<proxyType> - <string> - REQUIRED, Possible values are:

    direct     - A direct connection - no proxy in use,
    manual     - Manual proxy settings configured, e.g. setting a proxy for HTTP, a proxy for FTP, etc,
    pac        - Proxy autoconfiguration from a URL,
    autodetect - proxy autodetection, probably with WPAD,
    system     - Use system settings

=item B<proxyAutoconfigUrl> - <string> - REQUIRED if proxyType is 'pac', ignored otherwise. Expected format: http://hostname.com:1234/pacfile or file:///path/to/pacfile

=item B<ftpProxy>           - <string> - OPTIONAL, ignored if proxyType is not 'manual'. Expected format: hostname.com:1234

=item B<httpProxy>          - <string> - OPTIONAL, ignored if proxyType is not 'manual'. Expected format: hostname.com:1234

=item B<sslProxy>           - <string> - OPTIONAL, ignored if proxyType is not 'manual'. Expected format: hostname.com:1234

=item B<socksProxy>         - <string> - OPTIONAL, ignored if proxyType is not 'manual'. Expected format: hostname.com:1234.  WebDriver 3 only.

=item B<socksVersion>       - <int>    - OPTIONAL, ignored if proxyType is not 'manual'. WebDriver 3 only.

=item B<noProxy>            - <ARRAY>  - OPTIONAL, list of URLs to bypass the proxy for. WebDriver3 only.

=item B<firefox_profile>    - <string> - Base64 encoded ZIP file of a firefox profile directory, for use when you don't want/need Selenium::Firefox::Profile.

=back

=back

Output:

Selenium::Remote::Driver object

Usage:

    my $driver = Selenium::Remote::Driver->new;

    #or
    my $driver = Selenium::Remote::Driver->new('browser_name' => 'firefox',
                                               'platform'     => 'MAC');

    #or (for Firefox 47 or lower on Selenium 3+)
    my $driver = Selenium::Remote::Driver->new('browser_name' => 'firefox',
                                               'platform'     => 'MAC',
                                               'extra_capabilities' => {
                                                    'marionette' => \0,
                                              });

    #or
    my $driver = Selenium::Remote::Driver->new('remote_server_addr' => '10.10.1.1',
                                               'port'               => '2222',
                                               'auto_close'         => 0);

    #or
    my $driver = Selenium::Remote::Driver->new('browser_name' =>'chrome',
                                               'extra_capabilities' => {
                                                   'goog:chromeOptions' => {
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

    #or
    my $driver = Selenium::Remote::Driver->new('proxy' => {'proxyType' => 'manual', 'httpProxy' => 'myproxy.com:1234'});

    #or
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

Your error handler will receive three arguments: the first argument is
the C<$driver> object itself, and the second argument is the exception
message and stack trace in one multiline string.  The final argument(s) are the
argument array to the command just executed.

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

=for Pod::Coverage has_base_url

=for Pod::Coverage has_desired_capabilities

=for Pod::Coverage has_error_handler

=for Pod::Coverage has_firefox_profile

=for Pod::Coverage has_inner_window_size

=for Pod::Coverage has_javascript

=for Pod::Coverage has_port

=for Pod::Coverage has_remote_server_addr

=head1 METHODS

=head2 new_session (extra_capabilities)

Make a new session on the server.
Called by new(), not intended for regular use.

Occaisonally handy for recovering from brower crashes.

DANGER DANGER DANGER

This will throw away your old session if you have not closed it!

DANGER DANGER DANGER

=head2 new_desired_session(capabilities)

Basically the same as new_session, but with caps.
Sort of an analog to new_from_caps.

=head2 is_webdriver_3

Print whether the server (or browser) thinks it's implemented webdriver 3.
If this returns true, webdriver 3 methods will be used in the case an action exists in L<Selenium::Remote::Spec> for the method you are trying to call.
If a method you are calling has no webdriver 3 equivalent (or browser extension), the legacy commands implemented in L<Selenium::Remote::Commands> will be used.

Note how I said *thinks* above.  In the case you want to force usage of legacy methods, set $driver->{is_wd3} to work around various browser issues.

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

 Compatibility:
    On webdriver 3 servers, don't use this to send modifier keys; use send_modifier instead.

 Input: 1
    Required:
        {ARRAY | STRING} - Array of strings or a string.

 Usage:
    $driver->send_keys_to_active_element('abcd', 'efg');
    $driver->send_keys_to_active_element('hijk');

    or

    # include the WDKeys module
    use Selenium::Remote::WDKeys;
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

=head2 general_action

Provide an 'actions definition' hash to make webdriver use input devices.
Given the spec for the structure of this data is 'non normative',
it is left as an exercise to the reader what that means as to how to use this function.

That said, it seems most of the data looks something like this:

    $driver->general_action( actions => [{
        type => 'pointer|key|none|somethingElseSuperSpecialDefinedByYourBrowserDriver',
        id => MUST be mouse|key|none|other.  And by 'other' I mean anything else.  The first 3 are 'special' in that they are used in the global actions queue.
              If you want say, another mouse action to execute in parallel to other mouse actions (to simulate multi-touch, for example), call your action 'otherMouseAction' or something.
        parameters => {
            someOption => "basically these are global parameters used by all steps in the forthcoming "action chain".
        },
        actions => [
            {
                type => "keyUp|KeyDown if key, pointerUp|pointerDown|pointerMove|pointerCancel if pointer, pause if any type",
                key => A raw keycode or character from the keyboard if this is a key event,
                duration => how many 'ticks' this action should take, you probably want this to be 0 all of the time unless you are evading Software debounce.
                button => what number button if you are using a pointer (this sounds terribly like it might be re-purposed to be a joypad in the future sometime)
                origin => Point of Origin if moving a pointer around
                x => unit vector to travel along x-axis if pointerMove event
                y => unit vector to travel along y-axis if pointerMove event
            },
            ...
        ]
        },
        ...
        ]
    )

Only available on WebDriver3 capable selenium servers.

If you have called any legacy shim, such as mouse_move_to_location() previously, your actions passed will be appended to the existing actions queue.
Called with no arguments, it simply executes the existing action queue.

If you are looking for pre-baked action chains that aren't currently part of L<Selenium::Remote::Driver>,
consider L<Selenium::ActionChains>, which is shipped with this distribution instead.

=head3 COMPATIBILITY

Like most places, the WC3 standard is openly ignored by the driver binaries.
Generally an "actions" object will only accept:

    { type => ..., value => ... }

When using the direct drivers (E.G. Selenium::Chrome, Selenium::Firefox).
This is not documented anywhere but here, as far as I can tell.

=head2 release_general_action

Nukes *all* input device state (modifier key up/down, pointer button up/down, pointer location, and other device state) from orbit.
Call if you forget to do a *Up event in your provided action chains, or just to save time.

Also clears the current actions queue.

Only available on WebDriver3 capable selenium servers.

=head2 mouse_move_to_location

 Description:
    Move the mouse by an offset of the specificed element. If no
    element is specified, the move is relative to the current mouse
    cursor. If an element is provided but no offset, the mouse will be
    moved to the center of the element. If the element is not visible,
    it will be scrolled into view.

 Compatibility:
    Due to limitations in the Webdriver 3 API, mouse movements have to be executed 'lazily' e.g. only right before a click() event occurs.
    This is because there is no longer any persistent mouse location state; mouse movements are now totally atomic.
    This has several problematic aspects; for one, I can't think of a way to both hover an element and then do another action relying on the element staying hover()ed,
    Aside from using javascript workarounds.

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

=head2 get_timeouts

  Description:
    Get the currently configured values (ms) for the page load, script and implicit timeouts.

  Compatibility:
    Only available on WebDriver3 enabled selenium servers.

  Usage:
    $driver->get_timeouts();

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

    This is exactly equivalent to calling L</set_timeout> with a type
    arg of C<"implicit">.

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

 DEPRECATED: consider using Time::HiRes instead.

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
    DELETE the session, closing open browsers. We will try to call
    this on our down when we get destroyed, but in the event that we
    are demolished during global destruction, we will not be able to
    close the browser. For your own unattended and/or complicated
    tests, we recommend explicitly calling quit to make sure you're
    not leaving orphan browsers around.

    Note that as a Moo class, we use a subroutine called DEMOLISH that
    takes the place of DESTROY; for more information, see
    https://metacpan.org/pod/Moo#DEMOLISH.

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

 Compatibility:
    The ability to get the size of arbitrary handles by passing input only exists in WebDriver2.
    You will have to switch to the window first going forward.

 Input:
    STRING - <optional> - window handle (default is 'current' window)

 Output:
    HASH - containing keys 'height' & 'width'

 Usage:
    my $window_size = $driver->get_window_size();
    print $window_size->{'height'}, $window_size->{'width'};

=head2 get_window_position

 Description:
    Retrieve the window position

 Compatibility:
    The ability to get the size of arbitrary handles by passing input only exists in WebDriver2.
    You will have to switch to the window first going forward.

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

=head2 has_javascript

 Description:
    returns true if javascript is enabled in the driver.

 Compatibility:
    Can't be false on WebDriver 3.

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
    Optionally pass {'full' => 1} as argument to take a full screenshot and not
    only the viewport. (Works only with firefox and geckodriver >= 0.24.0)

 Output:
    STRING - base64 encoded image

 Usage:
    print $driver->screenshot();
    print $driver->screenshot({'full' => 1});

To conveniently write the screenshot to a file, see L</capture_screenshot>.

=head2 capture_screenshot

 Description:
    Capture a screenshot and save as a PNG to provided file name.
    (The method is compatible with the WWW::Selenium method of the same name)
    Optionally pass {'full' => 1} as second argument to take a full screenshot
    and not only the viewport. (Works only with firefox and geckodriver >= 0.24.0)

 Output:
    TRUE - (Screenshot is written to file)

 Usage:
    $driver->capture_screenshot($filename);
    $driver->capture_screenshot($filename, {'full' => 1});

=head2 available_engines

 Description:
    List all available engines on the machine. To use an engine, it has to be present in this list.

 Compatibility:
    Does not appear to be available on Webdriver3 enabled selenium servers.

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

=head3 COMPATIBILITY

Chromedriver will vomit if you pass anything but a webElement, so you probably should do that from now on.

=head2 switch_to_parent_frame

Webdriver 3 equivalent of calling switch_to_frame with no arguments (e.g. NULL frame).
This is actually called in that case, supposing you are using WD3 capable servers now.

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

=head2 set_window_position

 Description:
    Set the position (on screen) where you want your browser to be displayed.

 Compatibility:
    In webDriver 3 enabled selenium servers, you may only operate on the focused window.
    As such, the window handle argument below will be ignored in this context.

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

 Compatibility:
    In webDriver 3 enabled selenium servers, you may only operate on the focused window.
    As such, the window handle argument below will be ignored in this context.

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

 Compatibility:
    In webDriver 3 enabled selenium servers, you may only operate on the focused window.
    As such, the window handle argument below will be ignored in this context.

    Also, on chromedriver maximize is actually just setting the window size to the screen's
    available height and width.

 Input:
    STRING - <optional> - window handle (default is 'current' window)

 Output:
    BOOLEAN - Success or failure

 Usage:
    $driver->maximize_window();

=head2 minimize_window

 Description:
    Minimizes the currently focused browser window (webdriver3 only)

 Output:
    BOOLEAN - Success or failure

 Usage:
    $driver->minimize_window();

=head2 fullscreen_window

 Description:
    Fullscreens the currently focused browser window (webdriver3 only)

 Output:
    BOOLEAN - Success or failure

 Usage:
    $driver->fullscreen_window();

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

 Input: 2 (4 optional)
    Required:
        'name'   - STRING
        'value'  - STRING

    Optional:
        'path'   - STRING
        'domain' - STRING
        'secure'   - BOOLEAN - default false.
        'httponly' - BOOLEAN - default false.
        'expiry'   - TIME_T  - default 20 years in the future

 Usage:
    $driver->add_cookie('foo', 'bar', '/', '.google.com', 0, 1)

=head2 delete_all_cookies

 Description:
    Delete all cookies visible to the current page.

 Usage:
    $driver->delete_all_cookies();

=head2 get_cookie_named

Basically get only the cookie with the provided name.
Probably preferable to pick it out of the list unless you expect a *really* long list.

 Input:
    Cookie Name - STRING

Returns cookie definition hash, much like the elements in get_all_cookies();

  Compatibility:
    Only available on webdriver3 enabled selenium servers.

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
    # note the usage of ./ when searching for a child element instead of //
    my $child = $driver->find_child_elements($elem1, "./option");

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
    queue - (optional) queue the click, rather than executing it.  WD3 only.

 Usage:
    $driver->click('LEFT');
    $driver->click(1); #MIDDLE
    $driver->click('RIGHT');
    $driver->click;  #Defaults to left

=head2 double_click

 Description:
    Double-clicks at the current mouse coordinates (set by moveto).

 Compatibility:
    On webdriver3 enabled servers, you can double click arbitrary mouse buttons.

 Usage:
    $driver->double_click(button);

=head2 button_down

 Description:
    Click and hold the left mouse button (at the coordinates set by the
    last moveto command). Note that the next mouse-related command that
    should follow is buttonup . Any other mouse command (such as click
    or another call to buttondown) will yield undefined behaviour.

 Compatibility:
    On WebDriver 3 enabled servers, all this does is queue a button down action.
    You will either have to call general_action() to perform the queue, or an action like click() which also clears the queue.

 Usage:
    $self->button_down;

=head2 button_up

 Description:
    Releases the mouse button previously held (where the mouse is
    currently at). Must be called once for every buttondown command
    issued. See the note in click and buttondown about implications of
    out-of-order commands.

 Compatibility:
    On WebDriver 3 enabled servers, all this does is queue a button down action.
    You will either have to call general_action() to perform the queue, or an action like click() which also clears the queue.

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

L<L<https://github.com/SeleniumHQ/selenium> - the main selenium RC project|L<https://github.com/SeleniumHQ/selenium> - the main selenium RC project>

=item *

L<L<https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol> - the "legacy" webdriver specification|L<https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol> - the "legacy" webdriver specification>

=item *

L<L<https://www.w3.org/TR/webdriver/> - the WC3 WebDriver 3 specification|L<https://www.w3.org/TR/webdriver/> - the WC3 WebDriver 3 specification>

=item *

L<https://github.com/teodesian/Selenium-Remote-Driver/wiki>

=item *

L<Brownie|Brownie>

=item *

L<Wight|Wight>

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

=head1 CONTRIBUTORS

=for stopwords Allen Lew A.MacLeay Andy Jack Bas Bloemsaat Blake GH Brian Horakh Charles Howes Chris Davies Daniel Fackrell Dave Rolsky Dmitry Karasik Doug Bell Dylan Streb Eric Johnson Gabor Szabo George S. Baugh Gerhard Jungwirth Gordon Child GreatFlamingFoo Ivan Kurmanov Joe Higton Jon Hermansen Keita Sugama Ken Swanson lembark Luke Closs Martin Gruner Matthew Spahr Max O'Cull Michael Prokop mk654321 Peter Mottram (SysPete) Phil Kania Mitchell Prateek Goyal Richard Sailer Robert Utter rouzier Tetsuya Tatsumi Tod Hagan Tom Hukins Vangelis Katsikaros Vishwanath Janmanchi Viťas Strádal Yuki Kimoto Yves Lavoie

=over 4

=item *

Allen Lew <allen@alew.org>

=item *

A.MacLeay <a.macleay@gmail.com>

=item *

Andy Jack <andyjack@users.noreply.github.com>

=item *

Andy Jack <github@veracity.ca>

=item *

Bas Bloemsaat <bas@bloemsaat.com>

=item *

Blake GH <blake@mobiusconsortium.org>

=item *

Brian Horakh <brianh@zoovy.com>

=item *

Charles Howes <charles.howes@globalrelay.net>

=item *

Chris Davies <FMQA@users.noreply.github.com>

=item *

Daniel Fackrell <dfackrell@bluehost.com>

=item *

Dave Rolsky <autarch@urth.org>

=item *

Dmitry Karasik <dmitry@karasik.eu.org>

=item *

Doug Bell <doug@preaction.me>

=item *

Dylan Streb <dylan.streb@oneil.com>

=item *

Eric Johnson <eric.git@iijo.org>

=item *

Gabor Szabo <gabor@szabgab.com>

=item *

George S. Baugh <george.b@cpanel.net>

=item *

Gerhard Jungwirth <gjungwirth@sipwise.com>

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

lembark <lembark@wrkhors.com>

=item *

Luke Closs <lukec@users.noreply.github.com>

=item *

Martin Gruner <martin.gruner@otrs.com>

=item *

Matthew Spahr <matthew.spahr@cpanel.net>

=item *

Max O'Cull <maxattax97@gmail.com>

=item *

Michael Prokop <mprokop@sipwise.com>

=item *

mk654321 <kosmichal@gmail.com>

=item *

Peter Mottram (SysPete) <peter@sysnix.com>

=item *

Phil Kania <phil@vivox.com>

=item *

Phil Mitchell <phil.mitchell@pobox.com>

=item *

Prateek Goyal <prateek.goyal5@gmail.com>

=item *

Richard Sailer <richard@weltraumpflege.org>

=item *

Robert Utter <utter.robert@gmail.com>

=item *

rouzier <rouzier@gmail.com>

=item *

Tetsuya Tatsumi <ttatsumi@ra2.so-net.ne.jp>

=item *

Tod Hagan <42418406+tod222@users.noreply.github.com>

=item *

Tom Hukins <tom@eborcom.com>

=item *

Vangelis Katsikaros <vangelis@adzuna.com>

=item *

Vangelis Katsikaros <vkatsikaros@gmail.com>

=item *

Vishwanath Janmanchi <jvishwanath@gmail.com>

=item *

Viťas Strádal <vitas@matfyz.cz>

=item *

Yuki Kimoto <kimoto.yuki@gmail.com>

=item *

Yves Lavoie <ylavoie@yveslavoie.com>

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
