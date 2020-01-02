# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Get FormDraft object.
my $FormDraftObject = $Kernel::OM->Get('Kernel::System::FormDraft');

# Get Helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create test Ticket.
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "TicketCreate() $TicketID",
);

# Create test scenarions for FormDraftAdd().
my @Tests = (
    {
        Name       => 'No FormData - Add Fail',
        FormData   => undef,
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No ObjectType - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => undef,
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No ObjectID - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => 'Ticket',
        ObjectID   => undef,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No Action - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => undef,
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 0,
    },
    {
        Name     => 'No UserID - Add Fail',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => undef,
        Success    => 0,
    },
    {
        Name     => 'All Parameters OK with Attachment - Add Success',
        FormData => {
            Subject => 'UnitTest Subject',
            Body    => 'UnitTest Body',
        },
        FileData => [
            {
                'Content'     => 'Dear customer\n\nthank you!',
                'ContentType' => 'text/plain',
                'ContentID'   => undef,
                'Filename'    => 'thankyou.txt',
                'Filesize'    => 25,
                'FileID'      => 1,
                'Disposition' => 'attachment',
            },
        ],
        ObjectType => 'Ticket',
        ObjectID   => $TicketID,
        Action     => 'AgentTicketNote',
        Title      => 'UnitTest FormDraft',
        UserID     => 1,
        Success    => 1,
    },
);

# Test FormDraftAdd and FormDraftListGet functions.
my $FormDraftID;
for my $Test (@Tests) {

    # Create FormDraft.
    my $FormDraftAdd = $FormDraftObject->FormDraftAdd(
        FormData   => $Test->{FormData},
        FileData   => $Test->{FileData},
        ObjectType => $Test->{ObjectType},
        ObjectID   => $Test->{ObjectID},
        Action     => $Test->{Action},
        Title      => $Test->{Title},
        UserID     => $Test->{UserID},
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $FormDraftAdd,
            "FormDraftAdd() $Test->{Name}",
        );
    }
    else {
        $Self->True(
            $FormDraftAdd,
            "FormDraftAdd() $Test->{Name}",
        );

        # Get all FormDrafts for test Ticket, expecting one result.
        my $FormDraftList = $FormDraftObject->FormDraftListGet(
            ObjectType => 'Ticket',
            ObjectID   => $Test->{ObjectID},
            Action     => 'AgentTicketNote',
            UserID     => $Test->{UserID},
        );
        $Self->Is(
            scalar @{$FormDraftList},
            1,
            "FormDraftListGet() success"
        );

        # Get created FormDraft ID.
        $FormDraftID = $FormDraftList->[0]->{FormDraftID};

        # Test FormDraftGet() data with content.
        my $FormDraft = $FormDraftObject->FormDraftGet(
            FormDraftID => $FormDraftID,
            GetContent  => 1,
            UserID      => $Test->{UserID},
        );

        # Verify value from FormDraftGet().
        for my $FormDraftGetParam (qw(FormData FileData ObjectID ObjectType Title Action)) {
            $Self->IsDeeply(
                $FormDraft->{$FormDraftGetParam},
                $Test->{$FormDraftGetParam},
                "FormDraftGet() param $FormDraftGetParam"
            );
        }

        # Test FormDraftGet() without content.
        $FormDraft = $FormDraftObject->FormDraftGet(
            FormDraftID => $FormDraftID,
            GetContent  => 0,
            UserID      => $Test->{UserID},
        );
        $Self->Is(
            $FormDraft->{FileData},
            undef,
            'FormDraftGet() wthout content FileData'
        );
    }
}

# Create test scenarios for FormDraftUpdate().
@Tests = (
    {
        Name        => 'No FormData - Update Fail',
        FormData    => undef,
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No ObjectType - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => undef,
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No ObjectID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => undef,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No Action - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => undef,
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'No UserID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => undef,
        Success     => 0,
    },
    {
        Name     => 'No FormDraftID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => undef,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'Different ObjectType - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Article',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'Different ObjectID - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID + 1,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'Different Action - Update Fail',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketPriority',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 0,
    },
    {
        Name     => 'All Parameters OK - Update Success',
        FormData => {
            Subject => 'UnitTest Subject - Update',
            Body    => 'UnitTest Body - Update',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 1,
    },
    {
        Name     => 'All Parameters OK - Update Success - utf8 characters in title',
        FormData => {
            Subject => 'UnitTest Subject - Update - шђчћж',
            Body    => 'UnitTest Body - Update - шђчћж',
        },
        ObjectType  => 'Ticket',
        ObjectID    => $TicketID,
        Action      => 'AgentTicketNote',
        Title       => 'UnitTest FormDraft - Update - utf8 characters - шђчћж',
        FormDraftID => $FormDraftID,
        UserID      => 1,
        Success     => 1,
    },
);

# Test FormDraftUpdate().
for my $Test (@Tests) {

    # Update FormDraft.
    my $FormDraftUpdate = $FormDraftObject->FormDraftUpdate(
        FormData    => $Test->{FormData},
        ObjectType  => $Test->{ObjectType},
        ObjectID    => $Test->{ObjectID},
        Action      => $Test->{Action},
        Title       => $Test->{Title},
        FormDraftID => $Test->{FormDraftID},
        UserID      => $Test->{UserID},
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $FormDraftUpdate,
            "FormDraftUpdate() $Test->{Name}",
        );
    }
    else {
        $Self->True(
            $FormDraftUpdate,
            "FormDraftUpdate() $Test->{Name}",
        );

        # Get updated FormDraft data and check values.
        my $UpdatedFormDraft = $FormDraftObject->FormDraftGet(
            FormDraftID => $FormDraftID,
            GetContent  => 1,
            UserID      => $Test->{UserID},
        );
        $Self->Is(
            $UpdatedFormDraft->{FormData}->{Subject},
            $Test->{FormData}->{Subject},
            "FormDraftUpdate() updated param FormData - Subject"
        );
        $Self->Is(
            $UpdatedFormDraft->{FormData}->{Body},
            $Test->{FormData}->{Body},
            "FormDraftUpdate() updated param FormData - Body"
        );
        $Self->Is(
            $UpdatedFormDraft->{Title},
            $Test->{Title},
            "FormDraftUpdate() updated param Title"
        );
    }
}

# Test FormDraftDelete().
my $FormDraftDelete = $FormDraftObject->FormDraftDelete(
    FormDraftID => $FormDraftID,
    UserID      => 1,
);
$Self->True(
    $FormDraftDelete,
    'FormDraftDelete() success'
);

# Sanity check.
my $FormDraft = $FormDraftObject->FormDraftGet(
    FormDraftID => $FormDraftID,
    GetContent  => 1,
    UserID      => 1,
);
$Self->Is(
    $FormDraft->{Title},
    undef,
    'FormDraftDelete() check Title'
);

# Cleanup is done by RestoreDatabase.

1;
