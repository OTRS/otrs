# --
# TicketDynamicFieldSearchPerformance.t - ticket module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

use Time::HiRes;

# create local objects
my $RandomID = int rand 1_000_000_000;

# Field number to create.
#   A search will be executed in all fields at once (causing a JOIN for each
#   field, so be careful with this number.

my $FieldCount = 5;                     # Limit to 5 because of the UT servers.
my @SearchSteps = ( 1, 2, 3, 4, 5 );    # Steps at which to check search performance

my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# create backend object and delegates
my $BackendObject = Kernel::System::DynamicField::Backend->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfuly',
);

my @TestTicketIDs;

my $TicketID1 = $TicketObject->TicketCreate(
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

push @TestTicketIDs, $TicketID1;

my %Ticket1 = $TicketObject->TicketGet(
    TicketID => $TicketID1,
);

my $TicketID2 = $TicketObject->TicketCreate(
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

push @TestTicketIDs, $TicketID2;

my %Ticket2 = $TicketObject->TicketGet(
    TicketID => $TicketID2,
);

my @TestDynamicFields;
my %SearchParams;

for my $Counter ( 1 .. $FieldCount ) {

    # create a dynamic field
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => "DFT$Counter$RandomID",
        Label      => 'Description',
        FieldOrder => 9999,
        FieldType  => 'Text',     # mandatory, selects the DF backend to use for this field
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => 'Default',
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    );

    push @TestDynamicFields, $FieldID;

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $TicketID1,
        Value              => "ticket1_field$Counter",
        UserID             => 1,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $TicketID2,
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
            { $TicketID1 => $Ticket1{TicketNumber} },
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

for my $TicketID (@TestTicketIDs) {

    # the ticket is no longer needed
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

for my $FieldID (@TestDynamicFields) {

    # delete the dynamic field
    $DynamicFieldObject->DynamicFieldDelete(
        ID      => $FieldID,
        UserID  => 1,
        Reorder => 0,
    );
}

1;
