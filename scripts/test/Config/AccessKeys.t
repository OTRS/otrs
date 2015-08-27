# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# check used accesskeys in agent frontend
my %UsedAccessKeysAgent;

# frontend and toolbar modules
my %AgentModules = (
    %{ $ConfigObject->Get('Frontend::Module') },
    %{ $ConfigObject->Get('Frontend::ToolBarModule') }
);

ACCESSKEYSAGENT:
for my $AgentModule ( sort keys %AgentModules ) {

    # check navbar items
    if ( $AgentModules{$AgentModule}->{NavBar} && @{ $AgentModules{$AgentModule}->{NavBar} } ) {

        NAVBARITEMS:
        for my $NavBar ( sort @{ $AgentModules{$AgentModule}->{NavBar} } ) {

            my $NavBarKey  = $NavBar->{AccessKey} || '';
            my $NavBarName = $NavBar->{Name}      || '';
            next NAVBARITEMS if !$NavBarKey;

            $Self->False(
                defined $UsedAccessKeysAgent{$NavBarKey},
                "[AGENT FRONTEND] Check if access key already exists for access key '$NavBarKey' ($NavBarName)",
            );

            $UsedAccessKeysAgent{$NavBarKey} = 1;
        }
    }

    my $AccessKey = $AgentModules{$AgentModule}->{AccessKey} || '';
    my $Name      = $AgentModules{$AgentModule}->{Name}      || '';

    next ACCESSKEYSAGENT if !$AccessKey;

    $Self->False(
        defined $UsedAccessKeysAgent{$AccessKey},
        "[AGENT FRONTEND] Check if access key already exists for access key '$AccessKey' ($Name)",
    );

    $UsedAccessKeysAgent{$AccessKey} = 1;
}

# check used accesskeys in customer frontend
my %UsedAccessKeysCustomer;

# frontend and toolbar modules
my %CustomerModules = %{ $ConfigObject->Get('CustomerFrontend::Module') };

ACCESSKEYSCUSTOMER:
for my $CustomerModule ( sort keys %CustomerModules ) {

    next ACCESSKEYSCUSTOMER if !$CustomerModules{$CustomerModule}->{NavBar};
    next ACCESSKEYSCUSTOMER if !@{ $CustomerModules{$CustomerModule}->{NavBar} };

    NAVBARITEMS:
    for my $NavBar ( sort @{ $CustomerModules{$CustomerModule}->{NavBar} } ) {

        my $NavBarKey = $NavBar->{AccessKey} || '';

        next NAVBARITEMS if !$NavBarKey;

        $Self->False(
            defined $UsedAccessKeysCustomer{$NavBarKey},
            "[CUSTOMER FRONTEND] Check if access key already exists for access key '$NavBarKey'",
        );

        $UsedAccessKeysCustomer{$NavBarKey} = 1;
    }
}

1;
