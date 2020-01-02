# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use Kernel::System::UnitTest::Helper;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify     => 1,
        DisableAsyncCalls => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable cloud service calls to avoid test failures due to connection problems etc.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CloudServices::Disabled',
    Value => 1,
);

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
);
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

my $BaseURL = $ConfigObject->Get('HttpType') . '://';

$BaseURL .= $Helper->GetTestHTTPHostname() . '/';
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

for my $BaseURL ( sort keys %Frontends ) {

    FRONTEND:
    for my $Frontend ( sort keys %{ $Frontends{$BaseURL} } ) {

        next FRONTEND if $Frontend =~ m/Login|Logout/;

        my $URL = $BaseURL . "Action=$Frontend";

        my $Status;
        TRY:
        for my $Try ( 1 .. 2 ) {

            $Response = $UserAgent->get($URL);

            $Status = scalar $Response->code();
            my $StatusGroup = substr $Status, 0, 1;

            last TRY if $StatusGroup ne 5;
        }

        $Self->Is(
            $Status,
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

        # check response contents
        if ( $Response->header('Content-type') =~ 'html' ) {
            $Self->True(
                scalar $Response->content() =~ m{<body|<div|<script}xms,
                "Module $Frontend returned HTML ($URL)",
            );

            # Inspect all full HTML responses for robots information.
            if ( $Response->content() =~ m{<head>} ) {

                # Check robots information.
                if ( $BaseURL !~ m{public\.pl} ) {
                    $Self->True(
                        index( $Response->content(), '<meta name="robots" content="noindex,nofollow" />' ) > 0,
                        "Module $Frontend sends 'noindex' robots information.",
                    );
                }
                else {

                    next FRONTEND if $Frontend =~ m/PublicDownloads|PublicURLRedirect/;

                    $Self->True(
                        index( $Response->content(), '<meta name="robots" content="index,follow" />' ) > 0,
                        "Module $Frontend sends 'index' robots information.",
                    );
                }
            }
        }
        elsif ( $Response->header('Content-type') =~ 'json' ) {

            my $Data = $JSONObject->Decode(
                Data => $Response->content()
            );

            $Self->True(
                scalar $Data,
                "Module $Frontend returned valid JSON data ($URL)",
            );
        }
    }
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
