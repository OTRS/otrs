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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');
my $HelperObject            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DBObject                = $Kernel::OM->Get('Kernel::System::DB');
my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

my $RandomID = $HelperObject->GetRandomID();

my $UserID     = 1;
my $TestNumber = 1;

# workaround for oracle
# oracle databases can't determine the difference between NULL and ''
my $IsNotOracle = 1;
if ( $DBObject->GetDatabaseFunction('Type') eq 'oracle' ) {
    $IsNotOracle = 0;
}

my @Tests = (

    # notification add must fail - empty Name param
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => '',
            Comment => 'Just something for test',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel',
                    Body        => 'Textinhalt der Benachrichtigung',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },

    # notification add must fail - missing Data param
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => 'NotificationName' . $RandomID . $TestNumber,
            Comment => 'Just something for test',
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },

    # notification add must fail - missing Message param
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => 'NotificationName' . $RandomID . $TestNumber,
            Comment => 'Just something for test',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue'],
            },
            ValidID => 1,
        },
    },

    # notification add must fail - empty Message-Subject param
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => 'NotificationName' . $RandomID . $TestNumber,
            Comment => 'Just something for test',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => '',
                    Body        => 'Textinhalt der Benachrichtigung',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },

    # notification add must fail - empty Message-Body param
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => 'NotificationName' . $RandomID . $TestNumber,
            Comment => 'Just something for test',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel',
                    Body        => '',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },

    # notification add must fail - empty Message-ContentType param
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => 'NotificationName' . $RandomID . $TestNumber,
            Comment => 'Just something for test',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel',
                    Body        => 'Textinhalt der Benachrichtigung',
                    ContentType => '',
                },
            },
            ValidID => 1,
        },
    },

    # notification add must fail - missing ValidID parameter
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => 'NotificationName' . $RandomID . $TestNumber,
            Comment => 'Just something for test',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
            },
        },
    },

    # first sucessful add and update
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'NotificationName' . $RandomID,
            Comment => 'This is a test comment.',
            Data    => {
                Events => [ 'AnEventForThisTest' . $RandomID ],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel',
                    Body        => 'Textinhalt der Benachrichtigung',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },

    # add must fail because of duplicate name
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name    => 'NotificationName' . $RandomID,
            Comment => 'This is a test comment.',
            Data    => {
                Events => [ 'AnEventForThisTest' . $RandomID ],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel',
                    Body        => 'Textinhalt der Benachrichtigung',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },

    # successful add and update
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'NotificationNameSuccess' . $RandomID,
            Comment => 'This is a test comment.',
            Data    => {
                Events => [ 'AnEventForThisTest' . $RandomID ],
                Queue  => ['SomeQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject',
                    Body        => 'Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel',
                    Body        => 'Textinhalt der Benachrichtigung',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 2,
        },

        Update => {
            Name    => 'NotificationNameModifiedSuccess' . $RandomID,
            Comment => 'Just something for test modified',
            Data    => {
                Events => [ 'AnEventForThisTest' . $RandomID ],
                Queue  => ['ADifferentQueue'],
            },
            Message => {
                en => {
                    Subject     => 'Modified Notification subject',
                    Body        => 'Modified Body for notification',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Geänderter Benachrichtigungs-Titel',
                    Body        => 'Geänderter Textinhalt der Benachrichtigung',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },

    # another successful add and update
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'NotificationNameSuccess-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ' . $RandomID,
            Comment => 'Just something for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body        => 'Body for notification-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body        => 'Textinhalt der Benachrichtigung-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 2,
        },

        Update => {
            Name    => 'Notification-äüßÄÖÜ€исáéíúúÁÉÍÚñÑNameModifiedSuccess' . $RandomID,
            Comment => 'Just something modified for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events => [ 'AnEventForThisTest' . $RandomID ],
                Queue  => ['ADifferentQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
            },
            Message => {
                en => {
                    Subject     => 'Modified Notification subject-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body        => 'Modified Body for notification-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject => 'Geänderter Benachrichtigungs-Titel-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body    => 'Geänderter Textinhalt der Benachrichtigung-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
        },
    },
    {
        Name          => 'TestHTML ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'NotificationHTMLNameSuccess-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ' . $RandomID,
            Comment => 'Just something for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events => ['TicketQueueUpdate'],
                Queue  => ['SomeQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
            },
            Message => {
                en => {
                    Subject     => 'Notification subject-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body        => 'Body for notification-<br>äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/html',
                },
                de => {
                    Subject     => 'Benachrichtigungs-Titel-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body        => 'Textinhalt der Benachrichtigung-<br>äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/html',
                },
            },
            ValidID => 2,
        },

        Update => {
            Name    => 'NotificationHTML-äüßÄÖÜ€исáéíúúÁÉÍÚñÑNameModifiedSuccess' . $RandomID,
            Comment => 'Just something modified for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events => [ 'AnEventForThisTest' . $RandomID ],
                Queue  => ['ADifferentQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
            },
            Message => {
                en => {
                    Subject     => 'Modified Notification subject-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body        => 'Modified Body for notification-<br>äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/html',
                },
                de => {
                    Subject => 'Geänderter Benachrichtigungs-Titel-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    Body => 'Geänderter Textinhalt der Benachrichtigung-<br>äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
                    ContentType => 'text/html',
                },
            },
            ValidID => 1,
        },
    },
);

my %NotificationIDs;
TEST:
for my $Test (@Tests) {

    # Add NotificationEvent
    my $NotificationID = $NotificationEventObject->NotificationAdd(
        %{ $Test->{Add} },
        UserID => $UserID,
    );

    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $NotificationID,
            "$Test->{Name} - NotificationEventAdd()",
        );
        next TEST;
    }
    else {
        $Self->True(
            $NotificationID,
            "$Test->{Name} - NotificationEventAdd()",
        );
    }

    # remember ID to verify it later
    $NotificationIDs{$NotificationID} = $Test->{Add}->{Name};

    # get NotificationEvent
    my %NotificationEvent = $NotificationEventObject->NotificationGet(
        Name => $Test->{Add}->{Name},
    );

    my %NotificationEventByID = $NotificationEventObject->NotificationGet(
        ID => $NotificationID,
    );

    $Self->IsDeeply(
        \%NotificationEvent,
        \%NotificationEventByID,
        "$Test->{Name} - NotificationEventGet() - By name and by ID",
    );

    # verify NotificationEvent
    $Self->Is(
        1,
        IsHashRefWithData( \%NotificationEvent ),
        "$Test->{Name} - NotificationEventGet() - Right structure",
    );

    $Self->Is(
        $NotificationID,
        $NotificationEvent{ID},
        "$Test->{Name} - NotificationEventGet() - ID",
    );

    $Self->Is(
        $Test->{Add}->{Name},
        $NotificationEvent{Name},
        "$Test->{Name} - NotificationEventGet() - Name",
    );

    # workaround for oracle
    # oracle databases can't determine the difference between NULL and ''
    if ( !defined $NotificationEvent{Comment} && !$IsNotOracle ) {
        $NotificationEvent{Comment} = '';
    }

    $Self->Is(
        $Test->{Add}->{Comment},
        $NotificationEvent{Comment},
        "$Test->{Name} - NotificationEventGet() - Comment",
    );

    $Self->Is(
        $Test->{Add}->{ValidID},
        $NotificationEvent{ValidID},
        "$Test->{Name} - NotificationEventGet() - ValidID",
    );

    $Self->IsDeeply(
        $Test->{Add}->{Data},
        $NotificationEvent{Data},
        "$Test->{Name} - NotificationEventGet() - Data",
    );

    $Self->IsDeeply(
        $Test->{Add}->{Message},
        $NotificationEvent{Message},
        "$Test->{Name} - NotificationEventGet() - Message",
    );

    $Self->True(
        $NotificationEvent{ChangeTime},
        "$Test->{Name} - NotificationEventGet() - ChangeTime",
    );

    $Self->True(
        $NotificationEvent{CreateTime},
        "$Test->{Name} - NotificationEventGet() - CreateTime",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{ChangeBy},
        "$Test->{Name} - NotificationEventGet() - ChangeBy",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{CreateBy},
        "$Test->{Name} - NotificationEventGet() - CreateBy",
    );

    # update NotificationEvent
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }

    # include ID on update data
    $Test->{Update}->{ID} = $NotificationID;

    my $SuccessUpdate = $NotificationEventObject->NotificationUpdate(
        %{ $Test->{Update} },
        UserID => $UserID,
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $SuccessUpdate,
            "$Test->{Name} - NotificationEventUpdate() False",
        );
        next TEST;
    }
    else {
        $Self->True(
            $SuccessUpdate,
            "$Test->{Name} - NotificationEventUpdate() True",
        );
    }

    # remember ID to verify it later
    $NotificationIDs{$NotificationID} = $Test->{Update}->{Name};

    # get NotificationEvent
    %NotificationEvent = $NotificationEventObject->NotificationGet(
        Name => $Test->{Update}->{Name},
    );

    %NotificationEventByID = $NotificationEventObject->NotificationGet(
        ID => $NotificationID,
    );

    $Self->IsDeeply(
        \%NotificationEvent,
        \%NotificationEventByID,
        "$Test->{Name} - NotificationEventGet() - By name and by ID",
    );

    # verify NotificationEvent
    $Self->Is(
        1,
        IsHashRefWithData( \%NotificationEvent ),
        "$Test->{Name} - NotificationEventGet() - Right structure",
    );

    $Self->Is(
        $NotificationID,
        $NotificationEvent{ID},
        "$Test->{Name} - NotificationEventGet() - ID",
    );

    $Self->Is(
        $Test->{Update}->{Name},
        $NotificationEvent{Name},
        "$Test->{Name} - NotificationEventGet() - Name",
    );

    # workaround for oracle
    # oracle databases can't determine the difference between NULL and ''
    if ( !defined $NotificationEvent{Comment} && !$IsNotOracle ) {
        $NotificationEvent{Comment} = '';
    }

    $Self->Is(
        $Test->{Update}->{Comment},
        $NotificationEvent{Comment},
        "$Test->{Name} - NotificationEventGet() - Comment",
    );

    $Self->Is(
        $Test->{Update}->{ValidID},
        $NotificationEvent{ValidID},
        "$Test->{Name} - NotificationEventGet() - ValidID",
    );

    $Self->IsDeeply(
        $Test->{Update}->{Data},
        $NotificationEvent{Data},
        "$Test->{Name} - NotificationEventGet() - Data",
    );

    $Self->IsDeeply(
        $Test->{Update}->{Message},
        $NotificationEvent{Message},
        "$Test->{Name} - NotificationEventGet() - Message",
    );

    $Self->True(
        $NotificationEvent{ChangeTime},
        "$Test->{Name} - NotificationEventGet() - ChangeTime",
    );

    $Self->True(
        $NotificationEvent{CreateTime},
        "$Test->{Name} - NotificationEventGet() - CreateTime",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{ChangeBy},
        "$Test->{Name} - NotificationEventGet() - ChangeBy",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{CreateBy},
        "$Test->{Name} - NotificationEventGet() - CreateBy",
    );

}

