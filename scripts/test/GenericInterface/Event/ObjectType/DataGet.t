# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use vars (qw($Self));

# Get the Dynamic Field Objects configuration
my %RegisteredEvents = $Kernel::OM->Get('Kernel::System::Event')->EventList();

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

# Create all registered EventType handler modules
EVENTTYPE:
for my $EventType ( sort keys %RegisteredEvents ) {

    # Set the backend file.
    my $ObjectHandlerModule = "Kernel::GenericInterface::Event::ObjectType::$EventType";

    # Check if backend field exists
    my $LoadSuccess = $MainObject->Require($ObjectHandlerModule);

    $Self->True(
        $LoadSuccess,
        "$ObjectHandlerModule loads correctly",
    );

    next EVENTTYPE if !$LoadSuccess;

    # Create a backend object
    my $ObjectHandlerObject = $Kernel::OM->Get($ObjectHandlerModule);

    $Self->Is(
        ref $ObjectHandlerObject,
        $ObjectHandlerModule,
        "$ObjectHandlerModule creates correctly",
    );

    # Test if the object can execute DataGet.
    $Self->True(
        $ObjectHandlerObject->can('DataGet'),
        "$ObjectHandlerModule can execute DataGet()",
    );
}

1;
