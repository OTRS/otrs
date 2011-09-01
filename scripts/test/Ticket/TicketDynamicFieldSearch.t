# --
# TicketDynamicFieldSearch.t - ticket module testscript
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TicketDynamicFieldSearch.t,v 1.1 2011-09-01 12:43:14 mg Exp $
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

# create local objects
my $RandomID = int rand 1_000_000_000;

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

# create a dynamic field
my $FieldID1 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',            # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
);

my $Field1Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID1,
);

# create a dynamic field
my $FieldID2 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT2$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',            # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
);

my $Field2Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID2,
);

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

my %Ticket2 = $TicketObject->TicketGet(
    TicketID => $TicketID2,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field1Config,
    ObjectID           => $TicketID1,
    Value              => 'ticket1_field1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field2Config,
    ObjectID           => $TicketID1,
    Value              => 'ticket1_field2',
    UserID             => 1,
);
$BackendObject->ValueSet(
    DynamicFieldConfig => $Field1Config,
    ObjectID           => $TicketID2,
    Value              => 'ticket2_field1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field2Config,
    ObjectID           => $TicketID2,
    Value              => 'ticket2_field2',
    UserID             => 1,
);

eval {

    my %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                       => 'HASH',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT1$RandomID" => 'ticket1_field1',
        UserID                       => 1,
        Permission                   => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        { $TicketID1 => $Ticket1{TicketNumber} },
        'Search for one field',
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                       => 'HASH',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT1$RandomID" => 'ticket1_field1',
        "DynamicField_DFT2$RandomID" => 'ticket1_field2',
        UserID                       => 1,
        Permission                   => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        { $TicketID1 => $Ticket1{TicketNumber} },
        'Search for two fields',
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                       => 'HASH',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT1$RandomID" => 'ticket1_field1_nonexisting',
        "DynamicField_DFT2$RandomID" => 'ticket1_field2',
        UserID                       => 1,
        Permission                   => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {},
        'Search for two fields, wrong first value',
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                       => 'HASH',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT1$RandomID" => 'ticket1_field1',
        "DynamicField_DFT2$RandomID" => 'ticket1_field2_nonexisting',
        UserID                       => 1,
        Permission                   => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {},
        'Search for two fields, wrong second value',
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                       => 'HASH',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT1$RandomID" => 'ticket%_field1',
        "DynamicField_DFT2$RandomID" => 'ticket%_field2',
        UserID                       => 1,
        Permission                   => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {
            $TicketID1 => $Ticket1{TicketNumber},
            $TicketID2 => $Ticket2{TicketNumber},
        },
        'Search for two fields, match two tickets',
    );

    my @TicketResultSearch = $TicketObject->TicketSearch(
        Result                       => 'ARRAY',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT1$RandomID" => 'ticket%_field1',
        "DynamicField_DFT2$RandomID" => 'ticket%_field2',
        UserID                       => 1,
        Permission                   => 'rw',
        SortBy                       => "DynamicField_DFT1$RandomID",
        OrderBy                      => 'Up',
    );

    $Self->IsDeeply(
        \@TicketResultSearch,
        [ $TicketID1, $TicketID2, ],
        'Search for two fields, match two tickets, sort for search field, ASC',
    );

    @TicketResultSearch = $TicketObject->TicketSearch(
        Result                       => 'ARRAY',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT1$RandomID" => 'ticket%_field1',
        "DynamicField_DFT2$RandomID" => 'ticket%_field2',
        UserID                       => 1,
        Permission                   => 'rw',
        SortBy                       => "DynamicField_DFT1$RandomID",
        OrderBy                      => 'Down',
    );

    $Self->IsDeeply(
        \@TicketResultSearch,
        [ $TicketID2, $TicketID1, ],
        'Search for two fields, match two tickets, sort for search field, DESC',
    );

    @TicketResultSearch = $TicketObject->TicketSearch(
        Result                       => 'ARRAY',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT2$RandomID" => 'ticket%_field2',
        UserID                       => 1,
        Permission                   => 'rw',
        SortBy                       => "DynamicField_DFT1$RandomID",
        OrderBy                      => 'Up',
    );

    $Self->IsDeeply(
        \@TicketResultSearch,
        [ $TicketID1, $TicketID2, ],
        'Search for two fields, match two tickets, sort for another field, ASC',
    );

    @TicketResultSearch = $TicketObject->TicketSearch(
        Result                       => 'ARRAY',
        Limit                        => 100,
        Title                        => "Ticket$RandomID",
        "DynamicField_DFT2$RandomID" => 'ticket%_field2',
        UserID                       => 1,
        Permission                   => 'rw',
        SortBy                       => "DynamicField_DFT1$RandomID",
        OrderBy                      => 'Down',
    );

    $Self->IsDeeply(
        \@TicketResultSearch,
        [ $TicketID2, $TicketID1, ],
        'Search for two fields, match two tickets, sort for another field, DESC',
    );
};

print STDERR "$@";

=cut
my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Some Agent <email@example.com>',
    To             => 'Some Customer <customer-a@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);
=cut

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID1,
    UserID   => 1,
);
$TicketObject->TicketDelete(
    TicketID => $TicketID2,
    UserID   => 1,
);

# delete the dynamic field
$DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID1,
    UserID => 1,
);
$DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID2,
    UserID => 1,
);

1;