# get ID from added notifications
my @AddedNotifications = sort keys %NotificationIDs;

# verify IDs
$Self->Is(
    1,
    IsArrayRefWithData( \@AddedNotifications ),
    "Added Notification IDs- Right structure",
);

my @IDs = $NotificationEventObject->NotificationEventCheck( Event => 'AnEventForThisTest' . $RandomID );
@IDs = sort @IDs;

# verify NotificationEventCheck
$Self->Is(
    1,
    IsArrayRefWithData( \@IDs ),
    "NotificationEventCheck() - Right structure",
);

$Self->IsDeeply(
    \@AddedNotifications,
    \@IDs,
    "NotificationEventCheck()",
);

# list check from DB
my %NotificationList = $NotificationEventObject->NotificationList();
for my $NotificationID ( sort keys %NotificationIDs ) {
    $Self->Is(
        $NotificationIDs{$NotificationID},
        $NotificationList{$NotificationID},
        "NotificationList() from DB found NotificationEvent $NotificationID",
    );

    # delete entry
    my $SuccesDelete = $NotificationEventObject->NotificationDelete(
        ID     => $NotificationID,
        UserID => $UserID,
    );

    $Self->True(
        $SuccesDelete,
        "NotificationDelete() - $NotificationID",
    );
}

# list check deleted entries
%NotificationList = $NotificationEventObject->NotificationList();
for my $NotificationID ( sort keys %NotificationIDs ) {
    $Self->False(
        $NotificationList{$NotificationID},
        "NotificationList() deleted entry - $NotificationID",
    );
}

1;
