# --
# Kernel/System/WebUserAgent.pm - a web user agent
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::WebUserAgent;

use strict;
use warnings;

use HTTP::Headers;
use List::Util qw(first);
use LWP::UserAgent;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::WebUserAgent - a web user agent lib

=head1 SYNOPSIS

All web user agent functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::WebUserAgent;

    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        Timeout => 15,                  # optional, timeout
        Proxy   => 'proxy.example.com', # optional, proxy
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get database object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Self->{Timeout} = $Param{Timeout} || $ConfigObject->Get('WebUserAgent::Timeout') || 15;
    $Self->{Proxy}   = $Param{Proxy}   || $ConfigObject->Get('WebUserAgent::Proxy')   || '';

    return $Self;
}

=item Request()

return the content of requested URL.

Simple GET request:

    my %Response = $WebUserAgentObject->Request(
        URL => 'http://example.com/somedata.xml',
    );

Or a POST request; attributes can be a hashref like this:

    my %Response = $WebUserAgentObject->Request(
        URL  => 'http://example.com/someurl',
        Type => 'POST',
        Data => { Attribute1 => 'Value', Attribute2 => 'Value2' },
    );

alternatively, you can use an arrayref like this:

    my %Response = $WebUserAgentObject->Request(
        URL  => 'http://example.com/someurl',
        Type => 'POST',
        Data => [ Attribute => 'Value', Attribute => 'OtherValue' ],
    );

returns

    %Response = (
        Status  => '200 OK',    # http status
        Content => $ContentRef, # content of requested URL
    );

You can even pass some headers

    my %Response = $WebUserAgentObject->Request(
        URL    => 'http://example.com/someurl',
        Type   => 'POST',
        Data   => [ Attribute => 'Value', Attribute => 'OtherValue' ],
        Header => {
            Authorization => 'Basic xxxx',
            Content_Type  => 'text/json',
        },
    );

If you need to set credentials

    my %Response = $WebUserAgentObject->Request(
        URL          => 'http://example.com/someurl',
        Type         => 'POST',
        Data         => [ Attribute => 'Value', Attribute => 'OtherValue' ],
        Credentials  => {
            User     => 'otrs_user',
            Password => 'otrs_password',
            Realm    => 'OTRS Unittests',
            Location => 'ftp.otrs.org:80',
        },
    );

=cut

sub Request {
    my ( $Self, %Param ) = @_;

    # define method - default to GET
    $Param{Type} ||= 'GET';

    my $Response;

    {

        # set HTTPS proxy for ssl requests, localize %ENV because of mod_perl
        local %ENV = %ENV;

        # if a proxy is set, extract it and use it as environment variables for HTTPS
        if ( $Self->{Proxy} =~ /:\/\/(.*)\// ) {
            my $ProxyAddress = $1;

            # extract authentication information if needed
            if ( $ProxyAddress =~ /(.*):(.*)@(.*)/ ) {
                $ENV{HTTPS_PROXY_USERNAME} = $1;
                $ENV{HTTPS_PROXY_PASSWORD} = $2;
                $ProxyAddress              = $3;
            }
            $ENV{HTTPS_PROXY} = $ProxyAddress;

            # force Net::SSL from Crypt::SSLeay. It does SSL connections through proxies
            # but it can't verify hostnames
            $ENV{PERL_NET_HTTPS_SSL_SOCKET_CLASS} = "Net::SSL";
            $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME}    = 0;
        }

        # init agent
        my $UserAgent = LWP::UserAgent->new();

        # set credentials
        if ( $Param{Credentials} ) {
            my %CredentialParams    = %{ $Param{Credentials} || {} };
            my @Keys                = qw(Location Realm User Password);
            my $AllCredentialParams = !first { !defined $_ } @CredentialParams{@Keys};

            if ($AllCredentialParams) {
                $UserAgent->credentials(
                    @CredentialParams{@Keys},
                );
            }
        }

        # set headers
        if ( $Param{Header} ) {
            $UserAgent->default_headers(
                HTTP::Headers->new( %{ $Param{Header} } ),
            );
        }

        # set timeout
        $UserAgent->timeout( $Self->{Timeout} );

        # get database object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # set user agent
        $UserAgent->agent(
            $ConfigObject->Get('Product') . ' ' . $ConfigObject->Get('Version')
        );

        # set proxy - but only for non-https urls, the https urls must use the environment
        # variables:
        if ( $Self->{Proxy} && $Param{URL} !~ /^https/ ) {
            $UserAgent->proxy( [ 'http', 'ftp' ], $Self->{Proxy} );
        }

        if ( $Param{Type} eq 'GET' ) {

            # perform get request on URL
            $Response = $UserAgent->get( $Param{URL} );
        }

        else {

            # check for Data param
            if ( !IsArrayRefWithData( $Param{Data} ) && !IsHashRefWithData( $Param{Data} ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        'WebUserAgent POST: Need Data param containing a hashref or arrayref with data.',
                );
                return ( Status => 0 );
            }

            # perform post request plus data
            $Response = $UserAgent->post( $Param{URL}, $Param{Data} );
        }
    }
    if ( !$Response->is_success() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't perform $Param{Type} on $Param{URL}: " . $Response->status_line(),
        );
        return (
            Status => $Response->status_line(),
        );
    }

    # get the content to convert internal used charset
    my $ResponseContent = $Response->decoded_content();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$ResponseContent );

    if ( $Param{Return} && $Param{Return} eq 'REQUEST' ) {
        return (
            Status  => $Response->status_line(),
            Content => \$Response->request()->as_string(),
        );
    }

    # return request
    return (
        Status  => $Response->status_line(),
        Content => \$ResponseContent,
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
