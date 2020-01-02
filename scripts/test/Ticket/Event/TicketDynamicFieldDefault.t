# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

my $RandomID = $Helper->GetRandomID();

# Create test dynamic field.
my $DynamicFieldName = "DynamicField$RandomID";
my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $DynamicFieldName,
    FieldOrder => 9991,
    FieldType  => 'Text',
    Config     => {},
    Label      => 'Description',
    ObjectType => 'Ticket',
    ValidID    => 1,
    UserID     => 1,
    Reorder    => 0,
);
$Self->True(
    $DynamicFieldID,
    "DynamicFieldAdd - Created DynamicField - $DynamicFieldID",
);

# Set dynamic field to another value on ticket create.
my $DynamicFieldValue = 'Value';
$ConfigObject->Set(

);

my @Tests = (
    {
        Name                    => 'Undefined value',
        EventModuleRegistration => {
            Key => 'Ticket::EventModulePost###9600-TicketDynamicFieldDefault',
        },
        Result => undef,
    },
    {
        Name                    => 'Value set by event module',
        EventModuleRegistration => {
            Key   => 'Ticket::EventModulePost###9600-TicketDynamicFieldDefault',
            Value => {
                Module      => 'Kernel::System::Ticket::Event::TicketDynamicFieldDefault',
                Transaction => 0,
            },
        },
        EventModuleConfig => {
            Key   => 'Ticket::TicketDynamicFieldDefault###Element1',
            Value => {
                Event => 'TicketCreate',
                Name  => $DynamicFieldName,
                Value => 'Default',
            },
        },
        Result => 'Default',
    },
    {
        # Event module previously got executed even when ticket has been deleted, resulting in
        #   a number of errors in the log for missing ticket. This test is designed to reproduce
        #   this behavior, and will display errors if fix is not in place. Unfortunately, there is
        #   no way to trigger test fail in this scenario, since errors show up only in transaction
        #   mode. Please see bug#12369 for more information.
        Name                    => 'Missing ticket/Loop protection check',
        EventModuleRegistration => {
            Key   => 'Ticket::EventModulePost###9600-TicketDynamicFieldDefault',
            Value => {
                Module      => 'Kernel::System::Ticket::Event::TicketDynamicFieldDefault',
                Transaction => 1,
            },
        },
        Delete => 1,
    },
);

for my $Test (@Tests) {

    # Register event module.
    $ConfigObject->Set(
        %{ $Test->{EventModuleRegistration} },
    );

    # Configure event module.
    if ( $Test->{EventModuleConfig} ) {
        $ConfigObject->Set(
            %{ $Test->{EventModuleConfig} },
        );
    }

    # Create test ticket.
    my $TicketID = $TicketObject->TicketCreate(
        Title        => "Ticket$RandomID",
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        "$Test->{Name} - Ticket is created - $TicketID",
    );

    # Check dynamic field value.
    if ( $Test->{Result} ) {
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
        );
        $Self->Is(
            $Ticket{"DynamicField_$DynamicFieldName"},
            $Test->{Result},
            "$Test->{Name} - DynamicField $DynamicFieldName value",
        );
    }

    if ( $Test->{Delete} ) {
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "$Test->{Name} - Ticket is deleted",
        );
    }
}

# Cleanup is done by RestoreDatabase.

1;
