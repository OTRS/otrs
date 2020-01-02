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

use Kernel::System::VariableCheck qw(:all);

# get notification event object
my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my $UserID     = 1;
my $TestNumber = 1;

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'NotificationEvent',
);

# workaround for oracle
# oracle databases can't determine the difference between NULL and ''
my $IsNotOracle = 1;
if ( $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('Type') eq 'oracle' ) {
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

    # first successful add and update
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
    {
        Name          => 'TestHTML ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'NotificationHTMLNameSuccess-TicketType' . $RandomID,
            Comment => 'Just something for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events           => ['TicketQueueUpdate'],
                Queue            => ['SomeQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
                NotificationType => ['Ticket'],
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
            Name    => 'NotificationHTML-TicketType' . $RandomID,
            Comment => 'Just something modified for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events           => [ 'AnEventForThisTest' . $RandomID ],
                Queue            => ['ADifferentQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
                NotificationType => ['Ticket'],
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
    {
        Name          => 'TestHTML ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'NotificationHTMLNameSuccess-UnitTestType' . $RandomID,
            Comment => 'Just something for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events           => ['TicketQueueUpdate'],
                Queue            => ['SomeQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
                NotificationType => ['UnitTestType'],
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
            Name    => 'NotificationHTML-UnitTestType' . $RandomID,
            Comment => 'Just something modified for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events           => [ 'AnEventForThisTest' . $RandomID ],
                Queue            => ['ADifferentQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
                NotificationType => ['UnitTestType'],
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
    {
        Name          => 'TestHTML ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'NotificationHTMLNameSuccess-UnitTestType2' . $RandomID,
            Comment => 'Just something for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events           => ['TicketQueueUpdate'],
                Queue            => ['SomeQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
                NotificationType => [ 'UnitTestType' . $RandomID ],
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
            Name    => 'NotificationHTML-UnitTestType2' . $RandomID,
            Comment => 'Just something modified for test-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Data    => {
                Events           => [ 'AnEventForThisTest' . $RandomID ],
                Queue            => ['ADifferentQueue-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ'],
                NotificationType => [ 'UnitTestType' . $RandomID ],
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

    # determine notification type
    my $NotificationType = '';

    if (
        !$Test->{Add}->{Data}->{NotificationType}
        || !$Test->{Add}->{Data}->{NotificationType}->[0]
        )
    {
        $NotificationType = 'Ticket';
    }
    else {
        $NotificationType = $Test->{Add}->{Data}->{NotificationType}->[0];
    }

    if ( !IsHashRefWithData( $NotificationIDs{$NotificationType} ) ) {
        $NotificationIDs{$NotificationType} = ();
    }

    # remember ID to verify it later
    $NotificationIDs{$NotificationType}->{$NotificationID} = $Test->{Add}->{Name};

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

        my $SuccessUpdate = $NotificationEventObject->NotificationUpdate(
            %{ $Test->{Update} },
            PossibleEmptyMessage => 1,
            UserID               => $UserID,
        );

        $Self->True(
            $SuccessUpdate,
            "$Test->{Name} - NotificatioUpdate() with PossibleEmptyMessage parameter - True",
        );

        my %Notification = $NotificationEventObject->NotificationGet(
            ID => $NotificationID,
        );

        $Self->True(
            IsHashRefWithData( $Notification{Message} ),
            "$Test->{Name} - NotificatioUpdate() Message is not empty",
        );

        delete $Test->{Update}->{Message};
        $SuccessUpdate = $NotificationEventObject->NotificationUpdate(
            %{ $Test->{Update} },
            PossibleEmptyMessage => 1,
            UserID               => $UserID,
        );

        $Self->True(
            $SuccessUpdate,
            "$Test->{Name} - NotificatioUpdate() with PossibleEmptyMessage parameter without Message - True",
        );
    }

    # remember ID to verify it later
    $NotificationIDs{$NotificationType}->{$NotificationID} = $Test->{Update}->{Name};

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
my @AddedNotifications;

for my $NotificationType ( sort keys %NotificationIDs ) {
    push @AddedNotifications, sort keys %{ $NotificationIDs{$NotificationType} };
}

# verify IDs
$Self->Is(
    1,
    IsArrayRefWithData( \@AddedNotifications ),
    "Added Notification IDs- Right structure",
);

my @IDs = sort $NotificationEventObject->NotificationEventCheck( Event => 'AnEventForThisTest' . $RandomID );

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

# check notifications with type ticket
my %NotificationList = $NotificationEventObject->NotificationList( Type => 'Ticket' );
for my $NotificationID ( sort keys %NotificationIDs ) {
    $Self->Is(
        $NotificationIDs{Ticket}->{$NotificationID},
        $NotificationList{$NotificationID},
        "NotificationList() from DB with type 'Ticket' found NotificationEvent $NotificationID",
    );
}

# clear cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'NotificationEvent',
);

# check notifications with type ticket in details mode
%NotificationList = $NotificationEventObject->NotificationList(
    Type    => 'Ticket',
    Details => 1,
);

for my $NotificationID ( sort keys %NotificationIDs ) {
    $Self->Is(
        $NotificationIDs{Ticket}->{$NotificationID},
        $NotificationList{$NotificationID}->{Name},
        "NotificationList() from DB with type 'Ticket' in details mode found NotificationEvent $NotificationID",
    );
}

# check notifications with type ticket in details mode
%NotificationList = $NotificationEventObject->NotificationList(
    Type    => 'Ticket',
    Details => 1,
    All     => 1,
);

for my $NotificationID ( sort keys %NotificationIDs ) {

    my $NotificationType = '';

    if (
        !$NotificationList{$NotificationID}->{Data}->{NotificationType}
        || !$NotificationList{$NotificationID}->{Data}->{NotificationType}->[0]
        )
    {
        $NotificationType = 'Ticket';
    }
    else {
        $NotificationType = $NotificationList{$NotificationID}->{Data}->{NotificationType}->[0];
    }

    $Self->Is(
        $NotificationIDs{$NotificationType}->{$NotificationID},
        $NotificationList{$NotificationID}->{Name},
        "NotificationList() from DB with type 'Ticket' in details mode and all types found NotificationEvent $NotificationID",
    );
}

# clear cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'NotificationEvent',
);

# check notifications with type ticket in details mode
%NotificationList = $NotificationEventObject->NotificationList(
    Type    => 'Ticket',
    Details => 1,
);

for my $NotificationID ( sort keys %NotificationIDs ) {
    $Self->Is(
        $NotificationIDs{Ticket}->{$NotificationID},
        $NotificationList{$NotificationID}->{Name},
        "NotificationList() from DB with type 'Ticket' in details mode found NotificationEvent $NotificationID",
    );
}

# list check from DB without type and deletion
for my $NotificationType ( sort keys %NotificationIDs ) {

    %NotificationList = $NotificationEventObject->NotificationList( Type => $NotificationType );

    for my $NotificationID ( sort keys %{ $NotificationIDs{$NotificationType} } ) {

        $Self->Is(
            $NotificationIDs{$NotificationType}->{$NotificationID},
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
}

# list check deleted entries
for my $NotificationType ( sort keys %NotificationIDs ) {

    %NotificationList = $NotificationEventObject->NotificationList( Type => $NotificationType );

    for my $NotificationID ( sort keys %{ $NotificationIDs{$NotificationType} } ) {
        $Self->False(
            $NotificationList{$NotificationID},
            "NotificationList() deleted entry - $NotificationID",
        );
    }
}

my $NotificationYAML = <<'YAML';
---
- ChangeBy: '1'
  ChangeTime: 2017-05-08 11:28:35
  Comment: ''
  CreateBy: '1'
  CreateTime: 2017-05-08 11:28:35
  Data:
    AgentEnabledByDefault:
    - Email
    Events:
    - NotificationNewTicket
    Recipients:
    - AgentMyQueues
    - AgentMyServices
    SendOnOutOfOffice:
    - '1'
    Transports:
    - Email
    VisibleForAgent:
    - '1'
    VisibleForAgentTooltip:
    - You will receive a notification each time a new ticket is created in one of
      your "My Queues" or "My Services".
  ID: '1'
  Message:
    de:
      Body: 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,


        das Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>]
        wurde in der Queue <OTRS_TICKET_Queue> erstellt.


        <OTRS_CUSTOMER_REALNAME> schrieb:

        <OTRS_CUSTOMER_BODY[30]>


        <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


        -- <OTRS_CONFIG_NotificationSenderName>'
      ContentType: text/plain
      Subject: 'Ticket erstellt: <OTRS_TICKET_Title>'
    en:
      Body: 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,


        ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>]
        has been created in queue <OTRS_TICKET_Queue>.


        <OTRS_CUSTOMER_REALNAME> wrote:

        <OTRS_CUSTOMER_BODY[30]>


        <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


        -- <OTRS_CONFIG_NotificationSenderName>'
      ContentType: text/plain
      Subject: 'Ticket Created: <OTRS_TICKET_Title>'
    es_MX:
      Body: 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,


        el ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>]
        se ha creado en la fila <OTRS_TICKET_Queue>.


        <OTRS_CUSTOMER_REALNAME> escribió:

        <OTRS_CUSTOMER_BODY[30]>


        <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


        -- <OTRS_CONFIG_NotificationSenderName>'
      ContentType: text/plain
      Subject: 'Se ha creado un ticket: <OTRS_TICKET_Title>'
    hu:
      Body: 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!


        A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>]
        jegy létrejött a következő várólistában: <OTRS_TICKET_Queue>.


        <OTRS_CUSTOMER_REALNAME> ezt írta:

        <OTRS_CUSTOMER_BODY[30]>


        <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


        -- <OTRS_CONFIG_NotificationSenderName>'
      ContentType: text/plain
      Subject: 'Jegy létrehozva: <OTRS_TICKET_Title>'
    pt_BR:
      Body: 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,


        o ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>]
        foi criado na fila <OTRS_TICKET_Queue>.


        <OTRS_CUSTOMER_REALNAME> escreveu:

        <OTRS_CUSTOMER_BODY[30]>


        <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


        -- <OTRS_CONFIG_NotificationSenderName>'
      ContentType: text/plain
      Subject: 'Ticket criado: <OTRS_TICKET_Title>'
    zh_CN:
      Body: '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,


        票据工单 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>]
        已在等待队列 已在队列<OTRS_TICKET_Queue> 中被编制完成。中被创建完成


        <OTRS_CUSTOMER_REALNAME> 写道：

        <OTRS_CUSTOMER_BODY[30]>


        <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


        -- <OTRS_CONFIG_NotificationSenderName>'
      ContentType: text/plain
      Subject: 票据编制 工单已创建：<OTRS_TICKET_Title>
  Name: Ticket create notification
  ValidID: '1'
YAML

for my $Count ( 1 .. 5 ) {

    # at first find the notification id and delete the notification entry
    my %Notification = $NotificationEventObject->NotificationGet(
        Name => 'Ticket create notification',
    );

    my $Success = $NotificationEventObject->NotificationDelete(
        ID     => $Notification{ID},
        UserID => 1,
    );

    $Self->True(
        $Success,
        "ImportTest - Count $Count: Delete",
    );

    # import the notification for the first time
    my $NotificationImport = $NotificationEventObject->NotificationImport(
        Content                        => $NotificationYAML,
        OverwriteExistingNotifications => 1,
        UserID                         => 1,
    );

    $Self->True(
        $NotificationImport->{Success},
        "ImportTest - Count $Count: Import",
    );

    $Self->Is(
        $NotificationImport->{AddedNotifications},
        'Ticket create notification',
        "ImportTest - Count $Count: AddedNotifications",
    );

    $Self->Is(
        $NotificationImport->{NotificationErrors},
        '',
        "ImportTest - Count $Count: NotificationErrors",
    );

    $Self->Is(
        $NotificationImport->{UpdatedNotifications},
        '',
        "ImportTest - Count $Count: UpdatedNotifications",
    );

    # import the notification for the second time
    $NotificationImport = $NotificationEventObject->NotificationImport(
        Content                        => $NotificationYAML,
        OverwriteExistingNotifications => 1,
        UserID                         => 1,
    );

    $Self->True(
        $NotificationImport->{Success},
        "ImportTest - Count $Count: Import",
    );

    $Self->Is(
        $NotificationImport->{AddedNotifications},
        '',
        "ImportTest - Count $Count: AddedNotifications",
    );

    $Self->Is(
        $NotificationImport->{NotificationErrors},
        '',
        "ImportTest - Count $Count: NotificationErrors",
    );

    $Self->Is(
        $NotificationImport->{UpdatedNotifications},
        'Ticket create notification',
        "ImportTest - Count $Count: UpdatedNotifications",
    );
}

# cleanup cache is done by RestoreDatabase

1;
