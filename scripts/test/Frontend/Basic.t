# --
# Basic.t - Basic Frontend Tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

=cut
    This test logs into agent and customer interface, and then calls up all registered
    frontend modules to check for any internal server errors.
=cut

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use LWP::UserAgent;

use Kernel::Config;
use Kernel::System::UnitTest::Helper;
use Kernel::System::JSON;

my $ConfigObject = Kernel::Config->new();

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
    SkipSSLVerify  => 1,
);

my $TestUserLogin = $HelperObject->TestUserCreate(
    Groups => ['admin'],
);
my $TestCustomerUserLogin = $HelperObject->TestCustomerUserCreate();

my $JSONObject = Kernel::System::JSON->new( %{$Self} );

my $BaseURL = $ConfigObject->Get('HttpType') . '://';

#$BaseURL .= $ConfigObject->Get('FQDN') . '/';
$BaseURL .= 'localhost/';
$BaseURL .= $ConfigObject->Get('ScriptAlias');

my $AgentBaseURL    = $BaseURL . 'index.pl?';
my $CustomerBaseURL = $BaseURL . 'customer.pl?';
my $PublicBaseURL   = $BaseURL . 'public.pl?';

my $UserAgent = LWP::UserAgent->new();
$UserAgent->cookie_jar( {} );    # keep cookies

my $Response = $UserAgent->get(
    $AgentBaseURL . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
);
if ( !$Response->is_success() ) {
    $Self->True( 0, "Could not login to agent interface, aborting" );
    return 1;
}

$Response = $UserAgent->get(
    $CustomerBaseURL . "Action=Login;User=$TestCustomerUserLogin;Password=$TestCustomerUserLogin;"
);
if ( !$Response->is_success() ) {
    $Self->True( 0, "Could not login to customer interface, aborting" );
    return 1;
}

my ( $AgentSessionValid, $CustomerSessionValid );

# Get session info from cookie
$UserAgent->cookie_jar()->scan(
    sub {
        if ( $_[1] eq $ConfigObject->Get('SessionName') && $_[2] ) {
            $AgentSessionValid = 1;
        }
        if ( $_[1] eq $ConfigObject->Get('CustomerPanelSessionName') && $_[2] ) {
            $CustomerSessionValid = 1;
        }
        }
);

if ( !$AgentSessionValid ) {
    $Self->True( 0, "Could not login to agent interface, aborting" );
    return 1;
}
if ( !$CustomerSessionValid ) {
    $Self->True( 0, "Could not login to customer interface, aborting" );
    return 1;
}

my %Frontends = (
    $AgentBaseURL    => $ConfigObject->Get('Frontend::Module'),
    $CustomerBaseURL => $ConfigObject->Get('CustomerFrontend::Module'),
    $PublicBaseURL   => $ConfigObject->Get('PublicFrontend::Module'),
);

for my $BaseURL ( sort keys %Frontends ) {
    FRONTEND:
    for my $Frontend ( sort keys %{ $Frontends{$BaseURL} } ) {
        next FRONTEND if $Frontend =~ m/Login|Logout/;

        $Response = $UserAgent->get(
            $BaseURL . "Action=$Frontend"
        );

        $Self->Is(
            scalar $Response->code(),
            200,
            "Module $Frontend status code",
        );

        $Self->True(
            $Response->header('Content-type'),
            "Module $Frontend content type",
        );

        $Self->False(
            scalar $Response->header('X-OTRS-Login'),
            "Module $Frontend is no OTRS login screen",
        );

        # Check response contents
        if ( $Response->header('Content-type') =~ 'html' ) {
            $Self->True(
                $Response->content() =~ m{<body|<div|<script}xms,
                "Module $Frontend returned HTML",
            );
        }
        elsif ( $Response->header('Content-type') =~ 'json' ) {
            my $Data = $JSONObject->Decode( Data => $Response->content() );

            $Self->True(
                scalar $Data,
                "Module $Frontend returned valid JSON data",
            );
        }
    }
}

1;
