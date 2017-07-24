# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use vars (qw($Self));

# Get the Dynamic Field Objects configuration
my $DynamicFieldObjectTypeConfig = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::ObjectType');

$Self->True(
    IsHashRefWithData($DynamicFieldObjectTypeConfig),
    "DynamicFields::ObjectType is a hash",
);

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

# Create all registered ObjectType handler modules
for my $ObjectType ( sort keys %{$DynamicFieldObjectTypeConfig} ) {

    # Check if the registration for each field type is valid
    $Self->IsNot(
        $DynamicFieldObjectTypeConfig->{$ObjectType}->{Module} || '',
        '',
        "$ObjectType module is not empty or undefined",
    );

    # Set the backend file.
    my $ObjectHandlerModule = $DynamicFieldObjectTypeConfig->{$ObjectType}->{Module};

    # Check if backend field exists
    my $LoadSuccess = $MainObject->Require($ObjectHandlerModule);

    $Self->True(
        $LoadSuccess,
        "$ObjectHandlerModule loads correctly",
    );

    # Create a backend object
    my $ObjectHandlerObject = $Kernel::OM->Get($ObjectHandlerModule);

    $Self->Is(
        ref $ObjectHandlerObject,
        $ObjectHandlerModule,
        "$ObjectHandlerModule creates correctly",
    );

    # Test if the object can execute ObjectDataGet.
    $Self->True(
        $ObjectHandlerObject->can('ObjectDataGet'),
        "$ObjectHandlerModule can execute ObjectDataGet()",
    );
}

1;
