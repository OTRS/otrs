# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Time::HiRes;

# get needed objects
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# Field number to create.
#   A search will be executed in all fields at once (causing a JOIN for each
#   field, so be careful with this number.

my $FieldCount = 5;                     # Limit to 5 because of the UT servers.
my @SearchSteps = ( 1, 2, 3, 4, 5 );    # Steps at which to check search performance

$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfully',
);

my @TicketIDs;
my @Tickets;
for my $Item ( 1 .. 2 ) {
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

    push @TicketIDs, $TicketID;

    my %TicketData = $TicketObject->TicketGet(
        TicketID => $TicketID,
    );

    push @Tickets, \%TicketData;
}

my %SearchParams;

for my $Counter ( 1 .. $FieldCount ) {

    # create a dynamic field
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => "DFT$Counter$RandomID",
        Label      => 'Description',
        FieldOrder => 9999,
        FieldType  => 'Text',                   # mandatory, selects the DF backend to use for this field
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => 'Default',
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    );

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $TicketIDs[0],
        Value              => "ticket1_field$Counter",
        UserID             => 1,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $TicketIDs[1],
        Value              => "ticket2_field$Counter",
        UserID             => 1,
    );

    $SearchParams{"DynamicField_DFT$Counter$RandomID"} = {
        Like => "ticket1_%",
    };

    if ( grep { $_ == $Counter } @SearchSteps ) {

        my $Start = [ Time::HiRes::gettimeofday() ];

        my %TicketIDsSearch = $TicketObject->TicketSearch(
            Result => 'HASH',
            Limit  => 100,
            Title  => "Ticket$RandomID",
            %SearchParams,
            UserID     => 1,
            Permission => 'rw',
        );

        $Self->IsDeeply(
            \%TicketIDsSearch,
            { $TicketIDs[0] => $Tickets[0]->{TicketNumber} },
            "Search for $Counter fields result",
        );

        my $TimeTaken    = Time::HiRes::tv_interval($Start);
        my $TimeExpected = $Counter / 2;

        $Self->True(
            $TimeTaken < $TimeExpected,
            "Search for $Counter fields took less than $TimeExpected seconds ($TimeTaken)",
        );
    }
}

# cleanup is done by RestoreDatabase.

1;
