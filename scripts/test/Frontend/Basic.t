# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

$BaseURL .= 'localhost/';
$BaseURL .= $ConfigObject->Get('ScriptAlias');

my $AgentBaseURL    = $BaseURL . 'index.pl?';
my $CustomerBaseURL = $BaseURL . 'customer.pl?';
my $PublicBaseURL   = $BaseURL . 'public.pl?';

my $UserAgent = LWP::UserAgent->new(
    Timeout => 60,
);
$UserAgent->cookie_jar( {} );    # keep cookies

my $Response = $UserAgent->get(
    $AgentBaseURL . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
);
if ( !$Response->is_success() ) {
    $Self->True(
        0,
        "Could not login to agent interface, aborting! URL: "
            . $AgentBaseURL
            . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
    );
    return 1;
}

$Response = $UserAgent->get(
    $CustomerBaseURL . "Action=Login;User=$TestCustomerUserLogin;Password=$TestCustomerUserLogin;"
);

if ( !$Response->is_success() ) {
    $Self->True(
        0,
        "Could not login to customer interface, aborting! URL: "
            . $CustomerBaseURL
            . "Action=Login;User=$TestCustomerUserLogin;Password=$TestCustomerUserLogin;"
    );
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

# Don't test modules that call external services to avoid false errors.
delete $Frontends{$AgentBaseURL}->{AdminPackageManager};
delete $Frontends{$AgentBaseURL}->{AdminServiceCenter};

for my $BaseURL ( sort keys %Frontends ) {
    FRONTEND:
    for my $Frontend ( sort keys %{ $Frontends{$BaseURL} } ) {
        next FRONTEND if $Frontend =~ m/Login|Logout/;

        my $URL = $BaseURL . "Action=$Frontend";

        $Response = $UserAgent->get($URL);

        $Self->Is(
            scalar $Response->code(),
            200,
            "Module $Frontend status code ($URL)",
        );

        $Self->True(
            scalar $Response->header('Content-type'),
            "Module $Frontend content type ($URL)",
        );

        $Self->False(
            scalar $Response->header('X-OTRS-Login'),
            "Module $Frontend is no OTRS login screen ($URL)",
        );

        # Check response contents
        if ( $Response->header('Content-type') =~ 'html' ) {
            $Self->True(
                scalar $Response->content() =~ m{<body|<div|<script}xms,
                "Module $Frontend returned HTML ($URL)",
            );
        }
        elsif ( $Response->header('Content-type') =~ 'json' ) {
            my $Data = $JSONObject->Decode( Data => $Response->content() );

            $Self->True(
                scalar $Data,
                "Module $Frontend returned valid JSON data ($URL)",
            );
        }
    }
}

1;
